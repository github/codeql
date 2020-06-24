import java.io.IOException;
import java.io.InputStream;
import java.io.Serializable;
import java.net.Socket;
import java.util.HashMap;
import javax.script.CompiledScript;
import javax.script.SimpleScriptContext;
import org.mvel2.MVEL;
import org.mvel2.MVELRuntime;
import org.mvel2.ParserContext;
import org.mvel2.compiler.CompiledAccExpression;
import org.mvel2.compiler.CompiledExpression;
import org.mvel2.compiler.ExecutableStatement;
import org.mvel2.compiler.ExpressionCompiler;
import org.mvel2.integration.impl.ImmutableDefaultFactory;
import org.mvel2.jsr223.MvelCompiledScript;
import org.mvel2.jsr223.MvelScriptEngine;
import org.mvel2.templates.CompiledTemplate;
import org.mvel2.templates.TemplateCompiler;
import org.mvel2.templates.TemplateRuntime;

public class MvelInjection {

  public static void testWithMvelEval(Socket socket) throws IOException {
    MVEL.eval(read(socket));
  }

  public static void testWithMvelCompileAndExecute(Socket socket) throws IOException {
    Serializable expression = MVEL.compileExpression(read(socket));
    MVEL.executeExpression(expression);
  }

  public static void testWithExpressionCompiler(Socket socket) throws IOException {
    ExpressionCompiler compiler = new ExpressionCompiler(read(socket));
    ExecutableStatement statement = compiler.compile();
    statement.getValue(new Object(), new ImmutableDefaultFactory());
    statement.getValue(new Object(), new Object(), new ImmutableDefaultFactory());
  }

  public static void testWithCompiledExpressionGetDirectValue(Socket socket) throws IOException {
    ExpressionCompiler compiler = new ExpressionCompiler(read(socket));
    CompiledExpression expression = compiler.compile();
    expression.getDirectValue(new Object(), new ImmutableDefaultFactory());
  }

  public static void testCompiledAccExpressionGetValue(Socket socket) throws IOException {
    CompiledAccExpression expression = new CompiledAccExpression(
      read(socket).toCharArray(), Object.class, new ParserContext());
    expression.getValue(new Object(), new ImmutableDefaultFactory());
  }

  public static void testMvelScriptEngineCompileAndEvaluate(Socket socket) throws Exception {
    String input = read(socket);

    MvelScriptEngine engine = new MvelScriptEngine();
    CompiledScript compiledScript = engine.compile(input);
    compiledScript.eval();

    Serializable script = engine.compiledScript(input);
    engine.evaluate(script, new SimpleScriptContext());
  }

  public static void testMvelCompiledScriptCompileAndEvaluate(Socket socket) throws Exception {
    MvelScriptEngine engine = new MvelScriptEngine();
    ExpressionCompiler compiler = new ExpressionCompiler(read(socket));
    ExecutableStatement statement = compiler.compile();
    MvelCompiledScript script = new MvelCompiledScript(engine, statement);
    script.eval(new SimpleScriptContext());
  }

  public static void testTemplateRuntimeEval(Socket socket) throws Exception {
    TemplateRuntime.eval(read(socket), new HashMap());
  }

  public static void testTemplateRuntimeCompileTemplateAndExecute(Socket socket) throws Exception {
    TemplateRuntime.execute(
      TemplateCompiler.compileTemplate(read(socket)), new HashMap());
  }

  public static void testTemplateRuntimeCompileAndExecute(Socket socket) throws Exception {
    TemplateCompiler compiler = new TemplateCompiler(read(socket));
    TemplateRuntime.execute(compiler.compile(), new HashMap());
  }

  public static void testMvelRuntimeExecute(Socket socket) throws Exception {
    ExpressionCompiler compiler = new ExpressionCompiler(read(socket));
    CompiledExpression expression = compiler.compile();
    MVELRuntime.execute(false, expression, new Object(), new ImmutableDefaultFactory());
  }

  public static String read(Socket socket) throws IOException {
    try (InputStream is = socket.getInputStream()) {
      byte[] bytes = new byte[1024];
      int n = is.read(bytes);
      return new String(bytes, 0, n);
    }
  }
}
