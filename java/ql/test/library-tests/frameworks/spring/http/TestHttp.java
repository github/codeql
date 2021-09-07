import org.springframework.http.HttpEntity;
import org.springframework.http.ResponseEntity;
import org.springframework.http.RequestEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.util.MultiValueMap;
import org.springframework.util.LinkedMultiValueMap;
import java.util.Optional;
import java.util.List;

class TestHttp {
    static <T> T taint() { return null; }
    static void sink(Object o) {}

    void test1() {
        String x = taint();
        sink(new HttpEntity(x)); // $hasTaintFlow

        MultiValueMap<String,String> m1 = new LinkedMultiValueMap();
        sink(new HttpEntity(x, m1)); // $hasTaintFlow

        m1.add("a", taint());
        sink(new HttpEntity("a", m1)); // $hasTaintFlow
        sink(new HttpEntity<String>(m1)); // $hasTaintFlow

        MultiValueMap<String,String> m2 = new LinkedMultiValueMap();
        m2.add(taint(), "a");
        sink(new HttpEntity<String>(m2)); // $hasTaintFlow

        HttpEntity<String> ent = taint();
        sink(ent.getBody()); // $hasTaintFlow
        sink(ent.getHeaders()); // $hasTaintFlow

        RequestEntity<String> req = taint();
        sink(req.getUrl()); // $hasTaintFlow
    }

    void test2() {
        String x = taint();
        sink(ResponseEntity.ok(x)); // $hasTaintFlow
        sink(ResponseEntity.of(Optional.of(x))); // $hasTaintFlow

        sink(ResponseEntity.status(200).contentLength(2048).body(x)); // $hasTaintFlow
        sink(ResponseEntity.created(taint()).contentType(null).body("a")); // $hasTaintFlow
        sink(ResponseEntity.status(200).header(x, "a", "b", "c").build()); // $hasTaintFlow
        sink(ResponseEntity.status(200).header("h", "a", "b", x).build()); // $hasTaintFlow
        HttpHeaders h = new HttpHeaders();
        h.add("h", taint());
        sink(ResponseEntity.status(200).headers(h).allow().build()); // $hasTaintFlow
        sink(ResponseEntity.status(200).eTag(x).allow().build()); // $hasTaintFlow
        sink(ResponseEntity.status(200).location(taint()).lastModified(10000000).build()); // $hasTaintFlow
        sink(ResponseEntity.status(200).varyBy(x).build()); 
    }

    void test3() {
        String x = taint();

        MultiValueMap<String,String> m1 = new LinkedMultiValueMap();
        sink(new ResponseEntity(x, HttpStatus.ACCEPTED)); // $hasTaintFlow
        sink(new ResponseEntity(x, m1, HttpStatus.ACCEPTED)); // $hasTaintFlow
        sink(new ResponseEntity(x, m1, 200)); // $hasTaintFlow

        m1.add("a", taint());
        sink(new ResponseEntity("a", m1, HttpStatus.ACCEPTED)); // $hasTaintFlow
        sink(new ResponseEntity<String>(m1, HttpStatus.ACCEPTED)); // $hasTaintFlow
        sink(new ResponseEntity("a", m1, 200)); // $hasTaintFlow

        MultiValueMap<String,String> m2 = new LinkedMultiValueMap();
        m2.add(taint(), "a");
        sink(new ResponseEntity("a", m2, HttpStatus.ACCEPTED)); // $hasTaintFlow
        sink(new ResponseEntity<String>(m2, HttpStatus.ACCEPTED)); // $hasTaintFlow
        sink(new ResponseEntity("a", m2, 200)); // $hasTaintFlow

        ResponseEntity<String> ent = taint();
        sink(ent.getBody()); // $hasTaintFlow
        sink(ent.getHeaders()); // $hasTaintFlow
    }

    void test4() {
        MultiValueMap<String,String> m1 = new LinkedMultiValueMap();
        m1.add("a", taint());
        sink(new HttpHeaders(m1)); // $hasTaintFlow

        MultiValueMap<String,String> m2 = new LinkedMultiValueMap();
        m2.add(taint(), "a");
        sink(new HttpHeaders(m2)); // $hasTaintFlow

        HttpHeaders h1 = new HttpHeaders();
        h1.add(taint(), "a"); 
        sink(h1); // $hasTaintFlow

        HttpHeaders h2 = new HttpHeaders();
        h2.add("a", taint()); 
        sink(h2); // $hasTaintFlow

        HttpHeaders h3 = new HttpHeaders();
        h3.addAll(m1); 
        sink(h3); // $hasTaintFlow

        HttpHeaders h4 = new HttpHeaders();
        h4.addAll(m2); 
        sink(h4); // $hasTaintFlow

        HttpHeaders h5 = new HttpHeaders();
        h5.addAll(taint(), List.of()); 
        sink(h5); // $hasTaintFlow

        HttpHeaders h6 = new HttpHeaders();
        h6.addAll("a", List.of(taint())); 
        sink(h6); // $hasTaintFlow

        sink(HttpHeaders.formatHeaders(m1)); // $hasTaintFlow
        sink(HttpHeaders.formatHeaders(m2)); // $hasTaintFlow

        sink(HttpHeaders.encodeBasicAuth(taint(), "a", null)); // $hasTaintFlow
        sink(HttpHeaders.encodeBasicAuth("a", taint(), null)); // $hasTaintFlow
    }

    void test5() {
        HttpHeaders h = taint();
        
        sink(h.get(null).get(0)); // $hasTaintFlow
        sink(h.getAccept().get(0));
        sink(h.getAcceptCharset().get(0));
        sink(h.getAcceptLanguage().get(0));
        sink(h.getAcceptLanguageAsLocales().get(0));
        sink(h.getAccessControlAllowCredentials());
        sink(h.getAccessControlAllowHeaders().get(0)); // $hasTaintFlow
        sink(h.getAccessControlAllowMethods().get(0));
        sink(h.getAccessControlAllowOrigin()); // $hasTaintFlow
        sink(h.getAccessControlExposeHeaders().get(0)); // $hasTaintFlow
        sink(h.getAccessControlMaxAge());
        sink(h.getAccessControlRequestHeaders().get(0)); // $hasTaintFlow
        sink(h.getAccessControlRequestMethod()); 
        sink(h.getAllow().toArray()[0]);
        sink(h.getCacheControl()); // $hasTaintFlow
        sink(h.getConnection().get(0)); // $hasTaintFlow
        sink(h.getContentDisposition());
        sink(h.getContentLanguage());
        sink(h.getContentLength());
        sink(h.getContentType());
        sink(h.getDate());
        sink(h.getETag()); // $hasTaintFlow
        sink(h.getExpires());
        sink(h.getFirst("a")); // $hasTaintFlow
        sink(h.getFirstDate("a")); 
        sink(h.getFirstZonedDateTime("a")); 
        sink(h.getHost()); // $hasTaintFlow
        sink(h.getIfMatch().get(0)); // $hasTaintFlow
        sink(h.getIfModifiedSince()); 
        sink(h.getIfNoneMatch().get(0)); // $hasTaintFlow
        sink(h.getIfUnmodifiedSince()); 
        sink(h.getLastModified()); 
        sink(h.getLocation()); // $hasTaintFlow
        sink(h.getOrEmpty("a").get(0)); // $hasTaintFlow
        sink(h.getOrigin()); // $hasTaintFlow
        sink(h.getPragma()); // $hasTaintFlow
        sink(h.getUpgrade()); // $hasTaintFlow
        sink(h.getValuesAsList("a").get(0)); // $hasTaintFlow
        sink(h.getVary().get(0)); // $hasTaintFlow
    }
}