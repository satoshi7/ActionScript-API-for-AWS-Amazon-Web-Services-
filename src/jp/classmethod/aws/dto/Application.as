package jp.classmethod.aws.dto
{
	[Bindable]public class Application
	{
		public var region:String;
		public var Description:String;
		public var ApplicationName:String;
		public var DateCreated:String;
		public var DateUpdated:String;
		
		public function Application(xml:XML)
		{
			Description = xml.*::Description;
			ApplicationName = xml.*::ApplicationName;
			DateCreated = xml.*::DateCreated;
			DateUpdated = xml.*::DateUpdated;
		}
	}
}