# Query built without neutralizing special characters

```
ID: java/concatenated-sql-query
Kind: problem
Severity: error
Precision: high
Tags: security external/cwe/cwe-089

```
[Click to see the query in the CodeQL repository](https://github.com/github/codeql/tree/main/java/ql/src/Security/CWE/CWE-089/SqlUnescaped.ql)

Even when the components of a SQL query are not fully controlled by a user, it is a vulnerability to concatenate those components into a SQL query without neutralizing special characters. Perhaps a separate vulnerability will allow the user to gain control of the component. As well, a user who cannot gain full control of an input might influence it enough to cause the SQL query to fail to run.


## Recommendation
Usually, it is better to use a SQL prepared statement than to build a complete SQL query with string concatenation. A prepared statement can include a wildcard, written as a question mark (?), for each part of the SQL query that is expected to be filled in by a different value each time it is run. When the query is later executed, a value must be supplied for each wildcard in the query.

In the Java Persistence Query Language, it is better to use queries with parameters than to build a complete query with string concatenation. A Java Persistence query can include a parameter placeholder for each part of the query that is expected to be filled in by a different value when run. A parameter placeholder may be indicated by a colon (:) followed by a parameter name, or by a question mark (?) followed by an integer position. When the query is later executed, a value must be supplied for each parameter in the query, using the `setParameter` method. Specifying the query using the `@NamedQuery` annotation introduces an additional level of safety: the query must be a constant string literal, preventing construction by string concatenation, and the only way to fill in values for parts of the query is by setting positional parameters.

It is good practice to use prepared statements (in SQL) or query parameters (in the Java Persistence Query Language) for supplying parameter values to a query, whether or not any of the parameters are directly traceable to user input. Doing so avoids any need to worry about quoting and escaping.


## Example
In the following example, the code runs a simple SQL query in two different ways.

The first way involves building a query, `query1`, by concatenating the result of `getCategory` with some string literals. The result of `getCategory` can include special characters, or it might be refactored later so that it may return something that contains special characters.

The second way, which shows good practice, involves building a query, `query2`, with a single string literal that includes a wildcard (`?`). The wildcard is then given a value by calling `setString`. This version is immune to injection attacks, because any special characters in the result of `getCategory` are not given any special treatment.


```java
{
    // BAD: the category might have SQL special characters in it
    String category = getCategory();
    Statement statement = connection.createStatement();
    String query1 = "SELECT ITEM,PRICE FROM PRODUCT WHERE ITEM_CATEGORY='"
        + category + "' ORDER BY PRICE";
    ResultSet results = statement.executeQuery(query1);
}

{
    // GOOD: use a prepared query
    String category = getCategory();
    String query2 = "SELECT ITEM,PRICE FROM PRODUCT WHERE ITEM_CATEGORY=? ORDER BY PRICE";
    PreparedStatement statement = connection.prepareStatement(query2);
    statement.setString(1, category);
    ResultSet results = statement.executeQuery();
}
```

## References
* OWASP: [SQL Injection Prevention Cheat Sheet](https://cheatsheetseries.owasp.org/cheatsheets/SQL_Injection_Prevention_Cheat_Sheet.html).
* The CERT Oracle Secure Coding Standard for Java: [IDS00-J. Prevent SQL injection](https://www.securecoding.cert.org/confluence/display/java/IDS00-J.+Prevent+SQL+injection).
* The Java Tutorials: [Using Prepared Statements](http://docs.oracle.com/javase/tutorial/jdbc/basics/prepared.html).
* Common Weakness Enumeration: [CWE-89](https://cwe.mitre.org/data/definitions/89.html).