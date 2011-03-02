package com.era7.util.events
{
	import flash.events.Event;


	/**
	 * 
	 * @author Pablo Pareja Tobes
	 * 
	 */
	public class PaginationControlEvent extends Event
	{
		private static const SUFIX:String = "PCevt";	
		
		/** Event launched when the user wants to display the page specified by <i>getPage()</i> */
		public static const GO_TO_PAGE:String = "GoToPage" + SUFIX;
		/** Event launched when the user wants to display the last page */
		public static const GO_TO_LAST_PAGE:String = "GoToLastPage" + SUFIX;
		/** Event launched when the user wants to display the first page */
		public static const GO_TO_FIRST_PAGE:String = "GoToFirstPage" + SUFIX;
		
		/** Page number */
		protected var page:Number = 0;
		
		
		/**
		 * Constructor
		 * @param type Event type
		 * @param pageValue Number of the page
		 * @param bubbles
		 * @param cancelable
		 * 
		 */
		public function PaginationControlEvent(type:String,pageValue:Number, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			
			this.page = pageValue;
		}
		
		/**
		 *  Clone function
		 */
		override public function clone():Event{
			return new PaginationControlEvent(this.type,this.page,this.bubbles,this.cancelable);
		}
		
		/**
		 * Gets the page number 
		 * @return Number of the page
		 * 
		 */
		public function getPage():Number{
			return this.page;
		}
		
	}
}