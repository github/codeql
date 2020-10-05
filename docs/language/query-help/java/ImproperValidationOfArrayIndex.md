# Improper validation of user-provided array index

```
ID: java/improper-validation-of-array-index
Kind: path-problem
Severity: warning
Precision: medium
Tags: security external/cwe/cwe-129

```
[Click to see the query in the CodeQL repository](https://github.com/github/codeql/tree/main/java/ql/src/Security/CWE/CWE-129/ImproperValidationOfArrayIndex.ql)

Using unvalidated input as part of an index into the array can cause the array access to throw an `ArrayIndexOutOfBoundsException`. This is because there is no guarantee that the index provided is within the bounds of the array.

This problem occurs when user input is used as an array index, either directly or following one or more calculations. If the user input is unsanitized, it may be any value, which could result in either a negative index, or an index which is larger than the size of the array, either of which would result in an `ArrayIndexOutOfBoundsException`.


## Recommendation
The index used in the array access should be checked against the bounds of the array before being used. The index should be smaller than the array size, and it should not be negative.


## Example
The following program accesses an element from a fixed size constant array:


```java
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
```
The first access of the `productDescriptions` array uses the user-provided value as the index without performing any checks. If the user provides a negative value, or a value larger than the size of the array, then an `ArrayIndexOutOfBoundsException` may be thrown.

The second access of the `productDescriptions` array is contained within a conditional expression that verifies the user-provided value is a valid index into the array. This ensures that the access operation never throws an `ArrayIndexOutOfBoundsException`.


## References
* Java API: [ArrayIndexOutOfBoundsException](https://docs.oracle.com/javase/8/docs/api/java/lang/ArrayIndexOutOfBoundsException.html).
* Common Weakness Enumeration: [CWE-129](https://cwe.mitre.org/data/definitions/129.html).