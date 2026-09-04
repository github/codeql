import java.io.*;

public class Test {
	public static void main(String[] args) throws IOException {
		new File("foo").createNewFile(); // $ Alert
		new File("foo").delete(); // Don't flag: there's usually nothing to do
		new File("foo").mkdir(); // $ Alert
		new File("foo").mkdirs(); // Don't flag: the return value is uninformative/misleading
		new File("foo").renameTo(new File("bar")); // $ Alert
		new File("foo").setLastModified(0L); // $ Alert
		new File("foo").setReadOnly(); // $ Alert
		new File("foo").setWritable(true); // $ Alert
	}
}
