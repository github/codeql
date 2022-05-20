lgtm,codescanning
* Splitting a string by whitespace or a colon is now considered sanitizing by the `go/clear-text-logging` query, because this is frequently used to split a username and password or other secret.
