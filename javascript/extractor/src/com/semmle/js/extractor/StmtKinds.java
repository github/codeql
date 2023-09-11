package com.semmle.js.extractor;

import com.semmle.js.ast.DefaultVisitor;
import com.semmle.js.ast.ForInStatement;
import com.semmle.js.ast.Statement;
import com.semmle.js.ast.VariableDeclaration;
import com.semmle.util.exception.CatastrophicError;
import java.util.LinkedHashMap;
import java.util.Map;

/** Map from SpiderMonkey statement types to the numeric kinds used in the DB scheme. */
public class StmtKinds {
  private static final Map<String, Integer> stmtKinds = new LinkedHashMap<String, Integer>();

  static {
    stmtKinds.put("EmptyStatement", 0);
    stmtKinds.put("BlockStatement", 1);
    stmtKinds.put("ExpressionStatement", 2);
    stmtKinds.put("IfStatement", 3);
    stmtKinds.put("LabeledStatement", 4);
    stmtKinds.put("BreakStatement", 5);
    stmtKinds.put("ContinueStatement", 6);
    stmtKinds.put("WithStatement", 7);
    stmtKinds.put("SwitchStatement", 8);
    stmtKinds.put("ReturnStatement", 9);
    stmtKinds.put("ThrowStatement", 10);
    stmtKinds.put("TryStatement", 11);
    stmtKinds.put("WhileStatement", 12);
    stmtKinds.put("DoWhileStatement", 13);
    stmtKinds.put("ForStatement", 14);
    stmtKinds.put("ForInStatement", 15);
    stmtKinds.put("DebuggerStatement", 16);
    stmtKinds.put("FunctionDeclaration", 17);
    stmtKinds.put("SwitchCase", 19);
    stmtKinds.put("CatchClause", 20);
    stmtKinds.put("ForOfStatement", 21);
    stmtKinds.put("LetStatement", 24);
    stmtKinds.put("ForEachStatement", 25);
    stmtKinds.put("ClassDeclaration", 26);
    stmtKinds.put("ImportDeclaration", 27);
    stmtKinds.put("ExportAllDeclaration", 28);
    stmtKinds.put("ExportDefaultDeclaration", 29);
    stmtKinds.put("ExportNamedDeclaration", 30);
    stmtKinds.put("NamespaceDeclaration", 31);
    stmtKinds.put("ImportWholeDeclaration", 32);
    stmtKinds.put("ExportWholeDeclaration", 33);
    stmtKinds.put("InterfaceDeclaration", 34);
    stmtKinds.put("TypeAliasDeclaration", 35);
    stmtKinds.put("EnumDeclaration", 36);
    stmtKinds.put("ExternalModuleDeclaration", 37);
    stmtKinds.put("ExportAsNamespaceDeclaration", 38);
    stmtKinds.put("GlobalAugmentationDeclaration", 39);
  }

  private static final Map<String, Integer> declKinds = new LinkedHashMap<String, Integer>();

  static {
    declKinds.put("var", 18);
    declKinds.put("const", 22);
    declKinds.put("let", 23);
    declKinds.put("using", 40);
  }

  public static int getStmtKind(final Statement stmt) {
    Integer kind =
        stmt.accept(
            new DefaultVisitor<Void, Integer>() {
              @Override
              public Integer visit(Statement nd, Void v) {
                return stmtKinds.get(nd.getType());
              }

              @Override
              public Integer visit(VariableDeclaration nd, Void v) {
                return declKinds.get(nd.getKind());
              }

              @Override
              public Integer visit(ForInStatement nd, Void c) {
                return stmtKinds.get(nd.isEach() ? "ForEachStatement" : nd.getType());
              }
            },
            null);
    if (kind == null) throw new CatastrophicError("Unsupported statement kind: " + stmt.getClass());
    return kind;
  }
}
