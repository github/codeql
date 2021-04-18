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
            B.sink(req.getAuthority().getHostName()); //$hasTaintFlow
            B.sink(req.getAuthority().toString()); //$hasTaintFlow
            B.sink(req.getMethod()); //$hasTaintFlow
            B.sink(req.getPath()); //$hasTaintFlow
            B.sink(req.getScheme()); 
            B.sink(req.getRequestUri()); //$hasTaintFlow
            RequestLine line = new RequestLine(req);
            B.sink(line.getUri()); //$hasTaintFlow
            B.sink(line.getMethod()); //$hasTaintFlow
            B.sink(req.getHeaders()); //$hasTaintFlow
            B.sink(req.headerIterator()); //$hasTaintFlow
            Header h = req.getHeaders("abc")[3];
            B.sink(h.getName()); //$hasTaintFlow
            B.sink(h.getValue()); //$hasTaintFlow
            B.sink(req.getFirstHeader("abc")); //$hasTaintFlow
            B.sink(req.getLastHeader("abc")); //$hasTaintFlow
            HttpEntity ent = req.getEntity();
            B.sink(ent.getContent()); //$hasTaintFlow
            B.sink(ent.getContentEncoding()); //$hasTaintFlow
            B.sink(ent.getContentType()); //$hasTaintFlow
            B.sink(ent.getTrailerNames()); //$hasTaintFlow
            B.sink(ent.getTrailers().get()); //$hasTaintFlow
            B.sink(EntityUtils.toString(ent)); //$hasTaintFlow
            B.sink(EntityUtils.toByteArray(ent)); //$hasTaintFlow
            B.sink(EntityUtils.parse(ent)); //$hasTaintFlow
            res.setEntity(new StringEntity("<a href='" + req.getRequestUri() + "'>a</a>")); //$hasTaintFlow
            res.setEntity(new ByteArrayEntity(EntityUtils.toByteArray(ent), ContentType.TEXT_HTML)); //$hasTaintFlow
            res.setEntity(HttpEntities.create("<a href='" + req.getRequestUri() + "'>a</a>")); //$hasTaintFlow
            res.setHeader("Location", req.getRequestUri()); //$hasTaintFlow
            res.setHeader(new BasicHeader("Location", req.getRequestUri())); //$hasTaintFlow
        }
    }

    void test2() {
        ByteArrayBuffer bbuf = new ByteArrayBuffer(42);
        bbuf.append((byte[]) taint(), 0, 3); 
        sink(bbuf.array()); //$hasTaintFlow
        sink(bbuf.toByteArray()); //$hasTaintFlow
        sink(bbuf.toString()); 

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
        sink(Args.notNull("x", (String) taint())); 
    }

    class Test3 implements HttpServerRequestHandler {
        public void handle(ClassicHttpRequest req, HttpServerRequestHandler.ResponseTrigger restr, HttpContext ctx) throws HttpException, IOException {
            B.sink(req.getEntity()); //$hasTaintFlow
        }
    }
}