import * as ts from "./typescript";
import { Project } from "./common";

/**
 * Interface that exposes some internal properties we rely on, as well as
 * some properties we add ourselves.
 */
export interface AugmentedSourceFile extends ts.SourceFile {
    parseDiagnostics?: any[];
    /** Internal property that we expose as a workaround. */
    redirectInfo?: object | null;
    $tokens?: Token[];
    $lineStarts?: ReadonlyArray<number>;
}

export interface AugmentedNode extends ts.Node {
    $pos?: any;
    $end?: any;
    $declarationKind?: string;
}

export type AugmentedPos = number;

export interface Token {
    kind: ts.SyntaxKind;
    tokenPos: AugmentedPos;
    text: string;
}

function hasOwnProperty(o: object, p: string) {
    return o && Object.prototype.hasOwnProperty.call(o, p);
}

// build our own copy of `ts.SyntaxKind` without `First*`/`Last*` markers
let SyntaxKind: { [id: number]: string } = [];
for (let p in ts.SyntaxKind) {
    if (!hasOwnProperty(ts.SyntaxKind, p)) {
        continue;
    }
    // skip numeric indices
    if (+p === +p) {
        continue;
    }
    // skip `First*`/`Last*`
    if (p.substring(0, 5) === "First" || p.substring(0, 4) === "Last") {
        continue;
    }
    SyntaxKind[ts.SyntaxKind[p] as any] = p;
}

let skipWhiteSpace = /(?:\s|\/\/.*|\/\*[^]*?\*\/)*/g;

/**
 * Invokes the given callback for every AST node in the given tree.
 */
function forEachNode(ast: ts.Node, callback: (node: ts.Node) => void) {
    function visit(node: ts.Node) {
        ts.forEachChild(node, visit);
        callback(node);
    }
    visit(ast);
}

function tryGetTypeOfNode(typeChecker: ts.TypeChecker, node: AugmentedNode): ts.Type | null {
    try {
        return typeChecker.getTypeAtLocation(node);
    } catch (e) {
        let sourceFile = node.getSourceFile();
        let { line, character } = sourceFile.getLineAndCharacterOfPosition(node.pos);
        console.warn(`Could not compute type of ${ts.SyntaxKind[node.kind]} at ${sourceFile.fileName}:${line + 1}:${character + 1}`);
        return null;
    }
}

export function augmentAst(ast: AugmentedSourceFile, code: string, project: Project | null) {
    ast.$lineStarts = ast.getLineStarts();

    /**
     * Converts a numeric offset to the value expected by the Java counterpart of the extractor.
     */
    function augmentPos(pos: number, shouldSkipWhitespace?: boolean): AugmentedPos {
        // skip over leading spaces/comments
        if (shouldSkipWhitespace) {
            skipWhiteSpace.lastIndex = pos;
            pos += skipWhiteSpace.exec(code)[0].length;
        }
        return pos;
    }

    // Find the position of all tokens where the scanner requires parse-tree information.
    // At these offsets, a call to `scanner.reScanX` is required.
    type RescanEvent = () => void;
    let reScanEvents: RescanEvent[] = [];
    let reScanEventPos: number[] = [];
    let scanner = ts.createScanner(ts.ScriptTarget.ES2015, false, 1, code);
    let reScanSlashToken = scanner.reScanSlashToken.bind(scanner);
    let reScanTemplateToken = scanner.reScanTemplateToken.bind(scanner);
    let reScanGreaterToken = scanner.reScanGreaterToken.bind(scanner);
    if (!ast.parseDiagnostics || ast.parseDiagnostics.length === 0) {
        forEachNode(ast, node => {
            if (ts.isRegularExpressionLiteral(node)) {
                reScanEventPos.push(node.getStart(ast, false));
                reScanEvents.push(reScanSlashToken);
            }
            if (ts.isTemplateMiddle(node) || ts.isTemplateTail(node)) {
                reScanEventPos.push(node.getStart(ast, false));
                reScanEvents.push(reScanTemplateToken);
            }
            if (ts.isBinaryExpression(node)) {
                let operator = node.operatorToken;
                switch (operator.kind) {
                    case ts.SyntaxKind.GreaterThanEqualsToken:
                    case ts.SyntaxKind.GreaterThanGreaterThanEqualsToken:
                    case ts.SyntaxKind.GreaterThanGreaterThanGreaterThanEqualsToken:
                    case ts.SyntaxKind.GreaterThanGreaterThanGreaterThanToken:
                    case ts.SyntaxKind.GreaterThanGreaterThanToken:
                        reScanEventPos.push(operator.getStart(ast, false));
                        reScanEvents.push(reScanGreaterToken);
                        break;
                }
            }
        });
    }

    reScanEventPos.push(Infinity);

    // add tokens and comments to the AST
    ast.$tokens = [];
    let rescanEventIndex = 0;
    let nextRescanPosition = reScanEventPos[0];
    let tk;
    do {
        tk = scanner.scan();
        if (scanner.getTokenPos() === nextRescanPosition) {
            let callback = reScanEvents[rescanEventIndex];
            callback();
            ++rescanEventIndex;
            nextRescanPosition = reScanEventPos[rescanEventIndex];
        }
        ast.$tokens.push({
            kind: tk,
            tokenPos: augmentPos(scanner.getTokenPos()),
            text: scanner.getTokenText(),
        });
    } while (tk !== ts.SyntaxKind.EndOfFileToken);

    if (ast.parseDiagnostics) {
        ast.parseDiagnostics.forEach(d => {
            delete d.file;
            d.$pos = augmentPos(d.start);
        });
    }

    visitAstNode(ast);
    function visitAstNode(node: AugmentedNode) {
        ts.forEachChild(node, visitAstNode);

        // fill in line/column info
        if ("pos" in node) {
            node.$pos = augmentPos(node.pos, true);
        }
        if ("end" in node) {
            node.$end = augmentPos(node.end);
        }

        if (ts.isVariableDeclarationList(node as any)) {
            let tz = ts as any;
            if (typeof tz.isLet === "function" && tz.isLet(node) || (node.flags & ts.NodeFlags.Let)) {
                node.$declarationKind = "let";
            } else if (typeof tz.isConst === "function" && tz.isConst(node) || (node.flags & ts.NodeFlags.Const)) {
                node.$declarationKind = "const";
            } else {
                node.$declarationKind = "var";
            }
        }
    }
}
