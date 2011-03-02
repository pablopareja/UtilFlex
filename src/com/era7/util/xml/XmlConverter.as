package com.era7.util.xml
{
	
	public class XmlConverter
	{
		
		public static function CDATA(nm: String, info: String) : XML
    	{
       	 	return <{nm}>{new XML("<![CDATA["+info+"]]>")}</{nm}>;
    	}
		
		
	}
}