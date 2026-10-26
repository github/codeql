import io.micronaut.http.annotation.*;
import io.micronaut.http.*;
import io.micronaut.http.cookie.*;
import java.util.List;
import java.util.Map;

@Controller("/http")
class MicronautHttpRequestTest {

    void sink(Object o) {}

    @Get("/headers")
    void testHeaders(HttpRequest<?> request) {
        sink(request.getHeaders()); // $ hasTaintFlow
        sink(request.getHeaders().get("X-Custom")); // $ hasTaintFlow
        sink(request.getHeaders().getAll("X-Custom").get(0)); // $ hasTaintFlow
        sink(request.getHeaders().getFirst("X-Custom").get()); // $ hasTaintFlow
        sink(request.getHeaders().getValue("X-Custom").get(0)); // $ hasTaintFlow
        sink(request.getHeaders().values().iterator().next().get(0)); // $ hasTaintFlow
        sink(request.getHeaders().asMap().get("X-Custom").get(0)); // $ hasTaintFlow
        sink(request.getHeaders().asProperties().get("X-Custom")); // $ hasTaintFlow
        sink(request.getHeaders().subMap("X", List.class).get("Custom").get(0)); // $ hasTaintFlow
        for (Map.Entry<String, List<String>> header : request.getHeaders()) {
            sink(header.getValue().get(0)); // $ hasTaintFlow
        }
    }

    @Get("/params")
    void testParameters(HttpRequest<?> request) {
        sink(request.getParameters()); // $ hasTaintFlow
        sink(request.getParameters().get("q")); // $ hasTaintFlow
        sink(request.getParameters().getAll("q").get(0)); // $ hasTaintFlow
        sink(request.getParameters().getFirst("q").get()); // $ hasTaintFlow
        sink(request.getParameters().getValue("q").get(0)); // $ hasTaintFlow
        sink(request.getParameters().values().iterator().next().get(0)); // $ hasTaintFlow
        sink(request.getParameters().asMap().get("q").get(0)); // $ hasTaintFlow
    }

    @Get("/cookies")
    void testCookies(HttpRequest<?> request) {
        sink(request.getCookies()); // $ hasTaintFlow
        Cookie cookie = request.getCookies().get("session");
        sink(cookie); // $ hasTaintFlow
        sink(cookie.getValue()); // $ hasTaintFlow
        sink(cookie.getName()); // $ hasTaintFlow
        sink(cookie.getDomain()); // $ hasTaintFlow
        sink(cookie.getPath()); // $ hasTaintFlow
        sink(request.getCookies().getAll()); // $ hasTaintFlow
        sink(request.getCookies().findCookie("session")); // $ hasTaintFlow
        sink(request.getCookies().getValue("session")); // $ hasTaintFlow
        sink(request.getCookies().values().iterator().next()); // $ hasTaintFlow
        sink(request.getCookies().asMap().get("session")); // $ hasTaintFlow
        for (Map.Entry<String, Cookie> entry : request.getCookies()) {
            sink(entry.getValue()); // $ hasTaintFlow
        }
    }

    @Get("/uri")
    void testUri(HttpRequest<?> request) {
        sink(request.getUri()); // $ hasTaintFlow
        sink(request.getPath()); // $ hasTaintFlow
        sink(request.getMethodName()); // $ hasTaintFlow
    }

    @Post("/body")
    void testBody(HttpRequest<String> request) {
        sink(request.getBody()); // $ hasTaintFlow
    }

    @Get("/content")
    void testContent(HttpRequest<?> request) {
        sink(request.getContentType()); // $ hasTaintFlow
        sink(request.getContentLength()); // $ hasTaintFlow
    }

    @Get("/redirect")
    HttpResponse<?> testRedirect(HttpRequest<?> request) {
        return HttpResponse.redirect(request.getUri()); // $ hasTaintFlow
    }

    @Get("/header-set")
    HttpResponse<?> testHeaderSplitting(HttpRequest<?> request) {
        return HttpResponse.ok().header("X-Custom", request.getHeaders().get("User-Input")); // $ hasTaintFlow
    }
}
