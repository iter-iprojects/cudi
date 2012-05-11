
$(function(){
/*
   $("#proyecto_resources").multiselect();
   $("#futureproyecto_resources").multiselect();
   $("#futureproyectosactions_resources").multiselect();
*/	

});


/*


function showCourseLink(id){
	var items = [];
	
	$('#userplace').find('input[type=checkbox]').each(function(){
	var checked = $(this).attr('checked');
	if(checked){ 
		items.push('id: '+ $(this).attr('value'))
	}
	});


if (items.length > 0) pushIn(items);
} 

function  pushIn(items){
	var s = new String();
	$.each(items, function(k,v){	
		s += '"' +  v + '"' 
	if (k < items.length) s += ','	
	});
try{
  $("#futureproyecto_resources").val('');
$("#futureproyecto_resources").attr("value", "{"+ s.substring(0, s.length - 1)  +"}");

}catch(err){
  //   error ocurred...
}finally{
       $("#futureproyecto_resources").val('');
$("#futureproyecto_resources").attr("value", "{"+ s.substring(0, s.length - 1)  +"}");

}


try{
  $("#proyecto_resources").val('');
$("#proyecto_resources").attr("value", "{"+ s.substring(0, s.length - 1)  +"}");

}catch(err){
  //   error ocurred...
}finally{
       $("#futureproyecto_resources").val('');
$("#futureproyecto_resources").attr("value", "{"+ s.substring(0, s.length - 1)  +"}");

}



//$("#futureproyecto_resources").val('');
//$("#futureproyecto_resources").attr("value", "{"+ s.substring(0, s.length - 1)  +"}");
}


	$(document).ready(function() {

				$('input:checkbox:not([safari])').checkbox();
				$('input[safari]:checkbox').checkbox({cls:'jquery-safari-checkbox'});
				$('input:radio').checkbox();
			});

			displayForm = function (elementId)
			{
				var content = [];
				$('#' + elementId + ' input').each(function(){
					var el = $(this);

					if ( (el.attr('type').toLowerCase() == 'radio'))
					{
						if ( this.checked )
							content.push([
								'"', el.attr('name'), '": ',
								'value="', ( this.value ), '"',
								( this.disabled ? ', disabled' : '' )
							].join(''));
					}
					else
						content.push([
							'"', el.attr('name'), '": ',
							( this.checked ? 'checked' : 'not checked' ), 
							( this.disabled ? ', disabled' : '' )
						].join(''));
				});
				alert(content.join('\n'));
			}
			
			changeStyle = function(skin)
			{
				jQuery('#new_futureproyecto :checkbox').checkbox((skin ? {cls: skin} : {}));
			}
*/
