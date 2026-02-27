import io.micronaut.http.annotation.*;
import io.micronaut.http.*;
import io.micronaut.http.cookie.*;

@Controller("/http")
class MicronautHttpRequestTest {

    void sink(Object o) {}

    @Get("/headers")
    void testHeaders(HttpRequest<?> request) {
        sink(request.getHeaders()); // $hasTaintFlow
        sink(request.getHeaders().get("X-Custom")); // $hasTaintFlow
        sink(request.getHeaders().getAll("X-Custom")); // $hasTaintFlow
        sink(request.getHeaders().getFirst("X-Custom")); // $hasTaintFlow
        sink(request.getHeaders().values()); // $hasTaintFlow
    }

    @Get("/params")
    void testParameters(HttpRequest<?> request) {
        sink(request.getParameters()); // $hasTaintFlow
        sink(request.getParameters().get("q")); // $hasTaintFlow
        sink(request.getParameters().getAll("q")); // $hasTaintFlow
        sink(request.getParameters().getFirst("q")); // $hasTaintFlow
    }

    @Get("/cookies")
    void testCookies(HttpRequest<?> request) {
        sink(request.getCookies()); // $hasTaintFlow
        Cookie cookie = request.getCookies().get("session");
        sink(cookie); // $hasTaintFlow
        sink(cookie.getValue()); // $hasTaintFlow
        sink(cookie.getName()); // $hasTaintFlow
        sink(cookie.getDomain()); // $hasTaintFlow
        sink(cookie.getPath()); // $hasTaintFlow
        sink(request.getCookies().getAll()); // $hasTaintFlow
        sink(request.getCookies().findCookie("session")); // $hasTaintFlow
    }

    @Get("/uri")
    void testUri(HttpRequest<?> request) {
        sink(request.getUri()); // $hasTaintFlow
        sink(request.getPath()); // $hasTaintFlow
        sink(request.getMethodName()); // $hasTaintFlow
    }

    @Post("/body")
    void testBody(HttpRequest<String> request) {
        sink(request.getBody()); // $hasTaintFlow
    }

    @Get("/content")
    void testContent(HttpRequest<?> request) {
        sink(request.getContentType()); // $hasTaintFlow
        sink(request.getContentLength()); // $hasTaintFlow
    }

    @Get("/redirect")
    HttpResponse<?> testRedirect(HttpRequest<?> request) {
        return HttpResponse.redirect(request.getUri()); // $hasTaintFlow
    }

    @Get("/header-set")
    HttpResponse<?> testHeaderSplitting(HttpRequest<?> request) {
        return HttpResponse.ok().header("X-Custom", request.getHeaders().get("User-Input")); // $hasTaintFlow
    }
}
