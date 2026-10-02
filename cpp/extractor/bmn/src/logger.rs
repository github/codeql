use crate::environment;
use std::sync::LazyLock;

#[derive(PartialEq, PartialOrd)]
pub enum Verbosity {
    Silent,
    Error,
    Warning,
    Info,
    Debug,
}

// TODO: const DEFAULT_VERBOSITY: Verbosity = Verbosity::Error;
const DEFAULT_VERBOSITY: Verbosity = Verbosity::Info;

const fn level_to_verbosity(level: Option<usize>) -> Verbosity {
    match level {
        Some(0) => Verbosity::Silent,
        Some(1) => Verbosity::Error,
        Some(2) => Verbosity::Warning,
        Some(3) => Verbosity::Info,
        Some(_) => Verbosity::Debug,
        _ => DEFAULT_VERBOSITY,
    }
}

pub struct Logger {
    pub verbosity: Verbosity,
}

impl Logger {
    const fn new(level: Option<usize>) -> Logger {
        Logger {
            verbosity: level_to_verbosity(level),
        }
    }
}

fn create_log() -> Logger {
    let level = environment::get_optional(environment::CODEQL_EXTRACTOR_CPP_VERBOSITY)
        .and_then(|s| s.parse().ok());
    Logger::new(level)
}

pub static GLOBAL_LOGGER: LazyLock<Logger> = std::sync::LazyLock::new(create_log);

macro_rules! log {
    ($level:expr, $($arg:tt)*) => {
        if $level <= crate::logger::GLOBAL_LOGGER.verbosity {
            println!($($arg)*);
        }
    }
}

#[allow(unused_macros)]
macro_rules! debug {
    ($($arg:tt)*) => {
        log!(crate::logger::Verbosity::Debug, $($arg)*);
    }
}

macro_rules! info {
    ($($arg:tt)*) => {
        log!(crate::logger::Verbosity::Info, $($arg)*);
    }
}

macro_rules! warning {
    ($($arg:tt)*) => {
        log!(crate::logger::Verbosity::Warning, $($arg)*);
    }
}

macro_rules! error {
    ($($arg:tt)*) => {
        log!(crate::logger::Verbosity::Error, $($arg)*);
    }
}

#[allow(unused_imports)]
pub(crate) use debug;
pub(crate) use error;
pub(crate) use info;
pub(crate) use log;
pub(crate) use warning;
