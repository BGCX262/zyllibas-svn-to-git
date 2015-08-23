/*

FormatMx
@author zyl910

[2011-09-29]
定义
fmtThousand
fmtThousandIntUp
strThousand
strThousandIntUp
strBytes
strBytesB


*/

package zyllibas
{
	import mx.formatters.*;
	
	/**
	 * FormatMx 类是一个静态类，其功用是为处理 格式化字符串 提供便利。它基于mx.formatters。
	 * @author zyl910
	 */ 
	public final class FormatMx
	{
		/**
		 * 国际单位制词头（SI, International System of Units）的千位倍数（Multiples）部分。有时也称为“十进制乘数词头”。
		 * <p>注意"k"是小写，这是为了避免与热力学单位K冲突。若需要大写，请再调用<code>String.toUpperCase()</code>方法。</p>
		 * @default ["k", "M", "G", "T", "P", "E", "Z", "Y"]
		 */
		public static const prefixSI:Vector.<String> = Vector.<String>(["k", "M", "G", "T", "P", "E", "Z", "Y"]);

		/**
		 * prefixSI 中元素的数量。
		 * @default <code>prefixSI.length</code>
		 * @see FormatMx.prefixSI
		 */
		public static const prefixSICount:int = prefixSI.length;

		/**
		 * 二进制乘数词头（Binary prefix。IEEE 1541/IEC 60027-2）。
		 * <p>标准——<br/>
		 * 1.IEC 60027-2：电信和电子学（Telecommunications and electronics）。<br/>
		 * 2.IEEE 1541：二进制复接用前缀的查验标准（Standard for prefixes for binary multiples）。<br/>
		 * </p>
		 * @default ["Ki", "Mi", "Gi", "Ti", "Pi", "Ei", "Zi", "Yi"]
		 */
		public static const prefixBi:Vector.<String> = Vector.<String>(["Ki", "Mi", "Gi", "Ti", "Pi", "Ei", "Zi", "Yi"]);
		
		/**
		 * prefixBi 中元素的数量。
		 * @default <code>prefixBi.length</code>
		 * @see FormatMx.prefixBi
		 */
		public static const prefixBiCount:int = prefixBi.length;
		
		/**
		 * 返回NumberFormatter对象，它已配置为千位分隔符模式。
		 */
		public static const fmtThousand:NumberFormatter = new NumberFormatter();
		
		/**
		 * 返回NumberFormatter对象，它已配置为向上舍入整数的千位分隔符模式。
		 */
		public static const fmtThousandIntUp:NumberFormatter = new NumberFormatter();
		
		// public static function FormatMx()	// 静态构造函数
		{
			prefixSI.fixed = true;
			fmtThousand.useNegativeSign = true;
			fmtThousand.useThousandsSeparator = true;
			fmtThousandIntUp.useNegativeSign = true;
			fmtThousandIntUp.useThousandsSeparator = true;
			fmtThousandIntUp.precision = 0;
			fmtThousandIntUp.rounding = NumberBaseRoundType.UP;
		}
		
		/**
		 * 返回千位分隔符模式的格式字符串。
		 * @return 格式化的 String。如果发生错误，则为空字符串。
		 * @param value 要设置格式的值。
		 */
		public static function strThousand(value:Object):String
		{
			return fmtThousand.format(value);
		}
		
		/**
		 * 返回向上舍入整数的千位分隔符模式的格式字符串。
		 * @return 格式化的 String。如果发生错误，则为空字符串。
		 * @param value 要设置格式的值。
		 */
		public static function strThousandIntUp(value:Object):String
		{
			return fmtThousandIntUp.format(value);
		}
		
		/**
		 * 返回字节数的格式字符串（无“B”后缀）。
		 * @return 格式化的 String。如果发生错误，则为空字符串。
		 * @param value 要设置格式的值。
		 * @param fmt 数值格式。若为null，就采用fmtThousandIntUp。
		 * @param is1000 是否是以1000为基数。默认为false，表示以1024为基数，即 1K=1024。当为true时，表示以1000为基数，即 1K=1000。
		 * @param binaryPrefix 是否采用二进制乘数词头。当该值为true且is1000=false时，就表示使用二进制乘数词头。否则为国际单位制词头。
		 * @param strSpace 数值与乘数词头之间的填充字符串。默认为空。
		 * @param levelThreshold 级别阈值。若<code>value&lt;1024 * levelThreshold</code>，则原样显示数值；若<code>value&gt;=1024 * levelThreshold</code>，就将数值除以1024后再显示，以此类推。如levelThreshold=10时，f(10239)="10239"，f(10240)="10k"。
		 * @see FormatMx.prefixSI
		 * @see FormatMx.prefixBi
		 */
		public static function strBytes(value:Number, fmt:NumberFormatter=null, is1000:Boolean=false, binaryPrefix:Boolean=false, strSpace:String="", levelThreshold:Number=10):String
		{
			var v:Number = Math.max(0, value);
			var idxLevel:int = 0;	// 千位乘数的级别。0无，1k，2M...
			var base:Number = is1000?1000:1024;	// 基数
			var fDiv:Number = 1;	// 级别除数
			var _levelThreshold:Number = levelThreshold * (1 - (1 / (2*base)));	// 浮点误差修正
			for(var i:int=0; i<prefixSICount; ++i)
			{
				if (v <= (fDiv*base*_levelThreshold))	break;
				// 下一级别
				fDiv *= base;
				++idxLevel;
			}
			v = v / fDiv;
			// 输出
			var _fmt:NumberFormatter = (null!=fmt) ? fmt : fmtThousandIntUp;
			var s:String = _fmt.format(v) + strSpace;
			if (idxLevel>0)
			{
				if ( binaryPrefix && (!is1000) )
				{
					s += prefixBi[idxLevel-1];
				}
				else
				{
					s += prefixSI[idxLevel-1];
				}
			}
			return s;
		}
		
		/**
		 * 返回字节数的格式字符串（带“B”后缀）。
		 */
		public static function strBytesB(value:Number, fmt:NumberFormatter=null, is1000:Boolean=false, binaryPrefix:Boolean=false, strSpace:String="", levelThreshold:Number=10):String
		{
			return strBytes(value, fmt, is1000, binaryPrefix, strSpace, levelThreshold) + "B";
		}
	}
}