class Test {
	public static void main(String[] args) {
		{
			int data;

			BufferedReader readerBuffered = new BufferedReader(
					new InputStreamReader(System.in, "UTF-8"));
			String stringNumber = readerBuffered.readLine();
			if (stringNumber != null) {
				data = Integer.parseInt(stringNumber.trim());
			} else {
				data = 0;
			}

			// BAD: may overflow if input data is very large, for example
			// 'Integer.MAX_VALUE'
			int scaled = data * 10;

			//...
			
			// GOOD: use a guard to ensure no overflows occur
			int scaled2;
			if (data < Integer.MAX_VALUE / 10)
				scaled2 = data * 10;
			else
				scaled2 = Integer.MAX_VALUE;
		}
	}
}