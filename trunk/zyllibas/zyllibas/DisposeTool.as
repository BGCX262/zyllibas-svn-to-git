/*

DisposeTool
@author zyl910

[2011-09-29]
定义至clearSWFLoader

[2011-10-02]
增加isThoro参数
freeXML
clearXML
clearXMLList
clearLoader
重构，clearDynamic
发现在for中delete会导致迭代提前退出，改造clearDynamic。
貌似局部变量的释放很快。按下事件处理一结束，就自动释放干净了

[2011-10-10]
参考ObjectUtil.isSimple实现了isSimple函数。
free函数考虑isSimple。


*/

package zyllibas
{
	import flash.display.*;
	import flash.events.EventDispatcher;
	import flash.system.System;
	import flash.utils.Dictionary;
	
	import mx.collections.*;
	import mx.controls.SWFLoader;
	import mx.utils.*;

	use namespace zyladv;
	
	/**
	 * DisposeTool 类是一个静态类，其功用是为处理 资源释放 提供便利。
	 * @author zyl910
	 */ 
	public final class DisposeTool
	{
		/**
		 * 调用对象的 IDisposable.Dispose 方法。
		 * <p>若该对象不支持IDisposable接口，就忽略。</p>
		 * @param obj 欲释放的对象。
		 * @param isThoro 是否进行彻底释放。例如强制释放引用的对象。
		 */
		public static function dispose(obj:Object, isThoro:Boolean=false):void 
		{ 
			if (obj == null)	return;
			var itf:IDisposable = obj as IDisposable;
			if (null!=itf)
			{
				itf.dispose(isThoro);
				itf = null;
			}
		}
		
		/**
		 * @private 抄自 ObjectUtil.isSimple
		 *  Returns <code>true</code> if the object reference specified
		 *  is a simple data type. The simple data types include the following:
		 *  <ul>
		 *    <li><code>String</code></li>
		 *    <li><code>Number</code></li>
		 *    <li><code>uint</code></li>
		 *    <li><code>int</code></li>
		 *    <li><code>Boolean</code></li>
		 *  </ul>
		 *
		 *  @param value Object inspected.
		 *
		 *  @return <code>true</code> if the object specified
		 *  is one of the types above; <code>false</code> otherwise.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		public static function isSimple(value:Object):Boolean
		{
			//return false;	// 最保守策略，把所有对象均视为复杂类型，性能最高。
			//return ObjectUtil.isSimple(value);	// 利用ObjectUtil，可是Array、Date（动态）也返回true。
			var type:String = typeof(value);
			switch (type)
			{
				case "number":
				case "string":
				case "boolean":
				{
					return true;
				}
			}
			return false;
		}
		
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
				// 标准释放
				itf.dispose(isThoro);
				itf = null;
			}
			else
			{
				// 转型释放
				if (isSimple(obj))
				{
					// 简单类型不需要转型释放
				}
				else
				{
					// array
					clearDictionary(obj as Dictionary, isThoro);
					clearArray(obj as Array, isThoro);
					//clearVector(obj, isThoro);	// 怎么写泛型方法？
					clearIList(obj as IList, isThoro);
					clearXML(obj as XML, isThoro);
					clearXMLList(obj as XMLList, isThoro);
					
					// flash
					clearBitmap(obj as Bitmap, isThoro);
					clearBitmapData(obj as BitmapData, isThoro);
					clearEventDispatcher(obj as EventDispatcher, isThoro);
				}
				
			}
			// 释放动态属性
			clearDynamic(obj, isThoro);
		}
		
		/**
		 * 清空动态属性。
		 * @param obj 欲释放的对象。
		 * @param isThoro 是否进行彻底释放。例如强制释放引用的对象。
		 */
		public static function clearDynamic(obj:Object, isThoro:Boolean=false):void
		{
			if (obj == null)	return;
			if (obj is XML)	return;		// XML不能用此方法释放，会造成无限递归
			// 先清空内容
			var key:*;
			for (key in obj)
			{
				var t:Object = obj[key];
				obj[key] = undefined;	// 避免循环引用
				//delete obj[key];	// 在for中delete会导致迭代提前退出
				free(t, isThoro);
			}
			// 再释放属性
			for (key in obj)
			{
				delete obj[key];	// 虽然在for中delete会导致迭代提前退出，但聊胜于无
			}
			if (isThoro)
			{
				var arr:Array = [];
				var i:int = 0;
				for (key in obj)
				{
					arr[i] = key;
				}
				for (i=arr.length-1; i>=0; --i)
				{
					delete obj[arr[i]];
					arr[i] = undefined;
				}
				arr.length = 0;
			}
		}
		
		/**
		 * 清空 Dictionary。
		 * @param obj 欲释放的对象。
		 * @param isThoro 是否进行彻底释放。例如强制释放引用的对象。
		 */
		zyladv static function clearDictionary(obj:Dictionary, isThoro:Boolean=false):void 
		{ 
			if (obj == null)	return;
			// 先清空内容
			var key:*;
			for (key in obj)
			{
				var t:Object = obj[key];
				obj[key] = undefined;	// 避免循环引用
				//delete obj[key];	// 在for中delete会导致迭代提前退出
				free(t, isThoro);
			}
			// 再释放属性
			for (key in obj)
			{
				delete obj[key];	// 虽然在for中delete会导致迭代提前退出，但聊胜于无
			}
			if (isThoro)
			{
				var arr:Array = [];
				var i:int = 0;
				for (key in obj)
				{
					arr[i] = key;
				}
				for (i=arr.length-1; i>=0; --i)
				{
					delete obj[arr[i]];
					arr[i] = undefined;
				}
				arr.length = 0;
			}
		} 
		
		
		/**
		 * 清空数组。
		 * @param obj 欲释放的对象。
		 * @param isThoro 是否进行彻底释放。例如强制释放引用的对象。
		 */
		zyladv static function clearArray(obj:Array, isThoro:Boolean=false):void 
		{ 
			if (obj == null)	return;
			//while (obj.length > 0)
			//{
			//	free(obj.pop(), isThoro);
			//}
			for(var i:uint=0; i<obj.length; ++i)
			{
				var t:Object = obj[i];
				obj[i] = undefined;
				free(t, isThoro);
			}
			obj.length = 0;
		} 
		
		//public static function myVector(sourceArray:Object):Vector.<T>
		//{
		//	return new Vector.<T>;
		//}
		
		/**
		 * 清空Vector。
		 * @param obj 欲释放的对象。
		 * @param isThoro 是否进行彻底释放。例如强制释放引用的对象。
		 */
		public static function clearVector(obj:Vector.<Object>, isThoro:Boolean=false):void 
		{ 
			if (obj == null)	return;
			for(var i:uint=0; i<obj.length; ++i)
			{
				var t:Object = obj[i];
				obj[i] = undefined;
				free(t, isThoro);
			}
			obj.length = 0;
		}
		
		/**
		 * 清空 IList（ArrayCollection, ArrayList, AsyncListView, ListCollectionView, ...）。
		 * @param obj 欲释放的对象。
		 * @param isThoro 是否进行彻底释放。例如强制释放引用的对象。
		 */
		zyladv static function clearIList(obj:IList, isThoro:Boolean=false):void 
		{
			if (obj == null)	return;
			while (obj.length > 0)
			{
				free(obj.removeItemAt(0), isThoro);
			}
		}
		
		/**
		 * 自动释放继承自 XML 的对象。会尝试转型，释放所有资源。
		 * <p>1.若该对象支持IDisposable接口，就仅调用IDisposable.Dispose，而不尝试转型释放。</p>
		 * <p>2.最后会释放动态属性。</p>
		 * <p>3.因为明确了基类，将不会尝试转为其他根类型（Array、IList等），优化了性能。</p>
		 * @param obj 欲释放的对象。
		 * @param isThoro 是否进行彻底释放。例如强制释放引用的对象。
		 * @playerversion Flash 10.1
		 */
		public static function freeXML(obj:XML, isThoro:Boolean=false):void
		{ 
			if (obj == null)	return;
			var itf:IDisposable = obj as IDisposable;
			if (null!=itf)
			{
				// 标准释放
				itf.dispose(isThoro);
				itf = null;
			}
			else
			{
				// 转型释放
				clearXML(obj, isThoro);
			}
			// 释放动态属性
			clearDynamic(obj, isThoro);
		}
		
		/**
		 * 清空继承自 XML 的对象。会先尝试清空派生类，再清空自身。
		 * @param obj 欲清空的对象。
		 * @param isThoro 是否进行彻底释放。例如强制释放引用的对象。
		 * @playerversion Flash 10.1
		 */
		zyladv static function clearXML(obj:XML, isThoro:Boolean=false):void
		{
			if (null==obj)	return;
			// 清空派生类
			
			// 清空自身
			// <will>
			System.disposeXML(obj);
		}
		
		/**
		 * 清空继承自 XMLList 的对象。会先尝试清空派生类，再清空自身。
		 * @param obj 欲清空的对象。
		 * @param isThoro 是否进行彻底释放。例如强制释放引用的对象。
		 * @playerversion Flash 10.1
		 */
		zyladv static function clearXMLList(obj:XMLList, isThoro:Boolean=false):void
		{
			if (null==obj)	return;
			// 清空派生类
			
			// 清空自身
			// <will>
			while (obj.length() > 0)
			{
				free(obj[0], isThoro);
				delete obj[0];
			}
		}
		
		/**
		 * 自动释放继承自 Bitmap 的对象。会尝试转型，释放所有资源。
		 * @param obj 欲释放的对象。
		 * @param isThoro 是否进行彻底释放。例如强制释放引用的对象。
		 */
		public static function freeBitmap(obj:Bitmap, isThoro:Boolean=false):void
		{ 
			if (obj == null)	return;
			var itf:IDisposable = obj as IDisposable;
			if (null!=itf)
			{
				// 标准释放
				itf.dispose(isThoro);
				itf = null;
			}
			else
			{
				// 转型释放
				clearBitmap(obj, isThoro);
			}
			// 释放动态属性
			clearDynamic(obj, isThoro);
		}
		
		/**
		 * 清空继承自 Bitmap 的对象。会先尝试清空派生类，再清空自身。
		 * @param obj 欲清空的对象。
		 * @param isThoro 是否进行彻底释放。例如强制释放引用的对象。
		 */
		zyladv static function clearBitmap(obj:Bitmap, isThoro:Boolean=false):void
		{
			if (null==obj)	return;
			// 清空派生类
			
			// 清空自身
			// <will>
			freeBitmapData(obj.bitmapData, isThoro);
		}
		
		/**
		 * 自动释放继承自 BitmapData 的对象。会尝试转型，释放所有资源。
		 * @param obj 欲释放的对象。
		 * @param isThoro 是否进行彻底释放。例如强制释放引用的对象。
		 */
		public static function freeBitmapData(obj:BitmapData, isThoro:Boolean=false):void
		{ 
			if (obj == null)	return;
			var itf:IDisposable = obj as IDisposable;
			if (null!=itf)
			{
				// 标准释放
				itf.dispose(isThoro);
				itf = null;
			}
			else
			{
				// 转型释放
				clearBitmapData(obj, isThoro);
			}
			// 释放动态属性
			clearDynamic(obj, isThoro);
		}
		
		/**
		 * 清空继承自 BitmapData 的对象。会先尝试清空派生类，再清空自身。
		 * @param obj 欲清空的对象。
		 * @param isThoro 是否进行彻底释放。例如强制释放引用的对象。
		 */
		zyladv static function clearBitmapData(obj:BitmapData, isThoro:Boolean=false):void
		{
			if (null==obj)	return;
			// 清空派生类
			
			// 清空自身
			// <will>
			if (isThoro)
				obj.dispose();	// dispose后再调用BitmapData的方法会导致异常
		}
		
		/**
		 * 自动释放继承自 EventDispatcher 的对象。会尝试转型，释放所有资源。
		 * @param obj 欲释放的对象。
		 * @param isThoro 是否进行彻底释放。例如强制释放引用的对象。
		 */
		public static function freeEventDispatcher(obj:EventDispatcher, isThoro:Boolean=false):void
		{ 
			if (obj == null)	return;
			var itf:IDisposable = obj as IDisposable;
			if (null!=itf)
			{
				// 标准释放
				itf.dispose(isThoro);
				itf = null;
			}
			else
			{
				// 转型释放
				clearEventDispatcher(obj, isThoro);
			}
			// 释放动态属性
			clearDynamic(obj, isThoro);
		}
		
		/**
		 * 清空继承自 EventDispatcher 的对象。会先尝试清空派生类，再清空自身。
		 * @param obj 欲清空的对象。
		 * @param isThoro 是否进行彻底释放。例如强制释放引用的对象。
		 */
		zyladv static function clearEventDispatcher(obj:EventDispatcher, isThoro:Boolean=false):void
		{
			if (null==obj)	return;
			// 清空派生类
			clearDisplayObject(obj as DisplayObject, isThoro);
			
			// 清空自身
			// <will>
		}
		
		/**
		 * 自动释放继承自 DisplayObject 的对象。会尝试转型，释放所有资源。
		 * @param obj 欲释放的对象。
		 * @param isThoro 是否进行彻底释放。例如强制释放引用的对象。
		 */
		public static function freeDisplayObject(obj:DisplayObject, isThoro:Boolean=false):void
		{ 
			if (obj == null)	return;
			var itf:IDisposable = obj as IDisposable;
			if (null!=itf)
			{
				// 标准释放
				itf.dispose(isThoro);
				itf = null;
			}
			else
			{
				// 转型释放
				clearDisplayObject(obj, isThoro);
			}
			// 释放动态属性
			clearDynamic(obj, isThoro);
		}
		
		/**
		 * 清空继承自 DisplayObject 的对象。会先尝试清空派生类，再清空自身。
		 * @param obj 欲清空的对象。
		 * @param isThoro 是否进行彻底释放。例如强制释放引用的对象。
		 */
		zyladv static function clearDisplayObject(obj:DisplayObject, isThoro:Boolean=false):void
		{
			if (null==obj)	return;
			// 清空派生类
			clearInteractiveObject(obj as InteractiveObject, isThoro);
			
			// 清空自身
			// <will>
			//obj.cacheAsBitmap = false;
			//obj.mask = null;
		}
		
		/**
		 * 清空继承自 InteractiveObject 的对象。会先尝试清空派生类，再清空自身。
		 * @param obj 欲清空的对象。
		 * @param isThoro 是否进行彻底释放。例如强制释放引用的对象。
		 */
		zyladv static function clearInteractiveObject(obj:InteractiveObject, isThoro:Boolean=false):void
		{
			if (null==obj)	return;
			// 清空派生类
			clearDisplayObjectContainer(obj as DisplayObjectContainer, isThoro);
			
			// 清空自身
			// <will>
		}
		
		/**
		 * 清空继承自 DisplayObjectContainer 的对象。会先尝试清空派生类，再清空自身。
		 * @param obj 欲清空的对象。
		 * @param isThoro 是否进行彻底释放。例如强制释放引用的对象。
		 */
		zyladv static function clearDisplayObjectContainer(obj:DisplayObjectContainer, isThoro:Boolean=false):void
		{
			if (null==obj)	return;
			// 清空派生类
			clearSprite(obj as Sprite);
			
			// 清空自身
			while (obj.numChildren > 0)
			{
				freeDisplayObject(obj.removeChildAt(0), isThoro);
			}
			// <will>
		}
		
		/**
		 * 清空继承自 Loader 的对象。会先尝试清空派生类，再清空自身。
		 * @param obj 欲清空的对象。
		 * @param isThoro 是否进行彻底释放。例如强制释放引用的对象。
		 * @playerversion Flash 10
		 */
		zyladv static function clearLoader(obj:Loader, isThoro:Boolean=false):void
		{
			if (null==obj)	return;
			// 清空派生类
			
			// 清空自身
			// <will>
			obj.close();
			obj.unloadAndStop(isThoro);
		}
		
		/**
		 * 清空继承自 Sprite 的对象。会先尝试清空派生类，再清空自身。
		 * @param obj 欲清空的对象。
		 * @param isThoro 是否进行彻底释放。例如强制释放引用的对象。
		 */
		zyladv static function clearSprite(obj:Sprite, isThoro:Boolean=false):void
		{
			if (null==obj)	return;
			// 清空派生类
			clearMovieClip(obj as MovieClip, isThoro);
			// ...
			clearSWFLoader(obj as SWFLoader, isThoro);
			
			// 清空自身
			// <will>
			obj.hitArea = null;
		}
		
		/**
		 * 清空继承自 MovieClip 的对象。会先尝试清空派生类，再清空自身。
		 * @param obj 欲清空的对象。
		 * @param isThoro 是否进行彻底释放。例如强制释放引用的对象。
		 */
		zyladv static function clearMovieClip(obj:MovieClip, isThoro:Boolean=false):void
		{
			if (null==obj)	return;
			// 清空派生类
			
			// 清空自身
			// <will>
			obj.stop();
		}
		
		
		/**
		 * 清空继承自 SWFLoader 的对象。会先尝试清空派生类，再清空自身。
		 * @param obj 欲清空的对象。
		 * @param isThoro 是否进行彻底释放。例如强制释放引用的对象。
		 */
		zyladv static function clearSWFLoader(obj:SWFLoader, isThoro:Boolean=false):void
		{
			if (null==obj)	return;
			// 清空派生类
			
			// 清空自身
			// <will>
			obj.unloadAndStop(isThoro);
			freeDisplayObject(obj.content, isThoro);
		}
		
	}
}