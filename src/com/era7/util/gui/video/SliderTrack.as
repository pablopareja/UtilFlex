package com.era7.util.gui.video
{
	import mx.core.UIComponent;

	public class SliderTrack extends UIComponent
	{
		
		
		override public function get height():Number{
        	return 20;
  		}
 

        override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void{
            
            super.updateDisplayList(unscaledWidth, unscaledHeight);

            //2 circle that will act like round corners

            this.graphics.beginFill(0xFFFFFF,1);
            this.graphics.drawCircle(0,0,5);
            this.graphics.drawCircle(unscaledWidth,0,5);
            this.graphics.endFill();

            //line that represents the track

            this.graphics.moveTo(0,0);
            this.graphics.lineStyle(10,0xFFFFFF);
            this.graphics.lineTo(unscaledWidth,0); 

        }

		
	}
}