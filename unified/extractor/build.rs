fn main() {
    println!("cargo:rustc-check-cfg=cfg(bazel)");

    if let Ok(dir) = std::env::var("DEP_SWIFTSYNTAXFFI_LIBDIR") {
        println!("cargo:rustc-link-search=native={dir}");
        println!("cargo:rustc-link-lib=dylib=SwiftSyntaxFFI");
        println!("cargo:rustc-link-arg=-Wl,-rpath,{dir}");
    }
    if let Ok(dir) = std::env::var("DEP_SWIFTSYNTAXFFI_RUNTIMEDIR") {
        println!("cargo:rustc-link-arg=-Wl,-rpath,{dir}");
    }
}
