use super::project_definitions::Language;
use crate::logger::{log, warning};
use crate::telemetry::{Severity, Telemetry, TelemetryMessage};
use anyhow::{Result, anyhow};
use os_str_bytes::OsStrBytes;
use regex::bytes::Regex;
use std::ffi::OsStr;
use std::path::PathBuf;
use std::process::{Command, Stdio};

/// Searches for a regex in the output bytes and returns the first captured group as bytes.
fn search_regex_in_output<'h>(bytes: &'h [u8], regex: &Regex) -> Option<&'h [u8]> {
    regex
        .captures(bytes)
        .and_then(|caps| caps.get(1))
        .map(|m| m.as_bytes())
}

/// Splits the captured lines containing the default compiler include paths into a vector path
/// slices ready to be converted to `PathBuf`.
fn split_lines(captured_lines: &[u8]) -> Vec<&[u8]> {
    fn trim_line(line: &[u8]) -> &[u8] {
        let trimmed = line.strip_prefix(b" ").unwrap_or(line);
        if let Some(trimmed) = trimmed.strip_suffix(b" (framework directory)") {
            trimmed
        } else if let Some(trimmed) = trimmed.strip_suffix(b" (headermap)") {
            trimmed
        } else {
            trimmed
        }
    }
    captured_lines
        .split(|b| *b == b'\n')
        .map(|l| l.strip_suffix(b"\r").unwrap_or(l))
        .map(trim_line)
        .collect()
}

/// Converts the captured lines into a vector of `PathBuf`, filtering out empty lines
fn build_paths(captured_lines: &[&[u8]]) -> Result<Vec<PathBuf>> {
    let mut result: Vec<PathBuf> = Vec::new();
    for line in captured_lines {
        if line.is_empty() {
            continue; // Skip empty lines
        }
        if let Some(path) = OsStr::from_io_bytes(line) {
            result.push(PathBuf::from(path));
        } else {
            return Err(anyhow!(
                "Failed to convert compiler output line to PathBuf: {line:?}"
            ));
        }
    }
    Ok(result)
}

/// Matches the regex in the compiler output and returns the results as a vector of byte slices.
/// If the regex does not match, it returns an error with the specific message.
fn match_regex_get_results<'a>(
    regex: &Regex,
    text: &'a [u8],
    include_type: &str,
) -> Result<Vec<&'a [u8]>> {
    search_regex_in_output(text, regex)
        .map(split_lines)
        .ok_or_else(|| {
            anyhow!(
            "GNU default include folder finder could not parse the {include_type} compiler output."
        )
        })
}

/// Parses the compiler output to extract local and global include paths.
fn parse_compiler_output(output: &[u8]) -> Result<(Vec<PathBuf>, Vec<PathBuf>)> {
    let local_include_regex =
        Regex::new(r#"(?m)^#include "..." search starts here:\r?\n(( [^\n\r]*\r?\n)*)#include"#)
            .expect("Bad regex");
    let local_include_paths = match_regex_get_results(&local_include_regex, output, "local")?;

    let global_include_regex = Regex::new(
        r"(?m)^#include <...> search starts here:\r?\n(( [^\n\r]*\r?\n)*)End of search list.",
    )
    .expect("Bad regex");
    let global_include_paths = match_regex_get_results(&global_include_regex, output, "global")?;

    Ok((
        build_paths(&local_include_paths)?,
        build_paths(&global_include_paths)?,
    ))
}

/// Executes a command with arguments and returns the standard error output if the command was
/// successful.
fn execute_command_with_args_get_stderr(cmd: &OsStr, args: &[&str]) -> Result<Vec<u8>> {
    match Command::new(cmd).args(args).stdin(Stdio::piped()).output() {
        Ok(output) if output.status.success() => Ok(output.stderr),
        _ => Err(anyhow!(
            "Error invoking the compiler {cmd:?} to get the default include folders."
        )),
    }
}

/// Gets the default include paths for a given compiler.
fn get_default_include_for_compiler(compiler: &OsStr, lang: Language) -> Result<Vec<PathBuf>> {
    let args = vec!["-x", lang.gnu_language_descriptor(), "-v", "-E", "-"];

    execute_command_with_args_get_stderr(compiler, &args)
        .and_then(|output| parse_compiler_output(&output))
        .map(|(local, global)| {
            let mut result = Vec::new();
            result.extend(local);
            result.extend(global);
            result
        })
}

pub fn get_default_include_for_compiler_or_warn(
    telemetry: &Telemetry,
    compiler: &OsStr,
    lang: Language,
) -> Vec<PathBuf> {
    get_default_include_for_compiler(compiler, lang).unwrap_or_else(|e| {
        let message = format!(
            "Failed to get default include path for compiler {} and language {lang:?}: {e}",
            compiler.display()
        );
        warning!("{message}");
        telemetry.write_message(
            TelemetryMessage::new(
                Severity::Warning,
                "cpp/bmn/default-compiler-include-path-failure",
                message,
            )
            .attributes(serde_json::json!({ "compiler": compiler, "error": e.to_string()})),
        );
        Vec::new()
    })
}

#[cfg(test)]
mod tests {
    use super::*;
    use all_asserts::assert_true;

    // search_regex_in_output is tested by testing other functions that use it.

    #[test]
    fn test_split_lines_simple_value() {
        let text = "/usr/include";
        let ext = split_lines(text.as_bytes());
        assert_eq!(ext, [text.as_bytes()]);
    }

    #[test]
    fn test_split_lines_multiple_values() {
        let values = [
            "/usr/include",
            "/usr/local/include",
            "/usr/include/x86_64-linux-gnu",
        ];

        let text = format!("{}\n{}\n{}", values[0], values[1], values[2]);
        assert_eq!(split_lines(text.as_bytes()), values.map(str::as_bytes));
    }

    #[test]
    fn test_split_lines_multiple_values_with_empty_lines_and_spaces() {
        let values = [
            "/usr/include  ",
            "/usr/local/include ",
            "/usr/include/x86_64-linux-gnu",
        ];
        let text = format!("{}\n {}\n {}", values[0], values[1], values[2]);
        assert_eq!(split_lines(text.as_bytes()), values.map(str::as_bytes));
    }

    #[test]
    fn test_split_lines_multiple_values_with_empty_lines_spaces_and_spaces_in_paths() {
        let values = [
            "/usr /include  ",
            "/usr/local /include ",
            "/us r/include/x86_64 linux-gnu",
        ];
        let text = format!("{}\n {}\n {}", values[0], values[1], values[2]);
        assert_eq!(split_lines(text.as_bytes()), values.map(str::as_bytes));
    }

    #[test]
    fn test_split_lines_removes_trailing_values() {
        let text = " /Applications/Xcode.app/omitted/Frameworks (framework directory)";
        assert_eq!(
            split_lines(text.as_bytes()),
            ["/Applications/Xcode.app/omitted/Frameworks".as_bytes()]
        );
    }

    #[test]
    fn test_build_paths_works() {
        let value = "/usr/include";

        let expected = [PathBuf::from(value)].to_vec();
        let actual = build_paths(&[value.as_bytes(), "".as_bytes()]);
        assert_true!(actual.is_ok());
        assert_eq!(actual.unwrap(), expected);
    }

    #[test]
    fn test_parse_compiler_fails_with_bad_local_folders() {
        let result = parse_compiler_output("qwertyuiop".as_bytes());

        assert_true!(result.is_err());
        assert_eq!(
            result.unwrap_err().to_string(),
            "GNU default include folder finder could not parse the local compiler output."
        );
    }

    #[test]
    fn test_parse_compiler_fails_with_bad_global_folders() {
        let text = r#"
#include "..." search starts here:
#include <...> search starts here:"#;
        let result = parse_compiler_output(text.as_bytes());

        assert_true!(result.is_err());
        assert_eq!(
            result.unwrap_err().to_string(),
            "GNU default include folder finder could not parse the global compiler output."
        );
    }

    #[test]
    fn test_parse_compiler_includes_single_global_content() {
        let text = r#"
#include "..." search starts here:
#include <...> search starts here:
 /usr/lib/llvm-18/lib/clang/18/include
 /usr/local/include
 /usr/include/x86_64-linux-gnu
 /usr/include
End of search list."#;

        let result = parse_compiler_output(text.as_bytes());
        assert_true!(result.is_ok());
        assert_eq!(
            result.expect("uh"),
            (
                Vec::new(),
                vec![
                    PathBuf::from("/usr/lib/llvm-18/lib/clang/18/include"),
                    PathBuf::from("/usr/local/include"),
                    PathBuf::from("/usr/include/x86_64-linux-gnu"),
                    PathBuf::from("/usr/include")
                ]
            )
        );
    }

    #[test]
    fn test_parse_compiler_includes_single_local_content() {
        let text = r#"
#include "..." search starts here:
 /usr/lib/llvm-18/lib/clang/18/include
 /usr/local/include
 /usr/include/x86_64-linux-gnu
 /usr/include
#include <...> search starts here:
End of search list."#;
        let result = parse_compiler_output(text.as_bytes());
        assert_true!(result.is_ok());
        assert_eq!(
            result.expect("uh"),
            (
                vec![
                    PathBuf::from("/usr/lib/llvm-18/lib/clang/18/include"),
                    PathBuf::from("/usr/local/include"),
                    PathBuf::from("/usr/include/x86_64-linux-gnu"),
                    PathBuf::from("/usr/include")
                ],
                Vec::new()
            )
        );
    }
    #[test]
    fn test_parse_compiler_includes_both_content() {
        let text = r#"
#include "..." search starts here:
 /usr/lib/llvm-18/lib/clang/18/include
 /usr/local/include
 /usr/include/x86_64-linux-gnu
 /usr/include
#include <...> search starts here:
 /usr/lib/llvm-18/lib/clang/18/include
 /usr/local/include
 /usr/include/x86_64-linux-gnu
 /usr/include
End of search list."#;
        let result = parse_compiler_output(text.as_bytes());
        assert_true!(result.is_ok());
        assert_eq!(
            result.expect("uh"),
            (
                vec![
                    PathBuf::from("/usr/lib/llvm-18/lib/clang/18/include"),
                    PathBuf::from("/usr/local/include"),
                    PathBuf::from("/usr/include/x86_64-linux-gnu"),
                    PathBuf::from("/usr/include")
                ],
                vec![
                    PathBuf::from("/usr/lib/llvm-18/lib/clang/18/include"),
                    PathBuf::from("/usr/local/include"),
                    PathBuf::from("/usr/include/x86_64-linux-gnu"),
                    PathBuf::from("/usr/include")
                ]
            )
        );
    }

    #[test]
    fn test_parse_compiler_includes_multiple_local_empty_content() {
        let text = r#"
#include "..." search starts here:
#include <...> search starts here:
 /usr/lib/llvm-18/lib/clang/18/include
 /usr/local/include
 /usr/include/x86_64-linux-gnu
 /usr/include
End of search list."#;

        let result = parse_compiler_output(text.as_bytes());
        assert_true!(result.is_ok());
        assert_eq!(
            result.expect("uh"),
            (
                Vec::new(),
                vec![
                    PathBuf::from("/usr/lib/llvm-18/lib/clang/18/include"),
                    PathBuf::from("/usr/local/include"),
                    PathBuf::from("/usr/include/x86_64-linux-gnu"),
                    PathBuf::from("/usr/include")
                ]
            )
        );
    }

    #[test]
    fn test_parse_compiler_includes_multiple_global_empty_content() {
        let text = r#"
#include "..." search starts here:
 /usr/lib/llvm-18/lib/clang/18/include
 /usr/local/include
 /usr/include/x86_64-linux-gnu
 /usr/include
#include <...> search starts here:
End of search list."#;

        let result = parse_compiler_output(text.as_bytes());
        assert_true!(result.is_ok());
        assert_eq!(
            result.expect("uh"),
            (
                vec![
                    PathBuf::from("/usr/lib/llvm-18/lib/clang/18/include"),
                    PathBuf::from("/usr/local/include"),
                    PathBuf::from("/usr/include/x86_64-linux-gnu"),
                    PathBuf::from("/usr/include")
                ],
                Vec::new()
            )
        );
    }

    #[test]
    fn test_parse_compiler_includes_real_clang_output() {
        let text = r#"
Ubuntu clang version 18.1.3 (1ubuntu1)
Target: x86_64-pc-linux-gnu
Thread model: posix
InstalledDir: /usr/bin
Found candidate GCC installation: /usr/bin/../lib/gcc/x86_64-linux-gnu/13
Selected GCC installation: /usr/bin/../lib/gcc/x86_64-linux-gnu/13
Candidate multilib: .;@m64
Selected multilib: .;@m64
 (in-process)
 "/usr/lib/llvm-18/bin/clang" -cc1 -triple x86_64-pc-linux-gnu -fsyntax-only -disable-free -clear-ast-before-backend -disable-llvm-verifier -discard-value-names -main-file-name zero -mrelocation-model pic -pic-level 2 -pic-is-pie -mframe-pointer=all -fmath-errno -ffp-contract=on -fno-rounding-math -mconstructor-aliases -funwind-tables=2 -target-cpu x86-64 -tune-cpu generic -debugger-tuning=gdb -fdebug-compilation-dir=/tmp -v -fcoverage-compilation-dir=/tmp -resource-dir /usr/lib/llvm-18/lib/clang/18 -internal-isystem /usr/lib/llvm-18/lib/clang/18/include -internal-isystem /usr/local/include -internal-isystem /usr/bin/../lib/gcc/x86_64-linux-gnu/13/../../../../x86_64-linux-gnu/include -internal-externc-isystem /usr/include/x86_64-linux-gnu -internal-externc-isystem /include -internal-externc-isystem /usr/include -ferror-limit 19 -fgnuc-version=4.2.1 -fskip-odr-check-in-gmf -fcolor-diagnostics -faddrsig -D__GCC_HAVE_DWARF2_CFI_ASM=1 -x c /dev/zero
clang -cc1 version 18.1.3 based upon LLVM 18.1.3 default target x86_64-pc-linux-gnu
ignoring nonexistent directory "/usr/bin/../lib/gcc/x86_64-linux-gnu/13/../../../../x86_64-linux-gnu/include"
ignoring nonexistent directory "/include"
#include "..." search starts here:
#include <...> search starts here:
 /usr/lib/llvm-18/lib/clang/18/include
 /usr/local/include
 /usr/include/x86_64-linux-gnu
 /usr/include
End of search list.
"#;

        let result = parse_compiler_output(text.as_bytes());
        assert_true!(result.is_ok());
        assert_eq!(
            result.expect("uh"),
            (
                Vec::new(),
                vec![
                    PathBuf::from("/usr/lib/llvm-18/lib/clang/18/include"),
                    PathBuf::from("/usr/local/include"),
                    PathBuf::from("/usr/include/x86_64-linux-gnu"),
                    PathBuf::from("/usr/include")
                ]
            )
        );
    }

    #[test]
    fn test_parse_compiler_includes_real_gcc_output() {
        let text = r#"
Using built-in specs.
COLLECT_GCC=g++
COLLECT_LTO_WRAPPER=/usr/libexec/gcc/x86_64-linux-gnu/13/lto-wrapper
OFFLOAD_TARGET_NAMES=nvptx-none:amdgcn-amdhsa
OFFLOAD_TARGET_DEFAULT=1
Target: x86_64-linux-gnu
Configured with: ../src/configure -v --with-pkgversion='Ubuntu 13.3.0-6ubuntu2~24.04' --with-bugurl=file:///usr/share/doc/gcc-13/README.Bugs --enable-languages=c,ada,c++,go,d,fortran,objc,obj-c++,m2 --prefix=/usr --with-gcc-major-version-only --program-suffix=-13 --program-prefix=x86_64-linux-gnu- --enable-shared --enable-linker-build-id --libexecdir=/usr/libexec --without-included-gettext --enable-threads=posix --libdir=/usr/lib --enable-nls --enable-bootstrap --enable-clocale=gnu --enable-libstdcxx-debug --enable-libstdcxx-time=yes --with-default-libstdcxx-abi=new --enable-libstdcxx-backtrace --enable-gnu-unique-object --disable-vtable-verify --enable-plugin --enable-default-pie --with-system-zlib --enable-libphobos-checking=release --with-target-system-zlib=auto --enable-objc-gc=auto --enable-multiarch --disable-werror --enable-cet --with-arch-32=i686 --with-abi=m64 --with-multilib-list=m32,m64,mx32 --enable-multilib --with-tune=generic --enable-offload-targets=nvptx-none=/build/gcc-13-fG75Ri/gcc-13-13.3.0/debian/tmp-nvptx/usr,amdgcn-amdhsa=/build/gcc-13-fG75Ri/gcc-13-13.3.0/debian/tmp-gcn/usr --enable-offload-defaulted --without-cuda-driver --enable-checking=release --build=x86_64-linux-gnu --host=x86_64-linux-gnu --target=x86_64-linux-gnu --with-build-config=bootstrap-lto-lean --enable-link-serialization=2
Thread model: posix
Supported LTO compression algorithms: zlib zstd
gcc version 13.3.0 (Ubuntu 13.3.0-6ubuntu2~24.04)
COLLECT_GCC_OPTIONS='-v' '-fsyntax-only' '-o' '/dev/null' '-shared-libgcc' '-mtune=generic' '-march=x86-64' '-dumpdir' 'a-'
 /usr/libexec/gcc/x86_64-linux-gnu/13/cc1 -quiet -v -imultiarch x86_64-linux-gnu /dev/zero -quiet -dumpdir a- -dumpbase zero -mtune=generic -march=x86-64 -version -fsyntax-only -o /dev/null -fasynchronous-unwind-tables -fstack-protector-strong -Wformat -Wformat-security -fstack-clash-protection -fcf-protection
GNU C17 (Ubuntu 13.3.0-6ubuntu2~24.04) version 13.3.0 (x86_64-linux-gnu)
    compiled by GNU C version 13.3.0, GMP version 6.3.0, MPFR version 4.2.1, MPC version 1.3.1, isl version isl-0.26-GMP

GGC heuristics: --param ggc-min-expand=100 --param ggc-min-heapsize=131072
ignoring nonexistent directory "/usr/local/include/x86_64-linux-gnu"
ignoring nonexistent directory "/usr/lib/gcc/x86_64-linux-gnu/13/include-fixed/x86_64-linux-gnu"
ignoring nonexistent directory "/usr/lib/gcc/x86_64-linux-gnu/13/include-fixed"
ignoring nonexistent directory "/usr/lib/gcc/x86_64-linux-gnu/13/../../../../x86_64-linux-gnu/include"
#include "..." search starts here:
#include <...> search starts here:
 /usr/lib/gcc/x86_64-linux-gnu/13/include
 /usr/local/include
 /usr/include/x86_64-linux-gnu
 /usr/include
End of search list.
        "#;
        let result = parse_compiler_output(text.as_bytes());
        assert_true!(result.is_ok());
        assert_eq!(
            result.expect("uh"),
            (
                Vec::new(),
                vec![
                    PathBuf::from("/usr/lib/gcc/x86_64-linux-gnu/13/include"),
                    PathBuf::from("/usr/local/include"),
                    PathBuf::from("/usr/include/x86_64-linux-gnu"),
                    PathBuf::from("/usr/include")
                ]
            )
        );
    }

    #[test]
    fn test_parse_compiler_includes_real_macos_output() {
        let text = r#"
Apple clang version 16.0.0 (clang-1600.0.26.6)
Target: arm64-apple-darwin24.3.0
Thread model: posix
InstalledDir: /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin
ignoring nonexistent directory "/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/../include/c++/v1"
 "/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/clang" -cc1 -triple arm64-apple-macosx15.0.0 -Wundef-prefix=TARGET_OS_ -Wdeprecated-objc-isa-usage -Werror=deprecated-objc-isa-usage -Werror=implicit-function-declaration -fsyntax-only -disable-free -clear-ast-before-backend -disable-llvm-verifier -discard-value-names -main-file-name zero -mrelocation-model pic -pic-level 2 -mframe-pointer=non-leaf -fno-strict-return -ffp-contract=on -fno-rounding-math -funwind-tables=1 -fobjc-msgsend-selector-stubs -target-sdk-version=15.2 -fvisibility-inlines-hidden-static-local-var -fno-modulemap-allow-subdirectory-search -target-cpu apple-m1 -target-feature +v8.5a -target-feature +aes -target-feature +crc -target-feature +dotprod -target-feature +fp-armv8 -target-feature +fp16fml -target-feature +lse -target-feature +ras -target-feature +rcpc -target-feature +rdm -target-feature +sha2 -target-feature +sha3 -target-feature +neon -target-feature +zcm -target-feature +zcz -target-feature +fullfp16 -target-abi darwinpcs -debugger-tuning=lldb -target-linker-version 1115.7.3 -v -H -sys-header-deps -fcoverage-compilation-dir=/Users/esteffin/Desktop/JunkScratch/deptrace-stuff/missing-includes -resource-dir /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib/clang/16 -isysroot /Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX.sdk -I/usr/local/include -internal-isystem /Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX.sdk/usr/include/c++/v1 -internal-isystem /Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX.sdk/usr/local/include -internal-isystem /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib/clang/16/include -internal-externc-isystem /Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX.sdk/usr/include -internal-externc-isystem /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/include -Wno-reorder-init-list -Wno-implicit-int-float-conversion -Wno-c99-designator -Wno-final-dtor-non-final-class -Wno-extra-semi-stmt -Wno-misleading-indentation -Wno-quoted-include-in-framework-header -Wno-implicit-fallthrough -Wno-enum-enum-conversion -Wno-enum-float-conversion -Wno-elaborated-enum-base -Wno-reserved-identifier -Wno-gnu-folding-constant -fdeprecated-macro -fdebug-compilation-dir=/Users/esteffin/Desktop/JunkScratch/deptrace-stuff/missing-includes -ferror-limit 19 -stack-protector 1 -fstack-check -mdarwin-stkchk-strong-link -fblocks -fencode-extended-block-signature -fregister-global-dtors-with-atexit -fgnuc-version=4.2.1 -fno-cxx-modules -fcxx-exceptions -fexceptions -fmax-type-align=16 -fcommon -fcolor-diagnostics -clang-vendor-feature=+disableNonDependentMemberExprInCurrentInstantiation -fno-odr-hash-protocols -clang-vendor-feature=+enableAggressiveVLAFolding -clang-vendor-feature=+revert09abecef7bbf -clang-vendor-feature=+thisNoAlignAttr -clang-vendor-feature=+thisNoNullAttr -clang-vendor-feature=+disableAtImportPrivateFrameworkInImplementationError -D__GCC_HAVE_DWARF2_CFI_ASM=1 -x c++ /dev/zero
clang -cc1 version 16.0.0 (clang-1600.0.26.6) default target arm64-apple-darwin24.3.0
ignoring nonexistent directory "/usr/local/include"
ignoring nonexistent directory "/Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX.sdk/usr/local/include"
ignoring nonexistent directory "/Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX.sdk/Library/Frameworks"
#include "..." search starts here:
#include <...> search starts here:
 /Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX.sdk/usr/include/c++/v1
 /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib/clang/16/include
 /Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX.sdk/usr/include
 /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/include
 /Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX.sdk/System/Library/Frameworks (framework directory)
End of search list."#;

        let result = parse_compiler_output(text.as_bytes());
        assert_true!(result.is_ok());
        assert_eq!(
            result.expect("uh"),
            (
                Vec::new(),
                vec![
                    PathBuf::from(
                        "/Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX.sdk/usr/include/c++/v1"
                    ),
                    PathBuf::from(
                        "/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib/clang/16/include"
                    ),
                    PathBuf::from(
                        "/Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX.sdk/usr/include"
                    ),
                    PathBuf::from(
                        "/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/include"
                    ),
                    PathBuf::from(
                        "/Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX.sdk/System/Library/Frameworks"
                    )
                ]
            )
        );
    }

    #[test]
    fn test_parse_compiler_includes_with_windows_line_ending() {
        let text = "clang version 20.1.7\r\nTarget: x86_64-pc-windows-msvc\r\nThread model: posix\r\nInstalledDir: C:\\Program Files\\LLVM\\bin\r\n (in-process)\r\n \"C:\\Program Files\\LLVM\\bin\\clang++.exe\" -cc1 -triple x86_64-pc-windows-msvc19.44.35213 -E -disable-free -clear-ast-before-backend -disable-llvm-verifier -discard-value-names -main-file-name - -mrelocation-model pic -pic-level 2 -mframe-pointer=none -relaxed-aliasing -fmath-errno -ffp-contract=on -fno-rounding-math -mconstructor-aliases -fms-volatile -funwind-tables=2 -target-cpu x86-64 -tune-cpu generic \"-fdebug-compilation-dir=D:\\a\\igfoo-test\\igfoo-test\" -v \"-fcoverage-compilation-dir=D:\\a\\igfoo-test\\igfoo-test\" -resource-dir \"C:\\Program Files\\LLVM\\lib\\clang\\20\" -internal-isystem \"C:\\Program Files\\LLVM\\lib\\clang\\20\\include\" -internal-isystem \"C:\\Program Files\\Microsoft Visual Studio\\2022\\Enterprise\\VC\\Tools\\MSVC\\14.44.35207\\include\" -internal-isystem \"C:\\Program Files\\Microsoft Visual Studio\\2022\\Enterprise\\VC\\Tools\\MSVC\\14.44.35207\\atlmfc\\include\" -internal-isystem \"C:\\Program Files (x86)\\Windows Kits\\10\\Include\\10.0.26100.0\\ucrt\" -internal-isystem \"C:\\Program Files (x86)\\Windows Kits\\10\\Include\\10.0.26100.0\\shared\" -internal-isystem \"C:\\Program Files (x86)\\Windows Kits\\10\\Include\\10.0.26100.0\\um\" -internal-isystem \"C:\\Program Files (x86)\\Windows Kits\\10\\Include\\10.0.26100.0\\winrt\" -internal-isystem \"C:\\Program Files (x86)\\Windows Kits\\10\\Include\\10.0.26100.0\\cppwinrt\" -fdeprecated-macro -ferror-limit 19 -fno-use-cxa-atexit -fms-extensions -fms-compatibility -fms-compatibility-version=19.44.35213 -std=c++14 -fskip-odr-check-in-gmf -fdelayed-template-parsing -fcxx-exceptions -fexceptions -faddrsig -o - -x c++ -\r\nclang -cc1 version 20.1.7 based upon LLVM 20.1.7 default target x86_64-pc-windows-msvc\r\n#include \"...\" search starts here:\r\n C:\\Program Files (x86)\\Windows Kits\\10\\Include\\10.0.26100.0\\ucrt\r\n C:\\Program Files (x86)\\Windows Kits\\10\\Include\\10.0.26100.0\\shared\r\n#include <...> search starts here:\r\n C:\\Program Files (x86)\\Windows Kits\\10\\Include\\10.0.26100.0\\ucrt\r\n C:\\Program Files (x86)\\Windows Kits\\10\\Include\\10.0.26100.0\\shared\r\nEnd of search list.\r\n";
        let result = parse_compiler_output(text.as_bytes());
        assert_true!(result.is_ok());
        assert_eq!(
            result.expect("uh"),
            (
                vec![
                    PathBuf::from(
                        r"C:\Program Files (x86)\Windows Kits\10\Include\10.0.26100.0\ucrt"
                    ),
                    PathBuf::from(
                        r"C:\Program Files (x86)\Windows Kits\10\Include\10.0.26100.0\shared"
                    )
                ],
                vec![
                    PathBuf::from(
                        r"C:\Program Files (x86)\Windows Kits\10\Include\10.0.26100.0\ucrt"
                    ),
                    PathBuf::from(
                        r"C:\Program Files (x86)\Windows Kits\10\Include\10.0.26100.0\shared"
                    ),
                ]
            )
        );
    }

    #[test]
    fn test_parse_compiler_includes_real_windows_clang() {
        let text = r#"
clang version 20.1.7
Target: x86_64-pc-windows-msvc
Thread model: posix
InstalledDir: C:\Program Files\LLVM\bin
 (in-process)
 "C:\\Program Files\\LLVM\\bin\\clang++.exe" -cc1 -triple x86_64-pc-windows-msvc19.44.35213 -E -disable-free -clear-ast-before-backend -disable-llvm-verifier -discard-value-names -main-file-name - -mrelocation-model pic -pic-level 2 -mframe-pointer=none -relaxed-aliasing -fmath-errno -ffp-contract=on -fno-rounding-math -mconstructor-aliases -fms-volatile -funwind-tables=2 -target-cpu x86-64 -tune-cpu generic "-fdebug-compilation-dir=D:\\a\\igfoo-test\\igfoo-test" -v "-fcoverage-compilation-dir=D:\\a\\igfoo-test\\igfoo-test" -resource-dir "C:\\Program Files\\LLVM\\lib\\clang\\20" -internal-isystem "C:\\Program Files\\LLVM\\lib\\clang\\20\\include" -internal-isystem "C:\\Program Files\\Microsoft Visual Studio\\2022\\Enterprise\\VC\\Tools\\MSVC\\14.44.35207\\include" -internal-isystem "C:\\Program Files\\Microsoft Visual Studio\\2022\\Enterprise\\VC\\Tools\\MSVC\\14.44.35207\\atlmfc\\include" -internal-isystem "C:\\Program Files (x86)\\Windows Kits\\10\\Include\\10.0.26100.0\\ucrt" -internal-isystem "C:\\Program Files (x86)\\Windows Kits\\10\\Include\\10.0.26100.0\\shared" -internal-isystem "C:\\Program Files (x86)\\Windows Kits\\10\\Include\\10.0.26100.0\\um" -internal-isystem "C:\\Program Files (x86)\\Windows Kits\\10\\Include\\10.0.26100.0\\winrt" -internal-isystem "C:\\Program Files (x86)\\Windows Kits\\10\\Include\\10.0.26100.0\\cppwinrt" -fdeprecated-macro -ferror-limit 19 -fno-use-cxa-atexit -fms-extensions -fms-compatibility -fms-compatibility-version=19.44.35213 -std=c++14 -fskip-odr-check-in-gmf -fdelayed-template-parsing -fcxx-exceptions -fexceptions -faddrsig -o - -x c++ -
clang -cc1 version 20.1.7 based upon LLVM 20.1.7 default target x86_64-pc-windows-msvc
#include "..." search starts here:
#include <...> search starts here:
 C:\Program Files\LLVM\lib\clang\20\include
 C:\Program Files\Microsoft Visual Studio\2022\Enterprise\VC\Tools\MSVC\14.44.35207\include
 C:\Program Files\Microsoft Visual Studio\2022\Enterprise\VC\Tools\MSVC\14.44.35207\atlmfc\include
 C:\Program Files (x86)\Windows Kits\10\Include\10.0.26100.0\ucrt
 C:\Program Files (x86)\Windows Kits\10\Include\10.0.26100.0\shared
 C:\Program Files (x86)\Windows Kits\10\Include\10.0.26100.0\um
 C:\Program Files (x86)\Windows Kits\10\Include\10.0.26100.0\winrt
 C:\Program Files (x86)\Windows Kits\10\Include\10.0.26100.0\cppwinrt
End of search list."#;
        let result = parse_compiler_output(text.as_bytes());
        assert_true!(result.is_ok());
        assert_eq!(
            result.expect("uh"),
            (
                Vec::new(),
                vec![
                    PathBuf::from(r"C:\Program Files\LLVM\lib\clang\20\include"),
                    PathBuf::from(
                        r"C:\Program Files\Microsoft Visual Studio\2022\Enterprise\VC\Tools\MSVC\14.44.35207\include"
                    ),
                    PathBuf::from(
                        r"C:\Program Files\Microsoft Visual Studio\2022\Enterprise\VC\Tools\MSVC\14.44.35207\atlmfc\include"
                    ),
                    PathBuf::from(
                        r"C:\Program Files (x86)\Windows Kits\10\Include\10.0.26100.0\ucrt"
                    ),
                    PathBuf::from(
                        r"C:\Program Files (x86)\Windows Kits\10\Include\10.0.26100.0\shared"
                    ),
                    PathBuf::from(
                        r"C:\Program Files (x86)\Windows Kits\10\Include\10.0.26100.0\um"
                    ),
                    PathBuf::from(
                        r"C:\Program Files (x86)\Windows Kits\10\Include\10.0.26100.0\winrt"
                    ),
                    PathBuf::from(
                        r"C:\Program Files (x86)\Windows Kits\10\Include\10.0.26100.0\cppwinrt"
                    )
                ]
            )
        );
    }

    #[test]
    fn test_execute_command_with_args_get_stderr_with_bad_command() {
        let cmd = OsStr::new("command-not-existing");
        let output = execute_command_with_args_get_stderr(cmd, &["-v"]);
        assert_true!(output.is_err());
        assert_eq!(
            output.unwrap_err().to_string(),
            format!("Error invoking the compiler {cmd:?} to get the default include folders.")
        );
    }

    #[test]
    fn test_get_default_include_for_compiler() {
        let cmd = OsStr::new("command-not-existing");
        let result = get_default_include_for_compiler(cmd, Language::Cpp);
        assert_true!(result.is_err());
        assert_eq!(
            result.unwrap_err().to_string(),
            format!("Error invoking the compiler {cmd:?} to get the default include folders.")
        );
    }
}
