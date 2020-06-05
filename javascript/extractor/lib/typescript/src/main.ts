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

import * as fs from "fs";
import * as pathlib from "path";
import * as readline from "readline";
import * as ts from "./typescript";
import * as ast_extractor from "./ast_extractor";

import { Project } from "./common";
import { TypeTable } from "./type_table";
import { VirtualSourceRoot } from "./virtual_source_root";

interface ParseCommand {
    command: "parse";
    filename: string;
}
interface OpenProjectCommand {
    command: "open-project";
    tsConfig: string;
    sourceRoot: string | null;
    virtualSourceRoot: string | null;
    packageEntryPoints: [string, string][];
    packageJsonFiles: [string, string][];
}
interface CloseProjectCommand {
    command: "close-project";
    tsConfig: string;
}
interface GetTypeTableCommand {
    command: "get-type-table";
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
type Command = ParseCommand | OpenProjectCommand | CloseProjectCommand
    | GetTypeTableCommand | ResetCommand | QuitCommand | PrepareFilesCommand | GetMetadataCommand;

/** The state to be shared between commands. */
class State {
    public project: Project = null;
    public typeTable = new TypeTable();

    /** List of files that have been requested. */
    public pendingFiles: string[] = [];
    public pendingFileIndex = 0;

    /** Next response to be delivered. */
    public pendingResponse: string = null;
}
let state = new State();

const reloadMemoryThresholdMb = getEnvironmentVariable("SEMMLE_TYPESCRIPT_MEMORY_THRESHOLD", Number, 1000);

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
        console.log(JSON.stringify({type: "error", message: "Cycle = " + path.join(".")}));
    }
}

/** Property names to extract from the TypeScript AST. */
const astProperties: string[] = [
    "$declarationKind",
    "$declaredSignature",
    "$end",
    "$lineStarts",
    "$overloadIndex",
    "$pos",
    "$resolvedSignature",
    "$symbol",
    "$tokens",
    "$type",
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
    "decorators",
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
        throw new Error("File requested out of order. Expected '" + expectedFilename + "' but got '" + filename + "'");
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
    if (state.project != null) {
        let ast = state.project.program.getSourceFile(filename);
        if (ast != null && isExtractableSourceFile(ast)) {
            ast_extractor.augmentAst(ast, ast.text, state.project);
            return ast;
        }
    }
    // Fall back to extracting without a project.
    let {ast, code} = parseSingleFile(filename);
    ast_extractor.augmentAst(ast, code, null);
    return ast;
}

function parseSingleFile(filename: string): {ast: ts.SourceFile, code: string} {
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

    return {ast, code};
}

/**
 * Matches a path segment referencing a package in a node_modules folder, and extracts
 * two capture groups: the package name, and the relative path in the package.
 *
 * For example `lib/node_modules/@foo/bar/src/index.js` extracts the capture groups [`@foo/bar`, `src/index.js`].
 */
const nodeModulesRex = /[/\\]node_modules[/\\]((?:@[\w.-]+[/\\])?\w[\w.-]*)[/\\](.*)/;

function handleOpenProjectCommand(command: OpenProjectCommand) {
    Error.stackTraceLimit = Infinity;
    let tsConfigFilename = String(command.tsConfig);
    let tsConfig = ts.readConfigFile(tsConfigFilename, ts.sys.readFile);
    let basePath = pathlib.dirname(tsConfigFilename);

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
        readDirectory: ts.sys.readDirectory, // No need to override traversal/glob matching
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
    let project = new Project(tsConfigFilename, config, state.typeTable, packageEntryPoints, virtualSourceRoot);
    project.load();

    state.project = project;
    let program = project.program;
    let typeChecker = program.getTypeChecker();

    let shouldReportDiagnostics = getEnvironmentVariable("SEMMLE_TYPESCRIPT_REPORT_DIAGNOSTICS", Boolean, false);
    let diagnostics = shouldReportDiagnostics
        ? program.getSemanticDiagnostics().filter(d => d.category === ts.DiagnosticCategory.Error)
        : [];
    if (diagnostics.length > 0) {
        console.warn('TypeScript: reported ' + diagnostics.length + ' semantic errors.');
    }
    for (let diagnostic of diagnostics) {
        let text = diagnostic.messageText;
        if (text && typeof text !== 'string') {
            text = text.messageText;
        }
        let locationStr = '';
        let { file } = diagnostic;
        if (file != null) {
            let { line, character } = file.getLineAndCharacterOfPosition(diagnostic.start);
            locationStr = `${file.fileName}:${line}:${character}`;
        }
        console.warn(`TypeScript: ${locationStr} ${text}`);
    }

    // Associate external module names with the corresponding file symbols.
    // We need these mappings to identify which module a given external type comes from.
    // The TypeScript API lets us resolve a module name to a source file, but there is no
    // inverse mapping, nor a way to enumerate all known module names. So we discover all
    // modules on the type roots (usually "node_modules/@types" but this is configurable).
    let typeRoots = ts.getEffectiveTypeRoots(config.options, {
        directoryExists: (path) => fs.existsSync(path),
        getCurrentDirectory: () => basePath,
    });

    for (let typeRoot of typeRoots || []) {
        if (fs.existsSync(typeRoot) && fs.statSync(typeRoot).isDirectory()) {
            traverseTypeRoot(typeRoot, "");
        }
    }

    for (let sourceFile of program.getSourceFiles()) {
        addModuleBindingsFromModuleDeclarations(sourceFile);
        addModuleBindingsFromFilePath(sourceFile);
    }

    /** Concatenates two imports paths. These always use `/` as path separator. */
    function joinModulePath(prefix: string, suffix: string) {
        if (prefix.length === 0) return suffix;
        if (suffix.length === 0) return prefix;
        return prefix + "/" + suffix;
    }

    /**
     * Traverses a directory that is a type root or contained in a type root, and associates
     * module names (i.e. import strings) with files in this directory.
     *
     * `importPrefix` denotes an import string that resolves to this directory,
     * or an empty string if the file itself is a type root.
     *
     * The `filePath` is a system file path, possibly absolute, whereas `importPrefix`
     * is generally short and system-independent, typically just the name of a module.
     */
    function traverseTypeRoot(filePath: string, importPrefix: string) {
        for (let child of fs.readdirSync(filePath)) {
            if (child[0] === ".") continue;
            let childPath = pathlib.join(filePath, child);
            if (fs.statSync(childPath).isDirectory()) {
                traverseTypeRoot(childPath, joinModulePath(importPrefix, child));
                continue;
            }
            let sourceFile = program.getSourceFile(childPath);
            if (sourceFile == null) {
                continue;
            }
            addModuleBindingFromRelativePath(sourceFile, importPrefix, child);
        }
    }

    /**
     * Emits module bindings for a module with relative path `folder/baseName`.
     */
    function addModuleBindingFromRelativePath(sourceFile: ts.SourceFile, folder: string, baseName: string) {
        let symbol = typeChecker.getSymbolAtLocation(sourceFile);
        if (symbol == null) return; // Happens if the source file is not a module.

        let stem = getStem(baseName);
        let importPath = (stem === "index")
            ? folder
            : joinModulePath(folder, stem);

        let canonicalSymbol = getEffectiveExportTarget(symbol); // Follow `export = X` declarations.
        let symbolId = state.typeTable.getSymbolId(canonicalSymbol);

        // Associate the module name with this symbol.
        state.typeTable.addModuleMapping(symbolId, importPath);

        // Associate global variable names with this module.
        // For each `export as X` declaration, the global X refers to this module.
        // Note: the `globalExports` map is stored on the original symbol, not the target of `export=`.
        if (symbol.globalExports != null) {
            symbol.globalExports.forEach((global: ts.Symbol) => {
              state.typeTable.addGlobalMapping(symbolId, global.name);
            });
        }
    }

    /**
     * Returns the basename of `file` without its extension, while treating `.d.ts` as a
     * single extension.
     */
    function getStem(file: string) {
        if (file.endsWith(".d.ts")) {
            return pathlib.basename(file, ".d.ts");
        }
        let base = pathlib.basename(file);
        let dot = base.lastIndexOf('.');
        return dot === -1 || dot === 0 ? base : base.substring(0, dot);
    }

    /**
     * Emits module bindings for a module based on its file path.
     *
     * This looks for enclosing `node_modules` folders to determine the module name.
     * This is needed for modules that ship their own type definitions as opposed to having
     * type definitions loaded from a type root (conventionally named `@types/xxx`).
     */
    function addModuleBindingsFromFilePath(sourceFile: ts.SourceFile) {
        let fullPath = sourceFile.fileName;
        let index = fullPath.lastIndexOf('/node_modules/');
        if (index === -1) return;
        let relativePath = fullPath.substring(index + '/node_modules/'.length);
        // Ignore node_modules/@types folders here as they are typically handled as type roots.
        if (relativePath.startsWith("@types/")) return;
        let { dir, base } = pathlib.parse(relativePath);
        addModuleBindingFromRelativePath(sourceFile, dir, base);
    }

    /**
     * Emit module name bindings for external module declarations, i.e: `declare module 'X' {..}`
     * These can generally occur anywhere; they may or may not be on the type root path.
     */
    function addModuleBindingsFromModuleDeclarations(sourceFile: ts.SourceFile) {
        for (let stmt of sourceFile.statements) {
            if (ts.isModuleDeclaration(stmt) && ts.isStringLiteral(stmt.name)) {
                let symbol = (stmt as any).symbol;
                if (symbol == null) continue;
                symbol = getEffectiveExportTarget(symbol);
                let symbolId = state.typeTable.getSymbolId(symbol);
                let moduleName = stmt.name.text;
                state.typeTable.addModuleMapping(symbolId, moduleName);
            }
        }
    }

    /**
     * If `symbol` refers to a container with an `export = X` declaration, returns
     * the target of `X`, otherwise returns `symbol`.
     */
    function getEffectiveExportTarget(symbol: ts.Symbol) {
        if (symbol.exports != null && symbol.exports.has(ts.InternalSymbolName.ExportEquals)) {
            let exportAlias = symbol.exports.get(ts.InternalSymbolName.ExportEquals);
            if (exportAlias.flags & ts.SymbolFlags.Alias) {
                return typeChecker.getAliasedSymbol(exportAlias);
            }
        }
        return symbol;
    }

    console.log(JSON.stringify({
        type: "project-opened",
        files: config.fileNames.map(file => pathlib.resolve(file)),
    }));
}

function handleCloseProjectCommand(command: CloseProjectCommand) {
    if (state.project == null) {
        console.log(JSON.stringify({
            type: "error",
            message: "No project is open",
        }));
        return;
    }
    state.project.unload();
    state.project = null;
    console.log(JSON.stringify({type: "project-closed"}));
}

function handleGetTypeTableCommand(command: GetTypeTableCommand) {
    console.log(JSON.stringify({
        type: "type-table",
        typeTable: state.typeTable.getTypeTableJson(),
    }));
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
    state.typeTable.restrictedExpansion = getEnvironmentVariable("SEMMLE_TYPESCRIPT_NO_EXPANSION", Boolean, true);
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
        case "open-project":
            handleOpenProjectCommand(req);
            break;
        case "close-project":
            handleCloseProjectCommand(req);
            break;
        case "get-type-table":
            handleGetTypeTableCommand(req);
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
    } else if (pathlib.basename(argument) === "tsconfig.json") {
        handleOpenProjectCommand({
            command: "open-project",
            tsConfig: argument,
            packageEntryPoints: [],
            packageJsonFiles: [],
            sourceRoot: null,
            virtualSourceRoot: null,
        });
        for (let sf of state.project.program.getSourceFiles()) {
            if (pathlib.basename(sf.fileName) === "lib.d.ts") continue;
            handleParseCommand({
                command: "parse",
                filename: sf.fileName,
            }, false);
        }
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
