public class CloseWriterNested {
	public static void main(String[] args) throws IOException {
		OutputStreamWriter writer = null;
		try {
			// OutputStreamWriter may throw an exception, in which case the ...
			writer = new OutputStreamWriter(
					// ... FileOutputStream is not closed by the finally block
					new FileOutputStream("C:\\test.txt"), "UTF-8");
			writer.write("Hello world!");
		}
		finally {
			if (writer != null)
				writer.close();
		}
	}
}