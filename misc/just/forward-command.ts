import * as child_process from "child_process";
import * as path from "path";

const just = process.env["JUST_EXECUTABLE"]!;

console.debug = (...args: any[]) => {}  // comment out to debug script

function checkJustCommand(justfile: string, command: string, postitionalArgs: string[]): boolean {
    let {cwd, args} = getJustContext(justfile, command, [], postitionalArgs);
    console.debug(`Checking: ${cwd ? `cd ${cwd}; ` : ""}just ${args.join(", ")}`);
    const res = child_process.spawnSync(just, ["--dry-run", ...args], {
        stdio: ["ignore", "ignore", "pipe"],
        encoding: "utf8",
        cwd,
    });
    console.debug("result:", res);
    // avoid having the forwarder find itself
    return res.status === 0 && !res.stderr.includes(`forward-command.ts" ${command} "$@"`);
}

function commonPath(paths: string[]): string {
    if (paths.length === 0) return "";
    if (paths.length === 1) return paths[0];
    const splitPaths = paths.map((p) => p.split(path.sep));
    let i;
    for (i = 0; i <= splitPaths[0].length; i++) {
        if (!splitPaths.every((parts) => parts[i] === splitPaths[0][i])) {
            break;
        }
    }
    return splitPaths[0].slice(0, i).join(path.sep);
}

function findJustfile(command: string, paths: string[]): string | undefined {
    const common = commonPath(paths);
    for (let p = common;; p = path.dirname(p)) {
        const candidate = path.join(p, "justfile");
        if (checkJustCommand(candidate, command, paths)) {
            return candidate;
        }
        if (p === "/" || p === ".") {
            return undefined;
        }
    }
}

function forwardCommand(args: string[]): number {
    if (args.length == 0) {
        console.error("No command provided");
        return 1;
    }
    return forward(args[0], args.slice(1));
}

function forward(cmd: string, args: string[]): number {
    // non-positional arguments are flags, + (used by language tests) or environment variable settings
    const is_non_positional = /^(-.*|\+|[A-Z_][A-Z_0-9]*=.*)$/;
    const flags = args.filter((arg) => is_non_positional.test(arg));
    const positionalArgs = args.filter(
        (arg) => !is_non_positional.test(arg),
    );

    const justfile = findJustfile(cmd, positionalArgs.length !== 0 ? positionalArgs : ["."]);
    if (!justfile) {
        if (positionalArgs.length <= 1) {
            console.error(`No justfile found for ${cmd}${positionalArgs.length === 0 ? "" : " on " + positionalArgs[0]}`);
            return 1;
        }
        console.log(`no common justfile recipe found for ${cmd} for all arguments, trying one argument at a time`);
        const runs: [string, string | undefined][] = positionalArgs.map(arg => [arg, findJustfile(cmd, [arg])]);
        for (const [arg, justfile] of runs) {
            if (!justfile) {
                console.error(`No justfile found for ${cmd} on ${arg}`);
                return 1;
            }
        }
        for (const [arg, justfile] of runs) {
            if (invokeJust(justfile!, cmd, flags, [arg]) !== 0) {
                return 1;
            }
        }
        return 0;
    }
    return invokeJust(justfile, cmd, flags, positionalArgs);
}

function getJustContext(justfile: string, cmd: string, flags: string[], positionalArgs: string[]): {args: string[], cwd?: string} {
    if (positionalArgs.length === 1 && justfile == path.join(positionalArgs[0], "justfile")) {
        // If there's only one positional argument and it matches the justfile path, suppress arguments
        // so for example `just build ql/rust` becomes `just build` in the `ql/rust` directory
        return {
            cwd: positionalArgs[0],
            args: [
                cmd,
                ...flags,
            ],
        };
    } else {
        return {
            cwd: undefined,
            args: [
                "--justfile",
                justfile,
                cmd,
                ...flags,
                ...positionalArgs,
            ],
        };
    }
}

function invokeJust(justfile: string, cmd: string, flags: string[], positionalArgs: string[]): number {
    const { cwd, args } = getJustContext(justfile, cmd, flags, positionalArgs);
    console.log(`-> ${cwd ? `cd ${cwd}; ` : ""}just ${args.join(" ")}`);
    try {
        child_process.execFileSync(just, args, {
            stdio: "inherit",
            cwd,
        });
    } catch (error) {
        return 1;
    }
    return 0;
}

process.exit(forwardCommand(process.argv.slice(2)));
