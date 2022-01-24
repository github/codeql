import java.io.FileInputStream;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.Reader;
import java.io.StringWriter;
import java.util.ArrayList;
import java.util.List;
import org.apache.commons.io.IOUtils;

class Test {
	public static void ioutils() throws java.io.FileNotFoundException, java.io.IOException {
		InputStream inp = new FileInputStream("test"); // user input

		InputStream buf = IOUtils.buffer(inp);
		List<String> lines = IOUtils.readLines(inp, "UTF-8");
		byte[] bytes = IOUtils.readFully(inp, 1000);
		InputStream buf2 = IOUtils.toBufferedInputStream(inp);
		Reader bufread = IOUtils.toBufferedReader(new InputStreamReader(inp));
		byte[] bytes2 = IOUtils.toByteArray(inp, 1000);
		char[] chars = IOUtils.toCharArray(inp, "UTF-8");
		String s = IOUtils.toString(inp, "UTF-8");
		InputStream is = IOUtils.toInputStream(s, "UTF-8");

		StringWriter writer = new StringWriter();
		writer.toString(); // not tainted
		IOUtils.copy(inp, writer, "UTF-8");
		writer.toString(); // tainted

		writer = new StringWriter();
		writer.toString(); // not tainted
		IOUtils.copyLarge(bufread, writer);
		writer.toString(); // tainted

		byte x;
		byte[] tgt = new byte[100];
		sink(tgt); // not tainted
		IOUtils.read(inp, tgt);
		sink(tgt); // tainted

		tgt = new byte[100];
		sink(tgt); // not tainted
		IOUtils.readFully(inp, tgt);
		sink(tgt); // tainted

		writer = new StringWriter();
		writer.toString(); // not tainted
		IOUtils.write(chars, writer);
		writer.toString(); // tainted

		writer = new StringWriter();
		writer.toString(); // not tainted
		IOUtils.writeChunked(chars, writer);
		writer.toString(); // tainted

		writer = new StringWriter();
		writer.toString(); // not tainted
		IOUtils.writeLines(lines, "\n", writer);
		writer.toString(); // tainted

		writer = new StringWriter();
		writer.toString(); // not tainted
		IOUtils.writeLines(new ArrayList<String>(), s, writer);
		writer.toString(); // tainted
	}

    static void sink(Object o) { }
}
