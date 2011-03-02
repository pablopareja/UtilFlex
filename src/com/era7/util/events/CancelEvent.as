package com.era7.util.events
{
	import flash.events.Event;

	public class CancelEvent extends Event
	{
		
		public static const CANCEL_PRESSED:String = "CancelPressed";
		
		public function CancelEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
		
		/**
		 *  Clone function
		 */
		override public function clone():Event{
			return new CancelEvent(this.type,this.bubbles,this.cancelable);
		}
		
	}
}