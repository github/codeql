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

            // GOOD: sanitisation by concatenation with a prefix that prevents targeting an arbitrary host.
            // We test a few different ways of sanitisation: via string conctentation (perhaps nested),
            // via a stringbuilder and via String.format.
            String safeUri3 = "https://example.com/" + request.getParameter("uri3");
            HttpRequest r3 = HttpRequest.newBuilder(new URI(safeUri3)).build();
            client.send(r3, null);

            String safeUri4 = "https://example.com/" + ("someprefix" + request.getParameter("uri4"));
            HttpRequest r4 = HttpRequest.newBuilder(new URI(safeUri4)).build();
            client.send(r4, null);

            StringBuilder safeUri5 = new StringBuilder();
            safeUri5.append("https://example.com/").append(request.getParameter("uri5"));
            HttpRequest r5 = HttpRequest.newBuilder(new URI(safeUri5.toString())).build();
            client.send(r5, null);

            String safeUri6 = String.format("https://example.com/%s", request.getParameter("uri6"));
            HttpRequest r6 = HttpRequest.newBuilder(new URI(safeUri6)).build();
            client.send(r6, null);

            String safeUri7 = String.format("%s/%s", "https://example.com", request.getParameter("uri7"));
            HttpRequest r7 = HttpRequest.newBuilder(new URI(safeUri7)).build();
            client.send(r7, null);

            String safeUri8 = String.format("%s%s", "https://example.com/", request.getParameter("uri8"));
            HttpRequest r8 = HttpRequest.newBuilder(new URI(safeUri8)).build();
            client.send(r8, null);

            String safeUri9 = String.format("http://%s", "myserver.com") + "/" + request.getParameter("uri9");
            HttpRequest r9 = HttpRequest.newBuilder(new URI(safeUri9)).build();
            client.send(r9, null);

            // BAD: cases where a string that would sanitise is used, but occurs in the wrong
            // place to sanitise user input:
            String unsafeUri3 = request.getParameter("baduri3") + "https://example.com/";
            HttpRequest unsafer3 = HttpRequest.newBuilder(new URI(unsafeUri3)).build();
            client.send(unsafer3, null);

            String unsafeUri4 = ("someprefix" + request.getParameter("baduri4")) + "https://example.com/";
            HttpRequest unsafer4 = HttpRequest.newBuilder(new URI(unsafeUri4)).build();
            client.send(unsafer4, null);

            StringBuilder unsafeUri5 = new StringBuilder();
            unsafeUri5.append(request.getParameter("baduri5")).append("https://example.com/");
            HttpRequest unsafer5 = HttpRequest.newBuilder(new URI(unsafeUri5.toString())).build();
            client.send(unsafer5, null);

            String unsafeUri6 = String.format("%shttps://example.com/", request.getParameter("baduri6"));
            HttpRequest unsafer6 = HttpRequest.newBuilder(new URI(unsafeUri6)).build();
            client.send(unsafer6, null);

            String unsafeUri7 = String.format("%s/%s", request.getParameter("baduri7"), "https://example.com");
            HttpRequest unsafer7 = HttpRequest.newBuilder(new URI(unsafeUri7)).build();
            client.send(unsafer7, null);

            String unsafeUri8 = String.format("%s%s", request.getParameter("baduri8"), "https://example.com/");
            HttpRequest unsafer8 = HttpRequest.newBuilder(new URI(unsafeUri8)).build();
            client.send(unsafer8, null);

            String unsafeUri9 = request.getParameter("baduri9") + "/" + String.format("http://%s", "myserver.com");
            HttpRequest unsafer9 = HttpRequest.newBuilder(new URI(unsafeUri9)).build();
            client.send(unsafer9, null);

        } catch (Exception e) {
            // TODO: handle exception
        }
    }
}