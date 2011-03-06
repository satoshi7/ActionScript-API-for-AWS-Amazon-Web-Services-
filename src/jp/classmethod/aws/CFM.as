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
	 * Amazon Elastic Compute Cloud 
	 * @author satoshi
	 * 
	 */
	public class CFM extends AWSBase
	{
		public static const CREATE_STACK:String = "CreateStack";
		public static const DELETE_STACK:String = "DeleteStack";
		public static const DESCRIBE_STACK_EVENTS:String = "DescribeStackEvents";
		public static const DESCRIBE_STACKS:String = "DescribeStacks";
		public static const DESCRIBE_STACK_RESOURCES:String = "DescribeStackResources";
		public static const GET_TEMPLATE:String = "GetTemplate";
		public static const VALIDATE_TEMPLATE:String = "ValidateTemplate";
		
		//endpoint option
		public static const US_EAST_1:String = "cloudformation.us-east-1.amazonaws.com";
		public static const US_WEST_1:String = "cloudformation.us-west-1.amazonaws.com";
		public static const EU_WEST_1:String = "cloudformation.eu-west-1.amazonaws.com";
		public static const AP_SOUTHEAST_1:String = "cloudformation.ap-southeast-1.amazonaws.com";
		public static const AP_NORTHEAST_1:String = "cloudformation.ap-northeast-1.amazonaws.com";
		
		
		public function CFM(str:String=null) 
		{
			if(str != null){
				domainEndpoint=str;
			}else{
				domainEndpoint=CFM.US_EAST_1;
			}
			remoteRequestURL=protocol + _domainEndpoint + endPointURLExtendsion;
		}

		public function executeRequest(action:String, urlVariablesArr:Array=null, requestMethod:String="POST"):void
		{
			if(!urlVariablesArr){
				urlVariablesArr = new Array();
			}
			urlVariablesArr.push(new Parameter("Version", "2010-05-15"));
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
