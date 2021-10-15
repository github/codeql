import java.io.*;

public class Test {
	public static void main(String[] args) throws IOException {
		new File("foo").createNewFile();
		new File("foo").delete(); // Don't flag: there's usually nothing to do
		new File("foo").mkdir();
		new File("foo").mkdirs(); // Don't flag: the return value is uninformative/misleading
		new File("foo").renameTo(new File("bar"));
		new File("foo").setLastModified(0L);
		new File("foo").setReadOnly();
		new File("foo").setWritable(true);
	}
}
