lgtm,codescanning
* Added models for Apache Commons Lang's `RegExUtils` class. This means that any query that tracks tainted data may return additional results in cases where a `RegExUtils` transformation is part of the path from source to sink.
