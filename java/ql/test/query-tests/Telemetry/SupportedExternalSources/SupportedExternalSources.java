import java.io.InputStream;
import java.net.URL;

class SupportedExternalSources {
	public static void main(String[] args) throws Exception {
		URL github = new URL("https://www.github.com/");
		InputStream stream = github.openConnection().getInputStream();
	}
}
