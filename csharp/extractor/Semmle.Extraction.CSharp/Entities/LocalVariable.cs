using System;
using System.IO;
using Microsoft.CodeAnalysis;
using Semmle.Extraction.Entities;

namespace Semmle.Extraction.CSharp.Entities
{
    class LocalVariable : CachedSymbol<ISymbol>
    {
        LocalVariable(Context cx, ISymbol init, Expression parent, bool isVar, Extraction.Entities.Location declLocation)
            : base(cx, init)
        {
            Parent = parent;
            IsVar = isVar;
            DeclLocation = declLocation;
        }

        readonly Expression Parent;
        readonly bool IsVar;
        readonly Extraction.Entities.Location DeclLocation;

        public override void WriteId(TextWriter trapFile)
        {
            trapFile.WriteSubId(Parent);
            trapFile.Write('_');
            trapFile.Write(symbol.Name);
            trapFile.Write(";localvar");
        }

        public override void Populate(TextWriter trapFile)
        {
            if (symbol is ILocalSymbol local)
            {
                PopulateNullability(trapFile, local.NullableAnnotation);
                if (local.IsRef)
                    trapFile.type_annotation(this, Kinds.TypeAnnotation.Ref);
            }

            trapFile.localvars(
                this,
                IsRef ? 3 : IsConst ? 2 : 1,
                symbol.Name,
                IsVar ? 1 : 0,
                Type.Type.TypeRef,
                Parent);

            trapFile.localvar_location(this, DeclLocation);

            DefineConstantValue(trapFile);
        }

        public static LocalVariable Create(Context cx, ISymbol local, Expression parent, bool isVar, Extraction.Entities.Location declLocation)
        {
            return LocalVariableFactory.Instance.CreateEntity(cx, local, parent, isVar, declLocation);
        }

        /// <summary>
        /// Gets the local variable entity for <paramref name="local"/> which must
        /// already have been created.
        /// </summary>
        public static LocalVariable GetAlreadyCreated(Context cx, ISymbol local) => LocalVariableFactory.Instance.CreateEntity(cx, local, null, false, null);

        bool IsConst
        {
            get
            {
                var local = symbol as ILocalSymbol;
                return local != null && local.IsConst;
            }
        }

        bool IsRef
        {
            get
            {
                var local = symbol as ILocalSymbol;
                return local != null && local.IsRef;
            }
        }

        AnnotatedType Type
        {
            get
            {
                var local = symbol as ILocalSymbol;
                return local == null ? Parent.Type : Entities.Type.Create(Context, local.GetAnnotatedType());
            }
        }

        void DefineConstantValue(TextWriter trapFile)
        {
            var local = symbol as ILocalSymbol;
            if (local != null && local.HasConstantValue)
            {
                trapFile.constant_value(this, Expression.ValueAsString(local.ConstantValue));
            }
        }

        class LocalVariableFactory : ICachedEntityFactory<(ISymbol, Expression, bool, Extraction.Entities.Location), LocalVariable>
        {
            public static readonly LocalVariableFactory Instance = new LocalVariableFactory();

            public LocalVariable Create(Context cx, (ISymbol, Expression, bool, Extraction.Entities.Location) init) =>
                new LocalVariable(cx, init.Item1, init.Item2, init.Item3, init.Item4);
        }

        public override TrapStackBehaviour TrapStackBehaviour => TrapStackBehaviour.NeedsLabel;
    }
}
