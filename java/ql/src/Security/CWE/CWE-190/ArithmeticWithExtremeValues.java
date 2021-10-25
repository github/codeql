class Test {
	public static void main(String[] args) {	
		{
			long i = Long.MAX_VALUE;
			// BAD: overflow
			long j = i + 1;
		}
		
		{
			int i = Integer.MAX_VALUE;
			// GOOD: no overflow
			long j = (long)i + 1;
		}
	}
}