public void doGet(HttpServletRequest request, HttpServletResponse response) {
    String path = request.getParameter("path");

    Map<String, String> env = processBuilder.environment();
    // BAD: path is tainted and being added to the environment
    env.put("PATH", path);

    processBuilder.start();
}