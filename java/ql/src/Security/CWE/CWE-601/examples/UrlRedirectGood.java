public class UrlRedirect extends HttpServlet {
  private static final List<String> VALID_REDIRECTS = Arrays.asList(
    "http://cwe.mitre.org/data/definitions/601.html",
    "http://cwe.mitre.org/data/definitions/79.html"
  );

  protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
    // GOOD: the request parameter is validated against a known list of strings
    String target = request.getParameter("target");
    if (VALID_REDIRECTS.contains(target)) {
        response.sendRedirect(target);
    } else {
        response.sendRedirect("/error.html");
    }
  }
}