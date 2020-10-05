# Improper validation of user-provided size used for array construction

```
ID: java/improper-validation-of-array-construction
Kind: path-problem
Severity: warning
Precision: medium
Tags: security external/cwe/cwe-129

```
[Click to see the query in the CodeQL repository](https://github.com/github/codeql/tree/main/java/ql/src/Security/CWE/CWE-129/ImproperValidationOfArrayConstruction.ql)

Using unvalidated input when specifying the size of a newly created array can result in the creation of an array with size zero. If this array is subsequently accessed without further checks, an `ArrayIndexOutOfBoundsException` may be thrown, because there is no guarantee that the array is not empty.

This problem occurs when user input is used as the size during array initialization, either directly or following one or more calculations. If the user input is unvalidated, it may cause the size of the array to be zero.


## Recommendation
The size used in the array initialization should be verified to be greater than zero before being used. Alternatively, the array access may be protected by a conditional check that ensures it is only accessed if the index is less than the array size.


## Example
The following program constructs an array with the size specified by some user input:


```java
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
```
The first array construction is protected by a condition that checks if the user input is zero or more. However, if the user provides `0` as the `numberOfItems` parameter, then an empty array is created, and any array access would fail with an `ArrayIndexOutOfBoundsException`.

The second array construction is protected by a condition that checks if the user input is greater than zero. The array will therefore never be empty, and the following array access will not throw an `ArrayIndexOutOfBoundsException`.


## References
* Java API: [ArrayIndexOutOfBoundsException](https://docs.oracle.com/javase/8/docs/api/java/lang/ArrayIndexOutOfBoundsException.html).
* Common Weakness Enumeration: [CWE-129](https://cwe.mitre.org/data/definitions/129.html).