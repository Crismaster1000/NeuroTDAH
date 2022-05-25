package {

	import flash.display.MovieClip;
	import flash.utils.Timer;
	import flash.events.TimerEvent;


	public class TimerClass extends MovieClip {
		var clock: Timer = new Timer(1000); //tiempo de cada intento que realice
		//private var intento_p:Number=0;

		var time_execute: Number = 0;
		//para empezar con uno enseguida y no se pierda los segundos
		//var time_execute1: Number = 1;
		public function TimerClass() {}
		/*Funciones para el clock  que empieza en 0 usando time_execute tenemos el 
		start, ejecucion y stop */
		public function startClock() {
			clock.start();
			clock.addEventListener(TimerEvent.TIMER, clock_execute);
		}

		private function clock_execute(e: TimerEvent) {
			time_execute++;
			//trace("" + time_execute);
		}
		
		public function stopClock(): Number {
			clock.stop();
			return time_execute;
		}
/*Funciones para el clock  que empieza en 1 usando el time_execute1  tenemos el 
		start, ejecucion y stop */
		/*public function startClock1() {
			clock.start();
			clock.addEventListener(TimerEvent.TIMER, clock_execute1);
		}
		private function clock_execute1(e: TimerEvent) {
			time_execute1++;
			//trace("" + time_execute1);
		}
		public function stopClock1(): Number {
			clock.stop();
			return time_execute1;
		}*/
	
}
}