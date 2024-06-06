String opt = request.getParameter("opt");
String value = request.getParameter("value");

Map<String, String> env = processBuilder.environment();

// GOOD: opt and value are checked before being added to the environment
if (permittedJavaOptions.contains(opt) && validOption(opt, value)) {
    env.put(opt, value);
}