import assert from "node:assert/strict";
import { spawn, spawnSync } from "node:child_process";
import { copyFileSync, existsSync, mkdtempSync, readFileSync, rmSync, symlinkSync, writeFileSync } from "node:fs";
import { tmpdir } from "node:os";
import { dirname, join, resolve } from "node:path";
import { createInterface } from "node:readline";
import { after, test } from "node:test";
import { setTimeout } from "node:timers/promises";
import { fileURLToPath } from "node:url";

const root = resolve(dirname(fileURLToPath(import.meta.url)), "..");
const directory = mkdtempSync(join(tmpdir(), "codeql-typescript-lifecycle-"));
const entryPoint = join(directory, "main.js");
for (const name of ["main.js", "ast_extractor.js"]) {
    copyFileSync(join(root, "build", name), join(directory, name));
}
copyFileSync(join(root, "package.json"), join(directory, "package.json"));
symlinkSync(join(root, "node_modules"), join(directory, "node_modules"), "dir");
const filename = join(directory, "input.ts");
writeFileSync(filename, "const value = 1;");
const preload = join(directory, "track-native.cjs");
writeFileSync(preload, `
const cp = require("node:child_process");
const fs = require("node:fs");
const spawn = cp.spawn;
cp.spawn = function (...args) {
    const child = spawn(...args);
    fs.appendFileSync(process.env.NATIVE_LOG, JSON.stringify({
        pid: child.pid,
        stdio: args[2].stdio,
    }) + "\\n");
    if (process.env.KILL_NATIVE) child.kill("SIGKILL");
    return child;
};
`);
after(() => rmSync(directory, { recursive: true, force: true }));

function options(name, env = {}) {
    return {
        encoding: "utf8",
        timeout: 10000,
        env: {
            ...process.env,
            ...env,
            NATIVE_LOG: join(directory, name + ".log"),
        },
    };
}

function run(name, input, env = {}, args = []) {
    const opts = options(name, env);
    const result = spawnSync(process.execPath, ["--require", preload, entryPoint, ...args], {
        ...opts, input,
    });
    assert.ifError(result.error);
    assert.equal(result.signal, null, result.stderr);
    return result;
}

function nativeProcesses(name) {
    return readFileSync(join(directory, name + ".log"), "utf8").trim().split("\n").map(JSON.parse);
}

async function assertTerminated(pid) {
    for (let i = 0; i < 100; ++i) {
        try {
            process.kill(pid, 0);
        } catch (error) {
            assert.equal(error.code, "ESRCH");
            return;
        }
        await setTimeout(10);
    }
    assert.fail(`Native process ${pid} survived disposal`);
}

test("compiled wrapper preserves heritage, assertions and tokens, and accepts source-phase imports", () => {
    const input = join(directory, "compatibility.ts");
    writeFileSync(input, `
        interface I extends A, N.B<string> {}
        class C implements I {}
        import data from "data" assert { type: "json" };
        import source wasm from "./module.wasm";
        const expression = /data/g;
        const template = \`value:\${data}\`;
    `);
    const result = run("compatibility", [
        { command: "get-metadata" },
        { command: "parse", filename: input },
        { command: "quit" },
    ].map(command => JSON.stringify(command) + "\n").join(""));
    assert.equal(result.status, 0, result.stderr);
    assert.equal(result.stderr, "");
    const [metadata, { ast }] = result.stdout.trim().split("\n").map(JSON.parse);
    const kinds = metadata.syntaxKinds;
    assert.deepEqual(ast.parseDiagnostics, []);
    const heritage = ast.statements[0].heritageClauses[0].types;
    assert.equal(heritage[0].kind, kinds.TypeReference);
    assert.equal(heritage[0].typeName.text, "A");
    assert.equal(heritage[1].typeName.right.text, "B");
    assert.equal(heritage[1].typeArguments[0].kind, kinds.StringKeyword);
    assert.equal(ast.statements[2].attributes.attributes[0].name.text, "type");
    assert.equal(ast.statements[2].attributes.attributes[0].value.text, "json");
    assert.equal(ast.statements[3].importClause.phaseModifier, kinds.SourceKeyword);
    assert.equal(ast.statements[3].importClause.name.text, "wasm");
    assert(ast.$tokens.some(token => token.text === "/data/g" && token.kind === kinds.SlashToken));
    assert(ast.$tokens.some(token => token.text === "}`" && token.kind === kinds.CloseBraceToken));
});

test("compiled ESM wrapper reuses its native process until reset or quit", { timeout: 15000 }, async () => {
    const name = "repeated";
    const opts = options(name);
    const child = spawn(process.execPath, ["--require", preload, entryPoint], opts);
    let stderr = "";
    child.stderr.setEncoding("utf8").on("data", data => { stderr += data; });
    const lines = createInterface({ input: child.stdout })[Symbol.asyncIterator]();
    const exited = new Promise((accept, reject) => {
        child.on("error", reject);
        child.on("close", code => accept(code));
    });
    async function request(command) {
        child.stdin.write(JSON.stringify(command) + "\n");
        const line = await lines.next();
        assert.equal(line.done, false, stderr);
        return JSON.parse(line.value);
    }
    try {
        for (let session = 0; session < 2; ++session) {
            for (let batch = 0; batch < 2; ++batch) {
                assert.deepEqual(await request({ command: "prepare-files", filenames: Array(5).fill(filename) }),
                    { type: "ok" });
                for (let i = 0; i < 5; ++i) {
                    const response = await request({ command: "parse", filename });
                    assert.equal(response.type, "ast");
                    assert.deepEqual(response.ast.parseDiagnostics, []);
                    const processes = nativeProcesses(name);
                    assert.equal(processes.length, session + 1);
                    const native = processes[session];
                    assert.deepEqual(native.stdio, process.platform === "win32"
                        ? ["ignore", "ignore", "inherit"] : ["pipe", "pipe", "inherit"]);
                    process.kill(native.pid, 0);
                }
            }
            if (session === 0) {
                assert.deepEqual(await request({ command: "reset" }), { type: "reset-done" });
                await assertTerminated(nativeProcesses(name)[session].pid);
            }
        }
        // Quit must terminate even when the sender leaves stdin open.
        child.stdin.write('{"command":"quit"}\n');
        assert.equal(await exited, 0, stderr);
        assert.equal(stderr, "");
        await assertTerminated(nativeProcesses(name)[1].pid);
    } finally {
        child.stdin.destroy();
        child.kill();
        await exited;
    }
});

test("metadata and reset do not start a native process", () => {
    const result = run("lazy", [
        { command: "get-metadata" },
        { command: "reset" },
        { command: "quit" },
    ].map(command => JSON.stringify(command) + "\n").join(""));
    assert.equal(result.status, 0, result.stderr);
    assert.equal(result.stderr, "");
    assert.deepEqual(result.stdout.trim().split("\n").map(line => JSON.parse(line).type), ["metadata", "reset-done"]);
    assert.equal(existsSync(options("lazy").env.NATIVE_LOG), false);
});

test("reset and quit invalidate queued prefetch callbacks", () => {
    const missing = join(directory, "missing.ts");
    const result = run("cancelled", [
        { command: "prepare-files", filenames: [missing] },
        { command: "reset" },
        { command: "prepare-files", filenames: [missing] },
        { command: "quit" },
    ].map(command => JSON.stringify(command) + "\n").join(""));
    assert.equal(result.status, 0, result.stderr);
    assert.equal(result.stderr, "");
    assert.deepEqual(result.stdout.trim().split("\n").map(JSON.parse), [
        { type: "ok" }, { type: "reset-done" }, { type: "ok" },
    ]);
});

test("single-file mode and EOF flush responses and close native processes", async () => {
    for (const [name, input, args] of [
        ["single", "", [filename]],
        ["eof", JSON.stringify({ command: "parse", filename }) + "\n", []],
    ]) {
        const result = run(name, input, {}, args);
        assert.equal(result.status, 0, result.stderr);
        assert.equal(JSON.parse(result.stdout).type, "ast");
        assert.equal(result.stderr, "");
        await assertTerminated(nativeProcesses(name)[0].pid);
    }
});

test("native failures are fatal, close the process, and never become JSON diagnostics", async () => {
    const result = run("killed", "", { KILL_NATIVE: "1" }, [filename]);
    assert.equal(result.status, 1);
    assert.equal(result.stdout, "");
    assert.match(result.stderr, /Error|EOF|EPIPE|ECONNRESET/);
    await assertTerminated(nativeProcesses("killed")[0].pid);
});

test("fatal extraction errors are not masked by failing cleanup", async () => {
    const failureEntryPoint = join(directory, "fail-source-file.mjs");
    writeFileSync(failureEntryPoint, `
        import { API, Program } from "typescript/sync";
        Object.defineProperties(Program.prototype, {
            getSourceFile: { value() { throw new Error("Source file failure"); } },
            dispose: { value() { throw new Error("Program cleanup failure"); } },
        });
        Object.defineProperty(API.prototype, "close", {
            value() { throw new Error("API cleanup failure"); },
        });
        await import("./main.js");
    `);
    for (const [name, args, input] of [
        ["failed-single", [filename], ""],
        ["failed-server", [], JSON.stringify({ command: "parse", filename }) + "\n"],
    ]) {
        const result = spawnSync(process.execPath, ["--require", preload, failureEntryPoint, ...args], {
            ...options(name), input,
        });
        assert.ifError(result.error);
        assert.equal(result.signal, null, result.stderr);
        assert.equal(result.status, 1, result.stderr);
        assert.equal(result.stdout, "");
        assert.match(result.stderr, /Source file failure/);
        assert.doesNotMatch(result.stderr, /cleanup failure/);
        await assertTerminated(nativeProcesses(name)[0].pid);
    }
});

test("prefetch and stdout failures are fatal and terminate the native process", async () => {
    for (const [name, command, message] of [
        ["prefetch", { command: "prepare-files", filenames: [join(directory, "missing.ts")] },
            /did not return a source file/],
        ["stdout", { command: "parse", filename }, /EPIPE/],
    ]) {
        const child = spawn(process.execPath, ["--require", preload, entryPoint], options(name));
        let stderr = "";
        child.stderr.setEncoding("utf8").on("data", data => { stderr += data; });
        if (name === "stdout") child.stdout.destroy();
        else child.stdout.resume();
        const exited = new Promise((accept, reject) => {
            child.on("error", reject);
            child.on("close", code => accept(code));
        });
        try {
            child.stdin.write(JSON.stringify(command) + "\n");
            assert.equal(await exited, 1, stderr);
            assert.match(stderr, message);
            await assertTerminated(nativeProcesses(name)[0].pid);
        } finally {
            child.stdin.destroy();
            child.kill();
            await exited;
        }
    }
});

test("protocol and extraction failures close an already running native process", async () => {
    for (const [name, input, message] of [
        ["active-json", "{\n", /SyntaxError/],
        ["active-command", '{"command":"invalid"}\n', /Unknown command/],
        ["active-missing", JSON.stringify({ command: "parse", filename: join(directory, "missing.ts") }) + "\n",
            /did not return a source file/],
    ]) {
        const result = run(name, JSON.stringify({ command: "parse", filename }) + "\n" + input);
        assert.equal(result.status, 1, name);
        assert.equal(JSON.parse(result.stdout).type, "ast");
        assert.match(result.stderr, message);
        const processes = nativeProcesses(name);
        assert.equal(processes.length, 1);
        await assertTerminated(processes[0].pid);
    }
});

test("invalid commands and files fail on stderr", () => {
    for (const [name, input, args, message] of [
        ["json", "{\n", [], /SyntaxError/],
        ["command", '{"command":"invalid"}\n', [], /Unknown command/],
        ["missing", "", [join(directory, "missing.ts")], /did not return a source file/],
    ]) {
        const result = run(name, input, {}, args);
        assert.equal(result.status, 1, name);
        assert.equal(result.stdout, "", name);
        assert.match(result.stderr, message);
    }
});

test("the removed SEMMLE_TYPESCRIPT_HOME variable is ignored", () => {
    const result = run("override-ignored", "", {
        SEMMLE_TYPESCRIPT_HOME: join(directory, "missing-typescript"),
    }, [filename]);
    assert.equal(result.status, 0, result.stderr);
    assert.equal(JSON.parse(result.stdout).type, "ast");
    assert.equal(result.stderr, "");
});
