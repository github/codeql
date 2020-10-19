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

        private static TypeSyntax GetElementType(TypeSyntax type)
        {
            switch (type)
            {
                case ArrayTypeSyntax ats:
                    return GetElementType(ats.ElementType);
                case NullableTypeSyntax nts:
                    return GetElementType(nts.ElementType);
                default:
                    return type;
            }
        }

        private static Type GetElementType(Type type)
        {
            switch (type)
            {
                case ArrayType at:
                    return GetElementType(at.ElementType.Type);
                case NamedType nt when nt.symbol.IsBoundNullable():
                    return nt.TypeArguments.Single();
                default:
                    return type;
            }
        }

        protected override void Populate(TextWriter trapFile)
        {
            switch (syntax.Kind())
            {
                case SyntaxKind.ArrayType:
                    Emit(trapFile, loc ?? syntax.GetLocation(), parent, type);
                    Create(cx, GetElementType(syntax), this, GetElementType(type));
                    return;
                case SyntaxKind.NullableType:
                    var nts = (NullableTypeSyntax)syntax;
                    if (type is NamedType nt)
                    {
                        Emit(trapFile, loc ?? syntax.GetLocation(), parent, type);
                        Create(cx, nts.ElementType, this, nt.symbol.IsReferenceType ? nt : nt.TypeArguments[0]);
                    }
                    else if (type is ArrayType array)
                    {
                        Create(cx, nts.ElementType, parent, array);
                    }
                    return;
                case SyntaxKind.TupleType:
                    var tts = (TupleTypeSyntax)syntax;
                    var tt = (TupleType)type;
                    Emit(trapFile, loc ?? syntax.GetLocation(), parent, type);
                    tts.Elements.Zip(tt.TupleElements, (s, t) => Create(cx, s.Type, this, t.Type)).Enumerate();
                    return;
                case SyntaxKind.PointerType:
                    var pts = (PointerTypeSyntax)syntax;
                    var pt = (PointerType)type;
                    Emit(trapFile, loc ?? syntax.GetLocation(), parent, type);
                    Create(cx, pts.ElementType, this, pt.PointedAtType);
                    return;
                case SyntaxKind.GenericName:
                    var gns = (GenericNameSyntax)syntax;
                    Emit(trapFile, loc ?? gns.Identifier.GetLocation(), parent, type);
                    cx.PopulateLater(() => gns.TypeArgumentList.Arguments.Zip(type.TypeMentions, (s, t) => Create(cx, s, this, t)).Enumerate());
                    return;
                case SyntaxKind.QualifiedName:
                    if (type.ContainingType == null)
                    {
                        // namespace qualifier
                        Emit(trapFile, loc ?? syntax.GetLocation(), parent, type);
                    }
                    else
                    {
                        // Type qualifier
                        var qns = (QualifiedNameSyntax)syntax;
                        var right = Create(cx, qns.Right, parent, type);
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
