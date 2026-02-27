import io.micronaut.context.annotation.Value;
import io.micronaut.context.annotation.Property;
import io.micronaut.http.annotation.*;

@Controller("/config")
class MicronautConfigTest {

    void sink(Object o) {}

    @Value("${app.secret}")
    String secretValue;

    @Property(name = "app.api-key")
    String apiKey;

    @Get("/secret")
    void testValueField() {
        sink(secretValue);
    }

    @Get("/key")
    void testPropertyField() {
        sink(apiKey);
    }

    @Get("/param")
    void testValueParam(@Value("${app.name}") String appName) {
        sink(appName);
    }
}
