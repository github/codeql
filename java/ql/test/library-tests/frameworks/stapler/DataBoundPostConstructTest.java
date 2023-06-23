import javax.annotation.PostConstruct;
import net.sf.json.JSONObject;
import org.kohsuke.stapler.DataBoundConstructor;
import org.kohsuke.stapler.DataBoundResolvable;
import org.kohsuke.stapler.DataBoundSetter;
import org.kohsuke.stapler.StaplerRequest;

public class DataBoundPostConstructTest implements DataBoundResolvable {

    static Object source(String label) {
        return null;
    }

    static void sink(Object o) {}

    static void test() {
        new DataBoundPostConstructTest(source("constructor"));
        new DataBoundPostConstructTest(null).setField(source("setter"));
    }

    private Object field;

    @DataBoundConstructor
    public DataBoundPostConstructTest(Object field) {
        this.field = field;
    }

    @DataBoundSetter
    public void setField(Object field) {
        this.field = field;
    }

    private Object bindResolve(StaplerRequest request, JSONObject src) {
        sink(this.field); // $ hasValueFlow=constructor hasValueFlow=setter
        return null;
    }

    @PostConstruct
    private void post() {
        sink(this.field); // $ hasValueFlow=constructor hasValueFlow=setter
    }
}
