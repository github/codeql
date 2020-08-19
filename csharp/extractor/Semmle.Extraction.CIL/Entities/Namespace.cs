using System;
using System.Collections.Generic;
using System.IO;
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
    public sealed class Namespace : TypeContainer, INamespace
    {
        public Namespace? ParentNamespace;
        public readonly string Name;

        public bool IsGlobalNamespace => ParentNamespace == null;

        public override string IdSuffix => ";namespace";


        public override void WriteId(TextWriter trapFile)
        {
            if (ParentNamespace != null && !ParentNamespace.IsGlobalNamespace)
            {
                ParentNamespace.WriteId(trapFile);
                trapFile.Write('.');
            }
            trapFile.Write(Name);
        }

        public override bool Equals(object? obj)
        {
            if (obj is Namespace ns && Name == ns.Name)
            {
                if (ParentNamespace is null)
                    return ns.ParentNamespace is null;
                if (!(ns.ParentNamespace is null))
                    return ParentNamespace.Equals(ns.ParentNamespace);
            }
            return false;
        }

        public override int GetHashCode()
        {
            int h = ParentNamespace is null ? 19 : ParentNamespace.GetHashCode();
            return 13 * h + Name.GetHashCode();
        }

        public override IEnumerable<Type> TypeParameters => throw new NotImplementedException();

        public override IEnumerable<Type> MethodParameters => throw new NotImplementedException();

        static string parseNamespaceName(string fqn)
        {
            var i = fqn.LastIndexOf('.');
            return i == -1 ? fqn : fqn.Substring(i + 1);
        }

        static Namespace? createParentNamespace(Context cx, string fqn)
        {
            if (fqn == "") return null;
            var i = fqn.LastIndexOf('.');
            return i == -1 ? cx.GlobalNamespace : cx.Populate(new Namespace(cx, fqn.Substring(0, i)));
        }

        public Namespace(Context cx, string fqn) : this(cx, parseNamespaceName(fqn), createParentNamespace(cx, fqn))
        {
        }

        public Namespace(Context cx, string name, Namespace? parent) : base(cx)
        {
            Name = name;
            ParentNamespace = parent;
        }

        public override IEnumerable<IExtractionProduct> Contents
        {
            get
            {
                yield return Tuples.namespaces(this, Name);
                if (!IsGlobalNamespace)
                    yield return Tuples.parent_namespace(this, ParentNamespace!);
            }
        }
    }
}
