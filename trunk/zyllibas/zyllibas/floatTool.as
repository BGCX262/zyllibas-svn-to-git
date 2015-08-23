/*

floatTool
@author zyl910

[2011-09-23]
DefaultEpsilon
isEqual

[2011-10-11]
改进注释。

*/

package zyllibas
{
	/**
	 * floatTool是一个静态类，用于辅助浮点运算。
	 * @author zyl910
	 */
	public final class floatTool
	{
		/**
		 * 默认浮点误差
		 */
		public static const DefaultEpsilon:Number = 0.000001;
		
		/**
		 * 浮点数是否相等。
		 * @param a 浮点数a。
		 * @param b 浮点数b。
		 * @param epsilon 浮点数误差范围。
		 * @return 是否相等
		 */
		public static function isEqual(a:Number, b:Number, epsilon:Number=DefaultEpsilon):Boolean
		{
			// http://blog.csdn.net/happy__888/article/details/280627
			if (a==b)	return true;
			return ( Math.abs(a-b) < epsilon );
		}
		
	}
}