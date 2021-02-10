import org.apache.http.*;
import org.apache.http.protocol.*;
import org.apache.http.util.*;
import org.apache.http.entity.*;

class A {
    static Object taint() { return null; }

    static void sink(Object o) { }

    class Test1 implements HttpRequestHandler {
        public void handle(HttpRequest req, HttpResponse res, HttpContext ctx) {
            A.sink(req.getRequestLine());
            A.sink(req.getRequestLine().getUri());
            A.sink(req.getRequestLine().getMethod());
            A.sink(req.getAllHeaders());
            HeaderIterator it = req.headerIterator();
            A.sink(it.next());
            A.sink(it.nextHeader());
            Header h = req.getHeaders("abc")[3];
            A.sink(h.getName());
            A.sink(h.getValue());
            HeaderElement el = h.getElements()[0];
            A.sink(el.getName());
            A.sink(el.getValue());
            A.sink(el.getParameters());
            A.sink(el.getParameterByName("abc").getValue());
            A.sink(el.getParameter(0).getName());
            HttpEntity ent = ((HttpEntityEnclosingRequest)req).getEntity();
            A.sink(ent.getContent());
            A.sink(ent.getContentEncoding());
            A.sink(ent.getContentType());
            A.sink(EntityUtils.toString(ent));
            A.sink(EntityUtils.toByteArray(ent));
            A.sink(EntityUtils.getContentCharSet(ent));
            A.sink(EntityUtils.getContentMimeType(ent));
            res.setEntity(new StringEntity("<a href='" + req.getRequestLine().getUri() + "'>a</a>"));
            EntityUtils.updateEntity(res, new ByteArrayEntity(EntityUtils.toByteArray(ent)));
        }
    }
}