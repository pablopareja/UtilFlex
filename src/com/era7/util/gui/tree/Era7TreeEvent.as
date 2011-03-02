package com.era7.util.gui.tree
{
	import flash.events.Event;

	public class Era7TreeEvent extends Event
	{
		private static const SUFIX:String = "Era7TreeEvt";
		
		public static const NODE_SELECTED:String = "NodeSelected" + SUFIX;
		public static const NODE_ADDED:String = "NodeAdded" + SUFIX;
		public static const NODE_DELETED:String = "NodeDeleted" + SUFIX;
		public static const NO_NODES:String = "NoNodes" + SUFIX;
		
		protected var node:XML;
		
		/**
		 * 	Constructor
		 */
		public function Era7TreeEvent(type:String,xml:XML,bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			
			this.node = xml;
		}	
		
		public function getNode():XML{
			return this.node;
		}	
			
		/**
		 *  Clone function
		 */
		override public function clone():Event{
			return new Era7TreeEvent(this.type, this.node,this.bubbles,this.cancelable);
		}
		
	}
}