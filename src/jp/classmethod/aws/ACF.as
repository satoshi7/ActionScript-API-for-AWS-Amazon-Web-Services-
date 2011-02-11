package jp.classmethod.aws
{
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestHeader;
	import flash.net.URLVariables;
	
	import mx.utils.ObjectUtil;
	
	/**
	 * Amazon Simple Storage Service
	 * @author satoshi
	 * 
	 */
	public class ACF extends AWSBase
	{
		
		public static const GET:String = "GET";
		
		//endpoint option
		public static const US_EAST_1:String = "cloudfront.amazonaws.com";
		
		public function ACF(str:String=null) 
		{
			if(str != null){
				domainEndpoint=str;
			}else{
				domainEndpoint=ACF.US_EAST_1;
			}
			remoteRequestURL="https://" + _domainEndpoint + endPointURLExtendsion;
		}

		public function executeRequest(action:String=null, urlVariablesArr:Array=null, requestMethod:String="GET"):void
		{
			var dateString:String = AWSDateUtil.getHeaderDateString();
			
			urlVariablesArr.push(new Parameter("HTTP-Verb",requestMethod));
			urlVariablesArr.push(new Parameter("Date", dateString));
			var urlVariables:URLVariables=generateSignature(urlVariablesArr, 4, requestMethod);
			var auth:String = "AWS "+_awsAccessKey+":"+urlVariables.Signature;
			var request:URLRequest=new URLRequest(remoteRequestURL);
			
			request.method=requestMethod;
			
			var bucket:String = "";
			for (var j:int=0; j < urlVariablesArr.length; j++)
			{
				if (urlVariablesArr[j].key == "Bucket"){
					bucket = urlVariablesArr[j].value;
				}
			}

			var host:String = "cloudfront.amazonaws.com";
			var distribution:String = "/2010-11-01/distribution";
			
			var contentHeader:URLRequestHeader = new URLRequestHeader("Host",host);
			request.requestHeaders.push(contentHeader);
			var dateHeader:URLRequestHeader = new URLRequestHeader("Date",dateString);
			request.requestHeaders.push(dateHeader);
			var authheader:URLRequestHeader=new URLRequestHeader("Authorization",auth);
			request.requestHeaders.push(authheader);
			
			request.url = "https://" + host+distribution;
			
			trace(ObjectUtil.toString(request));
			
			var urlLoader:URLLoader=new URLLoader();
			urlLoader.addEventListener(Event.COMPLETE, handleRequest);
			urlLoader.addEventListener(IOErrorEvent.IO_ERROR, handleRequestIOError);
			urlLoader.load(request);		
		}
	}
}
