import java.io.IOException;
import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class RequestForgery extends HttpServlet {
    private static final String VALID_URI = "http://lgtm.com";
    private HttpClient client = HttpClient.newHttpClient();

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {

            URI uri = new URI(request.getParameter("uri"));
            // BAD: a request parameter is incorporated without validation into a Http
            // request
            HttpRequest r = HttpRequest.newBuilder(uri).build();
            client.send(r, null);

            // GOOD: the request parameter is validated against a known fixed string
            if (VALID_URI.equals(request.getParameter("uri"))) {
                HttpRequest r2 = HttpRequest.newBuilder(uri).build();
                client.send(r2, null);
            }
        } catch (Exception e) {
            // TODO: handle exception
        }
    }
}