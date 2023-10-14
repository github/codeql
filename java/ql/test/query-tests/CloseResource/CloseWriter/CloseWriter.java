import java.io.BufferedWriter;
import java.io.ByteArrayOutputStream;
import java.io.CharArrayWriter;
import java.io.Closeable;
import java.io.FileOutputStream;
import java.io.FileWriter;
import java.io.IOException;
import java.io.OutputStream;
import java.io.OutputStreamWriter;
import java.io.StringWriter;
import java.io.Writer;
import java.util.zip.ZipFile;

class CloseWriter {

	void test1() throws IOException {
		BufferedWriter bw = new BufferedWriter(new FileWriter("C:\\test.txt"));
		bw.write("test");
	}

	void test2() throws IOException {
		OutputStream out = new FileOutputStream("test.bin");
		out.write(1);
	}

	void test3() throws IOException {
		OutputStreamWriter writer = null;
		try {
			// OutputStreamWriter may throw an exception, in which case the ...
			writer = new OutputStreamWriter(
					// ... FileOutputStream is not closed by the finally block
					new FileOutputStream("C:\\test.txt"), "UTF-8");
			writer.write("test");
		}
		finally {
			if (writer != null)
				writer.close();
		}
	}

	void testCorrect1() throws IOException {
		BufferedWriter bw = null;
		try {
			bw = new BufferedWriter(new FileWriter("C:\\test.txt"));
			bw.write("test");
		}
		finally {
			if(bw != null)
				bw.close();  // 'bw' is closed
		}
	}

	void testCorrect2() throws IOException {
		BufferedWriter bw = null;
		try {
			bw = new BufferedWriter(new FileWriter("C:\\test.txt"));
			bw.write("test");
		}
		finally {
			cleanup(bw); // 'bw' is closed within a helper method
		}
	}

	void testCorrect3() throws IOException {
		FileOutputStream fos = null;
		OutputStreamWriter writer = null;
		try {
			fos = new FileOutputStream("C:\\test.txt");
			writer = new OutputStreamWriter(fos);
			writer.write("test");
		}
		finally {
			if (fos != null)
				fos.close();  // 'fos' is closed
			if (writer != null)
				writer.close();  // 'writer' is closed
		}
	}

	void testCorrect4() throws IOException {
		BufferedWriter bw = null;
		try {
			bw = new BufferedWriter(new FileWriter("C:\\test.txt"));
			bw.write("test");
		}
		finally {
			cleanup(null, bw); // 'bw' is closed within a varargs helper method, invoked with multiple args
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
		private BufferedWriter fileWr;
		LogFile(String path) {
			FileWriter fw = null;
			try {
				fw = new FileWriter(path);
			} catch (IOException e) {
				System.out.println("Error: File not readable: " + path);
				System.exit(1);
			}
			init(fw);
		}
		private void init(OutputStreamWriter writer) {
			fileWr = new BufferedWriter(writer);
		}
		public void writeStuff() throws IOException {
			fileWr.write("test");
			fileWr.close();
		}
	}

	// Classes which should be ignored
	void testIgnore() throws IOException {
		Writer w1 = new CharArrayWriter();
		w1.write("test");

		Writer w2 = new StringWriter();
		w2.write("test");

		OutputStream o1 = new ByteArrayOutputStream();
		o1.write(1);
	}
}
