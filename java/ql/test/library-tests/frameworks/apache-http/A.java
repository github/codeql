import org.apache.http.*;
import org.apache.http.protocol.*;
import org.apache.http.message.BasicHeader;
import org.apache.http.util.*;
import org.apache.http.entity.*;
import java.io.IOException;

class A {
    static Object taint() { return null; }

    static void sink(Object o) { }

    class Test1 implements HttpRequestHandler {
        public void handle(HttpRequest req, HttpResponse res, HttpContext ctx) throws IOException {
            A.sink(req.getRequestLine()); //$hasTaintFlow
            A.sink(req.getRequestLine().getUri()); //$hasTaintFlow
            A.sink(req.getRequestLine().getMethod()); //$hasTaintFlow
            A.sink(req.getAllHeaders()); //$hasTaintFlow
            HeaderIterator it = req.headerIterator();
            A.sink(it.next()); //$hasTaintFlow
            A.sink(it.nextHeader()); //$hasTaintFlow
            Header h = req.getHeaders("abc")[3];
            A.sink(h.getName()); //$hasTaintFlow
            A.sink(h.getValue()); //$hasTaintFlow
            HeaderElement el = h.getElements()[0];
            A.sink(el.getName()); //$hasTaintFlow
            A.sink(el.getValue()); //$hasTaintFlow
            A.sink(el.getParameters()); //$hasTaintFlow
            A.sink(el.getParameterByName("abc").getValue()); //$hasTaintFlow
            A.sink(el.getParameter(0).getName()); //$hasTaintFlow
            HttpEntity ent = ((HttpEntityEnclosingRequest)req).getEntity();
            A.sink(ent.getContent()); //$hasTaintFlow
            A.sink(ent.getContentEncoding()); //$hasTaintFlow
            A.sink(ent.getContentType()); //$hasTaintFlow
            A.sink(EntityUtils.toString(ent)); //$hasTaintFlow
            A.sink(EntityUtils.toByteArray(ent)); //$hasTaintFlow
            A.sink(EntityUtils.getContentCharSet(ent)); //$hasTaintFlow
            A.sink(EntityUtils.getContentMimeType(ent)); //$hasTaintFlow
            res.setEntity(new StringEntity("<a href='" + req.getRequestLine().getUri() + "'>a</a>")); //$hasTaintFlow
            EntityUtils.updateEntity(res, new ByteArrayEntity(EntityUtils.toByteArray(ent))); //$hasTaintFlow
            res.setHeader("Location", req.getRequestLine().getUri()); //$hasTaintFlow
            res.setHeader(new BasicHeader("Location", req.getRequestLine().getUri())); //$hasTaintFlow
        }
    }

    void test2() {
        ByteArrayBuffer bbuf = new ByteArrayBuffer(42);
        bbuf.append((byte[]) taint(), 0, 3);
        sink(bbuf.buffer()); //$hasTaintFlow
        sink(bbuf.toByteArray()); //$hasTaintFlow

        CharArrayBuffer cbuf = new CharArrayBuffer(42);
        cbuf.append(bbuf.toByteArray(), 0, 3);
        sink(cbuf.toCharArray()); //$hasTaintFlow
        sink(cbuf.toString()); //$hasTaintFlow
        sink(cbuf.subSequence(0, 3)); //$hasTaintFlow
        sink(cbuf.substring(0, 3)); //$hasTaintFlow
        sink(cbuf.substringTrimmed(0, 3)); //$hasTaintFlow

        sink(Args.notNull(taint(), "x")); //$hasTaintFlow
        sink(Args.notEmpty((String) taint(), "x")); //$hasTaintFlow
        sink(Args.notBlank((String) taint(), "x")); //$hasTaintFlow
        sink(Args.notNull("x", (String) taint())); // Good
    }
}