import java.io.InputStream;
import java.io.IOException;

import java.net.HttpURLConnection;
import java.net.URLConnection;
import java.net.URI;
import java.net.URL;

import javax.net.ssl.HttpsURLConnection;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.ServletException;

import org.apache.http.HttpRequest;
import org.apache.http.message.BasicHttpRequest;
import org.apache.http.message.BasicHttpEntityEnclosingRequest;

class SSRF {
	/** Test url.openStream() */
	public void openUrlStream(HttpServletRequest servletRequest) {
		String urlStr = servletRequest.getParameter("url");
		URL uri = new URL(urlStr);
		InputStream input = uri.openStream();
	}

	/** Test url.openConnection() */
	public void openUrlConnection(HttpServletRequest servletRequest) {
		String urlStr = servletRequest.getParameter("url");
		URL uri = new URL(urlStr);
		URLConnection input = uri.openConnection();
	}

	/** Test Apache HttpRequest */
	public void service(HttpServletRequest servletRequest, HttpServletResponse servletResponse)
			throws ServletException, IOException {
		String method = servletRequest.getMethod();
		String proxyRequestUri = servletRequest.getParameter("url");

		URI targetUriObj = new URI(proxyRequestUri);

		HttpRequest proxyRequest;
		// spec: RFC 2616, sec 4.3: either of these two headers signal that there is a
		// message body.
		if (servletRequest.getHeader("CONTENT_LENGTH") != null
				|| servletRequest.getHeader("TRANSFER_ENCODING") != null) {
				BasicHttpEntityEnclosingRequest eProxyRequest = new BasicHttpEntityEnclosingRequest(method, proxyRequestUri);
		} else {
			proxyRequest = new BasicHttpRequest(method, proxyRequestUri);
		}
	}

}