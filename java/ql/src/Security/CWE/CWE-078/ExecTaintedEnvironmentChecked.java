Map<String, String> env = builder.environment();
String debug = request.getParameter("debug");

if (debug != null) {
    env.put("PYTHONDEBUG", "1");
}
