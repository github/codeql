using Xunit;
using System.IO;
using System.Text;
using Microsoft.CodeAnalysis;
using Microsoft.CodeAnalysis.CSharp;
using Semmle.Extraction.CSharp.StubGenerator;

namespace Semmle.Extraction.Tests;
/// <summary>
/// Tests for the stub generator.
/// 
/// These tests can be used to more easily step debug the stub generator SymbolVisitor.
/// </summary>
public class StubGeneratorTests
{
    [Fact]
    public void StubGeneratorFieldTest()
    {
        // Setup
        const string source = @"
public class MyTest {
    public static readonly int MyField1;
    public const string MyField2 = ""hello"";
    }
";

        // Execute
        var stub = GenerateStub(source);

        // Verify
        const string expected = @"public class MyTest {
public static readonly int MyField1;
public const string MyField2 = default;
}
";
        Assert.Equal(expected, stub);
    }

    [Fact]
    public void StubGeneratorMethodTest()
    {
        // Setup
        const string source = @"
public class MyTest {
    public int M1(string arg1) { return 0; }
}";

        // Execute
        var stub = GenerateStub(source);

        // Verify
        const string expected = @"public class MyTest {
public int M1(string arg1) => throw null;
}
";
        Assert.Equal(expected, stub);
    }

    [Fact]
    public void StubGeneratorRefReadonlyParameterTest()
    {
        // Setup
        const string source = @"
public class MyTest {
    public int M1(ref readonly Guid guid) { return 0; }
}";

        // Execute
        var stub = GenerateStub(source);

        // Verify
        const string expected = @"public class MyTest {
public int M1(ref readonly Guid guid) => throw null;
}
";
        Assert.Equal(expected, stub);
    }

    [Fact]
    public void StubGeneratorEscapeMethodName()
    {
        // Setup
        const string source = @"
public class MyTest {
    public int @default() { return 0; }
}";

        // Execute
        var stub = GenerateStub(source);

        // Verify
        const string expected = @"public class MyTest {
public int @default() => throw null;
}
";
        Assert.Equal(expected, stub);
    }

    private static string GenerateStub(string source)
    {
        var st = CSharpSyntaxTree.ParseText(source);
        var compilation = CSharpCompilation.Create(null, new[] { st });
        var sb = new StringBuilder();
        var visitor = new StubVisitor(new StringWriter(sb) { NewLine = "\n" }, new RelevantSymbolStub());
        compilation.GlobalNamespace.Accept(visitor);
        return sb.ToString();
    }

    private class RelevantSymbolStub : IRelevantSymbol
    {
        public bool IsRelevantNamedType(INamedTypeSymbol symbol) => true;
        public bool IsRelevantNamespace(INamespaceSymbol symbol) => true;
    }
}
