import * as path from "path";
import * as process from "process";
import * as child_process from "child_process";

function languageTests(argv: string[]): number {
    const [extra_args, dir, ...relativeRoots] = argv;
    const semmle_code = process.env["SEMMLE_CODE"]!;
    let roots = relativeRoots.map((root) =>
        path.relative(semmle_code, path.join(dir, root)),
    );
    const invocation = [
        process.env["JUST_EXECUTABLE"] || "just",
        "--justfile",
        path.join(roots[0], "justfile"),
        "test",
        "--all-checks",
        "--codeql=built",
        ...extra_args.split(" "),
        ...roots,
    ];
    console.log(`-> just ${invocation.slice(1).join(" ")}`);
    try {
        child_process.execFileSync(invocation[0], invocation.slice(1), {
            stdio: "inherit",
            cwd: semmle_code,
        });
    } catch (error) {
        return 1;
    }
    return 0;
}

process.exit(languageTests(process.argv.slice(2)));
