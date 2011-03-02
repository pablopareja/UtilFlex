package com.era7.util
{
	public class BooleanParser
	{
		
		static public function parseBoolean(str:String):Boolean {
			switch(str.toLowerCase()) {
				case "1":
				case "true":
				case "yes":
					return true;
				case "0":
				case "false":
				case "no":
					return false;
				default:
					return Boolean(str);
			}
		}
	}
}