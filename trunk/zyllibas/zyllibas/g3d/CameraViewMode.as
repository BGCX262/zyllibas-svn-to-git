/*

CameraViewMode
@author zyl910

[2011-10-09]
定义

[2011-10-10]
文档一致性。

[2011-10-11]
文档一致性。

[2011-10-12]
移至zyllibas.g3d（Graphics 3D）包中。

*/

package zyllibas.g3d
{
	/**
	 * CameraViewMode 是一个静态类，用于处理 镜头观察模式 枚举。
	 * <p>镜头观察模式：用键盘、鼠标控制镜头观察世界的几种标准模式。</p>
	 * @author zyl910
	 */
	public final class CameraViewMode
	{
		/**
		 * 概览模式。
		 * <p>永远面对目标点，拖动使镜头在球面上移动，滚轮调整球面半径。</p>
		 */
		public static const overView:int = 0;
		/**
		 * 俯视模式。
		 * <p>俯视地面，拖动改变坐标，滚轮调整高度，翻页键旋转Y轴。</p>
		 */
		public static const topView:int = 1;
		/**
		 * 飞行模式。
		 * <p>拖动转动镜头，滚轮前进后退，键盘6自由度移动。</p>
		 */
		public static const flyView:int = 2;
		/**
		 * 步行模式。
		 * <p>类似飞行模式，但自动调整高度，类似在地面行走。</p>
		 */
		public static const walkView:int = 3;
		
		/**
		 * 最小值。
		 */
		public static const minValue:int = 0;
		/**
		 * 最大值。
		 */
		public static const maxValue:int = 3;
		
	}
	
}