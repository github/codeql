import * as child_process from "child_process";
import * as path from "path";
import * as os from "os";



function invoke(invocation: string[], options: {cwd?: string, log_prefix?: string} = {}) : number {
    const log_prefix = options.log_prefix && options.log_prefix !== "" ? `${options.log_prefix} ` : "";
    console.log(`${process.env["CMD_BEGIN"] || ""}${log_prefix}${invocation.join(" ")}${process.env["CMD_END"] || ""}`);
    try {
        child_process.execFileSync(invocation[0], invocation.slice(1), { stdio: "inherit", cwd: options.cwd });
    } catch (error) {
        return 1;
    }
    return 0;
}

type Args = {
    tests: string[];
    flags: string[];
    env: string[];
    build: boolean;
    testing_level: number;
};

function parseArgs(args: Args, argv: string) {
    argv
        .split(/(?<!\\) /)
        .forEach((arg) => {
            if (arg === "--no-build") {
                args.build = false;
            } else if (arg.startsWith("-")) {
                args.flags.push(arg);
            } else if (/^[A-Z_][A-Z_0-9]*=.*$/.test(arg)) {
                args.env.push(arg);
            } else if (/^\++$/.test(arg)) {
                args.testing_level = Math.max(args.testing_level, arg.length);
            } else if (arg !== "") {
                args.tests.push(arg);
            }
        });
}


function codeqlTestRun(argv: string[]): number {
    const [language, extra_args, ...plus] = argv;
    let codeql =
    process.env["SEMMLE_CODE"] ?
        path.join(process.env["SEMMLE_CODE"], "target", "intree", `codeql-${language}`, "codeql")
    :
        "codeql"
    ;
    const ram_per_thread = process.platform === "linux" ? 3000 : 2048;
    const cpus = os.cpus().length;
    let args: Args = {
        tests: [],
        flags: [
            `--ram=${ram_per_thread * cpus}`,
            `-j${cpus}`,
        ],
        env: [],
        build: true,
        testing_level: 0
    };
    parseArgs(args, extra_args);
    for (let i = 0; i < Math.min(plus.length, args.testing_level); i++) {
        parseArgs(args, plus[i]);
    }
    if (args.tests.length === 0) {
        args.tests.push(".");
    }
    if (args.build && process.env["SEMMLE_CODE"]) {
        // If SEMMLE_CODE is set, we are in the semmle-code repo, so we build the codeql binary.
        // Otherwise, we use codeql from PATH.
        if (invoke(["python3", "build", `target/intree/codeql-${language}`], {cwd: process.env["SEMMLE_CODE"]}) !== 0) {
            return 1;
        }
    }
    process.env["CODEQL_CONFIG_FILE"] ||= "."  // disable the default implicit config file, but keep an explicit one
    // Set and unset environment variables
    args.env.forEach((envVar) => {
        const [key, value] = envVar.split("=", 2);
        if (key) {
            if (value === undefined) {
                delete process.env[key];
            } else {
                process.env[key] = value;
            }
        } else {
            console.error(`Invalid environment variable assignment: ${envVar}`);
            process.exit(1);
        }
    });
    return invoke([codeql, "test", "run", ...args.flags, "--", ...args.tests], {log_prefix: args.env.join(" ")});
}

process.exit(codeqlTestRun(process.argv.slice(2)));
