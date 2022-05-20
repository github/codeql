lgtm,codescanning
* Expanded modeling of sensitive data sources to include: subscripting with a key that indicates sensitive data (`obj["password"]`), parameters whose names indicate sensitive data (`def func(password):`), and assignments to variables whose names indicate sensitive data (`password = ...`).
