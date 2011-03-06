package jp.classmethod.aws.core
{
	import flash.events.Event;
	
	import mx.collections.ArrayCollection;
	
	public class AWSEvent extends Event
	{
		// get xml object
		public var data:Object;
		// parsed ristrict object 
		public var list:ArrayCollection;
		
		public static const RESULT:String = "AWS_RESULT";
		
		public function AWSEvent(type:String, bubbles:Boolean = false,
								  cancelable:Boolean = false)
		{
			super(type, bubbles, cancelable);
		}
		
	}
}