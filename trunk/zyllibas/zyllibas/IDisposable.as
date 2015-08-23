/*

IDisposable
@author zyl910

参考了《Effective C#: 50 Specific Ways to Improve Your C#》（Effective C#中文版:改善C#程序的50种方法）的“条款18：实现标准dispose模式”

[2011-09-29]
定义

[2011-10-02]
增加isThoro参数

[2011-10-12]
文档一致性。

*/

package zyllibas
{
	/**
	 * IDisposable 是一个接口，用于统一 释放外部资源 的操作。
	 * @author zyl910
	 */
	public interface IDisposable
	{
		/**
		 * 执行释放外部资源的操作。
		 * @param isThoro 是否进行彻底释放。例如强制释放引用的对象。
		 */
		function dispose(isThoro:Boolean=false):void;
	}
}