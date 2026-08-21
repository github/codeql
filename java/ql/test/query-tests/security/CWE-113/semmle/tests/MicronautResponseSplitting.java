import io.micronaut.http.annotation.Controller;
import io.micronaut.http.annotation.Get;
import io.micronaut.http.annotation.QueryValue;
import io.micronaut.http.HttpResponse;
import io.micronaut.http.MutableHttpResponse;
import java.util.Collections;
import java.util.HashMap;
import java.util.Map;

@Controller("/headers")
public class MicronautResponseSplitting {

    @Get("/bad")
    public MutableHttpResponse<?> bad(@QueryValue String headerValue) { // $ Source
        // BAD: user-controlled header value
        return HttpResponse.ok().header("X-Custom", headerValue); // $ Alert
    }

    @Get("/good")
    public MutableHttpResponse<?> good(@QueryValue String headerValue) {
        // GOOD: sanitized header value by replacing line breaks
        String sanitized = headerValue.replace('\n', ' ').replace('\r', ' ');
        return HttpResponse.ok().header("X-Custom", sanitized);
    }

    @Get("/bad-map")
    public MutableHttpResponse<?> badMap(@QueryValue String headerValue) { // $ Source
        // BAD: user-controlled header value
        return HttpResponse.ok().headers(Collections.singletonMap("X-Custom", headerValue)); // $ Alert
    }

    @Get("/bad-map-mutation")
    public MutableHttpResponse<?> badMapMutation(@QueryValue String headerValue) { // $ Source
        Map<CharSequence, CharSequence> headers = new HashMap<>();
        headers.put("X-Custom", headerValue);
        return HttpResponse.ok().headers(headers); // $ Alert
    }

    @Get("/good-map")
    public MutableHttpResponse<?> goodMap() {
        return HttpResponse.ok().headers(Collections.singletonMap("X-Custom", "safe"));
    }

    @Get("/good-map-sanitized")
    public MutableHttpResponse<?> goodMapSanitized(@QueryValue String headerValue) {
        String sanitized = headerValue.replace('\n', ' ').replace('\r', ' ');
        return HttpResponse.ok().headers(Collections.singletonMap("X-Custom", sanitized));
    }
}
