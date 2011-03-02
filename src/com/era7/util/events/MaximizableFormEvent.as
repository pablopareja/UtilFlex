package com.era7.util.events
{
	import flash.events.Event;

	public class MaximizableFormEvent extends Event
	{
		private static const SUFIX:String = "MFevt";	
		
		public static const MAXIMIZE_FORM:String = "MaximizeForm" + SUFIX;
		public static const MINIMIZE_FORM:String = "MinimizeForm" + SUFIX;
		
		
		public function MaximizableFormEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
		
		/**
		 *  Clone function
		 */
		override public function clone():Event{
			return new MaximizableFormEvent(this.type,this.bubbles,this.cancelable);
		}
		
	}
}