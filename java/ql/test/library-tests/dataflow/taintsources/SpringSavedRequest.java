import org.springframework.security.web.savedrequest.SavedRequest;
import org.springframework.security.web.savedrequest.SimpleSavedRequest;

public class SpringSavedRequest {
	SavedRequest sr;

	public void test() {
		sr.getRedirectUrl();
		sr.getCookies();
		sr.getHeaderValues("name");
		sr.getHeaderNames();
		sr.getParameterValues("name");
		sr.getParameterMap();
	}

	SimpleSavedRequest ssr;

	public void test2() {
		ssr.getRedirectUrl();
		ssr.getCookies();
		ssr.getHeaderValues("name");
		ssr.getHeaderNames();
		ssr.getParameterValues("name");
		ssr.getParameterMap();
	}
}
