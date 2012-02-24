<!doctype html>
<html>
  <head>
    <meta name="layout" content="main"/>
    <title>Search front page</title>
    <g:javascript>
    $(document).ready(function()
    {   
        $('form').submit(function() 
        {
            $('.inline-spinner').show();
            return true;
        });
        
        $('.adv-toggle').click(function(evt)
        {
            evt.preventDefault();
            $('.adv').toggle(); 
            $(this).text($(this).text() == 'Show advanced search' ? 'Hide advanced search' : 'Show advanced search');
            $(this).toggleClass('active');
        });
        
        $('select[name=order]').change(function()
        {
            if($('select[name=order] option:selected').val() == 'distance')
            {
                $('label[for=location]').show();
                $('input[name=location]').show();
            }
            else
            {
                $('label[for=location]').hide();
                $('input[name=location]').hide();
            }
        });
    });
    
    function updateCount(data)
    {
        if(data.hits > 100)
        {
            $('.searchCounter li:first-child').removeClass('positive').addClass('negative');
        }
        else if(data.hits > 0)
        {
            $('.searchCounter li:first-child').removeClass('negative').addClass('positive');
        }
        else
        {
            $('.searchCounter li:first-child').removeClass('negative').removeClass('positive')
        }        
        
        $('.searchCounter li:first-child').text(data.hits);
    }
    
    function failCount(errorThrown)
    {
        $('.searchCounter li:first-child').text('0').removeClass('positive').removeClass('negative');
    }
    
    function getQString()
    {
        return 'q=' + $('input[name=q]').val() + '&studyMode=' + $('select[name=studyMode] option:selected').val() + '&qualification=' + $('select[name=qualification] option:selected').val();
    }
        
    </g:javascript>
  </head>
  <body>
    <h1>Discover course information...</h1>
    <g:form action="index" method="get">
        <div class="searchCounter default">
        <ul>
	        <li>
	            0
	        </li>
	        <li>
	            Matches
	        </li>
	    </ul>
	    </div>
    	<ul>
    		<li>
    		  <label for="q">Keyword(s)</label>
    		  <input id="q" name="q" type="text" class="large" value="${params.q}" onchange="${remoteFunction(action: 'count', params: 'getQString()', onSuccess: 'updateCount(data)', onFailure:'failCount(errorThrown)', method: 'GET' )}" onkeyup="${remoteFunction(action: 'count', params: 'getQString()', onSuccess: 'updateCount(data)', onFailure:'failCount(errorThrown)', method: 'GET' )}"/>
    		  <div class="inline-spinner" style="display:none;">Searching</div>        
    		</li>
    		<li class="adv" style="display:none">
              <label for="qualification">Qualification</label>
              <g:select name="qualification" onchange="${remoteFunction(action: 'count', params: 'getQString()', onSuccess: 'updateCount(data)', onFailure:'failCount(errorThrown)', method: 'GET' )}" from="${search_config.qualification}" optionKey="value" optionValue="key" value="All" class="small"/>       
            </li>
    		<li class="adv" style="display:none">
              <label for="studyMode">Attendance</label>
              <g:select name="studyMode" onchange="${remoteFunction(action: 'count', params: 'getQString()', onSuccess: 'updateCount(data)', onFailure:'failCount(errorThrown)', method: 'GET' )}" from="${search_config.studyMode}" optionKey="value" optionValue="key" value="Any" class="small"/>       
            </li>
    		<li class="adv" style="display:none">
              <label for="order">Order by</label>
              <g:select name="order" from="${search_config.order}" optionKey="value" optionValue="key" value="default" class="small"/>       
              <br/>
              <label for="location" style="display:none">My location is</label>
              <input id="location" style="display:none" name="location" type="text" class="large">  
            </li>
            <li class="adv" style="display:none">
              <label for="format">Display as</label>
              <g:select name="format" from="${['html','xml','json']}" value="html" class="small"/>    
            </li>
            <li>
              <label></label>
              <g:link href="#" class="adv-toggle">Show advanced search</g:link>  
            </li>
     		<li><input type="submit" class="button-link button-link-positive" value="Search"/></li>
    	</ul>
    </g:form>
  </body>
</html>
