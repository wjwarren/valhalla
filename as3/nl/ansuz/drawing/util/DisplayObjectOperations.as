package nl.ansuz.drawing.util {

	import flash.geom.Rectangle;
	import flash.display.DisplayObject;
	
	/**
	 * @author Wijnand Warren
	 */
	public class DisplayObjectOperations {
		
		/**
		 * Creates a duplicate of the DisplayObject passed.
		 * similar to duplicateMovieClip in AVM1
		 * 
		 * Thanks to com.senocular.display
		 * 
		 * @param obj the display object to duplicate
		 * @return a duplicate instance of object to duplicate
		 */
		public static function cloneDisplayObject(obj:DisplayObject):DisplayObject {
			// create duplicate
			var targetClass:Class = Class( Object(obj).constructor );
			var duplicate:DisplayObject = new targetClass();
			
			// duplicate properties
			duplicate.transform = obj.transform;
			duplicate.filters = obj.filters;
			duplicate.cacheAsBitmap = obj.cacheAsBitmap;
			duplicate.opaqueBackground = obj.opaqueBackground;
			if (obj.scale9Grid) {
				var rect:Rectangle = obj.scale9Grid;
				// Flash 9 bug where returned scale9Grid is 20x larger than assigned
				rect.x /= 20, rect.y /= 20, rect.width /= 20, rect.height /= 20;
				duplicate.scale9Grid = rect;
			}
			
			// TODO: Recurse!
			
			return duplicate;
		}
		
	}
}
