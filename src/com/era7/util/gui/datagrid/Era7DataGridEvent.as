package com.era7.util.gui.datagrid
{
	
	import flash.events.Event;

	public class Era7DataGridEvent extends Event
	{
		private static const SUFIX:String = "Er7DgEvt";		
		
		public static const ITEM_SELECTED:String = "itemSelected" + SUFIX;
		public static const NO_ITEMS:String = "noItems" + SUFIX;
		public static const ITEM_ADDED:String = "itemAdded";
		public static const ITEM_DELETED:String = "itemDeleted";
		
		
		protected var item:XML = null;
		
		/**
		 * 	Constructor
		 */
		public function Era7DataGridEvent(type:String, i:XML, 
						bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			
			item = i;
		}
		
		/**
		*  Clone function
		*/
		public override function clone():Event{						
			return new Era7DataGridEvent(type,item,bubbles,cancelable);
		}
		
		
		public function getItem():XML{	return item;}		
		public function setItem(value:XML):void{	item = value;}
		
	}
}