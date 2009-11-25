package nl.ansuz.util.sequentialloader {
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	
	/**
	 * Loads a queue of files in sequence
	 * 
	 * 1. Instantiate: var myLoader:SequentialLoader = new SequentialLoader();
	 * 2. Populate the queue: myLoader.addToQueue("something.swf", 500);
	 * 3. Add listeners: myLoader.addEventListener(...);
	 * 4. Start loading: myLoader.startLoad();
	 * 
	 * Available events:
	 * 	- SequentialLoaderEvent.LOAD_PROGRESS
	 * 	- SequentialLoaderEvent.LOAD_COMPLETE	 * 	- SequentialLoaderEvent.LOAD_SEQUENCE_COMPLETE	 * 	- SequentialLoaderEvent.LOAD_ERROR
	 * 
	 * @author wijnand.warren
	 */
	public class SequentialLoader extends EventDispatcher {
		
		private var loadQueue:Array;		private var totalSize:uint;		private var loadedSize:uint;
				
		private var urlLoader:URLLoader;
		private var loader:Loader;
		
		private var _pauseAfterLoad:Boolean;		private var _totalFilesLoaded:int;
		
		public static const FILETYPE_IMAGE:String 	= "imageType";
		public static const FILETYPE_VIDEO:String 	= "videoType";		public static const FILETYPE_XML:String 	= "xmlType";
		
		private var debug:Boolean = false;

		/**
		 * CONSTRUCTOR
		 */
		public function SequentialLoader() {
			init();
		}
		
		/**
		 * 
		 */
		private function init():void {
			//Tracer.output( debug, "SequentialLoader.init()", toString() );
			loadQueue = new Array();
			totalSize = 0;			loadedSize = 0;
			_pauseAfterLoad = false;
			_totalFilesLoaded = 0;
			
			loader = new Loader();
			urlLoader = new URLLoader();
		}
		
		/**
		 * Adds an items to load to the load queue
		 * 
		 * @param url the url to load
		 * @param filesize the aproximate filesize
		 * @param filetype the type of file we're loading: FILETYPE_IMAGE, FILETYPE_VIDEO, FILETYPE_XML
		 */
		public function addToQueue(url:String, filesize:uint, filetype:String):void {
			var lo : LoadObject = new LoadObject(url, filesize, filetype);
			loadQueue.push(lo);
			totalSize += filesize;
		}
		
		/**
		 * Updates the item in the queue at position id.
		 * NOTE: The queue gets shifted with each item that is loaded.
		 * 
		 * @param id The index of the item to update
		 * @param url the url to load
		 * @param filesize the aproximate filesize
		 * @param filetype the type of file we're loading: FILETYPE_IMAGE, FILETYPE_VIDEO, FILETYPE_XML
		 */
		public function updateQueueItem(id:int, url:String = "", filesize:int = -1, filetype:String = ""):void {
			var item:LoadObject = loadQueue[id];			
			if(url != "") item.url = url;
			if(filesize >= 0) item.filesize = filesize;			if(filetype != "") item.filetype = filetype;
		}
		
		/**
		 * Starts the loading sequence
		 */
		public function startLoad():void {
			var lo:LoadObject = loadQueue[0];
			if(lo == null) {
				loadNext();
				return;
			}
			
			cancelLoad();
			loader = null;
			loader = new Loader();
			var lc : LoaderContext = new LoaderContext(true, ApplicationDomain.currentDomain);
			lc.checkPolicyFile = true;
			
			if ( lo.filetype != FILETYPE_IMAGE ) {
//				urlLoader = new URLLoader();
				addVideoListeners();
				urlLoader.load( new URLRequest( lo.url + "?nocache=" + Math.random() * 10000 ));
			}
			else {
				addImageListeners();
				
				loader.load( new URLRequest( lo.url  ), lc);
			}
			//Tracer.output( debug, "SequentialLoader.startLoad(): " + lo.url, toString() );
		}
		
		/**
		 * Whether or no to pause loading after the current item is done.
		 */
		public function set pauseAfterLoad(value:Boolean):void {
			_pauseAfterLoad = value;
		}
		
		/**
		 * The number of files loaded
		 */
		public function get totalFilesLoaded():int {
			return _totalFilesLoaded;
		}
		
		/**
		 * Call this method when you're done doing what you need to do after a file has loaded.
		 * This will start loading the next file.
		 */
		public function resumeLoad():void {
			//pauseAfterLoad = false;
			loadNext();
		}
		
		/**
		 * Cancels all loading
		 */
		public function cancelLoad():void {
			removeListeners();
			/*if( loader.loaderInfo.willTrigger(Event.COMPLETE) ) {
				loader.close();
			}
			else*/ if ( urlLoader.willTrigger(Event.COMPLETE) ) {
				urlLoader.close();
			}
		}
		
		// ============================
		// PRIVATE FUNCTIONS
		// ============================
		
		/**
		 * Loads the next item in the queue
		 */
		private function loadNext() : void {
			if(loadQueue.length > 1){
				loadedSize += loadQueue[0].filesize;
				loadQueue.shift();
				startLoad();
			}
			else {
				// dispatch 100% progress
				var cust_event : SequentialLoaderEvent = new SequentialLoaderEvent(SequentialLoaderEvent.LOAD_PROGRESS);
				cust_event.data = 100;
				dispatchEvent( cust_event );
				// we're completely done!
				cust_event = new SequentialLoaderEvent(SequentialLoaderEvent.LOAD_SEQUENCE_COMPLETE);
				cust_event.data = null;
				dispatchEvent( cust_event );
			}
		}
		
		private function addImageListeners():void {
			loader.contentLoaderInfo.addEventListener( Event.COMPLETE, complete );
			loader.contentLoaderInfo.addEventListener( IOErrorEvent.IO_ERROR, error );
			loader.contentLoaderInfo.addEventListener( ProgressEvent.PROGRESS, progress );
			loader.contentLoaderInfo.addEventListener( SecurityErrorEvent.SECURITY_ERROR, error);
		}
		

		private function addVideoListeners():void {
			urlLoader.addEventListener( Event.COMPLETE, complete );
			urlLoader.addEventListener( IOErrorEvent.IO_ERROR, error );
			urlLoader.addEventListener( SecurityErrorEvent.SECURITY_ERROR, error );
			urlLoader.addEventListener( ProgressEvent.PROGRESS, progress );
		}
		

		private function removeListeners():void {
			if (loader) {
				loader.contentLoaderInfo.removeEventListener( Event.COMPLETE, complete );
				loader.contentLoaderInfo.removeEventListener( IOErrorEvent.IO_ERROR, error );
				loader.contentLoaderInfo.removeEventListener( SecurityErrorEvent.SECURITY_ERROR, error );	
				loader.contentLoaderInfo.removeEventListener( ProgressEvent.PROGRESS, progress );
			}
			if (urlLoader) {		
				urlLoader.removeEventListener( Event.COMPLETE, complete );
				urlLoader.removeEventListener( IOErrorEvent.IO_ERROR, error );
				urlLoader.removeEventListener( SecurityErrorEvent.SECURITY_ERROR, error );		
				urlLoader.removeEventListener( ProgressEvent.PROGRESS, progress );
			}	
		}
		
		// ============================
		// EVENT HANDLERS
		// ============================
		
		/**
		 * Updates the overall progress
		 */
		private function progress( event:ProgressEvent ) : void {
			var weight:Number = loadQueue[0].filesize / totalSize;
			var perc_current:Number = (event.bytesLoaded / event.bytesTotal) * 100;
			var perc_total:Number = loadedSize / totalSize * 100;
			var perc:uint = perc_total + perc_current * weight;
			
			var cust_event : SequentialLoaderEvent = new SequentialLoaderEvent(SequentialLoaderEvent.LOAD_PROGRESS);
			cust_event.data = perc;
			dispatchEvent( cust_event );
			
			//Tracer.output( debug, "SequentialLoader.progress(event): " + perc, toString() );			
		}
		
		/**
		 * Loading of an item complete
		 */
		private function complete( event:Event ):void {
			//trace ( this + ' complete ' );
			removeListeners();
			_totalFilesLoaded++;

			var cust_event : SequentialLoaderEvent = new SequentialLoaderEvent(SequentialLoaderEvent.LOAD_COMPLETE);
			cust_event.data = {event: event, filetype: loadQueue[0].filetype};
			dispatchEvent( cust_event );

			if(!_pauseAfterLoad) loadNext();
		}
		
		/**
		 * Loading an item generated an error
		 */
		private function error( event:Event ):void {
			//Tracer.output( debug, "SequentialLoader.error(event)", toString() );
			removeListeners();
			_totalFilesLoaded++;
			
			var cust_event : SequentialLoaderEvent = new SequentialLoaderEvent(SequentialLoaderEvent.LOAD_ERROR);
			cust_event.data = event;
			dispatchEvent( cust_event );
			
			if(!_pauseAfterLoad) loadNext();
			/*Tracer.output( debug, "SequentialLoader.error(event)", toString(), Tracer.ERROR);
			Tracer.output( debug, "-- " + event);*/
		}
	}
}
