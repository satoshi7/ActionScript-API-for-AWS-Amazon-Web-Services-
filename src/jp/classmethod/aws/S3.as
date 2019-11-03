package jp.classmethod.aws
{
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestHeader;
	import flash.net.URLVariables;
	
	import mx.utils.ObjectUtil;
	import jp.classmethod.aws.core.AWSBase;
	import jp.classmethod.aws.core.AWSDateUtil;
	import jp.classmethod.aws.core.Parameter;
	
	/**
	 * Amazon Simple Storage Service
	 * @author satoshi
	 * 
	 */
	public class S3 extends AWSBase
	{
		
		public static const GET:String = "GET";
		
		//endpoint option
		public static const US_EAST_1:String = "s3.amazonaws.com";
		public static const US_WEST_1:String = "s3-us-west-1.amazonaws.com";
		public static const EU_WEST_1:String = "s3-eu-west-1.amazonaws.com";
		public static const AP_SOUTHEAST_1:String = "s3-ap-southeast-1.amazonaws.com";
		public static const AP_NORTHEAST_1:String = "s3-ap-northeast-1.amazonaws.com";
		
		
		public function S3(str:String=null) 
		{
			if(str != null){
				domainEndpoint=str;
			}else{
				domainEndpoint=S3.US_EAST_1;
			}
			remoteRequestURL="http://" + _domainEndpoint + endPointURLExtendsion;
		}

		public function executeRequest(action:String=null, urlVariablesArr:Array=null, requestMethod:String="GET"):void
		{
			var dateString:String = AWSDateUtil.getHeaderDateString();
			var bucket:String = "", resources:String = "";
			for (var j:int=0; j < urlVariablesArr.length; j++)
			{
				if (urlVariablesArr[j].key == "Bucket"){
					bucket = urlVariablesArr[j].value;
				}
				if (urlVariablesArr[j].key == "Resources"){
					resources = urlVariablesArr[j].value;
				}
			}
			var host:String = "s3.amazonaws.com";
			if(bucket != ""){
				host = bucket+"."+host;
			}

			urlVariablesArr.push(new Parameter("HTTP-Verb",requestMethod));
			urlVariablesArr.push(new Parameter("Date", dateString));
			if (requestMethod == "PUT" || requestMethod == "POST") urlVariablesArr.push(new Parameter("Content-Type", "multipart/form-data"));
			var urlVariables:URLVariables=generateSignature(urlVariablesArr, 0, requestMethod);
			var auth:String = "AWS "+_awsAccessKey+":"+urlVariables.Signature;
			var request:URLRequest=new URLRequest(remoteRequestURL+resources);
			
			request.method=requestMethod;

			var contentHeader:URLRequestHeader = new URLRequestHeader("Host",host);
			request.requestHeaders.push(contentHeader);
			var dateHeader:URLRequestHeader = new URLRequestHeader("Date",dateString);
			request.requestHeaders.push(dateHeader);
			var authheader:URLRequestHeader=new URLRequestHeader("Authorization",auth);
			request.requestHeaders.push(authheader);
			var contentType:URLRequestHeader=new URLRequestHeader("Content-Type","multipart/form-data");
			if (requestMethod == "PUT" || requestMethod == "POST") request.requestHeaders.push(contentType);
			
			if (action) request.data = action

			trace(ObjectUtil.toString(request));
			
			var urlLoader:URLLoader=new URLLoader();
			urlLoader.addEventListener(Event.COMPLETE, handleRequest);
			urlLoader.addEventListener(IOErrorEvent.IO_ERROR, handleRequestIOError);
			urlLoader.load(request);		
		}
	}
}
