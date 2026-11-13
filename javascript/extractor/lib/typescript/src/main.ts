/**
 * @fileoverview Wrapper for TypeScript parser, inspired by
 *               [typescript-eslint-parser](https://github.com/eslint/typescript-eslint-parser).
 *
 * The wrapper can be invoked with a single argument, which is interpreted as a file name.
 * The file is parsed and the AST dumped to stdout as described below.
 *
 * When run without arguments, the wrapper enters server mode, expecting JSON-encoded requests
 * on `stdin`, one per line.
 *
 * Each request should have a `command` property, which should be `parse`, `prepare-files`,
 * `reset`, `get-metadata`, or `quit`.
 *
 * A `quit` request causes the wrapper to terminate.
 *
 * A `parse` request should have a `filename` property, which should be the path of a
 * TypeScript file.
 *
 * In response to a `parse` request, the wrapper invokes the TypeScript parser to parse
 * the given file, and dumps a JSON representation of the resulting AST to stdout.
 */

import * as pathlib from "path";
import * as readline from "readline";
import * as ts from "typescript/ast";
import { API, JsxEmit } from "typescript/sync";
import { version } from "typescript";
import { extractAst } from "./ast_extractor.js";

// Remove limit on stack trace depth.
Error.stackTraceLimit = Infinity;

interface ParseCommand {
    command: "parse";
    filename: string;
}
interface ResetCommand {
    command: "reset";
}
interface QuitCommand {
    command: "quit";
}
interface PrepareFilesCommand {
    command: "prepare-files";
    filenames: string[];
}
interface GetMetadataCommand {
    command: "get-metadata";
}
type Command = ParseCommand | ResetCommand | QuitCommand | PrepareFilesCommand | GetMetadataCommand;

/** The state to be shared between commands. */
class State {
    /** List of files that have been requested. */
    public pendingFiles: string[] = [];
    public pendingFileIndex = 0;
    /** Next response to be delivered. */
    public pendingResponse: string | null = null;
}
let state = new State();

/**
 * Debugging method for finding cycles in the projected AST. Should not be used in production.
 */
// tslint:disable-next-line:no-unused-variable
function checkCycle(root: any) {
    let path: string[] = [];
    function visit(obj: any): boolean {
        if (obj == null || typeof obj !== "object") return false;
        if (obj.$cycle_visiting) {
            return true;
        }
        obj.$cycle_visiting = true;
        for (let k in obj) {
            if (!obj.hasOwnProperty(k)) continue;
            if (k === "$cycle_visiting") continue;
            let cycle = visit(obj[k]);
            if (cycle) {
                path.push(k);
                return true;
            }
        }
        obj.$cycle_visiting = undefined;
        return false;
    }
    visit(root);
    if (path.length > 0) {
        path.reverse();
        console.log(JSON.stringify({ type: "error", message: "Cycle = " + path.join(".") }));
    }
}

// The API instance used to interact with the TypeScript compiler. Should be
// accessed through `getAPI` and `closeAPI`.
let api: API | undefined;

function getAPI(): API {
    return api ??= new API();
}

function closeAPI() {
    const previous = api;
    api = undefined;
    previous?.close();
}

function extractFile(filename: string): string {
    const program = getAPI().createProgram([pathlib.resolve(filename)], {
        experimentalDecorators: true,
        jsx: JsxEmit.Preserve,
        noResolve: true,
        noLib: true,
    });
    const ast = program.getSourceFile(pathlib.resolve(filename));
    if (ast == null) {
        throw new Error("TypeScript did not return a source file for " + filename);
    }
    const json = JSON.stringify({
        type: "ast",
        ast: extractAst(ast, program.getSyntacticDiagnostics()),
    });
    program.dispose();
    return json;
}

function prepareNextFile() {
    if (state.pendingResponse != null) return;
    if (state.pendingFileIndex < state.pendingFiles.length) {
        state.pendingResponse = extractFile(state.pendingFiles[state.pendingFileIndex]);
    }
}

// Start working on the next file as soon as the old one is flushed.
// Note that if we didn't wait for flushing, this would block the I/O
// loop and delay flushing.
function afterResponse(expectedState: State) {
    return (error?: Error | null) => {
        if (!error && state === expectedState) {
            prepareNextFile();
        }
    };
}

function handleParseCommand(command: ParseCommand) {
    const filename = command.filename;
    const expectedFilename = state.pendingFiles[state.pendingFileIndex];
    if (expectedFilename !== filename) {
        // File was requested out of order. This happens in rare cases because the Java process decided
        // against extracting it, for example because it was too large. Just recover and accept some wasted work.
        state.pendingResponse = null;
        state.pendingFileIndex = state.pendingFiles.indexOf(filename);
    }
    ++state.pendingFileIndex;
    const response = state.pendingResponse || extractFile(filename);
    state.pendingResponse = null;
    process.stdout.write(response + "\n", afterResponse(state));
}

function runReadLineInterface() {
    const rl = readline.createInterface({ input: process.stdin, output: process.stdout });
    rl.on("close", () => {
        state = new State();
        process.stdin.destroy();
        closeAPI();
    });
    rl.on("line", (line: string) => {
        const req: Command = JSON.parse(line);
        switch (req.command) {
            case "parse":
                handleParseCommand(req);
                break;
            case "prepare-files":
                state = new State();
                state.pendingFiles = req.filenames;
                process.stdout.write('{"type":"ok"}\n', afterResponse(state));
                break;
            case "reset":
                state = new State();
                closeAPI();
                console.log('{"type":"reset-done"}');
                break;
            case "get-metadata":
                console.log(JSON.stringify({
                    type: "metadata",
                    syntaxKinds: ts.SyntaxKind,
                    nodeFlags: ts.NodeFlags,
                }));
                break;
            case "quit":
                rl.close();
                break;
            default:
                throw new Error("Unknown command " + (req as { command: string }).command + ".");
        }
    });
}

// Parse command-line arguments.
if (process.argv.length > 2) {
    const argument = process.argv[2];
    if (argument === "--version") {
        console.log("parser-wrapper with TypeScript " + version);
    } else if (pathlib.extname(argument) === ".ts" || pathlib.extname(argument) === ".tsx") {
        process.stdout.write(extractFile(argument) + "\n");
        closeAPI();
    } else {
        console.error("Unrecognized file or flag: " + argument);
        process.exitCode = 1;
    }
} else {
    runReadLineInterface();
}
