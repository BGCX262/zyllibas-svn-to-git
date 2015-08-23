/*

sparkTool
@author zyl910

[2011-09-27]
dropDownHeight_Set

[2011-09-28]
dropDownSelectedText


*/

package zyllibas
{
	import flash.display.*;
	
	import mx.utils.*;
	
	import spark.components.*;
	import spark.components.supportClasses.*;
	
	//import flashx.textLayout.elements.*;
	
	/**
	 * sparkTool 类是一个静态类，其功用是为处理 spark控件 提供便利。
	 * @author zyl910
	 */
	public final class sparkTool
	{
		/**
		 * 设置下拉列表的高度。建议在open事件中调用此函数。
		 * @return 是否修改了高度。成功修改后返回true，条件不符合或失败就返回false。
		 * @param ctl 下拉控件。
		 * @param Height 高度。
		 * @param minCount 最小项目数。仅当列表中的数量>minCount时才设置高度。注：combobox控件默认能显示6个项目。
		 */
		public static function dropDownHeightSet(ctl:DropDownListBase, Height:Number, minCount:int=6):Boolean
		{
			if (null==ctl)	return false;
			if (null==ctl.dataProvider)	return false;
			if (ctl.dataProvider.length<=minCount)	return false;
			ctl.dropDown.height = Height;
			return true;
		}
		
		/**
		 * 取得下拉列表当前选择的字符串。失败时返回defaultStr。
		 * @return 是否修改了高度。成功修改后返回true，条件不符合或失败就返回false。
		 * @param ctl 下拉控件。
		 * @param field 字段。当selectedItem为对象类型时，返回它的字段，即 return ctl.selectedItem[field];
		 * @param defaultStr 默认字符串。
		 * @param autoTrim 是否自动去掉首尾空格。
		 */
		public static function dropDownSelectedText(ctl:DropDownListBase, field:String="label", defaultStr:String="", autoTrim:Boolean=true):String
		{
			if (null==ctl)	return defaultStr;
			if (undefined==ctl.selectedItem)	return defaultStr;
			var s:String;
			if (ctl.selectedItem as String)
			{
				s = ctl.selectedItem;
			}
			else
			{
				var obj:Object = ctl.selectedItem;
				s = obj[field];
			}
			if (autoTrim)
			{
				s = StringUtil.trim(s);
			}
			return s;
		}
		
		/*public static function TextFlowAddLine(tf:TextFlow, content:String):void
		{
			if (null==tf)		return;
			if (tf.numChildren>2000)	tf.removeChildAt(0);
			var p:ParagraphElement = new ParagraphElement;
			var se:SpanElement=new SpanElement();
			se.text = content;
			p.addChild(se);
			tf.addChild(p);
			tf.flowComposer.updateAllControllers();
		}
		
		public static function TextAreaAddLine(ta:TextArea, content:String):void
		{
			if (null==ta)		return;
			TextFlowAddLine(ta.textFlow, content);
			ta.validateNow();
			ta.scroller.viewport.verticalScrollPosition=ta.scroller.viewport.contentHeight;
		}*/
		
		/**
		 * 在文本框的末尾添加一行
		 * @param ta 文本框控件。
		 * @param content 所添加的内容。
		 */
		public static function TextAreaAddLine(ta:TextArea, content:String):void
		{
			if (null==ta)	return;
			//ta.selectRange(int.MAX_VALUE, int.MAX_VALUE);
			//ta.insertText(content + "\r\n");
			ta.appendText(content + "\n");
			ta.selectRange(int.MAX_VALUE, int.MAX_VALUE);
		}
		
	}
}