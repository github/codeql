// This file contains auto-generated code.
// Generated from `System.CodeDom, Version=4.0.3.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`.
namespace Microsoft
{
    namespace CSharp
    {
        public class CSharpCodeProvider : System.CodeDom.Compiler.CodeDomProvider
        {
            public override System.CodeDom.Compiler.ICodeCompiler CreateCompiler() => throw null;
            public override System.CodeDom.Compiler.ICodeGenerator CreateGenerator() => throw null;
            public CSharpCodeProvider() => throw null;
            public CSharpCodeProvider(System.Collections.Generic.IDictionary<string, string> providerOptions) => throw null;
            public override string FileExtension { get => throw null; }
            public override void GenerateCodeFromMember(System.CodeDom.CodeTypeMember member, System.IO.TextWriter writer, System.CodeDom.Compiler.CodeGeneratorOptions options) => throw null;
            public override System.ComponentModel.TypeConverter GetConverter(System.Type type) => throw null;
        }
    }
    namespace VisualBasic
    {
        public class VBCodeProvider : System.CodeDom.Compiler.CodeDomProvider
        {
            public override System.CodeDom.Compiler.ICodeCompiler CreateCompiler() => throw null;
            public override System.CodeDom.Compiler.ICodeGenerator CreateGenerator() => throw null;
            public VBCodeProvider() => throw null;
            public VBCodeProvider(System.Collections.Generic.IDictionary<string, string> providerOptions) => throw null;
            public override string FileExtension { get => throw null; }
            public override void GenerateCodeFromMember(System.CodeDom.CodeTypeMember member, System.IO.TextWriter writer, System.CodeDom.Compiler.CodeGeneratorOptions options) => throw null;
            public override System.ComponentModel.TypeConverter GetConverter(System.Type type) => throw null;
            public override System.CodeDom.Compiler.LanguageOptions LanguageOptions { get => throw null; }
        }
    }
}
namespace System
{
    namespace CodeDom
    {
        public class CodeArgumentReferenceExpression : System.CodeDom.CodeExpression
        {
            public CodeArgumentReferenceExpression() => throw null;
            public CodeArgumentReferenceExpression(string parameterName) => throw null;
            public string ParameterName { get => throw null; set { } }
        }
        public class CodeArrayCreateExpression : System.CodeDom.CodeExpression
        {
            public System.CodeDom.CodeTypeReference CreateType { get => throw null; set { } }
            public CodeArrayCreateExpression() => throw null;
            public CodeArrayCreateExpression(System.CodeDom.CodeTypeReference createType, System.CodeDom.CodeExpression size) => throw null;
            public CodeArrayCreateExpression(System.CodeDom.CodeTypeReference createType, params System.CodeDom.CodeExpression[] initializers) => throw null;
            public CodeArrayCreateExpression(System.CodeDom.CodeTypeReference createType, int size) => throw null;
            public CodeArrayCreateExpression(string createType, System.CodeDom.CodeExpression size) => throw null;
            public CodeArrayCreateExpression(string createType, params System.CodeDom.CodeExpression[] initializers) => throw null;
            public CodeArrayCreateExpression(string createType, int size) => throw null;
            public CodeArrayCreateExpression(System.Type createType, System.CodeDom.CodeExpression size) => throw null;
            public CodeArrayCreateExpression(System.Type createType, params System.CodeDom.CodeExpression[] initializers) => throw null;
            public CodeArrayCreateExpression(System.Type createType, int size) => throw null;
            public System.CodeDom.CodeExpressionCollection Initializers { get => throw null; }
            public int Size { get => throw null; set { } }
            public System.CodeDom.CodeExpression SizeExpression { get => throw null; set { } }
        }
        public class CodeArrayIndexerExpression : System.CodeDom.CodeExpression
        {
            public CodeArrayIndexerExpression() => throw null;
            public CodeArrayIndexerExpression(System.CodeDom.CodeExpression targetObject, params System.CodeDom.CodeExpression[] indices) => throw null;
            public System.CodeDom.CodeExpressionCollection Indices { get => throw null; }
            public System.CodeDom.CodeExpression TargetObject { get => throw null; set { } }
        }
        public class CodeAssignStatement : System.CodeDom.CodeStatement
        {
            public CodeAssignStatement() => throw null;
            public CodeAssignStatement(System.CodeDom.CodeExpression left, System.CodeDom.CodeExpression right) => throw null;
            public System.CodeDom.CodeExpression Left { get => throw null; set { } }
            public System.CodeDom.CodeExpression Right { get => throw null; set { } }
        }
        public class CodeAttachEventStatement : System.CodeDom.CodeStatement
        {
            public CodeAttachEventStatement() => throw null;
            public CodeAttachEventStatement(System.CodeDom.CodeEventReferenceExpression eventRef, System.CodeDom.CodeExpression listener) => throw null;
            public CodeAttachEventStatement(System.CodeDom.CodeExpression targetObject, string eventName, System.CodeDom.CodeExpression listener) => throw null;
            public System.CodeDom.CodeEventReferenceExpression Event { get => throw null; set { } }
            public System.CodeDom.CodeExpression Listener { get => throw null; set { } }
        }
        public class CodeAttributeArgument
        {
            public CodeAttributeArgument() => throw null;
            public CodeAttributeArgument(System.CodeDom.CodeExpression value) => throw null;
            public CodeAttributeArgument(string name, System.CodeDom.CodeExpression value) => throw null;
            public string Name { get => throw null; set { } }
            public System.CodeDom.CodeExpression Value { get => throw null; set { } }
        }
        public class CodeAttributeArgumentCollection : System.Collections.CollectionBase
        {
            public int Add(System.CodeDom.CodeAttributeArgument value) => throw null;
            public void AddRange(System.CodeDom.CodeAttributeArgumentCollection value) => throw null;
            public void AddRange(System.CodeDom.CodeAttributeArgument[] value) => throw null;
            public bool Contains(System.CodeDom.CodeAttributeArgument value) => throw null;
            public void CopyTo(System.CodeDom.CodeAttributeArgument[] array, int index) => throw null;
            public CodeAttributeArgumentCollection() => throw null;
            public CodeAttributeArgumentCollection(System.CodeDom.CodeAttributeArgumentCollection value) => throw null;
            public CodeAttributeArgumentCollection(System.CodeDom.CodeAttributeArgument[] value) => throw null;
            public int IndexOf(System.CodeDom.CodeAttributeArgument value) => throw null;
            public void Insert(int index, System.CodeDom.CodeAttributeArgument value) => throw null;
            public void Remove(System.CodeDom.CodeAttributeArgument value) => throw null;
            public System.CodeDom.CodeAttributeArgument this[int index] { get => throw null; set { } }
        }
        public class CodeAttributeDeclaration
        {
            public System.CodeDom.CodeAttributeArgumentCollection Arguments { get => throw null; }
            public System.CodeDom.CodeTypeReference AttributeType { get => throw null; }
            public CodeAttributeDeclaration() => throw null;
            public CodeAttributeDeclaration(System.CodeDom.CodeTypeReference attributeType) => throw null;
            public CodeAttributeDeclaration(System.CodeDom.CodeTypeReference attributeType, params System.CodeDom.CodeAttributeArgument[] arguments) => throw null;
            public CodeAttributeDeclaration(string name) => throw null;
            public CodeAttributeDeclaration(string name, params System.CodeDom.CodeAttributeArgument[] arguments) => throw null;
            public string Name { get => throw null; set { } }
        }
        public class CodeAttributeDeclarationCollection : System.Collections.CollectionBase
        {
            public int Add(System.CodeDom.CodeAttributeDeclaration value) => throw null;
            public void AddRange(System.CodeDom.CodeAttributeDeclarationCollection value) => throw null;
            public void AddRange(System.CodeDom.CodeAttributeDeclaration[] value) => throw null;
            public bool Contains(System.CodeDom.CodeAttributeDeclaration value) => throw null;
            public void CopyTo(System.CodeDom.CodeAttributeDeclaration[] array, int index) => throw null;
            public CodeAttributeDeclarationCollection() => throw null;
            public CodeAttributeDeclarationCollection(System.CodeDom.CodeAttributeDeclarationCollection value) => throw null;
            public CodeAttributeDeclarationCollection(System.CodeDom.CodeAttributeDeclaration[] value) => throw null;
            public int IndexOf(System.CodeDom.CodeAttributeDeclaration value) => throw null;
            public void Insert(int index, System.CodeDom.CodeAttributeDeclaration value) => throw null;
            public void Remove(System.CodeDom.CodeAttributeDeclaration value) => throw null;
            public System.CodeDom.CodeAttributeDeclaration this[int index] { get => throw null; set { } }
        }
        public class CodeBaseReferenceExpression : System.CodeDom.CodeExpression
        {
            public CodeBaseReferenceExpression() => throw null;
        }
        public class CodeBinaryOperatorExpression : System.CodeDom.CodeExpression
        {
            public CodeBinaryOperatorExpression() => throw null;
            public CodeBinaryOperatorExpression(System.CodeDom.CodeExpression left, System.CodeDom.CodeBinaryOperatorType op, System.CodeDom.CodeExpression right) => throw null;
            public System.CodeDom.CodeExpression Left { get => throw null; set { } }
            public System.CodeDom.CodeBinaryOperatorType Operator { get => throw null; set { } }
            public System.CodeDom.CodeExpression Right { get => throw null; set { } }
        }
        public enum CodeBinaryOperatorType
        {
            Add = 0,
            Subtract = 1,
            Multiply = 2,
            Divide = 3,
            Modulus = 4,
            Assign = 5,
            IdentityInequality = 6,
            IdentityEquality = 7,
            ValueEquality = 8,
            BitwiseOr = 9,
            BitwiseAnd = 10,
            BooleanOr = 11,
            BooleanAnd = 12,
            LessThan = 13,
            LessThanOrEqual = 14,
            GreaterThan = 15,
            GreaterThanOrEqual = 16,
        }
        public class CodeCastExpression : System.CodeDom.CodeExpression
        {
            public CodeCastExpression() => throw null;
            public CodeCastExpression(System.CodeDom.CodeTypeReference targetType, System.CodeDom.CodeExpression expression) => throw null;
            public CodeCastExpression(string targetType, System.CodeDom.CodeExpression expression) => throw null;
            public CodeCastExpression(System.Type targetType, System.CodeDom.CodeExpression expression) => throw null;
            public System.CodeDom.CodeExpression Expression { get => throw null; set { } }
            public System.CodeDom.CodeTypeReference TargetType { get => throw null; set { } }
        }
        public class CodeCatchClause
        {
            public System.CodeDom.CodeTypeReference CatchExceptionType { get => throw null; set { } }
            public CodeCatchClause() => throw null;
            public CodeCatchClause(string localName) => throw null;
            public CodeCatchClause(string localName, System.CodeDom.CodeTypeReference catchExceptionType) => throw null;
            public CodeCatchClause(string localName, System.CodeDom.CodeTypeReference catchExceptionType, params System.CodeDom.CodeStatement[] statements) => throw null;
            public string LocalName { get => throw null; set { } }
            public System.CodeDom.CodeStatementCollection Statements { get => throw null; }
        }
        public class CodeCatchClauseCollection : System.Collections.CollectionBase
        {
            public int Add(System.CodeDom.CodeCatchClause value) => throw null;
            public void AddRange(System.CodeDom.CodeCatchClauseCollection value) => throw null;
            public void AddRange(System.CodeDom.CodeCatchClause[] value) => throw null;
            public bool Contains(System.CodeDom.CodeCatchClause value) => throw null;
            public void CopyTo(System.CodeDom.CodeCatchClause[] array, int index) => throw null;
            public CodeCatchClauseCollection() => throw null;
            public CodeCatchClauseCollection(System.CodeDom.CodeCatchClauseCollection value) => throw null;
            public CodeCatchClauseCollection(System.CodeDom.CodeCatchClause[] value) => throw null;
            public int IndexOf(System.CodeDom.CodeCatchClause value) => throw null;
            public void Insert(int index, System.CodeDom.CodeCatchClause value) => throw null;
            public void Remove(System.CodeDom.CodeCatchClause value) => throw null;
            public System.CodeDom.CodeCatchClause this[int index] { get => throw null; set { } }
        }
        public class CodeChecksumPragma : System.CodeDom.CodeDirective
        {
            public System.Guid ChecksumAlgorithmId { get => throw null; set { } }
            public byte[] ChecksumData { get => throw null; set { } }
            public CodeChecksumPragma() => throw null;
            public CodeChecksumPragma(string fileName, System.Guid checksumAlgorithmId, byte[] checksumData) => throw null;
            public string FileName { get => throw null; set { } }
        }
        public class CodeComment : System.CodeDom.CodeObject
        {
            public CodeComment() => throw null;
            public CodeComment(string text) => throw null;
            public CodeComment(string text, bool docComment) => throw null;
            public bool DocComment { get => throw null; set { } }
            public string Text { get => throw null; set { } }
        }
        public class CodeCommentStatement : System.CodeDom.CodeStatement
        {
            public System.CodeDom.CodeComment Comment { get => throw null; set { } }
            public CodeCommentStatement() => throw null;
            public CodeCommentStatement(System.CodeDom.CodeComment comment) => throw null;
            public CodeCommentStatement(string text) => throw null;
            public CodeCommentStatement(string text, bool docComment) => throw null;
        }
        public class CodeCommentStatementCollection : System.Collections.CollectionBase
        {
            public int Add(System.CodeDom.CodeCommentStatement value) => throw null;
            public void AddRange(System.CodeDom.CodeCommentStatementCollection value) => throw null;
            public void AddRange(System.CodeDom.CodeCommentStatement[] value) => throw null;
            public bool Contains(System.CodeDom.CodeCommentStatement value) => throw null;
            public void CopyTo(System.CodeDom.CodeCommentStatement[] array, int index) => throw null;
            public CodeCommentStatementCollection() => throw null;
            public CodeCommentStatementCollection(System.CodeDom.CodeCommentStatementCollection value) => throw null;
            public CodeCommentStatementCollection(System.CodeDom.CodeCommentStatement[] value) => throw null;
            public int IndexOf(System.CodeDom.CodeCommentStatement value) => throw null;
            public void Insert(int index, System.CodeDom.CodeCommentStatement value) => throw null;
            public void Remove(System.CodeDom.CodeCommentStatement value) => throw null;
            public System.CodeDom.CodeCommentStatement this[int index] { get => throw null; set { } }
        }
        public class CodeCompileUnit : System.CodeDom.CodeObject
        {
            public System.CodeDom.CodeAttributeDeclarationCollection AssemblyCustomAttributes { get => throw null; }
            public CodeCompileUnit() => throw null;
            public System.CodeDom.CodeDirectiveCollection EndDirectives { get => throw null; }
            public System.CodeDom.CodeNamespaceCollection Namespaces { get => throw null; }
            public System.Collections.Specialized.StringCollection ReferencedAssemblies { get => throw null; }
            public System.CodeDom.CodeDirectiveCollection StartDirectives { get => throw null; }
        }
        public class CodeConditionStatement : System.CodeDom.CodeStatement
        {
            public System.CodeDom.CodeExpression Condition { get => throw null; set { } }
            public CodeConditionStatement() => throw null;
            public CodeConditionStatement(System.CodeDom.CodeExpression condition, params System.CodeDom.CodeStatement[] trueStatements) => throw null;
            public CodeConditionStatement(System.CodeDom.CodeExpression condition, System.CodeDom.CodeStatement[] trueStatements, System.CodeDom.CodeStatement[] falseStatements) => throw null;
            public System.CodeDom.CodeStatementCollection FalseStatements { get => throw null; }
            public System.CodeDom.CodeStatementCollection TrueStatements { get => throw null; }
        }
        public class CodeConstructor : System.CodeDom.CodeMemberMethod
        {
            public System.CodeDom.CodeExpressionCollection BaseConstructorArgs { get => throw null; }
            public System.CodeDom.CodeExpressionCollection ChainedConstructorArgs { get => throw null; }
            public CodeConstructor() => throw null;
        }
        public class CodeDefaultValueExpression : System.CodeDom.CodeExpression
        {
            public CodeDefaultValueExpression() => throw null;
            public CodeDefaultValueExpression(System.CodeDom.CodeTypeReference type) => throw null;
            public System.CodeDom.CodeTypeReference Type { get => throw null; set { } }
        }
        public class CodeDelegateCreateExpression : System.CodeDom.CodeExpression
        {
            public CodeDelegateCreateExpression() => throw null;
            public CodeDelegateCreateExpression(System.CodeDom.CodeTypeReference delegateType, System.CodeDom.CodeExpression targetObject, string methodName) => throw null;
            public System.CodeDom.CodeTypeReference DelegateType { get => throw null; set { } }
            public string MethodName { get => throw null; set { } }
            public System.CodeDom.CodeExpression TargetObject { get => throw null; set { } }
        }
        public class CodeDelegateInvokeExpression : System.CodeDom.CodeExpression
        {
            public CodeDelegateInvokeExpression() => throw null;
            public CodeDelegateInvokeExpression(System.CodeDom.CodeExpression targetObject) => throw null;
            public CodeDelegateInvokeExpression(System.CodeDom.CodeExpression targetObject, params System.CodeDom.CodeExpression[] parameters) => throw null;
            public System.CodeDom.CodeExpressionCollection Parameters { get => throw null; }
            public System.CodeDom.CodeExpression TargetObject { get => throw null; set { } }
        }
        public class CodeDirectionExpression : System.CodeDom.CodeExpression
        {
            public CodeDirectionExpression() => throw null;
            public CodeDirectionExpression(System.CodeDom.FieldDirection direction, System.CodeDom.CodeExpression expression) => throw null;
            public System.CodeDom.FieldDirection Direction { get => throw null; set { } }
            public System.CodeDom.CodeExpression Expression { get => throw null; set { } }
        }
        public class CodeDirective : System.CodeDom.CodeObject
        {
            public CodeDirective() => throw null;
        }
        public class CodeDirectiveCollection : System.Collections.CollectionBase
        {
            public int Add(System.CodeDom.CodeDirective value) => throw null;
            public void AddRange(System.CodeDom.CodeDirectiveCollection value) => throw null;
            public void AddRange(System.CodeDom.CodeDirective[] value) => throw null;
            public bool Contains(System.CodeDom.CodeDirective value) => throw null;
            public void CopyTo(System.CodeDom.CodeDirective[] array, int index) => throw null;
            public CodeDirectiveCollection() => throw null;
            public CodeDirectiveCollection(System.CodeDom.CodeDirectiveCollection value) => throw null;
            public CodeDirectiveCollection(System.CodeDom.CodeDirective[] value) => throw null;
            public int IndexOf(System.CodeDom.CodeDirective value) => throw null;
            public void Insert(int index, System.CodeDom.CodeDirective value) => throw null;
            public void Remove(System.CodeDom.CodeDirective value) => throw null;
            public System.CodeDom.CodeDirective this[int index] { get => throw null; set { } }
        }
        public class CodeEntryPointMethod : System.CodeDom.CodeMemberMethod
        {
            public CodeEntryPointMethod() => throw null;
        }
        public class CodeEventReferenceExpression : System.CodeDom.CodeExpression
        {
            public CodeEventReferenceExpression() => throw null;
            public CodeEventReferenceExpression(System.CodeDom.CodeExpression targetObject, string eventName) => throw null;
            public string EventName { get => throw null; set { } }
            public System.CodeDom.CodeExpression TargetObject { get => throw null; set { } }
        }
        public class CodeExpression : System.CodeDom.CodeObject
        {
            public CodeExpression() => throw null;
        }
        public class CodeExpressionCollection : System.Collections.CollectionBase
        {
            public int Add(System.CodeDom.CodeExpression value) => throw null;
            public void AddRange(System.CodeDom.CodeExpressionCollection value) => throw null;
            public void AddRange(System.CodeDom.CodeExpression[] value) => throw null;
            public bool Contains(System.CodeDom.CodeExpression value) => throw null;
            public void CopyTo(System.CodeDom.CodeExpression[] array, int index) => throw null;
            public CodeExpressionCollection() => throw null;
            public CodeExpressionCollection(System.CodeDom.CodeExpressionCollection value) => throw null;
            public CodeExpressionCollection(System.CodeDom.CodeExpression[] value) => throw null;
            public int IndexOf(System.CodeDom.CodeExpression value) => throw null;
            public void Insert(int index, System.CodeDom.CodeExpression value) => throw null;
            public void Remove(System.CodeDom.CodeExpression value) => throw null;
            public System.CodeDom.CodeExpression this[int index] { get => throw null; set { } }
        }
        public class CodeExpressionStatement : System.CodeDom.CodeStatement
        {
            public CodeExpressionStatement() => throw null;
            public CodeExpressionStatement(System.CodeDom.CodeExpression expression) => throw null;
            public System.CodeDom.CodeExpression Expression { get => throw null; set { } }
        }
        public class CodeFieldReferenceExpression : System.CodeDom.CodeExpression
        {
            public CodeFieldReferenceExpression() => throw null;
            public CodeFieldReferenceExpression(System.CodeDom.CodeExpression targetObject, string fieldName) => throw null;
            public string FieldName { get => throw null; set { } }
            public System.CodeDom.CodeExpression TargetObject { get => throw null; set { } }
        }
        public class CodeGotoStatement : System.CodeDom.CodeStatement
        {
            public CodeGotoStatement() => throw null;
            public CodeGotoStatement(string label) => throw null;
            public string Label { get => throw null; set { } }
        }
        public class CodeIndexerExpression : System.CodeDom.CodeExpression
        {
            public CodeIndexerExpression() => throw null;
            public CodeIndexerExpression(System.CodeDom.CodeExpression targetObject, params System.CodeDom.CodeExpression[] indices) => throw null;
            public System.CodeDom.CodeExpressionCollection Indices { get => throw null; }
            public System.CodeDom.CodeExpression TargetObject { get => throw null; set { } }
        }
        public class CodeIterationStatement : System.CodeDom.CodeStatement
        {
            public CodeIterationStatement() => throw null;
            public CodeIterationStatement(System.CodeDom.CodeStatement initStatement, System.CodeDom.CodeExpression testExpression, System.CodeDom.CodeStatement incrementStatement, params System.CodeDom.CodeStatement[] statements) => throw null;
            public System.CodeDom.CodeStatement IncrementStatement { get => throw null; set { } }
            public System.CodeDom.CodeStatement InitStatement { get => throw null; set { } }
            public System.CodeDom.CodeStatementCollection Statements { get => throw null; }
            public System.CodeDom.CodeExpression TestExpression { get => throw null; set { } }
        }
        public class CodeLabeledStatement : System.CodeDom.CodeStatement
        {
            public CodeLabeledStatement() => throw null;
            public CodeLabeledStatement(string label) => throw null;
            public CodeLabeledStatement(string label, System.CodeDom.CodeStatement statement) => throw null;
            public string Label { get => throw null; set { } }
            public System.CodeDom.CodeStatement Statement { get => throw null; set { } }
        }
        public class CodeLinePragma
        {
            public CodeLinePragma() => throw null;
            public CodeLinePragma(string fileName, int lineNumber) => throw null;
            public string FileName { get => throw null; set { } }
            public int LineNumber { get => throw null; set { } }
        }
        public class CodeMemberEvent : System.CodeDom.CodeTypeMember
        {
            public CodeMemberEvent() => throw null;
            public System.CodeDom.CodeTypeReferenceCollection ImplementationTypes { get => throw null; }
            public System.CodeDom.CodeTypeReference PrivateImplementationType { get => throw null; set { } }
            public System.CodeDom.CodeTypeReference Type { get => throw null; set { } }
        }
        public class CodeMemberField : System.CodeDom.CodeTypeMember
        {
            public CodeMemberField() => throw null;
            public CodeMemberField(System.CodeDom.CodeTypeReference type, string name) => throw null;
            public CodeMemberField(string type, string name) => throw null;
            public CodeMemberField(System.Type type, string name) => throw null;
            public System.CodeDom.CodeExpression InitExpression { get => throw null; set { } }
            public System.CodeDom.CodeTypeReference Type { get => throw null; set { } }
        }
        public class CodeMemberMethod : System.CodeDom.CodeTypeMember
        {
            public CodeMemberMethod() => throw null;
            public System.CodeDom.CodeTypeReferenceCollection ImplementationTypes { get => throw null; }
            public System.CodeDom.CodeParameterDeclarationExpressionCollection Parameters { get => throw null; }
            public event System.EventHandler PopulateImplementationTypes;
            public event System.EventHandler PopulateParameters;
            public event System.EventHandler PopulateStatements;
            public System.CodeDom.CodeTypeReference PrivateImplementationType { get => throw null; set { } }
            public System.CodeDom.CodeTypeReference ReturnType { get => throw null; set { } }
            public System.CodeDom.CodeAttributeDeclarationCollection ReturnTypeCustomAttributes { get => throw null; }
            public System.CodeDom.CodeStatementCollection Statements { get => throw null; }
            public System.CodeDom.CodeTypeParameterCollection TypeParameters { get => throw null; }
        }
        public class CodeMemberProperty : System.CodeDom.CodeTypeMember
        {
            public CodeMemberProperty() => throw null;
            public System.CodeDom.CodeStatementCollection GetStatements { get => throw null; }
            public bool HasGet { get => throw null; set { } }
            public bool HasSet { get => throw null; set { } }
            public System.CodeDom.CodeTypeReferenceCollection ImplementationTypes { get => throw null; }
            public System.CodeDom.CodeParameterDeclarationExpressionCollection Parameters { get => throw null; }
            public System.CodeDom.CodeTypeReference PrivateImplementationType { get => throw null; set { } }
            public System.CodeDom.CodeStatementCollection SetStatements { get => throw null; }
            public System.CodeDom.CodeTypeReference Type { get => throw null; set { } }
        }
        public class CodeMethodInvokeExpression : System.CodeDom.CodeExpression
        {
            public CodeMethodInvokeExpression() => throw null;
            public CodeMethodInvokeExpression(System.CodeDom.CodeExpression targetObject, string methodName, params System.CodeDom.CodeExpression[] parameters) => throw null;
            public CodeMethodInvokeExpression(System.CodeDom.CodeMethodReferenceExpression method, params System.CodeDom.CodeExpression[] parameters) => throw null;
            public System.CodeDom.CodeMethodReferenceExpression Method { get => throw null; set { } }
            public System.CodeDom.CodeExpressionCollection Parameters { get => throw null; }
        }
        public class CodeMethodReferenceExpression : System.CodeDom.CodeExpression
        {
            public CodeMethodReferenceExpression() => throw null;
            public CodeMethodReferenceExpression(System.CodeDom.CodeExpression targetObject, string methodName) => throw null;
            public CodeMethodReferenceExpression(System.CodeDom.CodeExpression targetObject, string methodName, params System.CodeDom.CodeTypeReference[] typeParameters) => throw null;
            public string MethodName { get => throw null; set { } }
            public System.CodeDom.CodeExpression TargetObject { get => throw null; set { } }
            public System.CodeDom.CodeTypeReferenceCollection TypeArguments { get => throw null; }
        }
        public class CodeMethodReturnStatement : System.CodeDom.CodeStatement
        {
            public CodeMethodReturnStatement() => throw null;
            public CodeMethodReturnStatement(System.CodeDom.CodeExpression expression) => throw null;
            public System.CodeDom.CodeExpression Expression { get => throw null; set { } }
        }
        public class CodeNamespace : System.CodeDom.CodeObject
        {
            public System.CodeDom.CodeCommentStatementCollection Comments { get => throw null; }
            public CodeNamespace() => throw null;
            public CodeNamespace(string name) => throw null;
            public System.CodeDom.CodeNamespaceImportCollection Imports { get => throw null; }
            public string Name { get => throw null; set { } }
            public event System.EventHandler PopulateComments;
            public event System.EventHandler PopulateImports;
            public event System.EventHandler PopulateTypes;
            public System.CodeDom.CodeTypeDeclarationCollection Types { get => throw null; }
        }
        public class CodeNamespaceCollection : System.Collections.CollectionBase
        {
            public int Add(System.CodeDom.CodeNamespace value) => throw null;
            public void AddRange(System.CodeDom.CodeNamespaceCollection value) => throw null;
            public void AddRange(System.CodeDom.CodeNamespace[] value) => throw null;
            public bool Contains(System.CodeDom.CodeNamespace value) => throw null;
            public void CopyTo(System.CodeDom.CodeNamespace[] array, int index) => throw null;
            public CodeNamespaceCollection() => throw null;
            public CodeNamespaceCollection(System.CodeDom.CodeNamespaceCollection value) => throw null;
            public CodeNamespaceCollection(System.CodeDom.CodeNamespace[] value) => throw null;
            public int IndexOf(System.CodeDom.CodeNamespace value) => throw null;
            public void Insert(int index, System.CodeDom.CodeNamespace value) => throw null;
            public void Remove(System.CodeDom.CodeNamespace value) => throw null;
            public System.CodeDom.CodeNamespace this[int index] { get => throw null; set { } }
        }
        public class CodeNamespaceImport : System.CodeDom.CodeObject
        {
            public CodeNamespaceImport() => throw null;
            public CodeNamespaceImport(string nameSpace) => throw null;
            public System.CodeDom.CodeLinePragma LinePragma { get => throw null; set { } }
            public string Namespace { get => throw null; set { } }
        }
        public class CodeNamespaceImportCollection : System.Collections.ICollection, System.Collections.IEnumerable, System.Collections.IList
        {
            public void Add(System.CodeDom.CodeNamespaceImport value) => throw null;
            int System.Collections.IList.Add(object value) => throw null;
            public void AddRange(System.CodeDom.CodeNamespaceImport[] value) => throw null;
            public void Clear() => throw null;
            void System.Collections.IList.Clear() => throw null;
            bool System.Collections.IList.Contains(object value) => throw null;
            void System.Collections.ICollection.CopyTo(System.Array array, int index) => throw null;
            public int Count { get => throw null; }
            int System.Collections.ICollection.Count { get => throw null; }
            public CodeNamespaceImportCollection() => throw null;
            public System.Collections.IEnumerator GetEnumerator() => throw null;
            System.Collections.IEnumerator System.Collections.IEnumerable.GetEnumerator() => throw null;
            int System.Collections.IList.IndexOf(object value) => throw null;
            void System.Collections.IList.Insert(int index, object value) => throw null;
            bool System.Collections.IList.IsFixedSize { get => throw null; }
            bool System.Collections.IList.IsReadOnly { get => throw null; }
            bool System.Collections.ICollection.IsSynchronized { get => throw null; }
            object System.Collections.IList.this[int index] { get => throw null; set { } }
            void System.Collections.IList.Remove(object value) => throw null;
            void System.Collections.IList.RemoveAt(int index) => throw null;
            object System.Collections.ICollection.SyncRoot { get => throw null; }
            public System.CodeDom.CodeNamespaceImport this[int index] { get => throw null; set { } }
        }
        public class CodeObject
        {
            public CodeObject() => throw null;
            public System.Collections.IDictionary UserData { get => throw null; }
        }
        public class CodeObjectCreateExpression : System.CodeDom.CodeExpression
        {
            public System.CodeDom.CodeTypeReference CreateType { get => throw null; set { } }
            public CodeObjectCreateExpression() => throw null;
            public CodeObjectCreateExpression(System.CodeDom.CodeTypeReference createType, params System.CodeDom.CodeExpression[] parameters) => throw null;
            public CodeObjectCreateExpression(string createType, params System.CodeDom.CodeExpression[] parameters) => throw null;
            public CodeObjectCreateExpression(System.Type createType, params System.CodeDom.CodeExpression[] parameters) => throw null;
            public System.CodeDom.CodeExpressionCollection Parameters { get => throw null; }
        }
        public class CodeParameterDeclarationExpression : System.CodeDom.CodeExpression
        {
            public CodeParameterDeclarationExpression() => throw null;
            public CodeParameterDeclarationExpression(System.CodeDom.CodeTypeReference type, string name) => throw null;
            public CodeParameterDeclarationExpression(string type, string name) => throw null;
            public CodeParameterDeclarationExpression(System.Type type, string name) => throw null;
            public System.CodeDom.CodeAttributeDeclarationCollection CustomAttributes { get => throw null; set { } }
            public System.CodeDom.FieldDirection Direction { get => throw null; set { } }
            public string Name { get => throw null; set { } }
            public System.CodeDom.CodeTypeReference Type { get => throw null; set { } }
        }
        public class CodeParameterDeclarationExpressionCollection : System.Collections.CollectionBase
        {
            public int Add(System.CodeDom.CodeParameterDeclarationExpression value) => throw null;
            public void AddRange(System.CodeDom.CodeParameterDeclarationExpressionCollection value) => throw null;
            public void AddRange(System.CodeDom.CodeParameterDeclarationExpression[] value) => throw null;
            public bool Contains(System.CodeDom.CodeParameterDeclarationExpression value) => throw null;
            public void CopyTo(System.CodeDom.CodeParameterDeclarationExpression[] array, int index) => throw null;
            public CodeParameterDeclarationExpressionCollection() => throw null;
            public CodeParameterDeclarationExpressionCollection(System.CodeDom.CodeParameterDeclarationExpressionCollection value) => throw null;
            public CodeParameterDeclarationExpressionCollection(System.CodeDom.CodeParameterDeclarationExpression[] value) => throw null;
            public int IndexOf(System.CodeDom.CodeParameterDeclarationExpression value) => throw null;
            public void Insert(int index, System.CodeDom.CodeParameterDeclarationExpression value) => throw null;
            public void Remove(System.CodeDom.CodeParameterDeclarationExpression value) => throw null;
            public System.CodeDom.CodeParameterDeclarationExpression this[int index] { get => throw null; set { } }
        }
        public class CodePrimitiveExpression : System.CodeDom.CodeExpression
        {
            public CodePrimitiveExpression() => throw null;
            public CodePrimitiveExpression(object value) => throw null;
            public object Value { get => throw null; set { } }
        }
        public class CodePropertyReferenceExpression : System.CodeDom.CodeExpression
        {
            public CodePropertyReferenceExpression() => throw null;
            public CodePropertyReferenceExpression(System.CodeDom.CodeExpression targetObject, string propertyName) => throw null;
            public string PropertyName { get => throw null; set { } }
            public System.CodeDom.CodeExpression TargetObject { get => throw null; set { } }
        }
        public class CodePropertySetValueReferenceExpression : System.CodeDom.CodeExpression
        {
            public CodePropertySetValueReferenceExpression() => throw null;
        }
        public class CodeRegionDirective : System.CodeDom.CodeDirective
        {
            public CodeRegionDirective() => throw null;
            public CodeRegionDirective(System.CodeDom.CodeRegionMode regionMode, string regionText) => throw null;
            public System.CodeDom.CodeRegionMode RegionMode { get => throw null; set { } }
            public string RegionText { get => throw null; set { } }
        }
        public enum CodeRegionMode
        {
            None = 0,
            Start = 1,
            End = 2,
        }
        public class CodeRemoveEventStatement : System.CodeDom.CodeStatement
        {
            public CodeRemoveEventStatement() => throw null;
            public CodeRemoveEventStatement(System.CodeDom.CodeEventReferenceExpression eventRef, System.CodeDom.CodeExpression listener) => throw null;
            public CodeRemoveEventStatement(System.CodeDom.CodeExpression targetObject, string eventName, System.CodeDom.CodeExpression listener) => throw null;
            public System.CodeDom.CodeEventReferenceExpression Event { get => throw null; set { } }
            public System.CodeDom.CodeExpression Listener { get => throw null; set { } }
        }
        public class CodeSnippetCompileUnit : System.CodeDom.CodeCompileUnit
        {
            public CodeSnippetCompileUnit() => throw null;
            public CodeSnippetCompileUnit(string value) => throw null;
            public System.CodeDom.CodeLinePragma LinePragma { get => throw null; set { } }
            public string Value { get => throw null; set { } }
        }
        public class CodeSnippetExpression : System.CodeDom.CodeExpression
        {
            public CodeSnippetExpression() => throw null;
            public CodeSnippetExpression(string value) => throw null;
            public string Value { get => throw null; set { } }
        }
        public class CodeSnippetStatement : System.CodeDom.CodeStatement
        {
            public CodeSnippetStatement() => throw null;
            public CodeSnippetStatement(string value) => throw null;
            public string Value { get => throw null; set { } }
        }
        public class CodeSnippetTypeMember : System.CodeDom.CodeTypeMember
        {
            public CodeSnippetTypeMember() => throw null;
            public CodeSnippetTypeMember(string text) => throw null;
            public string Text { get => throw null; set { } }
        }
        public class CodeStatement : System.CodeDom.CodeObject
        {
            public CodeStatement() => throw null;
            public System.CodeDom.CodeDirectiveCollection EndDirectives { get => throw null; }
            public System.CodeDom.CodeLinePragma LinePragma { get => throw null; set { } }
            public System.CodeDom.CodeDirectiveCollection StartDirectives { get => throw null; }
        }
        public class CodeStatementCollection : System.Collections.CollectionBase
        {
            public int Add(System.CodeDom.CodeExpression value) => throw null;
            public int Add(System.CodeDom.CodeStatement value) => throw null;
            public void AddRange(System.CodeDom.CodeStatementCollection value) => throw null;
            public void AddRange(System.CodeDom.CodeStatement[] value) => throw null;
            public bool Contains(System.CodeDom.CodeStatement value) => throw null;
            public void CopyTo(System.CodeDom.CodeStatement[] array, int index) => throw null;
            public CodeStatementCollection() => throw null;
            public CodeStatementCollection(System.CodeDom.CodeStatementCollection value) => throw null;
            public CodeStatementCollection(System.CodeDom.CodeStatement[] value) => throw null;
            public int IndexOf(System.CodeDom.CodeStatement value) => throw null;
            public void Insert(int index, System.CodeDom.CodeStatement value) => throw null;
            public void Remove(System.CodeDom.CodeStatement value) => throw null;
            public System.CodeDom.CodeStatement this[int index] { get => throw null; set { } }
        }
        public class CodeThisReferenceExpression : System.CodeDom.CodeExpression
        {
            public CodeThisReferenceExpression() => throw null;
        }
        public class CodeThrowExceptionStatement : System.CodeDom.CodeStatement
        {
            public CodeThrowExceptionStatement() => throw null;
            public CodeThrowExceptionStatement(System.CodeDom.CodeExpression toThrow) => throw null;
            public System.CodeDom.CodeExpression ToThrow { get => throw null; set { } }
        }
        public class CodeTryCatchFinallyStatement : System.CodeDom.CodeStatement
        {
            public System.CodeDom.CodeCatchClauseCollection CatchClauses { get => throw null; }
            public CodeTryCatchFinallyStatement() => throw null;
            public CodeTryCatchFinallyStatement(System.CodeDom.CodeStatement[] tryStatements, System.CodeDom.CodeCatchClause[] catchClauses) => throw null;
            public CodeTryCatchFinallyStatement(System.CodeDom.CodeStatement[] tryStatements, System.CodeDom.CodeCatchClause[] catchClauses, System.CodeDom.CodeStatement[] finallyStatements) => throw null;
            public System.CodeDom.CodeStatementCollection FinallyStatements { get => throw null; }
            public System.CodeDom.CodeStatementCollection TryStatements { get => throw null; }
        }
        public class CodeTypeConstructor : System.CodeDom.CodeMemberMethod
        {
            public CodeTypeConstructor() => throw null;
        }
        public class CodeTypeDeclaration : System.CodeDom.CodeTypeMember
        {
            public System.CodeDom.CodeTypeReferenceCollection BaseTypes { get => throw null; }
            public CodeTypeDeclaration() => throw null;
            public CodeTypeDeclaration(string name) => throw null;
            public bool IsClass { get => throw null; set { } }
            public bool IsEnum { get => throw null; set { } }
            public bool IsInterface { get => throw null; set { } }
            public bool IsPartial { get => throw null; set { } }
            public bool IsStruct { get => throw null; set { } }
            public System.CodeDom.CodeTypeMemberCollection Members { get => throw null; }
            public event System.EventHandler PopulateBaseTypes;
            public event System.EventHandler PopulateMembers;
            public System.Reflection.TypeAttributes TypeAttributes { get => throw null; set { } }
            public System.CodeDom.CodeTypeParameterCollection TypeParameters { get => throw null; }
        }
        public class CodeTypeDeclarationCollection : System.Collections.CollectionBase
        {
            public int Add(System.CodeDom.CodeTypeDeclaration value) => throw null;
            public void AddRange(System.CodeDom.CodeTypeDeclarationCollection value) => throw null;
            public void AddRange(System.CodeDom.CodeTypeDeclaration[] value) => throw null;
            public bool Contains(System.CodeDom.CodeTypeDeclaration value) => throw null;
            public void CopyTo(System.CodeDom.CodeTypeDeclaration[] array, int index) => throw null;
            public CodeTypeDeclarationCollection() => throw null;
            public CodeTypeDeclarationCollection(System.CodeDom.CodeTypeDeclarationCollection value) => throw null;
            public CodeTypeDeclarationCollection(System.CodeDom.CodeTypeDeclaration[] value) => throw null;
            public int IndexOf(System.CodeDom.CodeTypeDeclaration value) => throw null;
            public void Insert(int index, System.CodeDom.CodeTypeDeclaration value) => throw null;
            public void Remove(System.CodeDom.CodeTypeDeclaration value) => throw null;
            public System.CodeDom.CodeTypeDeclaration this[int index] { get => throw null; set { } }
        }
        public class CodeTypeDelegate : System.CodeDom.CodeTypeDeclaration
        {
            public CodeTypeDelegate() => throw null;
            public CodeTypeDelegate(string name) => throw null;
            public System.CodeDom.CodeParameterDeclarationExpressionCollection Parameters { get => throw null; }
            public System.CodeDom.CodeTypeReference ReturnType { get => throw null; set { } }
        }
        public class CodeTypeMember : System.CodeDom.CodeObject
        {
            public System.CodeDom.MemberAttributes Attributes { get => throw null; set { } }
            public System.CodeDom.CodeCommentStatementCollection Comments { get => throw null; }
            public CodeTypeMember() => throw null;
            public System.CodeDom.CodeAttributeDeclarationCollection CustomAttributes { get => throw null; set { } }
            public System.CodeDom.CodeDirectiveCollection EndDirectives { get => throw null; }
            public System.CodeDom.CodeLinePragma LinePragma { get => throw null; set { } }
            public string Name { get => throw null; set { } }
            public System.CodeDom.CodeDirectiveCollection StartDirectives { get => throw null; }
        }
        public class CodeTypeMemberCollection : System.Collections.CollectionBase
        {
            public int Add(System.CodeDom.CodeTypeMember value) => throw null;
            public void AddRange(System.CodeDom.CodeTypeMemberCollection value) => throw null;
            public void AddRange(System.CodeDom.CodeTypeMember[] value) => throw null;
            public bool Contains(System.CodeDom.CodeTypeMember value) => throw null;
            public void CopyTo(System.CodeDom.CodeTypeMember[] array, int index) => throw null;
            public CodeTypeMemberCollection() => throw null;
            public CodeTypeMemberCollection(System.CodeDom.CodeTypeMemberCollection value) => throw null;
            public CodeTypeMemberCollection(System.CodeDom.CodeTypeMember[] value) => throw null;
            public int IndexOf(System.CodeDom.CodeTypeMember value) => throw null;
            public void Insert(int index, System.CodeDom.CodeTypeMember value) => throw null;
            public void Remove(System.CodeDom.CodeTypeMember value) => throw null;
            public System.CodeDom.CodeTypeMember this[int index] { get => throw null; set { } }
        }
        public class CodeTypeOfExpression : System.CodeDom.CodeExpression
        {
            public CodeTypeOfExpression() => throw null;
            public CodeTypeOfExpression(System.CodeDom.CodeTypeReference type) => throw null;
            public CodeTypeOfExpression(string type) => throw null;
            public CodeTypeOfExpression(System.Type type) => throw null;
            public System.CodeDom.CodeTypeReference Type { get => throw null; set { } }
        }
        public class CodeTypeParameter : System.CodeDom.CodeObject
        {
            public System.CodeDom.CodeTypeReferenceCollection Constraints { get => throw null; }
            public CodeTypeParameter() => throw null;
            public CodeTypeParameter(string name) => throw null;
            public System.CodeDom.CodeAttributeDeclarationCollection CustomAttributes { get => throw null; }
            public bool HasConstructorConstraint { get => throw null; set { } }
            public string Name { get => throw null; set { } }
        }
        public class CodeTypeParameterCollection : System.Collections.CollectionBase
        {
            public int Add(System.CodeDom.CodeTypeParameter value) => throw null;
            public void Add(string value) => throw null;
            public void AddRange(System.CodeDom.CodeTypeParameterCollection value) => throw null;
            public void AddRange(System.CodeDom.CodeTypeParameter[] value) => throw null;
            public bool Contains(System.CodeDom.CodeTypeParameter value) => throw null;
            public void CopyTo(System.CodeDom.CodeTypeParameter[] array, int index) => throw null;
            public CodeTypeParameterCollection() => throw null;
            public CodeTypeParameterCollection(System.CodeDom.CodeTypeParameterCollection value) => throw null;
            public CodeTypeParameterCollection(System.CodeDom.CodeTypeParameter[] value) => throw null;
            public int IndexOf(System.CodeDom.CodeTypeParameter value) => throw null;
            public void Insert(int index, System.CodeDom.CodeTypeParameter value) => throw null;
            public void Remove(System.CodeDom.CodeTypeParameter value) => throw null;
            public System.CodeDom.CodeTypeParameter this[int index] { get => throw null; set { } }
        }
        public class CodeTypeReference : System.CodeDom.CodeObject
        {
            public System.CodeDom.CodeTypeReference ArrayElementType { get => throw null; set { } }
            public int ArrayRank { get => throw null; set { } }
            public string BaseType { get => throw null; set { } }
            public CodeTypeReference() => throw null;
            public CodeTypeReference(System.CodeDom.CodeTypeParameter typeParameter) => throw null;
            public CodeTypeReference(System.CodeDom.CodeTypeReference arrayType, int rank) => throw null;
            public CodeTypeReference(string typeName) => throw null;
            public CodeTypeReference(string typeName, System.CodeDom.CodeTypeReferenceOptions codeTypeReferenceOption) => throw null;
            public CodeTypeReference(string typeName, params System.CodeDom.CodeTypeReference[] typeArguments) => throw null;
            public CodeTypeReference(string baseType, int rank) => throw null;
            public CodeTypeReference(System.Type type) => throw null;
            public CodeTypeReference(System.Type type, System.CodeDom.CodeTypeReferenceOptions codeTypeReferenceOption) => throw null;
            public System.CodeDom.CodeTypeReferenceOptions Options { get => throw null; set { } }
            public System.CodeDom.CodeTypeReferenceCollection TypeArguments { get => throw null; }
        }
        public class CodeTypeReferenceCollection : System.Collections.CollectionBase
        {
            public int Add(System.CodeDom.CodeTypeReference value) => throw null;
            public void Add(string value) => throw null;
            public void Add(System.Type value) => throw null;
            public void AddRange(System.CodeDom.CodeTypeReferenceCollection value) => throw null;
            public void AddRange(System.CodeDom.CodeTypeReference[] value) => throw null;
            public bool Contains(System.CodeDom.CodeTypeReference value) => throw null;
            public void CopyTo(System.CodeDom.CodeTypeReference[] array, int index) => throw null;
            public CodeTypeReferenceCollection() => throw null;
            public CodeTypeReferenceCollection(System.CodeDom.CodeTypeReferenceCollection value) => throw null;
            public CodeTypeReferenceCollection(System.CodeDom.CodeTypeReference[] value) => throw null;
            public int IndexOf(System.CodeDom.CodeTypeReference value) => throw null;
            public void Insert(int index, System.CodeDom.CodeTypeReference value) => throw null;
            public void Remove(System.CodeDom.CodeTypeReference value) => throw null;
            public System.CodeDom.CodeTypeReference this[int index] { get => throw null; set { } }
        }
        public class CodeTypeReferenceExpression : System.CodeDom.CodeExpression
        {
            public CodeTypeReferenceExpression() => throw null;
            public CodeTypeReferenceExpression(System.CodeDom.CodeTypeReference type) => throw null;
            public CodeTypeReferenceExpression(string type) => throw null;
            public CodeTypeReferenceExpression(System.Type type) => throw null;
            public System.CodeDom.CodeTypeReference Type { get => throw null; set { } }
        }
        [System.Flags]
        public enum CodeTypeReferenceOptions
        {
            GlobalReference = 1,
            GenericTypeParameter = 2,
        }
        public class CodeVariableDeclarationStatement : System.CodeDom.CodeStatement
        {
            public CodeVariableDeclarationStatement() => throw null;
            public CodeVariableDeclarationStatement(System.CodeDom.CodeTypeReference type, string name) => throw null;
            public CodeVariableDeclarationStatement(System.CodeDom.CodeTypeReference type, string name, System.CodeDom.CodeExpression initExpression) => throw null;
            public CodeVariableDeclarationStatement(string type, string name) => throw null;
            public CodeVariableDeclarationStatement(string type, string name, System.CodeDom.CodeExpression initExpression) => throw null;
            public CodeVariableDeclarationStatement(System.Type type, string name) => throw null;
            public CodeVariableDeclarationStatement(System.Type type, string name, System.CodeDom.CodeExpression initExpression) => throw null;
            public System.CodeDom.CodeExpression InitExpression { get => throw null; set { } }
            public string Name { get => throw null; set { } }
            public System.CodeDom.CodeTypeReference Type { get => throw null; set { } }
        }
        public class CodeVariableReferenceExpression : System.CodeDom.CodeExpression
        {
            public CodeVariableReferenceExpression() => throw null;
            public CodeVariableReferenceExpression(string variableName) => throw null;
            public string VariableName { get => throw null; set { } }
        }
        namespace Compiler
        {
            public abstract class CodeCompiler : System.CodeDom.Compiler.CodeGenerator, System.CodeDom.Compiler.ICodeCompiler
            {
                protected abstract string CmdArgsFromParameters(System.CodeDom.Compiler.CompilerParameters options);
                System.CodeDom.Compiler.CompilerResults System.CodeDom.Compiler.ICodeCompiler.CompileAssemblyFromDom(System.CodeDom.Compiler.CompilerParameters options, System.CodeDom.CodeCompileUnit e) => throw null;
                System.CodeDom.Compiler.CompilerResults System.CodeDom.Compiler.ICodeCompiler.CompileAssemblyFromDomBatch(System.CodeDom.Compiler.CompilerParameters options, System.CodeDom.CodeCompileUnit[] ea) => throw null;
                System.CodeDom.Compiler.CompilerResults System.CodeDom.Compiler.ICodeCompiler.CompileAssemblyFromFile(System.CodeDom.Compiler.CompilerParameters options, string fileName) => throw null;
                System.CodeDom.Compiler.CompilerResults System.CodeDom.Compiler.ICodeCompiler.CompileAssemblyFromFileBatch(System.CodeDom.Compiler.CompilerParameters options, string[] fileNames) => throw null;
                System.CodeDom.Compiler.CompilerResults System.CodeDom.Compiler.ICodeCompiler.CompileAssemblyFromSource(System.CodeDom.Compiler.CompilerParameters options, string source) => throw null;
                System.CodeDom.Compiler.CompilerResults System.CodeDom.Compiler.ICodeCompiler.CompileAssemblyFromSourceBatch(System.CodeDom.Compiler.CompilerParameters options, string[] sources) => throw null;
                protected abstract string CompilerName { get; }
                protected CodeCompiler() => throw null;
                protected abstract string FileExtension { get; }
                protected virtual System.CodeDom.Compiler.CompilerResults FromDom(System.CodeDom.Compiler.CompilerParameters options, System.CodeDom.CodeCompileUnit e) => throw null;
                protected virtual System.CodeDom.Compiler.CompilerResults FromDomBatch(System.CodeDom.Compiler.CompilerParameters options, System.CodeDom.CodeCompileUnit[] ea) => throw null;
                protected virtual System.CodeDom.Compiler.CompilerResults FromFile(System.CodeDom.Compiler.CompilerParameters options, string fileName) => throw null;
                protected virtual System.CodeDom.Compiler.CompilerResults FromFileBatch(System.CodeDom.Compiler.CompilerParameters options, string[] fileNames) => throw null;
                protected virtual System.CodeDom.Compiler.CompilerResults FromSource(System.CodeDom.Compiler.CompilerParameters options, string source) => throw null;
                protected virtual System.CodeDom.Compiler.CompilerResults FromSourceBatch(System.CodeDom.Compiler.CompilerParameters options, string[] sources) => throw null;
                protected virtual string GetResponseFileCmdArgs(System.CodeDom.Compiler.CompilerParameters options, string cmdArgs) => throw null;
                protected static string JoinStringArray(string[] sa, string separator) => throw null;
                protected abstract void ProcessCompilerOutputLine(System.CodeDom.Compiler.CompilerResults results, string line);
            }
            public abstract class CodeDomProvider : System.ComponentModel.Component
            {
                public virtual System.CodeDom.Compiler.CompilerResults CompileAssemblyFromDom(System.CodeDom.Compiler.CompilerParameters options, params System.CodeDom.CodeCompileUnit[] compilationUnits) => throw null;
                public virtual System.CodeDom.Compiler.CompilerResults CompileAssemblyFromFile(System.CodeDom.Compiler.CompilerParameters options, params string[] fileNames) => throw null;
                public virtual System.CodeDom.Compiler.CompilerResults CompileAssemblyFromSource(System.CodeDom.Compiler.CompilerParameters options, params string[] sources) => throw null;
                public abstract System.CodeDom.Compiler.ICodeCompiler CreateCompiler();
                public virtual string CreateEscapedIdentifier(string value) => throw null;
                public abstract System.CodeDom.Compiler.ICodeGenerator CreateGenerator();
                public virtual System.CodeDom.Compiler.ICodeGenerator CreateGenerator(System.IO.TextWriter output) => throw null;
                public virtual System.CodeDom.Compiler.ICodeGenerator CreateGenerator(string fileName) => throw null;
                public virtual System.CodeDom.Compiler.ICodeParser CreateParser() => throw null;
                public static System.CodeDom.Compiler.CodeDomProvider CreateProvider(string language) => throw null;
                public static System.CodeDom.Compiler.CodeDomProvider CreateProvider(string language, System.Collections.Generic.IDictionary<string, string> providerOptions) => throw null;
                public virtual string CreateValidIdentifier(string value) => throw null;
                protected CodeDomProvider() => throw null;
                public virtual string FileExtension { get => throw null; }
                public virtual void GenerateCodeFromCompileUnit(System.CodeDom.CodeCompileUnit compileUnit, System.IO.TextWriter writer, System.CodeDom.Compiler.CodeGeneratorOptions options) => throw null;
                public virtual void GenerateCodeFromExpression(System.CodeDom.CodeExpression expression, System.IO.TextWriter writer, System.CodeDom.Compiler.CodeGeneratorOptions options) => throw null;
                public virtual void GenerateCodeFromMember(System.CodeDom.CodeTypeMember member, System.IO.TextWriter writer, System.CodeDom.Compiler.CodeGeneratorOptions options) => throw null;
                public virtual void GenerateCodeFromNamespace(System.CodeDom.CodeNamespace codeNamespace, System.IO.TextWriter writer, System.CodeDom.Compiler.CodeGeneratorOptions options) => throw null;
                public virtual void GenerateCodeFromStatement(System.CodeDom.CodeStatement statement, System.IO.TextWriter writer, System.CodeDom.Compiler.CodeGeneratorOptions options) => throw null;
                public virtual void GenerateCodeFromType(System.CodeDom.CodeTypeDeclaration codeType, System.IO.TextWriter writer, System.CodeDom.Compiler.CodeGeneratorOptions options) => throw null;
                public static System.CodeDom.Compiler.CompilerInfo[] GetAllCompilerInfo() => throw null;
                public static System.CodeDom.Compiler.CompilerInfo GetCompilerInfo(string language) => throw null;
                public virtual System.ComponentModel.TypeConverter GetConverter(System.Type type) => throw null;
                public static string GetLanguageFromExtension(string extension) => throw null;
                public virtual string GetTypeOutput(System.CodeDom.CodeTypeReference type) => throw null;
                public static bool IsDefinedExtension(string extension) => throw null;
                public static bool IsDefinedLanguage(string language) => throw null;
                public virtual bool IsValidIdentifier(string value) => throw null;
                public virtual System.CodeDom.Compiler.LanguageOptions LanguageOptions { get => throw null; }
                public virtual System.CodeDom.CodeCompileUnit Parse(System.IO.TextReader codeStream) => throw null;
                public virtual bool Supports(System.CodeDom.Compiler.GeneratorSupport generatorSupport) => throw null;
            }
            public abstract class CodeGenerator : System.CodeDom.Compiler.ICodeGenerator
            {
                protected virtual void ContinueOnNewLine(string st) => throw null;
                protected abstract string CreateEscapedIdentifier(string value);
                string System.CodeDom.Compiler.ICodeGenerator.CreateEscapedIdentifier(string value) => throw null;
                protected abstract string CreateValidIdentifier(string value);
                string System.CodeDom.Compiler.ICodeGenerator.CreateValidIdentifier(string value) => throw null;
                protected CodeGenerator() => throw null;
                protected System.CodeDom.CodeTypeDeclaration CurrentClass { get => throw null; }
                protected System.CodeDom.CodeTypeMember CurrentMember { get => throw null; }
                protected string CurrentMemberName { get => throw null; }
                protected string CurrentTypeName { get => throw null; }
                protected abstract void GenerateArgumentReferenceExpression(System.CodeDom.CodeArgumentReferenceExpression e);
                protected abstract void GenerateArrayCreateExpression(System.CodeDom.CodeArrayCreateExpression e);
                protected abstract void GenerateArrayIndexerExpression(System.CodeDom.CodeArrayIndexerExpression e);
                protected abstract void GenerateAssignStatement(System.CodeDom.CodeAssignStatement e);
                protected abstract void GenerateAttachEventStatement(System.CodeDom.CodeAttachEventStatement e);
                protected abstract void GenerateAttributeDeclarationsEnd(System.CodeDom.CodeAttributeDeclarationCollection attributes);
                protected abstract void GenerateAttributeDeclarationsStart(System.CodeDom.CodeAttributeDeclarationCollection attributes);
                protected abstract void GenerateBaseReferenceExpression(System.CodeDom.CodeBaseReferenceExpression e);
                protected virtual void GenerateBinaryOperatorExpression(System.CodeDom.CodeBinaryOperatorExpression e) => throw null;
                protected abstract void GenerateCastExpression(System.CodeDom.CodeCastExpression e);
                void System.CodeDom.Compiler.ICodeGenerator.GenerateCodeFromCompileUnit(System.CodeDom.CodeCompileUnit e, System.IO.TextWriter w, System.CodeDom.Compiler.CodeGeneratorOptions o) => throw null;
                void System.CodeDom.Compiler.ICodeGenerator.GenerateCodeFromExpression(System.CodeDom.CodeExpression e, System.IO.TextWriter w, System.CodeDom.Compiler.CodeGeneratorOptions o) => throw null;
                public virtual void GenerateCodeFromMember(System.CodeDom.CodeTypeMember member, System.IO.TextWriter writer, System.CodeDom.Compiler.CodeGeneratorOptions options) => throw null;
                void System.CodeDom.Compiler.ICodeGenerator.GenerateCodeFromNamespace(System.CodeDom.CodeNamespace e, System.IO.TextWriter w, System.CodeDom.Compiler.CodeGeneratorOptions o) => throw null;
                void System.CodeDom.Compiler.ICodeGenerator.GenerateCodeFromStatement(System.CodeDom.CodeStatement e, System.IO.TextWriter w, System.CodeDom.Compiler.CodeGeneratorOptions o) => throw null;
                void System.CodeDom.Compiler.ICodeGenerator.GenerateCodeFromType(System.CodeDom.CodeTypeDeclaration e, System.IO.TextWriter w, System.CodeDom.Compiler.CodeGeneratorOptions o) => throw null;
                protected abstract void GenerateComment(System.CodeDom.CodeComment e);
                protected virtual void GenerateCommentStatement(System.CodeDom.CodeCommentStatement e) => throw null;
                protected virtual void GenerateCommentStatements(System.CodeDom.CodeCommentStatementCollection e) => throw null;
                protected virtual void GenerateCompileUnit(System.CodeDom.CodeCompileUnit e) => throw null;
                protected virtual void GenerateCompileUnitEnd(System.CodeDom.CodeCompileUnit e) => throw null;
                protected virtual void GenerateCompileUnitStart(System.CodeDom.CodeCompileUnit e) => throw null;
                protected abstract void GenerateConditionStatement(System.CodeDom.CodeConditionStatement e);
                protected abstract void GenerateConstructor(System.CodeDom.CodeConstructor e, System.CodeDom.CodeTypeDeclaration c);
                protected virtual void GenerateDecimalValue(decimal d) => throw null;
                protected virtual void GenerateDefaultValueExpression(System.CodeDom.CodeDefaultValueExpression e) => throw null;
                protected abstract void GenerateDelegateCreateExpression(System.CodeDom.CodeDelegateCreateExpression e);
                protected abstract void GenerateDelegateInvokeExpression(System.CodeDom.CodeDelegateInvokeExpression e);
                protected virtual void GenerateDirectionExpression(System.CodeDom.CodeDirectionExpression e) => throw null;
                protected virtual void GenerateDirectives(System.CodeDom.CodeDirectiveCollection directives) => throw null;
                protected virtual void GenerateDoubleValue(double d) => throw null;
                protected abstract void GenerateEntryPointMethod(System.CodeDom.CodeEntryPointMethod e, System.CodeDom.CodeTypeDeclaration c);
                protected abstract void GenerateEvent(System.CodeDom.CodeMemberEvent e, System.CodeDom.CodeTypeDeclaration c);
                protected abstract void GenerateEventReferenceExpression(System.CodeDom.CodeEventReferenceExpression e);
                protected void GenerateExpression(System.CodeDom.CodeExpression e) => throw null;
                protected abstract void GenerateExpressionStatement(System.CodeDom.CodeExpressionStatement e);
                protected abstract void GenerateField(System.CodeDom.CodeMemberField e);
                protected abstract void GenerateFieldReferenceExpression(System.CodeDom.CodeFieldReferenceExpression e);
                protected abstract void GenerateGotoStatement(System.CodeDom.CodeGotoStatement e);
                protected abstract void GenerateIndexerExpression(System.CodeDom.CodeIndexerExpression e);
                protected abstract void GenerateIterationStatement(System.CodeDom.CodeIterationStatement e);
                protected abstract void GenerateLabeledStatement(System.CodeDom.CodeLabeledStatement e);
                protected abstract void GenerateLinePragmaEnd(System.CodeDom.CodeLinePragma e);
                protected abstract void GenerateLinePragmaStart(System.CodeDom.CodeLinePragma e);
                protected abstract void GenerateMethod(System.CodeDom.CodeMemberMethod e, System.CodeDom.CodeTypeDeclaration c);
                protected abstract void GenerateMethodInvokeExpression(System.CodeDom.CodeMethodInvokeExpression e);
                protected abstract void GenerateMethodReferenceExpression(System.CodeDom.CodeMethodReferenceExpression e);
                protected abstract void GenerateMethodReturnStatement(System.CodeDom.CodeMethodReturnStatement e);
                protected virtual void GenerateNamespace(System.CodeDom.CodeNamespace e) => throw null;
                protected abstract void GenerateNamespaceEnd(System.CodeDom.CodeNamespace e);
                protected abstract void GenerateNamespaceImport(System.CodeDom.CodeNamespaceImport e);
                protected void GenerateNamespaceImports(System.CodeDom.CodeNamespace e) => throw null;
                protected void GenerateNamespaces(System.CodeDom.CodeCompileUnit e) => throw null;
                protected abstract void GenerateNamespaceStart(System.CodeDom.CodeNamespace e);
                protected abstract void GenerateObjectCreateExpression(System.CodeDom.CodeObjectCreateExpression e);
                protected virtual void GenerateParameterDeclarationExpression(System.CodeDom.CodeParameterDeclarationExpression e) => throw null;
                protected virtual void GeneratePrimitiveExpression(System.CodeDom.CodePrimitiveExpression e) => throw null;
                protected abstract void GenerateProperty(System.CodeDom.CodeMemberProperty e, System.CodeDom.CodeTypeDeclaration c);
                protected abstract void GeneratePropertyReferenceExpression(System.CodeDom.CodePropertyReferenceExpression e);
                protected abstract void GeneratePropertySetValueReferenceExpression(System.CodeDom.CodePropertySetValueReferenceExpression e);
                protected abstract void GenerateRemoveEventStatement(System.CodeDom.CodeRemoveEventStatement e);
                protected virtual void GenerateSingleFloatValue(float s) => throw null;
                protected virtual void GenerateSnippetCompileUnit(System.CodeDom.CodeSnippetCompileUnit e) => throw null;
                protected abstract void GenerateSnippetExpression(System.CodeDom.CodeSnippetExpression e);
                protected abstract void GenerateSnippetMember(System.CodeDom.CodeSnippetTypeMember e);
                protected virtual void GenerateSnippetStatement(System.CodeDom.CodeSnippetStatement e) => throw null;
                protected void GenerateStatement(System.CodeDom.CodeStatement e) => throw null;
                protected void GenerateStatements(System.CodeDom.CodeStatementCollection stms) => throw null;
                protected abstract void GenerateThisReferenceExpression(System.CodeDom.CodeThisReferenceExpression e);
                protected abstract void GenerateThrowExceptionStatement(System.CodeDom.CodeThrowExceptionStatement e);
                protected abstract void GenerateTryCatchFinallyStatement(System.CodeDom.CodeTryCatchFinallyStatement e);
                protected abstract void GenerateTypeConstructor(System.CodeDom.CodeTypeConstructor e);
                protected abstract void GenerateTypeEnd(System.CodeDom.CodeTypeDeclaration e);
                protected virtual void GenerateTypeOfExpression(System.CodeDom.CodeTypeOfExpression e) => throw null;
                protected virtual void GenerateTypeReferenceExpression(System.CodeDom.CodeTypeReferenceExpression e) => throw null;
                protected void GenerateTypes(System.CodeDom.CodeNamespace e) => throw null;
                protected abstract void GenerateTypeStart(System.CodeDom.CodeTypeDeclaration e);
                protected abstract void GenerateVariableDeclarationStatement(System.CodeDom.CodeVariableDeclarationStatement e);
                protected abstract void GenerateVariableReferenceExpression(System.CodeDom.CodeVariableReferenceExpression e);
                protected abstract string GetTypeOutput(System.CodeDom.CodeTypeReference value);
                string System.CodeDom.Compiler.ICodeGenerator.GetTypeOutput(System.CodeDom.CodeTypeReference type) => throw null;
                protected int Indent { get => throw null; set { } }
                protected bool IsCurrentClass { get => throw null; }
                protected bool IsCurrentDelegate { get => throw null; }
                protected bool IsCurrentEnum { get => throw null; }
                protected bool IsCurrentInterface { get => throw null; }
                protected bool IsCurrentStruct { get => throw null; }
                protected abstract bool IsValidIdentifier(string value);
                bool System.CodeDom.Compiler.ICodeGenerator.IsValidIdentifier(string value) => throw null;
                public static bool IsValidLanguageIndependentIdentifier(string value) => throw null;
                protected abstract string NullToken { get; }
                protected System.CodeDom.Compiler.CodeGeneratorOptions Options { get => throw null; }
                protected System.IO.TextWriter Output { get => throw null; }
                protected virtual void OutputAttributeArgument(System.CodeDom.CodeAttributeArgument arg) => throw null;
                protected virtual void OutputAttributeDeclarations(System.CodeDom.CodeAttributeDeclarationCollection attributes) => throw null;
                protected virtual void OutputDirection(System.CodeDom.FieldDirection dir) => throw null;
                protected virtual void OutputExpressionList(System.CodeDom.CodeExpressionCollection expressions) => throw null;
                protected virtual void OutputExpressionList(System.CodeDom.CodeExpressionCollection expressions, bool newlineBetweenItems) => throw null;
                protected virtual void OutputFieldScopeModifier(System.CodeDom.MemberAttributes attributes) => throw null;
                protected virtual void OutputIdentifier(string ident) => throw null;
                protected virtual void OutputMemberAccessModifier(System.CodeDom.MemberAttributes attributes) => throw null;
                protected virtual void OutputMemberScopeModifier(System.CodeDom.MemberAttributes attributes) => throw null;
                protected virtual void OutputOperator(System.CodeDom.CodeBinaryOperatorType op) => throw null;
                protected virtual void OutputParameters(System.CodeDom.CodeParameterDeclarationExpressionCollection parameters) => throw null;
                protected abstract void OutputType(System.CodeDom.CodeTypeReference typeRef);
                protected virtual void OutputTypeAttributes(System.Reflection.TypeAttributes attributes, bool isStruct, bool isEnum) => throw null;
                protected virtual void OutputTypeNamePair(System.CodeDom.CodeTypeReference typeRef, string name) => throw null;
                protected abstract string QuoteSnippetString(string value);
                protected abstract bool Supports(System.CodeDom.Compiler.GeneratorSupport support);
                bool System.CodeDom.Compiler.ICodeGenerator.Supports(System.CodeDom.Compiler.GeneratorSupport support) => throw null;
                void System.CodeDom.Compiler.ICodeGenerator.ValidateIdentifier(string value) => throw null;
                protected virtual void ValidateIdentifier(string value) => throw null;
                public static void ValidateIdentifiers(System.CodeDom.CodeObject e) => throw null;
            }
            public class CodeGeneratorOptions
            {
                public bool BlankLinesBetweenMembers { get => throw null; set { } }
                public string BracingStyle { get => throw null; set { } }
                public CodeGeneratorOptions() => throw null;
                public bool ElseOnClosing { get => throw null; set { } }
                public string IndentString { get => throw null; set { } }
                public object this[string index] { get => throw null; set { } }
                public bool VerbatimOrder { get => throw null; set { } }
            }
            public abstract class CodeParser : System.CodeDom.Compiler.ICodeParser
            {
                protected CodeParser() => throw null;
                public abstract System.CodeDom.CodeCompileUnit Parse(System.IO.TextReader codeStream);
            }
            public class CompilerError
            {
                public int Column { get => throw null; set { } }
                public CompilerError() => throw null;
                public CompilerError(string fileName, int line, int column, string errorNumber, string errorText) => throw null;
                public string ErrorNumber { get => throw null; set { } }
                public string ErrorText { get => throw null; set { } }
                public string FileName { get => throw null; set { } }
                public bool IsWarning { get => throw null; set { } }
                public int Line { get => throw null; set { } }
                public override string ToString() => throw null;
            }
            public class CompilerErrorCollection : System.Collections.CollectionBase
            {
                public int Add(System.CodeDom.Compiler.CompilerError value) => throw null;
                public void AddRange(System.CodeDom.Compiler.CompilerErrorCollection value) => throw null;
                public void AddRange(System.CodeDom.Compiler.CompilerError[] value) => throw null;
                public bool Contains(System.CodeDom.Compiler.CompilerError value) => throw null;
                public void CopyTo(System.CodeDom.Compiler.CompilerError[] array, int index) => throw null;
                public CompilerErrorCollection() => throw null;
                public CompilerErrorCollection(System.CodeDom.Compiler.CompilerErrorCollection value) => throw null;
                public CompilerErrorCollection(System.CodeDom.Compiler.CompilerError[] value) => throw null;
                public bool HasErrors { get => throw null; }
                public bool HasWarnings { get => throw null; }
                public int IndexOf(System.CodeDom.Compiler.CompilerError value) => throw null;
                public void Insert(int index, System.CodeDom.Compiler.CompilerError value) => throw null;
                public void Remove(System.CodeDom.Compiler.CompilerError value) => throw null;
                public System.CodeDom.Compiler.CompilerError this[int index] { get => throw null; set { } }
            }
            public sealed class CompilerInfo
            {
                public System.Type CodeDomProviderType { get => throw null; }
                public System.CodeDom.Compiler.CompilerParameters CreateDefaultCompilerParameters() => throw null;
                public System.CodeDom.Compiler.CodeDomProvider CreateProvider() => throw null;
                public System.CodeDom.Compiler.CodeDomProvider CreateProvider(System.Collections.Generic.IDictionary<string, string> providerOptions) => throw null;
                public override bool Equals(object o) => throw null;
                public string[] GetExtensions() => throw null;
                public override int GetHashCode() => throw null;
                public string[] GetLanguages() => throw null;
                public bool IsCodeDomProviderTypeValid { get => throw null; }
            }
            public class CompilerParameters
            {
                public string CompilerOptions { get => throw null; set { } }
                public string CoreAssemblyFileName { get => throw null; set { } }
                public CompilerParameters() => throw null;
                public CompilerParameters(string[] assemblyNames) => throw null;
                public CompilerParameters(string[] assemblyNames, string outputName) => throw null;
                public CompilerParameters(string[] assemblyNames, string outputName, bool includeDebugInformation) => throw null;
                public System.Collections.Specialized.StringCollection EmbeddedResources { get => throw null; }
                public bool GenerateExecutable { get => throw null; set { } }
                public bool GenerateInMemory { get => throw null; set { } }
                public bool IncludeDebugInformation { get => throw null; set { } }
                public System.Collections.Specialized.StringCollection LinkedResources { get => throw null; }
                public string MainClass { get => throw null; set { } }
                public string OutputAssembly { get => throw null; set { } }
                public System.Collections.Specialized.StringCollection ReferencedAssemblies { get => throw null; }
                public System.CodeDom.Compiler.TempFileCollection TempFiles { get => throw null; set { } }
                public bool TreatWarningsAsErrors { get => throw null; set { } }
                public nint UserToken { get => throw null; set { } }
                public int WarningLevel { get => throw null; set { } }
                public string Win32Resource { get => throw null; set { } }
            }
            public class CompilerResults
            {
                public System.Reflection.Assembly CompiledAssembly { get => throw null; set { } }
                public CompilerResults(System.CodeDom.Compiler.TempFileCollection tempFiles) => throw null;
                public System.CodeDom.Compiler.CompilerErrorCollection Errors { get => throw null; }
                public int NativeCompilerReturnValue { get => throw null; set { } }
                public System.Collections.Specialized.StringCollection Output { get => throw null; }
                public string PathToAssembly { get => throw null; set { } }
                public System.CodeDom.Compiler.TempFileCollection TempFiles { get => throw null; set { } }
            }
            public static class Executor
            {
                public static void ExecWait(string cmd, System.CodeDom.Compiler.TempFileCollection tempFiles) => throw null;
                public static int ExecWaitWithCapture(nint userToken, string cmd, System.CodeDom.Compiler.TempFileCollection tempFiles, ref string outputName, ref string errorName) => throw null;
                public static int ExecWaitWithCapture(nint userToken, string cmd, string currentDir, System.CodeDom.Compiler.TempFileCollection tempFiles, ref string outputName, ref string errorName) => throw null;
                public static int ExecWaitWithCapture(string cmd, System.CodeDom.Compiler.TempFileCollection tempFiles, ref string outputName, ref string errorName) => throw null;
                public static int ExecWaitWithCapture(string cmd, string currentDir, System.CodeDom.Compiler.TempFileCollection tempFiles, ref string outputName, ref string errorName) => throw null;
            }
            [System.Flags]
            public enum GeneratorSupport
            {
                ArraysOfArrays = 1,
                EntryPointMethod = 2,
                GotoStatements = 4,
                MultidimensionalArrays = 8,
                StaticConstructors = 16,
                TryCatchStatements = 32,
                ReturnTypeAttributes = 64,
                DeclareValueTypes = 128,
                DeclareEnums = 256,
                DeclareDelegates = 512,
                DeclareInterfaces = 1024,
                DeclareEvents = 2048,
                AssemblyAttributes = 4096,
                ParameterAttributes = 8192,
                ReferenceParameters = 16384,
                ChainedConstructorArguments = 32768,
                NestedTypes = 65536,
                MultipleInterfaceMembers = 131072,
                PublicStaticMembers = 262144,
                ComplexExpressions = 524288,
                Win32Resources = 1048576,
                Resources = 2097152,
                PartialTypes = 4194304,
                GenericTypeReference = 8388608,
                GenericTypeDeclaration = 16777216,
                DeclareIndexerProperties = 33554432,
            }
            public interface ICodeCompiler
            {
                System.CodeDom.Compiler.CompilerResults CompileAssemblyFromDom(System.CodeDom.Compiler.CompilerParameters options, System.CodeDom.CodeCompileUnit compilationUnit);
                System.CodeDom.Compiler.CompilerResults CompileAssemblyFromDomBatch(System.CodeDom.Compiler.CompilerParameters options, System.CodeDom.CodeCompileUnit[] compilationUnits);
                System.CodeDom.Compiler.CompilerResults CompileAssemblyFromFile(System.CodeDom.Compiler.CompilerParameters options, string fileName);
                System.CodeDom.Compiler.CompilerResults CompileAssemblyFromFileBatch(System.CodeDom.Compiler.CompilerParameters options, string[] fileNames);
                System.CodeDom.Compiler.CompilerResults CompileAssemblyFromSource(System.CodeDom.Compiler.CompilerParameters options, string source);
                System.CodeDom.Compiler.CompilerResults CompileAssemblyFromSourceBatch(System.CodeDom.Compiler.CompilerParameters options, string[] sources);
            }
            public interface ICodeGenerator
            {
                string CreateEscapedIdentifier(string value);
                string CreateValidIdentifier(string value);
                void GenerateCodeFromCompileUnit(System.CodeDom.CodeCompileUnit e, System.IO.TextWriter w, System.CodeDom.Compiler.CodeGeneratorOptions o);
                void GenerateCodeFromExpression(System.CodeDom.CodeExpression e, System.IO.TextWriter w, System.CodeDom.Compiler.CodeGeneratorOptions o);
                void GenerateCodeFromNamespace(System.CodeDom.CodeNamespace e, System.IO.TextWriter w, System.CodeDom.Compiler.CodeGeneratorOptions o);
                void GenerateCodeFromStatement(System.CodeDom.CodeStatement e, System.IO.TextWriter w, System.CodeDom.Compiler.CodeGeneratorOptions o);
                void GenerateCodeFromType(System.CodeDom.CodeTypeDeclaration e, System.IO.TextWriter w, System.CodeDom.Compiler.CodeGeneratorOptions o);
                string GetTypeOutput(System.CodeDom.CodeTypeReference type);
                bool IsValidIdentifier(string value);
                bool Supports(System.CodeDom.Compiler.GeneratorSupport supports);
                void ValidateIdentifier(string value);
            }
            public interface ICodeParser
            {
                System.CodeDom.CodeCompileUnit Parse(System.IO.TextReader codeStream);
            }
            [System.Flags]
            public enum LanguageOptions
            {
                None = 0,
                CaseInsensitive = 1,
            }
            public class TempFileCollection : System.Collections.ICollection, System.IDisposable, System.Collections.IEnumerable
            {
                public string AddExtension(string fileExtension) => throw null;
                public string AddExtension(string fileExtension, bool keepFile) => throw null;
                public void AddFile(string fileName, bool keepFile) => throw null;
                public string BasePath { get => throw null; }
                public void CopyTo(string[] fileNames, int start) => throw null;
                void System.Collections.ICollection.CopyTo(System.Array array, int start) => throw null;
                public int Count { get => throw null; }
                int System.Collections.ICollection.Count { get => throw null; }
                public TempFileCollection() => throw null;
                public TempFileCollection(string tempDir) => throw null;
                public TempFileCollection(string tempDir, bool keepFiles) => throw null;
                public void Delete() => throw null;
                protected virtual void Dispose(bool disposing) => throw null;
                void System.IDisposable.Dispose() => throw null;
                public System.Collections.IEnumerator GetEnumerator() => throw null;
                System.Collections.IEnumerator System.Collections.IEnumerable.GetEnumerator() => throw null;
                bool System.Collections.ICollection.IsSynchronized { get => throw null; }
                public bool KeepFiles { get => throw null; set { } }
                object System.Collections.ICollection.SyncRoot { get => throw null; }
                public string TempDir { get => throw null; }
            }
        }
        public enum FieldDirection
        {
            In = 0,
            Out = 1,
            Ref = 2,
        }
        public enum MemberAttributes
        {
            Abstract = 1,
            Final = 2,
            Static = 3,
            Override = 4,
            Const = 5,
            ScopeMask = 15,
            New = 16,
            VTableMask = 240,
            Overloaded = 256,
            Assembly = 4096,
            FamilyAndAssembly = 8192,
            Family = 12288,
            FamilyOrAssembly = 16384,
            Private = 20480,
            Public = 24576,
            AccessMask = 61440,
        }
    }
}
