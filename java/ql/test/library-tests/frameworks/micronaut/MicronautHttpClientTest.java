import io.micronaut.http.*;
import io.micronaut.http.client.HttpClient;
import io.micronaut.http.client.BlockingHttpClient;
import io.micronaut.http.uri.UriBuilder;
import java.net.URI;

class MicronautHttpClientTest {

    void sink(Object o) {}

    String taint() {
        return null;
    }

    HttpClient client;

    void testRetrieveString() {
        String url = taint();
        client.toBlocking().retrieve(url); // $hasTaintFlow
    }

    void testRetrieveStringClass() {
        String url = taint();
        client.toBlocking().retrieve(url, String.class); // $hasTaintFlow
    }

    void testExchangeString() {
        String url = taint();
        client.toBlocking().exchange(url); // $hasTaintFlow
    }

    void testExchangeStringClass() {
        String url = taint();
        client.toBlocking().exchange(url, String.class); // $hasTaintFlow
    }

    void testGetFactory() {
        HttpRequest<?> req = HttpRequest.GET(taint());
        sink(req); // $hasTaintFlow
    }

    void testPostFactory() {
        HttpRequest<?> req = HttpRequest.POST(taint(), "body");
        sink(req); // $hasTaintFlow
    }

    void testPutFactory() {
        HttpRequest<?> req = HttpRequest.PUT(taint(), "body");
        sink(req); // $hasTaintFlow
    }

    void testDeleteFactory() {
        HttpRequest<?> req = HttpRequest.DELETE(taint());
        sink(req); // $hasTaintFlow
    }

    void testPatchFactory() {
        HttpRequest<?> req = HttpRequest.PATCH(taint(), "body");
        sink(req); // $hasTaintFlow
    }

    void testHeadFactory() {
        HttpRequest<?> req = HttpRequest.HEAD(taint());
        sink(req); // $hasTaintFlow
    }

    void testOptionsFactory() {
        HttpRequest<?> req = HttpRequest.OPTIONS(taint());
        sink(req); // $hasTaintFlow
    }

    void testUriBuilderOfCharSequence() {
        URI uri = UriBuilder.of(taint()).build();
        sink(uri); // $hasTaintFlow
    }

    void testUriBuilderOfUri() {
        URI uri = UriBuilder.of(URI.create(taint())).build();
        sink(uri); // $hasTaintFlow
    }

    void testUriBuilderHost() {
        URI uri = UriBuilder.of("http://example.com").host(taint()).build();
        sink(uri); // $hasTaintFlow
    }

    void testUriBuilderPath() {
        URI uri = UriBuilder.of("http://example.com").path(taint()).build();
        sink(uri); // $hasTaintFlow
    }

    void testUriBuilderQueryParamName() {
        URI uri = UriBuilder.of("http://example.com").queryParam(taint(), "value").build();
        sink(uri); // $hasTaintFlow
    }

    void testUriBuilderQueryParamValue() {
        URI uri = UriBuilder.of("http://example.com").queryParam("key", taint()).build();
        sink(uri); // $hasTaintFlow
    }

    void testUriBuilderFragment() {
        URI uri = UriBuilder.of("http://example.com").fragment(taint()).build();
        sink(uri); // $hasTaintFlow
    }
}
