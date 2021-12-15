import java.util.Collection;

class BadCheckOdd {
	
	public boolean goodLiteral() {
		return 10 % 2 > 0;
	}
	
	public boolean badLiteral() {
		return -10 % 2 > 0;
	}
	
	public boolean badBrackets1() {
		return -10 % 2 > (0);
	}
	
	public boolean badBrackets2() {
		return -10 % (2) > 0;//
	}
	
	public boolean badBrackets3() {
		return (-10) % 2 > 0;
	}
	
	public boolean badBrackets4() {
		return (-10 % 2) > 0;
	}

//  TODO: support for these cases
//	public boolean goodVarLiteral() {
//		int x = 10;
//		return x % 2 > 0;
//	}
//	
//	public boolean goodVarSize(Collection<String> collection) {
//		int x = collection.size();
//		return x % 2 > 0;
//	}
	
	public boolean goodArrayLength(int[] array) {
		return array.length % 2 > 0;
	}
	
	public boolean goodStringLength(String string) {
		return string.length() % 2 > 0;
	}
	
	public boolean badVarLiteral() {
		int x = -10;
		return x % 2 > 0;
	}
	
	public boolean badParam(int x) {
		return x % 2 > 0;
	}
	
	public boolean badSometimes(boolean positive) {
		int x;
		if(positive)
			x = 10;
		else
			x = -10;
		return x % 2 > 0;
	}
	
	private int f;
	public boolean badField() {
		return f % 2 >0;
	}
}