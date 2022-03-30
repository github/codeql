public class CloseReader {
	public static void main(String[] args) throws IOException {
		BufferedReader br = new BufferedReader(new FileReader("C:\\test.txt"));
		System.out.println(br.readLine());
		// ...
	}
}