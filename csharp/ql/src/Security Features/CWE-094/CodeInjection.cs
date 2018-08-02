using Microsoft.CSharp;
using System;
using System.CodeDom.Compiler;
using System.Reflection;
using System.Web;

public class CodeInjectionHandler : IHttpHandler
{
    public void ProcessRequest(HttpContext ctx)
    {
        // Code for calculating tax is provided as unvalidated user input
        string taxFormula = ctx.Request.QueryString["tax_formula"];
        // Used to create C#
        StringBuilder sourceCode = new StringBuilder("");
        sourceCode.Append("public class TaxCalc {\n");
        sourceCode.Append("\tpublic int CalculateTax(int value){\n");
        sourceCode.Append("\t\treturn " + taxFormula + "; \n");
        sourceCode.Append("\t}\n");
        sourceCode.Append("}\n");

        // BAD: This compiles the sourceCode, containing unvalidated user input
        CSharpCodeProvider c = new CSharpCodeProvider();
        ICodeCompiler icc = c.CreateCompiler();
        CompilerParameters cp = new CompilerParameters();
        CompilerResults cr = icc.CompileAssemblyFromSource(cp, sourceCode.ToString());

        // Compiled input is loaded, and an instance of the class is constructed
        System.Reflection.Assembly a = cr.CompiledAssembly;
        object taxCalc = a.CreateInstance("TaxCalc");

        // Unsafe code is executed
        Type taxCalcType = o.GetType();
        MethodInfo mi = type.GetMethod("CalculateTax");
        int value = int.Parse(ctx.Request.QueryString["value"]);
        int s = (int)mi.Invoke(o, new object[] { value });

        // Result is returned to the user
        ctx.Response.Write("Tax value is: " + s);
    }
}
