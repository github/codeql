public class CloseReaderFix {
	public static void main(String[] args) throws IOException {
		BufferedReader br = null;
		try {
			br = new BufferedReader(new FileReader("C:\\test.txt"));
			System.out.println(br.readLine());
		}
		finally {
			if(br != null)
				br.close();  // 'br' is closed
		}
		// ...
	}
}