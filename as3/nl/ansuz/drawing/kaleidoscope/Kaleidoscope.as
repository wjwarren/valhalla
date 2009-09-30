package nl.ansuz.drawing.kaleidoscope {
	
	import flash.display.*;
	
	public class Kaleidoscope extends Sprite {
		
		private var radius:int;
		private var patterns:Vector.<KaleidoPattern>;
		private var segments:int;
		
		/**
		 * CONSTRUCTOR
		 */
		public function Kaleidoscope(radius:int, patterns:Vector.<KaleidoPattern>, segments:int = 8) {
			this.radius = radius;
			this.patterns = patterns;
			this.segments = segments;
			
			init();
		}
		
		/**
		 * Initializes the Kaleidoscope.
		 */
		private function init():void {
			drawScope();
		}
		
		/**
		 * Draws the entire kaleidoscope
		 */
		private function drawScope():void {
			for(var i:int = 0; i < segments; i++) {
				drawSegment(i);
			}
		}
		
		/**
		 * Draws a single segment (or reflection) of the 
		 * kaleidoscope image
		 * 
		 * @param part The part of the Kaleidoscope to draw.
		 */
		private function drawSegment(part:int):void {
			//trace("Kaleidoscope.drawSegment()");
			
			var segment:Sprite = new Sprite();
			segment.x = segment.y = radius * 0.5;
			segment.rotation = 360 / segments * part;
			
			var patternRotation:Number = 360 / segments / patterns.length;
			var patternHolder:Sprite;
			var pattern:KaleidoPattern;
			
			// TODO: Begin and end with 1/2 of the 1st pattern
			for(var i:int = 0; i < patterns.length; i++) {
				patternHolder = new Sprite();
				pattern = patterns[i].clone();
				
				// offset the pattern in height
				pattern.y = radius * -0.5;
				patternHolder.addChild(pattern);
				
				// rotate the pattern to the right position
				patternHolder.rotation = patternRotation * i;
				
				segment.addChild(patternHolder);
			}
			// TODO: Draw mask? Probably not needed due to proper overlay
			// TODO: Except for the last element, so draw mask anyway...
			
			addChild(segment);
		}
	}
	
}