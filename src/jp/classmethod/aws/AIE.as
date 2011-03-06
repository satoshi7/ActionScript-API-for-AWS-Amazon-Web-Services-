package jp.classmethod.aws
{
	import com.hurlant.util.Base64;
	
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestHeader;
	import flash.net.URLVariables;
	
	import mx.formatters.DateFormatter;
	import mx.utils.ObjectUtil;
	import jp.classmethod.aws.core.AWSBase;
	import jp.classmethod.aws.core.AWSDateUtil;
	import jp.classmethod.aws.core.Parameter;
	
	/**
	 * Amazon Import Export
	 * @author satoshi
	 * 
	 */
	public class AIE extends AWSBase
	{
		
		public static const LIST_JOBS:String = "ListJobs";
		
		//endpoint option
		public static const US_EAST_1:String = "importexport.amazonaws.com";
		
		public function AIE(str:String=null) 
		{
			if(str != null){
				domainEndpoint=str;
			}else{
				domainEndpoint=AIE.US_EAST_1;
			}
			remoteRequestURL=protocol + _domainEndpoint + endPointURLExtendsion;
		}

		public function executeRequest(action:String, urlVariablesArr:Array=null, requestMethod:String="POST"):void
		{
			if(!urlVariablesArr){
				urlVariablesArr = new Array();
			}

			var dateString:String = AWSDateUtil.getHeaderDateString();
			urlVariablesArr.push(new Parameter("AWSAccessKeyId", _awsAccessKey));
			urlVariablesArr.push(new Parameter("Operation", action));
			urlVariablesArr.push(new Parameter("Timestamp", AWSDateUtil.generateRequestTimeStamp(new Date())));
			
			var urlVariables:URLVariables=generateSignature(urlVariablesArr, 2, requestMethod);
			var request:URLRequest=new URLRequest(remoteRequestURL);
			
			for each (var item:Parameter in urlVariablesArr){
				urlVariables[item.key]=item.value;
			}
			
			urlVariables["Operation"] = action;
			request.data=urlVariables;
			request.method=requestMethod;
			var host:String = protocol+"importexport.amazonaws.com";

			request.url = host;
							
			var contentHeader:URLRequestHeader = new URLRequestHeader("content-type","application/x-www-form-urlencoded;charset=utf-8");
			request.requestHeaders.push(contentHeader);
			var hostHeader:URLRequestHeader = new URLRequestHeader("host",host);
			request.requestHeaders.push(hostHeader);
			trace(ObjectUtil.toString(request));
			
			var urlLoader:URLLoader=new URLLoader();
			urlLoader.addEventListener(Event.COMPLETE, handleRequest);
			urlLoader.addEventListener(IOErrorEvent.IO_ERROR, handleRequestIOError);
			urlLoader.load(request);
		}
		
	}
}
