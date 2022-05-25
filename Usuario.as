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


	public class Usuario {

		public var nombre: String;
		public var apellido: String;
		public var edad: int;
		public var descripcion: String;

		// variables para request de login
		private var emailRequest: URLRequest;
		private var uploadRequest: URLRequest;
		private var variables: URLVariables;
		private var loader: URLLoader;
		var contentTypeHeader: URLRequestHeader;

		public var memoria_juegos: SharedObject = SharedObject.getLocal("juegos", "/");
		public var status:int;

		/*public function Usuario(nombre: String, apellido: String, edad: int, descripcion: String) {
			// constructor code
			this.nombre = nombre;
			this.apellido = apellido;
			this.edad = edad;
			this.descripcion = descripcion;
		}*/
		
		public function Usuario(){
			
		}

		public function show() {
			trace("Nombre : " + nombre);
			trace("Apellido : " + apellido);
			trace("Edad : " + edad + "\n");
			trace("Desc : " + descripcion);
		}

		public function cargar_datos() {

			//var jsonString = JSON.stringify(userjson);

			//var jsonString:String = JSON.stringify(myDataObject);

			uploadRequest = new URLRequest();
			uploadRequest.url = "http://tdah-campoverde-erazo.herokuapp.com/api/patient-data";
			//uploadRequest.url = "http://127.0.0.1:5000/";
			//uploadRequest.data = jsonString;
			//contentTypeHeader = new URLRequestHeader("Content-Type", "application/json");
			var token = memoria_juegos.data.user_token;
			contentTypeHeader = new URLRequestHeader("Authorization", "Bearer "+token);
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
			trace("COMPLETE JSON: " + prujson);
			var data: Object = JSON.parse(e.target.data);
			//trace("Nombre : " + data);
			if (status == 200) {
				//guardamos el token de usuario
				//memoria_juegos.data.user_token = data.id_token;
				//memoria_juegos.flush();
				//MovieClip(root).gotoAndStop(1, "Menu");
				memoria_juegos.data.usuario = data;
				memoria_juegos.flush();
				trace("INFORMACION RECOPILADA");
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



	}

}