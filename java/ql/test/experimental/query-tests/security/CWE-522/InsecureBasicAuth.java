import org.apache.http.RequestLine;
import org.apache.http.client.methods.HttpRequestBase;
import org.apache.http.client.methods.HttpGet;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.message.BasicHttpRequest;
import org.apache.http.message.BasicRequestLine;

import java.net.URI;
import java.net.URL;
import java.net.HttpURLConnection;
import java.net.URLConnection;
import java.util.Base64;

public class InsecureBasicAuth {
	/**
	 * Test basic authentication with Apache HTTP POST request using string constructor.
	 */
	public void testApacheHttpRequest(String username, String password) {
		String host = "www.example.com";
		HttpRequestBase post = new HttpPost("http://"+host+"/rest/getuser.do?uid=abcdx");
		post.setHeader("Accept", "application/json");
		post.setHeader("Content-type", "application/json");
		
		String authString = username + ":" + password;
		byte[] authEncBytes = Base64.getEncoder().encode(authString.getBytes());
		String authStringEnc = new String(authEncBytes);

		post.addHeader("Authorization", "Basic " + authStringEnc);
	}

	/**
	 * Test basic authentication with Apache HTTP GET request.
	 */
	public void testApacheHttpRequest2(String url) throws java.io.IOException {
		String urlStr = "http://www.example.com:8000/payment/retrieve";
		HttpGet get = new HttpGet(urlStr);
		get.setHeader("Accept", "application/json");
		get.setHeader("Authorization", "Basic " + new String(Base64.getEncoder().encode("admin:test".getBytes())));
	}

	/**
	 * Test basic authentication with Apache HTTP POST request using URI create method.
	 */
	public void testApacheHttpRequest3(String username, String password) {
		String uriStr = "http://www.example.com/rest/getuser.do?uid=abcdx";
		HttpRequestBase post = new HttpPost(URI.create(uriStr));
		post.setHeader("Accept", "application/json");
		post.setHeader("Content-type", "application/json");
		
		String authString = username + ":" + password;
		byte[] authEncBytes = Base64.getEncoder().encode(authString.getBytes());
		String authStringEnc = new String(authEncBytes);

		post.addHeader("Authorization", "Basic " + authStringEnc);
	}

	/**
	 * Test basic authentication with Apache HTTP POST request using the URI constructor with one argument.
	 */
	public void testApacheHttpRequest4(String username, String password) {
		String uriStr = "http://www.example.com/rest/getuser.do?uid=abcdx";
		URI uri = new URI(uriStr);
		HttpRequestBase post = new HttpPost(uri);
		post.setHeader("Accept", "application/json");
		post.setHeader("Content-type", "application/json");
		
		String authString = username + ":" + password;
		byte[] authEncBytes = Base64.getEncoder().encode(authString.getBytes());
		String authStringEnc = new String(authEncBytes);

		post.addHeader("Authorization", "Basic " + authStringEnc);
	}

	/**
	 * Test basic authentication with Apache HTTP POST request using a URI constructor with multiple arguments.
	 */
	public void testApacheHttpRequest5(String username, String password) {
		HttpRequestBase post = new HttpPost(new URI("http", "www.example.com", "/test", "abc=123", null));
		post.setHeader("Accept", "application/json");
		post.setHeader("Content-type", "application/json");
		
		String authString = username + ":" + password;
		byte[] authEncBytes = Base64.getEncoder().encode(authString.getBytes());
		String authStringEnc = new String(authEncBytes);

		post.addHeader("Authorization", "Basic " + authStringEnc);
	}

	/**
	 * Test basic authentication with Apache HTTP `BasicHttpRequest` using string constructor.
	 */
	public void testApacheHttpRequest6(String username, String password) {
		String uriStr = "http://www.example.com/rest/getuser.do?uid=abcdx";
		BasicHttpRequest post = new BasicHttpRequest("POST", uriStr);
		post.setHeader("Accept", "application/json");
		post.setHeader("Content-type", "application/json");
		
		String authString = username + ":" + password;
		byte[] authEncBytes = Base64.getEncoder().encode(authString.getBytes());
		String authStringEnc = new String(authEncBytes);

		post.addHeader("Authorization", "Basic " + authStringEnc);
	}

	/**
	 * Test basic authentication with Apache HTTP `BasicHttpRequest` using `RequestLine`.
	 */
	public void testApacheHttpRequest7(String username, String password) {
		String uriStr = "http://www.example.com/rest/getuser.do?uid=abcdx";
		RequestLine requestLine = new BasicRequestLine("POST", uriStr, null);
		BasicHttpRequest post = new BasicHttpRequest(requestLine);
		post.setHeader("Accept", "application/json");
		post.setHeader("Content-type", "application/json");
		
		String authString = username + ":" + password;
		byte[] authEncBytes = Base64.getEncoder().encode(authString.getBytes());
		String authStringEnc = new String(authEncBytes);

		post.addHeader("Authorization", "Basic " + authStringEnc);
	}

	/**
	 * Test basic authentication with Java HTTP URL connection using the `URL(String spec)` constructor.
	 */
	public void testHttpUrlConnection(String username, String password) {
		String urlStr = "http://www.example.com/rest/getuser.do?uid=abcdx";
		String authString = username + ":" + password;
		String encoding = Base64.getEncoder().encodeToString(authString.getBytes("UTF-8"));
		URL url = new URL(urlStr);
		HttpURLConnection conn = (HttpURLConnection) url.openConnection();
		conn.setRequestMethod("POST");
		conn.setDoOutput(true);
		conn.setRequestProperty("Authorization", "Basic " + encoding);
	}

	/**
	 * Test basic authentication with Java HTTP URL connection using the `URL(String protocol, String host, String file)` constructor.
	 */
	public void testHttpUrlConnection2(String username, String password) {
		String host = "www.example.com";
		String path = "/rest/getuser.do?uid=abcdx";
		String protocol = "http";
		String authString = username + ":" + password;
		String encoding = Base64.getEncoder().encodeToString(authString.getBytes("UTF-8"));
		URL url = new URL(protocol, host, path);
		HttpURLConnection conn = (HttpURLConnection) url.openConnection();
		conn.setRequestMethod("POST");
		conn.setDoOutput(true);
		conn.setRequestProperty("Authorization", "Basic " + encoding);
	}

	/**
	 * Test basic authentication with Java HTTP URL connection using a constructor with private URL.
	 */
	public void testHttpUrlConnection3(String username, String password) {
		String host = "LOCALHOST";
		String authString = username + ":" + password;
		String encoding = Base64.getEncoder().encodeToString(authString.getBytes("UTF-8"));
		HttpURLConnection conn = (HttpURLConnection) new URL("http://"+(((host+"/rest/getuser.do")+"?uid=abcdx"))).openConnection();
		conn.setRequestMethod("POST");
		conn.setDoOutput(true);
		conn.setRequestProperty("Authorization", "Basic " + encoding);
	}
}