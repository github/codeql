Map<String, String> env = builder.environment();
String debug = request.getParameter("debug");

// GOOD: Checking the value and not tainting the variable added to the environment
if (debug != null) {
    env.put("PYTHONDEBUG", "1");
}
