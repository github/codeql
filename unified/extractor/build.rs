fn main() {
    println!("cargo:rustc-check-cfg=cfg(bazel)");
}
