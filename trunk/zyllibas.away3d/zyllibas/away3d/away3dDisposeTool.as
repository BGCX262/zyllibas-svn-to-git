/*

ParamObjTool
@author zyl910

[2011-10-20]
定义

[2011-10-21]
free
clearObject3D
clearObjectContainer3D


*/
package zyllibas.away3d
{
	import zyllibas.zyladv;
	import zyllibas.IDisposable;
	import zyllibas.DisposeTool;
	
	import away3d.core.base.*;
	import away3d.containers.*;
	
	use namespace zyladv;
	
	/**
	 * ParamObjTool 是一个静态类，用于处理Away3D的资源释放操作。
	 * @see zyllibas.IDisposable
	 * @see zyllibas.DisposeTool
	 * @author zyl910
	 */
	public final class away3dDisposeTool
	{
		/**
		 * 自动释放。会尝试转型，释放所有资源。
		 * <p>1.若该对象支持IDisposable接口，就仅调用IDisposable.Dispose，而不尝试转型释放。</p>
		 * <p>2.最后会释放动态属性。</p>
		 * @param obj 欲释放的对象。
		 * @param isThoro 是否进行彻底释放。例如强制释放引用的对象。
		 */
		public static function free(obj:Object, isThoro:Boolean=false):void 
		{
			if (obj == null)	return;
			var itf:IDisposable = obj as IDisposable;
			if (null!=itf)
			{
				itf = null;
				DisposeTool.free(obj, isThoro);
			}
			else
			{
				// 转型释放
				if (!DisposeTool.isSimple(obj))
				{
					clearObject3D(obj as Object3D, isThoro);
				}
				DisposeTool.free(obj, isThoro);
			}
		}
		
		/**
		 * 清空 Object3D。
		 * @param obj 欲释放的对象。
		 * @param isThoro 是否进行彻底释放。例如强制释放引用的对象。
		 */
		zyladv static function clearObject3D(obj:Object3D, isThoro:Boolean=false):void 
		{
			if (null==obj)	return;
			// 清空派生类
			clearObjectContainer3D(obj as ObjectContainer3D, isThoro);
			
			// 清空自身
			// <will>
		}
		
		/**
		 * 清空 ObjectContainer3D。
		 * @param obj 欲释放的对象。
		 * @param isThoro 是否进行彻底释放。例如强制释放引用的对象。
		 */
		zyladv static function clearObjectContainer3D(obj:ObjectContainer3D, isThoro:Boolean=false):void 
		{
			if (null==obj)	return;
			// 清空派生类
			
			// 清空自身
			// 待改进
			for each(var t:Object3D in obj.children)
			{
				obj.removeChild(t);
				clearObject3D(t);
			}
			// <will>
		}
		
	}
	
}