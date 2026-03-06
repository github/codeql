import io.micronaut.http.annotation.*;
import io.micronaut.http.*;
import java.io.InputStream;
import java.io.Reader;

@Controller("/test")
class MicronautControllerTest {

    void sink(Object o) {}

    @Get("/path/{id}")
    void testPathVariable(@PathVariable String id) {
        sink(id); // $hasTaintFlow
    }

    @Get("/query")
    void testQueryValue(@QueryValue String name) {
        sink(name); // $hasTaintFlow
    }

    @Post("/body")
    void testBody(@Body String body) {
        sink(body); // $hasTaintFlow
    }

    @Get("/header")
    void testHeader(@Header String authorization) {
        sink(authorization); // $hasTaintFlow
    }

    @Get("/cookie")
    void testCookieValue(@CookieValue String sessionId) {
        sink(sessionId); // $hasTaintFlow
    }

    @Post("/part")
    void testPart(@Part String name) {
        sink(name); // $hasTaintFlow
    }

    @Get("/attr")
    void testRequestAttribute(@RequestAttribute String attr) {
        sink(attr); // $hasTaintFlow
    }

    @Post("/bean")
    void testRequestBean(@RequestBean Object bean) {
        sink(bean); // $hasTaintFlow
    }

    @Get("/implicit")
    void testImplicitParam(String implicitParam) {
        sink(implicitParam); // $hasTaintFlow
    }

    @Get("/request")
    void testHttpRequest(HttpRequest<String> request) {
        sink(request); // $hasTaintFlow
    }

    @Post("/stream")
    void testInputStream(InputStream stream) {
        sink(stream); // $hasTaintFlow
    }

    @Post("/reader")
    void testReader(Reader reader) {
        sink(reader); // $hasTaintFlow
    }

    @Post("/post")
    void testPostMethod(@Body String data) {
        sink(data); // $hasTaintFlow
    }

    @Put("/put")
    void testPutMethod(@Body String data) {
        sink(data); // $hasTaintFlow
    }

    @Delete("/delete/{id}")
    void testDeleteMethod(@PathVariable String id) {
        sink(id); // $hasTaintFlow
    }

    @Patch("/patch")
    void testPatchMethod(@Body String data) {
        sink(data); // $hasTaintFlow
    }

    @io.micronaut.http.annotation.Error
    void testErrorHandler(HttpRequest<?> request) {
        sink(request); // $hasTaintFlow
    }
}
