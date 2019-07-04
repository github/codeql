using Microsoft.CodeAnalysis.CSharp;
using Microsoft.CodeAnalysis.CSharp.Syntax;
using Semmle.Extraction.Entities;
using Semmle.Util;
using System.Linq;

namespace Semmle.Extraction.CSharp.Entities
{
    class TypeMention : FreshEntity
    {
        readonly TypeSyntax Syntax;
        readonly IEntity Parent;
        readonly Type Type;
        readonly Microsoft.CodeAnalysis.Location Loc;

        TypeMention(Context cx, TypeSyntax syntax, IEntity parent, Type type, Microsoft.CodeAnalysis.Location loc = null)
            : base(cx)
        {
            Syntax = syntax;
            Parent = parent;
            Type = type;
            Loc = loc;
        }

        static TypeSyntax GetElementType(TypeSyntax type)
        {
            switch(type)
            {
                case ArrayTypeSyntax ats:
                    return GetElementType(ats.ElementType);
                case NullableTypeSyntax nts:
                    return GetElementType(nts.ElementType);
                default:
                    return type;
            }
        }

        static Type GetElementType(Type t)
        {
            switch(t)
            {
                case ArrayType at:
                    return GetElementType(at.ElementType.Type);
                case NamedType nt when nt.symbol.IsBoundNullable():
                    return nt.TypeArguments.Single();
                default:
                    return t;
            }
        }

        void Populate()
        {
            switch (Syntax.Kind())
            {
                case SyntaxKind.ArrayType:
                    Emit(Loc ?? Syntax.GetLocation(), Parent, Type);
                    Create(cx, GetElementType(Syntax), this, GetElementType(Type));
                    return;
                case SyntaxKind.NullableType:
                    var nts = (NullableTypeSyntax)Syntax;
                    if (Type is NamedType nt)
                    {
                        Emit(Loc ?? Syntax.GetLocation(), Parent, Type);
                        Create(cx, nts.ElementType, this, nt.symbol.IsReferenceType ? nt : nt.TypeArguments[0]);
                    }
                    else if(Type is ArrayType array)
                    {
                        Create(cx, nts.ElementType, Parent, array);
                    }
                    return;
                case SyntaxKind.TupleType:
                    var tts = (TupleTypeSyntax)Syntax;
                    var tt = (TupleType)Type;
                    Emit(Loc ?? Syntax.GetLocation(), Parent, Type);
                    tts.Elements.Zip(tt.TupleElements, (s, t) => Create(cx, s.Type, this, t.Type)).Enumerate();
                    return;
                case SyntaxKind.PointerType:
                    var pts = (PointerTypeSyntax)Syntax;
                    var pt = (PointerType)Type;
                    Emit(Loc ?? Syntax.GetLocation(), Parent, Type);
                    Create(cx, pts.ElementType, this, pt.PointedAtType);
                    return;
                case SyntaxKind.GenericName:
                    var gns = (GenericNameSyntax)Syntax;
                    Emit(Loc ?? gns.Identifier.GetLocation(), Parent, Type);
                    cx.PopulateLater(() => gns.TypeArgumentList.Arguments.Zip(Type.TypeMentions, (s, t) => Create(cx, s, this, t)).Enumerate());
                    return;
                case SyntaxKind.QualifiedName:
                    if (Type.ContainingType == null)
                    {
                        // namespace qualifier
                        Emit(Loc ?? Syntax.GetLocation(), Parent, Type);
                    }
                    else
                    {
                        // Type qualifier
                        var qns = (QualifiedNameSyntax)Syntax;
                        var right = Create(cx, qns.Right, Parent, Type);
                        Create(cx, qns.Left, right, Type.ContainingType);
                    }
                    return;
                default:
                    Emit(Loc ?? Syntax.GetLocation(), Parent, Type);
                    return;
            }
        }

        void Emit(Microsoft.CodeAnalysis.Location loc, IEntity parent, Type type)
        {
            cx.Emit(Tuples.type_mention(this, type.TypeRef, parent));
            cx.Emit(Tuples.type_mention_location(this, cx.Create(loc)));
        }

        public static TypeMention Create(Context cx, TypeSyntax syntax, IEntity parent, Type type, Microsoft.CodeAnalysis.Location loc = null)
        {
            var ret = new TypeMention(cx, syntax, parent, type, loc);
            cx.Try(syntax, null, () => ret.Populate());
            return ret;
        }

        public static TypeMention Create(Context cx, TypeSyntax syntax, IEntity parent, AnnotatedType type, Microsoft.CodeAnalysis.Location loc = null) =>
            Create(cx, syntax, parent, type.Type, loc);

        public override TrapStackBehaviour TrapStackBehaviour => TrapStackBehaviour.OptionalLabel;
    }
}
