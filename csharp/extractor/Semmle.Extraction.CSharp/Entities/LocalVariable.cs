using System;
using System.IO;
using Microsoft.CodeAnalysis;

namespace Semmle.Extraction.CSharp.Entities
{
    class LocalVariable : CachedSymbol<ISymbol>
    {
        LocalVariable(Context cx, ISymbol init) : base(cx, init) { }

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
            var (kind, type) =
                Symbol is ILocalSymbol l ?
                    (l.IsRef ? 3 : l.IsConst ? 2 : 1, Type.Create(Context, l.GetAnnotatedType())) :
                    (1, parent.Type);
            trapFile.localvars(this, kind, Symbol.Name, isVar ? 1 : 0, type.Type.TypeRef, parent);

            if (Symbol is ILocalSymbol local)
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

        void DefineConstantValue(TextWriter trapFile)
        {
            if (Symbol is ILocalSymbol local && local.HasConstantValue)
            {
                trapFile.constant_value(this, Expression.ValueAsString(local.ConstantValue));
            }
        }

        class LocalVariableFactory : ICachedEntityFactory<ISymbol, LocalVariable>
        {
            public static readonly LocalVariableFactory Instance = new LocalVariableFactory();

            public LocalVariable Create(Context cx, ISymbol init) => new LocalVariable(cx, init);
        }

        public override TrapStackBehaviour TrapStackBehaviour => TrapStackBehaviour.NeedsLabel;
    }
}
