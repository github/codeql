import javax.ws.rs.client.*;
import java.io.IOException;
import java.net.URI;
import java.net.*;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.Proxy.Type;
import java.io.InputStream;

import org.apache.http.client.methods.HttpGet;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class JaxWsSSRF extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        Client client = ClientBuilder.newClient();
        String url = request.getParameter("url");
        client.target(url);
    }

}
