public class CloseWriterNestedFix {
	public static void main(String[] args) throws IOException {
		FileOutputStream fos = null;
		OutputStreamWriter writer = null;
		try {
			fos = new FileOutputStream("C:\\test.txt");
			writer = new OutputStreamWriter(fos);
			writer.write("Hello world!");
		}
		finally {
			if (writer != null)
				writer.close();  // 'writer' is closed
			if (fos != null)
				fos.close();  // 'fos' is closed
		}
	}
}