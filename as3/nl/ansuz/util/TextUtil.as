package nl.ansuz.util {

	/**
	 * Some text utilities
	 * 
	 * @author Wijnand Warren
	 */
	public class TextUtil {

		/**
		 * The Levenshtein distance between two strings is defined as the minimum number 
		 * of edits needed to transform one string into the other, with the allowable 
		 * edit operations being insertion, deletion, or substitution of a single character.
		 * http://en.wikipedia.org/wiki/Levenshtein_distance
		 * 
		 * Implementation taken from: http://snipplr.com/view.php?codeview&id=14878
		 * 
		 * @param s1 The first string in the comparison
		 * @param s2 The second string in the comparison
		 * 
		 * @return The minimum number of edits needed to transform s1 into s2
		 */
		public static function levenshteinDistance(s1:String, s2:String):int {
			var m : int = s1.length;
			var n : int = s2.length;
			var matrix : Array = new Array();
			var line : Array;
			var i : int;
			var j : int;
			for (i = 0;i <= m;i++) {
				line = new Array();
				for (j = 0;j <= n;j++) {
					if (i != 0)line.push(0);
     				else line.push(j);
				}
				line[0] = i;
				matrix.push(line);
			}
			
			var cost : int; 
			for (i = 1;i <= m;i++)
			for (j = 1;j <= n;j++) {
				if (s1.charAt(i - 1) == s2.charAt(j - 1)) cost = 0;
				else cost = 1;
				matrix[i][j] = Math.min(matrix[i - 1][j] + 1, matrix[i][j - 1] + 1, matrix[i - 1][j - 1] + cost);
			}
			
			return matrix[m][n]; 
		}
	}
}
