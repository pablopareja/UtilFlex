package com.era7.util.gui.tree
{
	public class Era7TreeError extends Error
	{
		
		public static const NO_NODE_SELECTED:String = "There is no node selected";
		
		public function Era7TreeError(message:String="", id:int=0)
		{
			super(message, id);
		}
		
	}
}