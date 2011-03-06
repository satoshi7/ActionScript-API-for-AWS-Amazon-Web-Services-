package jp.classmethod.aws.core
{
	public class Parameter
	{
		public var key:String;
		public var value:String;
		
		public function Parameter(_key:String,_value:String)
		{
			this.key = _key;
			this.value = _value;
		}
	}
}