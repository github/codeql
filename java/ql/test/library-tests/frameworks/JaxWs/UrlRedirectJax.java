import java.io.IOException;
import java.net.URI;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.ws.rs.core.Response;

public class UrlRedirectJax extends HttpServlet {
	protected void doGetJax(HttpServletRequest request, Response jaxResponse) throws Exception {
		// BAD
		jaxResponse.seeOther(new URI(request.getParameter("target")));

		// BAD
		jaxResponse.temporaryRedirect(new URI(request.getParameter("target")));
	}
}
