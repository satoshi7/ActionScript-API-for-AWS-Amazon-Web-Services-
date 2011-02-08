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
	
	import mx.formatters.DateFormatter;
	import mx.resources.IResourceManager;
	import mx.resources.ResourceManager;
	
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
		protected var dateFormatter:DateFormatter;
		
		public function AWSBase()
		{
			dateFormatter=new DateFormatter();
			dateFormatter.formatString="YYYY-MM-DTJ:NN:SSZ";
			
			remoteRequestURL=protocol + _domainEndpoint + endPointURLExtendsion;
		}
		
		public function set domainEndpoint(name:String):void{
			this._domainEndpoint = name;
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
		
		protected function generateRequestTimeStamp(d:Date):String
		{
			var splitArr:Array=null;
			var splitArr2:Array=null;
			
			var dd:Date=new Date(d.getUTCFullYear(), d.getUTCMonth(), d.getUTCDate(), d.getUTCHours(), d.getUTCMinutes(), d.getUTCSeconds(), d.getUTCMilliseconds());
			var ds:String=dateFormatter.format(dd);
			
			if (d.getUTCHours() < 10)
			{
				splitArr=ds.split("T");
				var timeSplit:Array=splitArr[1].split(":");
				if (timeSplit[0].length < 2)
					ds=splitArr[0] + "T0" + splitArr[1];
			}
			
			if (d.getUTCDate() < 10)
			{
				splitArr=ds.split("T");
				
				splitArr2=splitArr[0].split("-");
				if (splitArr2[2].length < 2)
					ds=splitArr2[0] + "-" + splitArr2[1] + "-0" + splitArr2[2] + "T" + splitArr[1];
			}
			if (d.getMonth() < 10)
			{
				splitArr=ds.split("T");
				
				splitArr2=splitArr[0].split("-");
				if (splitArr2[1].length < 2)
					ds=splitArr2[0] + "-0" + splitArr2[1] + "-" + splitArr2[2] + "T" + splitArr[1];
			}
			return ds;
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
				
				case 1: //deprecated
					
					break;
				
				case 2:
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
					hmacEncrypter=new HMAC(new SHA256());
					for (var j:int=0; j < urlVariablesArr.length; j++)
					{
						if (urlVariablesArr[j].key == "Date"){
							strToSign = urlVariablesArr[j].value;
						}
					}
					//strToSign = urlVariablesArr["Date"].value;
					requestData.writeUTFBytes(strToSign);
					
					break;
			}
			secretKeyAsBytes.writeUTFBytes(_awsSecretKey);
			urlVariables.Signature=Base64.encodeByteArray(hmacEncrypter.compute(secretKeyAsBytes, requestData));
			return urlVariables;
		}
		
		public function getHeaderDateString():String{
			// example : Tue, 25 May 2010 21:20:27 +0000
						
			var d:Date = new Date();
			var utcd:Date = new Date(d.fullYearUTC,d.monthUTC,d.dateUTC,d.hoursUTC,d.minutesUTC,d.secondsUTC,d.millisecondsUTC);

			var str:String = getDateEEEString(utcd.getDay())
							+", "
							+utcd.getDate()
							+" "
							+getDateMMMString(utcd.getMonth())
							+" "
							+utcd.getFullYear()
							+" "
							+utcd.getHours()
							+":"
							+utcd.getMinutes()
							+":"
							+utcd.getSeconds()
							+" GMT";
			
			trace(str);
			return str;
		}
		
		public function getDateMMMString(month:int):String{
			
			var str:String;
			switch(month+1)
			{
				case 1: { str = "Jan"; break;}
				case 2: { str = "Feb"; break;}
				case 3: { str = "Mar"; break;}
				case 4: { str = "Apr"; break;}
				case 5: { str = "May"; break;}
				case 6: { str = "Jun"; break;}
				case 7: { str = "Jul"; break;}
				case 8: { str = "Aug"; break;}
				case 9: { str = "Sep"; break;}
				case 10: { str = "Oct"; break;}
				case 11: { str = "Nov"; break;}
				case 12: { str = "Dec"; break;}
				
				default:
				{
					break;
				}
			}
			return str;
		}

		public function getDateEEEString(day:int):String{
			
			var str:String;
			switch(day)
			{
				case 0: { str = "San"; break;}
				case 1: { str = "Mon"; break;}
				case 2: { str = "Tue"; break;}
				case 3: { str = "Wed"; break;}
				case 4: { str = "Thu"; break;}
				case 5: { str = "Fri"; break;}
				case 6: { str = "Sat"; break;}
					
				default:
				{
					break;
				}
			}
			return str;
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
		}
	}
}

