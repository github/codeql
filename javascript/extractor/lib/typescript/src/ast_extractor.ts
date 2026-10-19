import { createRequire } from "node:module";
import { dirname, join } from "node:path";
import { pathToFileURL } from "node:url";
import { SyntaxKind } from "typescript/ast";
import * as ts from "typescript/ast";
import type { Diagnostic } from "typescript/sync";

export type JsonValue = string | number | boolean | JsonObject | JsonValue[];
export interface JsonObject {
    [property: string]: JsonValue;
}

/** Child and scalar properties consumed by the Java AST converter. */
const astProperties = [
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
    "declarationList",
    "declarations",
    "defaultType",
    "dotDotDotToken",
    "elements",
    "elementType",
    "elseStatement",
    "exclamationToken",
    "exportClause",
    "expression",
    "exprName",
    "extendsType",
    "falseType",
    "finallyBlock",
    "head",
    "heritageClauses",
    "importClause",
    "incrementor",
    "indexType",
    "initializer",
    "keywordToken",
    "label",
    "left",
    "literal",
    "members",
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
    "phaseModifier",
    "postfixToken",
    "properties",
    "propertyName",
    "qualifier",
    "questionDotToken",
    "questionToken",
    "right",
    "statement",
    "statements",
    "tag",
    "tagName",
    "template",
    "templateSpans",
    "text",
    "thenStatement",
    "token",
    "trueType",
    "tryBlock",
    "type",
    "typeArguments",
    "typeName",
    "typeParameter",
    "typeParameters",
    "types",
    "value",
    "variableDeclaration",
    "whenFalse",
    "whenTrue",
];

const require = createRequire(import.meta.url);
const packageRoot = dirname(require.resolve("typescript/package.json"));

// NOTE: Importing this file directly from the `typescript` package is a bit
// hacky, but the child properties are not exposed through the public API.
const { childProperties } = await import(
    pathToFileURL(join(packageRoot, "dist/api/node/protocol.generated.js")).href);

const scalarAstProperties = ["keywordToken", "operator", "phaseModifier", "text", "token"];
const astPropertiesByKind = {} as Record<ts.SyntaxKind, readonly string[]>;
for (const kind of Object.values(SyntaxKind)) {
    if (typeof kind === "number" && kind !== SyntaxKind.Count) {
        const children = childProperties[kind] ?? [];
        astPropertiesByKind[kind] = astProperties.filter(property =>
            scalarAstProperties.includes(property) || children.includes(property));
    }
}

const skipWhiteSpace = /(?:\s|\/\/.*|\/\*[^]*?\*\/)*/g;

export function extractAst(ast: ts.SourceFile, diagnostics: readonly Diagnostic[]): JsonObject {
    const code = ast.text;
    // The native parser still builds assertion ASTs, but now diagnoses this formerly accepted syntax.
    const parseDiagnostics = diagnostics.filter(diagnostic => diagnostic.code !== 2880);

    function augmentPos(pos: number): number {
        skipWhiteSpace.lastIndex = pos;
        return pos + skipWhiteSpace.exec(code)![0].length;
    }

    function projectValue(value: unknown): JsonValue {
        if (Array.isArray(value)) return Array.from(value, projectValue);
        if (typeof value === "string" || typeof value === "number" || typeof value === "boolean") {
            return value;
        }
        if (value != null && typeof value === "object" && "forEachChild" in value) {
            return projectNode(value as ts.Node);
        }
        throw new Error("Unexpected TypeScript AST property value");
    }

    function projectNode(node: ts.Node): JsonObject {
        const result: JsonObject = {
            kind: node.kind,
            flags: node.flags,
            $pos: augmentPos(node.pos),
            $end: node.end,
        };
        const properties = node as ts.Node & { [property: string]: unknown };
        for (const property of astPropertiesByKind[node.kind]) {
            const value = properties[property];
            if (value != null) result[property] = projectValue(value);
        }

        // Native nodes share boolean getters even on kinds where they are not meaningful.
        if (ts.isExportAssignment(node)) result.isExportEquals = node.isExportEquals;
        if (ts.isExportDeclaration(node) || ts.isImportEqualsDeclaration(node)
            || ts.isImportSpecifier(node) || ts.isExportSpecifier(node)) {
            result.isTypeOnly = node.isTypeOnly;
        }
        if (ts.isImportTypeNode(node)) result.isTypeOf = node.isTypeOf;

        return result;
    }

    const result = projectNode(ast);
    result.$lineStarts = Array.from(ast.getLineStarts());
    result.$tokens = extractTokens(ast, parseDiagnostics.length === 0);
    result.parseDiagnostics = parseDiagnostics.map(diagnostic => ({
        messageText: diagnostic.text,
        $pos: diagnostic.pos,
    }));
    return result;
}

function extractTokens(ast: ts.SourceFile, rescan: boolean): JsonObject[] {
    const scanner = ts.createScanner(false, ts.LanguageVariant.JSX, ast.text);
    const rescans = new Map<number, () => ts.SyntaxKind>();
    if (rescan) visit(ast);

    function visit(node: ts.Node): void {
        node.forEachChild(visit);
        if (ts.isRegularExpressionLiteral(node)) {
            rescans.set(node.getStart(ast), () => scanner.reScanSlashToken());
        } else if (ts.isTemplateMiddle(node) || ts.isTemplateTail(node)) {
            const template = node.parent.parent;
            const tagged = ts.isTemplateExpression(template) && ts.isTaggedTemplateExpression(template.parent);
            rescans.set(node.getStart(ast), () => scanner.reScanTemplateToken(tagged));
        } else if (ts.isBinaryExpression(node)) {
            const operator = node.operatorToken;
            switch (operator.kind) {
                case ts.SyntaxKind.GreaterThanEqualsToken:
                case ts.SyntaxKind.GreaterThanGreaterThanEqualsToken:
                case ts.SyntaxKind.GreaterThanGreaterThanGreaterThanEqualsToken:
                case ts.SyntaxKind.GreaterThanGreaterThanGreaterThanToken:
                case ts.SyntaxKind.GreaterThanGreaterThanToken:
                    rescans.set(operator.getStart(ast), () => scanner.reScanGreaterToken());
                    break;
            }
        }
    }

    const tokens: JsonObject[] = [];
    let kind: ts.SyntaxKind;
    do {
        kind = scanner.scan();
        const callback = rescans.get(scanner.getTokenStart());
        // Keep the pre-rescan kind, as in the original Java-facing token protocol.
        if (callback != null) callback();
        tokens.push({
            kind,
            tokenPos: scanner.getTokenStart(),
            text: scanner.getTokenText(),
        });
    } while (kind !== ts.SyntaxKind.EndOfFile);
    return tokens;
}
