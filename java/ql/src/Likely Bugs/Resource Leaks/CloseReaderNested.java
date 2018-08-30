public class CloseReaderNested {
	public static void main(String[] args) throws IOException {
		InputStreamReader reader = null;
		try {
			// InputStreamReader may throw an exception, in which case the ...
			reader = new InputStreamReader(
					// ... FileInputStream is not closed by the finally block
					new FileInputStream("C:\\test.txt"), "UTF-8");
			System.out.println(reader.read());
		}
		finally {
			if (reader != null)
				reader.close();
		}
	}
}