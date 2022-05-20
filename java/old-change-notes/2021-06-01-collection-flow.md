lgtm,codescanning
* Data flow now tracks steps through collections and arrays more precisely.
  That means that collection and array read steps are now matched up with
  preceding store steps. This results in increased precision for all flow-based
  queries, in particular most of the security queries.
