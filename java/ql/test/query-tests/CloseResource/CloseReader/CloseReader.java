import java.io.BufferedReader;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.IOException;
import java.io.InputStreamReader;

class CloseReader {

	public static void test1() throws IOException {
		BufferedReader br = new BufferedReader(new FileReader("C:\\test.txt"));
		System.out.println(br.readLine());
	}

	public static void test2() throws FileNotFoundException, IOException {
		BufferedReader br = null;
		try {
			br = new BufferedReader(new FileReader("C:\\test.txt"));
			System.out.println(br.readLine());
		}
		finally {
			if(br != null)
				br.close();  // 'br' is closed
		}
	}

	public static void test3() throws IOException {
		BufferedReader br = null;
		try {
			br = new BufferedReader(new FileReader("C:\\test.txt"));
			System.out.println(br.readLine());
		}
		finally {
			cleanup(br); // 'br' is closed within a helper method
		}
	}

	public static void test4() throws IOException {
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

	public static void test5() throws IOException {
		FileInputStream fis = null;
		InputStreamReader reader = null;
		try {
			fis = new FileInputStream("C:\\test.txt");
			reader = new InputStreamReader(fis);
			System.out.println(reader.read());
		}
		finally {
			if (fis != null)
				fis.close();  // 'fis' is closed
			if (reader != null)
				reader.close();  // 'reader' is closed
		}
	}

	public static void test6() throws IOException {
		BufferedReader br = null;
		try {
			br = new BufferedReader(new FileReader("C:\\test.txt"));
			System.out.println(br.readLine());
		}
		finally {
			cleanup(null, br); // 'br' is closed within a varargs helper method, invoked with multiple args
		}
	}

	public static void cleanup(java.io.Closeable... closeables) throws IOException {
		for (java.io.Closeable c : closeables) {
			if (c != null) {
				c.close();
			}
		}
	}

	public static class LogFile {
		private BufferedReader fileRd;
		LogFile(String path) {
			FileReader fr = null;
			try {
				fr = new FileReader(path);
			} catch (FileNotFoundException e) {
				System.out.println("Error: File not readable: " + path);
				System.exit(1);
			}
			init(fr);
		}
		private void init(InputStreamReader reader) {
			fileRd = new BufferedReader(reader);
		}
		public void readStuff() {
			System.out.println(fileRd.readLine());
			fileRd.close();
		}
	}
}
