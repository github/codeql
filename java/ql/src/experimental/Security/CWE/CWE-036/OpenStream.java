public class TestServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        // BAD: a URL from a remote source is opened with URL#openStream()
        URL url = new URL(request.getParameter("url"));
        InputStream inputStream = new URL(url).openStream();
    }
}
