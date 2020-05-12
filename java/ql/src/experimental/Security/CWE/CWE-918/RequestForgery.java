public class TestServlet extends HttpServlet {
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
	throws ServletException, IOException {
        String target = request.getParameter("target");
		URL url = new URL("https://" + target + ".example.com/data/");
        URLConnection connection = url.openConnection();
        // connect and read response
	}
}
