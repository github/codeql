public class TestServlet extends HttpServlet {
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
	throws ServletException, IOException {
        String target = request.getParameter("target");

        String subdomain;
        if (target.contentEquals("EU")) {
            subdomain = "europe";
        } else {
            subdomain = "global";
        }

        URL url = new URL("https://" + subdomain + ".example.com/data/");
        url.openConnection();
        // connect and read response
	}
}
