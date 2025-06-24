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
 * Each request should have a `command` property, which should either be `parse` or `quit`.
 *
 * A `quit` request causes the wrapper to terminate.
 *
 * A `parse` request should have a `filename` property, which should be the path of a
 * TypeScript file.
 *
 * In response to a `parse` request, the wrapper invokes the TypeScript parser to parse
 * the given file, and dumps a JSON representation of the resulting AST to stdout,
 * with the following adjustments:
 *
 *   - the `kind` and `operator` properties have symbolic string values instead of numeric
 *     values (the latter change between versions of the TypeScript compiler, the former
 *     don't);
 *   - position information is given in terms of line/column pairs instead of offsets;
 *   - declarations have a `declarationKind` property indicating whether they are `var`,
 *     `let` or `const` declarations;
 *   - `parent` pointers are omitted (since they cannot be serialised to JSON);
 *   - tokens and comments are added to the AST root node in a `tokens` property.
 */

"use strict";

import * as pathlib from "path";
import * as readline from "readline";
import * as ts from "./typescript";
import * as ast_extractor from "./ast_extractor";

import { Project } from "./common";
import { VirtualSourceRoot } from "./virtual_source_root";

// Remove limit on stack trace depth.
Error.stackTraceLimit = Infinity;

interface ParseCommand {
    command: "parse";
    filename: string;
}
interface LoadCommand {
    tsConfig: string;
    sourceRoot: string | null;
    virtualSourceRoot: string | null;
    packageEntryPoints: [string, string][];
    packageJsonFiles: [string, string][];
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
    public project: Project = null;

    /** List of files that have been requested. */
    public pendingFiles: string[] = [];
    public pendingFileIndex = 0;

    /** Next response to be delivered. */
    public pendingResponse: string = null;

    /** Map from `package.json` files to their contents. */
    public parsedPackageJson = new Map<string, any>();

    /** Map from `package.json` files to the file referenced in its `types` or `typings` field. */
    public packageTypings = new Map<string, string | undefined>();

    /** Map from file path to the enclosing `package.json` file, if any. Will not traverse outside node_modules. */
    public enclosingPackageJson = new Map<string, string | undefined>();
}
let state = new State();

const reloadMemoryThresholdMb = getEnvironmentVariable("SEMMLE_TYPESCRIPT_MEMORY_THRESHOLD", Number, 1000);

function getPackageJson(file: string): any {
    let cache = state.parsedPackageJson;
    if (cache.has(file)) return cache.get(file);
    let result = getPackageJsonRaw(file);
    cache.set(file, result);
    return result;
}

function getPackageJsonRaw(file: string): any {
    if (!ts.sys.fileExists(file)) return undefined;
    try {
        let json = JSON.parse(ts.sys.readFile(file));
        if (typeof json !== 'object') return undefined;
        return json;
    } catch (e) {
        return undefined;
    }
}

function getPackageTypings(file: string): string | undefined {
    let cache = state.packageTypings;
    if (cache.has(file)) return cache.get(file);
    let result = getPackageTypingsRaw(file);
    cache.set(file, result);
    return result;
}

function getPackageTypingsRaw(packageJsonFile: string): string | undefined {
    let json = getPackageJson(packageJsonFile);
    if (json == null) return undefined;
    let typings = json.types || json.typings; // "types" and "typings" are aliases
    if (typeof typings !== 'string') return undefined;
    let absolutePath = pathlib.join(pathlib.dirname(packageJsonFile), typings);
    if (ts.sys.directoryExists(absolutePath)) {
        absolutePath = pathlib.join(absolutePath, 'index.d.ts');
    } else if (!absolutePath.endsWith('.ts')) {
        absolutePath += '.d.ts';
    }
    if (!ts.sys.fileExists(absolutePath)) return undefined;
    return ts.sys.resolvePath(absolutePath);
}

function getEnclosingPackageJson(file: string): string | undefined {
    let cache = state.packageTypings;
    if (cache.has(file)) return cache.get(file);
    let result = getEnclosingPackageJsonRaw(file);
    cache.set(file, result);
    return result;
}

function getEnclosingPackageJsonRaw(file: string): string | undefined {
    let packageJson = pathlib.join(file, 'package.json');
    if (ts.sys.fileExists(packageJson)) {
        return packageJson;
    }
    if (pathlib.basename(file) === 'node_modules') {
        return undefined;
    }
    let dirname = pathlib.dirname(file);
    if (dirname.length < file.length) {
        return getEnclosingPackageJson(dirname);
    }
    return undefined;
}

/**
 * Debugging method for finding cycles in the TypeScript AST. Should not be used in production.
 *
 * If cycles are found, the whitelist in `astProperties` is too permissive.
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
            // Ignore numeric and whitelisted properties.
            if (+k !== +k && !astPropertySet.has(k)) continue;
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

/** Property names to extract from the TypeScript AST. */
const astProperties: string[] = [
    "$declarationKind",
    "$end",
    "$lineStarts",
    "$overloadIndex",
    "$pos",
    "$tokens",
    "argument",
    "argumentExpression",
    "arguments",
    "assertsModifier",
    "asteriskToken",
    "attributes",
    "block",
    "body",
    "caseBlock",
    "catchClause",
    "checkType",
    "children",
    "clauses",
    "closingElement",
    "closingFragment",
    "condition",
    "constraint",
    "constructor",
    "declarationList",
    "declarations",
    "default",
    "delete",
    "dotDotDotToken",
    "elements",
    "elementType",
    "elementTypes",
    "elseStatement",
    "escapedText",
    "exclamationToken",
    "exportClause",
    "expression",
    "exprName",
    "extendsType",
    "falseType",
    "finallyBlock",
    "flags",
    "head",
    "heritageClauses",
    "importClause",
    "incrementor",
    "indexType",
    "init",
    "initializer",
    "isExportEquals",
    "isTypeOf",
    "isTypeOnly",
    "keywordToken",
    "kind",
    "label",
    "left",
    "literal",
    "members",
    "messageText",
    "modifiers",
    "moduleReference",
    "moduleSpecifier",
    "name",
    "namedBindings",
    "objectType",
    "openingElement",
    "openingFragment",
    "operand",
    "operator",
    "operatorToken",
    "parameterName",
    "parameters",
    "parseDiagnostics",
    "properties",
    "propertyName",
    "qualifier",
    "questionDotToken",
    "questionToken",
    "right",
    "selfClosing",
    "statement",
    "statements",
    "tag",
    "tagName",
    "template",
    "templateSpans",
    "text",
    "thenStatement",
    "token",
    "tokenPos",
    "trueType",
    "tryBlock",
    "type",
    "typeArguments",
    "typeName",
    "typeParameter",
    "typeParameters",
    "types",
    "variableDeclaration",
    "whenFalse",
    "whenTrue",
];

/** Property names used in a parse command response, in addition to the AST itself. */
const astMetaProperties: string[] = [
    "ast",
    "type",
];

/** Property names to extract in an AST response. */
const astPropertySet = new Set([...astProperties, ...astMetaProperties]);

/**
 * Converts (part of) an AST to a JSON string, ignoring properties we're not interested in.
 */
function stringifyAST(obj: any) {
    return JSON.stringify(obj, (k, v) => {
        // Filter out properties that aren't numeric, empty, or whitelisted.
        // Note `k` is the empty string for the root object, which is also covered by +k === +k.
        return (+k === +k || astPropertySet.has(k)) ? v : undefined;
    });
}

function extractFile(filename: string): string {
    let ast = getAstForFile(filename);

    return stringifyAST({
        type: "ast",
        ast,
    });
}

function prepareNextFile() {
    if (state.pendingResponse != null) return;
    if (state.pendingFileIndex < state.pendingFiles.length) {
        checkMemoryUsage();
        let nextFilename = state.pendingFiles[state.pendingFileIndex];
        state.pendingResponse = extractFile(nextFilename);
    }
}

function handleParseCommand(command: ParseCommand, checkPending = true) {
    let filename = command.filename;
    let expectedFilename = state.pendingFiles[state.pendingFileIndex];
    if (expectedFilename !== filename && checkPending) {
        // File was requested out of order. This happens in rare cases because the Java process decided against extracting it,
        // for example because it was too large. Just recover and accept that some work was wasted.
        state.pendingResponse = null;
        state.pendingFileIndex = state.pendingFiles.indexOf(filename);
    }
    ++state.pendingFileIndex;
    let response = state.pendingResponse || extractFile(command.filename);
    state.pendingResponse = null;
    process.stdout.write(response + "\n", () => {
        // Start working on the next file as soon as the old one is flushed.
        // Note that if we didn't wait for flushing, this would block the I/O
        // loop and delay flushing.
        prepareNextFile();
    });
}

/**
 * Returns true if the given source file has an actual AST, as opposed to
 * a SourceFile that is a "redirect" to another SourceFile.
 *
 * The TypeScript API should not expose such redirecting SourceFiles,
 * but we sometimes get them anyway.
 */
function isExtractableSourceFile(ast: ast_extractor.AugmentedSourceFile): boolean {
    return ast.redirectInfo == null;
}

/**
 * Gets the AST and source code for the given file, either from
 * an already-open project, or by parsing the file.
 */
function getAstForFile(filename: string): ts.SourceFile {
    let { ast, code } = parseSingleFile(filename);
    ast_extractor.augmentAst(ast, code, null);
    return ast;
}

function parseSingleFile(filename: string): { ast: ts.SourceFile, code: string } {
    let code = ts.sys.readFile(filename);

    // create a compiler host that only allows access to `filename`
    let compilerHost: ts.CompilerHost = {
        fileExists() { return true; },
        getCanonicalFileName() { return filename; },
        getCurrentDirectory() { return ""; },
        getDefaultLibFileName() { return "lib.d.ts"; },
        getNewLine() { return "\n"; },
        getSourceFile() {
            return ts.createSourceFile(filename, code, ts.ScriptTarget.Latest, true);
        },
        readFile() { return null; },
        useCaseSensitiveFileNames() { return true; },
        writeFile() { return null; },
        getDirectories() { return []; },
    };

    // parse `filename` with minimial checking
    let compilerOptions: ts.CompilerOptions = {
        experimentalDecorators: true,
        experimentalAsyncFunctions: true,
        jsx: ts.JsxEmit.Preserve,
        noResolve: true,
    };

    let program = ts.createProgram([filename], compilerOptions, compilerHost);

    let ast = program.getSourceFile(filename);

    return { ast, code };
}

/**
 * Matches a path segment referencing a package in a node_modules folder, and extracts
 * two capture groups: the package name, and the relative path in the package.
 *
 * For example `lib/node_modules/@foo/bar/src/index.js` extracts the capture groups [`@foo/bar`, `src/index.js`].
 */
const nodeModulesRex = /[/\\]node_modules[/\\]((?:@[\w.-]+[/\\])?\w[\w.-]*)[/\\](.*)/;

interface LoadedConfig {
    config: ts.ParsedCommandLine;
    basePath: string;
    packageEntryPoints: Map<string, string>;
    packageJsonFiles: Map<string, string>;
    virtualSourceRoot: VirtualSourceRoot;
    ownFiles: string[];
}

function loadTsConfig(command: LoadCommand): LoadedConfig {
    let tsConfig = ts.readConfigFile(command.tsConfig, ts.sys.readFile);
    let basePath = pathlib.dirname(command.tsConfig);

    let packageEntryPoints = new Map(command.packageEntryPoints);
    let packageJsonFiles = new Map(command.packageJsonFiles);
    let virtualSourceRoot = new VirtualSourceRoot(command.sourceRoot, command.virtualSourceRoot);

    /**
     * Rewrites path segments of form `node_modules/PACK/suffix` to be relative to
     * the location of package PACK in the source tree, if it exists.
     */
    function redirectNodeModulesPath(path: string) {
        let nodeModulesMatch = nodeModulesRex.exec(path);
        if (nodeModulesMatch == null) return null;
        let packageName = nodeModulesMatch[1];
        let packageJsonFile = packageJsonFiles.get(packageName);
        if (packageJsonFile == null) return null;
        let packageDir = pathlib.dirname(packageJsonFile);
        let suffix = nodeModulesMatch[2];
        let finalPath = pathlib.join(packageDir, suffix);
        if (!ts.sys.fileExists(finalPath)) return null;
        return finalPath;
    }

    /**
     * Create the host passed to the tsconfig.json parser.
     *
     * We override its file system access in case there is an "extends"
     * clause pointing into "./node_modules", which must be redirected to
     * the location of an installed package or a checked-in package.
     */
    let parseConfigHost: ts.ParseConfigHost = {
        useCaseSensitiveFileNames: true,
        readDirectory: (rootDir, extensions, excludes?, includes?, depth?) => {
            // Perform the glob matching in both real and virtual source roots.
            let exclusions = excludes == null ? [] : [...excludes];
            if (virtualSourceRoot.virtualSourceRoot != null) {
                // qltest puts the virtual source root inside the real source root (.testproj).
                // Make sure we don't find files inside the virtual source root in this pass.
                exclusions.push(virtualSourceRoot.virtualSourceRoot);
            }
            let originalResults = ts.sys.readDirectory(rootDir, extensions, exclusions, includes, depth)
            let virtualDir = virtualSourceRoot.toVirtualPath(rootDir);
            if (virtualDir == null) {
                return originalResults;
            }
            // Make sure glob matching does not to discover anything in node_modules.
            let virtualExclusions = excludes == null ? [] : [...excludes];
            virtualExclusions.push('**/node_modules/**/*');
            let virtualResults = ts.sys.readDirectory(virtualDir, extensions, virtualExclusions, includes, depth)
            return [...originalResults, ...virtualResults];
        },
        fileExists: (path: string) => {
            return ts.sys.fileExists(path)
                || virtualSourceRoot.toVirtualPathIfFileExists(path) != null
                || redirectNodeModulesPath(path) != null;
        },
        readFile: (path: string) => {
            if (!ts.sys.fileExists(path)) {
                let virtualPath = virtualSourceRoot.toVirtualPathIfFileExists(path);
                if (virtualPath != null) return ts.sys.readFile(virtualPath);
                virtualPath = redirectNodeModulesPath(path);
                if (virtualPath != null) return ts.sys.readFile(virtualPath);
            }
            return ts.sys.readFile(path);
        }
    };
    let config = ts.parseJsonConfigFileContent(tsConfig.config, parseConfigHost, basePath);

    let ownFiles = config.fileNames.map(file => pathlib.resolve(file));

    return { config, basePath, packageJsonFiles, packageEntryPoints, virtualSourceRoot, ownFiles };
}

function handleResetCommand(command: ResetCommand) {
    reset();
    console.log(JSON.stringify({
        type: "reset-done",
    }));
}

function handlePrepareFilesCommand(command: PrepareFilesCommand) {
    state.pendingFiles = command.filenames;
    state.pendingFileIndex = 0;
    state.pendingResponse = null;
    process.stdout.write('{"type":"ok"}\n', () => {
        prepareNextFile();
    });
}

function handleGetMetadataCommand(command: GetMetadataCommand) {
    console.log(JSON.stringify({
        type: "metadata",
        syntaxKinds: ts.SyntaxKind,
        nodeFlags: ts.NodeFlags,
    }));
}

function reset() {
    state = new State();
}

function getEnvironmentVariable<T>(name: string, parse: (x: string) => T, defaultValue: T) {
    let value = process.env[name];
    return value != null ? parse(value) : defaultValue;
}

/**
 * Whether the memory usage was last observed to be above the threshold for restarting the TypeScript compiler.
 *
 * This is to prevent repeatedly restarting the compiler if the GC does not immediately bring us below the
 * threshold again.
 */
let hasReloadedSinceExceedingThreshold = false;

/**
 * If memory usage has moved above a the threshold, reboot the TypeScript compiler instance.
 *
 * Make sure to call this only when stdout has been flushed.
 */
function checkMemoryUsage() {
    let bytesUsed = process.memoryUsage().heapUsed;
    let megabytesUsed = bytesUsed / 1000000;
    if (!hasReloadedSinceExceedingThreshold && megabytesUsed > reloadMemoryThresholdMb && state.project != null) {
        console.warn('Restarting TypeScript compiler due to memory usage');
        state.project.reload();
        hasReloadedSinceExceedingThreshold = true;
    }
    else if (hasReloadedSinceExceedingThreshold && megabytesUsed < reloadMemoryThresholdMb) {
        hasReloadedSinceExceedingThreshold = false;
    }
}

function runReadLineInterface() {
    reset();
    let rl = readline.createInterface({ input: process.stdin, output: process.stdout });
    rl.on("line", (line: string) => {
        let req: Command = JSON.parse(line);
        switch (req.command) {
            case "parse":
                handleParseCommand(req);
                break;
            case "prepare-files":
                handlePrepareFilesCommand(req);
                break;
            case "reset":
                handleResetCommand(req);
                break;
            case "get-metadata":
                handleGetMetadataCommand(req);
                break;
            case "quit":
                rl.close();
                break;
            default:
                throw new Error("Unknown command " + (req as any).command + ".");
        }
    });
}

// Parse command-line arguments.
if (process.argv.length > 2) {
    let argument = process.argv[2];
    if (argument === "--version") {
        console.log("parser-wrapper with TypeScript " + ts.version);
    } else if (pathlib.extname(argument) === ".ts" || pathlib.extname(argument) === ".tsx") {
        handleParseCommand({
            command: "parse",
            filename: argument,
        }, false);
    } else {
        console.error("Unrecognized file or flag: " + argument);
    }
    process.exit(0);
} else {
    runReadLineInterface();
}
