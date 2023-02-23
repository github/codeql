let not_sensitive_data = { a: 1, b : 2} 
// GOOD: it is fine to log data that is not sensitive
console.info(`[INFO] Some object contains: ${not_sensitive_data}`);