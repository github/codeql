import org.springframework.http.HttpEntity;
import org.springframework.http.ResponseEntity;
import org.springframework.http.RequestEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.util.MultiValueMap;
import org.springframework.util.LinkedMultiValueMap;
import java.util.Optional;

class TestHttp {
    static <T> T taint() { return null; }
    static void sink(Object o) {}

    void test1() {
        String x = taint();
        sink(new HttpEntity(x)); // $hasTaintFlow

        MultiValueMap<String,String> m = new LinkedMultiValueMap();
        sink(new HttpEntity(x, m)); // $hasTaintFlow

        m.add("a", taint());
        sink(new HttpEntity("a", m)); // $ MISSING:hasTaintFlow
        sink(new HttpEntity<String>(m)); // $ MISSING:hasTaintFlow

        HttpEntity<String> ent = taint();
        sink(ent.getBody()); // $hasTaintFlow
        sink(ent.getHeaders()); // $hasTaintFlow

        RequestEntity<String> req = taint();
        sink(req.getUrl()); // $hasTaintFlow
    }

    void test2() {
        String x = taint();
        sink(ResponseEntity.ok(x)); // $hasTaintFlow
        sink(ResponseEntity.of(Optional.of(x))); // $ MISSING:hasTaintFlow

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
}