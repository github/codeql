import java.io.StringWriter;
import java.net.ServerSocket;
import java.net.Socket;
import java.util.function.Consumer;

import org.apache.commons.jexl3.*;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;

@Controller
public class Jexl3Injection {

    private static void runJexlExpression(String jexlExpr) {
        JexlEngine jexl = new JexlBuilder().create();
        JexlExpression e = jexl.createExpression(jexlExpr);
        JexlContext jc = new MapContext();
        e.evaluate(jc); // $ Alert
    }

    private static void runJexlExpressionWithJexlInfo(String jexlExpr) {
        JexlEngine jexl = new JexlBuilder().create();
        JexlExpression e = jexl.createExpression(new JexlInfo("unknown", 0, 0), jexlExpr);
        JexlContext jc = new MapContext();
        e.evaluate(jc); // $ Alert
    }

    private static void runJexlScript(String jexlExpr) {
        JexlEngine jexl = new JexlBuilder().create();
        JexlScript script = jexl.createScript(jexlExpr);
        JexlContext jc = new MapContext();
        script.execute(jc); // $ Alert
    }

    private static void runJexlScriptViaCallable(String jexlExpr) {
        JexlEngine jexl = new JexlBuilder().create();
        JexlScript script = jexl.createScript(jexlExpr);
        JexlContext jc = new MapContext();

        try {
            script.callable(jc).call(); // $ Alert
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
    }

    private static void runJexlExpressionViaGetProperty(String jexlExpr) {
        JexlEngine jexl = new JexlBuilder().create();
        jexl.getProperty(new Object(), jexlExpr); // $ Alert
    }

    private static void runJexlExpressionViaSetProperty(String jexlExpr) {
        JexlEngine jexl = new JexlBuilder().create();
        jexl.setProperty(new Object(), jexlExpr, new Object()); // $ Alert
    }

    private static void runJexlExpressionViaJxltEngineExpressionEvaluate(String jexlExpr) {
        JexlEngine jexl = new JexlBuilder().create();
        JxltEngine jxlt = jexl.createJxltEngine();
        jxlt.createExpression(jexlExpr).evaluate(new MapContext()); // $ Alert
    }

    private static void runJexlExpressionViaJxltEngineExpressionPrepare(String jexlExpr) {
        JexlEngine jexl = new JexlBuilder().create();
        JxltEngine jxlt = jexl.createJxltEngine();
        jxlt.createExpression(jexlExpr).prepare(new MapContext()); // $ Alert
    }

    private static void runJexlExpressionViaJxltEngineTemplateEvaluate(String jexlExpr) {
        JexlEngine jexl = new JexlBuilder().create();
        JxltEngine jxlt = jexl.createJxltEngine();
        jxlt.createTemplate(jexlExpr).evaluate(new MapContext(), new StringWriter()); // $ Alert
    }

    private static void runJexlExpressionViaCallable(String jexlExpr) {
        JexlEngine jexl = new JexlBuilder().create();
        JexlExpression e = jexl.createExpression(jexlExpr);
        JexlContext jc = new MapContext();

        try {
            e.callable(jc).call(); // $ Alert
        } catch (Exception ex) {
            throw new RuntimeException(ex);
        }
    }

    private static void testWithSocket(Consumer<String> action) throws Exception {
        try (ServerSocket serverSocket = new ServerSocket(0)) {
            try (Socket socket = serverSocket.accept()) {
                byte[] bytes = new byte[1024];
                int n = socket.getInputStream().read(bytes); // $ Source
                String jexlExpr = new String(bytes, 0, n);
                action.accept(jexlExpr);
            }
        }
    }

    // below are tests for the query

    public static void testWithJexlExpressionEvaluate() throws Exception {
        testWithSocket(Jexl3Injection::runJexlExpression);
    }

    public static void testWithJexlExpressionEvaluateWithInfo() throws Exception {
        testWithSocket(Jexl3Injection::runJexlExpressionWithJexlInfo);
    }

    public static void testWithJexlScriptExecute() throws Exception {
        testWithSocket(Jexl3Injection::runJexlScript);
    }

    public static void testWithJexlScriptCallable() throws Exception {
        testWithSocket(Jexl3Injection::runJexlScriptViaCallable);
    }

    public static void testWithJexlEngineGetProperty() throws Exception {
        testWithSocket(Jexl3Injection::runJexlExpressionViaGetProperty);
    }

    public static void testWithJexlEngineSetProperty() throws Exception {
        testWithSocket(Jexl3Injection::runJexlExpressionViaSetProperty);
    }

    public static void testWithJxltEngineExpressionEvaluate() throws Exception {
        testWithSocket(Jexl3Injection::runJexlExpressionViaJxltEngineExpressionEvaluate);
    }

    public static void testWithJxltEngineExpressionPrepare() throws Exception {
        testWithSocket(Jexl3Injection::runJexlExpressionViaJxltEngineExpressionPrepare);
    }

    public static void testWithJxltEngineTemplateEvaluate() throws Exception {
        testWithSocket(Jexl3Injection::runJexlExpressionViaJxltEngineTemplateEvaluate);
    }

    public static void testWithJexlExpressionCallable() throws Exception {
        testWithSocket(Jexl3Injection::runJexlExpressionViaCallable);
    }

    @PostMapping("/request")
    public ResponseEntity testWithSpringControllerThatEvaluatesJexlFromPathVariable(@PathVariable String expr) { // $ Source

        runJexlExpression(expr);
        return ResponseEntity.ok(HttpStatus.OK);
    }

    @PostMapping("/request")
    public ResponseEntity testWithSpringControllerThatEvaluatesJexlFromRequestBody(@RequestBody Data data) { // $ Source

        String expr = data.getExpr();
        runJexlExpression(expr);

        return ResponseEntity.ok(HttpStatus.OK);
    }

    @PostMapping("/request")
    public ResponseEntity testWithSpringControllerThatEvaluatesJexlFromRequestBodyWithNestedObjects(
            @RequestBody CustomRequest customRequest) { // $ Source

        String expr = customRequest.getData().getExpr();
        runJexlExpression(expr);

        return ResponseEntity.ok(HttpStatus.OK);
    }

    public static class CustomRequest {

        private Data data;

        CustomRequest(Data data) {
            this.data = data;
        }

        public Data getData() {
            return data;
        }
    }

    public static class Data {

        private String expr;

        Data(String expr) {
            this.expr = expr;
        }

        public String getExpr() {
            return expr;
        }
    }
}
