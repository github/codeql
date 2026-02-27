import io.micronaut.http.annotation.Controller;
import io.micronaut.http.annotation.Get;
import io.micronaut.http.annotation.QueryValue;
import io.micronaut.http.HttpResponse;
import io.micronaut.http.MutableHttpResponse;
import java.net.URI;

@Controller("/redirect")
public class MicronautUrlRedirect {

    @Get("/bad")
    public MutableHttpResponse<?> bad(@QueryValue String target) {
        // BAD: user-controlled redirect target
        return HttpResponse.redirect(URI.create(target));
    }

    @Get("/good")
    public MutableHttpResponse<?> good(@QueryValue String target) {
        // GOOD: redirect to a fixed URL
        if ("home".equals(target)) {
            return HttpResponse.redirect(URI.create("/home"));
        }
        return HttpResponse.ok();
    }
}
