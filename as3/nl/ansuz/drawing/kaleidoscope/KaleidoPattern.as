package nl.ansuz.drawing.kaleidoscope {
	import nl.ansuz.drawing.util.DisplayObjectOperations;
	
	import flash.display.DisplayObject;
	
	import flash.display.Sprite;

	/**
	 * @author Wijnand Warren
	 */
	public class KaleidoPattern extends Sprite {
		
		private var shapes:Vector.<DisplayObject>;
		private var colours:Vector.<uint>;
		
		/**
		 * CONSTRUCTOR
		 */
		public function KaleidoPattern(shapes:Vector.<DisplayObject>, colours:Vector.<uint>) {
			//trace("KaleidoPattern.KaleidoPattern()");
			
			this.shapes = shapes;
			this.colours = colours;
			
			init();
		}
		
		/**
		 * 
		 */
		private function init():void {
			constructPattern();
		}
		
		/**
		 * Builds the pattern
		 */
		private function constructPattern() : void {
			//trace("KaleidoPattern.constructPattern()");
			
			var shape:DisplayObject;
			
			for(var i:int = 0; i < shapes.length; i++) {
				// get shape element
				shape = DisplayObjectOperations.cloneDisplayObject( shapes[i] );
				// TODO: apply colour
				
				this.addChild(shape);
			}
		}
		
		/**
		 * Gets a clone of this Pattern
		 */
		public function clone():KaleidoPattern {
			//trace("KaleidoPattern.clone()");
			
			return new KaleidoPattern(shapes, colours);
		}
	}
}
