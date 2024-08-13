using System.Management.Automation.Language;
using Semmle.Extraction.PowerShell.Entities;

namespace Semmle.Extraction.PowerShell;

/// <summary>
/// This is a Visitor that implements the AstVisitor2 abstract class for walking powershell ASTs.
/// </summary>
public class PowerShellVisitor2 : AstVisitor2
{
    /// <summary>
    /// The constructor requires the context so it can be passed to entities that are created
    /// </summary>
    /// <param name="ctx"></param>
    public PowerShellVisitor2(PowerShellContext ctx)
    {
        this.Context = ctx;
    }
    private PowerShellContext Context { get; set; }

    /// <summary>
    /// Default visit is called by the base class for all properties by default.
    ///     Until the more specific visitors below are actually overridden this will get called for every ast
    /// </summary>
    /// <param name="ast"></param>
    /// <returns></returns>
    public override AstVisitAction DefaultVisit(Ast ast)
    {
        EntityConstructor.ConstructAppropriateEntity(Context, ast);
        return AstVisitAction.Continue;
    }
}