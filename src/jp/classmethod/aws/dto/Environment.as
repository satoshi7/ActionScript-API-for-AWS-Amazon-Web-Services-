package jp.classmethod.aws.dto
{
	[Bindable]public class Environment
	{
		public var region:String;
		public var VersionLabel:String;
		public var Status:String;
		public var ApplicationName:String;
		public var EndpointURL:String;
		public var CNAME:String;
		public var Health:String;
		public var EnvironmentId:String;
		public var DateUpdated:String;
		public var SolutionStackName:String;
		public var Description:String;
		public var EnvironmentName:String;
		public var DateCreated:String;
		public var TemplateName:String;
		
		public function Environment(xml:XML)
		{
			VersionLabel = xml.*::VersionLabel;
			Status = xml.*::Status;
			ApplicationName = xml.*::ApplicationName;
			EndpointURL = xml.*::EndpointURL;
			CNAME = xml.*::CNAME;
			Health = xml.*::Health;
			EnvironmentId = xml.*::EnvironmentId;
			DateUpdated = xml.*::DateUpdated;
			SolutionStackName = xml.*::SolutionStackName;
			Description = xml.*::Description;
			EnvironmentName = xml.*::EnvironmentName;
			DateCreated = xml.*::DateCreated;
			TemplateName = xml.*::TemplateName;
		}
	}
}