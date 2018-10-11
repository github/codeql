using System;
using System.Collections.Generic;
using Semmle.Extraction.Entities;

namespace Semmle.Extraction.CIL.Entities
{
    /// <summary>
    /// A namespace.
    /// </summary>
    interface INamespace : ITypeContainer
    {
    }

    /// <summary>
    /// A namespace.
    /// </summary>
    public class Namespace : TypeContainer, INamespace
    {
        public Namespace ParentNamespace;
        public readonly StringId Name;

        public bool IsGlobalNamespace => ParentNamespace == null;

        static readonly Id suffix = CIL.Id.Create(";namespace");

        public Id CreateId
        {
            get
            {
                if (ParentNamespace != null && !ParentNamespace.IsGlobalNamespace)
                {
                    return ParentNamespace.ShortId + cx.Dot + Name;
                }
                return Name;
            }
        }

        public override Id IdSuffix => suffix;

        public override IEnumerable<Type> TypeParameters => throw new NotImplementedException();

        public override IEnumerable<Type> MethodParameters => throw new NotImplementedException();

        static string parseNamespaceName(string fqn)
        {
            var i = fqn.LastIndexOf('.');
            return i == -1 ? fqn : fqn.Substring(i + 1);
        }

        static Namespace createParentNamespace(Context cx, string fqn)
        {
            if (fqn == "") return null;
            var i = fqn.LastIndexOf('.');
            return i == -1 ? cx.GlobalNamespace : cx.Populate(new Namespace(cx, fqn.Substring(0, i)));
        }

        public Namespace(Context cx, string fqn) : this(cx, cx.GetId(parseNamespaceName(fqn)), createParentNamespace(cx, fqn))
        {
        }

        public Namespace(Context cx, StringId name, Namespace parent) : base(cx)
        {
            Name = name;
            ParentNamespace = parent;
            ShortId = CreateId;
        }

        public override IEnumerable<IExtractionProduct> Contents
        {
            get
            {
                yield return Tuples.namespaces(this, Name.Value);
                if (!IsGlobalNamespace)
                    yield return Tuples.parent_namespace(this, ParentNamespace);
            }
        }
    }
}
