package jp.classmethod.aws.dto
{
	[Bindable]public class Instance
	{
		public var region:String;
		public var tagName:String;
		public var instanceId:String;
		public var imageId:String;
		public var instanceType:String;
		public var instanceName:String;
		public var dnsName:String;
		public var launchTime:String;
		public var ipAddress:String;
		public var rootDeviceType:String;
		public var status:String;
		public var availabilityZone:String;
		
		public function Instance(xml:XML)
		{
			instanceId = xml.*::instanceId;
			imageId = xml.*::imageId;
			instanceType = xml.*::instanceType;
			instanceName = xml.*::instanceName;
			dnsName = xml.*::dnsName;
			launchTime = xml.*::launchTime;
			ipAddress = xml.*::ipAddress;
			rootDeviceType = xml.*::rootDeviceType;
			status = xml.*::instanceState.*::name;
			availabilityZone = xml.*::placement.*::availabilityZone;
		}
	}
}