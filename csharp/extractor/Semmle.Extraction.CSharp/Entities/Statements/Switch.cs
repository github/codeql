using System.IO;
using System.Linq;
using Microsoft.CodeAnalysis.CSharp.Syntax;
using Semmle.Extraction.Kinds;

namespace Semmle.Extraction.CSharp.Entities.Statements
{
    internal class Switch : Statement<SwitchStatementSyntax>
    {
        private static readonly object nullLabel = new object();
        public static object DefaultLabel { get; } = new object();

        // Sometimes, the literal "null" is used as a label.
        // This is inconveniently represented by the "null" object.
        // This cannot be stored in a Dictionary<>, so substitute an object which can be.
        public static object LabelForValue(object label)
        {
            return label ?? nullLabel;
        }

        private Switch(Context cx, SwitchStatementSyntax node, IStatementParentEntity parent, int child)
            : base(cx, node, StmtKind.SWITCH, parent, child) { }

        public static Switch Create(Context cx, SwitchStatementSyntax node, IStatementParentEntity parent, int child)
        {
            var ret = new Switch(cx, node, parent, child);
            ret.TryPopulate();
            return ret;
        }

        protected override void PopulateStatement(TextWriter trapFile)
        {
            Expression.Create(cx, Stmt.Expression, this, 0);
            var childIndex = 0;

            foreach (var section in Stmt.Sections)
            {
                foreach (var stmt in section.Labels.Select(label => Case<SwitchLabelSyntax>.Create(cx, label, this, childIndex)))
                {
                    childIndex += stmt.NumberOfStatements;
                }

                foreach (var stmt in section.Statements.Select(s => Create(cx, s, this, childIndex)))
                {
                    childIndex += stmt.NumberOfStatements;
                }
            }
        }
    }
}
