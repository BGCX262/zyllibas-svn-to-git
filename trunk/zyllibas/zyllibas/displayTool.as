/*

memTool
@author zyl910

[2011-09-23] memTool
clearDisplayObjectContainer
clearDisplayObjectContainerSafe


[2011-09-26] displayTool

*/

package zyllibas
{
	import flash.display.*;
	//import flash.ui.*;
	
	import mx.core.UIComponent;
	
	/**
	 * 显示对象（DisplayObject） 的辅助类。以静态方法的形式提供服务。
	 * @author zyl910
	 */
	public final class displayTool
	{
		
		/**
		 * 清空显示容器。
		 * @param doc 显示容器。
		 */
		public static function clearDisplayObjectContainer(doc:DisplayObjectContainer):void
		{
			if (null==doc)	return;
			var dpo:DisplayObject;
			var t:DisplayObjectContainer;
			for(var i:int=doc.numChildren-1; i>=0; --i)
			{
				dpo = doc.getChildAt(i);
				if (null!=dpo)
				{
					t = dpo as DisplayObjectContainer;
					if (null != t)
					{
						clearDisplayObjectContainer(t);
					}
					t = null;
				}
				dpo = null;
				doc.removeChildAt(i);
			}
		}
		
		/**
		 * 清空显示容器安全版。不会抛出异常。
		 * @param doc 显示容器。
		 */
		public static function clearDisplayObjectContainerSafe(doc:DisplayObjectContainer):void
		{
			if (null==doc)	return;
			try
			{
				clearDisplayObjectContainer(doc);
			}
			catch(ex:Error)
			{
				// 忽略
			}
		}
		
		/**
		 * 检查一个DisplayObject是否与自身场景不属于同一个容器内。用于避免干扰鼠标事件。
		 * 
		 * @return 若不属于同一容器就返回true。否则返回false。无法判断时返回false。
		 * @param dobjo 欲检查的对象
		 * @param myParent 自身对象的容器
		 * @example 用法演示：
		 * <listing version="3.0">
		 * private function MouseDown(event:MouseEvent):void
		 * {
		 * 	// 检查点击位置，若是其他控件则推出
		 * 	if (displayTool.CheckOtherUI(event.target, this.parent))	return;
		 * 	// doing...
		 * 	move = true;
		 * }
		 * </listing>
		 */
		public static function CheckOtherUI(obj:Object, myParent:DisplayObjectContainer):Boolean
		{
			if (null==obj) return false;	// 无法判断时返回false。
			var dobjo:DisplayObject = obj as DisplayObject;
			if (null==dobjo) return false;	// 无法判断时返回false。
			// 检测点击的界面对象
			var dobjc:DisplayObjectContainer;
			var ui:UIComponent = obj as UIComponent;
			if (null==ui)
			{
				dobjc = dobjo.parent;
				while (null!=dobjc)
				{
					ui = dobjc as UIComponent;
					if (null!=ui)	// 找到了界面对象
					{
						break;
					}
					// next
					dobjc = dobjc.parent;
				}
			}
			if (null==ui) return false;	// 无法判断时返回false。
			// 与自身的界面对象进行比较
			var uiMy:UIComponent;
			dobjc = myParent;	//this.parent;
			while (null!=dobjc)
			{
				uiMy = dobjc as UIComponent;
				if (null!=uiMy)	
				{
					if (uiMy === ui)
					{
						return false;
					}
				}
				// next
				dobjc = dobjc.parent;
			}
			return true;
		}
	}
}