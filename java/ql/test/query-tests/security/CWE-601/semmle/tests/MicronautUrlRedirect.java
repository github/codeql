import io.micronaut.http.annotation.Controller;
import io.micronaut.http.annotation.Get;
import io.micronaut.http.annotation.QueryValue;
import io.micronaut.http.HttpResponse;
import io.micronaut.http.MutableHttpResponse;
import java.net.URI;

@Controller("/redirect")
public class MicronautUrlRedirect {

    @Get("/bad")
    public MutableHttpResponse<?> bad(@QueryValue String target) { // $ Source
        // BAD: user-controlled redirect target
        return HttpResponse.redirect(URI.create(target)); // $ Alert
    }

    @Get("/good")
    public MutableHttpResponse<?> good(@QueryValue String target) {
        // GOOD: redirect to a fixed URL
        if ("home".equals(target)) {
            return HttpResponse.redirect(URI.create("/home"));
        }
        return HttpResponse.ok();
    }

    @Get("/permanent")
    public MutableHttpResponse<?> permanent(@QueryValue String target) { // $ Source
        return HttpResponse.permanentRedirect(URI.create(target)); // $ Alert
    }

    @Get("/see-other")
    public MutableHttpResponse<?> seeOther(@QueryValue String target) { // $ Source
        return HttpResponse.seeOther(URI.create(target)); // $ Alert
    }

    @Get("/temporary")
    public MutableHttpResponse<?> temporary(@QueryValue String target) { // $ Source
        return HttpResponse.temporaryRedirect(URI.create(target)); // $ Alert
    }
}
