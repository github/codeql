using Semmle.Extraction.Kinds;
using System.Linq;
using System.IO;
using Semmle.Extraction.Entities;
using System.Collections.Generic;
using Microsoft.CodeAnalysis.CSharp.Syntax;
using System;

namespace Semmle.Extraction.CSharp.Entities.Statements
{
    internal class GlobalStatementsBlock : Statement
    {
        private readonly Method parent;
        private readonly List<GlobalStatementSyntax> globalStatements;

        private GlobalStatementsBlock(Context cx, Method parent, List<GlobalStatementSyntax> globalStatements)
            : base(cx, StmtKind.BLOCK, parent, 0)
        {
            this.parent = parent;
            this.globalStatements = globalStatements;
        }

        public override Microsoft.CodeAnalysis.Location? ReportingLocation
        {
            get
            {
                return parent.Symbol
                    ?.DeclaringSyntaxReferences
                    .FirstOrDefault()
                    ?.GetSyntax()
                    .GetLocation();
            }
        }

        public static GlobalStatementsBlock Create(Context cx, Method parent, List<GlobalStatementSyntax> globalStatements)
        {
            var ret = new GlobalStatementsBlock(cx, parent, globalStatements);
            ret.TryPopulate();
            return ret;
        }

        protected override void PopulateStatement(TextWriter trapFile)
        {
            trapFile.stmt_location(this, Context.CreateLocation(ReportingLocation));

            for (var i = 0; i < globalStatements.Count; i++)
            {
                if (globalStatements[i].Statement is not null)
                {
                    Statement.Create(Context, globalStatements[i].Statement, this, i);
                }
            }
        }
    }
}
