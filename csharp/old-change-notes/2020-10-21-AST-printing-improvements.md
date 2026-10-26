tooling
* AST printing in Visual Studio Code has been improved. Notable changes are:
   * Duplications of namespace declarations have been removed.
   * `TypeMention` nodes have been added to the tree.
   * Child nodes of assignments and casts have been rearranged to represent syntax order
   instead of execution order.
* Various fixes have been applied for `TypeMention` extraction.