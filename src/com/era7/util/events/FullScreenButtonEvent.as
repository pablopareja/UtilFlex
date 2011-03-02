package com.era7.util.events
{
	import flash.events.Event;

	public class FullScreenButtonEvent extends Event
	{
		private static const SUFIX:String = "fullEt";
		
		public static const GO_FULL_SCREEN:String = "goFullScreen" + SUFIX;
		public static const GO_BACK_NORMAL:String = "goBackNormal" + SUFIX;
		
		
		/*
		*	Constructor
		*/
		public function FullScreenButtonEvent(type:String,bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
		
		
		/**
		 *  Clone function
		 */
		override public function clone():Event{
			return new FullScreenButtonEvent(this.type,this.bubbles,this.cancelable);
		}
		
	}
}