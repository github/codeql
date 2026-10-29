class Test {
	public static void main(String[] args) throws IOException {
		{
			long data;

			BufferedReader readerBuffered = new BufferedReader(
					new InputStreamReader(System.in, "UTF-8"));
			String stringNumber = readerBuffered.readLine();
			if (stringNumber != null) {
				data = Long.parseLong(stringNumber.trim());
			} else {
				data = 0;
			}

			// AVOID: potential truncation if input data is very large,
			// for example 'Long.MAX_VALUE'
			int scaled = (int)data;

			//...

			// GOOD: use a guard to ensure no truncation occurs
			int scaled2;
			if (data > Integer.MIN_VALUE && data < Integer.MAX_VALUE)
				scaled2 = (int)data;
			else
				throw new IllegalArgumentException("Invalid input");
		}
	}
}