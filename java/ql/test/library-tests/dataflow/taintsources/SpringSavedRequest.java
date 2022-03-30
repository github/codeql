import org.springframework.security.web.savedrequest.SavedRequest;
import org.springframework.security.web.savedrequest.SimpleSavedRequest;

public class SpringSavedRequest {
	SavedRequest sr;

	private static void sink(Object o) {}

	public void test() {
		sink(sr.getRedirectUrl()); // $hasRemoteValueFlow
		sink(sr.getCookies()); // $hasRemoteValueFlow
		sink(sr.getHeaderValues("name")); // $hasRemoteValueFlow
		sink(sr.getHeaderNames()); // $hasRemoteValueFlow
		sink(sr.getParameterValues("name")); // $hasRemoteValueFlow
		sink(sr.getParameterMap()); // $hasRemoteValueFlow
	}

	SimpleSavedRequest ssr;

	public void test2() {
		sink(ssr.getRedirectUrl()); // $hasRemoteValueFlow
		sink(ssr.getCookies()); // $hasRemoteValueFlow
		sink(ssr.getHeaderValues("name")); // $hasRemoteValueFlow
		sink(ssr.getHeaderNames()); // $hasRemoteValueFlow
		sink(ssr.getParameterValues("name")); // $hasRemoteValueFlow
		sink(ssr.getParameterMap()); // $hasRemoteValueFlow
	}
}
