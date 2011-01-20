package jp.classmethod.aws
{
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLVariables;
	
	public class EC2 extends AWSBase
	{
		
		public static const DESCRIBE_INSTANCES:String = "DescribeInstances";
		public static const DESCRIVE_REGIONS:String = "DescribeRegions";

		public function EC2() 
		{
			domainEndpoint="ec2.amazonaws.com";
			remoteRequestURL=protocol + domainEndpoint + endPointURLExtendsion;
		}

		public function executeRequest(action:String, urlVariablesArr:Array=null, requestMethod:String="POST"):void
		{
			if(!urlVariablesArr){
				urlVariablesArr = new Array();
			}
			urlVariablesArr.push(new Parameter("Version", "2009-08-15"));
			urlVariablesArr.push(new Parameter("Action", action));
			urlVariablesArr.push(new Parameter("AWSAccessKeyId", _awsAccessKey));
			urlVariablesArr.push(new Parameter("Timestamp", generateRequestTimeStamp(new Date())));

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
