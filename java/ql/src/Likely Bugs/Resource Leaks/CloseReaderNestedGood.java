public class CloseReaderNestedFix {
	public static void main(String[] args) throws IOException {
		FileInputStream fis = null;
		InputStreamReader reader = null;
		try {
			fis = new FileInputStream("C:\\test.txt");
			reader = new InputStreamReader(fis);
			System.out.println(reader.read());
		}
		finally {
			if (reader != null)
				reader.close();  // 'reader' is closed
			if (fis != null)
				fis.close();  // 'fis' is closed
		}
	}
}