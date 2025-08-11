import java.io.IOException;
import java.net.URI;

import org.apache.http.client.methods.HttpGet;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.client.methods.HttpPut;
import org.apache.http.client.methods.HttpDelete;
import org.apache.http.client.methods.HttpHead;
import org.apache.http.client.methods.HttpOptions;
import org.apache.http.client.methods.HttpTrace;
import org.apache.http.client.methods.HttpPatch;
import org.apache.http.client.methods.RequestBuilder;
import org.apache.http.message.BasicHttpRequest;
import org.apache.http.message.BasicHttpEntityEnclosingRequest;
import org.apache.http.message.BasicRequestLine;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class ApacheHttpSSRF extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {

            String sink = request.getParameter("uri"); // $ Source
            URI uri = new URI(sink);

            HttpGet httpGet = new HttpGet(uri); // $ Alert
            HttpGet httpGet2 = new HttpGet();
            httpGet2.setURI(uri); // $ Alert

            new HttpHead(uri); // $ Alert
            new HttpPost(uri); // $ Alert
            new HttpPut(uri); // $ Alert
            new HttpDelete(uri); // $ Alert
            new HttpOptions(uri); // $ Alert
            new HttpTrace(uri); // $ Alert
            new HttpPatch(uri); // $ Alert

            new BasicHttpRequest(new BasicRequestLine("GET", uri.toString(), null)); // $ Alert
            new BasicHttpRequest("GET", uri.toString()); // $ Alert
            new BasicHttpRequest("GET", uri.toString(), null); // $ Alert

            new BasicHttpEntityEnclosingRequest(new BasicRequestLine("GET", uri.toString(), null)); // $ Alert
            new BasicHttpEntityEnclosingRequest("GET", uri.toString()); // $ Alert
            new BasicHttpEntityEnclosingRequest("GET", uri.toString(), null); // $ Alert

            RequestBuilder.get(uri); // $ Alert
            RequestBuilder.post(uri); // $ Alert
            RequestBuilder.put(uri); // $ Alert
            RequestBuilder.delete(uri); // $ Alert
            RequestBuilder.options(uri); // $ Alert
            RequestBuilder.head(uri); // $ Alert
            RequestBuilder.trace(uri); // $ Alert
            RequestBuilder.patch(uri); // $ Alert
            RequestBuilder.get("").setUri(uri); // $ Alert

        } catch (Exception e) {
            // TODO: handle exception
        }
    }
}
