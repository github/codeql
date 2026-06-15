import org.springframework.util.MultiValueMap;
import org.springframework.web.client.RestTemplate;
import org.springframework.http.RequestEntity;
import org.springframework.http.ResponseEntity;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpStatus;
import java.net.URI;
import org.springframework.http.HttpMethod;
import java.io.IOException;
import java.net.URI;
import java.net.*;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.Proxy.Type;
import java.io.InputStream;
import java.util.Map;

import org.apache.http.client.methods.HttpGet;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class SpringSSRF extends HttpServlet {

    protected void doGet(HttpServletRequest request2, HttpServletResponse response2)
            throws ServletException, IOException {
        String fooResourceUrl = request2.getParameter("uri"); // $ Source
        RestTemplate restTemplate = new RestTemplate();
        HttpEntity<String> request = new HttpEntity<>(new String("bar"));
        try {
            restTemplate.getForEntity(fooResourceUrl + "/1", String.class); // $ Alert
            restTemplate.getForEntity("http://{foo}", String.class, fooResourceUrl); // $ Alert
            restTemplate.getForEntity("http://{foo}/a/b", String.class, fooResourceUrl); // $ Alert
            restTemplate.getForEntity("{protocol}://{foo}/a/b", String.class, "http", fooResourceUrl); // $ Alert
            restTemplate.getForEntity("http://safe.com/{foo}", String.class, fooResourceUrl); // not bad - the tainted value does not affect the host
            restTemplate.getForEntity("http://{foo}", String.class, "safe.com", fooResourceUrl); // not bad - the tainted value is unused
            restTemplate.getForEntity("http://{foo}", String.class, Map.of("foo", fooResourceUrl)); // $ Alert
            restTemplate.getForEntity("http://safe.com/{foo}", String.class, Map.of("foo", fooResourceUrl)); // not bad - the tainted value does not affect the host
            restTemplate.getForEntity("http://{foo}", String.class, Map.of("foo", "safe.com", "unused", fooResourceUrl)); // $ SPURIOUS: Alert // not bad - the key for the tainted value is unused
            restTemplate.getForEntity("http://{foo}", String.class, Map.of("foo", "safe.com", fooResourceUrl, "unused")); // not bad - the tainted value is in a map key

            restTemplate.exchange(fooResourceUrl, HttpMethod.POST, request, String.class); // $ Alert
            restTemplate.exchange("http://{foo}", HttpMethod.POST, request, String.class, fooResourceUrl); // $ Alert
            restTemplate.exchange("http://{foo}/a/b", HttpMethod.POST, request, String.class, fooResourceUrl); // $ Alert
            restTemplate.exchange("{protocol}://{foo}/a/b", HttpMethod.POST, request, String.class, "http", fooResourceUrl); // $ Alert
            restTemplate.exchange("http://safe.com/{foo}", HttpMethod.POST, request, String.class, fooResourceUrl); // not bad - the tainted value does not affect the host
            restTemplate.exchange("http://{foo}", HttpMethod.POST, request, String.class, "safe.com", fooResourceUrl); // not bad - the tainted value is unused
            restTemplate.exchange("http://{foo}", HttpMethod.POST, request, String.class, Map.of("foo", fooResourceUrl)); // $ Alert
            restTemplate.exchange("http://safe.com/{foo}", HttpMethod.POST, request, String.class, Map.of("foo", fooResourceUrl)); // not bad - the tainted value does not affect the host
            restTemplate.exchange("http://{foo}", HttpMethod.POST, request, String.class, Map.of("foo", "safe.com", "unused", fooResourceUrl)); // $ SPURIOUS: Alert // not bad - the key for the tainted value is unused
            restTemplate.exchange("http://{foo}", HttpMethod.POST, request, String.class, Map.of("foo", "safe.com", fooResourceUrl, "unused")); // not bad - the tainted value is in a map key

            restTemplate.execute(fooResourceUrl, HttpMethod.POST, null, null, "test"); // $ Alert
            restTemplate.execute("http://{foo}", HttpMethod.POST, null, null, fooResourceUrl); // $ Alert
            restTemplate.execute("http://{foo}/a/b", HttpMethod.POST, null, null, fooResourceUrl); // $ Alert
            restTemplate.execute("{protocol}://{foo}/a/b", HttpMethod.POST, null, null, "http", fooResourceUrl); // $ Alert
            restTemplate.execute("http://safe.com/{foo}", HttpMethod.POST, null, null, fooResourceUrl); // not bad - the tainted value does not affect the host
            restTemplate.execute("http://{foo}", HttpMethod.POST, null, null, "safe.com", fooResourceUrl); // not bad - the tainted value is unused
            restTemplate.execute("http://{foo}", HttpMethod.POST, null, null, Map.of("foo", fooResourceUrl)); // $ Alert
            restTemplate.execute("http://safe.com/{foo}", HttpMethod.POST, null, null, Map.of("foo", fooResourceUrl)); // not bad - the tainted value does not affect the host
            restTemplate.execute("http://{foo}", HttpMethod.POST, null, null, Map.of("foo", "safe.com", "unused", fooResourceUrl)); // $ SPURIOUS: Alert // not bad - the key for the tainted value is unused
            restTemplate.execute("http://{foo}", HttpMethod.POST, null, null, Map.of("foo", "safe.com", fooResourceUrl, "unused")); // not bad - the tainted value is in a map key

            restTemplate.getForObject(fooResourceUrl, String.class, "test"); // $ Alert
            restTemplate.getForObject("http://{foo}", String.class, fooResourceUrl); // $ Alert
            restTemplate.getForObject("http://{foo}/a/b", String.class, fooResourceUrl); // $ Alert
            restTemplate.getForObject("{protocol}://{foo}/a/b", String.class, "http", fooResourceUrl); // $ Alert
            restTemplate.getForObject("http://safe.com/{foo}", String.class, fooResourceUrl); // not bad - the tainted value does not affect the host
            restTemplate.getForObject("http://{foo}", String.class, "safe.com", fooResourceUrl); // not bad - the tainted value is unused
            restTemplate.getForObject("http://{foo}", String.class, Map.of("foo", fooResourceUrl)); // $ Alert
            restTemplate.getForObject("http://safe.com/{foo}", String.class, Map.of("foo", fooResourceUrl)); // not bad - the tainted value does not affect the host
            restTemplate.getForObject("http://{foo}", String.class, Map.of("foo", "safe.com", "unused", fooResourceUrl)); // $ SPURIOUS: Alert // not bad - the key for the tainted value is unused
            restTemplate.getForObject("http://{foo}", String.class, Map.of("foo", "safe.com", fooResourceUrl, "unused")); // not bad - the tainted value is in a map key

            restTemplate.patchForObject(fooResourceUrl, new String("object"), String.class, "hi"); // $ Alert
            restTemplate.patchForObject("http://{foo}", new String("object"), String.class, fooResourceUrl); // $ Alert
            restTemplate.patchForObject("http://{foo}/a/b", new String("object"), String.class, fooResourceUrl); // $ Alert
            restTemplate.patchForObject("{protocol}://{foo}/a/b", new String("object"), String.class, "http", fooResourceUrl); // $ Alert
            restTemplate.patchForObject("http://safe.com/{foo}", new String("object"), String.class, fooResourceUrl); // not bad - the tainted value does not affect the host
            restTemplate.patchForObject("http://{foo}", new String("object"), String.class, "safe.com", fooResourceUrl); // not bad - the tainted value is unused
            restTemplate.patchForObject("http://{foo}", new String("object"), String.class, Map.of("foo", fooResourceUrl)); // $ Alert
            restTemplate.patchForObject("http://safe.com/{foo}", new String("object"), String.class, Map.of("foo", fooResourceUrl)); // not bad - the tainted value does not affect the host
            restTemplate.patchForObject("http://{foo}", new String("object"), String.class, Map.of("foo", "safe.com", "unused", fooResourceUrl)); // $ SPURIOUS: Alert // not bad - the key for the tainted value is unused
            restTemplate.patchForObject("http://{foo}", new String("object"), String.class, Map.of("foo", "safe.com", fooResourceUrl, "unused")); // not bad - the tainted value is in a map key

            restTemplate.postForEntity(new URI(fooResourceUrl), new String("object"), String.class); // $ Alert
            restTemplate.postForEntity("http://{foo}", new String("object"), String.class, fooResourceUrl); // $ Alert
            restTemplate.postForEntity("http://{foo}/a/b", new String("object"), String.class, fooResourceUrl); // $ Alert
            restTemplate.postForEntity("{protocol}://{foo}/a/b", new String("object"), String.class, "http", fooResourceUrl); // $ Alert
            restTemplate.postForEntity("http://safe.com/{foo}", new String("object"), String.class, fooResourceUrl); // not bad - the tainted value does not affect the host
            restTemplate.postForEntity("http://{foo}", new String("object"), String.class, "safe.com", fooResourceUrl); // not bad - the tainted value is unused
            restTemplate.postForEntity("http://{foo}", new String("object"), String.class, Map.of("foo", fooResourceUrl)); // $ Alert
            restTemplate.postForEntity("http://safe.com/{foo}", new String("object"), String.class, Map.of("foo", fooResourceUrl)); // not bad - the tainted value does not affect the host
            restTemplate.postForEntity("http://{foo}", new String("object"), String.class, Map.of("foo", "safe.com", "unused", fooResourceUrl)); // $ SPURIOUS: Alert // not bad - the key for the tainted value is unused
            restTemplate.postForEntity("http://{foo}", new String("object"), String.class, Map.of("foo", "safe.com", fooResourceUrl, "unused")); // not bad - the tainted value is in a map key

            restTemplate.postForLocation(fooResourceUrl, new String("object")); // $ Alert
            restTemplate.postForLocation("http://{foo}", new String("object"), fooResourceUrl); // $ Alert
            restTemplate.postForLocation("http://{foo}/a/b", new String("object"), fooResourceUrl); // $ Alert
            restTemplate.postForLocation("{protocol}://{foo}/a/b", new String("object"), "http", fooResourceUrl); // $ Alert
            restTemplate.postForLocation("http://safe.com/{foo}", new String("object"), fooResourceUrl); // not bad - the tainted value does not affect the host
            restTemplate.postForLocation("http://{foo}", new String("object"), "safe.com", fooResourceUrl); // not bad - the tainted value is unused
            restTemplate.postForLocation("http://{foo}", new String("object"), Map.of("foo", fooResourceUrl)); // $ Alert
            restTemplate.postForLocation("http://safe.com/{foo}", new String("object"), Map.of("foo", fooResourceUrl)); // not bad - the tainted value does not affect the host
            restTemplate.postForLocation("http://{foo}", new String("object"), Map.of("foo", "safe.com", "unused", fooResourceUrl)); // $ SPURIOUS: Alert // not bad - the key for the tainted value is unused
            restTemplate.postForLocation("http://{foo}", new String("object"), Map.of("foo", "safe.com", fooResourceUrl, "unused")); // not bad - the tainted value is in a map key

            restTemplate.postForObject(fooResourceUrl, new String("object"), String.class); // $ Alert
            restTemplate.postForObject("http://{foo}", new String("object"), String.class, fooResourceUrl); // $ Alert
            restTemplate.postForObject("http://{foo}/a/b", new String("object"), String.class, fooResourceUrl); // $ Alert
            restTemplate.postForObject("{protocol}://{foo}/a/b", new String("object"), String.class, "http", fooResourceUrl); // $ Alert
            restTemplate.postForObject("http://safe.com/{foo}", new String("object"), String.class, fooResourceUrl); // not bad - the tainted value does not affect the host
            restTemplate.postForObject("http://{foo}", new String("object"), String.class, "safe.com", fooResourceUrl); // not bad - the tainted value is unused
            restTemplate.postForObject("http://{foo}", new String("object"), String.class, Map.of("foo", fooResourceUrl)); // $ Alert
            restTemplate.postForObject("http://safe.com/{foo}", new String("object"), String.class, Map.of("foo", fooResourceUrl)); // not bad - the tainted value does not affect the host
            restTemplate.postForObject("http://{foo}", new String("object"), String.class, Map.of("foo", "safe.com", "unused", fooResourceUrl)); // $ SPURIOUS: Alert // not bad - the key for the tainted value is unused
            restTemplate.postForObject("http://{foo}", new String("object"), String.class, Map.of("foo", "safe.com", fooResourceUrl, "unused")); // not bad - the tainted value is in a map key

            restTemplate.put(fooResourceUrl, new String("object")); // $ Alert
            restTemplate.put("http://{foo}", new String("object"), fooResourceUrl); // $ Alert
            restTemplate.put("http://{foo}/a/b", new String("object"), fooResourceUrl); // $ Alert
            restTemplate.put("{protocol}://{foo}/a/b", new String("object"), "http", fooResourceUrl); // $ Alert
            restTemplate.put("http://safe.com/{foo}", new String("object"), fooResourceUrl); // not bad - the tainted value does not affect the host
            restTemplate.put("http://{foo}", new String("object"), "safe.com", fooResourceUrl); // not bad - the tainted value is unused
            restTemplate.put("http://{foo}", new String("object"), Map.of("foo", fooResourceUrl)); // $ Alert
            restTemplate.put("http://safe.com/{foo}", new String("object"), Map.of("foo", fooResourceUrl)); // not bad - the tainted value does not affect the host
            restTemplate.put("http://{foo}", new String("object"), Map.of("foo", "safe.com", "unused", fooResourceUrl)); // $ SPURIOUS: Alert // not bad - the key for the tainted value is unused
            restTemplate.put("http://{foo}", new String("object"), Map.of("foo", "safe.com", fooResourceUrl, "unused")); // not bad - the tainted value is in a map key

            restTemplate.delete(fooResourceUrl); // $ Alert
            restTemplate.delete("http://{foo}", fooResourceUrl); // $ Alert
            restTemplate.delete("http://{foo}/a/b", fooResourceUrl); // $ Alert
            restTemplate.delete("{protocol}://{foo}/a/b", "http", fooResourceUrl); // $ Alert
            restTemplate.delete("http://safe.com/{foo}", fooResourceUrl); // not bad - the tainted value does not affect the host
            restTemplate.delete("http://{foo}", "safe.com", fooResourceUrl); // not bad - the tainted value is unused
            restTemplate.delete("http://{foo}", Map.of("foo", fooResourceUrl)); // $ Alert
            restTemplate.delete("http://safe.com/{foo}", Map.of("foo", fooResourceUrl)); // not bad - the tainted value does not affect the host
            restTemplate.delete("http://{foo}", Map.of("foo", "safe.com", "unused", fooResourceUrl)); // $ SPURIOUS: Alert // not bad - the key for the tainted value is unused
            restTemplate.delete("http://{foo}", Map.of("foo", "safe.com", fooResourceUrl, "unused")); // not bad - the tainted value is in a map key

            restTemplate.headForHeaders(fooResourceUrl); // $ Alert
            restTemplate.headForHeaders("http://{foo}", fooResourceUrl); // $ Alert
            restTemplate.headForHeaders("http://{foo}/a/b", fooResourceUrl); // $ Alert
            restTemplate.headForHeaders("{protocol}://{foo}/a/b", "http", fooResourceUrl); // $ Alert
            restTemplate.headForHeaders("http://safe.com/{foo}", fooResourceUrl); // not bad - the tainted value does not affect the host
            restTemplate.headForHeaders("http://{foo}", "safe.com", fooResourceUrl); // not bad - the tainted value is unused
            restTemplate.headForHeaders("http://{foo}", Map.of("foo", fooResourceUrl)); // $ Alert
            restTemplate.headForHeaders("http://safe.com/{foo}", Map.of("foo", fooResourceUrl)); // not bad - the tainted value does not affect the host
            restTemplate.headForHeaders("http://{foo}", Map.of("foo", "safe.com", "unused", fooResourceUrl)); // $ SPURIOUS: Alert // not bad - the key for the tainted value is unused
            restTemplate.headForHeaders("http://{foo}", Map.of("foo", "safe.com", fooResourceUrl, "unused")); // not bad - the tainted value is in a map key

            restTemplate.optionsForAllow(fooResourceUrl); // $ Alert
            restTemplate.optionsForAllow("http://{foo}", fooResourceUrl); // $ Alert
            restTemplate.optionsForAllow("http://{foo}/a/b", fooResourceUrl); // $ Alert
            restTemplate.optionsForAllow("{protocol}://{foo}/a/b", "http", fooResourceUrl); // $ Alert
            restTemplate.optionsForAllow("http://safe.com/{foo}", fooResourceUrl); // not bad - the tainted value does not affect the host
            restTemplate.optionsForAllow("http://{foo}", "safe.com", fooResourceUrl); // not bad - the tainted value is unused
            restTemplate.optionsForAllow("http://{foo}", Map.of("foo", fooResourceUrl)); // $ Alert
            restTemplate.optionsForAllow("http://safe.com/{foo}", Map.of("foo", fooResourceUrl)); // not bad - the tainted value does not affect the host
            restTemplate.optionsForAllow("http://{foo}", Map.of("foo", "safe.com", "unused", fooResourceUrl)); // $ SPURIOUS: Alert // not bad - the key for the tainted value is unused
            restTemplate.optionsForAllow("http://{foo}", Map.of("foo", "safe.com", fooResourceUrl, "unused")); // not bad - the tainted value is in a map key

            {
                String body = new String("body");
                URI uri = new URI(fooResourceUrl);
                RequestEntity<String> requestEntity =
                        RequestEntity.post(uri).body(body); // $ Alert
                ResponseEntity<String> response = restTemplate.exchange(requestEntity, String.class);
                RequestEntity.get(uri); // $ Alert
                RequestEntity.put(uri); // $ Alert
                RequestEntity.delete(uri); // $ Alert
                RequestEntity.options(uri); // $ Alert
                RequestEntity.patch(uri); // $ Alert
                RequestEntity.head(uri); // $ Alert
                RequestEntity.method(null, uri); // $ Alert
            }
            {
                URI uri = new URI(fooResourceUrl);
                MultiValueMap<String, String> headers = null;
                java.lang.reflect.Type type = null;
                new RequestEntity<String>(null, uri); // $ Alert
                new RequestEntity<String>(headers, null, uri); // $ Alert
                new RequestEntity<String>("body", null, uri); // $ Alert
                new RequestEntity<String>("body", headers, null, uri); // $ Alert
                new RequestEntity<String>("body", null, uri, type); // $ Alert
                new RequestEntity<String>("body", headers, null, uri, type); // $ Alert
            }
        } catch (org.springframework.web.client.RestClientException | java.net.URISyntaxException e) {}
    }
}
