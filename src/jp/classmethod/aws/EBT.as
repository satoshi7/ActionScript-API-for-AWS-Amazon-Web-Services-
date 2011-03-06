package jp.classmethod.aws
{
	import com.adobe.utils.DateUtil;
	import com.hurlant.crypto.hash.HMAC;
	import com.hurlant.crypto.hash.SHA1;
	import com.hurlant.util.Base64;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestHeader;
	import flash.net.URLVariables;
	import flash.utils.ByteArray;
	
	import mx.formatters.DateFormatter;
	import mx.utils.ObjectUtil;
	import jp.classmethod.aws.core.AWSBase;
	import jp.classmethod.aws.core.AWSDateUtil;
	import jp.classmethod.aws.core.Parameter;

	/**
	 * AWS Elastic Beanstalk 
	 * @author satoshi
	 * 
	 */
	public class EBT extends AWSBase
	{
		public static const DESCRIBE_APPLICATIONS:String = "DescribeApplications";
		public static const DESCRIBE_APPLICATION_VERSIONS:String = "DescribeApplicationVersions";
		public static const DESCRIBE_CONFIGURATION_OPTIONS:String = "DescribeConfigurationOptions";
		public static const DESCRIBE_ENVIRONMENT_RESOURCES:String = "DescribeEnvironmentResources";
		public static const DESCRIBE_ENVIRONMENTS:String = "DescribeEnvironments";
		public static const DESCRIBE_EVENTS:String = "DescribeEvents";
		public static const LIST_AVAILABLE_SOLUTION_STACKS:String = "ListAvailableSolutionStacks";
		public static const CREATE_APPLICATION:String = "CreateApplication";
		public static const CREATE_ENVIRONMENT:String = "CreateEnvironment";
		
		public function EBT()
		{
			domainEndpoint="elasticbeanstalk.us-east-1.amazonaws.com";
			remoteRequestURL=protocol + _domainEndpoint + endPointURLExtendsion;
		}

		public function executeRequest(action:String, urlVariablesArr:Array=null, requestMethod:String="POST"):void
		{
			if(!urlVariablesArr){
				urlVariablesArr = new Array();
			}
			urlVariablesArr.push(new Parameter("Version", "2010-12-01"));
			urlVariablesArr.push(new Parameter("Action", action));
			urlVariablesArr.push(new Parameter("AWSAccessKeyId", _awsAccessKey));
			urlVariablesArr.push(new Parameter("Timestamp", AWSDateUtil.generateRequestTimeStamp(new Date())));
			//urlVariablesArr.push(new Parameter("Timestamp", DateUtil.toW3CDTF(new Date(),true)));

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
