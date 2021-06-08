import javax.script.AbstractScriptEngine;
import javax.script.Compilable;
import javax.script.CompiledScript;
import javax.script.ScriptEngine;
import javax.script.ScriptEngineManager;
import javax.script.ScriptEngineFactory;
import javax.script.ScriptException;

import jdk.nashorn.api.scripting.NashornScriptEngine;
import jdk.nashorn.api.scripting.NashornScriptEngineFactory;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class ScriptEngineTest extends HttpServlet {

	public void testWithScriptEngineReference(String input) throws ScriptException {
		ScriptEngineManager scriptEngineManager = new ScriptEngineManager();
		// Create with ScriptEngine reference
		ScriptEngine scriptEngine = scriptEngineManager.getEngineByExtension("js");
		Object result = scriptEngine.eval(input);
	}
	
	public void testNashornWithScriptEngineReference(String input) throws ScriptException {
		NashornScriptEngineFactory factory = new NashornScriptEngineFactory();
		// Create Nashorn with ScriptEngine reference
		ScriptEngine engine = (NashornScriptEngine) factory.getScriptEngine(new String[] { "-scripting" });
		Object result = engine.eval(input);
	}

	
	public void testNashornWithNashornScriptEngineReference(String input) throws ScriptException {
		NashornScriptEngineFactory factory = new NashornScriptEngineFactory();
		// Create Nashorn with NashornScriptEngine reference
		NashornScriptEngine engine = (NashornScriptEngine) factory.getScriptEngine(new String[] { "-scripting" });
		Object result = engine.eval(input);
	}
	
	public void testCustomScriptEngineReference(String input) throws ScriptException {
		MyCustomFactory factory = new MyCustomFactory();
		//Create with Custom Script Engine reference
		MyCustomScriptEngine engine = (MyCustomScriptEngine) factory.getScriptEngine(new String[] { "-scripting" });
		Object result = engine.eval(input);
	}

	public void testScriptEngineCompilable(String input) throws ScriptException {
		NashornScriptEngineFactory factory = new NashornScriptEngineFactory();
		Compilable engine = (Compilable) factory.getScriptEngine(new String[] { "-scripting" });
		CompiledScript script = engine.compile(input);
		Object result = script.eval();
	}

	public void testScriptEngineGetProgram(String input) throws ScriptException {
		ScriptEngineManager scriptEngineManager = new ScriptEngineManager();
		ScriptEngine engine = scriptEngineManager.getEngineByName("nashorn");
		String program = engine.getFactory().getProgram(input);
		Object result = engine.eval(program);
	}

	private static class MyCustomScriptEngine extends AbstractScriptEngine {
		public Object eval(String var1) throws ScriptException { return null; }

		@Override
		public ScriptEngineFactory getFactory() { return null; }
	}
	
	private static class MyCustomFactory implements ScriptEngineFactory {
		public MyCustomFactory() {
		}

		@Override
		public ScriptEngine getScriptEngine() { return null; }

		public ScriptEngine getScriptEngine(String... args) { return null; }

		@Override
		public String getEngineName() { return null; }

		@Override
		public String getMethodCallSyntax(final String obj, final String method, final String... args) { return null; }

		@Override
		public String getProgram(final String... statements) { return null; }
	}

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		try {
			String code = request.getParameter("code");

			new ScriptEngineTest().testWithScriptEngineReference(code);
			new ScriptEngineTest().testNashornWithScriptEngineReference(code);
			new ScriptEngineTest().testNashornWithNashornScriptEngineReference(code);
			new ScriptEngineTest().testCustomScriptEngineReference(code);
			new ScriptEngineTest().testScriptEngineCompilable(code);
			new ScriptEngineTest().testScriptEngineGetProgram(code);
		} catch (ScriptException se) {
			throw new IOException(se.getMessage());
		}
	}
}
