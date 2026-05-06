import java.io.IOException;
import java.net.URI;

import org.apache.http.client.fluent.Request;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class ApacheHttpFluentSSRF extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {

            String sink = request.getParameter("uri"); // $ Source
            URI uri = new URI(sink);

            Request.Delete(sink); // $ Alert
            Request.Delete(uri); // $ Alert
            Request.Get(sink); // $ Alert
            Request.Get(uri); // $ Alert
            Request.Head(sink); // $ Alert
            Request.Head(uri); // $ Alert
            Request.Options(sink); // $ Alert
            Request.Options(uri); // $ Alert
            Request.Patch(sink); // $ Alert
            Request.Patch(uri); // $ Alert
            Request.Post(sink); // $ Alert
            Request.Post(uri); // $ Alert
            Request.Put(sink); // $ Alert
            Request.Put(uri); // $ Alert
            Request.Trace(sink); // $ Alert
            Request.Trace(uri); // $ Alert

        } catch (Exception e) {
            // TODO: handle exception
        }
    }
}
