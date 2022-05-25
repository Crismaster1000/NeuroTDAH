package {

	import flash.events.TimerEvent;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequestHeader;
	import flash.display.Sprite;
	import flash.net.SharedObject;
	import flash.events.HTTPStatusEvent;
	import flash.utils.setTimeout;


	public class Scores {

		// variables para request de login
		private var emailRequest: URLRequest;
		private var uploadRequest: URLRequest;
		private var variables: URLVariables;
		private var loader: URLLoader;
		var contentTypeHeader: URLRequestHeader;

		public var memoria_juegos: SharedObject = SharedObject.getLocal("juegos", "/");
		public var status: int;

		public function Scores() {}


		public function cargar_scores() {

			//var jsonString = JSON.stringify(userjson);

			//var jsonString:String = JSON.stringify(myDataObject);

			uploadRequest = new URLRequest();
			uploadRequest.url = "http://tdah-campoverde-erazo.herokuapp.com/api/scores/lowers";
			//uploadRequest.url = "http://127.0.0.1:5000/";
			//uploadRequest.data = jsonString;
			//contentTypeHeader = new URLRequestHeader("Content-Type", "application/json");
			var token = memoria_juegos.data.user_token;
			contentTypeHeader = new URLRequestHeader("Authorization", "Bearer " + token);
			uploadRequest.requestHeaders.push(contentTypeHeader);
			uploadRequest.method = URLRequestMethod.GET;
			uploadRequest.contentType = "application/json";

			loader = new URLLoader();
			loader.dataFormat = URLLoaderDataFormat.TEXT;
			loader.addEventListener(Event.COMPLETE, onResponse);
			loader.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler, false, 0, true);
			loader.addEventListener(HTTPStatusEvent.HTTP_STATUS, httpStatusHandler);
			try {
				loader.load(uploadRequest);
			} catch (e: Error) {
				trace(e);
			}

		}


		private function onResponse(e: Event): void {

			var prujson: Object = e.target.data;
			//trace("COMPLETE JSON: " + prujson);
			var data: Object = JSON.parse(e.target.data);
			//trace("SCORES: "+data);
			if (status == 200) {
				//guardamos el token de usuario
				//memoria_juegos.data.user_token = data.id_token;
				//memoria_juegos.flush();
				//MovieClip(root).gotoAndStop(1, "Menu");
				memoria_juegos.data.usuario_scores = data;
				memoria_juegos.flush();
				trace("SCORES RECOPILADOS");
			} else {
				trace("usuario denegado")
				//alert_txt.text = "Usuario no encontradp";
			}
			//token.data.resul = prujson.toString();
			//res.flush();


		}

		function httpStatusHandler(event: HTTPStatusEvent): void {
			trace("httpStatusHandler: " + event);
			trace("status: " + event.status);
			status = event.status;
		}

		function ioErrorHandler(e: IOErrorEvent): void {
			//trace("ORNLoader:ioErrorHandler: " + e);
			//dispatchEvent(e);
			//alert_txt.text = "Usuario no encontrado";
			trace("error");
			trace(e);
		}


		public function cargar_leves() {

			//var jsonString = JSON.stringify(userjson);

			//var jsonString:String = JSON.stringify(myDataObject);

			uploadRequest = new URLRequest();
			uploadRequest.url = "http://tdah-campoverde-erazo.herokuapp.com/api/scores/last-levels";
			//uploadRequest.url = "http://127.0.0.1:5000/";
			//uploadRequest.data = jsonString;
			//contentTypeHeader = new URLRequestHeader("Content-Type", "application/json");
			var token = memoria_juegos.data.user_token;
			contentTypeHeader = new URLRequestHeader("Authorization", "Bearer " + token);
			uploadRequest.requestHeaders.push(contentTypeHeader);
			uploadRequest.method = URLRequestMethod.GET;
			uploadRequest.contentType = "application/json";

			loader = new URLLoader();
			loader.dataFormat = URLLoaderDataFormat.TEXT;
			loader.addEventListener(Event.COMPLETE, onResponse1);
			loader.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler, false, 0, true);
			loader.addEventListener(HTTPStatusEvent.HTTP_STATUS, httpStatusHandler);
			try {
				loader.load(uploadRequest);
			} catch (e: Error) {
				trace(e);
			}

		}

		private function onResponse1(e: Event): void {

			var prujson: Object = e.target.data;
			//trace("COMPLETE JSON: " + prujson);
			var data: Object = JSON.parse(e.target.data);
			//trace("Nombre : " + data);
			if (status == 200) {
				//guardamos el token de usuario
				//memoria_juegos.data.user_token = data.id_token;
				//memoria_juegos.flush();
				//MovieClip(root).gotoAndStop(1, "Menu");
				memoria_juegos.data.usuario_levels = data;
				memoria_juegos.flush();
				setTimeout(asignar_niveles,1000);
				trace("NIVELES RECOPILADOS");
			} else {
				trace("usuario denegado")
				//alert_txt.text = "Usuario no encontradp";
			}
			//token.data.resul = prujson.toString();
			//res.flush();


		}

		public function asignar_niveles() {

			var last_simon = memoria_juegos.data.usuario_levels[0].lastLevel;
			var last_palabras = memoria_juegos.data.usuario_levels[1].lastLevel;
			var last_cuadros = memoria_juegos.data.usuario_levels[2].lastLevel;
			trace("NIVELES - SIMON : " + last_simon + " - PALABRAS : " + last_palabras + " - CUADROS : " + last_cuadros);

			if(last_simon == 0){
				trace("cero");
				memoria_juegos.data.simon_start = true;
				memoria_juegos.flush();
				trace(memoria_juegos.data.simon_start);
			}else{
				trace("no cero");
				memoria_juegos.data.last_simon = last_simon;
				memoria_juegos.data.simon_start = false;
				memoria_juegos.flush();
				trace(memoria_juegos.data.last_simon);
			}
			
			if(last_palabras == 0){
				trace("cero");
				memoria_juegos.data.palabras_start = true;
				memoria_juegos.flush();
				trace(memoria_juegos.data.palabras_start);
			}else{
				trace("no cero");
				memoria_juegos.data.last_palabras = last_palabras;
				memoria_juegos.data.palabras_start = false;
				memoria_juegos.flush();
				trace(memoria_juegos.data.last_palabras);
			}
			
			if(last_cuadros == 0){
				trace("cero");
				memoria_juegos.data.cuadros_start = true;
				memoria_juegos.flush();
				trace(memoria_juegos.data.cuadros_start);
			}else{
				trace("no cero");
				memoria_juegos.data.last_cuadros = last_cuadros;
				memoria_juegos.data.cuadros_start = false;
				memoria_juegos.flush();
				trace(memoria_juegos.data.last_cuadros);
			}
			
			
			
			
		}



	}
}