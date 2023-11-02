import java.lang.ProcessBuilder;
import java.lang.Runtime;
import java.util.Map;

public class TaintedEnvironment {
    public Object source() {
        return null;
    }

    public void buildProcess() throws java.io.IOException {
        String s = (String) source();
        ProcessBuilder pb = new ProcessBuilder();

        pb.environment().put("foo", s); // $hasTaintFlow

        pb.environment().put(s, "foo"); // $hasTaintFlow

        Map<String, String> env = pb.environment();

        env.put("foo", s); // $hasTaintFlow

        pb.start();
    }

    public void exec() throws java.io.IOException {
        String kv = (String) source();

        Runtime.getRuntime().exec(new String[] { "ls" }, new String[] { kv }); // $hasTaintFlow
    }
}
