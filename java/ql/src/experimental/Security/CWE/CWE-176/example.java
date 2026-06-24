import java.text.Normalizer;

public class BadExampleBypassEscape extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String inputEncoded = encodeForHtml(request.getParameter("input"));
        String output = Normalizer.normalize(inputEncoded, Normalizer.Form.NFKC);
        response.getWriter().write(output);
    }

    static String encodeForHtml(String text) {
        return text.replace("<", "&lt;");
    }
}