package jp.classmethod.aws
{
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLVariables;
	
	/**
	 * Amazon Virtual Private Cloud
	 * @author satoshi
	 * 
	 */
	public class VPC extends AWSBase
	{
		
		public static const DESCRIBE_VPCS:String = "DescribeVpcs";
		public static const DESCRIBE_CUSTOMER_GATEWAYS:String = "DescribeCustomerGateways";
		
		
		//endpoint option
		public static const US_EAST_1:String = "ec2.us-east-1.amazonaws.com";
		public static const US_WEST_1:String = "ec2.us-west-1.amazonaws.com";
		public static const EU_WEST_1:String = "ec2.eu-west-1.amazonaws.com";
		public static const AP_SOUTHEAST_1:String = "ec2.ap-southeast-1.amazonaws.com";
		public static const AP_NORTHEAST_1:String = "ec2.ap-northeast-1.amazonaws.com";
		
		
		public function VPC(str:String=null) 
		{
			if(str != null){
				domainEndpoint=str;
			}else{
				domainEndpoint=VPC.US_EAST_1;
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
	}
}
