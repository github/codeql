public class GroovyInjection {
    void injectionViaClassLoader(HttpServletRequest request) {    
        String script = request.getParameter("script");
        final GroovyClassLoader classLoader = new GroovyClassLoader();
        Class groovy = classLoader.parseClass(script);
        GroovyObject groovyObj = (GroovyObject) groovy.newInstance();
    }

    void injectionViaEval(HttpServletRequest request) {
        String script = request.getParameter("script");
        Eval.me(script);
    }

    void injectionViaGroovyShell(HttpServletRequest request) {
        GroovyShell shell = new GroovyShell();
        String script = request.getParameter("script");
        shell.evaluate(script);
    }

    void injectionViaGroovyShellGroovyCodeSource(HttpServletRequest request) {
        GroovyShell shell = new GroovyShell();
        String script = request.getParameter("script");
        GroovyCodeSource gcs = new GroovyCodeSource(script, "test", "Test");
        shell.evaluate(gcs);
    }
}

