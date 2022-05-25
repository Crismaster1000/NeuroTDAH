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
	import flash.utils.setTimeout;


	public class LoginM extends MovieClip {

		// memoria del juego
		public var memoria_juegos: SharedObject = SharedObject.getLocal("juegos", "/");

		// variables para request de login
		private var emailRequest: URLRequest;
		private var uploadRequest: URLRequest;
		private var variables: URLVariables;
		private var loader: URLLoader;
		var contentTypeHeader: URLRequestHeader;

		var user: String;
		//var token: SharedObject = SharedObject.getLocal("token", "/");
		var userjson: Object;
		var status: int;
		var userr: Usuario;
		var scores_data: Scores;

		var loader_mc: Loading;

		public function LoginM() {
			// constructor code

		}

		function enviar_post() {

			//public var userr:Usuario = new Usuario();

			if (usuario.text != null && usuario.text != "") {
				user = usuario.text;
				userjson = {
					"username": user,
					"password": user
				}
				var jsonString = JSON.stringify(userjson);
				trace("JSON A ENVIAR : ", jsonString);

				//var jsonString:String = JSON.stringify(myDataObject);

				uploadRequest = new URLRequest();
				uploadRequest.url = "https://tdah-campoverde-erazo.herokuapp.com/api/authenticate";
				uploadRequest.data = jsonString;
				contentTypeHeader = new URLRequestHeader("Content-Type", "application/json");
				uploadRequest.requestHeaders.push(contentTypeHeader);
				//uploadRequest.contentType = "application/json";
				uploadRequest.method = URLRequestMethod.POST;

				loader = new URLLoader();
				loader.dataFormat = URLLoaderDataFormat.TEXT;
				loader.addEventListener(Event.COMPLETE, onResponse);
				loader.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler, false, 0, true);
				loader.addEventListener(HTTPStatusEvent.HTTP_STATUS, httpStatusHandler);
				try {
					loader.load(uploadRequest);
					loader_mc = new Loading();
					loader_mc.x = 0;
					loader_mc.y = 0;
					addChild(loader_mc);
				} catch (e: Error) {
					trace(e);
				}
			} else {
				alert_txt.text = "Escriba un nombre";
			}
		}

		private function onResponse(e: Event): void {

			var prujson: Object = e.target.data;
			trace("COMPLETE JSON: " + prujson);
			var data: Object = JSON.parse(e.target.data);
			trace("TOKEN : " + data.id_token);
			if (status == 200) {
				//guardamos el token de usuario
				memoria_juegos.data.user_token = data.id_token;
				memoria_juegos.flush();
				// cargamos los datos del usuario
				userr = new Usuario();
				userr.cargar_datos();
				// cargamos los niveles y puntajes
				scores_data = new Scores();
				scores_data.cargar_scores();
				scores_data.cargar_leves();
				setTimeout(loading_rm, 2000);
			} else {
				trace("usuario denegado")
				alert_txt.text = "Usuario no encontrado";
			}
			//token.data.resul = prujson.toString();
			//res.flush();


		}


		public function loading_rm() {
			removeChild(loader_mc);
			MovieClip(root).gotoAndPlay(1, "Menu");
		}


		private function httpStatusHandler(event: HTTPStatusEvent): void {
			trace("httpStatusHandler: " + event);
			trace("status: " + event.status);
			status = event.status
		}

		private function ioErrorHandler(e: IOErrorEvent): void {
			//trace("ORNLoader:ioErrorHandler: " + e);
			//dispatchEvent(e);
			removeChild(loader_mc);
			alert_txt.text = "Usuario no encontrado";
			trace("error")
			trace(e);
		}

	}

}