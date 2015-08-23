/*

DisposeBase
@author zyl910

[2011-09-30]
定义

[2011-10-02]
废除disposing参数
增加isThoro参数

*/

package zyllibas
{
	/**
	 * DisposeDerived类是一个派生类，用于演示标准的资源释放(Dispose)处理模式。
	 * @author zyl910
	 */
	public class DisposeDerived extends DisposeBase
	{
		private var _myObj:Object;	// 内部资源（管理生存）
		public var OwnerObject:Object;	// 拥有的外部资源（管理生存）
		public var RefObject:Object;	// 引用的外部资源（不管理生存）
		
		public function DisposeDerived()
		{
			//TODO: implement function
			super();
			_myObj = new Object();
		}
		
		/**
		 * 执行释放资源的操作。派生类应该覆盖此方法。
		 * @param isThoro 是否进行彻底释放。例如强制释放引用的对象。
		 */
		protected override function onDispose(isThoro:Boolean):void
		{
			// == 释放拥有的外部资源 ==
			DisposeTool.free(OwnerObject);
			OwnerObject = null;
			// == 释放引用的外部资源 ==
			if (isThoro)
				DisposeTool.free(RefObject);
			RefObject = null;
			// == 释放内部资源 ==
			DisposeTool.free(_myObj);
			_myObj = null;
			// == 基类的释放 ==
			super.onDispose(isThoro);
		}
	}
}