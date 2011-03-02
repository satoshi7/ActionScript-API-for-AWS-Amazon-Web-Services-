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
	
	/**
	 * Amazon Simple Email Service 
	 * @author satoshi
	 * 
	 */
	public class SES extends AWSBase
	{
		
		public static const LIST_VERIFIED_EMAIL_ADDRESSES:String = "ListVerifiedEmailAddresses";
		public static const SEND_EMAIL:String = "SendEmail";
		
		//endpoint option
		public static const US_EAST_1:String = "email.us-east-1.amazonaws.com";
		//public static const US_WEST_1:String = "email.us-west-1.amazonaws.com";
		
		
		public function SES(str:String=null) 
		{
			if(str != null){
				domainEndpoint=str;
			}else{
				domainEndpoint=SES.US_EAST_1;
			}
			remoteRequestURL=protocol + _domainEndpoint + endPointURLExtendsion;
		}

		public function executeRequest(action:String, urlVariablesArr:Array=null, requestMethod:String="POST"):void
		{
			var dateString:String = AWSDateUtil.getHeaderDateString();
			
			if(!urlVariablesArr){
				urlVariablesArr = new Array();
			}
			
			urlVariablesArr.push(new Parameter("Date", dateString));
			var urlVariables:URLVariables=generateSignature(urlVariablesArr, 3, requestMethod);
			var auth:String = "AWS3-HTTPS AWSAccessKeyId="+_awsAccessKey+", Algorithm=HmacSHA256, Signature="+urlVariables.Signature;
			var request:URLRequest=new URLRequest(remoteRequestURL);
			
			for each (var item:Parameter in urlVariablesArr){
				urlVariables[item.key]=item.value;
			}
			
			urlVariables["Action"] = action;
			request.data=urlVariables;
			request.method=requestMethod;
							
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
