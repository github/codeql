import * as child_process from "child_process";
import * as path from "path";
import * as fs from "fs";

const vars = {
    just: process.env["JUST_EXECUTABLE"] || "just",
    error: process.env["JUST_ERROR"] || "",
};

console.debug = (...args: any[]) => {}; // comment out to debug script
const old_console_error = console.error;
console.error = (message: string) => {
    old_console_error(vars.error + message);
};

function checkJustCommand(
    justfile: string,
    command: string,
    postitionalArgs: string[],
): boolean {
    if (!fs.existsSync(justfile)) {
        return false;
    }
    let { cwd, args } = getJustContext(justfile, command, [], postitionalArgs);
    console.debug(
        `Checking: ${cwd ? `cd ${cwd}; ` : ""}just ${args.join(", ")}`,
    );
    const res = child_process.spawnSync(vars.just, ["--dry-run", ...args], {
        stdio: ["ignore", "ignore", "pipe"],
        encoding: "utf8",
        cwd,
    });
    console.debug("result:", res);
    // avoid having the forwarder find itself
    return (
        res.status === 0 &&
        !res.stderr.includes(`forward-command.ts" ${command} "$@"`)
    );
}

function findJustfile(command: string, arg: string): string | undefined {
    for (let p = arg; ; p = path.dirname(p)) {
        const candidate = path.join(p, "justfile");
        if (checkJustCommand(candidate, command, [arg])) {
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
    const positionalArgs = args.filter((arg) => !is_non_positional.test(arg));
    let justfiles: Map<string, string[]> = new Map();
    for (const arg of positionalArgs.length > 0 ? positionalArgs : ["."]) {
        const justfile = findJustfile(cmd, arg);
        if (!justfile) {
            console.error(`No justfile found for ${cmd} on ${arg}`);
            return 1;
        }
        justfiles.set(justfile, [...(justfiles.get(justfile) || []), arg]);
    }
    const invocations = Array.from(justfiles.entries()).map(
        ([justfile, positionalArgs]) => {
            const { cwd, args } = getJustContext(
                justfile,
                cmd,
                flags,
                positionalArgs,
            );
            console.log(`-> ${cwd ? `cd ${cwd}; ` : ""}just ${args.join(" ")}`);
            return { cwd, args };
        },
    );
    for (const { cwd, args } of invocations) {
        if (invokeJust(cwd, args) !== 0) {
            return 1;
        }
    }
    return 0;
}

function getJustContext(
    justfile: string,
    cmd: string,
    flags: string[],
    positionalArgs: string[],
): { args: string[]; cwd?: string } {
    if (
        positionalArgs.length === 1 &&
        justfile == path.join(positionalArgs[0], "justfile")
    ) {
        // If there's only one positional argument and it matches the justfile path, suppress arguments
        // so for example `just build ql/rust` becomes `just build` in the `ql/rust` directory
        return {
            cwd: positionalArgs[0],
            args: [cmd, ...flags],
        };
    } else {
        return {
            cwd: undefined,
            args: ["--justfile", justfile, cmd, ...flags, ...positionalArgs],
        };
    }
}

function invokeJust(cwd: string | undefined, args: string[]): number {
    try {
        child_process.execFileSync(vars.just, args, {
            stdio: "inherit",
            cwd,
        });
    } catch (error) {
        return 1;
    }
    return 0;
}

process.exit(forwardCommand(process.argv.slice(2)));
