package jp.classmethod.aws
{
	import flash.events.Event;
	
	public class AWSEvent extends Event
	{
		public var data:Object;
		public static const RESULT:String = "AWS_RESULT";
		
		public function AWSEvent(type:String, bubbles:Boolean = false,
								  cancelable:Boolean = false)
		{
			super(type, bubbles, cancelable);
		}
		
	}
}