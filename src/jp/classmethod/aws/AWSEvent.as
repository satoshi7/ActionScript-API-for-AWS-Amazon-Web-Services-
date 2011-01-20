package jp.classmethod.aws
{
	import flash.events.Event;
	
	import mx.events.FlexEvent;

	public class AWSEvent extends FlexEvent
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