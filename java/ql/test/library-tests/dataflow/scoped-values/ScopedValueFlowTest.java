public class ScopedValueFlowTest {
    private static final ScopedValue<String> USER_CONTEXT = ScopedValue.newInstance();
    private static final ScopedValue<String> SESSION_ID = ScopedValue.newInstance();

    public static void main(String[] args) {
        String userInput = args[0]; // source

        // Test 1: Basic scoped value binding and retrieval
        ScopedValue.where(USER_CONTEXT, userInput)
            .run(() -> {
                String value = USER_CONTEXT.get();
                sink(value); // should flag: tainted data reaches sink
            });

        // Test 2: Multiple scoped value bindings with chaining
        ScopedValue.where(USER_CONTEXT, userInput)
            .where(SESSION_ID, "safe-one")
            .run(() -> {
                String user = USER_CONTEXT.get();
                String session = SESSION_ID.get();
                sink(user); // should flag: tainted data reaches sink
                sink(session); // should NOT flag
            });

        ScopedValue.where(USER_CONTEXT, userInput)
            .run(() -> {
                String outer = USER_CONTEXT.get();
                ScopedValue.where(USER_CONTEXT, "safe-two")
                    .run(() -> {
                        String inner = USER_CONTEXT.get();
                        sink(inner); // False Positive: currently flags (model limitation
                    });
                sink(outer); // should flag: tainted data reaches sink
            });
    }

    public static void sink(String s) {
    }
}