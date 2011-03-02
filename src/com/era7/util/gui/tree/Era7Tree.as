package com.era7.util.gui.tree
{		
	import mx.binding.utils.BindingUtils;
	import mx.controls.*;
	import mx.events.ListEvent;  
		
	
	/**
	 * Tree class.
	 * @author Pablo Pareja Tobes
	 * 
	 */
	public class Era7Tree extends Tree
	{
		
		/**
		 *	Flag indicating whether not allowed nodes should be displayed differently from the allowed ones.
		 */
		public var distinguishNotAllowedNodes:Boolean = false;	
		/**
		 *	Flag indicating whether invisible nodes should be displayed differently from the rest.
		 */
		public var distinguishInvisibleNodes:Boolean = false;	
		/**
		 *	Flag indicating whether the first level nodes should be opened by default.
		 */
		public var openFirstLevelNodesFlag:Boolean = true;				
		
		protected var wholeXmlSource:XML;
		
		[Bindable]
		public var xmlSource:XML;
	
		/**
		 *	Default indentation for the tree icons 
		 */
		public const DEFAULT_INDENTATION:int = 30;	
		
		protected const NAVIGATION_ARRAY_LENGTH:Number = 10;
		protected var navigationCursor:int = -1;
		protected var navigationArray:Array;
		
		public var openItemsArray:Array = null;
		
		/**
		 * 	If true, the first node of the tree will automatically be selected when the source for the tree is assigned
		 */
		public var selectFirstNodeWhenRefreshing:Boolean = false;
		
		
		//-------------------------------ICONS-----------------------------------
		//-----------------------------------------------------------------------	
		/**
		 * 	Icon for nodes
		 */	
		[Bindable]
		public var nodeIcon:Class;
		/**
		 * 	Icon for not allowed nodes
		 */
		[Bindable]
		public var nodeNotAllowedIcon:Class;	
		
		/**
		 * 	Icon for invisible nodes
		 */	
		[Bindable]
		public var invisibleNodeIcon:Class;
		//-----------------------------------------------------------------------	
		//-----------------------------------------------------------------------
		
		//-------------------------------------
		/**
		 *  Nodes tag name
		 */	
		public var nodeTagName:String = "node";
				
		
		/**
		 * Constructor
		 */ 
		public function Era7Tree(){
			super();
			
			this.dataProvider = xmlSource;
			this.iconFunction = myiconfunction;
			
			
			this.addEventListener(ListEvent.ITEM_CLICK,itemClicked);
						
			//Binding the dataProvider property to the xmlsource var		
			BindingUtils.bindProperty(this, "dataProvider", this, "xmlSource");
						
			this.setStyle("indentation",DEFAULT_INDENTATION);
			
			this.horizontalScrollPolicy = "auto";
			this.variableRowHeight = true;
			this.wordWrap = true;
			
			this.showRoot = true;
						
			this.setStyle("openDuration","0");
			
			this.navigationArray = new Array();
		}
		
		/**
		 * 	Sets the indentation for the tree icons
		 */
		public function setIndentation(value:int):void{
			this.setStyle("indentation",value);
		}
		
		public function lowerSelectedNode():void{
			
			if(selectedItem != null){
				
				var selectedNode:XML = XML(selectedItem);
				var sourceCopy:XML = selectedNode.copy();				
				var index:int = selectedNode.childIndex();
				
				if(index != XML(selectedNode.parent()).elements().length() - 1){
					
					var followingSibling:XML = XML(selectedNode.parent()).children()[index+1];								
					
					//deleting the source node				
					var sourceNodeList:XMLList = selectedNode.parent().*.(@id == selectedNode.@id);					
					for(var j:int=0;j<sourceNodeList.length();j++){
						delete sourceNodeList[j];
					}
					
					XML(followingSibling.parent()).insertChildAfter(followingSibling,sourceCopy);
				}
						
			}
		}
		
		/**
		 * 	Replaces the selected item with 'value'
		 *  If keepChildren is true the children with tag name this.nodeTagName are not removed 
		 *  or replaced.
		 */
		public function replaceSelectedValue(value:XML,keepChildren:Boolean=false):void{
			if(selectedItem != null){
				replaceValue(XML(selectedItem).@id,value,keepChildren);
			}			
		}
		/**
		 * 	Replaces the item with id equals to 'destinationID' with the xml node 'value'
		 *  If keepChildren is true the children with tag name this.nodeTagName are not removed 
		 *  or replaced.
		 */
		public function replaceValue(destinationID:String, value:XML, keepChildren:Boolean=false):void{
			
			var list:XMLList = xmlSource..* + xmlSource;					
			var list2:XMLList = list.(@id == destinationID);			
			
			if(list2.length() == 1){
				
				var childrenBackUpList:XMLList = null;
				
				if(keepChildren){
					childrenBackUpList = list2.child(nodeTagName).copy();
				}
				
				if(list2.parent() == null){
					xmlSource = value;
					if(keepChildren){
						for(var i:int=0;i<childrenBackUpList.length();i++){
							xmlSource.appendChild(childrenBackUpList[i]);
						}
					}
				}else{
					list2[0] = value; 
					if(keepChildren){
						for(var j:int=0;j<childrenBackUpList.length();j++){
							list2[0].appendChild(childrenBackUpList[j]);
						}
					}
				}
			}
		}
		
		/**
		 * 
		 */
		public function raiseSelectedNode():void{
			if(selectedItem != null){
				
				var selectedNode:XML = XML(selectedItem);
				var sourceCopy:XML = selectedNode.copy();
				
				var index:int = selectedNode.childIndex();
				
				if(index != 0){
					
					var previousSibling:XML = XML(selectedNode.parent()).children()[index-1];					
					
					//deleting the source node				
					var sourceNodeList:XMLList = selectedNode.parent().*.(@id == selectedNode.@id);					
					for(var j:int=0;j<sourceNodeList.length();j++){
						delete sourceNodeList[j];
					}
					
					XML(previousSibling.parent()).insertChildBefore(previousSibling,sourceCopy);
				}
						
			}
		}
		
		/**
		 * 	Moves the node with id(as an attribute called 'id') to the selected node.
		 *  If there is no selected node, this method throws an error.
		 *  @param node_id Id of the node to be moved
		 *  @param prepend If true the node is moved as the first child of the selected node, 
		 *  		otherwise it will be added as the las child. 
		 *  @return True in case the specified node was found and could be moved to its destination, false otherwise.
		 */
		public function moveNodeAsChildOfSelectedNode(node_id:String,prepend:Boolean=true):Boolean{
			var parentID:String = XML(this.selectedItem).@id;
			if(parentID == null){
				return false;
			}else{
				return moveNodeAsChild(node_id,parentID,prepend);
			}			
					
		}	
		/**
		 * 	The node with id(as an attribute called 'id') is moved in order to be a sibling of the selected node.
		 *  If there is no selected node, this method throws an error.
		 *  @param insertBefore If true the node is inserted before the selected node, otherwise the node is inserted after.
		 *  @return True in case the specified node was found and moved to its destination, false otherwise.
		 */
		public function moveNodeAsSiblingOfSelectedNode(node_id:String,insertBefore:Boolean=true):Boolean{
			
			var siblingID:String = XML(this.selectedItem).@id;
			if(siblingID == null){
				return false;
			}else{
				return moveNodeAsSibling(node_id,siblingID,insertBefore);
			}
					
		}	
		
		/**
		 * 
		 * @param sourceId
		 * @param destinationId
		 * @return 
		 * 
		 */
		public function moveNodeAsChild(sourceId:String,destinationId:String,prepend:Boolean=true):Boolean{
			
			var sourceNode:XML = xmlSource..*.(@id == sourceId)[0];
			var destinationNode:XML = (xmlSource + xmlSource..*).(@id == destinationId)[0];
			
			if(sourceNode == null || destinationNode == null){
				return false;
			}else{
				var sourceCopy:XML = sourceNode.copy();
				
				//deleting the source node				
				var sourceNodeList:XMLList = sourceNode.parent().*.(@id == sourceId);					
				for(var j:int=0;j<sourceNodeList.length();j++){
					delete sourceNodeList[j];
				}
				
				if(prepend){
					destinationNode.prependChild(sourceCopy);
				}else{
					destinationNode.appendChild(sourceCopy);
				}				
																			
				return true;
			}
			
		}
		/**
		 *  The node with id sourceId is moved in order to be a sibling of the node with id destinationId. 
		 *  @param sourceId ID of the source node
		 *  @param destinationId ID of the destination node, <i>(which will be the sibling of the source node after the call to this method)</i>
		 *  @param before True --> the node is inserted before the destination node, False --> the node is inserted after the destination node
		 *  @return True in case the specified node was found and could be moved to its destination, false otherwise.
		 * 
		 */
		public function moveNodeAsSibling(sourceId:String,destinationId:String,before:Boolean):Boolean{
			
			var sourceNode:XML = xmlSource..*.(@id == sourceId)[0];
			var destinationNode:XML = xmlSource..*.(@id == destinationId)[0];
			
			if(sourceNode == null || destinationNode == null){
				return false;
			}else{
				var sourceCopy:XML = sourceNode.copy();
				
				//deleting the source node				
				var sourceNodeList:XMLList = sourceNode.parent().*.(@id == sourceId);					
				for(var j:int=0;j<sourceNodeList.length();j++){
					delete sourceNodeList[j];
				}
				
				var parent:XML = destinationNode.parent();
				
				if(before){
					parent.insertChildBefore(sourceCopy,destinationNode);
				}else{
					parent.insertChildAfter(sourceCopy,destinationNode);
				}				
																			
				return true;
			}
		}
		
		/**
		 *  Adds the node 'node' to the selected node.
		 *  <b> <i>If there is no node selected the method throws an error</i>
		 *  @param node Node to be added
		 */
		public function addNodeAsChildOfSelectedNode(node:XML):void{
			
			if(selectedItem == null){
				throw new Era7TreeError(Era7TreeError.NO_NODE_SELECTED);
			}else{							
				XML(selectedItem).appendChild(node);			
				validateNow();
				dispatchEvent(new Era7TreeEvent(Era7TreeEvent.NODE_ADDED,node));
			}			
		}	
		/**
		 *  Adds the node 'node' as the upper sibling of the selected node.
		 *  <b> <i>If there is no node selected the method throws an error</i>
		 *  @param node Node to be added
		 */
		public function addNodeAsUpperSiblingOfSelectedNode(node:XML):void{
			
			if(this.selectedItem == null){
				throw new Era7TreeError(Era7TreeError.NO_NODE_SELECTED);
			}else{							
				XML(XML(selectedItem).parent()).insertChildBefore(XML(selectedItem),node);		
				validateNow();
				dispatchEvent(new Era7TreeEvent(Era7TreeEvent.NODE_ADDED,node));
			}			
		}
		/**
		 *  Adds the node 'node' as the lower sibling of the selected node.
		 *  <b> <i>If there is no node selected the method throws an error</i>
		 *  @param node Node to be added
		 */
		public function addNodeAsLowerSiblingOfSelectedNode(node:XML):void{
			
			if(this.selectedItem == null){
				throw new Era7TreeError(Era7TreeError.NO_NODE_SELECTED);
			}else{							
				XML(XML(selectedItem).parent()).insertChildAfter(XML(selectedItem),node);		
				validateNow();
				dispatchEvent(new Era7TreeEvent(Era7TreeEvent.NODE_ADDED,node));
			}			
		}
		
		/**
		 * 	Deletes the node with id equals to 'id' param. (id must be an attribute called 'id')
		 *  <i>The id value is supposed to be unique</i> 
		 *  <b> <i>The root node cannot be deleted</i>
		 *  @param id ID of the node to be deleted
		 *  @return True in case the specified node was found and deleted, false otherwise.
		 */
		public function deleteNode(id:String):Boolean{
			
			var temp:XML = this.xmlSource..*.(@id == id)[0];				
			
			if(temp != null){
				delete temp.parent().*.(@id == id)[0];
				
				return true;
			}else{
				return false;
			}	
		}
		/**
		 * 	Deletes the selected node (the node selected must have an id attribute)
		 *  <b> <i>The id value is supposed to be unique</i> 
		 *  <b> <i>The root node cannot be deleted</i>
		 *  @return True in case the specified node was found and deleted, false otherwise.
		 */
		public function deleteSelectedNode():Boolean{
			
			if(this.selectedItem == null){
				throw new Era7TreeError(Era7TreeError.NO_NODE_SELECTED);
				return false;
			}else{
				var tempID:String = XML(this.selectedItem).@id;
				delete XML(this.selectedItem).parent().*.(@id == tempID)[0];
				return true;
			}
		}
		
		
		/**
		 *  Closes every branch of the tree starting from the specified node
		 *  If no xml is passed as an argument, the whole tree will be closed.
		 *  @param xml Tree node from which the different branches of the tree will be closed
		 */
		public function closeEveryBranchFrom(xml:XML=null):void{
			
			if(xml==null){
				closeEveryBranchFrom(xmlSource);
			}else{
				this.expandItem(xml,false,false);
				this.expandChildrenOf(xml,false);
				for each (var element:XML in xml.elements()){								
					closeEveryBranchFrom(element);						
				}
			}			
		}		
		/**
		 *  Expands every branch of the tree starting from the specified node
		 *  If no xml is passed as an argument, every branch of the tree will be opened.
		 *  @param xml Tree node from which the differente branches of the tree will be opened. 
		 */
		public function expandEveryBranchFrom(xml:XML=null):void{
			
			if(xml==null)
				xml = xmlSource;
				
			var list:XMLList = xml+xml..*;
			var tempArray:Array = new Array();
			
			for each(var elem:XML in list){					
			   	tempArray.push(elem);				    
			}
			
			openItems = openItems.concat(tempArray);
			validateNow();					
			
		}
		
		/**
		 *  Expands the selected node.
		 *  <b><i>If there is no node selected the method throws an error</i>
		 */
		public function expandSelectedItem():void{
			if(this.selectedItem == null){
				throw new Era7TreeError(Era7TreeError.NO_NODE_SELECTED);
			}else{
				expandItem(XML(this.selectedItem),true,false);	
			}					
		}
		
		/**
		 *  Expands every branch from the selected node.
		 *  <b><i>If there is no node selected the method throws an error</i>
		 */
		public function expandEveryBranchFromSelectedItem():void{
			if(this.selectedItem == null){
				throw new Era7TreeError(Era7TreeError.NO_NODE_SELECTED);
			}else{
				expandEveryBranchFrom(XML(this.selectedItem));	
			}					
		}
		
		/**
		 *  Closes every branch from the selected node.
		 *  <b><i>If there is no node selected the method throws an error</i>
		 */
		public function closeEveryBranchFromSelectedItem():void{
			if(this.selectedItem == null){
				throw new Era7TreeError(Era7TreeError.NO_NODE_SELECTED);
			}else{
				closeEveryBranchFrom(XML(this.selectedItem));	
			}					
		}
		
		
		/**
		 *  Changes the view of the tree displaying only the descendants of the selected node
		 *  <b><i>If there is no node selected the method throws an error</i>
		 */
		public function showFromSelectedItem():void{
			
			if(selectedItem == null){
				throw new Era7TreeError(Era7TreeError.NO_NODE_SELECTED);
			}else{				
				xmlSource = XML(this.selectedItem);
				
				validateNow();
				
				if(openFirstLevelNodesFlag){
					callLater(openFirstLevelNodes);
				}
				
			}			
		}
		
		/**
		 *  Changes the view of the tree displaying every node from the main root.
		 */
		public function showFromMainRoot():void{
			xmlSource = wholeXmlSource.copy();
			validateNow();
			
			if(openItemsArray == null){
				callLater(openFirstLevelNodes);					
			}else{
				callLater(refreshOpenItemsState);					
			}
		} 		
		
		
		/**
		 *  Sets the attribute label field for the tree, specifying the attribute from which the tree
		 *  will take the labels for the nodes to be displayed.
		 */
		public function setAttributeLabelField(value:String):void{
			this.labelField = "@" + value;
		}
		
		/**
		 *  Method to manage the requests derived from the selection of different
		 *  nodes in the tree visualization.
		 */
		protected function itemClicked(event:ListEvent):void{			
			if(selectedItem != null){								
				this.dispatchEvent(new Era7TreeEvent(Era7TreeEvent.NODE_SELECTED,new XML(this.selectedItem),true));	
				this.addElementToNavigationArray(XML(this.selectedItem).@id);				
			}					
		}
		
		/**
		 *  Sets the xml source for the tree visualization
		 */
		public function setXMLSource(xml:XML):void{
			
			xmlSource = xml.copy();
			wholeXmlSource = xml.copy();
			
			validateNow();
			
			//----Initializing the navigation array and the cursor----			
			navigationArray = new Array();
			navigationCursor = -1;
			//-------------------------------------------------------			
			
			if(openItemsArray == null){
				callLater(openFirstLevelNodes);					
			}else{
				callLater(refreshOpenItemsState);					
			}		
			
			if(this.selectFirstNodeWhenRefreshing){
				callLater(selectFirstNode);
			}
		}
		/**
		 * 	Open first level nodes
		 */
		private function openFirstLevelNodes():void{
			this.expandItem(this.xmlSource.*[0],true,false);			
		}
		/**
		 * 	Select first node
		 */
		public function selectFirstNode():void{
			this.selectedIndex = 0;
			
			this.dispatchEvent(new Era7TreeEvent(Era7TreeEvent.NODE_SELECTED,XML(this.selectedItem),true,true));
								
			this.addElementToNavigationArray(XML(this.selectedItem).@id);	
		}
		
		/**
		 * Method overriding the icon function of the class in order to personalize the 
		 * icons showed in the visualization.
		 * 
		 */
		protected function myiconfunction(item:Object):Class{
						  
			var temp:XML = new XML(item);  
            var allowed:String = temp.@allowed;  
            var visible:String = temp.@visible;
                                  
            if(distinguishNotAllowedNodes && allowed == "false"){            	
            	return this.nodeNotAllowedIcon;            	            	
            }
            
            if(distinguishInvisibleNodes && visible == "false"){
            	return this.invisibleNodeIcon;
            } 
            
            return this.nodeIcon;       
        }
        /**
        * 	Update open items array
        */
        public function updateOpenItemsArray():void{
        	openItemsArray = new Array();
        	for each(var element:* in this.openItems){
        		openItemsArray.push(String(XML(element).@id));
        	}
        }
        /**
        * 	Set open items array
        */
       	public function setOpenItemsArray(value:Array):void{      		
       		this.openItemsArray = value;
       		this.refreshOpenItemsState();
       	}
        /**
        * 	Refresh open items state
        */
        public function refreshOpenItemsState():void{        	
        	
        	if(openItemsArray.indexOf(String(this.xmlSource.@id)) != -1){
        		this.expandItem(this.xmlSource,true,false);        		
        	}
        	        	
        	for each(var element:* in this.xmlSource..*){
        		if(openItemsArray.indexOf(String(XML(element).@id)) != -1){
        			this.expandItem(element,true,false);        			
        		}
        	}
        }                
        
        /**
      	 * 	Add element to navigation array
      	 */
      	public function addElementToNavigationArray(id:String):void{
      		this.navigationArray.push(id);
      		this.navigationCursor++;
      		if(this.navigationArray.length > this.NAVIGATION_ARRAY_LENGTH){
      			this.navigationArray.pop();
      		}      		
      	}
      	/**
      	 * 	Navigate back
      	 */
      	public function navigateBack():void{      		
      		
      		if(navigationArray.length > 1 && navigationCursor > 0){
      			this.goToItem(String(navigationArray[navigationCursor-1]));
      			navigationCursor--;
      		}
      	}
      	/**
      	 * 	Navigate forth
      	 */
      	public function navigateForth():void{    		
      		
      		if(navigationArray.length > 1 && navigationCursor < navigationArray.length-1 ){
      			this.goToItem(String(navigationArray[navigationCursor+1]));
      			navigationCursor++;
      		}
      	}
      	/**
      	 * 	Navigate to start
      	 */
      	public function navigateToStart():void{      		
      		this.goToItem(String(navigationArray[0]));
      		navigationCursor=0;      		
      	}
      	/**
      	 * 	Go to item
      	 */
      	public function goToItem(id:String,addToNavigationArray:Boolean=false):void{
      		
      		
      		
      		var element:XML = (xmlSource..* + xmlSource).(@id == id)[0];
      		
      		if(element != null){
      			
      			var valueParent:XML = element.parent();   
      			var elementsToOpen:Array = new Array(); 
      			 			
      			while(valueParent != null){
      				     				
	      			if(!this.isItemOpen(valueParent)){   
	      				elementsToOpen.push(valueParent);	      				
	      			}
	      			valueParent = valueParent.parent();
      			}
      			
      			for each(var elem:XML in elementsToOpen){
	      			this.expandItem(elem,true,false);
	      		}     			
      			
      			this.selectedIndex = this.getItemIndex(element);
      			this.validateNow();
      			
      			
      			this.dispatchEvent(new Era7TreeEvent(Era7TreeEvent.NODE_SELECTED,XML(this.selectedItem),true));		
      			
      			   			
      			this.scrollToIndex(this.selectedIndex);
      			
      			if(addToNavigationArray){
      				//We add the element to the history of accessed elements so that it
      				//will be taken into account for the navigateBack and navigateForth methods
      				this.addElementToNavigationArray(id);
      			}
      		}
      	}
		/**
		 * 	Gets the selected node id
		 */
		public function getSelectedNodeID():String{
			if(this.selectedItem == null){
				throw new Era7TreeError(Era7TreeError.NO_NODE_SELECTED);
			}else{
				return String(this.selectedItem.@id);
			}			
		}	
		
			
	}
}