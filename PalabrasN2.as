package {

	import flash.display.MovieClip;
	import flash.geom.Point;
	import flash.events.MouseEvent;
	import flash.events.Event;
	import flash.net.SharedObject;
	import flash.globalization.DateTimeFormatter;
	import flash.utils.setTimeout;


	public class PalabrasN2 extends MovieClip {

		var silabas_invertidas = ["ESCUDO", "ARMAS", "ALTO", "OSCAR", "ESPEJO", "ISLA", "ALMA", "ENSAYO", "ESFERO", "ARMARIO", "ENCHUFE", "INDIO", "INCENDIO", "ALBAÑIL", "ANGEL", "LIBRO", "ESCUELA", "FRUTA", "GLOBO", "FIESTA"];

		//var numBalls: uint = 5;
		public var arrayBalls: Array = new Array();
		public var arrayVels: Array = new Array();


		public var initialVelX: Number = 1;
		public var initialVelY: Number = 1;

		var palabra: String;
		var palabra_array: Array;

		var nump = 0;

		var memoria_juegos: SharedObject = SharedObject.getLocal("juegos", "/");

		var timer:TimerClass = new TimerClass();
		var post_data:Post;
		var manito:bienmc = new bienmc();

		public function PalabrasN2() {

			again.addEventListener(MouseEvent.CLICK, repetir);
			//memoria_juegos.clear();
			// iniciamos memoria
			if (memoria_juegos.data.num_fase == null) {
				memoria_juegos.data.num_fase = 0;
				memoria_juegos.flush();
			}
			if (memoria_juegos.data.num_fase > 0) {
				memoria_juegos.data.num_fase = 0;
				memoria_juegos.flush();
			}
			timer.startClock();
			inicio();
		}

		public function inicio() {
			if (contains(manito)) removeChild(manito);
			// generamos un numero random
			var ran = randomRange(0, silabas_invertidas.length - 1);
			// asignamos una palabra
			palabra = silabas_invertidas[ran];
			// mostramos la palabra
			palabra_inicial.text = palabra;
			silabas_invertidas.removeAt(ran);
			// dividimos la palabra en arreglos
			palabra_array = new Array();
			palabra_array = palabra.split("");
			//nump = palabra_array.length;
			trace("LA PALABRA ES : " + palabra_array);
			// generamos las pelotas con cada letra
			addballs(palabra_array);
		}

		public function verificar(palabra_a: String, palabra_b: String) {
			/*if (palabra_a == palabra_b) {
				trace("PASS");
				MovieClip(this.root).gotoAndPlay(1, "ANIMACION 1");
			}*/
			if (nump == palabra_array.length) {
				if (palabra_a == palabra_b) {
					trace("PASO");
					// recuperamos la fase en que esta
					var fase = memoria_juegos.data.num_fase;
					memoria_juegos.data.num_fase = fase + 1;
					memoria_juegos.flush();
					fase = memoria_juegos.data.num_fase;
					trace("FASE : " + fase);
					//MovieClip(this.root).gotoAndPlay(1, "ANIMACION 1");
					if (fase < 7) {
						// borramos los listeners
						for (var i = 0; i < arrayBalls.length; i++) {
							arrayBalls[i].removeEventListener(Event.ENTER_FRAME, movearray);
							arrayBalls[i] = null;
							
						}
						palabra_final.text = "";
						//arrayBalls = null;
						//arrayVels = null;
						arrayBalls = new Array();
						arrayVels = new Array();
						//initialVelX = 1;
						//initialVelY = 1;
						nump = 0;
						manito.x = 548;
						manito.y = 364;
						this.addChild(manito);
						manito.gotoAndPlay(2);
						setTimeout(inicio,2000);
						//inicio();
					} else {
						// enviamos los datos
						timer.stopClock();
						post_data = new Post();
						var df: DateTimeFormatter = new DateTimeFormatter("");
						df.setDateTimePattern("yyyy-MM-dd'T'HH:mm:ss'Z'")
						var datos: Array = [timer.time_execute, "2", df.format(new Date()), memoria_juegos.data.usuario.id, "2"];
						post_data.post_data(datos);

						MovieClip(this.root).gotoAndPlay(1, "PASASTE");
						//this.parent.removeChild(this);
					}
				} else {
					trace("NO PASO");
					MovieClip(this.root).gotoAndPlay(1, "FALLASTE");
				}
			}
		}

		public function addballs(palabra: Array) {

			for (var i: int = 0; i < palabra.length; i++) {
				//instanciamos la Pelota
				var letrita: Pelota = new Pelota();

				letrita.x = randomRange(100, 850);
				letrita.y = randomRange(100, 500);
				letrita.letra.text = palabra[i];
				addChild(letrita);

				letrita.addEventListener(MouseEvent.CLICK, presionado);
				letrita.addEventListener(Event.ENTER_FRAME, movearray);

				// agregamos la Pelota a la lista
				arrayBalls.push(letrita);


				//use a Point to store velocities in two axis
				//you could also set random starting velocities
				//so each ball would move differently initially
				var vel: Point = new Point(initialVelX, initialVelY);
				// agregamos la velocidad
				arrayVels.push(vel);

			}
		}

		function movearray(event: Event): void {
			var letrita: Pelota = new Pelota();
			var vel: Point = new Point(0, 0);

			for (var i = 0; i < palabra_array.length; i++) {

				letrita = arrayBalls[i];
				vel = arrayVels[i];

				letrita.x += vel.x;
				letrita.y += vel.y;

				//letrita.x += 1;
				//letrita.y += 1;

				if (letrita.x >= 1040 - letrita.width || letrita.x < 40) {
					vel.x *= -1;
				} else if (letrita.y >= 640 - letrita.height || letrita.y < 80) {
					vel.y *= -1;
				}

			}
		}

		function presionado(clickInfo: MouseEvent) {
			//removeChild(letrita);

			// contador para la longitud de la palabra
			nump += 1;

			// construimos la palabra en el texto
			palabra_final.appendText(clickInfo.currentTarget.letra.text);
			// eliminamos el listener de la Pelota presionada
			this.removeEventListener(Event.ENTER_FRAME, movearray);
			// hacemos que la Pelota desaparezca
			arrayBalls[clickInfo.currentTarget.gotoAndPlay(2)];
			// verificamos si la palabra es igual
			verificar(palabra_inicial.text, palabra_final.text);

			//removeChild(arrayBalls[clickInfo.currentTarget]);
			//parent.removeChild(this);
		}


		function repetir(clickInfo: MouseEvent) {

			for (var i = 0; i < arrayBalls.length; i++) {

				//if(contains(arrayBalls[i])){
				arrayBalls[i].removeEventListener(Event.ENTER_FRAME, movearray);
				if (contains(arrayBalls[i])) {
					this.removeChild(arrayBalls[i]);
				}
				arrayBalls[i] = null;
				//trace(arrayBalls);
				//}

			}
			trace(arrayBalls);
			palabra_final.text = "";
			arrayBalls = new Array();
			arrayVels = new Array();
			nump = 0;
			inicio();
		}

		function randomRange(minNum: Number, maxNum: Number): Number {
			return (Math.floor(Math.random() * (maxNum - minNum + 1)) + minNum);
			//return Math.ceil(Math.random() * maxNum) + minNum
			/*var num = Math.ceil(Math.random());
			trace(num);
			while(num > maxNum || num < minNum){
				num = Math.ceil(Math.random());
			}
			return num;*/
		}


	}

}