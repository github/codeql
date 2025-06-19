use std::{
    fs,
    path::{Path, PathBuf},
};

/// This represents the minimum supported path transformation that is needed to support extracting
/// overlay databases. Specifically, it represents a transformer where one path prefix is replaced
/// with a different prefix.
pub struct PathTransformer {
    pub original: String,
    pub replacement: String,
}

/// Normalizes the path according to the common CodeQL specification, and, applies the given path
/// transformer, if any. Assumes that `path` has already been canonicalized using
/// `std::fs::canonicalize`.
pub fn normalize_and_transform_path(path: &Path, transformer: Option<&PathTransformer>) -> String {
    let path = normalize_path(path);
    match transformer {
        Some(transformer) => match path.strip_prefix(&transformer.original) {
            Some(suffix) => format!("{}{}", transformer.replacement, suffix),
            None => path,
        },
        None => path,
    }
}

/**
 * Attempts to load a path transformer.
 *
 * If the `CODEQL_PATH_TRANSFORMER` environment variable is not set, no transformer has been
 * specified and the function returns `Ok(None)`.
 *
 * If the environment variable is set, the function attempts to load the transformer from the file
 * at the specified path. If this is successful, it returns `Ok(Some(PathTransformer))`.
 *
 * If the file cannot be read, or if it does not match the minimal subset of the path-transformer
 * syntax supported by this extractor, the function returns an error.
 */
pub fn load_path_transformer() -> std::io::Result<Option<PathTransformer>> {
    let path = match std::env::var("CODEQL_PATH_TRANSFORMER") {
        Ok(p) => p,
        Err(_) => return Ok(None),
    };
    let file_content = fs::read_to_string(path)?;
    let lines = file_content
        .lines()
        .map(|line| line.trim().to_owned())
        .filter(|line| !line.is_empty())
        .collect::<Vec<String>>();

    if lines.len() != 2 {
        return Err(unsupported_transformer_error());
    }
    let replacement = lines[0]
        .strip_prefix('#')
        .ok_or(unsupported_transformer_error())?;
    let original = lines[1]
        .strip_suffix("//")
        .ok_or(unsupported_transformer_error())?;

    Ok(Some(PathTransformer {
        original: original.to_owned(),
        replacement: replacement.to_owned(),
    }))
}

fn unsupported_transformer_error() -> std::io::Error {
    std::io::Error::new(
        std::io::ErrorKind::InvalidData,
        "This extractor only supports path transformers specifying a single path-prefix rewrite, \
         with the first line starting with a # and the second line ending with //.",
    )
}

/// Normalizes the path according to the common CodeQL specification. Assumes that `path` has
/// already been canonicalized using `std::fs::canonicalize`.
fn normalize_path(path: &Path) -> String {
    if cfg!(windows) {
        // The way Rust canonicalizes paths doesn't match the CodeQL spec, so we
        // have to do a bit of work removing certain prefixes and replacing
        // backslashes.
        let mut components: Vec<String> = Vec::new();
        let mut path_components = path.components().peekable();
        while let Some(component) = path_components.next() {
            match component {
                std::path::Component::Prefix(prefix) => match prefix.kind() {
                    std::path::Prefix::Disk(letter) | std::path::Prefix::VerbatimDisk(letter) => {
                        components.push(format!("{}:", letter as char));
                    }
                    std::path::Prefix::Verbatim(x) | std::path::Prefix::DeviceNS(x) => {
                        components.push(x.to_string_lossy().to_string());
                    }
                    std::path::Prefix::UNC(server, share)
                    | std::path::Prefix::VerbatimUNC(server, share) => {
                        components.push(server.to_string_lossy().to_string());
                        components.push(share.to_string_lossy().to_string());
                    }
                },
                std::path::Component::Normal(n) => {
                    components.push(n.to_string_lossy().to_string());
                }
                std::path::Component::RootDir => {
                    if path_components.peek().is_none() {
                        // The path points at a root directory, so we need to add a
                        // trailing slash, e.g. `C:/` instead of `C:`.
                        components.push("".to_string());
                    }
                }
                std::path::Component::CurDir => {}
                std::path::Component::ParentDir => {}
            }
        }
        components.join("/")
    } else {
        // For other operating systems, we can use the canonicalized path
        // without modifications.
        format!("{}", path.display())
    }
}

/// Convert a user-supplied path to an absolute path, and convert it to a verbatim path on Windows.
pub fn path_from_string(path: &str) -> PathBuf {
    let mut path = PathBuf::from(path);
    // make path absolute
    if path.is_relative() {
        path = std::env::current_dir().unwrap().join(path)
    };
    let mut components = path.components();

    // make Windows paths verbatim (with `\\?\` prefixes) which allow for extended-length paths.
    let mut result = match components.next() {
        None => unreachable!("empty path"),

        Some(component) => match component {
            std::path::Component::Prefix(prefix) => match prefix.kind() {
                std::path::Prefix::Disk(drive) => {
                    let root = format!(r"\\?\{}:\", drive as char);
                    PathBuf::from(root)
                }
                std::path::Prefix::UNC(server, share) => {
                    let mut root = std::ffi::OsString::from(r"\\?\UNC\");
                    root.push(server);
                    root.push(r"\");
                    root.push(share);
                    PathBuf::from(root)
                }
                std::path::Prefix::Verbatim(_)
                | std::path::Prefix::VerbatimUNC(_, _)
                | std::path::Prefix::VerbatimDisk(_)
                | std::path::Prefix::DeviceNS(_) => Path::new(&component).to_path_buf(),
            },
            _ => Path::new(&component).to_path_buf(),
        },
    };
    // remove `.` and `..` components
    for component in components {
        match component {
            std::path::Component::CurDir => continue,
            std::path::Component::ParentDir => {
                result.pop();
            }
            _ => result.push(component),
        }
    }
    result
}

pub fn path_for(
    dir: &Path,
    path: &Path,
    ext: &str,
    transformer: Option<&PathTransformer>,
) -> PathBuf {
    let path = if transformer.is_some() {
        let transformed = normalize_and_transform_path(path, transformer);
        PathBuf::from(transformed)
    } else {
        path.to_path_buf()
    };
    let mut result = PathBuf::from(dir);
    for component in path.components() {
        match component {
            std::path::Component::Prefix(prefix) => match prefix.kind() {
                std::path::Prefix::Disk(letter) | std::path::Prefix::VerbatimDisk(letter) => {
                    result.push(format!("{}_", letter as char))
                }
                std::path::Prefix::Verbatim(x) | std::path::Prefix::DeviceNS(x) => {
                    result.push(x);
                }
                std::path::Prefix::UNC(server, share)
                | std::path::Prefix::VerbatimUNC(server, share) => {
                    result.push("unc");
                    result.push(server);
                    result.push(share);
                }
            },
            std::path::Component::RootDir => {
                // skip
            }
            std::path::Component::Normal(_) => {
                result.push(component);
            }
            std::path::Component::CurDir => {
                // skip
            }
            std::path::Component::ParentDir => {
                result.pop();
            }
        }
    }
    if !ext.is_empty() {
        match result.extension() {
            Some(x) => {
                let mut new_ext = x.to_os_string();
                new_ext.push(".");
                new_ext.push(ext);
                result.set_extension(new_ext);
            }
            None => {
                result.set_extension(ext);
            }
        }
    }
    result
}
