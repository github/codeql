import java.net.ServerSocket;
import java.net.Socket;
import java.security.AccessControlException;
import java.util.Arrays;
import java.util.Iterator;
import java.util.List;
import java.util.function.Consumer;

import org.apache.commons.jexl3.*;
import org.apache.commons.jexl3.introspection.*;

public class SandboxedJexl3 {

    private static void runJexlExpressionWithSandbox(String jexlExpr) {
        JexlSandbox sandbox = new JexlSandbox(false);
        sandbox.white(SandboxedJexl3.class.getCanonicalName());
        JexlEngine jexl = new JexlBuilder().sandbox(sandbox).create();
        JexlExpression e = jexl.createExpression(jexlExpr); // Safe
        JexlContext jc = new MapContext();
        e.evaluate(jc); // Safe
    }

    private static void runJexlExpressionWithUberspectSandbox(String jexlExpr) {
        JexlUberspect sandbox = new JexlUberspectSandbox();
        JexlEngine jexl = new JexlBuilder().uberspect(sandbox).create();
        JexlExpression e = jexl.createExpression(jexlExpr); // Safe
        JexlContext jc = new MapContext();
        e.evaluate(jc); // Safe
    }

    private static JexlBuilder STATIC_JEXL_BUILDER;

    static {
        JexlSandbox sandbox = new JexlSandbox(false);
        sandbox.white(SandboxedJexl3.class.getCanonicalName());
        STATIC_JEXL_BUILDER = new JexlBuilder().sandbox(sandbox);
    }

    private static void runJexlExpressionViaJxltEngineWithSandbox(String jexlExpr) {
        JexlEngine jexl = STATIC_JEXL_BUILDER.create();
        JxltEngine jxlt = jexl.createJxltEngine();
        jxlt.createExpression(jexlExpr).evaluate(new MapContext()); // Safe
    }

    private static class JexlUberspectSandbox implements JexlUberspect {

    }

    private static void withSocket(Consumer<String> action) throws Exception {
        try (ServerSocket serverSocket = new ServerSocket(0)) {
            try (Socket socket = serverSocket.accept()) {
                byte[] bytes = new byte[1024];
                int n = socket.getInputStream().read(bytes);
                String jexlExpr = new String(bytes, 0, n);
                action.accept(jexlExpr);
            }
        }
    }

    // below are examples of safer Jexl usage

    // with JexlSandbox
    public static void saferJexlExpressionInSandbox() throws Exception {
        withSocket(SandboxedJexl3::runJexlExpressionWithSandbox);
    }

    // with a custom sandbox implemented with JexlUberspect
    public static void saferJexlExpressionInUberspectSandbox() throws Exception {
        withSocket(SandboxedJexl3::runJexlExpressionWithUberspectSandbox);
    }

    // with JexlSandbox and JxltEngine
    public static void saferJxltExpressionInSandbox() throws Exception {
        withSocket(SandboxedJexl3::runJexlExpressionViaJxltEngineWithSandbox);
    }
}
