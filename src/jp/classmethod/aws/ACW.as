package jp.classmethod.aws
{
	import com.hurlant.crypto.hash.HMAC;
	import com.hurlant.crypto.hash.SHA1;
	import com.hurlant.util.Base64;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLVariables;
	import flash.utils.ByteArray;
	
	import mx.formatters.DateFormatter;
	import mx.utils.ObjectUtil;

	/**
	 * Amazon CloudWatch 
	 * @author satoshi
	 * 
	 */	
	public class ACW extends AWSBase
	{
		
		public static const LIST_METRICS:String = "ListMetrics";
		public static const DESCRIBE_ALARMS:String = "DescribeAlarms";

		//endpoint option
		public static const US_EAST_1:String = "monitoring.amazonaws.com";
		public static const US_WEST_1:String = "monitoring.us-west-1.amazonaws.com";
		public static const EU_WEST_1:String = "monitoring.eu-west-1.amazonaws.com";
		public static const AP_SOUTHEAST_1:String = "monitoring.ap-southeast-1.amazonaws.com";
		public static const AP_NORTHEAST_1:String = "monitoring.ap-northeast-1.amazonaws.com";
		
		public function ACW(str:String=null) 
		{
			if(str != null){
				domainEndpoint=str;
			}else{
				domainEndpoint=ACW.US_EAST_1;
			}
			remoteRequestURL="http://" + _domainEndpoint + endPointURLExtendsion;
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
