public static void main(String args[]) {
	String[] words = {"Who", "is", "John", "Galt"};
	String[][] wordMatrix = {{"There", "is"}, {"no", "spoon"}};
	
	// BAD: This implicitly uses 'Object.toString' to convert the contents
	// of 'words[]', and prints out something similar to:
	// [Ljava.lang.String;@459189e1
	System.out.println(words);
	
	// GOOD: 'Arrays.toString' calls 'toString' on
	// each of the array's elements. The statement prints out:
	// [Who, is, John, Galt]
	System.out.println(Arrays.toString(words));
	
	// ALMOST RIGHT: This calls 'toString' on each of the multi-dimensional 
	// array's elements. However, because the elements are arrays, the statement
	// prints out something similar to:
	// [[Ljava.lang.String;@55f33675, [Ljava.lang.String;@527c6768]]
	System.out.println(Arrays.toString(wordMatrix));
	
	// GOOD: This properly prints out the contents of the multi-dimensional array:
	// [[There, is], [no, spoon]]
	System.out.println(Arrays.deepToString(wordMatrix));
}