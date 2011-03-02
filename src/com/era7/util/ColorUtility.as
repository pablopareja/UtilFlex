package com.era7.util
{
	public class ColorUtility
	{
		
		
		public static function fixedInt(value:int, mask:String):String {			
        	return String(mask + value.toString(16)).substr(-mask.length).toUpperCase();
        }
        
		/* Convert r/g/b values (255,0,255) to a fixed string ('FF00FF'). */
		public static function rgbToStr(r:int, g:int, b:int):String {
		    return fixedInt(rgbToInt(r, g, b), "000000");
		}
		
		/* Convert a string ('0xFF00FF') to an integer (16711935). */
		public static function strToInt(value:String):int {
		    return int(value);
		}
		
		/* Convert a string ('0xFF00FF') to an object containing an 'r', 'g', and 'b' property. */
		public static function strToRGB(value:String):Object {
		    var temp:int = strToInt(value);
		    return {r:rChannel(temp), g:gChannel(temp), b:bChannel(temp)};
		}
		
		private static function rChannel(value:int):int {
            return value >> 16 & 0xFF;
        }
        private static function gChannel(value:int):int {
            return value >> 8 & 0xFF;
        }
        private static function bChannel(value:int):int {
           return value >> 0 & 0xFF;
        }
        private static function rgbToInt(r:int, g:int, b:int):int {
           return r << 16 | g << 8 | b << 0;
        }




	}
}