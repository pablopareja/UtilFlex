package com.era7.util.date
{	
	public class DateSortingUtility
	{
		
		import mx.utils.ObjectUtil;
		import mx.controls.Alert;

        public static function date_sortCompareFunc(itemA:String, itemB:String):int {
        	   /* Date.parse() returns an int, but
                   ObjectUtil.dateCompare() expects two
                   Date objects, so convert String to
                   int to Date. */
            var dateA:Date = DateSortingUtility.convertStringToDate(itemA);            
            var dateB:Date = DateSortingUtility.convertStringToDate(itemB);           
            
            return ObjectUtil.dateCompare(dateA, dateB);
        }
        
        
        private static function convertStringToDate(value:String):Date{
        	var date:Date = new Date();
        	date.setFullYear(value.substr(6,4),value.substr(3,2),value.substr(0,2));
        	  	
        	date.setHours(value.substr(11,2),value.substr(14,2),value.substr(17,2),0);     
        	
        	return date;
        }

		
	}
}
