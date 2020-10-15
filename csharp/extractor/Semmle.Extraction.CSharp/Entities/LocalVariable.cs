using System;
using System.IO;
using Microsoft.CodeAnalysis;

namespace Semmle.Extraction.CSharp.Entities
{
    internal class LocalVariable : CachedSymbol<ISymbol>
    {
        private LocalVariable(Context cx, ISymbol init) : base(cx, init) { }

        public override void WriteId(TextWriter trapFile)
        {
            throw new InvalidOperationException();
        }

        public override void WriteQuotedId(TextWriter trapFile)
        {
            trapFile.Write('*');
        }

        public override void Populate(TextWriter trapFile) { }

        public void PopulateManual(Expression parent, bool isVar)
        {
            var trapFile = Context.TrapWriter.Writer;
            var (kind, type) = symbol is ILocalSymbol l
                ? (l.IsRef ? 3 : l.IsConst ? 2 : 1, Type.Create(Context, l.GetAnnotatedType()))
                : (1, parent.Type);
            trapFile.localvars(this, kind, symbol.Name, isVar ? 1 : 0, type.Type.TypeRef, parent);

            if (symbol is ILocalSymbol local)
            {
                PopulateNullability(trapFile, local.GetAnnotatedType());
                if (local.IsRef)
                    trapFile.type_annotation(this, Kinds.TypeAnnotation.Ref);
            }

            trapFile.localvar_location(this, Location);

            DefineConstantValue(trapFile);
        }

        public static LocalVariable Create(Context cx, ISymbol local)
        {
            return LocalVariableFactory.Instance.CreateEntityFromSymbol(cx, local);
        }

        private void DefineConstantValue(TextWriter trapFile)
        {
            if (symbol is ILocalSymbol local && local.HasConstantValue)
            {
                trapFile.constant_value(this, Expression.ValueAsString(local.ConstantValue));
            }
        }

        private class LocalVariableFactory : ICachedEntityFactory<ISymbol, LocalVariable>
        {
            public static LocalVariableFactory Instance { get; } = new LocalVariableFactory();

            public LocalVariable Create(Context cx, ISymbol init) => new LocalVariable(cx, init);
        }

        public override TrapStackBehaviour TrapStackBehaviour => TrapStackBehaviour.NeedsLabel;
    }
}
