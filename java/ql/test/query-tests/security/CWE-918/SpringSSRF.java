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

import org.apache.http.client.methods.HttpGet;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class SpringSSRF extends HttpServlet {

    protected void doGet(HttpServletRequest request2, HttpServletResponse response2)
            throws ServletException, IOException {
        String fooResourceUrl = request2.getParameter("uri");;
        RestTemplate restTemplate = new RestTemplate();
        HttpEntity<String> request = new HttpEntity<>(new String("bar"));
        try {
            restTemplate.getForEntity(fooResourceUrl + "/1", String.class); // $ SSRF
            restTemplate.exchange(fooResourceUrl, HttpMethod.POST, request, String.class); // $ SSRF
            restTemplate.execute(fooResourceUrl, HttpMethod.POST, null, null, "test"); // $ SSRF
            restTemplate.getForObject(fooResourceUrl, String.class, "test"); // $ SSRF
            restTemplate.patchForObject(fooResourceUrl, new String("object"), String.class, "hi"); // $ SSRF
            restTemplate.postForEntity(new URI(fooResourceUrl), new String("object"), String.class); // $ SSRF
            restTemplate.postForLocation(fooResourceUrl, new String("object")); // $ SSRF
            restTemplate.postForObject(fooResourceUrl, new String("object"), String.class); // $ SSRF
            restTemplate.put(fooResourceUrl, new String("object")); // $ SSRF
            restTemplate.delete(fooResourceUrl); // $ SSRF
            restTemplate.headForHeaders(fooResourceUrl); // $ SSRF
            restTemplate.optionsForAllow(fooResourceUrl); // $ SSRF
            {
                String body = new String("body");
                URI uri = new URI(fooResourceUrl);
                RequestEntity<String> requestEntity =
                        RequestEntity.post(uri).body(body); // $ SSRF
                ResponseEntity<String> response = restTemplate.exchange(requestEntity, String.class);
                RequestEntity.get(uri); // $ SSRF
                RequestEntity.put(uri); // $ SSRF
                RequestEntity.delete(uri); // $ SSRF
                RequestEntity.options(uri); // $ SSRF
                RequestEntity.patch(uri); // $ SSRF
                RequestEntity.head(uri); // $ SSRF
                RequestEntity.method(null, uri); // $ SSRF
            }
            {
                URI uri = new URI(fooResourceUrl);
                MultiValueMap<String, String> headers = null;
                java.lang.reflect.Type type = null;
                new RequestEntity<String>(null, uri); // $ SSRF
                new RequestEntity<String>(headers, null, uri); // $ SSRF
                new RequestEntity<String>("body", null, uri); // $ SSRF
                new RequestEntity<String>("body", headers, null, uri); // $ SSRF
                new RequestEntity<String>("body", null, uri, type); // $ SSRF
                new RequestEntity<String>("body", headers, null, uri, type); // $ SSRF
            }
        } catch (org.springframework.web.client.RestClientException | java.net.URISyntaxException e) {}
    }
}
