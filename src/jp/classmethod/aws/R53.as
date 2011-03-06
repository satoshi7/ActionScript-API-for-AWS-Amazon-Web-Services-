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
	 * Amazon Route 53
	 * @author satoshi
	 * 
	 */
	public class R53 extends AWSBase
	{
		//endpoint option
		public static const US_EAST_1:String = "route53.amazonaws.com";
		
		public function R53(str:String=null) 
		{
			if(str != null){
				domainEndpoint=str;
			}else{
				domainEndpoint=R53.US_EAST_1;
			}
			remoteRequestURL=protocol + _domainEndpoint + endPointURLExtendsion;
		}

		public function executeRequest(action:String=null, urlVariablesArr:Array=null, requestMethod:String="GET"):void
		{
			var dateString:String = AWSDateUtil.getHeaderDateString();
			
			if(!urlVariablesArr){
				urlVariablesArr = new Array();
			}
			
			urlVariablesArr.push(new Parameter("Date", dateString));
			var urlVariables:URLVariables=generateSignature(urlVariablesArr, 3, requestMethod);
			var auth:String = "AWS3-HTTPS AWSAccessKeyId="+_awsAccessKey+", Algorithm=HmacSHA256, Signature="+urlVariables.Signature;
			var request:URLRequest=new URLRequest(remoteRequestURL);
			
			request.data=urlVariables;
			request.method=requestMethod;
				
			var hostzone:String = "/2010-10-01/hostedzone";
			request.url = protocol+_domainEndpoint+hostzone;
			
			var hostHeader:URLRequestHeader = new URLRequestHeader("Host",_domainEndpoint);
			request.requestHeaders.push(hostHeader);
							
			var contentHeader:URLRequestHeader = new URLRequestHeader("Content-Type","application/x-www-form-urlencoded");
			request.requestHeaders.push(contentHeader);
			var dateHeader:URLRequestHeader = new URLRequestHeader("Date",dateString);
			request.requestHeaders.push(dateHeader);
			var authheader:URLRequestHeader=new URLRequestHeader("X-Amzn-Authorization",auth);
			request.requestHeaders.push(authheader);
			
			var urlLoader:URLLoader=new URLLoader();
			urlLoader.addEventListener(Event.COMPLETE, handleRequest);
			urlLoader.addEventListener(IOErrorEvent.IO_ERROR, handleRequestIOError);
			urlLoader.load(request);
		}
		
	}
}
