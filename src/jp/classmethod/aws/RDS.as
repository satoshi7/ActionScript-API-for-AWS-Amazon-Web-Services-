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
	 * Amazon Relational Database Service 
	 * @author satoshi
	 * 
	 */
	public class RDS extends AWSBase
	{
		public static const DESCRIBE_DB_INSTANCES:String = "DescribeDBInstances";
		
		//endpoint option
		public static const US_EAST_1:String = "rds.us-east-1.amazonaws.com";
		public static const US_WEST_1:String = "rds.us-west-1.amazonaws.com";
		public static const EU_WEST_1:String = "rds.eu-west-1.amazonaws.com";
		public static const AP_SOUTHEAST_1:String = "rds.ap-southeast-1.amazonaws.com";
		
		public function RDS(str:String=null) 
		{
			if(str != null){
				domainEndpoint=str;
			}else{
				domainEndpoint=RDS.US_EAST_1;
			}
			remoteRequestURL=protocol + _domainEndpoint + endPointURLExtendsion;
		}
		public function executeRequest(action:String, urlVariablesArr:Array=null, requestMethod:String="POST"):void
		{
			if(!urlVariablesArr){
				urlVariablesArr = new Array();
			}
			urlVariablesArr.push(new Parameter("Version", "2009-10-16"));
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
			urlLoader.addEventListener(Event.COMPLETE, handleSimpleDBRequest);
			urlLoader.addEventListener(IOErrorEvent.IO_ERROR, handleSimpleDBRequestIOError);
			urlLoader.load(request);

			function handleSimpleDBRequest(event:Event):void
			{
				trace(event.currentTarget.data);
			}
			
			function handleSimpleDBRequestIOError(event:IOErrorEvent):void
			{
				trace(event.currentTarget.data);
			}

		}
	}
}
