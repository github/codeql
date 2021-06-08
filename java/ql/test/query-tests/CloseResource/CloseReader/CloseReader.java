import java.io.BufferedReader;
import java.io.ByteArrayInputStream;
import java.io.CharArrayReader;
import java.io.Closeable;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.IOException;
import java.io.Reader;
import java.io.StringReader;
import java.util.zip.ZipFile;

class CloseReader {

	void test1() throws IOException {
		BufferedReader br = new BufferedReader(new FileReader("C:\\test.txt"));
		System.out.println(br.readLine());
	}

	void test2() throws IOException {
		InputStream in = new FileInputStream("file.bin");
		in.read();
	}

	void test3() throws IOException {
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

	void test4() throws IOException {
		ZipFile zipFile = new ZipFile("file.zip");
		System.out.println(zipFile.getComment());
	}

	void testCorrect1() throws IOException {
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

	void testCorrect2() throws IOException {
		BufferedReader br = null;
		try {
			br = new BufferedReader(new FileReader("C:\\test.txt"));
			System.out.println(br.readLine());
		}
		finally {
			cleanup(br); // 'br' is closed within a helper method
		}
	}

	void testCorrect3() throws IOException {
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

	void testCorrect4() throws IOException {
		BufferedReader br = null;
		try {
			br = new BufferedReader(new FileReader("C:\\test.txt"));
			System.out.println(br.readLine());
		}
		finally {
			cleanup(null, br); // 'br' is closed within a varargs helper method, invoked with multiple args
		}
	}

	void cleanup(Closeable... closeables) throws IOException {
		for (Closeable c : closeables) {
			if (c != null) {
				c.close();
			}
		}
	}

	static class LogFile {
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
		public void readStuff() throws IOException {
			System.out.println(fileRd.readLine());
			fileRd.close();
		}
	}

	// Classes which should be ignored
	void testIgnore() throws IOException {
		Reader r1 = new CharArrayReader(new char[] {'a'});
		r1.read();

		Reader r2 = new StringReader("a");
		r2.read();

		InputStream i1 = new ByteArrayInputStream(new byte[] {1});
		i1.read();
	}
}
