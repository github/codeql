use std::env;
use std::path::PathBuf;
use std::process::Command;

fn main() {
    let manifest_dir = PathBuf::from(env::var("CARGO_MANIFEST_DIR").unwrap());
    let swift_dir = manifest_dir.join("swift");

    println!(
        "cargo:rerun-if-changed={}",
        swift_dir.join("Package.swift").display()
    );
    println!(
        "cargo:rerun-if-changed={}",
        swift_dir
            .join("Sources/SwiftSyntaxFFI/SwiftSyntaxFFI.swift")
            .display()
    );
    println!("cargo:rerun-if-env-changed=SWIFT");
    println!("cargo:rerun-if-env-changed=SWIFTC");

    // Build the Swift FFI package as a release dynamic library.
    let mut command = Command::new(swift_bin());
    command
        .args(["build", "-c", "release"])
        .current_dir(&swift_dir);
    apply_bare_repository_workaround(&mut command);
    let status = command.status().unwrap_or_else(|e| {
        panic!(
            "failed to run `{swift} build`: {e}\n\
             Install a Swift toolchain (see https://www.swift.org/install/, e.g. via \
             swiftly) and ensure `swift` is on PATH, or set the `SWIFT` environment \
             variable to the `swift` executable. The pinned version is in `.swift-version`.",
            swift = swift_bin(),
        )
    });
    assert!(status.success(), "`swift build` failed");

    // Link against the freshly built dynamic library.
    let build_dir = swift_dir.join(".build/release");
    println!("cargo:rustc-link-search=native={}", build_dir.display());
    println!("cargo:rustc-link-lib=dylib=SwiftSyntaxFFI");
    println!("cargo:rustc-link-arg=-Wl,-rpath,{}", build_dir.display());

    // The executable also needs to find the Swift runtime libraries at run time.
    if let Some(runtime) = swift_runtime_dir() {
        println!("cargo:rustc-link-search=native={}", runtime.display());
        println!("cargo:rustc-link-arg=-Wl,-rpath,{}", runtime.display());
    }
}

/// Directory containing the active Swift toolchain's runtime libraries
/// (e.g. `libswiftCore.so`).
fn swift_runtime_dir() -> Option<PathBuf> {
    let output = Command::new(swiftc_bin())
        .arg("-print-target-info")
        .output()
        .ok()?;
    if !output.status.success() {
        return None;
    }
    let info = String::from_utf8_lossy(&output.stdout);

    // Extract `"runtimeResourcePath": "..."` without pulling in a JSON dep.
    let key = "\"runtimeResourcePath\"";
    let start = info.find(key)?;
    let rest = &info[start + key.len()..];
    let colon = rest.find(':')?;
    let after = &rest[colon + 1..];
    let open = after.find('"')?;
    let value_start = &after[open + 1..];
    let close = value_start.find('"')?;
    let resource_path = &value_start[..close];

    Some(PathBuf::from(resource_path).join(if cfg!(target_os = "macos") { "macosx" } else { "linux" }))
}

/// `swift` driver: `$SWIFT` if set, else `swift` from `PATH`.
fn swift_bin() -> String {
    env::var("SWIFT").unwrap_or_else(|_| "swift".to_string())
}

/// `swiftc` compiler: `$SWIFTC` if set, else `swiftc` from `PATH`.
fn swiftc_bin() -> String {
    env::var("SWIFTC").unwrap_or_else(|_| "swiftc".to_string())
}

/// Workaround for GitHub Codespaces, which sets
/// `GIT_CONFIG_KEY_0=safe.bareRepository` / `GIT_CONFIG_VALUE_0=explicit` and
/// breaks the cached bare git repos `swift build` uses. Relax to `all` only
/// for this subprocess, and only when that exact key is set.
fn apply_bare_repository_workaround(command: &mut Command) {
    if env::var("GIT_CONFIG_KEY_0").as_deref() == Ok("safe.bareRepository") {
        command.env("GIT_CONFIG_VALUE_0", "all");
    }
}
