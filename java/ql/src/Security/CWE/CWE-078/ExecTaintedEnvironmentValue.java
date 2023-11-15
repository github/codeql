public void doGet(HttpServletRequest request, HttpServletResponse response) {
    String path = request.getParameter("path");

    Map<String, String> env = processBuilder.environment();
    env.put("PATH", path);

    processBuilder.start();
}