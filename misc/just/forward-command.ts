import * as child_process from "child_process";
import * as path from "path";
import * as fs from "fs";

function commonJustfile(paths: string[]): string {
    if (paths.length === 0) return "";
    const splitPaths = paths.map((p) => p.split(path.sep));
    let justfile: string | undefined = undefined;
    for (let i = 0; i <= splitPaths[0].length; i++) {
        let candidate = path.join(splitPaths[0].slice(0, i).join(path.sep), "justfile");
        if (fs.existsSync(candidate)) {
            justfile = candidate;
        }
        if (!splitPaths.every((parts) => parts[i] === splitPaths[0][i])) {
            break;
        }
    }
    if (justfile === undefined) {
        throw new Error("No common justfile found");
    }
    return justfile;
}

function forwardCommand(args: string[]): number {
    // Avoid infinite recursion
    if (args.length == 0) {
        console.error("No command provided");
        return 1;
    }
    const cmd = args[0];
    const envVariable = `__JUST_FORWARD_${cmd}`;
    if (process.env[envVariable]) {
        console.error(`No common ${cmd} handler found`);
        return 1;
    }
    process.env[envVariable] = "true";
    const cmdArgs = args.slice(1);
    // non-positional arguments are flags, + (used by language tests) or environment variable settings
    const is_non_positional = /^(-.*|\+|[A-Z_][A-Z_0-9]*=.*)$/;
    const flags = cmdArgs.filter((arg) => is_non_positional.test(arg));
    const positionalArgs = cmdArgs.filter(
        (arg) => !is_non_positional.test(arg),
    );

    const justfile = commonJustfile(positionalArgs.length !== 0 ? positionalArgs : ["."]);
    let cwd: string | undefined;
    let invocation = [process.env["JUST_EXECUTABLE"] || "just"];
    if (positionalArgs.length === 1 && justfile == path.join(positionalArgs[0], "justfile")) {
        // If there's only one positional argument and it matches the justfile path, suppress arguments
        // so for example `just build ql/rust` becomes `just build` in the `ql/rust` directory
        cwd = positionalArgs[0];
        invocation.push(
            cmd,
            ...flags,
        );
        console.log(`-> cd ${cwd}; just ${invocation.slice(1).join(" ")}`);
    } else {
        cwd = undefined;
        invocation.push(
            "--justfile",
            justfile,
            cmd,
            ...flags,
            ...positionalArgs,
        );
        console.log(`-> just ${invocation.slice(1).join(" ")}`);
    }

    try {
        child_process.execFileSync(invocation[0], invocation.slice(1), {
            stdio: "inherit",
            cwd,
        });
    } catch (error) {
        return 1;
    }
    return 0;
}

process.exit(forwardCommand(process.argv.slice(2)));
