/*

away3dTool
@author zyl910

[2011-09-23]
freeObject3D
freeObject3DSafe
clearObjectContainer3D
clearObjectContainer3DSafe

[2011-09-26]
cloneMouseEvent3D
newParser

[2011-09-27]
newParser: 修复加载obj的bug
newRenderer

[2011-09-28]
materialLibrarySetValue

[2011-9-29]
freeObject3D: 不再调用removeChild

*/

package zyllibas.away3d
{
	import away3d.containers.*;
	import away3d.core.base.*;
	import away3d.core.render.*;
	import away3d.events.*;
	import away3d.loaders.*;
	import away3d.loaders.data.*;
	import away3d.materials.Material;
	
	/**
	 * Away3D的辅助类。以静态方法的形式提供服务。
	 * @author zyl910
	 */
	public final class away3dTool
	{
		
		/**
		 * 清除3D对象。
		 * @param obj 3D对象。
		 */
		public static function freeObject3D(obj:Object3D):void
		{
			if (null==obj)	return;
			clearObjectContainer3D(obj as ObjectContainer3D);	// 尝试释放容器内的对象
			//if (null!=obj.parent)	// [2011-9-29]会影响结构层次，决定不再这样做
			//{
			//	obj.parent.removeChild(obj);
			//}
			// [will]没找到好的释放模式，以后改进
		}
		
		/**
		 * 清除3D对象。
		 * @param obj 3D对象。
		 */
		public static function freeObject3DSafe(obj:Object3D):void
		{
			if (null==obj)	return;
			try
			{
				freeObject3D(obj);
			}
			catch(ex:Error)
			{
				// 忽略
			}
		}
		
		/**
		 * 清空3D容器。
		 * <p>仅容器内的对象，不包含自身。</p>
		 * @param col 3D容器。
		 */
		public static function clearObjectContainer3D(col:ObjectContainer3D):void
		{
			if (null==col)	return;
			// [will]没找到好的释放模式，以后改进
			// foreach{ clearObject3D() }
			for each(var obj:Object3D in col.children)
			{
				col.removeChild(obj);
				freeObject3D(obj);
			}
		}
		
		/**
		 * 清空3D容器安全版。不会抛出异常。
		 * @param col 3D容器。
		 */
		public static function clearObjectContainer3DSafe(col:ObjectContainer3D):void
		{
			if (null==col)	return;
			try
			{
				clearObjectContainer3D(col);
			}
			catch(ex:Error)
			{
				// 忽略
			}
		}
		
		/**
		 * 克隆一个MouseEvent3D对象
		 * @return 克隆结果。
		 * @param type 事件类型。
		 * @param e 源事件。
		 */
		public static function cloneMouseEvent3D(type:String, e:MouseEvent3D=null):MouseEvent3D
		{
			var result:MouseEvent3D = new MouseEvent3D(type);
			
			result.screenX = e.screenX;
			result.screenY = e.screenY;
			result.screenZ = e.screenZ;
			
			result.sceneX = e.sceneX;
			result.sceneY = e.sceneY;
			result.sceneZ = e.sceneZ;
			
			result.view = e.view;
			result.object = e.object;
			result.elementVO = e.elementVO;
			result.material = e.material;
			result.uv = e.uv;
			
			result.ctrlKey = e.ctrlKey;
			result.shiftKey = e.shiftKey;
			
			return result;
		}
		
		/**
		 * 新建模型解析对象
		 * @return 模型解析对象。null表示失败。
		 * @param ParserType 解析器类型。
		 * @param init 初始化参数。
		 */
		public static function newParser(ParserType:String, init:Object = null):AbstractParser
		{
			switch (ParserType)
			{
				case "AC3D": return new AC3D(init); break;
				case "Ase": return new Ase(init); break;
				case "AWData": return new AWData(init); break;
				case "Collada": return new Collada(init); break;
				case "Kmz": return new Kmz(init); break;
				case "Max3DS": return new Max3DS(init); break;
				case "Md2": return new Md2(init); break;
				case "Obj": return new Obj(init); break;
				case "Swf": return new Swf(init); break;
			}
			return null;
		}
		
		/**
		 * 新建渲染器对象
		 * @return 渲染器对象。null表示失败。
		 * @param nameRenderer 渲染器的名称。
		 */
		public static function newRenderer(nameRenderer:String):Renderer
		{
			switch (nameRenderer)
			{
				case "BASIC": return Renderer.BASIC; break;
				case "CORRECT_Z_ORDER": return Renderer.CORRECT_Z_ORDER; break;
				case "INTERSECTING_OBJECTS": return Renderer.INTERSECTING_OBJECTS; break;
			}
			return null;
		}
		
		/**
		 * 给材质列表赋值。
		 * @return 是否成功。
		 * @param obj 3D对象。
		 * @param name 材质名。空表示使用Mesh.material。
		 * @param mate 材质。
		 */
		public static function materialLibrarySetValue(obj:Object3D, name:String, mate:Material):Boolean
		{
			if (null==obj)	return false;
			if ((null==name) || (name.length<=0))
			{
				// 给默认的material赋值
				var mesh:Mesh = obj as Mesh;
				if (null==mesh)	return false;
				mesh.material = mate;
			}
			else
			{
				// 给材质列表中的项目赋值
				var md:MaterialData = obj.materialLibrary.getMaterial(name);
				if (null==md)	return false;
				md.material = mate;
			}
			return true;
		}
		
	}
}