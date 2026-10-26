lgtm,codescanning
* The 'Not enough memory allocated for pointer type' (cpp/allocation-too-small) and 'Not enough memory allocated for array of pointer type' (cpp/suspicious-allocation-size) queries have been improved. Previously some allocations would be reported by both queries, this no longer occurs. In addition more allocation functions are now understood by both queries.
