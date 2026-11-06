import assert from "node:assert/strict";
import { execFileSync, spawn } from "node:child_process";
import { copyFileSync, mkdtempSync, rmSync, symlinkSync, writeFileSync } from "node:fs";
import { tmpdir } from "node:os";
import { dirname, join, resolve } from "node:path";
import { createInterface } from "node:readline";
import { after, test } from "node:test";
import { fileURLToPath, pathToFileURL } from "node:url";
import { API, JsxEmit } from "typescript/sync";
import { SyntaxKind, NodeFlags } from "typescript/ast";

const root = resolve(dirname(fileURLToPath(import.meta.url)), "..");
const directory = mkdtempSync(join(tmpdir(), "codeql-typescript-wrapper-"));
const entryPoint = join(directory, "main.js");
copyFileSync(join(root, "package.json"), join(directory, "package.json"));
symlinkSync(join(root, "node_modules"), join(directory, "node_modules"), "dir");
for (const name of ["main.js", "ast_extractor.js"]) {
    copyFileSync(join(root, "build", name), join(directory, name));
}
const { extractAst } = await import(pathToFileURL(join(directory, "ast_extractor.js")));
const api = new API();

after(() => {
    try {
        api.close();
    } finally {
        rmSync(directory, { recursive: true });
    }
});

function extract(text, extension = ".ts") {
    const filename = join(directory, "input" + extension);
    writeFileSync(filename, text);
    const program = api.createProgram([filename], {
        noResolve: true, noLib: true, jsx: JsxEmit.Preserve, experimentalDecorators: true,
    });
    try {
        return JSON.parse(JSON.stringify(extractAst(program.getSourceFile(filename), program.getSyntacticDiagnostics())));
    } finally {
        program.dispose();
        api.clearSourceFileCache();
    }
}

function declaration(ast, index = 0) {
    return ast.statements[index].declarationList.declarations[0];
}

test("AST getters are projected without native implementation details or unrelated booleans", () => {
    const text = "// comment\r\nexport const \\u0061 = \"\u{1f600}\";\r\nlet b = 2; var c = 3;";
    const ast = extract(text);
    const first = declaration(ast);
    assert.equal(first.name.text, "a");
    assert.equal(first.name.$pos, text.indexOf("\\u0061"));
    assert.equal(first.initializer.text, "\u{1f600}");
    assert.equal(first.initializer.$end, text.indexOf('";') + 1);
    assert.equal(ast.statements[0].modifiers[0].kind, SyntaxKind.ExportKeyword);
    assert.deepEqual(ast.$lineStarts, [0, text.indexOf("export"), text.indexOf("let")]);
    assert.deepEqual(ast.statements.map(statement => statement.declarationList.flags & NodeFlags.BlockScoped),
        [NodeFlags.Const, NodeFlags.Let, NodeFlags.None]);
    assert.deepEqual(ast.parseDiagnostics, []);
    const json = JSON.stringify(ast);
    for (const field of ["parent", "view", "sourceFile", "isTypeOnly", "isTypeOf", "isExportEquals"]) {
        assert(!json.includes(`"${field}":`), field);
    }
});

test("per-kind property lists retain optional fields absent from earlier nodes", () => {
    const ast = extract(`
        let empty;
        let definite!: number;
        let initialized: number = 1;
        function plain() {}
        export async function* rich<T extends object = {}>(...args: T[]): Iterable<T> { yield args[0]; }
    `);
    assert.deepEqual(ast.parseDiagnostics, []);
    assert(!("type" in declaration(ast)));
    assert(!("initializer" in declaration(ast)));
    assert.equal(declaration(ast, 1).exclamationToken.kind, SyntaxKind.ExclamationToken);
    assert.equal(declaration(ast, 1).type.kind, SyntaxKind.NumberKeyword);
    assert.equal(declaration(ast, 2).initializer.text, "1");
    const [plain, rich] = ast.statements.slice(3);
    assert(!("modifiers" in plain));
    assert(!("typeParameters" in plain));
    assert.deepEqual(rich.modifiers.map(modifier => modifier.kind), [SyntaxKind.ExportKeyword, SyntaxKind.AsyncKeyword]);
    assert.equal(rich.asteriskToken.kind, SyntaxKind.AsteriskToken);
    assert.equal(rich.typeParameters[0].constraint.kind, SyntaxKind.ObjectKeyword);
    assert.equal(rich.typeParameters[0].defaultType.kind, SyntaxKind.TypeLiteral);
    assert.equal(rich.parameters[0].dotDotDotToken.kind, SyntaxKind.DotDotDotToken);
    assert.equal(rich.type.typeName.text, "Iterable");
    assert.equal(rich.body.statements[0].expression.kind, SyntaxKind.YieldExpression);
});

test("scalar getters are retained alongside per-kind child properties", () => {
    const ast = extract(`
        import ordinary from "ordinary";
        import type { T } from "types";
        import source wasm from "./module.wasm";
        const positive = +value;
        const negative = -value;
        value++;
        value--;
        type Keys = keyof T;
        function construct() { return new.target; }
        const meta = import.meta;
        interface I extends Base {}
        class C extends Base implements I {}
    `);
    assert.deepEqual(ast.parseDiagnostics, []);
    assert(!("phaseModifier" in ast.statements[0].importClause));
    assert.equal(ast.statements[1].importClause.phaseModifier, SyntaxKind.TypeKeyword);
    assert.equal(ast.statements[2].importClause.phaseModifier, SyntaxKind.SourceKeyword);
    assert.equal(declaration(ast, 3).initializer.operator, SyntaxKind.PlusToken);
    assert.equal(declaration(ast, 4).initializer.operator, SyntaxKind.MinusToken);
    assert.equal(ast.statements[5].expression.operator, SyntaxKind.PlusPlusToken);
    assert.equal(ast.statements[6].expression.operator, SyntaxKind.MinusMinusToken);
    assert.equal(ast.statements[7].type.operator, SyntaxKind.KeyOfKeyword);
    assert.equal(ast.statements[8].body.statements[0].expression.keywordToken, SyntaxKind.NewKeyword);
    assert.equal(declaration(ast, 9).initializer.keywordToken, SyntaxKind.ImportKeyword);
    assert.equal(ast.statements[10].heritageClauses[0].token, SyntaxKind.ExtendsKeyword);
    assert.deepEqual(ast.statements[11].heritageClauses.map(clause => clause.token),
        [SyntaxKind.ExtendsKeyword, SyntaxKind.ImplementsKeyword]);
});

test("known syntax kinds do not probe unrelated child getters", () => {
    const ast = extractAst({
        kind: SyntaxKind.SourceFile, flags: 0, pos: 0, end: 0, text: "", statements: [],
        forEachChild() {},
        getLineStarts() { return [0]; },
        get argument() { throw new Error("Unrelated child property was read"); },
    }, []);
    assert.deepEqual(ast.statements, []);
    assert.equal(ast.text, "");
});

test("syntax error messages and UTF-16 offsets retain the Java-facing response", () => {
    const text = 'const emoji = "\u{1f600}";\r\nconst broken = ;\r\n';
    const ast = extract(text);
    assert.deepEqual(ast.parseDiagnostics, [{
        messageText: "Expression expected.", $pos: text.lastIndexOf(";"),
    }]);
    assert.deepEqual(ast.$lineStarts, [0, text.indexOf("const broken"), text.length]);
});

test("optional members, definite assignment, type defaults, and decorators use native fields", () => {
    const ast = extract(`
        type T<U = number> = U;
        interface I { p?: string; m?(): void }
        @sealed export class C {
            @field p!: string;
            @method m(@parameter publicArg?: number) {}
        }
    `);
    assert.deepEqual(ast.parseDiagnostics, []);
    assert.equal(ast.statements[0].typeParameters[0].defaultType.kind, SyntaxKind.NumberKeyword);
    const [property, method] = ast.statements[1].members;
    assert.equal(property.postfixToken.kind, SyntaxKind.QuestionToken);
    assert.equal(method.postfixToken.kind, SyntaxKind.QuestionToken);
    const cls = ast.statements[2];
    assert.deepEqual(cls.modifiers.map(modifier => modifier.kind), [SyntaxKind.Decorator, SyntaxKind.ExportKeyword]);
    assert.equal(cls.members[0].postfixToken.kind, SyntaxKind.ExclamationToken);
    assert.equal(cls.members[0].modifiers[0].kind, SyntaxKind.Decorator);
    assert.equal(cls.members[1].parameters[0].modifiers[0].kind, SyntaxKind.Decorator);
    assert.equal(cls.members[1].parameters[0].questionToken.kind, SyntaxKind.QuestionToken);
});

test("global augmentations and dotted namespaces need no synthetic flags", () => {
    const ast = extract(`
        declare /* a */ global { interface Window {} }
        namespace global {}
        module global {}
        namespace A.B.C {}
        namespace A { namespace B {} }
        declare module "external" {}
    `);
    assert.deepEqual(ast.parseDiagnostics, []);
    const [global, namedGlobal, moduleGlobal, dotted, nested, external] = ast.statements;
    assert.equal(global.name.text, "global");
    assert.equal(namedGlobal.name.text, "global");
    assert.equal(moduleGlobal.name.text, "global");
    assert.equal(dotted.body.kind, SyntaxKind.ModuleDeclaration);
    assert.equal(dotted.body.body.kind, SyntaxKind.ModuleDeclaration);
    assert.equal(dotted.body.flags, NodeFlags.None);
    assert.equal(dotted.body.body.flags, NodeFlags.None);
    assert.equal(nested.body.statements[0].flags, NodeFlags.None);
    assert.equal(external.name.text, "external");
});

test("import attributes and type-only phases use native property names", () => {
    const ast = extract(`
        import type { X } from "types";
        import { type Y, Z } from "types";
        import data from "data" with { type: "json" };
        export { data } from "data" with { type: "json" };
        type T = typeof import("data", { with: { type: "json" } });
        export type { X };
    `);
    assert.deepEqual(ast.parseDiagnostics, []);
    assert.equal(ast.statements[0].importClause.phaseModifier, SyntaxKind.TypeKeyword);
    assert.equal(ast.statements[1].importClause.namedBindings.elements[0].isTypeOnly, true);
    assert.equal(ast.statements[1].importClause.namedBindings.elements[1].isTypeOnly, false);
    for (const node of [ast.statements[2], ast.statements[3], ast.statements[4].type]) {
        assert.equal(node.attributes.attributes[0].name.text, "type");
        assert.equal(node.attributes.attributes[0].value.text, "json");
    }
    assert.equal(ast.statements[4].type.isTypeOf, true);
    assert.equal(ast.statements[5].isTypeOnly, true);
});

test("regex, nested templates, tagged templates, type templates and operators are rescanned", () => {
    const text = 'const x = `a${/a+/gi.test(s) ? tag`b${v}c` : `d${w}e`}f`; '
        + 'type T = `a${string}b`; const y = a >= b >> c >>> d; a >>= b; a >>>= b;';
    const ast = extract(text);
    assert.deepEqual(ast.parseDiagnostics, []);
    const rescannedTexts = ["/a+/gi", "}c`", "}e`", "}f`", "}b`", ">=", ">>", ">>>", ">>=", ">>>="];
    const tokens = ast.$tokens.filter(token => rescannedTexts.includes(token.text));
    assert.deepEqual(tokens.map(token => token.text), ["/a+/gi", "}c`", "}e`", "}f`", "}b`", ">=", ">>", ">>>", ">>=", ">>>="]);
    assert.deepEqual(tokens.map(token => token.kind), [
        SyntaxKind.SlashToken,
        ...Array(4).fill(SyntaxKind.CloseBraceToken),
        ...Array(5).fill(SyntaxKind.GreaterThanToken),
    ]);
    for (const token of tokens) {
        assert.equal(text.slice(token.tokenPos, token.tokenPos + token.text.length), token.text);
    }
    assert.equal(ast.$tokens.at(-1).kind, SyntaxKind.EndOfFile);
    assert.equal(ast.$tokens.at(-1).tokenPos, text.length);
});

test("interface heritage preserves native type references", () => {
    const ast = extract(`
        interface I extends A, N.B<string> {}
        class C extends Base<number> implements A, N.B<string> {}
    `);
    assert.deepEqual(ast.parseDiagnostics, []);
    const [iface, cls] = ast.statements;
    for (const heritage of [iface.heritageClauses[0], cls.heritageClauses[1]]) {
        assert.equal(heritage.types[0].kind, SyntaxKind.TypeReference);
        assert.equal(heritage.types[0].typeName.text, "A");
        assert.equal(heritage.types[1].typeName.right.text, "B");
        assert.equal(heritage.types[1].typeArguments[0].kind, SyntaxKind.StringKeyword);
        assert(!("expression" in heritage.types[1]));
    }
    assert.equal(cls.heritageClauses[0].types[0].expression.text, "Base");
});

test("legacy import assertions retain attributes without hiding genuine syntax errors", () => {
    const source = `
        import data from "data" assert { type: "json" };
        export { data } from "data" assert { type: "json" };
        const pattern = /data/g;
    `;
    const ast = extract(source);
    assert.deepEqual(ast.parseDiagnostics, []);
    for (const node of ast.statements.slice(0, 2)) {
        assert.equal(node.attributes.attributes[0].name.text, "type");
        assert.equal(node.attributes.attributes[0].value.text, "json");
    }
    assert(ast.$tokens.some(token => token.kind === SyntaxKind.SlashToken && token.text === "/data/g"));
    const invalid = extract(source + "const broken = ;");
    assert.equal(invalid.parseDiagnostics.length, 1);
    assert.equal(invalid.parseDiagnostics[0].messageText, "Expression expected.");
    assert.equal(invalid.parseDiagnostics[0].$pos, (source + "const broken = ;").lastIndexOf(";"));
});

test("TSX children, attributes, and positions survive projection", () => {
    const ast = extract('const view = <><div title="hi">{value}</div><C {...props}/></>;', ".tsx");
    assert.deepEqual(ast.parseDiagnostics, []);
    const fragment = declaration(ast).initializer;
    assert.equal(fragment.kind, SyntaxKind.JsxFragment);
    assert.equal(fragment.children[0].openingElement.attributes.properties[0].name.text, "title");
    assert.equal(fragment.children[0].children[0].expression.text, "value");
    assert.equal(fragment.children[1].kind, SyntaxKind.JsxSelfClosingElement);
    assert.equal(fragment.children[1].attributes.properties[0].expression.text, "props");
});

test("the actual wrapper handles metadata, prepared files, out-of-order parsing, reset and quit", async () => {
    const first = join(directory, "first.ts");
    const second = join(directory, "second.ts");
    writeFileSync(first, "const first = 1;");
    writeFileSync(second, "let second = 2;");
    const child = spawn(process.execPath, [entryPoint], { stdio: ["pipe", "pipe", "pipe"] });
    let stderr = "";
    const lines = createInterface({ input: child.stdout })[Symbol.asyncIterator]();
    child.stderr.setEncoding("utf8").on("data", data => { stderr += data; });
    const exited = new Promise((accept, reject) => {
        child.on("error", reject);
        child.on("close", (code, signal) => {
            try {
                assert.equal(signal, null);
                assert.equal(code, 0, stderr);
                accept();
            } catch (error) {
                reject(error);
            }
        });
    });
    async function request(command) {
        child.stdin.write(JSON.stringify(command) + "\n");
        const line = await lines.next();
        assert.equal(line.done, false, stderr);
        return JSON.parse(line.value);
    }
    try {
        const metadata = await request({ command: "get-metadata" });
        assert.equal(metadata.type, "metadata");
        assert.deepEqual(metadata.syntaxKinds, SyntaxKind);
        assert.deepEqual(metadata.nodeFlags, NodeFlags);
        assert(!("EndOfFileToken" in metadata.syntaxKinds));
        assert(!("GlobalAugmentation" in metadata.nodeFlags));
        assert.deepEqual(await request({ command: "prepare-files", filenames: [first, second] }), { type: "ok" });
        assert.equal(declaration((await request({ command: "parse", filename: first })).ast).name.text, "first");
        assert.equal(declaration((await request({ command: "parse", filename: second })).ast).name.text, "second");
        await request({ command: "prepare-files", filenames: [first, second] });
        assert.equal(declaration((await request({ command: "parse", filename: second })).ast).name.text, "second");
        assert.deepEqual(await request({ command: "reset" }), { type: "reset-done" });
        assert.equal(declaration((await request({ command: "parse", filename: first })).ast).name.text, "first");
        child.stdin.end('{"command":"quit"}\n');
        await exited;
        assert.equal(stderr, "");
    } finally {
        child.stdin.destroy();
        child.kill();
        await exited;
    }
});

test("single-file invocation flushes JSON and reports missing files", () => {
    const filename = join(directory, "command-line.ts");
    writeFileSync(filename, "const value = 1;");
    const options = {
        encoding: "utf8",
    };
    const response = JSON.parse(execFileSync(process.execPath, [entryPoint, filename], options));
    assert.equal(declaration(response.ast).name.text, "value");
    assert.throws(() => execFileSync(process.execPath, [entryPoint, resolve(directory, "missing.ts")], {
        ...options, stdio: ["ignore", "pipe", "pipe"],
    }), error => {
        assert.equal(error.stdout, "");
        assert.match(error.stderr, /TypeScript did not return a source file/);
        return true;
    });
});
