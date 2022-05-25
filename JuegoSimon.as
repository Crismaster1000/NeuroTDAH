package  {
	
	import flash.display.MovieClip;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	
	
	public class JuegoSimon extends MovieClip {
		
		var clock: Timer = new Timer(1000); //tiempo de cada intento que realice
		var time_execute: Number = 0;
		var nivel:int = 0;
		var memoria_juegos: SharedObject = SharedObject.getLocal("juegos", "/");
		
		public function JuegoSimon() {
			// constructor code
		}
		
		public function startClock() {
			clock.start();
			clock.addEventListener(TimerEvent.TIMER, clock_execute);
		}
		private function clock_execute(e: TimerEvent) {
			time_execute++;
			//timetxt.text = time_execute.toString();
			trace("" + time_execute);
		}
		public function stopClock(): Number {
			clock.stop();
			return time_execute;
		}
	}
	
}
