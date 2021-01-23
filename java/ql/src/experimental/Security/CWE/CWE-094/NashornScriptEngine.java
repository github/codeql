// Bad: Execute externally controlled input in Nashorn Script Engine
NashornScriptEngineFactory factory = new NashornScriptEngineFactory();
NashornScriptEngine engine = (NashornScriptEngine) factory.getScriptEngine(new String[] { "-scripting"});
Object result = engine.eval(input);
