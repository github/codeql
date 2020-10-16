import javascript

// Check which flow labels are materialized by importing `javascript.qll`.
// If this increases, it may indicate a performance issue.
select any(DataFlow::FlowLabel label)
