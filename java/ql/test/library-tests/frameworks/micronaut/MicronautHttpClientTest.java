import io.micronaut.http.*;
import io.micronaut.http.client.HttpClient;
import io.micronaut.http.client.BlockingHttpClient;
import io.micronaut.http.uri.UriBuilder;
import io.micronaut.core.type.Argument;
import java.net.URI;
import java.util.Collections;

class MicronautHttpClientTest {

    void sink(Object o) {}

    String taint() {
        return null;
    }

    HttpClient client;

    void testRetrieveString() {
        String url = taint();
        client.toBlocking().retrieve(url); // $ hasTaintFlow
    }

    void testRetrieveStringClass() {
        String url = taint();
        client.toBlocking().retrieve(url, String.class); // $ hasTaintFlow
    }

    void testExchangeString() {
        String url = taint();
        client.toBlocking().exchange(url); // $ hasTaintFlow
    }

    void testExchangeStringClass() {
        String url = taint();
        client.toBlocking().exchange(url, String.class); // $ hasTaintFlow
    }

    void testRetrieveStringClassClass() {
        client.toBlocking().retrieve(taint(), String.class, Object.class); // $ hasTaintFlow
    }

    void testExchangeStringClassClass() {
        client.toBlocking().exchange(taint(), String.class, Object.class); // $ hasTaintFlow
    }

    void testBlockingRequest() {
        client.toBlocking().retrieve(HttpRequest.GET(taint())); // $ hasTaintFlow
        client.toBlocking().retrieve(HttpRequest.GET(taint()), String.class); // $ hasTaintFlow
        client.toBlocking().retrieve(HttpRequest.GET(taint()), new Argument<String>()); // $ hasTaintFlow
        client.toBlocking().retrieve(HttpRequest.GET(taint()), new Argument<String>(), new Argument<Object>()); // $ hasTaintFlow
        client.toBlocking().exchange(HttpRequest.GET(taint())); // $ hasTaintFlow
        client.toBlocking().exchange(HttpRequest.GET(taint()), String.class); // $ hasTaintFlow
        client.toBlocking().exchange(HttpRequest.GET(taint()), new Argument<String>()); // $ hasTaintFlow
        client.toBlocking().exchange(HttpRequest.GET(taint()), new Argument<String>(), new Argument<Object>()); // $ hasTaintFlow
    }

    void testNonBlockingClient() {
        client.retrieve(taint()); // $ hasTaintFlow
        client.exchange(taint()); // $ hasTaintFlow
        client.exchange(taint(), String.class); // $ hasTaintFlow
        client.retrieve(HttpRequest.GET(taint())); // $ hasTaintFlow
        client.retrieve(HttpRequest.GET(taint()), String.class); // $ hasTaintFlow
        client.retrieve(HttpRequest.GET(taint()), new Argument<String>()); // $ hasTaintFlow
        client.retrieve(HttpRequest.GET(taint()), new Argument<String>(), new Argument<Object>()); // $ hasTaintFlow
        client.exchange(HttpRequest.GET(taint())); // $ hasTaintFlow
        client.exchange(HttpRequest.GET(taint()), String.class); // $ hasTaintFlow
        client.exchange(HttpRequest.GET(taint()), new Argument<String>()); // $ hasTaintFlow
        client.exchange(HttpRequest.GET(taint()), new Argument<String>(), new Argument<Object>()); // $ hasTaintFlow
    }

    void testGetFactory() {
        HttpRequest<?> req = HttpRequest.GET(taint());
        sink(req); // $ hasTaintFlow
    }

    void testPostFactory() {
        HttpRequest<?> req = HttpRequest.POST(taint(), "body");
        sink(req); // $ hasTaintFlow
    }

    void testPutFactory() {
        HttpRequest<?> req = HttpRequest.PUT(taint(), "body");
        sink(req); // $ hasTaintFlow
    }

    void testDeleteFactory() {
        HttpRequest<?> req = HttpRequest.DELETE(taint());
        sink(req); // $ hasTaintFlow
    }

    void testPatchFactory() {
        HttpRequest<?> req = HttpRequest.PATCH(taint(), "body");
        sink(req); // $ hasTaintFlow
    }

    void testHeadFactory() {
        HttpRequest<?> req = HttpRequest.HEAD(taint());
        sink(req); // $ hasTaintFlow
    }

    void testOptionsFactory() {
        HttpRequest<?> req = HttpRequest.OPTIONS(taint());
        sink(req); // $ hasTaintFlow
    }

    void testUriFactories() {
        sink(HttpRequest.GET(URI.create(taint()))); // $ hasTaintFlow
        sink(HttpRequest.POST(URI.create(taint()), "body")); // $ hasTaintFlow
        sink(HttpRequest.PUT(URI.create(taint()), "body")); // $ hasTaintFlow
        sink(HttpRequest.DELETE(URI.create(taint()))); // $ hasTaintFlow
        sink(HttpRequest.DELETE(URI.create(taint()), "body")); // $ hasTaintFlow
        sink(HttpRequest.PATCH(URI.create(taint()), "body")); // $ hasTaintFlow
        sink(HttpRequest.HEAD(URI.create(taint()))); // $ hasTaintFlow
        sink(HttpRequest.OPTIONS(URI.create(taint()))); // $ hasTaintFlow
    }

    void testDeleteFactoryWithBody() {
        sink(HttpRequest.DELETE(taint(), "body")); // $ hasTaintFlow
    }

    void testUriBuilderOfCharSequence() {
        URI uri = UriBuilder.of(taint()).build();
        sink(uri); // $ hasTaintFlow
    }

    void testUriBuilderOfUri() {
        URI uri = UriBuilder.of(URI.create(taint())).build();
        sink(uri); // $ hasTaintFlow
    }

    void testUriBuilderHost() {
        URI uri = UriBuilder.of("http://example.com").host(taint()).build();
        sink(uri); // $ hasTaintFlow
    }

    void testUriBuilderPath() {
        URI uri = UriBuilder.of("http://example.com").path(taint()).build();
        sink(uri); // $ hasTaintFlow
    }

    void testUriBuilderQueryParamName() {
        URI uri = UriBuilder.of("http://example.com").queryParam(taint(), "value").build();
        sink(uri); // $ hasTaintFlow
    }

    void testUriBuilderQueryParamValue() {
        URI uri = UriBuilder.of("http://example.com").queryParam("key", taint()).build();
        sink(uri); // $ hasTaintFlow
    }

    void testUriBuilderFragment() {
        URI uri = UriBuilder.of("http://example.com").fragment(taint()).build();
        sink(uri); // $ hasTaintFlow
    }

    void testUriBuilderMutation() {
        UriBuilder builder = UriBuilder.of("http://example.com");
        builder.host(taint());
        sink(builder.build()); // $ hasTaintFlow
    }

    void testUriBuilderReplaceQueryParam() {
        URI uri = UriBuilder.of("http://example.com").replaceQueryParam("key", taint()).build();
        sink(uri); // $ hasTaintFlow
    }

    void testUriBuilderAdditionalFluentMethods() {
        sink(UriBuilder.of("http://example.com").scheme(taint()).build()); // $ hasTaintFlow
        sink(UriBuilder.of("http://example.com").userInfo(taint()).build()); // $ hasTaintFlow
        sink(UriBuilder.of("http://example.com").replacePath(taint()).build()); // $ hasTaintFlow
    }

    void testUriBuilderExpandBuilder() {
        URI uri = UriBuilder.of(taint()).expand(Collections.singletonMap("id", "value"));
        sink(uri); // $ hasTaintFlow
    }

    void testUriBuilderExpandValue() {
        URI uri = UriBuilder.of("http://example.com/{id}")
            .expand(Collections.singletonMap("id", taint()));
        sink(uri); // $ hasTaintFlow
    }
}
