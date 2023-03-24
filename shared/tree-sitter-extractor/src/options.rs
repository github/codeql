use num_cpus;

/// Gets the number of threads the extractor should use.
/// This is controlled by the CODEQL_THREADS environment variable.
pub fn num_threads() -> Result<usize, String> {
    let threads_str = std::env::var("CODEQL_THREADS").unwrap_or_else(|_| "-1".into());
    let num_cpus = num_cpus::get();
    parse_codeql_threads(&threads_str, num_cpus)
        .ok_or_else(|| format!("Unable to parse CODEQL_THREADS value '{}'", &threads_str))
}

/// Parses the given string to determine the number of threads the extractor
/// should use, as described in the extractor spec:
///
/// "If the number is positive, it indicates the number of threads that should
/// be used. If the number is negative or zero, it should be added to the number
/// of cores available on the machine to determine how many threads to use
/// (minimum of 1). If unspecified, should be considered as set to -1."
///
/// # Examples
///
/// ```
/// use codeql_extractor::options::parse_codeql_threads;
///
/// assert_eq!(parse_codeql_threads("1", 4), Some(1));
/// assert_eq!(parse_codeql_threads("5", 4), Some(5));
/// assert_eq!(parse_codeql_threads("0", 4), Some(4));
/// assert_eq!(parse_codeql_threads("-1", 4), Some(3));
/// assert_eq!(parse_codeql_threads("-3", 4), Some(1));
/// assert_eq!(parse_codeql_threads("-4", 4), Some(1));
/// assert_eq!(parse_codeql_threads("-5", 4), Some(1));
/// assert_eq!(parse_codeql_threads("nope", 4), None);
/// ```
pub fn parse_codeql_threads(threads_str: &str, num_cpus: usize) -> Option<usize> {
    match threads_str.parse::<i32>() {
        Ok(num) if num <= 0 => {
            let reduction = num.abs_diff(0) as usize;
            Some(std::cmp::max(1, num_cpus.saturating_sub(reduction)))
        }
        Ok(num) => Some(num as usize),

        Err(_) => None,
    }
}
