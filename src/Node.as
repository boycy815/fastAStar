package  
{
	/**
	 * ...
	 * @author clifford.cheny http://www.cnblogs.com/flash3d/
	 */
	public class Node 
	{
		public var block:int;
		public var version:int;
		public var links:Vector.<Node>;
		public var linksLength:int;
		public var parent:Node;
		public var nowCost:int;
		public var mayCost:int;
		public var dist:int;
		public var x:int;
		public var y:int;
		public var next:Node;
		public var pre:Node;
	}

}