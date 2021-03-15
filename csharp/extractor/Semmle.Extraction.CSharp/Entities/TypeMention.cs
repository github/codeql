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
        private readonly Microsoft.CodeAnalysis.Location? loc;

        private TypeMention(Context cx, TypeSyntax syntax, IEntity parent, Type type, Microsoft.CodeAnalysis.Location? loc = null)
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
                    return Context.GetTypeInfo(nts.ElementType).Type?.IsReferenceType == true
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
                    return GetArrayElementType(at.ElementType);
                case NamedType nt when nt.Symbol.IsBoundSpan() ||
                                       nt.Symbol.IsBoundReadOnlySpan():
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
                    Create(Context, GetArrayElementType(syntax), this, GetArrayElementType(type));
                    return;
                case SyntaxKind.NullableType:
                    var nts = (NullableTypeSyntax)syntax;
                    if (type is NamedType nt)
                    {
                        if (!nt.Symbol.IsReferenceType)
                        {
                            Emit(trapFile, loc ?? syntax.GetLocation(), parent, type);
                            Create(Context, nts.ElementType, this, nt.TypeArguments[0]);
                        }
                        else
                        {
                            Create(Context, nts.ElementType, parent, type);
                        }
                    }
                    else if (type is ArrayType)
                    {
                        Create(Context, nts.ElementType, parent, type);
                    }
                    return;
                case SyntaxKind.TupleType:
                    var tts = (TupleTypeSyntax)syntax;
                    var tt = (TupleType)type;
                    Emit(trapFile, loc ?? syntax.GetLocation(), parent, type);
                    tts.Elements.Zip(tt.TupleElements, (s, t) => Create(Context, s.Type, this, t.Type)).Enumerate();
                    return;
                case SyntaxKind.GenericName:
                    Emit(trapFile, loc ?? syntax.GetLocation(), parent, type);
                    Context.PopulateLater(() =>
                        ((GenericNameSyntax)syntax)
                            .TypeArgumentList
                            .Arguments
                            .Zip(type.TypeMentions, (s, t) => Create(Context, s, this, t)).Enumerate());
                    return;
                case SyntaxKind.QualifiedName:
                    var qns = (QualifiedNameSyntax)syntax;
                    var right = Create(Context, qns.Right, parent, type);
                    if (type.ContainingType is not null)
                    {
                        // Type qualifier
                        Create(Context, qns.Left, right, type.ContainingType);
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
            trapFile.type_mention_location(this, Context.CreateLocation(loc));
        }

        public static TypeMention Create(Context cx, TypeSyntax syntax, IEntity parent, Type type, Microsoft.CodeAnalysis.Location? loc = null)
        {
            var ret = new TypeMention(cx, syntax, parent, type, loc);
            cx.Try(syntax, null, () => ret.Populate(cx.TrapWriter.Writer));
            return ret;
        }

        public static TypeMention Create(Context cx, TypeSyntax syntax, IEntity parent, AnnotatedTypeSymbol? type, Microsoft.CodeAnalysis.Location? loc = null) =>
            Create(cx, syntax, parent, Type.Create(cx, type?.Symbol), loc);

        public override TrapStackBehaviour TrapStackBehaviour => TrapStackBehaviour.OptionalLabel;
    }
}
