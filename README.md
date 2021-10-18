# CodeQL

This open source repository contains the standard CodeQL libraries and queries that power [LGTM](https://lgtm.com) and the other CodeQL products that [GitHub](https://github.com) makes available to its customers worldwide. For the queries, libraries, and extractor that power Go analysis, visit the [CodeQL for Go repository](https://github.com/github/codeql-go).

## How do I learn CodeQL and run queries?

There is [extensive documentation](https://codeql.github.com/docs/) on getting started with writing CodeQL.
You can use the [interactive query console](https://lgtm.com/help/lgtm/using-query-console) on LGTM.com or the [CodeQL for Visual Studio Code](https://codeql.github.com/docs/codeql-for-visual-studio-code/) extension to try out your queries on any open source project that's currently being analyzed.

## Contributing
Pull requests are welcome.For major changes,please open an issue first to discuss what you would like to change.
Please make sure to update tests as appropriate.
We welcome contributions to our standard library and standard checks. Do you have an idea for a new check, or how to improve an existing query? Then please go ahead and open a pull request! Before you do, though, please take the time to read our [contributing guidelines](CONTRIBUTING.md). You can also consult our [style guides](https://github.com/github/codeql/tree/main/docs) to learn how to format your code for consistency and clarity, how to write query metadata, and how to write query help documentation for your query.

## License

The code in this repository is licensed under the [MIT License](LICENSE) by [GitHub](https://github.com).

## Visual Studio Code integration

If you use Visual Studio Code to work in this repository, there are a few integration features to make development easier.I t also enables major effects on the project and makes the repo to look good and neat.

### CodeQL for Visual Studio Code

You can install the [CodeQL for Visual Studio Code](https://marketplace.visualstudio.com/items?itemName=GitHub.vscode-codeql) extension to get syntax highlighting, IntelliSense, and code navigation for the QL language, as well as unit test support for testing CodeQL libraries and queries.

### Tasks

The `.vscode/tasks.json` file defines custom tasks specific to working in this repository. To invoke one of these tasks, select the `Terminal | Run Task...` menu option, and then select the desired task from the dropdown. You can also invoke the `Tasks: Run Task` command from the command palette.
