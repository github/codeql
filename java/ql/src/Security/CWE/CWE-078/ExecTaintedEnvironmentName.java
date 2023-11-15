public void doGet(HttpServletRequest request, HttpServletResponse response) {
    String attr = request.getParameter("attribute");
    String value = request.getParameter("value");

    Map<String, String> env = processBuilder.environment();
    env.put(attribute, value);

    processBuilder.start();
}