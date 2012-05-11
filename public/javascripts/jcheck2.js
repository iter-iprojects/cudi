/*
jQuery.fn.checkboxPersonalizado = function(opciones) {

	//opciones de configuración por defecto
	var conf = {
		activo: false,
		colorTextos: {
			activo: "#f00",
			pasivo: "#ff0"
		},
		textos: {
			activo: "",
			pasivo: ""
		},
		imagen: {
			activo: 'img/chekYes.png',
			pasivo: 'img/checkNo.png'
		},
		cssElemento: {
			padding: "",
			display: "block",
			margin: "2px",
			border: "",
			height: "25px",
			width: "25px",	
			cursor: "pointer"
		},
		cssAdicional: {
			
		},
		nameCheck: "ncheck"
	};
	//Las extiendo con las opciones recibidas al invocar el plugin
	jQuery.extend(conf, opciones);
	
	this.each(function(){
		var miCheck = $(this);
		
		var activo = conf.activo
		var elementoCheck = $('<input type="checkbox" style="display: none;" />');
		if(conf.nameCheck==""){
			elementoCheck.attr("name", miCheck.text());
		}else{
			elementoCheck.attr("name", conf.nameCheck);
		}
		miCheck.before(elementoCheck);
		miCheck.css(conf.cssElemento);
		miCheck.css(conf.cssAdicional);
		
		if (activo){
			activar();
		}else{	
			desactivar();
		}
		miCheck.click(function(e){
			if(activo){
			
				var act=$(this).attr("name");
				desactivar($(this).attr("name"));
				$('#pcontainother  p[name='+act+']').attr("marcado","y");
                                $('#pcontain  p[name='+act+']').attr("marcado","y");
				//alert('desactivo osea marco n:'+$(this).attr("name"));
			}else{	
				//alert('activo marco y :'+$(this).attr("name"));
				activar($(this).attr("name"));
				$('#pcontainother  p[name='+act+']').attr("marcado","n");
                                $('#pcontain  p[name='+act+']').attr("marcado","n");
			}
			//getRangeDatePrices();
			//setField();
			//setFields();
			activo = !activo;
		});
		
		function desactivar(id){
		 id = (typeof id == 'undefined') ? da='nohayid': da=id ;
			miCheck.css({
				background: "transparent url(" + conf.imagen.pasivo + ") no-repeat 3px",
				color: conf.colorTextos.pasivo
			});
			if (conf.textos.pasivo!=""){
				miCheck.text(conf.textos.pasivo)
			}
			elementoCheck.removeAttr("checked");
			elementoCheck.attr("name", da);
		
		};									
		
		function activar(id){

			id = (typeof id == 'undefined') ? da='nohayid': da=id ;

			miCheck.css({
				background: "transparent url(" + conf.imagen.activo + ") no-repeat 3px",
				color: conf.colorTextos.activo
			});
			//$(this).attr("style","float:left");
			if (conf.textos.activo!=""){
				miCheck.text(conf.textos.activo)
			}
			elementoCheck.attr("checked","1");
			elementoCheck.attr("name", da);

		};	
	});

	
	return this;
};	

$(document).ready(function(){
	$(".ch").checkboxPersonalizado();
	$("#otro").checkboxPersonalizado({
		activo: false,
		colorTextos: {
			activo: "#f80",
			pasivo: "#98a"
		},
		imagen: {
			activo: 'weather_cloudy.png',
			pasivo: 'weather_rain.png'
		},
		textos: {
			activo: 'Buen tiempo :)',
			pasivo: 'Buena cara ;)'
		},
		cssAdicional: {
			border: "1px solid #dd5",
			width: "100px"
		},
		nameCheck: "buen_tiempo"
	});
})
*/
