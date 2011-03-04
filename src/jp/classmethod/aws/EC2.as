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
		public static const DESCRIBE_IMAGES:String = "DescribeImages";
		public static const DESCRIBE_IMAGE_ATTRIBUTE:String = "DescribeImageAttribute";
		public static const RUN_INSTANCES:String = "RunInstances";
		public static const TERMINATE_INSTANCES:String = "TerminateInstances";
		public static const START_INSTANCES:String = "StartInstances";
		public static const STOP_INSTANCES:String = "StopInstances";
		public static const CREATE_TAGS:String = "CreateTags";
		
		//endpoint option
		public static const US_EAST_1:String = "ec2.us-east-1.amazonaws.com";
		public static const US_WEST_1:String = "ec2.us-west-1.amazonaws.com";
		public static const EU_WEST_1:String = "ec2.eu-west-1.amazonaws.com";
		public static const AP_SOUTHEAST_1:String = "ec2.ap-southeast-1.amazonaws.com";
		public static const AP_NORTHEAST_1:String = "ec2.ap-northeast-1.amazonaws.com";
		
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
			urlVariablesArr.push(new Parameter("Version", "2010-11-15"));
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
		
		public function runInstances(amiId:String,minCount:int=1,maxCount:int=1,keyName:String=null,instanceType:String=null):void{
			var vals:Array = new Array();
			vals.push(new Parameter("ImageId",amiId));
			vals.push(new Parameter("MinCount",minCount.toString()));
			vals.push(new Parameter("MaxCount",maxCount.toString()));
			if(keyName!=null)vals.push(new Parameter("KeyName",keyName));
			if(instanceType!=null)vals.push(new Parameter("InstanceType",instanceType));
			this.executeRequest(EC2.RUN_INSTANCES,vals);
		}
		public function createTags(instanceId:String,key:String,value:String):void{
			var vals:Array = new Array();
			vals.push(new Parameter("ResourceId.1",instanceId));
			vals.push(new Parameter("Tag.1.Key",key));
			vals.push(new Parameter("Tag.1.Value",value));
			this.executeRequest(EC2.CREATE_TAGS,vals);
		}
	}
}
