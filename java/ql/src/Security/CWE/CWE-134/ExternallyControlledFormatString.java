public class ResponseSplitting extends HttpServlet {
  protected void doGet(HttpServletRequest request, HttpServletResponse response)
  throws ServletException, IOException {
    Calendar expirationDate = new GregorianCalendar(2017, GregorianCalendar.SEPTEMBER, 1);
    // User provided value
    String cardSecurityCode = request.getParameter("cardSecurityCode");
    
    if (notValid(cardSecurityCode)) {
      
      /*
       * BAD: user provided value is included in the format string.
       * A malicious user could provide an extra format specifier, which causes an
       * exception to be thrown. Or they could provide a %1$tm or %1$te format specifier to
       * access the month or day of the expiration date.
       */
      System.out.format(cardSecurityCode +
                          " is not the right value. Hint: the card expires in %1$ty.",
                        expirationDate);
      
      // GOOD: %s is used to include the user-provided cardSecurityCode in the output
      System.out.format("%s is not the right value. Hint: the card expires in %2$ty.",
                        cardSecurityCode,
                        expirationDate);
    }

  }
}