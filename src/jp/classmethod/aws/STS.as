package jp.classmethod.aws
{
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLVariables;
	
	import jp.classmethod.aws.dto.Instance;
	
	import mx.collections.ArrayCollection;
	import jp.classmethod.aws.core.AWSBase;
	import jp.classmethod.aws.core.AWSDateUtil;
	import jp.classmethod.aws.core.AWSEvent;
	import jp.classmethod.aws.core.Parameter;
	
	/**
	 * AWS Security Token Service
	 * @author satoshi
	 * 
	 */
	public class STS extends AWSBase
	{
		
		public static const GET_FEDERATION_TOKEN:String = "GetFederationToken";
		public static const GET_SESSION_TOKEN:String = "GetSessionToken";
		
		
		
		//endpoint option
		public static const US_EAST_1:String = "sts.amazonaws.com";
				
		public function STS(str:String=null) 
		{
			if(str != null){
				domainEndpoint=str;
			}else{
				domainEndpoint=STS.US_EAST_1;
			}
			remoteRequestURL=protocol + _domainEndpoint + endPointURLExtendsion;
		}

		public function executeRequest(action:String, urlVariablesArr:Array=null, requestMethod:String="POST"):void
		{
			this.action = action;
			if(!urlVariablesArr){
				urlVariablesArr = new Array();
			}
			urlVariablesArr.push(new Parameter("Version", "2011-06-15"));
			urlVariablesArr.push(new Parameter("Action", action));
			urlVariablesArr.push(new Parameter("AWSAccessKeyId", _awsAccessKey));
			urlVariablesArr.push(new Parameter("Timestamp", AWSDateUtil.generateRequestTimeStamp(new Date())));

			var urlVariables:URLVariables=generateSignature(urlVariablesArr, 2, requestMethod);
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
		
		public function exec(obj:Object):void{
			var urlVariablesArr:Array=new Array();
			var action:String;
			
			for(var key:String in obj){
				var value:String = obj[key];
				trace(key+value);
				if(key == "Action"){
					action = value;
				}else{
					urlVariablesArr.push(new Parameter(key,value));
				}
			}
			
			executeRequest(action,urlVariablesArr);
		}
		
		public override function handleRequest(event:Event):void{
			var data:XML = XML(event.currentTarget.data);
			var list:ArrayCollection = new ArrayCollection();
			
			if(action == "DescribeInstances"){
				var xmlList:XMLList = data.*::reservationSet.*::item.*::instancesSet.*::item;
				for each (var item:XML in xmlList) {
					var instance:Instance = new Instance(item);
					instance.region = this.domainEndpoint;
					list.addItem(instance);
				}
			}
			
			var ae:AWSEvent = new AWSEvent(AWSEvent.RESULT);
			ae.data = event.currentTarget.data;
			ae.list = list;
			dispatchEvent(ae);
		}
			
		public function runInstances(amiId:String,minCount:int=1,maxCount:int=1,keyName:String=null,instanceType:String=null):void{
			var vals:Array = new Array();
			vals.push(new Parameter("ImageId",amiId));
			vals.push(new Parameter("MinCount",minCount.toString()));
			vals.push(new Parameter("MaxCount",maxCount.toString()));
			if(keyName!=null)vals.push(new Parameter("KeyName",keyName));
			if(instanceType!=null)vals.push(new Parameter("InstanceType",instanceType));
			this.executeRequest(EC2.RUN_INSTANCES,vals);
		}
		
		public function createTags(instanceId:String,key:String,value:String):void{
			var vals:Array = new Array();
			vals.push(new Parameter("ResourceId.1",instanceId));
			vals.push(new Parameter("Tag.1.Key",key));
			vals.push(new Parameter("Tag.1.Value",value));
			this.executeRequest(EC2.CREATE_TAGS,vals);
		}
	}
}
