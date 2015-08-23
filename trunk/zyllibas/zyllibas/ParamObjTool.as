/*

ParamObjTool
@author zyl910

[2011-10-20]
定义

[2011-10-21]
getString
getBool
getInt
getNumber


*/
package zyllibas
{
	/**
	 * ParamObjTool 是一个静态类，用于辅助处理Object参数。
	 * @author zyl910
	 */
	public final class ParamObjTool
	{
		/**
		 * 取得逻辑值参数。
		 * @return 返回逻辑值。
		 * @param params 参数对象。从该对象获取参数。
		 * @param name 参数名。
		 * @param def 默认值。
		 */
		public static function getBool(params:Object, name:String, def:Boolean=false):Boolean
		{
			if (null==params)	return def;
			if (!params.hasOwnProperty(name))	return def;
			return Boolean(params[name]);
		}
		
		/**
		 * 取得整数参数。
		 * @return 返回整数。
		 * @param params 参数对象。从该对象获取参数。
		 * @param name 参数名。
		 * @param def 默认值。
		 * @param notNaN 是否不能为NaN。当返回值应是NaN时，若notNaN为true，那就返回def。
		 */
		public static function getInt(params:Object, name:String, def:int=0, notNaN:Boolean=false):int
		{
			if (null==params)	return def;
			if (!params.hasOwnProperty(name))	return def;
			var t:int = int(params[name]);
			if (notNaN)
			{
				if ( isNaN(t) )
				{
					return def;
				}
			}
			return t;
		}
		
		/**
		 * 取得数字参数。
		 * @return 返回数字。
		 * @param params 参数对象。从该对象获取参数。
		 * @param name 参数名。
		 * @param def 默认值。
		 * @param notNaN 是否不能为NaN。当返回值应是NaN时，若notNaN为true，那就返回def。
		 */
		public static function getNumber(params:Object, name:String, def:Number=0, notNaN:Boolean=false):Number
		{
			if (null==params)	return def;
			if (!params.hasOwnProperty(name))	return def;
			var t:Number = Number(params[name]);
			if (notNaN)
			{
				if ( isNaN(t) )
				{
					return def;
				}
			}
			return t;
		}
		
		/**
		 * 取得字符串参数。
		 * @return 返回字符串。
		 * @param params 参数对象。从该对象获取参数。
		 * @param name 参数名。
		 * @param def 默认值。
		 * @param notEmpty 是否不能为空字符串。当返回字符串应是空字符串（""）时，若notEmpty为true，那就返回def。
		 */
		public static function getString(params:Object, name:String, def:String=null, notEmpty:Boolean=false):String
		{
			if (null==params)	return def;
			if (!params.hasOwnProperty(name))	return def;
			var s:String = String(params[name]);
			if (notEmpty)
			{
				if ( (null==s) || (s.length<=0) )
				{
					return def;
				}
			}
			return s;
		}

	}
}