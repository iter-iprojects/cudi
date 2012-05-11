   
    // Set URL of your WebSocketMain.swf here:
    WEB_SOCKET_SWF_LOCATION = "WebSocketMain.swf";
    // Set this to dump debug message from Flash to console.log:
    WEB_SOCKET_DEBUG = true;
    
    // Everything below is the same as using standard WebSocket.
    
    var ws;
    
    function init() {

      // Connect to Web Socket.
      // Change host/port here to your own Web Socket server.
      ws = new WebSocket("ws://192.168.21.69:8085/");

      // Set event handlers.
      ws.onopen = function() {
        output("onopen");
      };
      ws.onmessage = function(e) {
        // e.data contains received string.
        output("onmessage: " + e.data);
      };
      ws.onclose = function() {
        output("onclose");
      };
      ws.onerror = function() {
        output("onerror");
      };
      usersonline() 
    }
    
    
    function usersonline() {
    	
    	// set interval
    	var tid = setInterval(mycode, 30000);
    	function mycode() {
    		//aqui va a buscar que usuarios están online en este momento 
    	  // do some stuff...
    	  // no need to recall the function (it's an interval, it'll loop forever)
    		   var i='loqueplaz';
    		   var jqxhr = $.post("users/usersonline","id="+i ,  function(d) {
    			      //alert("success" + d);
    			    })
    			    .success(function() { //alert("second success");
    			     })
    			    .error(function() { //alert("error");
    			     })
    			    .complete(function() { //alert("complete");

    		         
    		            //$("#statusadvice").attr("style", "display:none");  
    			     });

    		    // perform other work here ...

    		    // Set another completion function for the request above
    		    jqxhr.complete(function(){ //alert("second complete");

    		    	 	//alert('valor d' + d);
    		    });	
    		
    		
    		
    		
    		
    		
    		
    		
    	}
    	function abortTimer() { // to be called when you want to stop the timer
    	  clearInterval(tid);
    	}

    	


    	    }    
    
    
    
    function onSubmit() {
      var input = document.getElementById("input");
      // You can send message to the Web Socket using ws.send.
      //le añado un identificadorf
      var idu = document.getElementById("idu");
      ws.send(idu.value + input.value);
      output("send: " + input.value);
      input.value = "";
      input.focus();
    }
    
    function onCloseClick() {
      ws.close();
    }
    
    function output(str) {
      var log = document.getElementById("log");
      var escaped = str.replace(/&/, "&amp;").replace(/</, "&lt;").
        replace(/>/, "&gt;").replace(/"/, "&quot;"); // "
      $('#log').before(escaped + "<br>" + log.innerHTML);
      
      //log.innerHTML = escaped + "<br>" + log.innerHTML;
      
      
    }

