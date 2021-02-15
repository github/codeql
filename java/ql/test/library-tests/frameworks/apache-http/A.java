import org.apache.http.*;
import org.apache.http.protocol.*;
import org.apache.http.message.BasicHeader;
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
            res.setHeader("Location", req.getRequestLine().getUri());
            res.setHeader(new BasicHeader("Location", req.getRequestLine().getUri()));
        }
    }

    void test2() {
        ByteArrayBuffer bbuf = new ByteArrayBuffer(42);
        bbuf.append((byte[]) taint(), 0, 3);
        sink(bbuf.buffer());
        sink(bbuf.toByteArray());

        CharArrayBuffer cbuf = new CharArrayBuffer(42);
        cbuf.append(bbuf.toByteArray(), 0, 3);
        sink(cbuf.toCharArray());
        sink(cbuf.toString());
        sink(cbuf.subSequence(0, 3));
        sink(cbuf.substring(0, 3));
        sink(cbuf.substringTrimmed(0, 3));

        sink(Args.notNull(taint(), "x"));
        sink(Args.notEmpty((String) taint(), "x"));
        sink(Args.notBlank((String) taint(), "x"));
        sink(Args.notNull("x", (String) taint())); // Good
    }
}