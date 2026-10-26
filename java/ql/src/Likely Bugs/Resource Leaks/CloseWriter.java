public class CloseWriter {
	public static void main(String[] args) throws IOException {
		BufferedWriter bw = new BufferedWriter(new FileWriter("C:\\test.txt"));
		bw.write("Hello world!");
		// ...
	}
}