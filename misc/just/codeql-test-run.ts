import * as child_process from "child_process";
import * as path from "path";

function codeqlTestRun(argv: string[]): number {
    const [language, args, ...plus] = argv;
    let codeql =
    process.env["SEMMLE_CODE"] ?
        path.join(process.env["SEMMLE_CODE"], "target", "intree", `codeql-${language}`, "codeql")
    :
        "codeql"
    ;
    process.env["CODEQL_CONFIG_FILE"] ||= "."  // disable the default implicit config file, but keep an explicit one
    let plus_options = plus.map(option => option.trim().split("\n").filter(option => option !== ""));
    let testing_level = 0;
    let parsed_args = args.split(" ").filter(arg => {
        if (arg === "") return false;
        if (/^\++$/.test(arg)) {
            testing_level = Math.max(testing_level, arg.length);
            return false;
        }
        return true;
    });
    if (parsed_args.every(arg => arg.startsWith("-"))) {
        parsed_args.push(".");
    }
    let invocation = [codeql, "test", "run", "-j0", ...parsed_args];
    for (let i = 0; i < Math.min(plus_options.length, testing_level); i++) {
        invocation.push(...plus_options[i]);
    }
    console.log(`${process.env["CMD_BEGIN"] || ""}${invocation.join(" ")}${process.env["CMD_END"] || ""}`);
    try {
        child_process.execFileSync(invocation[0], invocation.slice(1), { stdio: "inherit" });
    } catch (error) {
        return 1;
    }
    return 0;
}

process.exit(codeqlTestRun(process.argv.slice(2)));
