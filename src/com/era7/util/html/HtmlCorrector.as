package com.era7.util.html
{
	public class HtmlCorrector
	{
		
		
		public static function correctHtmlFontFormat(st:String):String{
			var pattern:RegExp = /SIZE=\"/g;
			var str:String = st.replace(pattern, "style=\"font-size:"); 
			/*
			pattern = /<TEXTFORMAT.*>/g;
			str = str.replace(pattern, ""); 
			
			pattern = /<.*TEXTFORMAT.*>/g;
			str = str.replace(pattern, ""); 
			*/
			return str;
		}
		public static function convertToFlexHTMLFontFormat(st:String):String{
			var pattern:RegExp = /style=\"font-size:/g;
			var str:String = st.replace(pattern, "SIZE=\"");
			return str;
		}
	}
	
	
}