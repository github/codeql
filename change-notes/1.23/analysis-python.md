# Improvements to Python analysis


## General improvements



## New queries

| **Query** | **Tags** | **Purpose** |
|-----------|----------|-------------|
| Clear-text logging of sensitive information (`py/clear-text-logging-sensitive-data`) | security, external/cwe/cwe-312 | Finds instances where sensitive information is logged without encryption or hashing. Results are shown on LGTM by default. |
| Clear-text storage of sensitive information (`py/clear-text-storage-sensitive-data`) | security, external/cwe/cwe-312 | Finds instances where sensitive information is stored without encryption or hashing. Results are shown on LGTM by default. |
| Binding a socket to all network interfaces (`py/bind-socket-all-network-interfaces`) | security, warning, severity | Finds instances where a socket is bound to all network interfaces. Results are not shown on LGTM by default. |
