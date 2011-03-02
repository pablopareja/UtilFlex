package com.era7.util.time
{
	public class TimerEstimator
	{
		
		
		/**
		 * 	Returns the estimated time in milliseconds
		 */
		public static function estimateUploadTime(fileSizeInBytes:int,speedInKBperSecond:Number):Number{
			
			var milliseconds:Number = Math.round(fileSizeInBytes/speedInKBperSecond);
			
			var estimatedTime:Date = new Date();
			estimatedTime.setTime(milliseconds);
			
			return estimatedTime.getTime();
		}

	}
}