package jp.classmethod.aws.core
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
	 * dateutil class
	 * @author satoshi
	 * 
	 */	
	public class AWSDateUtil
	{
		public static function generateRequestTimeStamp(d:Date):String
		{
			var splitArr:Array=null;
			var splitArr2:Array=null;
			
			var dd:Date=new Date(d.getUTCFullYear(), d.getUTCMonth(), d.getUTCDate(), d.getUTCHours(), d.getUTCMinutes(), d.getUTCSeconds(), d.getUTCMilliseconds());
			var ds:String=getSignatureDateString(dd);

			//trace(ds);
			return ds;
		}
				
		public static function getHeaderDateString():String{
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
			
			return str;
		}
		
		public static function getDateMMMString(month:int):String{
			
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

		public static function getDateEEEString(day:int):String{
			
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

		public static function getSignatureDateString(date:Date):String{
			//YYYY-MM-DTJ:NN:SSZ
			var ds:String = "";
			ds += date.getFullYear().toString();
			ds += "-";
			if(date.getMonth()+1<10)ds+="0";
			ds += (date.getMonth()+1).toString();
			ds += "-";
			if(date.getDate()<10)ds+="0";
			ds += date.getDate().toString();
			ds += "T";
			if(date.getHours()<10)ds+="0";
			ds += date.getHours().toString();
			ds += ":";
			if(date.getMinutes()<10)ds+="0";
			ds += date.getMinutes().toString();
			ds += ":";
			if(date.getSeconds()<10)ds+="0";
			ds += date.getSeconds().toString();
			ds += "Z";
			//trace(ds);
			return ds;
		}

	}
}

