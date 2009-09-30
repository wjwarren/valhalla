package nl.ansuz.drawing.util {

	/**
	 * @author Wijnand Warren
	 */
	public class ColourOperations {
		// Nothing, all static methods...
	}
	
	/**
	 * Splits R, G, B properties from a hex value
	 * 
	 * @param hex The hex value to split.
	 * @return A Vector containing the separate R, G, G values.
	 */
	public static function splitRGBFromHex(hex:uint):Vector.<uint> {
		var r:uint = hex >> 16;
		var g:uint = hex >> 8 & 0xFF;
		var b:uint = hex & 0xFF;
		
		var split:Vector.<uint> = new Vector.<uint>();
		split[0] = r;
		split[1] = g;
		split[2] = b;
		
		return split;
	}
}
