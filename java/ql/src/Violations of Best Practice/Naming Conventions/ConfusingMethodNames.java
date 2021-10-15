public class InternetResource
{
	private String protocol;
	private String host;
	private String path;

	// ...

	public String toUri() {
		return protocol + "://" + host + "/" + path;
	}

	// ...

	public String toURI() {
		return toUri();
	}
}