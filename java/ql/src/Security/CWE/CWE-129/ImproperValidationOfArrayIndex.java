public class ImproperValidationOfArrayIndex extends HttpServlet {

  protected void doGet(HttpServletRequest request, HttpServletResponse response)
  throws ServletException, IOException {
    String[] productDescriptions = new String[] { "Chocolate bar", "Fizzy drink" };

    // User provided value
    String productID = request.getParameter("productID");
    try {
        int productID = Integer.parseInt(userProperty.trim());

        /*
         * BAD Array is accessed without checking if the user provided value is out of
         * bounds.
         */
        String productDescription = productDescriptions[productID];

        if (productID >= 0 && productID < productDescriptions.length) {
          // GOOD We have checked that the array index is valid first
          productDescription = productDescriptions[productID];
        } else {
          productDescription = "No product for that ID";
        }

        response.getWriter().write(productDescription);

    } catch (NumberFormatException e) { }
  }
}