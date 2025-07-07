import * as child_process from "child_process";
import * as path from "path";
import * as os from "os";
import * as fs from "fs";

function invoke(
    invocation: string[],
    options: { cwd?: string; log_prefix?: string } = {},
): number {
    const log_prefix =
        options.log_prefix && options.log_prefix !== ""
            ? `${options.log_prefix} `
            : "";
    console.log(
        `${process.env["CMD_BEGIN"] || ""}${log_prefix}${invocation.join(" ")}${process.env["CMD_END"] || ""}`,
    );
    try {
        child_process.execFileSync(invocation[0], invocation.slice(1), {
            stdio: "inherit",
            cwd: options.cwd,
        });
    } catch (error) {
        return 1;
    }
    return 0;
}

type Args = {
    tests: string[];
    flags: string[];
    env: string[];
    codeql: string;
    all: boolean;
};

function parseArgs(args: Args, argv: string) {
    argv.split(/(?<!\\) /)
        .map((arg) => arg.replace("\\ ", " "))
        .forEach((arg) => {
            if (arg.startsWith("--codeql=")) {
                args.codeql = arg.split("=")[1];
            } else if (arg === "+" || arg === "--all-checks") {
                args.all = true;
            } else if (arg.startsWith("-")) {
                args.flags.push(arg);
            } else if (/^[A-Z_][A-Z_0-9]*=.*$/.test(arg)) {
                args.env.push(arg);
            } else if (arg !== "") {
                args.tests.push(arg);
            }
        });
}

function codeqlTestRun(argv: string[]): number {
    const semmle_code = process.env["SEMMLE_CODE"];
    const [language, base_args, all_args, extra_args] = argv;
    const ram_per_thread = process.platform === "linux" ? 3000 : 2048;
    const cpus = os.cpus().length;
    let args: Args = {
        tests: [],
        flags: [`--ram=${ram_per_thread * cpus}`, `-j${cpus}`],
        env: [],
        codeql: semmle_code ? "build" : "host",
        all: false,
    };
    parseArgs(args, base_args);
    parseArgs(args, extra_args);
    if (args.all) {
        parseArgs(args, all_args);
    }
    if (!semmle_code && (args.codeql === "build" || args.codeql === "built")) {
        console.error(
            "Using `--codeql=build` or `--codeql=built` requires working with the internal repository",
        );
        return 1;
    }
    if (args.tests.length === 0) {
        args.tests.push(".");
    }
    if (args.codeql === "build") {
        if (
            invoke(["python3", "build", `target/intree/codeql-${language}`], {
                cwd: semmle_code,
            }) !== 0
        ) {
            return 1;
        }
    }
    if (args.codeql !== "host") {
        // disable the default implicit config file, but keep an explicit one
        // this is the same behavior wrt to `--codeql` as the integration test runner
        process.env["CODEQL_CONFIG_FILE"] ||= ".";
    }
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
    let codeql;
    if (args.codeql === "built" || args.codeql === "build") {
        codeql = path.join(
            semmle_code!,
            "target",
            "intree",
            `codeql-${language}`,
            "codeql",
        );
    } else if (args.codeql === "host") {
        codeql = "codeql";
    } else {
        codeql = args.codeql;
        if (fs.lstatSync(codeql).isDirectory()) {
            codeql = path.join(codeql, "codeql");
            if (process.platform === "win32") {
                codeql += ".exe";
            }
        }
        if (!fs.existsSync(codeql)) {
            console.error(`CodeQL executable not found: ${codeql}`);
            return 1;
        }
    }

    return invoke([codeql, "test", "run", ...args.flags, "--", ...args.tests], {
        log_prefix: args.env.join(" "),
    });
}

process.exit(codeqlTestRun(process.argv.slice(2)));
