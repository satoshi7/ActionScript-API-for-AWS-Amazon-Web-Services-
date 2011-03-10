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
	
	import jp.classmethod.aws.core.AWSBase;
	import jp.classmethod.aws.core.AWSDateUtil;
	import jp.classmethod.aws.core.AWSEvent;
	import jp.classmethod.aws.core.Parameter;
	import jp.classmethod.aws.dto.Application;
	import jp.classmethod.aws.dto.Environment;
	import jp.classmethod.aws.dto.SolutionStack;
	
	import mx.collections.ArrayCollection;

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
			this.action = action;
			if(!urlVariablesArr){
				urlVariablesArr = new Array();
			}
			urlVariablesArr.push(new Parameter("Version", "2010-12-01"));
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
		
		public override function handleRequest(event:Event):void{
			var data:XML = XML(event.currentTarget.data);
			var list:ArrayCollection = new ArrayCollection();
			var xmlList:XMLList;
			
			switch(action)
			{
				case DESCRIBE_ENVIRONMENTS:
				{
					xmlList = data.*::DescribeEnvironmentsResult.*::Environments.*::member;
					for each (var item:XML in xmlList) {
						var environment:Environment = new Environment(item);
						environment.region = this.domainEndpoint;
						list.addItem(environment);
					}
					break;
				}
				case DESCRIBE_APPLICATIONS:
				{
					xmlList = data.*::DescribeApplicationsResult.*::Applications.*::member;
					for each (var item2:XML in xmlList) {
						var app:Application = new Application(item2);
						app.region = this.domainEndpoint;
						list.addItem(app);
					}
					break;

				}
				case LIST_AVAILABLE_SOLUTION_STACKS:
				{
					xmlList = data.*::ListAvailableSolutionStacksResult.*::SolutionStacks.*::member;
					for each (var item3:XML in xmlList) {
						var sol:SolutionStack = new SolutionStack(item3);
						sol.region = this.domainEndpoint;
						list.addItem(sol);
					}
					break;
					
				}
					
				default:
				{
					trace("default");
					break;
				}
				trace("handleRequest");

			}

			var ae:AWSEvent = new AWSEvent(AWSEvent.RESULT);
			ae.data = event.currentTarget.data;
			ae.list = list;
			dispatchEvent(ae);
		}

	}
}
