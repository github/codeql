// This file contains auto-generated code.

namespace System
{
    namespace Diagnostics
    {
        // Generated from `System.Diagnostics.StackFrame` in `System.Diagnostics.StackTrace, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public class StackFrame
        {
            public virtual int GetFileColumnNumber() => throw null;
            public virtual int GetFileLineNumber() => throw null;
            public virtual string GetFileName() => throw null;
            public virtual int GetILOffset() => throw null;
            public virtual System.Reflection.MethodBase GetMethod() => throw null;
            public virtual int GetNativeOffset() => throw null;
            public const int OFFSET_UNKNOWN = default;
            public StackFrame() => throw null;
            public StackFrame(bool needFileInfo) => throw null;
            public StackFrame(int skipFrames) => throw null;
            public StackFrame(int skipFrames, bool needFileInfo) => throw null;
            public StackFrame(string fileName, int lineNumber) => throw null;
            public StackFrame(string fileName, int lineNumber, int colNumber) => throw null;
            public override string ToString() => throw null;
        }

        // Generated from `System.Diagnostics.StackFrameExtensions` in `System.Diagnostics.StackTrace, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public static class StackFrameExtensions
        {
            public static System.IntPtr GetNativeIP(this System.Diagnostics.StackFrame stackFrame) => throw null;
            public static System.IntPtr GetNativeImageBase(this System.Diagnostics.StackFrame stackFrame) => throw null;
            public static bool HasILOffset(this System.Diagnostics.StackFrame stackFrame) => throw null;
            public static bool HasMethod(this System.Diagnostics.StackFrame stackFrame) => throw null;
            public static bool HasNativeImage(this System.Diagnostics.StackFrame stackFrame) => throw null;
            public static bool HasSource(this System.Diagnostics.StackFrame stackFrame) => throw null;
        }

        // Generated from `System.Diagnostics.StackTrace` in `System.Diagnostics.StackTrace, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public class StackTrace
        {
            public virtual int FrameCount { get => throw null; }
            public virtual System.Diagnostics.StackFrame GetFrame(int index) => throw null;
            public virtual System.Diagnostics.StackFrame[] GetFrames() => throw null;
            public const int METHODS_TO_SKIP = default;
            public StackTrace() => throw null;
            public StackTrace(System.Exception e) => throw null;
            public StackTrace(System.Exception e, bool fNeedFileInfo) => throw null;
            public StackTrace(System.Exception e, int skipFrames) => throw null;
            public StackTrace(System.Exception e, int skipFrames, bool fNeedFileInfo) => throw null;
            public StackTrace(System.Diagnostics.StackFrame frame) => throw null;
            public StackTrace(bool fNeedFileInfo) => throw null;
            public StackTrace(int skipFrames) => throw null;
            public StackTrace(int skipFrames, bool fNeedFileInfo) => throw null;
            public override string ToString() => throw null;
        }

        namespace SymbolStore
        {
            // Generated from `System.Diagnostics.SymbolStore.ISymbolBinder` in `System.Diagnostics.StackTrace, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public interface ISymbolBinder
            {
                System.Diagnostics.SymbolStore.ISymbolReader GetReader(int importer, string filename, string searchPath);
            }

            // Generated from `System.Diagnostics.SymbolStore.ISymbolBinder1` in `System.Diagnostics.StackTrace, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public interface ISymbolBinder1
            {
                System.Diagnostics.SymbolStore.ISymbolReader GetReader(System.IntPtr importer, string filename, string searchPath);
            }

            // Generated from `System.Diagnostics.SymbolStore.ISymbolDocument` in `System.Diagnostics.StackTrace, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public interface ISymbolDocument
            {
                System.Guid CheckSumAlgorithmId { get; }
                System.Guid DocumentType { get; }
                int FindClosestLine(int line);
                System.Byte[] GetCheckSum();
                System.Byte[] GetSourceRange(int startLine, int startColumn, int endLine, int endColumn);
                bool HasEmbeddedSource { get; }
                System.Guid Language { get; }
                System.Guid LanguageVendor { get; }
                int SourceLength { get; }
                string URL { get; }
            }

            // Generated from `System.Diagnostics.SymbolStore.ISymbolDocumentWriter` in `System.Diagnostics.StackTrace, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public interface ISymbolDocumentWriter
            {
                void SetCheckSum(System.Guid algorithmId, System.Byte[] checkSum);
                void SetSource(System.Byte[] source);
            }

            // Generated from `System.Diagnostics.SymbolStore.ISymbolMethod` in `System.Diagnostics.StackTrace, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public interface ISymbolMethod
            {
                System.Diagnostics.SymbolStore.ISymbolNamespace GetNamespace();
                int GetOffset(System.Diagnostics.SymbolStore.ISymbolDocument document, int line, int column);
                System.Diagnostics.SymbolStore.ISymbolVariable[] GetParameters();
                int[] GetRanges(System.Diagnostics.SymbolStore.ISymbolDocument document, int line, int column);
                System.Diagnostics.SymbolStore.ISymbolScope GetScope(int offset);
                void GetSequencePoints(int[] offsets, System.Diagnostics.SymbolStore.ISymbolDocument[] documents, int[] lines, int[] columns, int[] endLines, int[] endColumns);
                bool GetSourceStartEnd(System.Diagnostics.SymbolStore.ISymbolDocument[] docs, int[] lines, int[] columns);
                System.Diagnostics.SymbolStore.ISymbolScope RootScope { get; }
                int SequencePointCount { get; }
                System.Diagnostics.SymbolStore.SymbolToken Token { get; }
            }

            // Generated from `System.Diagnostics.SymbolStore.ISymbolNamespace` in `System.Diagnostics.StackTrace, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public interface ISymbolNamespace
            {
                System.Diagnostics.SymbolStore.ISymbolNamespace[] GetNamespaces();
                System.Diagnostics.SymbolStore.ISymbolVariable[] GetVariables();
                string Name { get; }
            }

            // Generated from `System.Diagnostics.SymbolStore.ISymbolReader` in `System.Diagnostics.StackTrace, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public interface ISymbolReader
            {
                System.Diagnostics.SymbolStore.ISymbolDocument GetDocument(string url, System.Guid language, System.Guid languageVendor, System.Guid documentType);
                System.Diagnostics.SymbolStore.ISymbolDocument[] GetDocuments();
                System.Diagnostics.SymbolStore.ISymbolVariable[] GetGlobalVariables();
                System.Diagnostics.SymbolStore.ISymbolMethod GetMethod(System.Diagnostics.SymbolStore.SymbolToken method);
                System.Diagnostics.SymbolStore.ISymbolMethod GetMethod(System.Diagnostics.SymbolStore.SymbolToken method, int version);
                System.Diagnostics.SymbolStore.ISymbolMethod GetMethodFromDocumentPosition(System.Diagnostics.SymbolStore.ISymbolDocument document, int line, int column);
                System.Diagnostics.SymbolStore.ISymbolNamespace[] GetNamespaces();
                System.Byte[] GetSymAttribute(System.Diagnostics.SymbolStore.SymbolToken parent, string name);
                System.Diagnostics.SymbolStore.ISymbolVariable[] GetVariables(System.Diagnostics.SymbolStore.SymbolToken parent);
                System.Diagnostics.SymbolStore.SymbolToken UserEntryPoint { get; }
            }

            // Generated from `System.Diagnostics.SymbolStore.ISymbolScope` in `System.Diagnostics.StackTrace, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public interface ISymbolScope
            {
                int EndOffset { get; }
                System.Diagnostics.SymbolStore.ISymbolScope[] GetChildren();
                System.Diagnostics.SymbolStore.ISymbolVariable[] GetLocals();
                System.Diagnostics.SymbolStore.ISymbolNamespace[] GetNamespaces();
                System.Diagnostics.SymbolStore.ISymbolMethod Method { get; }
                System.Diagnostics.SymbolStore.ISymbolScope Parent { get; }
                int StartOffset { get; }
            }

            // Generated from `System.Diagnostics.SymbolStore.ISymbolVariable` in `System.Diagnostics.StackTrace, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public interface ISymbolVariable
            {
                int AddressField1 { get; }
                int AddressField2 { get; }
                int AddressField3 { get; }
                System.Diagnostics.SymbolStore.SymAddressKind AddressKind { get; }
                object Attributes { get; }
                int EndOffset { get; }
                System.Byte[] GetSignature();
                string Name { get; }
                int StartOffset { get; }
            }

            // Generated from `System.Diagnostics.SymbolStore.ISymbolWriter` in `System.Diagnostics.StackTrace, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public interface ISymbolWriter
            {
                void Close();
                void CloseMethod();
                void CloseNamespace();
                void CloseScope(int endOffset);
                System.Diagnostics.SymbolStore.ISymbolDocumentWriter DefineDocument(string url, System.Guid language, System.Guid languageVendor, System.Guid documentType);
                void DefineField(System.Diagnostics.SymbolStore.SymbolToken parent, string name, System.Reflection.FieldAttributes attributes, System.Byte[] signature, System.Diagnostics.SymbolStore.SymAddressKind addrKind, int addr1, int addr2, int addr3);
                void DefineGlobalVariable(string name, System.Reflection.FieldAttributes attributes, System.Byte[] signature, System.Diagnostics.SymbolStore.SymAddressKind addrKind, int addr1, int addr2, int addr3);
                void DefineLocalVariable(string name, System.Reflection.FieldAttributes attributes, System.Byte[] signature, System.Diagnostics.SymbolStore.SymAddressKind addrKind, int addr1, int addr2, int addr3, int startOffset, int endOffset);
                void DefineParameter(string name, System.Reflection.ParameterAttributes attributes, int sequence, System.Diagnostics.SymbolStore.SymAddressKind addrKind, int addr1, int addr2, int addr3);
                void DefineSequencePoints(System.Diagnostics.SymbolStore.ISymbolDocumentWriter document, int[] offsets, int[] lines, int[] columns, int[] endLines, int[] endColumns);
                void Initialize(System.IntPtr emitter, string filename, bool fFullBuild);
                void OpenMethod(System.Diagnostics.SymbolStore.SymbolToken method);
                void OpenNamespace(string name);
                int OpenScope(int startOffset);
                void SetMethodSourceRange(System.Diagnostics.SymbolStore.ISymbolDocumentWriter startDoc, int startLine, int startColumn, System.Diagnostics.SymbolStore.ISymbolDocumentWriter endDoc, int endLine, int endColumn);
                void SetScopeRange(int scopeID, int startOffset, int endOffset);
                void SetSymAttribute(System.Diagnostics.SymbolStore.SymbolToken parent, string name, System.Byte[] data);
                void SetUnderlyingWriter(System.IntPtr underlyingWriter);
                void SetUserEntryPoint(System.Diagnostics.SymbolStore.SymbolToken entryMethod);
                void UsingNamespace(string fullName);
            }

            // Generated from `System.Diagnostics.SymbolStore.SymAddressKind` in `System.Diagnostics.StackTrace, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public enum SymAddressKind
            {
                BitField,
                ILOffset,
                NativeOffset,
                NativeRVA,
                NativeRegister,
                NativeRegisterRegister,
                NativeRegisterRelative,
                NativeRegisterStack,
                NativeSectionOffset,
                NativeStackRegister,
            }

            // Generated from `System.Diagnostics.SymbolStore.SymDocumentType` in `System.Diagnostics.StackTrace, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class SymDocumentType
            {
                public SymDocumentType() => throw null;
                public static System.Guid Text;
            }

            // Generated from `System.Diagnostics.SymbolStore.SymLanguageType` in `System.Diagnostics.StackTrace, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class SymLanguageType
            {
                public static System.Guid Basic;
                public static System.Guid C;
                public static System.Guid CPlusPlus;
                public static System.Guid CSharp;
                public static System.Guid Cobol;
                public static System.Guid ILAssembly;
                public static System.Guid JScript;
                public static System.Guid Java;
                public static System.Guid MCPlusPlus;
                public static System.Guid Pascal;
                public static System.Guid SMC;
                public SymLanguageType() => throw null;
            }

            // Generated from `System.Diagnostics.SymbolStore.SymLanguageVendor` in `System.Diagnostics.StackTrace, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class SymLanguageVendor
            {
                public static System.Guid Microsoft;
                public SymLanguageVendor() => throw null;
            }

            // Generated from `System.Diagnostics.SymbolStore.SymbolToken` in `System.Diagnostics.StackTrace, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public struct SymbolToken
            {
                public static bool operator !=(System.Diagnostics.SymbolStore.SymbolToken a, System.Diagnostics.SymbolStore.SymbolToken b) => throw null;
                public static bool operator ==(System.Diagnostics.SymbolStore.SymbolToken a, System.Diagnostics.SymbolStore.SymbolToken b) => throw null;
                public bool Equals(System.Diagnostics.SymbolStore.SymbolToken obj) => throw null;
                public override bool Equals(object obj) => throw null;
                public override int GetHashCode() => throw null;
                public int GetToken() => throw null;
                // Stub generator skipped constructor 
                public SymbolToken(int val) => throw null;
            }

        }
    }
}
