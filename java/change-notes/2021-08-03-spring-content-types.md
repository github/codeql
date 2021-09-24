lgtm,codescanning
* The XSS query now accounts for more ways to set the content-type of an entity served via a Spring HTTP endpoint. This may flag more cases where an XSS-vulnerable content-type is set, and exclude more cases where a non-vulnerable content-type such as `application/json` is set.
