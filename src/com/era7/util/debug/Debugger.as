package com.era7.util.debug
{
	import mx.core.Application;
	import mx.core.FlexGlobals;
	import mx.core.UIComponent;
	import mx.managers.PopUpManager;
	
	public class Debugger
	{
		
		protected static var requestWindow:DebugWindow = null;
		protected static var responseWindow:DebugWindow = null;
		protected static var errorWindow:DebugWindow = null;
		protected static var comp:UIComponent = null;
		
		
		public static const REQUEST_MODE:int = 0;
		public static const RESPONSE_MODE:int = 1;
		public static const ERROR_MODE:int = 2;
		
		
		/**
		 * 	Set UIComponent
		 */
		public static function setUIComponent(value:UIComponent):void{
			comp = value;
		}
		
		/**
		 * 	Append text
		 */
		public static function appendText(value:String,mode:int):void{
			
			if(comp == null){
				comp = UIComponent(FlexGlobals.topLevelApplication);
			}
			
			if(mode == Debugger.REQUEST_MODE){
				if(requestWindow == null){
					requestWindow = DebugWindow(PopUpManager.createPopUp(comp,DebugWindow));
					requestWindow.title = "Request debugger!";
					PopUpManager.centerPopUp(requestWindow);	
				}else{
					if(!requestWindow.visible){
						requestWindow.visible = true;
					}
				}
				
				requestWindow.appendText(value+"\n>--------\n");
				
			}else if(mode == Debugger.RESPONSE_MODE){
				if(responseWindow == null){
					responseWindow = DebugWindow(PopUpManager.createPopUp(comp,DebugWindow));
					responseWindow.title = "Response debugger!";
					PopUpManager.centerPopUp(responseWindow);	
				}else{
					if(!responseWindow.visible){
						responseWindow.visible = true;
					}
				}
				
				responseWindow.appendText(value+"\n>--------\n");
				
			}else if(mode == Debugger.ERROR_MODE){
				if(errorWindow == null){
					errorWindow = DebugWindow(PopUpManager.createPopUp(comp,DebugWindow));
					errorWindow.title = "Error debugger!";
					PopUpManager.centerPopUp(errorWindow);	
				}else{
					if(!errorWindow.visible){
						errorWindow.visible = true;
					}
				}
				
				errorWindow.appendText(value+"\n>--------\n");
			}
			
			
		}

	}
}