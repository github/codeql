/**
 * Wrapper for the TypeScript parser. Accepts newline-delimited JSON commands on stdin
 * and writes ASTs and parser metadata to stdout, or parses a single command-line file.
 */

import * as pathlib from "path";
import * as readline from "readline";
import * as ts from "typescript/ast";
import { API, JsxEmit } from "typescript/sync";
import { version } from "typescript";
import { extractAst } from "./ast_extractor.js";

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

class State {
    public pendingFiles: string[] = [];
    public pendingFileIndex = 0;
    public pendingResponse: string | null = null;
}
let state = new State();
let stopped = false;
let readLineInterface: readline.Interface | undefined;
let reportedMemoryPressure = false;

function createAPI(): API {
    const threshold = Number(process.env.SEMMLE_TYPESCRIPT_MEMORY_THRESHOLD ?? 1000) * 1000000;
    if (!Number.isSafeInteger(threshold) || threshold <= 0) {
        throw new Error("SEMMLE_TYPESCRIPT_MEMORY_THRESHOLD must be a positive number of megabytes");
    }
    const rss = process.memoryUsage().rss;
    if (rss >= threshold && !reportedMemoryPressure) {
        console.warn("Node.js RSS exceeds the TypeScript memory budget; limiting native compiler memory");
    }
    reportedMemoryPressure = rss >= threshold;

    // The API inherits the environment when it spawns its native process.
    const previousLimit = process.env.GOMEMLIMIT;
    process.env.GOMEMLIMIT = String(Math.max(1, threshold - rss));
    try {
        return new API();
    } finally {
        if (previousLimit == null) delete process.env.GOMEMLIMIT;
        else process.env.GOMEMLIMIT = previousLimit;
    }
}

function extractFile(filename: string): string {
    const api = createAPI();
    try {
        const program = api.createProgram([pathlib.resolve(filename)], {
            experimentalDecorators: true,
            jsx: JsxEmit.Preserve,
            noResolve: true,
            noLib: true,
        });
        try {
            const ast = program.getSourceFile(pathlib.resolve(filename));
            if (ast == null) {
                throw new Error("TypeScript did not return a source file for " + filename);
            }
            return JSON.stringify({
                type: "ast",
                ast: extractAst(ast, program.getSyntacticDiagnostics()),
            });
        } finally {
            program.dispose();
        }
    } finally {
        api.close();
    }
}

function prepareNextFile() {
    if (state.pendingResponse != null) return;
    if (state.pendingFileIndex < state.pendingFiles.length) {
        state.pendingResponse = extractFile(state.pendingFiles[state.pendingFileIndex]);
    }
}

function fail(error: unknown) {
    stopped = true;
    state = new State();
    readLineInterface?.close();
    process.stdin.destroy();
    console.error(error);
    process.exitCode = 1;
}

function afterResponse(expectedState: State) {
    return (error?: Error | null) => {
        if (error != null) {
            fail(error);
            return;
        }
        if (stopped || state !== expectedState) return;
        try {
            prepareNextFile();
        } catch (failure) {
            fail(failure);
        }
    };
}

function handleParseCommand(command: ParseCommand) {
    const filename = command.filename;
    const expectedFilename = state.pendingFiles[state.pendingFileIndex];
    if (expectedFilename !== filename) {
        // Java may skip a prepared file, for example because it is too large.
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
    readLineInterface = rl;
    rl.on("close", () => {
        stopped = true;
        state = new State();
        process.stdin.destroy();
    });
    rl.on("error", fail);
    rl.on("line", (line: string) => {
        if (stopped) return;
        try {
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
        } catch (error) {
            fail(error);
        }
    });
}

process.stdout.on("error", fail);

try {
    if (process.argv.length > 2) {
        const argument = process.argv[2];
        if (argument === "--version") {
            console.log("parser-wrapper with TypeScript " + version);
        } else if (pathlib.extname(argument) === ".ts" || pathlib.extname(argument) === ".tsx") {
            process.stdout.write(extractFile(argument) + "\n");
        } else {
            console.error("Unrecognized file or flag: " + argument);
            process.exitCode = 1;
        }
    } else {
        runReadLineInterface();
    }
} catch (error) {
    fail(error);
}
