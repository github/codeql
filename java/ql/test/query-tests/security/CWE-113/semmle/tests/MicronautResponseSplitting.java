import io.micronaut.http.annotation.Controller;
import io.micronaut.http.annotation.Get;
import io.micronaut.http.annotation.QueryValue;
import io.micronaut.http.HttpResponse;
import io.micronaut.http.MutableHttpResponse;

@Controller("/headers")
public class MicronautResponseSplitting {

    @Get("/bad")
    public MutableHttpResponse<?> bad(@QueryValue String headerValue) {
        // BAD: user-controlled header value
        return HttpResponse.ok().header("X-Custom", headerValue);
    }

    @Get("/good")
    public MutableHttpResponse<?> good(@QueryValue String headerValue) {
        // GOOD: sanitized header value by replacing line breaks
        String sanitized = headerValue.replace('\n', ' ').replace('\r', ' ');
        return HttpResponse.ok().header("X-Custom", sanitized);
    }
}
