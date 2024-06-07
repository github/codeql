public void doGet(HttpServletRequest request, HttpServletResponse response) {
    String username = request.getParameter("username");

    // BAD: The input is written to the session without being sanitized.
    request.getSession().setAttribute("username", username);
}