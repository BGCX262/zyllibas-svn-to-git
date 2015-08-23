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
	 * DisposeBase类是一个基类，用于演示标准的资源释放(Dispose)处理模式。
	 * @author zyl910
	 */
	public class DisposeBase implements IDisposable
	{
		public function DisposeBase()
		{
		}
		
		/**
		 * 执行释放外部资源的操作。派生类不应该覆盖此方法，而应该覆盖onDispose。
		 * @param isThoro 是否进行彻底释放。例如强制释放引用的对象。
		 */
		public function dispose(isThoro:Boolean=false):void
		{
			onDispose(isThoro);	// 虽然ActionScript没有析构函数，但isDisposing参数还是值得借鉴的
		}
		
		/**
		 * 执行释放资源的操作。派生类应该覆盖此方法。
		 * @param isThoro 是否进行彻底释放。例如强制释放引用的对象。
		 */
		protected function onDispose(isThoro:Boolean):void
		{
			// == 释放拥有的外部资源 ==
			// == 释放引用的外部资源 ==
			// == 释放内部资源 ==
			// == 基类的释放 ==
			DisposeTool.clearDynamic(this, isThoro);
		}
	}
}