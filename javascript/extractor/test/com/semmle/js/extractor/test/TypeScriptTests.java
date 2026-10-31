package com.semmle.js.extractor.test;

import com.semmle.js.ast.ClassDeclaration;
import com.semmle.js.ast.DeclarationFlags;
import com.semmle.js.ast.ExportNamedDeclaration;
import com.semmle.js.ast.Program;
import com.semmle.js.ast.Token;
import com.semmle.js.ast.VariableDeclaration;
import com.semmle.js.extractor.ExtractionMetrics;
import com.semmle.js.parser.JSParser.Result;
import com.semmle.ts.ast.ExternalModuleDeclaration;
import com.semmle.ts.ast.GlobalAugmentationDeclaration;
import com.semmle.ts.ast.InterfaceDeclaration;
import com.semmle.ts.ast.NamespaceDeclaration;
import com.semmle.ts.extractor.TypeScriptParser;
import java.io.File;
import java.nio.file.Files;
import org.junit.After;
import org.junit.Assert;
import org.junit.Rule;
import org.junit.Test;
import org.junit.rules.TemporaryFolder;

public class TypeScriptTests {
  @Rule public TemporaryFolder folder = new TemporaryFolder();

  private final TypeScriptParser parser = new TypeScriptParser();

  @After
  public void tearDown() {
    parser.killProcess();
  }

  private Program parse(String source) throws Exception {
    File file = folder.newFile("input.ts");
    Files.writeString(file.toPath(), source);
    Result result = parser.parse(file, source, new ExtractionMetrics());
    Assert.assertTrue(result.getErrors().toString(), result.getErrors().isEmpty());
    Assert.assertEquals(Token.Type.EOF, result.getTokens().get(result.getTokens().size() - 1).getType());
    return (Program) result.getAST();
  }

  @Test
  public void namespaceClassifications() throws Exception {
    Program program =
        parse(
            "declare /* a */ global { interface Window {} }\n"
                + "declare\u00a0/* b */\ufeffglobal {}\n"
                + "namespace global {}\n"
                + "module global {}\n"
                + "namespace A.B.C {}\n"
                + "namespace X { namespace Y {} }\n"
                + "declare module \"external\" {}");
    Assert.assertTrue(program.getBody().get(0) instanceof GlobalAugmentationDeclaration);
    Assert.assertTrue(program.getBody().get(1) instanceof GlobalAugmentationDeclaration);
    Assert.assertTrue(program.getBody().get(2) instanceof NamespaceDeclaration);
    Assert.assertTrue(program.getBody().get(3) instanceof NamespaceDeclaration);
    NamespaceDeclaration a = (NamespaceDeclaration) program.getBody().get(4);
    ExportNamedDeclaration exportedB = (ExportNamedDeclaration) a.getBody().get(0);
    NamespaceDeclaration b = (NamespaceDeclaration) exportedB.getDeclaration();
    ExportNamedDeclaration exportedC = (ExportNamedDeclaration) b.getBody().get(0);
    Assert.assertEquals("B", b.getName().getName());
    Assert.assertEquals(
        "C", ((NamespaceDeclaration) exportedC.getDeclaration()).getName().getName());
    NamespaceDeclaration x = (NamespaceDeclaration) program.getBody().get(5);
    Assert.assertTrue(x.getBody().get(0) instanceof NamespaceDeclaration);
    Assert.assertTrue(program.getBody().get(6) instanceof ExternalModuleDeclaration);
  }

  @Test
  public void memberPostfixTokensAndTypeDefaults() throws Exception {
    Program program =
        parse(
            "interface I<T = number> { p?: string; m?(): void; required: T }\n"
                + "class C { p!: string; optional?: number; required: number }");
    InterfaceDeclaration iface = (InterfaceDeclaration) program.getBody().get(0);
    Assert.assertEquals("number", iface.getTypeParameters().get(0).getDefault().getLoc().getSource());
    Assert.assertTrue(DeclarationFlags.isOptional(iface.getBody().get(0).getFlags()));
    Assert.assertTrue(DeclarationFlags.isAbstract(iface.getBody().get(1).getFlags()));
    Assert.assertFalse(DeclarationFlags.isOptional(iface.getBody().get(2).getFlags()));
    ClassDeclaration cls = (ClassDeclaration) program.getBody().get(1);
    var members = cls.getClassDef().getBody().getBody();
    Assert.assertTrue(DeclarationFlags.hasDefiniteAssignmentAssertion(members.get(0).getFlags()));
    Assert.assertFalse(DeclarationFlags.isOptional(members.get(0).getFlags()));
    Assert.assertTrue(DeclarationFlags.isOptional(members.get(1).getFlags()));
    Assert.assertFalse(DeclarationFlags.hasDefiniteAssignmentAssertion(members.get(1).getFlags()));
    Assert.assertFalse(DeclarationFlags.isOptional(members.get(2).getFlags()));
  }

  @Test
  public void variableDeclarationKinds() throws Exception {
    Program program =
        parse("var a; let b; const c = 1; using d = resource(); await using e = resource();");
    String[] kinds = {"var", "let", "const", "using", "using"};
    for (int i = 0; i < kinds.length; ++i) {
      Assert.assertEquals(kinds[i], ((VariableDeclaration) program.getBody().get(i)).getKind());
    }
  }
}
