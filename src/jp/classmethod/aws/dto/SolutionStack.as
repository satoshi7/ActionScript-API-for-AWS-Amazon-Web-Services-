package jp.classmethod.aws.dto
{
	[Bindable]public class SolutionStack
	{
		public var region:String;
		public var name:String;
		
		public function SolutionStack(xml:XML)
		{
			name = xml.*::name;
		}
	}
}