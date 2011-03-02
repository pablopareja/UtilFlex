package com.era7.util.xml
{
	public class XMLSearchTool
	{
		
		private var xmlSource:XML;
		
		
		
		/**
		 *  Returns true if the xml element passed as a parameter has at least one
		 *  child of the specified kind.
		 */
		public static function hasSpecifiedKindChildren(kind:String,xml:XML):Boolean{
			for each (var element:XML in xml.elements()){
				if(element.name() == kind)
					return true;						
			}
			return false;
		}
		
		
		/**
		 *  This method looks for the element specified in the xml source
		 *  and returns the element found
		 * 	@param removeChildren If true all the children of the node will be removed 
		 * 	and there will remain only the attributes of the node.
		 * 
		 */
		public static function lookForElementWithName(nodeType:String,name:String,id:String,xml:XML,
									removeChildren:Boolean=false):XML{
			
			if(xml.name() == nodeType){				
				if(xml.@id == id && xml.@name == name){					
					if(xml.elements().length()>0 && removeChildren){
						//trace("before: \n" + xml);
						//Removing of every children in the case where it is necessary
						for(var i:int = xml.elements().length() -1; i>=0;i--){
							//trace("child["+i+"] = "+ xml.children()[i]);
							delete xml.children()[i];
							//trace("after: \n" + xml.toXMLString());
						}
						
					}					
					return xml;					
				}
			}				
					
			if(xml.elements().length() == 0)
				return null;
			else{
				var solution:XML;
				for each (var element:XML in xml.elements()){
					solution = lookForElementWithName(nodeType,name,id,element);
					if(solution != null)
						return solution;						
				}
				return null;
			}				
					
			
		}
		
		
		
		public static function lookForElementById(nodeType:String,id:String,xml:XML):XML{
			
			if(xml.name() == nodeType){				
				if(xml.@id == id){										
					return xml;					
				}
			}				
					
			if(xml.elements().length() == 0)
				return null;
			else{
				var solution:XML;
				for each (var element:XML in xml.elements()){
					solution = lookForElementById(nodeType,id,element);
					if(solution != null)
						return solution;						
				}
				return null;
			}				
					
			
		}
		
		
		/**
		 *  This method looks for the element specified in the xml source
		 *  and returns the element found	
		 * 
		 */
		public static function lookForElementByName(nodeName:String,xml:XML):XML{
			var name:String = xml.@name;
			if(nodeName.indexOf(name) != -1){
				return xml;					
			}else{
				if(xml.elements().length() == 0)
					return null;
				else{
					var solution:XML;
					for each (var element:XML in xml.elements()){
						solution = lookForElementByName(nodeName,element);
						if(solution != null)
							return solution;						
					}
					return null;
				}
				
			}
			return null;
			
		}
		
		
		/**
		 *  This method looks for the element specified in the xml source
		 *  and returns the element found
		 * 	@param removeChildren If true all the children of the node will be removed 
		 * 	and there will remain only the attributes of the node.
		 * 
		 */
		public static function lookForElement(nodeType:String,id:String,xml:XML,
									removeChildren:Boolean=false):XML{
			if(xml.name() == nodeType){
				if(xml.@id == id){
					if(xml.elements().length()>0 && removeChildren){
						//trace("before: \n" + xml);
						//Removing of every children in the case where it is necessary
						for(var i:int = xml.elements().length() -1; i>=0;i--){
							//trace("child["+i+"] = "+ xml.children()[i]);
							delete xml.children()[i];
							//trace("after: \n" + xml.toXMLString());
						}
						
					}
						
					return xml;					
				}
					
			}else{
				if(xml.elements().length() == 0)
					return null;
				else{
					var solution:XML;
					for each (var element:XML in xml.elements()){
						solution = lookForElement(nodeType,id,element);
						if(solution != null)
							return solution;						
					}
					return null;
				}
				
			}
			return null;
			
		}
		
	}
}