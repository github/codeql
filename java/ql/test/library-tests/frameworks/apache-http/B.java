import org.apache.hc.core5.http.*;
import org.apache.hc.core5.http.protocol.HttpContext;
import org.apache.hc.core5.http.io.HttpRequestHandler;
import org.apache.hc.core5.http.io.HttpServerRequestHandler;
import org.apache.hc.core5.http.message.*;
import org.apache.hc.core5.http.io.entity.*;
import org.apache.hc.core5.util.*;
import java.io.IOException;

class B {
    static Object taint() { return null; }

    static void sink(Object o) { }

    class Test1 implements HttpRequestHandler {
        public void handle(ClassicHttpRequest req, ClassicHttpResponse res, HttpContext ctx) throws IOException, ParseException {
            B.sink(req.getAuthority().getHostName()); //$hasTaintFlow=y
            B.sink(req.getAuthority().toString()); //$hasTaintFlow=y
            B.sink(req.getMethod()); //$hasTaintFlow=y
            B.sink(req.getPath()); //$hasTaintFlow=y
            B.sink(req.getScheme()); 
            B.sink(req.getRequestUri()); //$hasTaintFlow=y
            RequestLine line = new RequestLine(req);
            B.sink(line.getUri()); //$hasTaintFlow=y
            B.sink(line.getMethod()); //$hasTaintFlow=y
            B.sink(req.getHeaders()); //$hasTaintFlow=y
            B.sink(req.headerIterator()); //$hasTaintFlow=y
            Header h = req.getHeaders("abc")[3];
            B.sink(h.getName()); //$hasTaintFlow=y
            B.sink(h.getValue()); //$hasTaintFlow=y
            B.sink(req.getFirstHeader("abc")); //$hasTaintFlow=y
            B.sink(req.getLastHeader("abc")); //$hasTaintFlow=y
            HttpEntity ent = req.getEntity();
            B.sink(ent.getContent()); //$hasTaintFlow=y
            B.sink(ent.getContentEncoding()); //$hasTaintFlow=y
            B.sink(ent.getContentType()); //$hasTaintFlow=y
            B.sink(ent.getTrailerNames()); //$hasTaintFlow=y
            B.sink(ent.getTrailers().get()); //$hasTaintFlow=y
            B.sink(EntityUtils.toString(ent)); //$hasTaintFlow=y
            B.sink(EntityUtils.toByteArray(ent)); //$hasTaintFlow=y
            B.sink(EntityUtils.parse(ent)); //$hasTaintFlow=y
            res.setEntity(new StringEntity("<a href='" + req.getRequestUri() + "'>a</a>")); //$hasTaintFlow=y
            res.setEntity(new ByteArrayEntity(EntityUtils.toByteArray(ent), ContentType.TEXT_HTML)); //$hasTaintFlow=y
            res.setEntity(HttpEntities.create("<a href='" + req.getRequestUri() + "'>a</a>")); //$hasTaintFlow=y
            res.setHeader("Location", req.getRequestUri()); //$hasTaintFlow=y
            res.setHeader(new BasicHeader("Location", req.getRequestUri())); //$hasTaintFlow=y
        }
    }

    void test2() {
        ByteArrayBuffer bbuf = new ByteArrayBuffer(42);
        bbuf.append((byte[]) taint(), 0, 3); 
        sink(bbuf.array()); //$hasTaintFlow=y
        sink(bbuf.toByteArray()); //$hasTaintFlow=y
        sink(bbuf.toString()); 

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
        sink(Args.notNull("x", (String) taint())); 
    }

    class Test3 implements HttpServerRequestHandler {
        public void handle(ClassicHttpRequest req, HttpServerRequestHandler.ResponseTrigger restr, HttpContext ctx) throws HttpException, IOException {
            B.sink(req.getEntity()); //$hasTaintFlow=y
        }
    }
}