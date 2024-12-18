public void doGet(HttpServletRequest request, HttpServletResponse response) {
    String attr = request.getParameter("attribute");
    String value = request.getParameter("value");

    Map<String, String> env = processBuilder.environment();
    // BAD: attr and value are tainted and being added to the environment
    env.put(attr, value);

    processBuilder.start();
}