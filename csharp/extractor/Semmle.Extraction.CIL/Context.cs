﻿using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Reflection.Metadata;
using System.Reflection.PortableExecutable;

namespace Semmle.Extraction.CIL
{
    /// <summary>
    /// Extraction context for CIL extraction.
    /// Adds additional context that is specific for CIL extraction.
    /// One context = one DLL/EXE.
    /// </summary>
    partial class Context : IDisposable
    {
        public Extraction.Context cx;
        readonly FileStream stream;
        public readonly MetadataReader mdReader;
        public readonly PEReader peReader;
        public readonly string assemblyPath;
        public Entities.Assembly assembly;
        public PDB.IPdb pdb;

        public Context(Extraction.Context cx, string assemblyPath, bool extractPdbs)
        {
            this.cx = cx;
            this.assemblyPath = assemblyPath;
            stream = File.OpenRead(assemblyPath);
            peReader = new PEReader(stream, PEStreamOptions.PrefetchEntireImage);
            mdReader = peReader.GetMetadataReader();
            TypeSignatureDecoder = new Entities.TypeSignatureDecoder(this);

            globalNamespace = new Lazy<Entities.Namespace>(() => Populate(new Entities.Namespace(this, "", null)));
            systemNamespace = new Lazy<Entities.Namespace>(() => Populate(new Entities.Namespace(this, "System")));
            genericHandleFactory = new CachedFunction<GenericContext, Handle, IExtractedEntity>(CreateGenericHandle);
            namespaceFactory = new CachedFunction<StringHandle, Entities.Namespace>(n => CreateNamespace(mdReader.GetString(n)));
            namespaceDefinitionFactory = new CachedFunction<NamespaceDefinitionHandle, Entities.Namespace>(CreateNamespace);
            sourceFiles = new CachedFunction<PDB.ISourceFile, Entities.PdbSourceFile>(path => new Entities.PdbSourceFile(this, path));
            folders = new CachedFunction<PathTransformer.ITransformedPath, Entities.Folder>(path => new Entities.Folder(this, path));
            sourceLocations = new CachedFunction<PDB.Location, Entities.PdbSourceLocation>(location => new Entities.PdbSourceLocation(this, location));

            defaultGenericContext = new EmptyContext(this);

            if (extractPdbs)
            {
                pdb = PDB.PdbReader.Create(assemblyPath, peReader);
                if (pdb != null)
                {
                    cx.Extractor.Logger.Log(Util.Logging.Severity.Info, string.Format("Found PDB information for {0}", assemblyPath));
                }
            }
        }

        void IDisposable.Dispose()
        {
            if (pdb != null)
                pdb.Dispose();
            peReader.Dispose();
            stream.Dispose();
        }

        /// <summary>
        /// Extract the contents of a given entity.
        /// </summary>
        /// <param name="entity">The entity to extract.</param>
        public void Extract(IExtractedEntity entity)
        {
            foreach (var content in entity.Contents)
            {
                content.Extract(this);
            }
        }

        public void WriteAssemblyPrefix(TextWriter trapFile)
        {
            var def = mdReader.GetAssemblyDefinition();
            trapFile.Write(GetString(def.Name));
            trapFile.Write('_');
            trapFile.Write(def.Version.ToString());
            trapFile.Write("::");
        }

        public readonly Entities.TypeSignatureDecoder TypeSignatureDecoder;

        /// <summary>
        /// A type used to signify something we can't handle yet.
        /// Specifically, function pointers (used in C++).
        /// </summary>
        public Entities.Type ErrorType
        {
            get
            {
                var errorType = new Entities.ErrorType(this);
                Populate(errorType);
                return errorType;
            }
        }

        /// <summary>
        /// Attempt to locate debugging information for a particular method.
        ///
        ///     Returns null on failure, for example if there was no PDB information found for the
        ///     DLL, or if the particular method is compiler generated or doesn't come from source code.
        /// </summary>
        /// <param name="handle">The handle of the method.</param>
        /// <returns>The debugging information, or null if the information could not be located.</returns>
        public PDB.IMethod GetMethodDebugInformation(MethodDefinitionHandle handle)
        {
            return pdb == null ? null : pdb.GetMethod(handle.ToDebugInformationHandle());
        }
    }

    /// <summary>
    /// When we decode a type/method signature, we need access to
    /// generic parameters.
    /// </summary>
    public abstract class GenericContext
    {
        public Context cx;

        public GenericContext(Context cx)
        {
            this.cx = cx;
        }

        /// <summary>
        /// The list of generic type parameters.
        /// </summary>
        public abstract IEnumerable<Entities.Type> TypeParameters { get; }

        /// <summary>
        /// The list of generic method parameters.
        /// </summary>
        public abstract IEnumerable<Entities.Type> MethodParameters { get; }

        /// <summary>
        /// Gets the `p`th type parameter.
        /// </summary>
        /// <param name="p">The index of the parameter.</param>
        /// <returns>
        /// For constructed types, the supplied type.
        /// For unbound types, the type parameter.
        /// </returns>
        public Entities.Type GetGenericTypeParameter(int p)
        {
            return TypeParameters.ElementAt(p);
        }

        /// <summary>
        /// Gets the `p`th method type parameter.
        /// </summary>
        /// <param name="p">The index of the parameter.</param>
        /// <returns>
        /// For constructed types, the supplied type.
        /// For unbound types, the type parameter.
        /// </returns>
        public Entities.Type GetGenericMethodParameter(int p)
        {
            return MethodParameters.ElementAt(p);
        }
    }

    /// <summary>
    /// A generic context which does not contain any type parameters.
    /// </summary>
    public class EmptyContext : GenericContext
    {
        public EmptyContext(Context cx) : base(cx)
        {
        }

        public override IEnumerable<Entities.Type> TypeParameters { get { yield break; } }

        public override IEnumerable<Entities.Type> MethodParameters { get { yield break; } }
    }
}
