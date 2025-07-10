import org.apache.commons.jexl2.*;

import java.io.StringWriter;
import java.net.ServerSocket;
import java.net.Socket;
import java.util.function.Consumer;

public class Jexl2Injection {

    private static void runJexlExpression(String jexlExpr) {
        JexlEngine jexl = new JexlEngine();
        Expression e = jexl.createExpression(jexlExpr);
        JexlContext jc = new MapContext();
        e.evaluate(jc); // $hasJexlInjection
    }

    private static void runJexlExpressionWithJexlInfo(String jexlExpr) {
        JexlEngine jexl = new JexlEngine();
        Expression e = jexl.createExpression(jexlExpr, new DebugInfo("unknown", 0, 0));
        JexlContext jc = new MapContext();
        e.evaluate(jc); // $hasJexlInjection
    }

    private static void runJexlScript(String jexlExpr) {
        JexlEngine jexl = new JexlEngine();
        Script script = jexl.createScript(jexlExpr);
        JexlContext jc = new MapContext();
        script.execute(jc); // $hasJexlInjection
    }

    private static void runJexlScriptViaCallable(String jexlExpr) {
        JexlEngine jexl = new JexlEngine();
        Script script = jexl.createScript(jexlExpr);
        JexlContext jc = new MapContext();

        try {
            script.callable(jc).call(); // $hasJexlInjection
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
    }

    private static void runJexlExpressionViaGetProperty(String jexlExpr) {
        JexlEngine jexl = new JexlEngine();
        jexl.getProperty(new Object(), jexlExpr); // $hasJexlInjection
    }

    private static void runJexlExpressionViaSetProperty(String jexlExpr) {
        JexlEngine jexl = new JexlEngine();
        jexl.setProperty(new Object(), jexlExpr, new Object()); // $hasJexlInjection
    }

    private static void runJexlExpressionViaUnifiedJEXLParseAndEvaluate(String jexlExpr) {
        JexlEngine jexl = new JexlEngine();
        UnifiedJEXL unifiedJEXL = new UnifiedJEXL(jexl);
        unifiedJEXL.parse(jexlExpr).evaluate(new MapContext()); // $hasJexlInjection
    }

    private static void runJexlExpressionViaUnifiedJEXLParseAndPrepare(String jexlExpr) {
        JexlEngine jexl = new JexlEngine();
        UnifiedJEXL unifiedJEXL = new UnifiedJEXL(jexl);
        unifiedJEXL.parse(jexlExpr).prepare(new MapContext()); // $hasJexlInjection
    }

    private static void runJexlExpressionViaUnifiedJEXLTemplateEvaluate(String jexlExpr) {
        JexlEngine jexl = new JexlEngine();
        UnifiedJEXL unifiedJEXL = new UnifiedJEXL(jexl);
        unifiedJEXL.createTemplate(jexlExpr).evaluate(new MapContext(), new StringWriter()); // $hasJexlInjection
    }

    private static void testWithSocket(Consumer<String> action) throws Exception {
        try (ServerSocket serverSocket = new ServerSocket(0)) {
            try (Socket socket = serverSocket.accept()) {
                byte[] bytes = new byte[1024];
                int n = socket.getInputStream().read(bytes);
                String jexlExpr = new String(bytes, 0, n);
                action.accept(jexlExpr);
            }
        }
    }

    // below are tests for the query

    public static void testWithJexlExpressionEvaluate() throws Exception {
        testWithSocket(Jexl2Injection::runJexlExpression);
    }

    public static void testWithJexlExpressionEvaluateWithInfo() throws Exception {
        testWithSocket(Jexl2Injection::runJexlExpressionWithJexlInfo);
    }

    public static void testWithJexlScriptExecute() throws Exception {
        testWithSocket(Jexl2Injection::runJexlScript);
    }

    public static void testWithJexlScriptCallable() throws Exception {
        testWithSocket(Jexl2Injection::runJexlScriptViaCallable);
    }

    public static void testWithJexlEngineGetProperty() throws Exception {
        testWithSocket(Jexl2Injection::runJexlExpressionViaGetProperty);
    }

    public static void testWithJexlEngineSetProperty() throws Exception {
        testWithSocket(Jexl2Injection::runJexlExpressionViaSetProperty);
    }

    public static void testWithUnifiedJEXLParseAndEvaluate() throws Exception {
        testWithSocket(Jexl2Injection::runJexlExpressionViaUnifiedJEXLParseAndEvaluate);
    }

    public static void testWithUnifiedJEXLParseAndPrepare() throws Exception {
        testWithSocket(Jexl2Injection::runJexlExpressionViaUnifiedJEXLParseAndPrepare);
    }

    public static void testWithUnifiedJEXLTemplateEvaluate() throws Exception {
        testWithSocket(Jexl2Injection::runJexlExpressionViaUnifiedJEXLTemplateEvaluate);
    }
}
