lgtm,codescanning
* CIL extraction has been improved to store `modreq` and `modopt` custom modifiers.
The extracted information is surfaced through the `CustomModifierReceiver` class. Additionally,
the information is also used to evaluate the new `Setter::isInitOnly` predicate.