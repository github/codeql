import java.io.IOException;
import java.net.URI;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import jakarta.ws.rs.core.Response;

public class UrlRedirectJakarta extends HttpServlet {
	protected void doGetJax(HttpServletRequest request, Response jaxResponse) throws Exception {
		// BAD
		jaxResponse.seeOther(new URI(request.getParameter("target")));

		// BAD
		jaxResponse.temporaryRedirect(new URI(request.getParameter("target")));
	}
}
