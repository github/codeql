# Vale styles for testing QL documentation

The styles stored in these subdirectories are used by the [Vale](https://github.com/errata-ai/vale) application.
This is used to test QL documentation.

The styles in the `Microsoft` directory are installed from the [Microsoft style guide](https://github.com/errata-ai/Microsoft).
The styles are used to test documentation before it's merged into Git.
They are not distributed as part of any of our products.
For the license information, see [LICENSE](https://github.com/errata-ai/Microsoft/blob/master/LICENSE).

## Upgrading the Microsoft styles

To upgrade the Microsoft styles:

1. Download the [latest release](https://github.com/errata-ai/Microsoft/releases).
1. Unzip the archive over the `vale-styles` directory.
1. We use Semmle-customized versions of a few of these rules, check whether any of the following rules have changes:
    * `Headings.yaml`
1. Update the `Semmle` version of the rule of the same name with those changes.
1. Commit your changes and test the new versions of the rules.
1. Open a pull request.