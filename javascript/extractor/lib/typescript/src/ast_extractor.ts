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
    $symbol?: number;
    $lineStarts?: ReadonlyArray<number>;
}

export interface AugmentedNode extends ts.Node {
    $pos?: any;
    $end?: any;
    $declarationKind?: string;
    $type?: number;
    $symbol?: number;
    $resolvedSignature?: number;
    $overloadIndex?: number;
    $declaredSignature?: number;
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
        console.warn(`Could not compute type of ${ts.SyntaxKind[node.kind]} at ${sourceFile.fileName}:${line+1}:${character+1}`);
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

    let typeChecker = project && project.program.getTypeChecker();
    let typeTable = project && project.typeTable;

    // Associate a symbol with the AST node root, in case it is a module.
    if (typeTable != null) {
        let symbol = typeChecker.getSymbolAtLocation(ast);
        if (symbol != null) {
            ast.$symbol = typeTable.getSymbolId(symbol);
        }
    }

    // Number of conditional type expressions the visitor is currently inside.
    // We disable type extraction inside such type expressions, to avoid complications
    // with `infer` types.
    let insideConditionalTypes = 0;

    visitAstNode(ast);
    function visitAstNode(node: AugmentedNode) {
        if (node.kind === ts.SyntaxKind.ConditionalType) {
            ++insideConditionalTypes;
        }
        ts.forEachChild(node, visitAstNode);
        if (node.kind === ts.SyntaxKind.ConditionalType) {
            --insideConditionalTypes;
        }

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

        if (typeChecker != null && insideConditionalTypes === 0) {
            if (isTypedNode(node)) {
                let contextualType = isContextuallyTypedNode(node)
                    ? typeChecker.getContextualType(node)
                    : null;
                let type = contextualType || tryGetTypeOfNode(typeChecker, node);
                if (type != null) {
                    let parent = node.parent;
                    let unfoldAlias = ts.isTypeAliasDeclaration(parent) && node === parent.type;
                    let id = typeTable.buildType(type, unfoldAlias);
                    if (id != null) {
                        node.$type = id;
                    }
                }
                // Extract the target call signature of a function call.
                // In case the callee is overloaded or generic, this is not something we can
                // derive from the callee type in QL.
                if (ts.isCallOrNewExpression(node)) {
                    let kind = ts.isCallExpression(node) ? ts.SignatureKind.Call : ts.SignatureKind.Construct;
                    let resolvedSignature = typeChecker.getResolvedSignature(node);
                    if (resolvedSignature != null) {
                        let resolvedId = typeTable.getSignatureId(kind, resolvedSignature);
                        if (resolvedId != null) {
                            (node as AugmentedNode).$resolvedSignature = resolvedId;
                        }
                        let declaration = resolvedSignature.declaration;
                        if (declaration != null) {
                            // Find the generic signature, i.e. without call-site type arguments substituted,
                            // but with overloading resolved.
                            let calleeType = typeChecker.getTypeAtLocation(node.expression);
                            if (calleeType != null && declaration != null) {
                                let calleeSignatures = typeChecker.getSignaturesOfType(calleeType, kind);
                                for (let i = 0; i < calleeSignatures.length; ++i) {
                                    if (calleeSignatures[i].declaration === declaration) {
                                        (node as AugmentedNode).$overloadIndex = i;
                                        break;
                                    }
                                }
                            }
                            // Extract the symbol so the declaration can be found from QL.
                            let name = (declaration as any).name;
                            let symbol = name && typeChecker.getSymbolAtLocation(name);
                            if (symbol != null) {
                                (node as AugmentedNode).$symbol = typeTable.getSymbolId(symbol);
                            }
                        }
                    }
                }
            }
            let symbolNode =
                isNamedNodeWithSymbol(node) ? node.name :
                ts.isImportDeclaration(node) ? node.moduleSpecifier :
                ts.isExternalModuleReference(node) ? node.expression :
                null;
            if (symbolNode != null) {
                let symbol = typeChecker.getSymbolAtLocation(symbolNode);
                if (symbol != null) {
                    node.$symbol = typeTable.getSymbolId(symbol);
                }
            }
            if (ts.isTypeReferenceNode(node)) {
                // For type references we inject a symbol on each part of the name.
                // We traverse each node in the name here since we know these are part of
                // a type annotation.  This means we don't have to do it for all identifiers
                // and qualified names, which would extract more information than we need.
                let namePart: (ts.EntityName & AugmentedNode) = node.typeName;
                while (ts.isQualifiedName(namePart)) {
                    let symbol = typeChecker.getSymbolAtLocation(namePart.right);
                    if (symbol != null) {
                        namePart.$symbol = typeTable.getSymbolId(symbol);
                    }

                    // Traverse into the prefix.
                    namePart = namePart.left;
                }
                let symbol = typeChecker.getSymbolAtLocation(namePart);
                if (symbol != null) {
                    namePart.$symbol = typeTable.getSymbolId(symbol);
                }
            }
            if (ts.isFunctionLike(node)) {
                let signature = typeChecker.getSignatureFromDeclaration(node);
                if (signature != null) {
                    let kind = ts.isConstructSignatureDeclaration(node) || ts.isConstructorDeclaration(node)
                            ? ts.SignatureKind.Construct : ts.SignatureKind.Call;
                    let id = typeTable.getSignatureId(kind, signature);
                    if (id != null) {
                        (node as AugmentedNode).$declaredSignature = id;
                    }
                }
            }
        }
    }
}

type NamedNodeWithSymbol = AugmentedNode & (ts.ClassDeclaration | ts.InterfaceDeclaration
    | ts.TypeAliasDeclaration | ts.EnumDeclaration | ts.EnumMember | ts.ModuleDeclaration | ts.FunctionDeclaration
    | ts.MethodDeclaration | ts.MethodSignature);

/**
 * True if the given AST node has a name, and should be associated with a symbol.
 */
function isNamedNodeWithSymbol(node: ts.Node): node is NamedNodeWithSymbol {
    switch (node.kind) {
        case ts.SyntaxKind.ClassDeclaration:
        case ts.SyntaxKind.InterfaceDeclaration:
        case ts.SyntaxKind.TypeAliasDeclaration:
        case ts.SyntaxKind.EnumDeclaration:
        case ts.SyntaxKind.EnumMember:
        case ts.SyntaxKind.ModuleDeclaration:
        case ts.SyntaxKind.FunctionDeclaration:
        case ts.SyntaxKind.MethodDeclaration:
        case ts.SyntaxKind.MethodSignature:
            return true;
    }
    return false;
}

/**
 * True if the given AST node has a type.
 */
function isTypedNode(node: ts.Node): boolean {
    switch (node.kind) {
        case ts.SyntaxKind.ArrayLiteralExpression:
        case ts.SyntaxKind.ArrowFunction:
        case ts.SyntaxKind.AsExpression:
        case ts.SyntaxKind.AwaitExpression:
        case ts.SyntaxKind.BinaryExpression:
        case ts.SyntaxKind.CallExpression:
        case ts.SyntaxKind.ClassExpression:
        case ts.SyntaxKind.ClassDeclaration:
        case ts.SyntaxKind.CommaListExpression:
        case ts.SyntaxKind.ConditionalExpression:
        case ts.SyntaxKind.Constructor:
        case ts.SyntaxKind.DeleteExpression:
        case ts.SyntaxKind.ElementAccessExpression:
        case ts.SyntaxKind.ExpressionStatement:
        case ts.SyntaxKind.ExpressionWithTypeArguments:
        case ts.SyntaxKind.FalseKeyword:
        case ts.SyntaxKind.FunctionDeclaration:
        case ts.SyntaxKind.FunctionExpression:
        case ts.SyntaxKind.GetAccessor:
        case ts.SyntaxKind.Identifier:
        case ts.SyntaxKind.IndexSignature:
        case ts.SyntaxKind.JsxExpression:
        case ts.SyntaxKind.LiteralType:
        case ts.SyntaxKind.MethodDeclaration:
        case ts.SyntaxKind.MethodSignature:
        case ts.SyntaxKind.NewExpression:
        case ts.SyntaxKind.NonNullExpression:
        case ts.SyntaxKind.NoSubstitutionTemplateLiteral:
        case ts.SyntaxKind.NumericLiteral:
        case ts.SyntaxKind.ObjectKeyword:
        case ts.SyntaxKind.ObjectLiteralExpression:
        case ts.SyntaxKind.OmittedExpression:
        case ts.SyntaxKind.ParenthesizedExpression:
        case ts.SyntaxKind.PartiallyEmittedExpression:
        case ts.SyntaxKind.PostfixUnaryExpression:
        case ts.SyntaxKind.PrefixUnaryExpression:
        case ts.SyntaxKind.PropertyAccessExpression:
        case ts.SyntaxKind.RegularExpressionLiteral:
        case ts.SyntaxKind.SetAccessor:
        case ts.SyntaxKind.StringLiteral:
        case ts.SyntaxKind.TaggedTemplateExpression:
        case ts.SyntaxKind.TemplateExpression:
        case ts.SyntaxKind.TemplateHead:
        case ts.SyntaxKind.TemplateMiddle:
        case ts.SyntaxKind.TemplateSpan:
        case ts.SyntaxKind.TemplateTail:
        case ts.SyntaxKind.TrueKeyword:
        case ts.SyntaxKind.TypeAssertionExpression:
        case ts.SyntaxKind.TypeLiteral:
        case ts.SyntaxKind.TypeOfExpression:
        case ts.SyntaxKind.VoidExpression:
        case ts.SyntaxKind.YieldExpression:
            return true;
        default:
            return ts.isTypeNode(node);
    }
}

type ContextuallyTypedNode = (ts.ArrayLiteralExpression | ts.ObjectLiteralExpression) & AugmentedNode;

function isContextuallyTypedNode(node: ts.Node): node is ContextuallyTypedNode {
    let kind = node.kind;
    return kind === ts.SyntaxKind.ArrayLiteralExpression || kind === ts.SyntaxKind.ObjectLiteralExpression;
}
