public class UrlRedirect extends HttpServlet {
  protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
    // BAD: a request parameter is incorporated without validation into a URL redirect
    response.sendRedirect(request.getParameter("target"));
  }
}