using System;
using System.IO;
using Microsoft.CodeAnalysis;

namespace Semmle.Extraction.CSharp.Entities
{
    internal class LocalVariable : CachedSymbol<ISymbol>
    {
        private LocalVariable(Context cx, ISymbol init) : base(cx, init) { }

        public override void WriteId(EscapingTextWriter trapFile)
        {
            throw new InvalidOperationException();
        }

        public sealed override void WriteQuotedId(EscapingTextWriter trapFile)
        {
            trapFile.Write('*');
        }

        public override void Populate(TextWriter trapFile) { }

        public void PopulateManual(Expression parent, bool isVar)
        {
            var trapFile = Context.TrapWriter.Writer;
            var @var = isVar ? 1 : 0;

            if (Symbol is ILocalSymbol local)
            {
                var kind = local.IsRef ? Kinds.VariableKind.Ref : local.IsConst ? Kinds.VariableKind.Const : Kinds.VariableKind.None;
                var type = local.GetAnnotatedType();
                trapFile.localvars(this, kind, Symbol.Name, @var, Type.Create(Context, type).TypeRef, parent);

                PopulateNullability(trapFile, local.GetAnnotatedType());
                PopulateScopedKind(trapFile, local.ScopedKind);
                if (local.IsRef)
                    trapFile.type_annotation(this, Kinds.TypeAnnotation.Ref);
            }
            else
            {
                trapFile.localvars(this, Kinds.VariableKind.None, Symbol.Name, @var, Type.Create(Context, parent.Type).TypeRef, parent);
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
            if (Symbol is ILocalSymbol local && local.HasConstantValue)
            {
                trapFile.constant_value(this, Expression.ValueAsString(local.ConstantValue!));
            }
        }

        private class LocalVariableFactory : CachedEntityFactory<ISymbol, LocalVariable>
        {
            public static LocalVariableFactory Instance { get; } = new LocalVariableFactory();

            public override LocalVariable Create(Context cx, ISymbol init) => new LocalVariable(cx, init);
        }

        public override TrapStackBehaviour TrapStackBehaviour => TrapStackBehaviour.NeedsLabel;
    }
}
