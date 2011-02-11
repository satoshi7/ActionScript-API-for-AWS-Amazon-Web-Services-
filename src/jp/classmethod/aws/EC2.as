package jp.classmethod.aws
{
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLVariables;
	
	/**
	 * Amazon Elastic Compute Cloud 
	 * @author satoshi
	 * 
	 */
	public class EC2 extends AWSBase
	{
		
		public static const DESCRIBE_INSTANCES:String = "DescribeInstances";
		public static const DESCRIBE_REGIONS:String = "DescribeRegions";
		public static const DESCRIBE_AVAILABILITY_ZONES:String = "DescribeAvailabilityZones";
		public static const DESCRIBE_BUNDLE_TASKS:String = "DescribeBundleTasks";
		public static const DESCRIBE_CONVERSION_TASKS:String = "DescribeConversionTasks";
		public static const DESCRIBE_KEY_PAIRS:String = "DescribeKeyPairs";
		public static const DESCRIBE_RESERVED_INSTANCES:String = "DescribeReservedInstances";
		public static const DESCRIBE_RESERVED_INSTANCES_OFFERINGS:String = "DescribeReservedInstancesOfferings";
		public static const DESCRIBE_SECURITY_GROUPS:String = "DescribeSecurityGroups";
		public static const DESCRIBE_SNAP_SHOTS:String = "DescribeSnapshots";
		public static const DESCRIBE_SPOT_DATA_FEED_SUBSCRIPTION:String = "DescribeSpotDatafeedSubscription";
		public static const DESCRIBE_SPOT_INSTANCE_REQUESTS:String = "DescribeSpotInstanceRequests";
		public static const DESCRIBE_SPOT_PRICE_HISTORY:String = "DescribeSpotPriceHistory";
		public static const DESCRIBE_TAGS:String = "DescribeTags";
		public static const DESCRIBE_VOLUMES:String = "DescribeVolumes";
		
		//endpoint option
		public static const US_EAST_1:String = "ec2.us-east-1.amazonaws.com";
		public static const US_WEST_1:String = "ec2.us-west-1.amazonaws.com";
		public static const EU_WEST_1:String = "ec2.eu-west-1.amazonaws.com";
		public static const AP_SOUTHEAST_1:String = "ec2.ap-southeast-1.amazonaws.com";
		
		public function EC2(str:String=null) 
		{
			if(str != null){
				domainEndpoint=str;
			}else{
				domainEndpoint=EC2.US_EAST_1;
			}
			remoteRequestURL=protocol + _domainEndpoint + endPointURLExtendsion;
		}

		public function executeRequest(action:String, urlVariablesArr:Array=null, requestMethod:String="POST"):void
		{
			if(!urlVariablesArr){
				urlVariablesArr = new Array();
			}
			urlVariablesArr.push(new Parameter("Version", "2009-08-15"));
			urlVariablesArr.push(new Parameter("Action", action));
			urlVariablesArr.push(new Parameter("AWSAccessKeyId", _awsAccessKey));
			urlVariablesArr.push(new Parameter("Timestamp", AWSDateUtil.generateRequestTimeStamp(new Date())));

			var urlVariables:URLVariables=generateSignature(urlVariablesArr, signatureVersionToUse, requestMethod);
			for each (var item:Parameter in urlVariablesArr)
				urlVariables[item.key]=item.value;

			var request:URLRequest=new URLRequest(remoteRequestURL);
			request.data=urlVariables;
			request.method=requestMethod;

			var urlLoader:URLLoader=new URLLoader();
			urlLoader.addEventListener(Event.COMPLETE, handleRequest);
			urlLoader.addEventListener(IOErrorEvent.IO_ERROR, handleRequestIOError);
			urlLoader.load(request);
		}
	}
}
