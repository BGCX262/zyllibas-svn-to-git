/*

IPCloneable
@author zyl910

IPCloneable 是一个接口，用于统一 支持可选参数的对象复制 的操作。
备注：为了避免与其他类库的“ICloneable”冲突。

[2011-10-12]
定义

[2011-10-20]
pclone增加objAllocated参数。

*/

package zyllibas
{
	/**
	 * IPCloneable 是一个接口，用于统一 支持可选参数的对象复制 的操作。
	 * @author zyl910
	 */
	public interface IPCloneable
	{
		/**
		 * 返回复制的对象（支持可选参数）。
		 * @return 返回复制的对象。
		 * @param params 可选参数。用于调整返回对象的属性。虽然不是完全地符合克隆语义，但这样比较灵活。
		 * @param objAllocated 已分配的对象。您可以事先分配一个对象，再由pclone给它赋值。还可用于派生类调用基类的pclone方法。若objAllocated非法，忽略，新建。
		 */
		function pclone(params:Object=null, objAllocated:Object = null):Object;
		
	}
}