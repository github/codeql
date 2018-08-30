/*>>> import org.checkerframework.checker.nullness.qual.Nullable;*/
public class CommentedCode {

	public static int method(){
//		int commentedOutCode = 6;

//		int commentedOutCode = 6; // with a trailing comment
				
//		String s = "commented code with";
//
//
//
//		String t = "many blank lines";
		
//		not commented-out code
		
//		not commented-out code
//		on multiple lines
//		ending with a semicolon;
		
		/** javadoc style comment */
		
		/** 
		 * javadoc style comment with code tags:
		 * <code>
		 * 	int looksLikeCode;
		 *  int butIsnt;
		 *  for(int i=1;i<100;i++){
		 *    System.out.println("not code!!!");
		 *  }
		 * </code>
		 */
		
		/** 
		 * javadoc style comment with pre tags:
		 * <pre>
		 * 	int looksLikeCode;
		 *  int butIsnt;
		 *  for(int i=1;i<100;i++){
		 *    System.out.println("not code!!!");
		 *  }
		 * </pre>
		 */
		
		/**
		 * 	int blockCommentedCode;
		 *  for(int i=1;i<100;i++){
		 *    System.out.println("this is code!!!");
		 *  }
		 */
		
		/**
		 * JavaDoc style comment containing HTML entities (e.g. for documentation of XML-related things). The semicolons should not trigger any alerts.
		 * 
		 * &gt;
		 * &gt;
		 * &gt;
		 */
			
		/**
		 * JavaDoc style comment containing HTML entities (e.g. for documentation of XML-related things). The semicolons should not trigger any alerts.
		 * 
		 * &agrave;
		 * &agrave;
		 * &agrave;
		 */
		
		/**
		 * JavaDoc style comment containing HTML entities using decimal encoding. The semicolons should not trigger any alerts.
		 * 
		 * a&#768;
		 * a&#768;
		 * a&#768;
		 */
		
		/**
		 * JavaDoc style comment containing HTML entities using hexadecimal encoding. The semicolons should not trigger any alerts.
		 * 
		 * &#768F;
		 * &#768F;
		 * &#768F;
		 */
		
		/**
		 * Incorrect HTML entities should trigger alert on semicolon
		 * 
		 * &nbsp ;
		 * &nbsp ;
		 * &nbsp ;
		 */
	}
	
//	public static int commentedOutMethod(){
//		
//		return 123;
//		
//	}

    // JSNI
    class Element {}
    public native void scrollTo(Element elem) /*-{
        elem.scrollIntoView(true);
    }-*/;

    String empty = ""; //$NON-NLS-1$ 
    String alsoEmpty = "" + ""; //$NON-NLS-1$ //$NON-NLS-2$

// Java Modeling Language (JML) comments
//@ assert ...;
//@ assert ...;

//    
//    /*
//     * 
//     */
//    /**
//     * 
//     */
//    @Deprecated
//    void commentedOutMethodWithAnnotationsAndEmptyComments() {}

    /***
     System.out.println("");
     ***/
}
