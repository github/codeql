using Microsoft.CodeAnalysis.CSharp;
using Microsoft.CodeAnalysis.CSharp.Syntax;
using Semmle.Extraction.Entities;
using Semmle.Util;
using System.IO;
using System.Linq;

namespace Semmle.Extraction.CSharp.Entities
{
    internal class TypeMention : FreshEntity
    {
        private readonly TypeSyntax syntax;
        private readonly IEntity parent;
        private readonly Type type;
        private readonly Microsoft.CodeAnalysis.Location loc;

        private TypeMention(Context cx, TypeSyntax syntax, IEntity parent, Type type, Microsoft.CodeAnalysis.Location loc = null)
            : base(cx)
        {
            this.syntax = syntax;
            this.parent = parent;
            this.type = type;
            this.loc = loc;
        }

        private TypeSyntax GetArrayElementType(TypeSyntax type)
        {
            switch (type)
            {
                case ArrayTypeSyntax ats:
                    return GetArrayElementType(ats.ElementType);
                case NullableTypeSyntax nts:
                    // int[]? -> int[] -> int
                    // int?   -> int?
                    return cx.GetTypeInfo(nts.ElementType).Type.IsReferenceType
                        ? GetArrayElementType(nts.ElementType)
                        : nts;
                case PointerTypeSyntax pts:
                    return GetArrayElementType(pts.ElementType);
                default:
                    return type;
            }
        }

        private static Type GetArrayElementType(Type type)
        {
            switch (type)
            {
                case ArrayType at:
                    return GetArrayElementType(at.ElementType.Type);
                case NamedType nt when nt.symbol.IsBoundSpan() ||
                                       nt.symbol.IsBoundReadOnlySpan():
                    return nt.TypeArguments.Single();
                case PointerType pt:
                    return GetArrayElementType(pt.PointedAtType);
                default:
                    return type;
            }
        }

        protected override void Populate(TextWriter trapFile)
        {
            switch (syntax.Kind())
            {
                case SyntaxKind.ArrayType:
                case SyntaxKind.PointerType:
                    Emit(trapFile, loc ?? syntax.GetLocation(), parent, type);
                    Create(cx, GetArrayElementType(syntax), this, GetArrayElementType(type));
                    return;
                case SyntaxKind.NullableType:
                    var nts = (NullableTypeSyntax)syntax;
                    if (type is NamedType nt)
                    {
                        if (!nt.symbol.IsReferenceType)
                        {
                            Emit(trapFile, loc ?? syntax.GetLocation(), parent, type);
                            Create(cx, nts.ElementType, this, nt.TypeArguments[0]);
                        }
                        else
                        {
                            Create(cx, nts.ElementType, parent, type);
                        }
                    }
                    else if (type is ArrayType)
                    {
                        Create(cx, nts.ElementType, parent, type);
                    }
                    return;
                case SyntaxKind.TupleType:
                    var tts = (TupleTypeSyntax)syntax;
                    var tt = (TupleType)type;
                    Emit(trapFile, loc ?? syntax.GetLocation(), parent, type);
                    tts.Elements.Zip(tt.TupleElements, (s, t) => Create(cx, s.Type, this, t.Type)).Enumerate();
                    return;
                case SyntaxKind.GenericName:
                    Emit(trapFile, loc ?? syntax.GetLocation(), parent, type);
                    cx.PopulateLater(() =>
                        ((GenericNameSyntax)syntax)
                            .TypeArgumentList
                            .Arguments
                            .Zip(type.TypeMentions, (s, t) => Create(cx, s, this, t)).Enumerate());
                    return;
                case SyntaxKind.QualifiedName:
                    var qns = (QualifiedNameSyntax)syntax;
                    var right = Create(cx, qns.Right, parent, type);
                    if (type.ContainingType is object)
                    {
                        // Type qualifier
                        Create(cx, qns.Left, right, type.ContainingType);
                    }
                    return;
                default:
                    Emit(trapFile, loc ?? syntax.GetLocation(), parent, type);
                    return;
            }
        }

        private void Emit(TextWriter trapFile, Microsoft.CodeAnalysis.Location loc, IEntity parent, Type type)
        {
            trapFile.type_mention(this, type.TypeRef, parent);
            trapFile.type_mention_location(this, cx.Create(loc));
        }

        public static TypeMention Create(Context cx, TypeSyntax syntax, IEntity parent, Type type, Microsoft.CodeAnalysis.Location loc = null)
        {
            var ret = new TypeMention(cx, syntax, parent, type, loc);
            cx.Try(syntax, null, () => ret.Populate(cx.TrapWriter.Writer));
            return ret;
        }

        public static TypeMention Create(Context cx, TypeSyntax syntax, IEntity parent, AnnotatedType type, Microsoft.CodeAnalysis.Location loc = null) =>
            Create(cx, syntax, parent, type.Type, loc);

        public override TrapStackBehaviour TrapStackBehaviour => TrapStackBehaviour.OptionalLabel;
    }
}
