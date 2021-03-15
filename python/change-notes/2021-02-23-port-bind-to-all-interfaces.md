lgtm,codescanning
* Updated _Binding a socket to all network interfaces_ (`py/bind-socket-all-network-interfaces`) query to use the new type-tracking approach instead of points-to analysis. You may see differences in the results found by the query, but overall this change should result in a more robust and accurate analysis.
* Updated _Binding a socket to all network interfaces_ (`py/bind-socket-all-network-interfaces`) to recognize binding to all interfaces in IPv6 with hostnames `::` and `::0`
