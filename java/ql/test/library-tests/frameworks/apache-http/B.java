import org.apache.hc.core5.http.*;
import org.apache.hc.core5.http.protocol.HttpContext;
import org.apache.hc.core5.http.io.HttpRequestHandler;
import org.apache.hc.core5.http.message.*;
import org.apache.hc.core5.http.io.entity.*;
import org.apache.hc.core5.util.*;
import java.io.IOException;

class B {
    static Object taint() { return null; }

    static void sink(Object o) { }

    class Test1 implements HttpRequestHandler {
        public void handle(ClassicHttpRequest req, ClassicHttpResponse res, HttpContext ctx) throws IOException, ParseException {
            B.sink(req.getAuthority().getHostName());
            B.sink(req.getAuthority().toString());
            B.sink(req.getMethod());
            B.sink(req.getPath());
            B.sink(req.getScheme());
            B.sink(req.getRequestUri());
            RequestLine line = new RequestLine(req);
            B.sink(line.getUri());
            B.sink(line.getMethod());
            B.sink(req.getHeaders());
            B.sink(req.headerIterator());
            Header h = req.getHeaders("abc")[3];
            B.sink(h.getName());
            B.sink(h.getValue());
            B.sink(req.getFirstHeader("abc"));
            B.sink(req.getLastHeader("abc"));
            HttpEntity ent = req.getEntity();
            B.sink(ent.getContent());
            B.sink(ent.getContentEncoding());
            B.sink(ent.getContentType());
            B.sink(ent.getTrailerNames());
            B.sink(ent.getTrailers().get());
            B.sink(EntityUtils.toString(ent));
            B.sink(EntityUtils.toByteArray(ent));
            B.sink(EntityUtils.parse(ent));
            res.setEntity(new StringEntity("<a href='" + req.getRequestUri() + "'>a</a>"));
            res.setEntity(new ByteArrayEntity(EntityUtils.toByteArray(ent), ContentType.TEXT_HTML));
            res.setEntity(HttpEntities.create("<a href='" + req.getRequestUri() + "'>a</a>"));
            res.setHeader("Location", req.getRequestUri());
            res.setHeader(new BasicHeader("Location", req.getRequestUri()));
        }
    }

    void test2() {
        ByteArrayBuffer bbuf = new ByteArrayBuffer(42);
        bbuf.append((byte[]) taint(), 0, 3);
        sink(bbuf.array());
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