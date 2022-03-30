
namespace System.CodeDom.Compiler
{
    public interface ICodeCompiler
    {
        CompilerResults CompileAssemblyFromSource(CompilerParameters options, string source);
    }

    public class CodeDomProvider : System.ComponentModel.Component
    {
        public virtual ICodeCompiler CreateCompiler() => null;
    }

    public class CompilerParameters
    {
    }

    public class CompilerResults
    {
        public System.Reflection.Assembly CompiledAssembly { get; set; }
    }
}

namespace Microsoft.CSharp
{
    public class CSharpCodeProvider : System.CodeDom.Compiler.CodeDomProvider
    {
        public override System.CodeDom.Compiler.ICodeCompiler CreateCompiler() => null;
    }
}
