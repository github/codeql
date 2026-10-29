import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
import java.net.URL;

class SupportedExternalSinks {
	public static void main(String[] args) throws Exception {
		new FileWriter(new File("foo"));
		new URL("http://foo").openStream();
	}
}
