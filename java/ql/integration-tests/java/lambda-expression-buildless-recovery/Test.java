// The import below is intentionally commented out to test buildless recovery.
// import java.util.stream.Stream;

public class LambdaBuildlessRecoveryTest {

    private Stream<String> getStringStream() {
        return getStringStream();
    }

    public void testSimpleLambdaExpression() {
        int unused = 0;
        Stream<String> s = getStringStream();
        Stream<String> mapped = s.map(x -> x);
        mapped.forEach(System.out::println);
    }

    public void testLambdaWithBlockBody() {
        int unused = 42;
        Stream<String> s = getStringStream();
        Stream<String> filtered = s.filter(item -> {
            int unused = 42;
            String proc = item.toUpperCase();
            return proc.length() > 0;
        });
        filtered.forEach(System.out::println);
    }

    public void testVariableCapture() {
        int unused = 99;
        String prefix = "proc_";
        Stream<String> s = getStringStream();
        Stream<String> result = s.map(item -> prefix + item);
        result.forEach(System.out::println);
    }
}
