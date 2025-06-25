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
            restTemplate.exchange(fooResourceUrl, HttpMethod.POST, request, String.class); // $ Alert
            restTemplate.execute(fooResourceUrl, HttpMethod.POST, null, null, "test"); // $ Alert
            restTemplate.getForObject(fooResourceUrl, String.class, "test"); // $ Alert
            restTemplate.getForObject("http://{foo}", String.class, fooResourceUrl); // $ Alert
            restTemplate.getForObject("http://{foo}/a/b", String.class, fooResourceUrl); // $ Alert
            restTemplate.getForObject("http://safe.com/{foo}", String.class, fooResourceUrl); // not bad - the tainted value does not affect the host
            restTemplate.getForObject("http://{foo}", String.class, "safe.com", fooResourceUrl); // not bad - the tainted value is unused
            restTemplate.getForObject("http://{foo}", String.class, Map.of("foo", fooResourceUrl)); // $ Alert
            restTemplate.getForObject("http://safe.com/{foo}", String.class, Map.of("foo", fooResourceUrl)); // not bad - the tainted value does not affect the host
            restTemplate.getForObject("http://{foo}", String.class, Map.of("foo", "safe.com", "unused", fooResourceUrl)); // $ SPURIOUS: Alert // not bad - the key for the tainted value is unused
            restTemplate.getForObject("http://{foo}", String.class, Map.of("foo", "safe.com", fooResourceUrl, "unused")); // not bad - the tainted value is in a map key
            restTemplate.patchForObject(fooResourceUrl, new String("object"), String.class, "hi"); // $ Alert
            restTemplate.postForEntity(new URI(fooResourceUrl), new String("object"), String.class); // $ Alert
            restTemplate.postForLocation(fooResourceUrl, new String("object")); // $ Alert
            restTemplate.postForObject(fooResourceUrl, new String("object"), String.class); // $ Alert
            restTemplate.put(fooResourceUrl, new String("object")); // $ Alert
            restTemplate.delete(fooResourceUrl); // $ Alert
            restTemplate.headForHeaders(fooResourceUrl); // $ Alert
            restTemplate.optionsForAllow(fooResourceUrl); // $ Alert
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
