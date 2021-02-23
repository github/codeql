using System;
using Microsoft.DiaSymReader;
using System.Reflection;

#pragma warning disable IDE0060, CA1822

namespace Semmle.Extraction.PDB
{
    /// <summary>
    /// This is not used but is seemingly needed in order to use DiaSymReader.
    /// </summary>
    internal class MdProvider : ISymReaderMetadataProvider
    {
        public MdProvider()
        {
        }

        public object? GetMetadataImport() => null;

        public unsafe bool TryGetStandaloneSignature(int standaloneSignatureToken, out byte* signature, out int length) =>
            throw new NotImplementedException();

        public bool TryGetTypeDefinitionInfo(int typeDefinitionToken, out string namespaceName, out string typeName, out TypeAttributes attributes, out int baseTypeToken) =>
            throw new NotImplementedException();

        public bool TryGetTypeDefinitionInfo(int typeDefinitionToken, out string namespaceName, out string typeName, out TypeAttributes attributes) =>
            throw new NotImplementedException();

        public bool TryGetTypeReferenceInfo(int typeReferenceToken, out string namespaceName, out string typeName, out int resolutionScopeToken) =>
            throw new NotImplementedException();

        public bool TryGetTypeReferenceInfo(int typeReferenceToken, out string namespaceName, out string typeName) =>
            throw new NotImplementedException();
    }
}

#pragma warning restore
