package jp.classmethod.aws
{
	import com.hurlant.crypto.hash.HMAC;
	import com.hurlant.crypto.hash.SHA1;
	import com.hurlant.crypto.hash.SHA256;
	import com.hurlant.util.Base64;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.net.URLVariables;
	import flash.utils.ByteArray;
	
	/**
	 * base class
	 * @author satoshi
	 * 
	 */	
	public class AWSBase extends EventDispatcher
	{
		protected static var _awsAccessKey:String="";
		protected static var _awsSecretKey:String="";
		protected static var remoteRequestURL:String="";
		protected static var endPointURLExtendsion:String="/";
		protected static var protocol:String="https://";
		protected var _domainEndpoint:String="";
		protected static var signatureVersionToUse:int=2;
		
		public function AWSBase()
		{
			remoteRequestURL=protocol + _domainEndpoint + endPointURLExtendsion;
		}
		
		public function set domainEndpoint(name:String):void{
			this._domainEndpoint = name;
		}

		public function get domainEndpoint():String{
			return this._domainEndpoint;
		}
		
		protected function setSignatureVersion(sigVer:int):void
		{
			signatureVersionToUse=sigVer;
		}
		
		public function setAWSCredentials(accessKey:String, secretKey:String):void
		{
			_awsAccessKey=accessKey;
			_awsSecretKey=secretKey;
		}
		
		protected function generateSignature(urlVariablesArr:Array, sigVersion:int, requestMethod:String="POST"):URLVariables
		{
			var requestData:ByteArray=new ByteArray();
			var secretKeyAsBytes:ByteArray=new ByteArray();
			var urlVariables:URLVariables=new URLVariables();
			var strToSign:String="";
			
			var hmacEncrypter:HMAC=null;
			switch (sigVersion)
			{
				
				case 0:
					// for S3
					hmacEncrypter=new HMAC(new SHA1());
					var dateStr:String = "";
					var resourcesStr:String = "";
					var httpVerb:String = "";
					var bucket:String = "";
					var amzHeaders:String = "";
					
					for (var k:int=0; k < urlVariablesArr.length; k++)
					{
						if (urlVariablesArr[k].key == "Date"){
							dateStr = urlVariablesArr[k].value;
						}
						if (urlVariablesArr[k].key == "Resources"){
							resourcesStr = urlVariablesArr[k].value;
						}
						if (urlVariablesArr[k].key == "HTTP-Verb"){
							httpVerb = urlVariablesArr[k].value;
						}
						if (urlVariablesArr[k].key == "Bucket"){
							bucket = urlVariablesArr[k].value;
						}
					}
					strToSign += httpVerb+"\n";
					strToSign += "\n";
					strToSign += "\n";
					strToSign += dateStr+"\n";
					strToSign += "/"+bucket+resourcesStr;
					requestData.writeUTFBytes(strToSign);
					break;
				
				case 1: 
					break;
				
				case 2:
					// for EC2, CloudWatch, Import Export, Auto Scaling, Elastic Beanstalk, 
					//     Elastic Load Balancing, Elastic MapReduce, Identity and Access Management, 
					//     Relational Database Service, SimpleDB, Simple Notification Service,
					//     Simple Queue Service, Virtual Private Cloud, 
					hmacEncrypter=new HMAC(new SHA1());
					
					
					var accessKeyStr:String="";
					urlVariablesArr.push(new Parameter("SignatureVersion", sigVersion.toString()));
					urlVariablesArr.push(new Parameter("SignatureMethod", "HmacSHA1"));
					
					urlVariablesArr.sortOn("key", Array.CASEINSENSITIVE);
					
					for (var i:int=0; i < urlVariablesArr.length; i++)
					{
						urlVariables[urlVariablesArr[i].key]=urlVariablesArr[i].value;
						if (urlVariablesArr[i].key == "AWSAccessKeyId")
							accessKeyStr=urlVariablesArr[i].key + "=" + urlVariablesArr[i].value;
						else
							strToSign+="&" + urlVariablesArr[i].key + "=" + encodeURIComponent(urlVariablesArr[i].value);
					}
					strToSign=requestMethod + "\n" + _domainEndpoint + "\n" + endPointURLExtendsion + "\n" + accessKeyStr + strToSign;
					while (strToSign.indexOf("!") >= 0)
						strToSign=strToSign.replace("!", "%21");
					
					while (strToSign.indexOf("'") >= 0)
						strToSign=strToSign.replace("'", "%27");
					
					while (strToSign.indexOf("*") > 0)
						strToSign=strToSign.replace("*", "%2A");
					
					while (strToSign.indexOf("(") > 0)
						strToSign=strToSign.replace("(", "%28");
					
					while (strToSign.indexOf(")") > 0)
						strToSign=strToSign.replace(")", "%29");
					requestData.writeUTFBytes(strToSign);
					
					break;
				case 3:
					// for Route 53, Simple Email Service, 
					hmacEncrypter=new HMAC(new SHA256());
					for (var j:int=0; j < urlVariablesArr.length; j++)
					{
						if (urlVariablesArr[j].key == "Date"){
							strToSign = urlVariablesArr[j].value;
						}
					}
					requestData.writeUTFBytes(strToSign);
					
					break;
				case 4:
					// for CloudFront, 
					hmacEncrypter=new HMAC(new SHA1());
					for (var m:int=0; m < urlVariablesArr.length; m++)
					{
						if (urlVariablesArr[m].key == "Date"){
							strToSign = urlVariablesArr[m].value;
						}
					}
					requestData.writeUTFBytes(strToSign);
					
					break;
			}
			trace(requestData);
			secretKeyAsBytes.writeUTFBytes(_awsSecretKey);
			urlVariables.Signature=Base64.encodeByteArray(hmacEncrypter.compute(secretKeyAsBytes, requestData));
			return urlVariables;
		}
		
		public function handleRequest(event:Event):void
		{
			trace(event.currentTarget.data);
			var ae:AWSEvent = new AWSEvent(AWSEvent.RESULT);
			ae.data = event.currentTarget.data;
			dispatchEvent(ae);
		}
		
		public function handleRequestIOError(event:IOErrorEvent):void
		{
			trace(event.currentTarget.data);
			var ae:AWSEvent = new AWSEvent(AWSEvent.RESULT);
			ae.data = event.currentTarget.data;
			dispatchEvent(ae);
		}
	}
}

