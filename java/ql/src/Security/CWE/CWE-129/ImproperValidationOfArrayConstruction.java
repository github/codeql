public class ImproperValidationOfArrayIndex extends HttpServlet {

  protected void doGet(HttpServletRequest request, HttpServletResponse response)
  throws ServletException, IOException {
    try {
      // User provided value
      int numberOfItems = Integer.parseInt(request.getParameter("numberOfItems").trim());

      if (numberOfItems >= 0) {
        /*
         * BAD numberOfItems may be zero, which would cause the array indexing operation to
         * throw an ArrayIndexOutOfBoundsException
         */
        String items = new String[numberOfItems];
        items[0] = "Item 1";
      }

      if (numberOfItems > 0) {
        /*
         * GOOD numberOfItems must be greater than zero, so the indexing succeeds.
         */
        String items = new String[numberOfItems];
        items[0] = "Item 1";
      }

    } catch (NumberFormatException e) { }
  }
}