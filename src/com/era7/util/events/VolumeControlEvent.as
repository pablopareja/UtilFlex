package com.era7.util.events
{
	import flash.events.Event;

	public class VolumeControlEvent extends Event
	{
		private static const SUFIX:String = "vCtEt";
		
		public static const VOLUME_CHANGED:String = "volumeChanged" + SUFIX;
		public static const MUTED:String = "muted" + SUFIX;
		public static const VOLUME_ACTIVATED:String = "volumeActivated" + SUFIX;
		
		protected var volumeValue:Number = 0;
		
		/*
		*	Constructor
		*/
		public function VolumeControlEvent(type:String,volume:Number, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			
			volumeValue = volume;
		}
		
		public function getVolume():Number{	return volumeValue;}
		public function setVolume(value:Number):void{	volumeValue = value;}
		
		/**
		 *  Clone function
		 */
		override public function clone():Event{
			return new VolumeControlEvent(this.type,this.volumeValue,this.bubbles,this.cancelable);
		}
		
	}
}