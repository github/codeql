## Contributing

Hi there! We're thrilled that you'd like to contribute to this project. Your help is essential for keeping it great.

Contributions to this project are [released](https://help.github.com/articles/github-terms-of-service/#6-contributions-under-repository-license) to the public under the [project's open source license](LICENSE).

Please note that this project is released with a [Contributor Code of Conduct][CODE_OF_CONDUCT.md]. By participating in this project you agree to abide by its terms.

## Adding a new query

If you have an idea for a query that you would like to share with other CodeQL users, please open a pull request to add it to this repository. 
Follow the steps below to help other users understand what your query does, and to ensure that your query is consistent with the other CodeQL queries.

1. **Consult the documentation for query writers**

   There is lots of useful documentation to help you write CodeQL queries, ranging from information about query file structure to language-specific tutorials. For more information on the documentation available, see [Writing QL queries](https://help.semmle.com/QL/learn-ql/writing-queries/writing-queries.html) on [help.semmle.com](https://help.semmle.com).

2. **Format your code correctly**

   All of the standard CodeQL queries and libraries are uniformly formatted for clarity and consistency, so we strongly recommend that all contributions follow the same formatting guidelines. If you use the CodeQL extension for Visual Studio Code, you can auto-format your query in the [QL editor](https://help.semmle.com/ql-for-eclipse/Content/WebHelp/ql-editor.html). For more information, see the [QL style guide](https://github.com/Semmle/ql/blob/master/docs/ql-style-guide.md).

3. **Make sure your query has the correct metadata**

   Query metadata is used by Semmle's analysis to identify your query and make sure the query results are displayed properly. 
   The most important metadata to include are the `@name`, `@description`, and the `@kind`.
   Other metadata properties (`@precision`, `@severity`, and `@tags`) are usually added after the query has been reviewed by the maintainers.
   For more information on writing query metadata, see the [Query metadata style guide](https://github.com/Semmle/ql/blob/master/docs/query-metadata-style-guide.md).

4. **Make sure the `select` statement is compatible with the query type**

   The `select` statement of your query must be compatible with the query type (determined by the `@kind` metadata property) for alert or path results to be displayed correctly in LGTM and Visual Studio Code.
   For more information on `select` statement format, see [Introduction to query files](https://help.semmle.com/QL/learn-ql/writing-queries/introduction-to-queries.html#select-clause) on help.semmle.com.

5. **Write a query help file**

   Query help files explain the purpose of your query to other users. Write your query help in a `.qhelp` file and save it in the same directory as your new query. 
   For more information on writing query help, see the [Query help style guide](https://github.com/Semmle/ql/blob/master/docs/query-help-style-guide.md).

## Resources

- [How to Contribute to Open Source](https://opensource.guide/how-to-contribute/)
- [Using Pull Requests](https://help.github.com/articles/about-pull-requests/)
- [GitHub Help](https://help.github.com)
- [A Note About Git Commit Messages](http://tbaggery.com/2008/04/19/a-note-about-git-commit-messages.html)
