import jakarta.ws.rs.client.*;
import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class JakartaWsSSRF extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        Client client = ClientBuilder.newClient();
        String url = request.getParameter("url");
        client.target(url); // $ SSRF
    }

}
