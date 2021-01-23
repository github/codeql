import jdk.nashorn.api.scripting.NashornScriptEngine;
import jdk.nashorn.api.scripting.NashornScriptEngineFactory;
import javax.script.*;


public class ScriptEngineTest {

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
	
	public static void main(String[] args) throws ScriptException {
		new ScriptEngineTest().testWithScriptEngineReference(args[0]);
		new ScriptEngineTest().testNashornWithScriptEngineReference(args[0]);
		new ScriptEngineTest().testNashornWithNashornScriptEngineReference(args[0]);
		new ScriptEngineTest().testCustomScriptEngineReference(args[0]);
	}
	
	private static class MyCustomScriptEngine extends AbstractScriptEngine {
		public Object eval(String var1) throws ScriptException {
			return null;
		}
	}
	
	private static class MyCustomFactory implements ScriptEngineFactory {
		public MyCustomFactory() {
    		}
    		
    		public ScriptEngine getScriptEngine() { return null; }

		public ScriptEngine getScriptEngine(String... args) { return null; }
	}
}
