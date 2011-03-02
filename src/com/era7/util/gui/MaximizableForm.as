package com.era7.util.gui
{
	import com.era7.util.events.MaximizableFormEvent;
	
	import flash.events.MouseEvent;
	
	import mx.containers.HBox;
	import mx.containers.VBox;
	import mx.controls.Image;

	public class MaximizableForm extends VBox
	{
		
		
		[Embed(source="../../../../../icons/minimize.png")]
		protected var minimizeIcon:Class;
		[Embed(source="../../../../../icons/maximize.png")]
		protected var maximizeIcon:Class;
		
		protected var hbox:HBox;
		protected var minimizeButton:Image;
		protected var maximizeButton:Image;
		
		/**
		 * 	Constructor
		 */	
		public function MaximizableForm()
		{
			super();
			
			this.setStyle("verticalGap",0);
		}
		
		/**
		 * 	Create children
		 */
		override protected function createChildren():void {
		   	
		    minimizeButton = new Image();
		    minimizeButton.useHandCursor = true;
		    minimizeButton.mouseChildren = false;
		    minimizeButton.buttonMode = true;
		    minimizeButton.height = 12;
		    minimizeButton.source = this.minimizeIcon;
		    minimizeButton.addEventListener(MouseEvent.CLICK,onMinimizeButtonClick);
		    
		    maximizeButton = new Image();
		    maximizeButton.useHandCursor = true;
		    maximizeButton.mouseChildren = false;
		    maximizeButton.buttonMode = true;
		    maximizeButton.source = this.maximizeIcon;
		    maximizeButton.addEventListener(MouseEvent.CLICK,onMaximizeButtonClick);
		    
		    hbox = new HBox();
		    hbox.percentWidth = 100;
		    hbox.setStyle("verticalAlign","top");
		    hbox.setStyle("horizontalAlign","right");
		    hbox.setStyle("horizontalGap",4);
		    
		    hbox.addChild(minimizeButton);
		    hbox.addChild(maximizeButton);		    
		    
		    this.addChild(hbox);
		    
		    super.createChildren();
		}

		
		private function onMinimizeButtonClick(event:MouseEvent):void{
				this.dispatchEvent(new MaximizableFormEvent(MaximizableFormEvent.MINIMIZE_FORM,true));
		}			
		private function onMaximizeButtonClick(event:MouseEvent):void{
			this.dispatchEvent(new MaximizableFormEvent(MaximizableFormEvent.MAXIMIZE_FORM,true));
		}
		
	}
}