public class CloseWriterFix {
	public static void main(String[] args) throws IOException {
		BufferedWriter bw = null;
		try {
			bw = new BufferedWriter(new FileWriter("C:\\test.txt"));
			bw.write("Hello world!");
		}
		finally {
			if(bw != null)
				bw.close();  // 'bw' is closed
		}
		// ...
	}
}