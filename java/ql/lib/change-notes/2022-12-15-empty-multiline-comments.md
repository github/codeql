---
category: fix
---
* We now correctly handle empty block comments, like `/**/`. Previously these could be mistaken for Javadoc comments and led to attribution of Javadoc tags to the wrong declaration.
