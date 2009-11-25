package nl.ansuz.util.sequentialloader {
	import flash.events.Event;

	/**
	 * Events used by the SequentialLoader class.<br>
	 * <b>DO NOT</b> assign to a command
	 * 
	 * @author wijnand.warren
	 */
	public class SequentialLoaderEvent extends Event {
		
		public static const LOAD_PROGRESS:String 			= "LoadProgress";		public static const LOAD_COMPLETE:String 			= "LoadComplete";		public static const LOAD_SEQUENCE_COMPLETE:String 	= "LoadSequenceComplete";		public static const LOAD_ERROR:String 				= "LoadError";
		
		// TODO: Stop using nasty type Object
		public var data:Object;
		
		/**
		 * CONSTRUCTOR
		 */
		public function SequentialLoaderEvent(type : String, bubbles : Boolean = false, cancelable : Boolean = false) {
			super(type, bubbles, cancelable);
		}
	}
}
