using System;

namespace Semmle.Extraction.PowerShell.Entities;

using Semmle.Extraction.Entities;
using System.IO;

internal class StringLiteralEntity : CachedEntity<(Microsoft.CodeAnalysis.Location, string)>
{
    private StringLiteralEntity(PowerShellContext cx, Microsoft.CodeAnalysis.Location loc, string text)
        : base(cx, (loc, text))
    {
    }

    private Location? location;

    public override Microsoft.CodeAnalysis.Location ReportingLocation => Symbol.Item1;
    public string Text => Symbol.Item2;
    public override void Populate(TextWriter trapFile)
    {
        location = PowerShellContext.CreateLocation(ReportingLocation);
        trapFile.string_literal(this);
        trapFile.string_literal_location(this, TrapSuitableLocation);
        string[] splits = Text.Split(new[] { '\r', '\n' },
            StringSplitOptions.RemoveEmptyEntries | StringSplitOptions.TrimEntries);
        for (int index = 0; index < splits.Length; index++)
        {
            trapFile.string_literal_line(this, index, splits[index]);
        }
    }

    public override bool NeedsPopulation => true;

    public override void WriteId(EscapingTextWriter trapFile)
    {
        trapFile.WriteSubId(TrapSuitableLocation);
        trapFile.Write(";string_literal");
    }

    internal static StringLiteralEntity Create(PowerShellContext cx, Microsoft.CodeAnalysis.Location loc, string text)
    {
        var init = (loc, text);
        return StringLiteralFactory.Instance.CreateEntity(cx, init, init);
    }

    private class StringLiteralFactory : CachedEntityFactory<(Microsoft.CodeAnalysis.Location, string), StringLiteralEntity>
    {
        public static StringLiteralFactory Instance { get; } = new StringLiteralFactory();

        public override StringLiteralEntity Create(PowerShellContext cx, (Microsoft.CodeAnalysis.Location, string) init) =>
            new StringLiteralEntity(cx, init.Item1, init.Item2);
    }

    public override TrapStackBehaviour TrapStackBehaviour => TrapStackBehaviour.OptionalLabel;
}