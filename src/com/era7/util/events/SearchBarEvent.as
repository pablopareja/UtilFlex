package com.era7.util.events
{
	import flash.events.Event;

	public class SearchBarEvent extends Event
	{
		private static const SUFIX:String = "sBaEvt";
		
		public static const SEARCH:String = "search" + SUFIX;
		public static const GO_TO_ELEMENT:String = "goToElement" + SUFIX;
		
		protected var searchText:String = "";
		
		/*
		*	Constructor
		*/
		public function SearchBarEvent(type:String,text:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			
			searchText = text;
		}
		
		public function getSearchText():String{	return searchText;}
		public function setSearchText(value:String):void{	searchText = value;}
		
		
		/**
		 *  Clone function
		 */
		override public function clone():Event{
			return new SearchBarEvent(this.type,this.searchText,this.bubbles,this.cancelable);
		}
		
	}
}