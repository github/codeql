// semmle-extractor-options: ${testdir}/../../../resources/stubs/System.Web.cs /r:System.Collections.Specialized.dll ${testdir}/../../../resources/stubs/Microsoft.CSharp.cs /r:System.ComponentModel.Primitives.dll ${testdir}/../../../resources/stubs/System.Windows.cs

using Microsoft.CSharp;
using Microsoft.CodeAnalysis.CSharp.Scripting;
using System;
using System.CodeDom.Compiler;
using System.Reflection;
using System.Web;

namespace Microsoft.CodeAnalysis.CSharp.Scripting
{
    public static class CSharpScript
    {
        public static void EvaluateAsync(string code)
        {
            // Dummy implementation
        }
    }
}

public class CommandInjectionHandler : IHttpHandler
{
    public void ProcessRequest(HttpContext ctx)
    {
        string code = ctx.Request.QueryString["code"];
        CSharpCodeProvider c = new CSharpCodeProvider();
        ICodeCompiler icc = c.CreateCompiler();

        CompilerParameters cp = new CompilerParameters();
        // BAD: Compiling unvalidated code from the user
        CompilerResults cr = icc.CompileAssemblyFromSource(cp, code);

        System.Reflection.Assembly a = cr.CompiledAssembly;
        object o = a.CreateInstance("MyNamespace.MyClass");

        Type t = o.GetType();
        MethodInfo mi = t.GetMethod("Eval");

        object s = mi.Invoke(o, null);

        // BAD: Use the Roslyn APIs to dynamically evaluate C#
        CSharpScript.EvaluateAsync(code);
    }

    public bool IsReusable
    {
        get
        {
            return true;
        }
    }

    System.Windows.Forms.RichTextBox box1;

    void OnButtonClicked()
    {
        // BAD: Use the Roslyn APIs to dynamically evaluate C#
        CSharpScript.EvaluateAsync(box1.Text);
    }
}
