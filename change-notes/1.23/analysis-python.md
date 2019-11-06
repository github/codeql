# Improvements to Python analysis


## General improvements



## New queries

| **Query** | **Tags** | **Purpose** |
|-----------|----------|-------------|
| Clear-text logging of sensitive information (`py/clear-text-logging-sensitive-data`) | security, external/cwe/cwe-312 | Finds instances where sensitive information is logged without encryption or hashing. Results are shown on LGTM by default. |
| Clear-text storage of sensitive information (`py/clear-text-storage-sensitive-data`) | security, external/cwe/cwe-312 | Finds instances where sensitive information is stored without encryption or hashing. Results are shown on LGTM by default. |
| Missing rate limiting (`py/missing-rate-limiting`) | security, external/cwe/cwe-770 | An HTTP request handler that performs expensive operations without restricting the rate at which operations can be carried out is vulnerable to denial-of-service attacks. |
| Binding a socket to all network interfaces (`py/bind-socket-all-network-interfaces`) | security | Finds instances where a socket is bound to all network interfaces. Results are shown on LGTM by default. |


## Changes to existing queries

| **Query**                  | **Expected impact**    | **Change** |
|----------------------------|------------------------|------------|
| Unreachable code | Fewer false positives | Analysis now accounts for uses of `contextlib.suppress` to suppress exceptions. |
| `__iter__` method returns a non-iterator | Better alert message | Alert now highlights which class is expected to be an iterator. |


## Changes to QL libraries

* Django library now recognizes positional arguments from a `django.conf.urls.url` regex (Django version 1.x)
