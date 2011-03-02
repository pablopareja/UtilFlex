package com.era7.util.xml
{
	
	import mx.controls.Alert;
	
	public class XmlManager
	{
		
		public static function deleteNodes(name:String,xml:XML):XML{			
			var xml:XML =  deleteNodeRecursive(name,xml);			
			return xml;
		}
		
		private static function deleteNodeRecursive(name:String,xml:XML):XML{
			
			for(var i:int = xml.elements().length()-1;i>=0;i--){
				
				if(xml.elements()[i].name() == name){					
					delete xml.elements()[i];
				}
					
				else{
					deleteNodeRecursive(name,xml.elements()[i]);
				}
					
			}
			return xml;			
		}
		
		public static function deleteNodesWithAttributeBoolean(attributeName:String,b:Boolean,xml:XML):XML{			
			
			var newXML:XML = new XML(<areas/>);						
			return deleteNodesWithAttributeBooleanRecursive(attributeName,b,newXML,xml);
		}
				
		public static function deleteNodesWithAttributeBooleanRecursive(attributeName:String,b:Boolean,newXml:XML,xml:XML):XML{
					
			for(var i:int = xml.elements().length()-1;i>=0;i--){
				
				if(XML(xml.elements()[i]).attribute(attributeName)[0] == b.toString()){	
					deleteNodesWithAttributeBooleanRecursive(attributeName,b,newXml,xml.elements()[i]);		
					delete xml.elements()[i];
				}else{
					newXml.appendChild(XML(xml.elements()[i]).copy());
				}
					
			}
			return newXml;		
		}
		
	}
}