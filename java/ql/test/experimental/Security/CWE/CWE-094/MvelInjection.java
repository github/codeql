import java.io.IOException;
import java.io.InputStream;
import java.io.Serializable;
import java.net.Socket;
import org.mvel2.MVEL;
import org.mvel2.compiler.CompiledExpression;
import org.mvel2.compiler.ExecutableStatement;
import org.mvel2.compiler.ExpressionCompiler;
import org.mvel2.integration.impl.ImmutableDefaultFactory;

public class MvelInjection {

  public static void testWithMvelEval(Socket socket) throws IOException {
    try (InputStream in = socket.getInputStream()) {
      byte[] bytes = new byte[1024];
      int n = in.read(bytes);
      String input = new String(bytes, 0, n);
      MVEL.eval(input);
    }
  }

  public static void testWithMvelCompileAndExecute(Socket socket) throws IOException {
    try (InputStream in = socket.getInputStream()) {
      byte[] bytes = new byte[1024];
      int n = in.read(bytes);
      String input = new String(bytes, 0, n);
      Serializable expression = MVEL.compileExpression(input);
      MVEL.executeExpression(expression);
    }
  }

  public static void testWithExpressionCompiler(Socket socket) throws IOException {
    try (InputStream in = socket.getInputStream()) {
      byte[] bytes = new byte[1024];
      int n = in.read(bytes);
      String input = new String(bytes, 0, n);
      ExpressionCompiler compiler = new ExpressionCompiler(input);
      ExecutableStatement statement = compiler.compile();
      statement.getValue(new Object(), new ImmutableDefaultFactory());
    }
  }

  public static void testWithCompiledExpressionGetDirectValue(Socket socket) throws IOException {
    try (InputStream in = socket.getInputStream()) {
      byte[] bytes = new byte[1024];
      int n = in.read(bytes);
      String input = new String(bytes, 0, n);
      ExpressionCompiler compiler = new ExpressionCompiler(input);
      CompiledExpression expression = compiler.compile();
      expression.getDirectValue(new Object(), new ImmutableDefaultFactory());
    }
  }
}
