package {

	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.utils.setTimeout;
	import flash.net.SharedObject;
	import flash.globalization.DateTimeFormatter;


	public class CuadrosGame2 extends MovieClip {

		var cuadrantesx: Array = [0, 250, 500, 750, 250, 0, 750, 500];
		var cuadrantesy: Array = [0, 200, 400];
		/*var cuadrantes: Array = [
			[0, 0],
			[250, 0],
			[500, 0],
			[750, 0],
			[0, 200],
			[250, 200],
			[500, 200],
			[750, 200],
			[0, 400],
			[250, 400],
			[500, 400],
			[750, 400]
		];*/

		var cuadrantes: Array = [
			[0, 0],
			[250, 0],
			[500, 0],
			[750, 0],
			[0, 200],
			[250, 200],
			[500, 200],
			[750, 200],
			[0, 400],
			[250, 400],
			[500, 400],
			[750, 400]
		];

		//memoria para el juego
		//var memoria3: SharedObject = SharedObject.getLocal("juego3", "/");

		//definimos los mc de las imagenes
		var imagen1: peli1 = new peli1();
		var imagen2: peli2 = new peli2();
		var imagen3: peli3 = new peli3();
		var imagen4: peli4 = new peli4();
		var imagen5: peli5 = new peli5();
		var imagen6: peli6 = new peli6();
		var imagen7: peli7 = new peli7();

		//definimos el mc del cuadro
		var cuadro: CuadroF;
		// definimos el mc de la imagen
		var imagen: MovieClip

		var imagenes: Array = new Array();

		//flag para botones
		var btn_act: Boolean;

		// arreglo para cuadros
		var cuadrados_array: Array = new Array();
		// arreglo para posiciones de cuadrantes
		var posiciones_array: Array = new Array();
		// arreglo para posiciones despues de click
		var posiciones_after: Array = new Array();
		// arreglo para flags de botones presionados
		var contadores_array: Array = [false, false, false, false, false, false, false, false, false, false, false, false];
		// arreglo para cuadros after press
		var cuadros_stage: Array = new Array();

		var memoria_juegos: SharedObject = SharedObject.getLocal("juegos", "/");

		var timer:TimerClass = new TimerClass();
		var post_data:Post;
		var fase = 1;
		var manito:bienmc = new bienmc();



		public function CuadrosGame2() {

			timer.startClock();

			n1.addEventListener(MouseEvent.CLICK, presionado);
			n2.addEventListener(MouseEvent.CLICK, presionado);
			n3.addEventListener(MouseEvent.CLICK, presionado);
			n4.addEventListener(MouseEvent.CLICK, presionado);
			n5.addEventListener(MouseEvent.CLICK, presionado);
			n6.addEventListener(MouseEvent.CLICK, presionado);
			n7.addEventListener(MouseEvent.CLICK, presionado);
			n8.addEventListener(MouseEvent.CLICK, presionado);
			n9.addEventListener(MouseEvent.CLICK, presionado);
			n10.addEventListener(MouseEvent.CLICK, presionado);
			n11.addEventListener(MouseEvent.CLICK, presionado);
			n12.addEventListener(MouseEvent.CLICK, presionado);


			sborrar.addEventListener(MouseEvent.CLICK, borrar_cuadros);
			verificarbtn.addEventListener(MouseEvent.CLICK, verificar);
			// constructor code
			//imagenes = new Array();
			trace("INICIO....");
			// ingresamos las imagenes al arreglo
			imagenes.push(imagen1, imagen2, imagen3, imagen4, imagen5, imagen6, imagen7);
			trace("IMAGENES : " + imagenes);
			inicio();
			time_count.text = timer.time_execute.toString();
		}


		public function inicio() {
			if(contains(manito)) removeChild(manito);
			trace("FASE NUM : "+fase);
			// hacemos invisibles los botones
			set_visible(false);
			//desactivamos los botones
			desactivar();
			// AGREGAMOS LA IMAGEN
			agregar_imagen(imagenes);
			// AGREGAMOS LOS CUADROS
			agregar_cuadros(5, cuadro);
			// esperar 1 min , hacer girar la imagen y desaparecer los cuadros
		}

		public function agregar_imagen(imagenes_array: Array) {
			// generamos un numero aleatorio 
			var num = randomRange(0, imagenes_array.length-1);
			//Math.floor(Math.random() * imagenes_array.length);
			imagen = imagenes_array[num];
			//removemos la imagen de la lista
			//imagenes_array.splice(imagen);
			trace("ARREGLO DE IMAGENES : " + this.imagenes);

			imagen.x = 0; //40
			imagen.y = 0; //50
			//addChild(imagen);
			this.addChildAt(imagen, 0);
			imagen.gotoAndStop(1);
			// hacemos girar la imagen despues de 1 min
			setTimeout(girar, 10000, imagen);
			// quitamos los cuadrados 3 seg antes de que gire
			setTimeout(eliminar_cuadros, 9000, 5);


		}

		public function agregar_cuadros(num_cuadros: int, cuadro_mc: MovieClip) {

			//var num = Math.floor(Math.random() * cuadrantes.length);
			var numeros: Array = new Array();
			numeros[0] = 1000;
			//cuadrados = new Array();
			//posiciones = new Array();

			for (var j = 0; j < num_cuadros; j++) {

				// generamos un num aleatorio entre 0 y 3
				var num = randomRange(0, 11);

				// verificamos si el numero ya salio previamente
				var flag = verificar_num(numeros, num);
				//trace("CONDICION PRE : " + flag);
				while (flag) {
					num = randomRange(0, 11);
					//trace("NUMERO NUEVO : " + num);
					flag = verificar_num(numeros, num);
					//trace("CONDICION POST : " + flag);
				}
				//trace("NUMERO : " + num);
				// agregamos el numero al array
				numeros[j] = num;
				trace("ARREGLO : " + numeros);
				trace("NUMERO FINAL : " + num);

				// agregamos el cuadro
				cuadro_mc = new CuadroF();
				cuadro_mc.x = cuadrantes[num][0]
				cuadro_mc.y = cuadrantes[num][1]
				
				//cuadro_mc.x = cuadrantesx[num];
				//cuadro_mc.y = cuadrantesy[randomRange(0, 2)];
				
				// calculamos el cuadrante donde se agrego el cuadro
				for (var h = 0; h < cuadrantes.length; h++) {

					if (cuadro_mc.x == cuadrantes[h][0] && cuadro_mc.y == cuadrantes[h][1]) {
						var num_cuadrante = h + 1;
						trace("CUADRANTE NUM : " + num_cuadrante);
						//agregamos el cuadrante al arreglo 
						posiciones_array.push(num_cuadrante);
					}
				}
				trace("CUADRANTE : " + posiciones_array[j] + " COORDENADAS : X= " + cuadro_mc.x + ",Y= " + cuadro_mc.y);
				// ordenamos el arreglo
				ordenar_array(posiciones_array);
				//memoria3.data.posiciones = posiciones;
				// agregamos el cuadro a la lista
				cuadrados_array.push(cuadro_mc);
				addChild(cuadro_mc);

			}

			trace("POSICIONES DE CUADRADOS : " + posiciones_array);
		}

		private function girar(imagen: MovieClip) {
			trace("GIRANDO...");
			imagenes[imagen.gotoAndPlay(1)];
			// activamos los botones despues de que giro la imagen
			setTimeout(activar, 3000);
		}

		function set_visible(condicion: Boolean) {
			n1.visible = condicion;
			n2.visible = condicion;
			n3.visible = condicion;
			n4.visible = condicion;
			n5.visible = condicion;
			n6.visible = condicion;
			n7.visible = condicion;
			n8.visible = condicion;
			n9.visible = condicion;
			n10.visible = condicion;
			n11.visible = condicion;
			n12.visible = condicion;
		}


		public function presionado(clickInfo: MouseEvent): void {

			var numero = clickInfo.target.name.substr(1, 2);

			if (btn_act != false && contadores_array[numero - 1] == false) {

				contadores_array[numero - 1] = true;

				trace("CUADRANTE : " + numero);
				//agregamos el cuadro
				posiciones_after.push(numero);
				// ordenamos el arreglo
				ordenar_array(posiciones_after);

				numero = numero - 1;
				// agregamos un cuadro en la posicion donde hizo click y lo animamos
				animar(cuadro, numero);
			}
			//trace("POSICIONES : " + memoria_local.data.posiciones);
			trace("POSICIONES : " + posiciones_after);
		}

		public function animar(cuadro: MovieClip, cuadrante: int) {
			cuadro = new CuadroF();
			//setChildIndex(cuadro as MovieClip, numChildren - 1);
			cuadro.x = cuadrantes[cuadrante][0];
			cuadro.y = cuadrantes[cuadrante][1];
			//this.addChild(cuadro);
			this.addChildAt(cuadro, 1);

			//cuadros[cuadrante] = cuadro;
			cuadros_stage.push(cuadro);
			trace(cuadros_stage);
			//memoria_local.data.cuadros_stage = cuadros_stage;
			//memoria_local.flush();
		}


		public function activar() {
			btn_act = true;
			set_visible(true);
			trace("BOTONES ACTIVADOS..");
			//navigateToURL(new URLRequest("http://www.adobe.com"), "_blank");
			//button_1.enabled = true;
		}

		public function desactivar() {
			btn_act = false;
			set_visible(false);
			trace("BOTONES DESACTIVADOS..");
			//navigateToURL(new URLRequest("http://www.adobe.com"), "_blank");
			//button_1.enabled = true;
		}

		function randomRange(minNum: Number, maxNum: Number): Number {
			return (Math.floor(Math.random() * (maxNum - minNum + 1)) + minNum);
		}

		// funcion que verifica si un numero existe en un vector
		public function verificar_num(arreglo: Array, num: int): Boolean {
			var flag: Boolean = false;
			for (var j = 0; j < arreglo.length; j++) {
				if (num == arreglo[j]) {
					flag = true;
					return flag;
				}
			}
			return flag;
		}

		public function ordenar_array(arreglo: Array): Array {
			arreglo.sort(Array.NUMERIC);
			return arreglo;
		}

		public function eliminar_cuadros(cuadros: int) {
			//cuadro = new CuadroF();
			for (var j = 0; j < cuadros; j++) {
				this.removeChild(cuadrados_array[j]);

			}
			cuadrados_array = new Array();
		}


		// funcion que borra los cuadros del escenario
		public function borrar_cuadros(clickInfo: MouseEvent): void {

			for (var j = 0; j < posiciones_after.length; j++) {
				//this.removeChild(cuadros[j]);
				//this.removeChildAt(1);
				if (this.contains(cuadros_stage[j])) {
					removeChild(cuadros_stage[j]);
				}
				cuadros_stage[j] = null;

			}
			cuadros_stage = new Array();
			posiciones_after = new Array();
			contadores_array = [false, false, false, false, false, false, false, false, false, false, false, false];
		}


		public function verificar(clickInfo: MouseEvent) {

			// verificamos si estan bien ubicados los cuadros
			var flag = sameArrays(posiciones_array, posiciones_after);
			if (flag) {
				//eliminar_cuadros(3);
				//inicio();
				// borramos los cuadros del escenario
				for (var k = 0; k < cuadros_stage.length; k++) {
					if(this.contains(cuadros_stage[k])){
						this.removeChild(cuadros_stage[k]);
					}
					
				}
				this.removeChild(imagen);
				cuadros_stage = new Array();
				cuadrados_array = new Array();
				posiciones_array = new Array();
				posiciones_after = new Array();
				contadores_array = [false, false, false, false, false, false, false, false, false, false, false, false];
				if (fase > 6){
					// enviamos los datos
						timer.stopClock();
						post_data = new Post();
						var df: DateTimeFormatter = new DateTimeFormatter("");
						df.setDateTimePattern("yyyy-MM-dd'T'HH:mm:ss'Z'")
						var datos: Array = [timer.time_execute, "2", df.format(new Date()), memoria_juegos.data.usuario.id, "3"];
						post_data.post_data(datos);

						MovieClip(this.root).gotoAndPlay(1, "PASASTE");
				}else{
					fase++;
					manito.x = 482;
					manito.y = 294;
					manito.weight = 535;
					manito.height = 443;
					this.addChild(manito);
					manito.gotoAndPlay(2);
					setTimeout(inicio, 2000);
					//inicio();
				}
				//MovieClip(this.root).gotoAndPlay(1, "PASASTE");
			} else {
				for (var j = 0; j < posiciones_after.length; j++) {

					this.removeChild(cuadros_stage[j]);
				}
				MovieClip(this.root).gotoAndPlay(1, "FALLASTE");
			}
		}


		function sameArrays(vec_uno: Array, vec_dos: Array): Boolean {
			trace(vec_uno);
			trace(vec_dos);

			var verify = false;
			var conter = 0;

			if (vec_uno.length == vec_dos.length) {
				for (var i = 0; i < vec_dos.length; i++) {
					//trace("ESTE " + vec_uno[i] + " ES IGUAL A ESTE " + vec_dos[i]);
					if (vec_uno[i] == vec_dos[i]) {
						conter++;
					}
				}
			}

			
			if (conter == vec_dos.length) {
				verify = true;
			} else
				verify = false;


			return verify
		}



	}

}