class RepoMonitor {

  def iterateLatest(db, collection, processing_closure) {

    // Lookup a monitor record for the identified collection
    // Create one if it doesn't exist.
    def monitor_info = db.monitors.findOne(coll:collection);
    if ( monitor_info == null ) {
      println("Create new monitor info for ${collection}");
      monitor_info = [:]
      monitor_info.coll = collection
      monitor_info.maxts = 0;
      monitor_info.maxid = ''
    }
    else {
      println("Using existing monitor info");
    }


    def next=true;  
    def batch_size = 10;
    def iteration_count = 0;
    // set max_iterations to -1 for unlimited
    def max_iterations = 2;
    def highest_last_modified = 0;
    def highest_identifier = "";

    while( ( ( max_iterations == -1 ) || ( iteration_count < max_iterations ) ) && next) {
      next=false;
      println("${next} Finding all entries from ${collection} where lastModified > ${monitor_info.maxts} and id > \"${monitor_info.maxid}\"");
      def batch = db."${collection}".find( [ lastModified : [ $gt : monitor_info.maxts ], _id : [ $gt : monitor_info.maxid ]  ] ).limit(batch_size+1).sort(lastModified:1,_id:1);
      int counter = 0;

      batch.each { r ->
        if ( counter < batch_size ) {
          counter++;
          processing_closure.call(r)
          highest_last_modified = r.lastModified;
          highest_identifier = r._id;
          println("* ${iteration_count}/${counter}/${batch_size} : ${highest_last_modified}, ${highest_identifier}");
        }
        else {
          // We've reached record batch_size+1, which means there is at least 1 more record to process. We should loop,
          // assuming we haven't passed max_iterations
          println("Counter has reached ${batch_size+1}, reset maxid");
          next=true
        }
      }
      println("Saving monitor info ${monitor_info}");
      monitor_info.maxts = highest_last_modified;
      monitor_info.maxid = highest_identifier
      iteration_count++;
      db.monitors.save(monitor_info);
    }
  }
}
