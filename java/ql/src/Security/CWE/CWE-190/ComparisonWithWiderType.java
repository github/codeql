class Test {
	public static void main(String[] args) {
		
		{		
			int BIGNUM = Integer.MAX_VALUE;
			long MAXGET = Short.MAX_VALUE + 1;
			
			char[] buf = new char[BIGNUM];

			short bytesReceived = 0;
			
			// BAD: 'bytesReceived' is compared with a value of wider type.
			// 'bytesReceived' overflows before reaching MAXGET,
			// causing an infinite loop.
			while (bytesReceived < MAXGET) {
				bytesReceived += getFromInput(buf, bytesReceived);
			}
		}
		
		{
			long bytesReceived2 = 0;
			
			// GOOD: 'bytesReceived2' has a type at least as wide as MAXGET.
			while (bytesReceived2 < MAXGET) {
				bytesReceived2 += getFromInput(buf, bytesReceived2);
			}
		}
		
	}
	
	public static int getFromInput(char[] buf, short pos) {
		// write to buf
		// ...
		return 1;
	}
}