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
        {
            ResponseEntity<String> response =
                    restTemplate.getForEntity(fooResourceUrl + "/1", String.class);
        }

        {
            ResponseEntity<String> response =
                    restTemplate.exchange(fooResourceUrl, HttpMethod.POST, request, String.class);
        }
        {
            ResponseEntity<String> response =
                    restTemplate.execute(fooResourceUrl, HttpMethod.POST, null, null, "test");
        }
        {
            ResponseEntity<String> response =
                    restTemplate.getForEntity(fooResourceUrl, String.class, "test");
        }
        {
            String body = new String("body");
            RequestEntity<String> requestEntity =
                    RequestEntity.post(new URI(fooResourceUrl)).body(body);
            ResponseEntity<String> response = restTemplate.exchange(requestEntity, String.class);
        }
        {
            String response = restTemplate.patchForObject(fooResourceUrl, new String("object"),
                    String.class, "hi");
        }
        {
            ResponseEntity<String> response = restTemplate.postForEntity(new URI(fooResourceUrl),
                    new String("object"), String.class);
        }
        {
            URI response = restTemplate.postForLocation(fooResourceUrl, new String("object"));
        }
        {
            String response =
                    restTemplate.postForObject(fooResourceUrl, new String("object"), String.class);
        }
        {
            restTemplate.put(fooResourceUrl, new String("object"));
        }
        } catch (org.springframework.web.client.RestClientException | java.net.URISyntaxException e) {}
    }
}
