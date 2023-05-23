import hudson.model.Descriptor;
import org.kohsuke.stapler.HttpResponse;
import org.kohsuke.stapler.StaplerRequest;
import org.kohsuke.stapler.StaplerResponse;

public class HttpResponseTest {

    Object source() {
        return null;
    }

    void sink(Object o) {}

    private class MyDescriptor extends Descriptor<Object> {
        public HttpResponse doTest() {
            return (MyHttpResponse) source();
        }
    }

    private class MyHttpResponse implements HttpResponse {
        @Override
        public void generateResponse(StaplerRequest p0, StaplerResponse p1, Object p2) {
            sink(this); // $ hasValueFlow
        }
    }
}
