import org.apache.commons.jexl2.*;
import org.apache.commons.jexl2.introspection.*;

import java.net.ServerSocket;
import java.net.Socket;
import java.util.function.Consumer;

public class SandboxedJexl2 {

    private static void runJexlExpressionWithSandbox(String jexlExpr) {
        Sandbox sandbox = new Sandbox();
        sandbox.white(SandboxedJexl2.class.getCanonicalName());
        Uberspect uberspect = new SandboxUberspectImpl(null, sandbox);
        JexlEngine jexl = new JexlEngine(uberspect, null, null, null);
        Expression e = jexl.createExpression(jexlExpr);
        JexlContext jc = new MapContext();
        e.evaluate(jc); // Safe
    }

    private static void runJexlExpressionViaSandboxedUnifiedJexl(String jexlExpr) {
        Sandbox sandbox = new Sandbox();
        sandbox.white(SandboxedJexl2.class.getCanonicalName());
        Uberspect uberspect = new SandboxUberspectImpl(null, sandbox);
        JexlEngine jexl = new JexlEngine(uberspect, null, null, null);
        UnifiedJEXL unifiedJEXL = new UnifiedJEXL(jexl);
        unifiedJEXL.parse(jexlExpr).evaluate(new MapContext()); // Safe
    }

    private static void simpleServer(Consumer<String> action) throws Exception {
        try (ServerSocket serverSocket = new ServerSocket(0)) {
            try (Socket socket = serverSocket.accept()) {
                byte[] bytes = new byte[1024];
                int n = socket.getInputStream().read(bytes);
                String jexlExpr = new String(bytes, 0, n);
                action.accept(jexlExpr);
            }
        }
    }

    public static void saferJexlExpressionEvaluate() throws Exception {
        simpleServer(SandboxedJexl2::runJexlExpressionWithSandbox);
    }

    public static void saferJexlExpressionEvaluateViaUnifiedJexl() throws Exception {
        simpleServer(SandboxedJexl2::runJexlExpressionViaSandboxedUnifiedJexl);
    }
}
