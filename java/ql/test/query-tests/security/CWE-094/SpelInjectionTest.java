import java.io.IOException;
import java.io.InputStream;
import java.net.Socket;
import org.springframework.expression.Expression;
import org.springframework.expression.ExpressionParser;
import org.springframework.expression.spel.standard.SpelExpression;
import org.springframework.expression.spel.standard.SpelExpressionParser;
import org.springframework.expression.spel.support.SimpleEvaluationContext;
import org.springframework.expression.spel.support.StandardEvaluationContext;

public class SpelInjectionTest {

  private static final ExpressionParser PARSER = new SpelExpressionParser();

  public void testGetValue(Socket socket) throws IOException {
    InputStream in = socket.getInputStream();

    byte[] bytes = new byte[1024];
    int n = in.read(bytes);
    String input = new String(bytes, 0, n);

    ExpressionParser parser = new SpelExpressionParser();
    Expression expression = parser.parseExpression(input);
    expression.getValue(); // $hasSpelInjection
  }

  public void testGetValueWithParseRaw(Socket socket) throws IOException {
    InputStream in = socket.getInputStream();

    byte[] bytes = new byte[1024];
    int n = in.read(bytes);
    String input = new String(bytes, 0, n);
    SpelExpressionParser parser = new SpelExpressionParser();
    SpelExpression expression = parser.parseRaw(input);
    expression.getValue(); // $hasSpelInjection
  }

  public void testGetValueWithChainedCalls(Socket socket) throws IOException {
    InputStream in = socket.getInputStream();

    byte[] bytes = new byte[1024];
    int n = in.read(bytes);
    String input = new String(bytes, 0, n);

    Expression expression = new SpelExpressionParser().parseExpression(input);
    expression.getValue(); // $hasSpelInjection
  }

  public void testSetValueWithRootObject(Socket socket) throws IOException {
    InputStream in = socket.getInputStream();

    byte[] bytes = new byte[1024];
    int n = in.read(bytes);
    String input = new String(bytes, 0, n);

    Expression expression = new SpelExpressionParser().parseExpression(input);

    Object root = new Object();
    Object value = new Object();
    expression.setValue(root, value); // $hasSpelInjection
  }

  public void testGetValueWithStaticParser(Socket socket) throws IOException {
    InputStream in = socket.getInputStream();

    byte[] bytes = new byte[1024];
    int n = in.read(bytes);
    String input = new String(bytes, 0, n);

    Expression expression = PARSER.parseExpression(input);
    expression.getValue(); // $hasSpelInjection
  }

  public void testGetValueType(Socket socket) throws IOException {
    InputStream in = socket.getInputStream();

    byte[] bytes = new byte[1024];
    int n = in.read(bytes);
    String input = new String(bytes, 0, n);

    Expression expression = PARSER.parseExpression(input);
    expression.getValueType(); // $hasSpelInjection
  }

  public void testWithStandardEvaluationContext(Socket socket) throws IOException {
    InputStream in = socket.getInputStream();

    byte[] bytes = new byte[1024];
    int n = in.read(bytes);
    String input = new String(bytes, 0, n);

    Expression expression = PARSER.parseExpression(input);

    StandardEvaluationContext context = new StandardEvaluationContext();
    expression.getValue(context); // $hasSpelInjection
  }

  public void testWithSimpleEvaluationContext(Socket socket) throws IOException {
    InputStream in = socket.getInputStream();

    byte[] bytes = new byte[1024];
    int n = in.read(bytes);
    String input = new String(bytes, 0, n);

    Expression expression = PARSER.parseExpression(input);
    SimpleEvaluationContext context = SimpleEvaluationContext.forReadWriteDataBinding().build();

    expression.getValue(context); // Safe - the expression is evaluated in a limited context
  }

}
