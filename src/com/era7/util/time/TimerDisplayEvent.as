package com.era7.util.time
{
	import flash.events.Event;

	public class TimerDisplayEvent extends Event
	{
		private static const SUFIX:String = "TDEv";
		
		public static const TIME_ELAPSED:String = "TimeElapsed" + SUFIX;
		
		public function TimerDisplayEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
		
		/**
		 *  Clone function
		 */
		override public function clone():Event{
			return new TimerDisplayEvent(this.type,this.bubbles,this.cancelable);
		}
		
	}
}