package nl.ansuz.util {

	import flash.display.Sprite;
	import flash.ui.ContextMenu;
	import flash.ui.ContextMenuItem;

	/**
	 * @author Wijnand Warren
	 */
	public class Version {
		
		private static const VERSION:String = "14-10-2009 16:21:39";		private static const MENU_PREFIX:String = "Version: ";
		
		private var menuHolder:Sprite;
		
		/**
		 * CONSTRUCTOR
		 */
		public function Version(menuHolder:Sprite) {
			this.menuHolder = menuHolder;
			
			init();
		}
		
		/**
		 * 
		 */
		private function init() : void {
			addVersion();
		}
		
		/**
		 * Adds the version number to the context menu
		 */
		private function addVersion() : void {
			var contextMenu:ContextMenu = new ContextMenu();
			
			var item:ContextMenuItem = new ContextMenuItem(MENU_PREFIX + VERSION);
            contextMenu.customItems.push(item);
            
            menuHolder.contextMenu = contextMenu;
		}
	}
}
