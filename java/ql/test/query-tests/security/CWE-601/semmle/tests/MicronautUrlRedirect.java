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

    @Get("/permanent")
    public MutableHttpResponse<?> permanent(@QueryValue String target) {
        return HttpResponse.permanentRedirect(URI.create(target));
    }

    @Get("/see-other")
    public MutableHttpResponse<?> seeOther(@QueryValue String target) {
        return HttpResponse.seeOther(URI.create(target));
    }

    @Get("/temporary")
    public MutableHttpResponse<?> temporary(@QueryValue String target) {
        return HttpResponse.temporaryRedirect(URI.create(target));
    }
}
