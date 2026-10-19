import assert from "node:assert/strict";
import { spawn, spawnSync } from "node:child_process";
import { copyFileSync, mkdtempSync, readFileSync, rmSync, symlinkSync, writeFileSync } from "node:fs";
import { tmpdir } from "node:os";
import { dirname, join, resolve } from "node:path";
import { createInterface } from "node:readline";
import { after, test } from "node:test";
import { setTimeout } from "node:timers/promises";
import { fileURLToPath } from "node:url";

const root = resolve(dirname(fileURLToPath(import.meta.url)), "..");
const directory = mkdtempSync(join(tmpdir(), "codeql-typescript-lifecycle-"));
const entryPoint = join(directory, "main.js");
for (const name of ["main.js", "ast_extractor.js", "typescript.js"]) {
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
        memoryLimit: process.env.GOMEMLIMIT,
        stdio: args[2].stdio,
    }) + "\\n");
    if (process.env.KILL_NATIVE) child.kill("SIGKILL");
    return child;
};
`);
after(() => rmSync(directory, { recursive: true, force: true }));

function options(name, env = {}) {
    const environment = { ...process.env };
    delete environment.SEMMLE_TYPESCRIPT_HOME;
    return {
        encoding: "utf8",
        timeout: 10000,
        env: {
            ...environment,
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

test("compiled ESM wrapper releases each native process and budgets its memory", { timeout: 15000 }, async () => {
    const name = "repeated";
    const opts = options(name, { SEMMLE_TYPESCRIPT_MEMORY_THRESHOLD: "1000", GOMEMLIMIT: "900MiB" });
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
        for (let i = 0; i < 10; ++i) {
            const response = await request({ command: "parse", filename });
            assert.equal(response.type, "ast");
            assert.deepEqual(response.ast.parseDiagnostics, []);
            const processes = nativeProcesses(name);
            assert.equal(processes.length, i + 1);
            const native = processes[i];
            assert(Number(native.memoryLimit) > 0);
            assert(Number(native.memoryLimit) < 1000000000);
            assert.deepEqual(native.stdio, process.platform === "win32"
                ? ["ignore", "ignore", "inherit"] : ["pipe", "pipe", "inherit"]);
            await assertTerminated(native.pid);
            assert.deepEqual(await request({ command: "reset" }), { type: "reset-done" });
        }
        // Quit must terminate even when the sender leaves stdin open.
        child.stdin.write('{"command":"quit"}\n');
        assert.equal(await exited, 0, stderr);
        assert.equal(stderr, "");
    } finally {
        child.stdin.destroy();
        child.kill();
        await exited;
    }
});

test("reset and quit invalidate queued prefetch callbacks", () => {
    const missing = join(directory, "missing.ts");
    const result = run("cancelled", [
        { command: "prepare-files", filenames: [missing] },
        { command: "reset" },
        { command: "prepare-files", filenames: [missing] },
        { command: "quit" },
        { command: "parse", filename: missing },
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

test("invalid commands, files, memory settings, and runtime overrides fail on stderr", () => {
    for (const [name, input, env, args, message] of [
        ["json", "{\n", {}, [], /SyntaxError/],
        ["command", '{"command":"invalid"}\n', {}, [], /Unknown command/],
        ["missing", "", {}, [join(directory, "missing.ts")], /did not return a source file/],
        ["memory", "", { SEMMLE_TYPESCRIPT_MEMORY_THRESHOLD: "invalid" }, [filename], /MEMORY_THRESHOLD/],
        ["override", "", { SEMMLE_TYPESCRIPT_HOME: directory }, [filename], /SEMMLE_TYPESCRIPT_HOME/],
    ]) {
        const result = run(name, input, env, args);
        assert.equal(result.status, 1, name);
        assert.equal(result.stdout, "", name);
        assert.match(result.stderr, message);
    }
});

test("SEMMLE_TYPESCRIPT_HOME selects the installed native package", () => {
    const result = run("override-valid", "", {
        SEMMLE_TYPESCRIPT_HOME: join(root, "node_modules", "typescript"),
    }, [filename]);
    assert.equal(result.status, 0, result.stderr);
    assert.equal(JSON.parse(result.stdout).type, "ast");
    assert.equal(result.stderr, "");
});
