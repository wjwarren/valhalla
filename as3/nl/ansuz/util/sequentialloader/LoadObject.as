package nl.ansuz.util.sequentialloader {

	/**
	 * Stores all data for an item to load, used by the SequentialLoader
	 * 
	 * @author wijnand.warren
	 */
	public class LoadObject {
		
		private var _url:String;		private var _filesize:uint;		private var _filetype:String;
		
		/**
		 * CONSTRUCTOR
		 */
		public function LoadObject(url:String, filesize:uint, filetype:String) {
			_url = url;
			_filesize = filesize;
			_filetype = filetype;
		}
		
		// ============================
		// GETTERS / SETTERS
		// ============================
		
		public function get url():String
		{
			return _url;
		}
		public function set url(value:String):void {
			_url = value;
		}
		
		public function get filesize():uint
		{
			return _filesize;
		}
		public function set filesize(value:uint):void {
			_filesize = value;
		}
		
		public function get filetype():String
		{
			return _filetype;
		}
		public function set filetype(value:String):void {
			_filetype = value;
		}

	}
}
