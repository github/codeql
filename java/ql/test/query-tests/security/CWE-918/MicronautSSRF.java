import io.micronaut.http.annotation.Controller;
import io.micronaut.http.annotation.Get;
import io.micronaut.http.annotation.QueryValue;
import io.micronaut.http.client.HttpClient;
import io.micronaut.http.uri.UriBuilder;
import java.net.URI;

@Controller("/ssrf")
public class MicronautSSRF {

    private HttpClient client;

    @Get("/retrieve")
    public String testRetrieve(@QueryValue String url) { // $ Source
        return client.toBlocking().retrieve(url); // $ Alert
    }

    @Get("/exchange-string")
    public Object testExchangeWithString(@QueryValue String url) { // $ Source
        return client.toBlocking().exchange(url); // $ Alert
    }

    @Get("/retrieve-typed")
    public Object testRetrieveTyped(@QueryValue String url) { // $ Source
        return client.toBlocking().retrieve(url, String.class); // $ Alert
    }

    @Get("/uri-builder")
    public String testUriBuilder(@QueryValue String host) { // $ Source
        URI uri = UriBuilder.of("http://example.com").host(host).build();
        return client.toBlocking().retrieve(uri.toString()); // $ Alert
    }
}
