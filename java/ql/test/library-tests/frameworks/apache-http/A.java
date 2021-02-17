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
            A.sink(req.getRequestLine()); //$hasTaintFlow=y
            A.sink(req.getRequestLine().getUri()); //$hasTaintFlow=y
            A.sink(req.getRequestLine().getMethod()); //$hasTaintFlow=y
            A.sink(req.getAllHeaders()); //$hasTaintFlow=y
            HeaderIterator it = req.headerIterator();
            A.sink(it.next()); //$hasTaintFlow=y
            A.sink(it.nextHeader()); //$hasTaintFlow=y
            Header h = req.getHeaders("abc")[3];
            A.sink(h.getName()); //$hasTaintFlow=y
            A.sink(h.getValue()); //$hasTaintFlow=y
            HeaderElement el = h.getElements()[0];
            A.sink(el.getName()); //$hasTaintFlow=y
            A.sink(el.getValue()); //$hasTaintFlow=y
            A.sink(el.getParameters()); //$hasTaintFlow=y
            A.sink(el.getParameterByName("abc").getValue()); //$hasTaintFlow=y
            A.sink(el.getParameter(0).getName()); //$hasTaintFlow=y
            HttpEntity ent = ((HttpEntityEnclosingRequest)req).getEntity();
            A.sink(ent.getContent()); //$hasTaintFlow=y
            A.sink(ent.getContentEncoding()); //$hasTaintFlow=y
            A.sink(ent.getContentType()); //$hasTaintFlow=y
            A.sink(EntityUtils.toString(ent)); //$hasTaintFlow=y
            A.sink(EntityUtils.toByteArray(ent)); //$hasTaintFlow=y
            A.sink(EntityUtils.getContentCharSet(ent)); //$hasTaintFlow=y
            A.sink(EntityUtils.getContentMimeType(ent)); //$hasTaintFlow=y
            res.setEntity(new StringEntity("<a href='" + req.getRequestLine().getUri() + "'>a</a>")); //$hasTaintFlow=y
            EntityUtils.updateEntity(res, new ByteArrayEntity(EntityUtils.toByteArray(ent))); //$hasTaintFlow=y
            res.setHeader("Location", req.getRequestLine().getUri()); //$hasTaintFlow=y
            res.setHeader(new BasicHeader("Location", req.getRequestLine().getUri())); //$hasTaintFlow=y
        }
    }

    void test2() {
        ByteArrayBuffer bbuf = new ByteArrayBuffer(42);
        bbuf.append((byte[]) taint(), 0, 3);
        sink(bbuf.buffer()); //$hasTaintFlow=y
        sink(bbuf.toByteArray()); //$hasTaintFlow=y

        CharArrayBuffer cbuf = new CharArrayBuffer(42);
        cbuf.append(bbuf.toByteArray(), 0, 3);
        sink(cbuf.toCharArray()); //$hasTaintFlow=y
        sink(cbuf.toString()); //$hasTaintFlow=y
        sink(cbuf.subSequence(0, 3)); //$hasTaintFlow=y
        sink(cbuf.substring(0, 3)); //$hasTaintFlow=y
        sink(cbuf.substringTrimmed(0, 3)); //$hasTaintFlow=y

        sink(Args.notNull(taint(), "x")); //$hasTaintFlow=y
        sink(Args.notEmpty((String) taint(), "x")); //$hasTaintFlow=y
        sink(Args.notBlank((String) taint(), "x")); //$hasTaintFlow=y
        sink(Args.notNull("x", (String) taint())); // Good
    }
}