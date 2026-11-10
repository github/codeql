fn main() {
    let out_dir = std::env::var("OUT_DIR").unwrap();
    std::fs::write(
        std::path::Path::new(&out_dir).join("generated.rs"),
        "pub fn from_build_script() -> u32 { 42 }\n",
    )
    .unwrap();
    println!("cargo:rerun-if-changed=build.rs");
}
