package {

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


	public class Post extends MovieClip {

		private var uploadRequest: URLRequest;
		private var variables: URLVariables;
		private var loader: URLLoader;
		var contentTypeHeader: URLRequestHeader;
		var contentTypeHeader1: URLRequestHeader;

		public var memoria_juegos: SharedObject = SharedObject.getLocal("juegos", "/");

		var userjson: Object;
		var status: int;
		var jsonString;


		public function Post() {
			// constructor code
		}

		public function post_data(datos: Array) {
			// armamos el json con los datos del registro de la persona
			userjson = {
				"time": datos[0],
				"level": datos[1],
				"creation_date": datos[2].toString(),
				"patientId": datos[3],
				"gameId": datos[4]
			}
			jsonString = JSON.stringify(userjson);
			trace("JSON A ENVIAR : ", jsonString)

			uploadRequest = new URLRequest();
			//uploadRequest.url = "http://127.0.0.1:5000/";
			uploadRequest.url = "https://tdah-campoverde-erazo.herokuapp.com/api/scores/";
			uploadRequest.data = jsonString;

      var token = memoria_juegos.data.user_token;
			contentTypeHeader = new URLRequestHeader("Authorization", "Bearer "+token);
			uploadRequest.requestHeaders.push(contentTypeHeader);
			uploadRequest.method = URLRequestMethod.POST;
			uploadRequest.contentType = "application/json";

			loader = new URLLoader();
			loader.dataFormat = URLLoaderDataFormat.TEXT;
			loader.addEventListener(Event.COMPLETE, onResponse);
			loader.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler, false, 0, true);
			loader.addEventListener(HTTPStatusEvent.HTTP_STATUS, httpStatusHandler);

      /*
			contentTypeHeader = new URLRequestHeader("Content-Type", "application/json");
			uploadRequest.requestHeaders.push(contentTypeHeader);
			uploadRequest.method = URLRequestMethod.POST;

			loader = new URLLoader();
			loader.dataFormat = URLLoaderDataFormat.TEXT;
			loader.addEventListener(Event.COMPLETE, onResponse);
			loader.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler, false, 0, true);
			loader.addEventListener(HTTPStatusEvent.HTTP_STATUS, httpStatusHandler);
      */

			try {
				loader.load(uploadRequest);
				trace("ENVIANDO...")
			} catch (e: Error) {
				trace(e);
			}

		}


		private function onResponse(e: Event): void {

			var prujson: Object = e.target.data;
			trace(prujson);
			var data: Object = JSON.parse(e.target.data);
			//trace(data.id_token);
			if (status == 201) {
				trace("DATOS ENVIADOS");
				//MovieClip(root).gotoAndStop(1, "Menu");
			} else {
				trace("DATOS NO ENVIADOS");

			}
			//token.data.resul = prujson.toString();
			//res.flush();


		}

		function httpStatusHandler(event: HTTPStatusEvent): void {
			trace("httpStatusHandler: " + event);
			trace("status: " + event.status);
			status = event.status
		}


		function ioErrorHandler(e: IOErrorEvent): void {
			//trace("ORNLoader:ioErrorHandler: " + e);
			//dispatchEvent(e);
			trace(e)
			trace("error")
		}

	}


}