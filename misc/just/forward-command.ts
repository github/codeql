import * as child_process from "child_process";
import * as path from "path";
import * as fs from "fs";

function commonDir(paths: string[]): string {
    if (paths.length === 0) return "";
    const splitPaths = paths.map((p) => p.split(path.sep));
    let i;
    for (i = 0; i < splitPaths[0].length; i++) {
        if (!splitPaths.every((parts) => parts[i] === splitPaths[0][i])) {
            break;
        }
    }
    const commonParts = splitPaths[0].slice(0, i);
    let ret = commonParts.join(path.sep);
    if (!fs.existsSync(ret)) {
        throw new Error(`Common directory does not exist: ${ret}`);
    }
    if (!fs.lstatSync(ret).isDirectory()) {
        ret = path.dirname(ret);
    }
    return ret;
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

    if (positionalArgs.length === 0) {
        console.error("No positional arguments provided");
        return 1;
    }

    const commonPath = commonDir(positionalArgs);
    let relativeArgs = positionalArgs.map(
        (arg) => path.relative(commonPath, arg) || ".",
    );
    if (relativeArgs.length === 1 && relativeArgs[0] === ".") {
        relativeArgs = [];
    }
    let relativeFlags = flags.map((arg) => {
        // this might break in specific corner cases, but is good enough for most uses
        // workaround if this doesn't work is to not use the forwarder (call just directly in the relevant directory)
        if (arg.includes("=") && arg.includes(path.sep)) {
            let [flags, flag_arg] = arg.split("=", 2);
            flag_arg = flag_arg
                .split(path.delimiter)
                .map((p) =>
                    path.isAbsolute(p) ? p : path.relative(commonPath, p),
                )
                .join(path.delimiter);
            return `${flags}=${flag_arg}`;
        }
        return arg;
    });

    const invocation = [
        process.env["JUST_EXECUTABLE"] || "just",
        cmd,
        ...relativeFlags,
        ...relativeArgs,
    ];
    console.log(`-> ${commonPath}: just ${invocation.slice(1).join(" ")}`);
    try {
        child_process.execFileSync(invocation[0], invocation.slice(1), {
            stdio: "inherit",
            cwd: commonPath,
        });
    } catch (error) {
        return 1;
    }
    return 0;
}

process.exit(forwardCommand(process.argv.slice(2)));
