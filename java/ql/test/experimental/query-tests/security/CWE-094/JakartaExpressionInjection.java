import java.io.IOException;
import java.net.ServerSocket;
import java.net.Socket;
import java.util.ArrayList;
import java.util.function.Consumer;

import javax.el.ELContext;
import javax.el.ELManager;
import javax.el.ELProcessor;
import javax.el.ExpressionFactory;
import javax.el.LambdaExpression;
import javax.el.MethodExpression;
import javax.el.StandardELContext;
import javax.el.ValueExpression;

public class JakartaExpressionInjection {
    
    private static void testWithSocket(Consumer<String> action) throws IOException {
        try (ServerSocket serverSocket = new ServerSocket(0)) {
            try (Socket socket = serverSocket.accept()) {
                byte[] bytes = new byte[1024];
                int n = socket.getInputStream().read(bytes);
                String expression = new String(bytes, 0, n);
                action.accept(expression);
            }
        }
    }

    private static void testWithELProcessorEval() throws IOException {
        testWithSocket(expression -> {
            ELProcessor processor = new ELProcessor();
            processor.eval(expression);
        });
    }

    private static void testWithELProcessorGetValue() throws IOException {
        testWithSocket(expression -> {   
            ELProcessor processor = new ELProcessor();
            processor.getValue(expression, Object.class);
        });
    }

    private static void testWithLambdaExpressionInvoke() throws IOException {
        testWithSocket(expression -> {
            ExpressionFactory factory = ELManager.getExpressionFactory();
            StandardELContext context = new StandardELContext(factory);
            ValueExpression valueExpression = factory.createValueExpression(context, expression, Object.class);
            LambdaExpression lambdaExpression = new LambdaExpression(new ArrayList<>(), valueExpression);
            lambdaExpression.invoke(context, new Object[0]);
        });
    }

    private static void testWithELProcessorSetValue() throws IOException {
        testWithSocket(expression -> {
            ELProcessor processor = new ELProcessor();
            processor.setValue(expression, new Object());
        });
    }

    private static void testWithJuelValueExpressionGetValue() throws IOException {
        testWithSocket(expression -> {
            ExpressionFactory factory = new de.odysseus.el.ExpressionFactoryImpl();
            ELContext context = new de.odysseus.el.util.SimpleContext();
            ValueExpression e = factory.createValueExpression(context, expression, Object.class);
            e.getValue(context);
        });
    }

    private static void testWithJuelValueExpressionSetValue() throws IOException {
        testWithSocket(expression -> {
            ExpressionFactory factory = new de.odysseus.el.ExpressionFactoryImpl();
            ELContext context = new de.odysseus.el.util.SimpleContext();
            ValueExpression e = factory.createValueExpression(context, expression, Object.class);
            e.setValue(context, new Object());
        });
    }

    private static void testWithJuelMethodExpressionInvoke() throws IOException {
        testWithSocket(expression -> {
            ExpressionFactory factory = new de.odysseus.el.ExpressionFactoryImpl();
            ELContext context = new de.odysseus.el.util.SimpleContext();
            MethodExpression e = factory.createMethodExpression(context, expression, Object.class, new Class[0]);
            e.invoke(context, new Object[0]);
        });
    }

}
