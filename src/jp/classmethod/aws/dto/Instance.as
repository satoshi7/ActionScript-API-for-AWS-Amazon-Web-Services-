package jp.classmethod.aws.dto
{
	[Bindable]public class Instance
	{
		public var region:String;
		public var tagName:String;
		public var instanceId:String;
		public var imageId:String;
		public var instanceType:String;
		public var instanceState:String;
		public var privateDnsName:String;
		public var dnsName:String;
		public var launchTime:String;
		public var ipAddress:String;
		public var rootDeviceType:String;
		public var status:String;
		public var availabilityZone:String;
		public var kernelId:String;
		public var monitoring:String;
		public var privateIpAddress:String;
		public var architecture:String;
		public var rootDeviceName:String;
		public var virtualizationType:String;
		public var clientToken:String;
		public var hypervisor:String;
		
		public function Instance(xml:XML)
		{
			tagName = xml.*::tagSet.*::item.*::value;
			instanceId = xml.*::instanceId;
			imageId = xml.*::imageId;
			instanceType = xml.*::instanceType;
			instanceState = xml.*::instanceState.*::name;
			privateDnsName = xml.*::privateDnsName;
			dnsName = xml.*::dnsName;
			launchTime = xml.*::launchTime;
			ipAddress = xml.*::ipAddress;
			rootDeviceType = xml.*::rootDeviceType;
			status = xml.*::instanceState.*::name;
			availabilityZone = xml.*::placement.*::availabilityZone;
			kernelId = xml.*::kernelId;
			monitoring = xml.*::monitoring.*::state;
			privateIpAddress = xml.*::privateIpAddress;
			architecture = xml.*::architecture;
			rootDeviceName = xml.*::rootDeviceName;
			virtualizationType = xml.*::virtualizationType;
			clientToken = xml.*::clientToken;
			hypervisor = xml.*::hypervisor;
		}
	}
}