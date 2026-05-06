import java.io.IOException;

import org.apache.http.HttpHost;
import org.apache.http.HttpRequest;
import org.apache.http.client.HttpClient;
import org.apache.http.client.ResponseHandler;
import org.apache.http.client.methods.HttpUriRequest;
import org.apache.http.message.BasicHttpRequest;
import org.apache.http.protocol.HttpContext;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class ApacheHttpClientExecuteSSRF extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {

            String sink = request.getParameter("host"); // $ Source

            HttpHost host = new HttpHost(sink);
            HttpRequest req = new BasicHttpRequest("GET", "/");
            HttpUriRequest uriReq = (HttpUriRequest) (Object) sink;
            HttpContext context = null;
            HttpClient client = null;
            ResponseHandler<Object> handler = null;

            client.execute(host, req); // $ Alert
            client.execute(host, req, context); // $ Alert
            client.execute(host, req, handler); // $ Alert
            client.execute(host, req, handler, context); // $ Alert
            client.execute(uriReq); // $ Alert
            client.execute(uriReq, context); // $ Alert
            client.execute(uriReq, handler); // $ Alert
            client.execute(uriReq, handler, context); // $ Alert

        } catch (Exception e) {
            // TODO: handle exception
        }
    }
}
