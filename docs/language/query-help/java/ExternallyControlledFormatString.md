# Use of externally-controlled format string

```
ID: java/tainted-format-string
Kind: path-problem
Severity: error
Precision: high
Tags: security external/cwe/cwe-134

```
[Click to see the query in the CodeQL repository](https://github.com/github/codeql/tree/main/java/ql/src/Security/CWE/CWE-134/ExternallyControlledFormatString.ql)

The `String.format` method and related methods, like `PrintStream.printf` and `Formatter.format`, all accept a format string that is used to format the trailing arguments to the format call by providing inline format specifiers. If the format string contains unsanitized input from an untrusted source, then that string may contain extra format specifiers that cause an exception to be thrown or information to be leaked.

The Java standard library implementation for the format methods throws an exception if either the format specifier does not match the type of the argument, or if there are too few or too many arguments. If unsanitized input is used in the format string, it may contain invalid extra format specifiers which cause an exception to be thrown.

Positional format specifiers may be used to access an argument to the format call by position. Unsanitized input in the format string may use a positional format specifier to access information that was not intended to be visible. For example, when formatting a Calendar instance we may intend to print only the year, but a user-specified format string may include a specifier to access the month and day.


## Recommendation
If the argument passed as a format string is meant to be a plain string rather than a format string, then pass `%s` as the format string, and pass the original argument as the sole trailing argument.


## Example
The following program is meant to check a card security code for a stored credit card:


```java
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
```
However, in the first format call it uses the cardSecurityCode provided by the user in a format string. If the user includes a format specifier in the cardSecurityCode field, they may be able to cause an exception to be thrown, or to be able to access extra information about the stored card expiration date.

The second format call shows the correct approach. The user-provided value is passed as an argument to the format call. This prevents any format specifiers in the user provided value from being evaluated.


## References
* CERT Java Coding Standard: [IDS06-J. Exclude unsanitized user input from format strings](https://www.securecoding.cert.org/confluence/display/java/IDS06-J.+Exclude+unsanitized+user+input+from+format+strings).
* Java SE Documentation: [Formatting Numeric Print Output](https://docs.oracle.com/javase/tutorial/java/data/numberformat.html).
* Java API: [Formatter](https://docs.oracle.com/javase/8/docs/api/java/util/Formatter.html).
* Common Weakness Enumeration: [CWE-134](https://cwe.mitre.org/data/definitions/134.html).