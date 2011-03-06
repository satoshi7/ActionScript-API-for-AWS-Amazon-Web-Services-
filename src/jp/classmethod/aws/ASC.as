package jp.classmethod.aws
{
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLVariables;
	import jp.classmethod.aws.core.AWSBase;
	import jp.classmethod.aws.core.AWSDateUtil;
	import jp.classmethod.aws.core.Parameter;
	
	/**
	 * Auto Scaling 
	 * @author satoshi
	 * 
	 */
	public class ASC extends AWSBase
	{
		
		public static const DESCRIBE_SCALING_ACTIVITIES:String = "DescribeScalingActivities";
		
		//endpoint option
		public static const US_EAST_1:String = "autoscaling.us-east-1.amazonaws.com";
		public static const US_WEST_1:String = "autoscaling.us-west-1.amazonaws.com";
		public static const EU_WEST_1:String = "autoscaling.eu-west-1.amazonaws.com";
		public static const AP_SOUTHEAST_1:String = "autoscaling.ap-southeast-1.amazonaws.com";
		public static const AP_NORTHEAST_1:String = "autoscaling.ap-northeast-1.amazonaws.com";
		
		public function ASC(str:String=null) 
		{
			if(str != null){
				domainEndpoint=str;
			}else{
				domainEndpoint=ASC.US_EAST_1;
			}
			remoteRequestURL=protocol + _domainEndpoint + endPointURLExtendsion;
		}

		public function executeRequest(action:String, urlVariablesArr:Array=null, requestMethod:String="POST"):void
		{
			if(!urlVariablesArr){
				urlVariablesArr = new Array();
			}
			urlVariablesArr.push(new Parameter("Version", "2010-08-01"));
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
