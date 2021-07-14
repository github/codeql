// This file contains auto-generated code.

namespace Antlr
{
    namespace Runtime
    {
        // Generated from `Antlr.Runtime.ANTLRInputStream` in `Antlr3.Runtime, Version=3.5.0.2, Culture=neutral, PublicKeyToken=eb42632606e9261f`
        public class ANTLRInputStream : Antlr.Runtime.ANTLRReaderStream
        {
            public ANTLRInputStream(System.IO.Stream input, int size, int readBufferSize, System.Text.Encoding encoding) : base(default(System.IO.TextReader)) => throw null;
            public ANTLRInputStream(System.IO.Stream input, int size, System.Text.Encoding encoding) : base(default(System.IO.TextReader)) => throw null;
            public ANTLRInputStream(System.IO.Stream input, int size) : base(default(System.IO.TextReader)) => throw null;
            public ANTLRInputStream(System.IO.Stream input, System.Text.Encoding encoding) : base(default(System.IO.TextReader)) => throw null;
            public ANTLRInputStream(System.IO.Stream input) : base(default(System.IO.TextReader)) => throw null;
        }

        // Generated from `Antlr.Runtime.ANTLRReaderStream` in `Antlr3.Runtime, Version=3.5.0.2, Culture=neutral, PublicKeyToken=eb42632606e9261f`
        public class ANTLRReaderStream : Antlr.Runtime.ANTLRStringStream
        {
            public ANTLRReaderStream(System.IO.TextReader r, int size, int readChunkSize) => throw null;
            public ANTLRReaderStream(System.IO.TextReader r, int size) => throw null;
            public ANTLRReaderStream(System.IO.TextReader r) => throw null;
            public const int InitialBufferSize = default;
            public virtual void Load(System.IO.TextReader r, int size, int readChunkSize) => throw null;
            public const int ReadBufferSize = default;
        }

        // Generated from `Antlr.Runtime.ANTLRStringStream` in `Antlr3.Runtime, Version=3.5.0.2, Culture=neutral, PublicKeyToken=eb42632606e9261f`
        public class ANTLRStringStream : Antlr.Runtime.IIntStream, Antlr.Runtime.ICharStream
        {
            public ANTLRStringStream(string input, string sourceName) => throw null;
            public ANTLRStringStream(string input) => throw null;
            public ANTLRStringStream(System.Char[] data, int numberOfActualCharsInArray, string sourceName) => throw null;
            public ANTLRStringStream(System.Char[] data, int numberOfActualCharsInArray) => throw null;
            protected ANTLRStringStream() => throw null;
            public virtual int CharPositionInLine { get => throw null; set => throw null; }
            public virtual void Consume() => throw null;
            public virtual int Count { get => throw null; }
            public virtual int Index { get => throw null; }
            public virtual int LA(int i) => throw null;
            public virtual int LT(int i) => throw null;
            public virtual int Line { get => throw null; set => throw null; }
            public virtual int Mark() => throw null;
            public virtual void Release(int marker) => throw null;
            public virtual void Reset() => throw null;
            public virtual void Rewind(int m) => throw null;
            public virtual void Rewind() => throw null;
            public virtual void Seek(int index) => throw null;
            public virtual string SourceName { get => throw null; }
            public virtual string Substring(int start, int length) => throw null;
            public override string ToString() => throw null;
            protected System.Char[] data;
            protected int lastMarker;
            protected int markDepth;
            protected System.Collections.Generic.IList<Antlr.Runtime.CharStreamState> markers;
            protected int n;
            public string name;
            protected int p;
        }

        // Generated from `Antlr.Runtime.AstParserRuleReturnScope<,>` in `Antlr3.Runtime, Version=3.5.0.2, Culture=neutral, PublicKeyToken=eb42632606e9261f`
        public class AstParserRuleReturnScope<TTree, TToken> : Antlr.Runtime.ParserRuleReturnScope<TToken>, Antlr.Runtime.IRuleReturnScope, Antlr.Runtime.IAstRuleReturnScope<TTree>, Antlr.Runtime.IAstRuleReturnScope
        {
            public AstParserRuleReturnScope() => throw null;
            public TTree Tree { get => throw null; set => throw null; }
            object Antlr.Runtime.IAstRuleReturnScope.Tree { get => throw null; }
        }

        // Generated from `Antlr.Runtime.BaseRecognizer` in `Antlr3.Runtime, Version=3.5.0.2, Culture=neutral, PublicKeyToken=eb42632606e9261f`
        public abstract class BaseRecognizer
        {
            public virtual bool AlreadyParsedRule(Antlr.Runtime.IIntStream input, int ruleIndex) => throw null;
            public virtual int BacktrackingLevel { get => throw null; set => throw null; }
            public BaseRecognizer(Antlr.Runtime.RecognizerSharedState state) => throw null;
            public BaseRecognizer() => throw null;
            public virtual void BeginResync() => throw null;
            protected virtual Antlr.Runtime.BitSet CombineFollows(bool exact) => throw null;
            protected virtual Antlr.Runtime.BitSet ComputeContextSensitiveRuleFOLLOW() => throw null;
            protected virtual Antlr.Runtime.BitSet ComputeErrorRecoverySet() => throw null;
            public virtual void ConsumeUntil(Antlr.Runtime.IIntStream input, int tokenType) => throw null;
            public virtual void ConsumeUntil(Antlr.Runtime.IIntStream input, Antlr.Runtime.BitSet set) => throw null;
            protected virtual void DebugBeginBacktrack(int level) => throw null;
            protected virtual void DebugEndBacktrack(int level, bool successful) => throw null;
            protected virtual void DebugEnterAlt(int alt) => throw null;
            protected virtual void DebugEnterDecision(int decisionNumber, bool couldBacktrack) => throw null;
            protected virtual void DebugEnterRule(string grammarFileName, string ruleName) => throw null;
            protected virtual void DebugEnterSubRule(int decisionNumber) => throw null;
            protected virtual void DebugExitDecision(int decisionNumber) => throw null;
            protected virtual void DebugExitRule(string grammarFileName, string ruleName) => throw null;
            protected virtual void DebugExitSubRule(int decisionNumber) => throw null;
            public virtual Antlr.Runtime.Debug.IDebugEventListener DebugListener { get => throw null; }
            protected virtual void DebugLocation(int line, int charPositionInLine) => throw null;
            protected virtual void DebugRecognitionException(Antlr.Runtime.RecognitionException ex) => throw null;
            protected virtual void DebugSemanticPredicate(bool result, string predicate) => throw null;
            public const int DefaultTokenChannel = default;
            public virtual void DisplayRecognitionError(string[] tokenNames, Antlr.Runtime.RecognitionException e) => throw null;
            public virtual void EmitErrorMessage(string msg) => throw null;
            public virtual void EndResync() => throw null;
            public virtual bool Failed { get => throw null; }
            protected virtual object GetCurrentInputSymbol(Antlr.Runtime.IIntStream input) => throw null;
            public virtual string GetErrorHeader(Antlr.Runtime.RecognitionException e) => throw null;
            public virtual string GetErrorMessage(Antlr.Runtime.RecognitionException e, string[] tokenNames) => throw null;
            protected virtual object GetMissingSymbol(Antlr.Runtime.IIntStream input, Antlr.Runtime.RecognitionException e, int expectedTokenType, Antlr.Runtime.BitSet follow) => throw null;
            public virtual int GetRuleMemoization(int ruleIndex, int ruleStartIndex) => throw null;
            public virtual int GetRuleMemoizationCacheSize() => throw null;
            public virtual string GetTokenErrorDisplay(Antlr.Runtime.IToken t) => throw null;
            public virtual string GrammarFileName { get => throw null; }
            public const int Hidden = default;
            protected virtual void InitDFAs() => throw null;
            public const int InitialFollowStackSize = default;
            public virtual object Match(Antlr.Runtime.IIntStream input, int ttype, Antlr.Runtime.BitSet follow) => throw null;
            public virtual void MatchAny(Antlr.Runtime.IIntStream input) => throw null;
            public const int MemoRuleFailed = default;
            public const int MemoRuleUnknown = default;
            public virtual void Memoize(Antlr.Runtime.IIntStream input, int ruleIndex, int ruleStartIndex) => throw null;
            public virtual bool MismatchIsMissingToken(Antlr.Runtime.IIntStream input, Antlr.Runtime.BitSet follow) => throw null;
            public virtual bool MismatchIsUnwantedToken(Antlr.Runtime.IIntStream input, int ttype) => throw null;
            public const string NextTokenRuleName = default;
            public virtual int NumberOfSyntaxErrors { get => throw null; }
            protected void PopFollow() => throw null;
            protected void PushFollow(Antlr.Runtime.BitSet fset) => throw null;
            public virtual void Recover(Antlr.Runtime.IIntStream input, Antlr.Runtime.RecognitionException re) => throw null;
            public virtual object RecoverFromMismatchedSet(Antlr.Runtime.IIntStream input, Antlr.Runtime.RecognitionException e, Antlr.Runtime.BitSet follow) => throw null;
            protected virtual object RecoverFromMismatchedToken(Antlr.Runtime.IIntStream input, int ttype, Antlr.Runtime.BitSet follow) => throw null;
            public virtual void ReportError(Antlr.Runtime.RecognitionException e) => throw null;
            public virtual void Reset() => throw null;
            public virtual void SetState(Antlr.Runtime.RecognizerSharedState value) => throw null;
            public abstract string SourceName { get; }
            public virtual System.Collections.Generic.List<string> ToStrings(System.Collections.Generic.ICollection<Antlr.Runtime.IToken> tokens) => throw null;
            public virtual string[] TokenNames { get => throw null; }
            public System.IO.TextWriter TraceDestination { get => throw null; set => throw null; }
            public virtual void TraceIn(string ruleName, int ruleIndex, object inputSymbol) => throw null;
            public virtual void TraceOut(string ruleName, int ruleIndex, object inputSymbol) => throw null;
            protected internal Antlr.Runtime.RecognizerSharedState state;
        }

        // Generated from `Antlr.Runtime.BitSet` in `Antlr3.Runtime, Version=3.5.0.2, Culture=neutral, PublicKeyToken=eb42632606e9261f`
        public class BitSet : System.ICloneable
        {
            public void Add(int el) => throw null;
            public BitSet(int nbits) => throw null;
            public BitSet(System.UInt64[] bits) => throw null;
            public BitSet(System.Collections.Generic.IEnumerable<int> items) => throw null;
            public BitSet() => throw null;
            public object Clone() => throw null;
            public override bool Equals(object other) => throw null;
            public override int GetHashCode() => throw null;
            public void GrowToInclude(int bit) => throw null;
            public bool IsNil() => throw null;
            public int LengthInLongWords() => throw null;
            public bool Member(int el) => throw null;
            public int NumBits() => throw null;
            public static Antlr.Runtime.BitSet Of(int el) => throw null;
            public static Antlr.Runtime.BitSet Of(int a, int b, int c, int d) => throw null;
            public static Antlr.Runtime.BitSet Of(int a, int b, int c) => throw null;
            public static Antlr.Runtime.BitSet Of(int a, int b) => throw null;
            public Antlr.Runtime.BitSet Or(Antlr.Runtime.BitSet a) => throw null;
            public void OrInPlace(Antlr.Runtime.BitSet a) => throw null;
            public void Remove(int el) => throw null;
            public int Size() => throw null;
            public int[] ToArray() => throw null;
            public string ToString(string[] tokenNames) => throw null;
            public override string ToString() => throw null;
        }

        // Generated from `Antlr.Runtime.BufferedTokenStream` in `Antlr3.Runtime, Version=3.5.0.2, Culture=neutral, PublicKeyToken=eb42632606e9261f`
        public class BufferedTokenStream : Antlr.Runtime.ITokenStreamInformation, Antlr.Runtime.ITokenStream, Antlr.Runtime.IIntStream
        {
            public BufferedTokenStream(Antlr.Runtime.ITokenSource tokenSource) => throw null;
            public BufferedTokenStream() => throw null;
            public virtual void Consume() => throw null;
            public virtual int Count { get => throw null; }
            protected virtual void Fetch(int n) => throw null;
            public virtual void Fill() => throw null;
            public virtual Antlr.Runtime.IToken Get(int i) => throw null;
            public virtual System.Collections.Generic.List<Antlr.Runtime.IToken> GetTokens(int start, int stop, int ttype) => throw null;
            public virtual System.Collections.Generic.List<Antlr.Runtime.IToken> GetTokens(int start, int stop, System.Collections.Generic.IEnumerable<int> types) => throw null;
            public virtual System.Collections.Generic.List<Antlr.Runtime.IToken> GetTokens(int start, int stop, Antlr.Runtime.BitSet types) => throw null;
            public virtual System.Collections.Generic.List<Antlr.Runtime.IToken> GetTokens(int start, int stop) => throw null;
            public virtual System.Collections.Generic.List<Antlr.Runtime.IToken> GetTokens() => throw null;
            public virtual int Index { get => throw null; }
            public virtual int LA(int i) => throw null;
            protected virtual Antlr.Runtime.IToken LB(int k) => throw null;
            public virtual Antlr.Runtime.IToken LT(int k) => throw null;
            public virtual Antlr.Runtime.IToken LastRealToken { get => throw null; }
            public virtual Antlr.Runtime.IToken LastToken { get => throw null; }
            public virtual int Mark() => throw null;
            public virtual int MaxLookBehind { get => throw null; }
            public virtual int Range { get => throw null; set => throw null; }
            public virtual void Release(int marker) => throw null;
            public virtual void Reset() => throw null;
            public virtual void Rewind(int marker) => throw null;
            public virtual void Rewind() => throw null;
            public virtual void Seek(int index) => throw null;
            protected virtual void Setup() => throw null;
            public virtual string SourceName { get => throw null; }
            protected virtual void Sync(int i) => throw null;
            public virtual string ToString(int start, int stop) => throw null;
            public virtual string ToString(Antlr.Runtime.IToken start, Antlr.Runtime.IToken stop) => throw null;
            public override string ToString() => throw null;
            public virtual Antlr.Runtime.ITokenSource TokenSource { get => throw null; set => throw null; }
            protected int _p;
            protected System.Collections.Generic.List<Antlr.Runtime.IToken> _tokens;
        }

        // Generated from `Antlr.Runtime.CharStreamConstants` in `Antlr3.Runtime, Version=3.5.0.2, Culture=neutral, PublicKeyToken=eb42632606e9261f`
        public static class CharStreamConstants
        {
            public const int EndOfFile = default;
        }

        // Generated from `Antlr.Runtime.CharStreamState` in `Antlr3.Runtime, Version=3.5.0.2, Culture=neutral, PublicKeyToken=eb42632606e9261f`
        public class CharStreamState
        {
            public CharStreamState() => throw null;
            public int charPositionInLine;
            public int line;
            public int p;
        }

        // Generated from `Antlr.Runtime.ClassicToken` in `Antlr3.Runtime, Version=3.5.0.2, Culture=neutral, PublicKeyToken=eb42632606e9261f`
        public class ClassicToken : Antlr.Runtime.IToken
        {
            public int Channel { get => throw null; set => throw null; }
            public int CharPositionInLine { get => throw null; set => throw null; }
            public ClassicToken(int type, string text, int channel) => throw null;
            public ClassicToken(int type, string text) => throw null;
            public ClassicToken(int type) => throw null;
            public ClassicToken(Antlr.Runtime.IToken oldToken) => throw null;
            public Antlr.Runtime.ICharStream InputStream { get => throw null; set => throw null; }
            public int Line { get => throw null; set => throw null; }
            public int StartIndex { get => throw null; set => throw null; }
            public int StopIndex { get => throw null; set => throw null; }
            public string Text { get => throw null; set => throw null; }
            public override string ToString() => throw null;
            public int TokenIndex { get => throw null; set => throw null; }
            public int Type { get => throw null; set => throw null; }
        }

        // Generated from `Antlr.Runtime.CommonToken` in `Antlr3.Runtime, Version=3.5.0.2, Culture=neutral, PublicKeyToken=eb42632606e9261f`
        public class CommonToken : Antlr.Runtime.IToken
        {
            public int Channel { get => throw null; set => throw null; }
            public int CharPositionInLine { get => throw null; set => throw null; }
            public CommonToken(int type, string text) => throw null;
            public CommonToken(int type) => throw null;
            public CommonToken(Antlr.Runtime.IToken oldToken) => throw null;
            public CommonToken(Antlr.Runtime.ICharStream input, int type, int channel, int start, int stop) => throw null;
            public CommonToken() => throw null;
            public Antlr.Runtime.ICharStream InputStream { get => throw null; set => throw null; }
            public int Line { get => throw null; set => throw null; }
            public int StartIndex { get => throw null; set => throw null; }
            public int StopIndex { get => throw null; set => throw null; }
            public string Text { get => throw null; set => throw null; }
            public override string ToString() => throw null;
            public int TokenIndex { get => throw null; set => throw null; }
            public int Type { get => throw null; set => throw null; }
        }

        // Generated from `Antlr.Runtime.CommonTokenStream` in `Antlr3.Runtime, Version=3.5.0.2, Culture=neutral, PublicKeyToken=eb42632606e9261f`
        public class CommonTokenStream : Antlr.Runtime.BufferedTokenStream
        {
            public int Channel { get => throw null; }
            public CommonTokenStream(Antlr.Runtime.ITokenSource tokenSource, int channel) => throw null;
            public CommonTokenStream(Antlr.Runtime.ITokenSource tokenSource) => throw null;
            public CommonTokenStream() => throw null;
            public override void Consume() => throw null;
            protected override Antlr.Runtime.IToken LB(int k) => throw null;
            public override Antlr.Runtime.IToken LT(int k) => throw null;
            public override void Reset() => throw null;
            protected override void Setup() => throw null;
            protected virtual int SkipOffTokenChannels(int i) => throw null;
            protected virtual int SkipOffTokenChannelsReverse(int i) => throw null;
            public override Antlr.Runtime.ITokenSource TokenSource { get => throw null; set => throw null; }
        }

        // Generated from `Antlr.Runtime.DFA` in `Antlr3.Runtime, Version=3.5.0.2, Culture=neutral, PublicKeyToken=eb42632606e9261f`
        public class DFA
        {
            public DFA(Antlr.Runtime.SpecialStateTransitionHandler specialStateTransition) => throw null;
            public DFA() => throw null;
            protected virtual void DebugRecognitionException(Antlr.Runtime.RecognitionException ex) => throw null;
            public virtual string Description { get => throw null; }
            public virtual void Error(Antlr.Runtime.NoViableAltException nvae) => throw null;
            protected virtual void NoViableAlt(int s, Antlr.Runtime.IIntStream input) => throw null;
            public virtual int Predict(Antlr.Runtime.IIntStream input) => throw null;
            public Antlr.Runtime.SpecialStateTransitionHandler SpecialStateTransition { get => throw null; set => throw null; }
            public static System.Int16[] UnpackEncodedString(string encodedString) => throw null;
            public static System.Char[] UnpackEncodedStringToUnsignedChars(string encodedString) => throw null;
            protected System.Int16[] accept;
            public bool debug;
            protected int decisionNumber;
            protected System.Int16[] eof;
            protected System.Int16[] eot;
            protected System.Char[] max;
            protected System.Char[] min;
            protected Antlr.Runtime.BaseRecognizer recognizer;
            protected System.Int16[] special;
            protected System.Int16[][] transition;
        }

        // Generated from `Antlr.Runtime.EarlyExitException` in `Antlr3.Runtime, Version=3.5.0.2, Culture=neutral, PublicKeyToken=eb42632606e9261f`
        public class EarlyExitException : Antlr.Runtime.RecognitionException
        {
            public int DecisionNumber { get => throw null; }
            public EarlyExitException(string message, int decisionNumber, Antlr.Runtime.IIntStream input, System.Exception innerException) => throw null;
            public EarlyExitException(string message, int decisionNumber, Antlr.Runtime.IIntStream input) => throw null;
            public EarlyExitException(string message, System.Exception innerException) => throw null;
            public EarlyExitException(string message) => throw null;
            public EarlyExitException(int decisionNumber, Antlr.Runtime.IIntStream input) => throw null;
            public EarlyExitException() => throw null;
        }

        // Generated from `Antlr.Runtime.FailedPredicateException` in `Antlr3.Runtime, Version=3.5.0.2, Culture=neutral, PublicKeyToken=eb42632606e9261f`
        public class FailedPredicateException : Antlr.Runtime.RecognitionException
        {
            public FailedPredicateException(string message, System.Exception innerException) => throw null;
            public FailedPredicateException(string message, Antlr.Runtime.IIntStream input, string ruleName, string predicateText, System.Exception innerException) => throw null;
            public FailedPredicateException(string message, Antlr.Runtime.IIntStream input, string ruleName, string predicateText) => throw null;
            public FailedPredicateException(string message) => throw null;
            public FailedPredicateException(Antlr.Runtime.IIntStream input, string ruleName, string predicateText) => throw null;
            public FailedPredicateException() => throw null;
            public string PredicateText { get => throw null; }
            public string RuleName { get => throw null; }
            public override string ToString() => throw null;
        }

        // Generated from `Antlr.Runtime.GrammarRuleAttribute` in `Antlr3.Runtime, Version=3.5.0.2, Culture=neutral, PublicKeyToken=eb42632606e9261f`
        public class GrammarRuleAttribute : System.Attribute
        {
            public GrammarRuleAttribute(string name) => throw null;
            public string Name { get => throw null; }
        }

        // Generated from `Antlr.Runtime.IAstRuleReturnScope` in `Antlr3.Runtime, Version=3.5.0.2, Culture=neutral, PublicKeyToken=eb42632606e9261f`
        public interface IAstRuleReturnScope : Antlr.Runtime.IRuleReturnScope
        {
            object Tree { get; }
        }

        // Generated from `Antlr.Runtime.IAstRuleReturnScope<>` in `Antlr3.Runtime, Version=3.5.0.2, Culture=neutral, PublicKeyToken=eb42632606e9261f`
        public interface IAstRuleReturnScope<TAstLabel> : Antlr.Runtime.IRuleReturnScope, Antlr.Runtime.IAstRuleReturnScope
        {
            TAstLabel Tree { get; }
        }

        // Generated from `Antlr.Runtime.ICharStream` in `Antlr3.Runtime, Version=3.5.0.2, Culture=neutral, PublicKeyToken=eb42632606e9261f`
        public interface ICharStream : Antlr.Runtime.IIntStream
        {
            int CharPositionInLine { get; set; }
            int LT(int i);
            int Line { get; set; }
            string Substring(int start, int length);
        }

        // Generated from `Antlr.Runtime.IIntStream` in `Antlr3.Runtime, Version=3.5.0.2, Culture=neutral, PublicKeyToken=eb42632606e9261f`
        public interface IIntStream
        {
            void Consume();
            int Count { get; }
            int Index { get; }
            int LA(int i);
            int Mark();
            void Release(int marker);
            void Rewind(int marker);
            void Rewind();
            void Seek(int index);
            string SourceName { get; }
        }

        // Generated from `Antlr.Runtime.IRuleReturnScope` in `Antlr3.Runtime, Version=3.5.0.2, Culture=neutral, PublicKeyToken=eb42632606e9261f`
        public interface IRuleReturnScope
        {
            object Start { get; }
            object Stop { get; }
        }

        // Generated from `Antlr.Runtime.IRuleReturnScope<>` in `Antlr3.Runtime, Version=3.5.0.2, Culture=neutral, PublicKeyToken=eb42632606e9261f`
        public interface IRuleReturnScope<TLabel> : Antlr.Runtime.IRuleReturnScope
        {
            TLabel Start { get; }
            TLabel Stop { get; }
        }

        // Generated from `Antlr.Runtime.ITemplateRuleReturnScope` in `Antlr3.Runtime, Version=3.5.0.2, Culture=neutral, PublicKeyToken=eb42632606e9261f`
        public interface ITemplateRuleReturnScope
        {
            object Template { get; }
        }

        // Generated from `Antlr.Runtime.ITemplateRuleReturnScope<>` in `Antlr3.Runtime, Version=3.5.0.2, Culture=neutral, PublicKeyToken=eb42632606e9261f`
        public interface ITemplateRuleReturnScope<TTemplate> : Antlr.Runtime.ITemplateRuleReturnScope
        {
            TTemplate Template { get; }
        }

        // Generated from `Antlr.Runtime.IToken` in `Antlr3.Runtime, Version=3.5.0.2, Culture=neutral, PublicKeyToken=eb42632606e9261f`
        public interface IToken
        {
            int Channel { get; set; }
            int CharPositionInLine { get; set; }
            Antlr.Runtime.ICharStream InputStream { get; set; }
            int Line { get; set; }
            int StartIndex { get; set; }
            int StopIndex { get; set; }
            string Text { get; set; }
            int TokenIndex { get; set; }
            int Type { get; set; }
        }

        // Generated from `Antlr.Runtime.ITokenSource` in `Antlr3.Runtime, Version=3.5.0.2, Culture=neutral, PublicKeyToken=eb42632606e9261f`
        public interface ITokenSource
        {
            Antlr.Runtime.IToken NextToken();
            string SourceName { get; }
            string[] TokenNames { get; }
        }

        // Generated from `Antlr.Runtime.ITokenStream` in `Antlr3.Runtime, Version=3.5.0.2, Culture=neutral, PublicKeyToken=eb42632606e9261f`
        public interface ITokenStream : Antlr.Runtime.IIntStream
        {
            Antlr.Runtime.IToken Get(int i);
            Antlr.Runtime.IToken LT(int k);
            int Range { get; }
            string ToString(int start, int stop);
            string ToString(Antlr.Runtime.IToken start, Antlr.Runtime.IToken stop);
            Antlr.Runtime.ITokenSource TokenSource { get; }
        }

        // Generated from `Antlr.Runtime.ITokenStreamInformation` in `Antlr3.Runtime, Version=3.5.0.2, Culture=neutral, PublicKeyToken=eb42632606e9261f`
        public interface ITokenStreamInformation
        {
            Antlr.Runtime.IToken LastRealToken { get; }
            Antlr.Runtime.IToken LastToken { get; }
            int MaxLookBehind { get; }
        }

        // Generated from `Antlr.Runtime.LegacyCommonTokenStream` in `Antlr3.Runtime, Version=3.5.0.2, Culture=neutral, PublicKeyToken=eb42632606e9261f`
        public class LegacyCommonTokenStream : Antlr.Runtime.ITokenStream, Antlr.Runtime.IIntStream
        {
            public virtual void Consume() => throw null;
            public virtual int Count { get => throw null; }
            public virtual void DiscardTokenType(int ttype) => throw null;
            public virtual void FillBuffer() => throw null;
            public virtual Antlr.Runtime.IToken Get(int i) => throw null;
            public virtual System.Collections.Generic.IList<Antlr.Runtime.IToken> GetTokens(int start, int stop, int ttype) => throw null;
            public virtual System.Collections.Generic.IList<Antlr.Runtime.IToken> GetTokens(int start, int stop, System.Collections.Generic.IList<int> types) => throw null;
            public virtual System.Collections.Generic.IList<Antlr.Runtime.IToken> GetTokens(int start, int stop, Antlr.Runtime.BitSet types) => throw null;
            public virtual System.Collections.Generic.IList<Antlr.Runtime.IToken> GetTokens(int start, int stop) => throw null;
            public virtual System.Collections.Generic.IList<Antlr.Runtime.IToken> GetTokens() => throw null;
            public virtual int Index { get => throw null; }
            public virtual int LA(int i) => throw null;
            protected virtual Antlr.Runtime.IToken LB(int k) => throw null;
            public virtual Antlr.Runtime.IToken LT(int k) => throw null;
            public LegacyCommonTokenStream(Antlr.Runtime.ITokenSource tokenSource, int channel) => throw null;
            public LegacyCommonTokenStream(Antlr.Runtime.ITokenSource tokenSource) => throw null;
            public LegacyCommonTokenStream() => throw null;
            public virtual int Mark() => throw null;
            public virtual int Range { get => throw null; set => throw null; }
            public virtual void Release(int marker) => throw null;
            public virtual void Reset() => throw null;
            public virtual void Rewind(int marker) => throw null;
            public virtual void Rewind() => throw null;
            public virtual void Seek(int index) => throw null;
            public virtual void SetDiscardOffChannelTokens(bool discardOffChannelTokens) => throw null;
            public virtual void SetTokenSource(Antlr.Runtime.ITokenSource tokenSource) => throw null;
            public virtual void SetTokenTypeChannel(int ttype, int channel) => throw null;
            protected virtual int SkipOffTokenChannels(int i) => throw null;
            protected virtual int SkipOffTokenChannelsReverse(int i) => throw null;
            public virtual string SourceName { get => throw null; }
            public virtual string ToString(int start, int stop) => throw null;
            public virtual string ToString(Antlr.Runtime.IToken start, Antlr.Runtime.IToken stop) => throw null;
            public override string ToString() => throw null;
            public virtual Antlr.Runtime.ITokenSource TokenSource { get => throw null; }
            protected int channel;
            protected System.Collections.Generic.IDictionary<int, int> channelOverrideMap;
            protected bool discardOffChannelTokens;
            protected System.Collections.Generic.List<int> discardSet;
            protected int lastMarker;
            protected int p;
            protected System.Collections.Generic.List<Antlr.Runtime.IToken> tokens;
        }

        // Generated from `Antlr.Runtime.Lexer` in `Antlr3.Runtime, Version=3.5.0.2, Culture=neutral, PublicKeyToken=eb42632606e9261f`
        public abstract class Lexer : Antlr.Runtime.BaseRecognizer, Antlr.Runtime.ITokenSource
        {
            public virtual int CharIndex { get => throw null; }
            public int CharPositionInLine { get => throw null; set => throw null; }
            public virtual Antlr.Runtime.ICharStream CharStream { get => throw null; set => throw null; }
            public virtual void Emit(Antlr.Runtime.IToken token) => throw null;
            public virtual Antlr.Runtime.IToken Emit() => throw null;
            public virtual string GetCharErrorDisplay(int c) => throw null;
            public virtual Antlr.Runtime.IToken GetEndOfFileToken() => throw null;
            public override string GetErrorMessage(Antlr.Runtime.RecognitionException e, string[] tokenNames) => throw null;
            public Lexer(Antlr.Runtime.ICharStream input, Antlr.Runtime.RecognizerSharedState state) => throw null;
            public Lexer(Antlr.Runtime.ICharStream input) => throw null;
            public Lexer() => throw null;
            public int Line { get => throw null; set => throw null; }
            public virtual void Match(string s) => throw null;
            public virtual void Match(int c) => throw null;
            public virtual void MatchAny() => throw null;
            public virtual void MatchRange(int a, int b) => throw null;
            public virtual Antlr.Runtime.IToken NextToken() => throw null;
            protected virtual void ParseNextToken() => throw null;
            public virtual void Recover(Antlr.Runtime.RecognitionException re) => throw null;
            public override void ReportError(Antlr.Runtime.RecognitionException e) => throw null;
            public override void Reset() => throw null;
            public virtual void Skip() => throw null;
            public override string SourceName { get => throw null; }
            public string Text { get => throw null; set => throw null; }
            public virtual void TraceIn(string ruleName, int ruleIndex) => throw null;
            public virtual void TraceOut(string ruleName, int ruleIndex) => throw null;
            protected Antlr.Runtime.ICharStream input;
            public abstract void mTokens();
        }

        // Generated from `Antlr.Runtime.MismatchedNotSetException` in `Antlr3.Runtime, Version=3.5.0.2, Culture=neutral, PublicKeyToken=eb42632606e9261f`
        public class MismatchedNotSetException : Antlr.Runtime.MismatchedSetException
        {
            public MismatchedNotSetException(string message, System.Exception innerException) => throw null;
            public MismatchedNotSetException(string message, Antlr.Runtime.BitSet expecting, Antlr.Runtime.IIntStream input, System.Exception innerException) => throw null;
            public MismatchedNotSetException(string message, Antlr.Runtime.BitSet expecting, Antlr.Runtime.IIntStream input) => throw null;
            public MismatchedNotSetException(string message) => throw null;
            public MismatchedNotSetException(Antlr.Runtime.BitSet expecting, Antlr.Runtime.IIntStream input) => throw null;
            public MismatchedNotSetException() => throw null;
            public override string ToString() => throw null;
        }

        // Generated from `Antlr.Runtime.MismatchedRangeException` in `Antlr3.Runtime, Version=3.5.0.2, Culture=neutral, PublicKeyToken=eb42632606e9261f`
        public class MismatchedRangeException : Antlr.Runtime.RecognitionException
        {
            public int A { get => throw null; }
            public int B { get => throw null; }
            public MismatchedRangeException(string message, int a, int b, Antlr.Runtime.IIntStream input, System.Exception innerException) => throw null;
            public MismatchedRangeException(string message, int a, int b, Antlr.Runtime.IIntStream input) => throw null;
            public MismatchedRangeException(string message, System.Exception innerException) => throw null;
            public MismatchedRangeException(string message) => throw null;
            public MismatchedRangeException(int a, int b, Antlr.Runtime.IIntStream input) => throw null;
            public MismatchedRangeException() => throw null;
            public override string ToString() => throw null;
        }

        // Generated from `Antlr.Runtime.MismatchedSetException` in `Antlr3.Runtime, Version=3.5.0.2, Culture=neutral, PublicKeyToken=eb42632606e9261f`
        public class MismatchedSetException : Antlr.Runtime.RecognitionException
        {
            public Antlr.Runtime.BitSet Expecting { get => throw null; }
            public MismatchedSetException(string message, System.Exception innerException) => throw null;
            public MismatchedSetException(string message, Antlr.Runtime.BitSet expecting, Antlr.Runtime.IIntStream input, System.Exception innerException) => throw null;
            public MismatchedSetException(string message, Antlr.Runtime.BitSet expecting, Antlr.Runtime.IIntStream input) => throw null;
            public MismatchedSetException(string message) => throw null;
            public MismatchedSetException(Antlr.Runtime.BitSet expecting, Antlr.Runtime.IIntStream input) => throw null;
            public MismatchedSetException() => throw null;
            public override string ToString() => throw null;
        }

        // Generated from `Antlr.Runtime.MismatchedTokenException` in `Antlr3.Runtime, Version=3.5.0.2, Culture=neutral, PublicKeyToken=eb42632606e9261f`
        public class MismatchedTokenException : Antlr.Runtime.RecognitionException
        {
            public int Expecting { get => throw null; }
            public MismatchedTokenException(string message, int expecting, Antlr.Runtime.IIntStream input, System.Collections.Generic.IList<string> tokenNames, System.Exception innerException) => throw null;
            public MismatchedTokenException(string message, int expecting, Antlr.Runtime.IIntStream input, System.Collections.Generic.IList<string> tokenNames) => throw null;
            public MismatchedTokenException(string message, System.Exception innerException) => throw null;
            public MismatchedTokenException(string message) => throw null;
            public MismatchedTokenException(int expecting, Antlr.Runtime.IIntStream input, System.Collections.Generic.IList<string> tokenNames) => throw null;
            public MismatchedTokenException(int expecting, Antlr.Runtime.IIntStream input) => throw null;
            public MismatchedTokenException() => throw null;
            public override string ToString() => throw null;
            public System.Collections.ObjectModel.ReadOnlyCollection<string> TokenNames { get => throw null; }
        }

        // Generated from `Antlr.Runtime.MismatchedTreeNodeException` in `Antlr3.Runtime, Version=3.5.0.2, Culture=neutral, PublicKeyToken=eb42632606e9261f`
        public class MismatchedTreeNodeException : Antlr.Runtime.RecognitionException
        {
            public int Expecting { get => throw null; }
            public MismatchedTreeNodeException(string message, int expecting, Antlr.Runtime.Tree.ITreeNodeStream input, System.Exception innerException) => throw null;
            public MismatchedTreeNodeException(string message, int expecting, Antlr.Runtime.Tree.ITreeNodeStream input) => throw null;
            public MismatchedTreeNodeException(string message, System.Exception innerException) => throw null;
            public MismatchedTreeNodeException(string message) => throw null;
            public MismatchedTreeNodeException(int expecting, Antlr.Runtime.Tree.ITreeNodeStream input) => throw null;
            public MismatchedTreeNodeException() => throw null;
            public override string ToString() => throw null;
        }

        // Generated from `Antlr.Runtime.MissingTokenException` in `Antlr3.Runtime, Version=3.5.0.2, Culture=neutral, PublicKeyToken=eb42632606e9261f`
        public class MissingTokenException : Antlr.Runtime.MismatchedTokenException
        {
            public MissingTokenException(string message, int expecting, Antlr.Runtime.IIntStream input, object inserted, System.Collections.Generic.IList<string> tokenNames, System.Exception innerException) => throw null;
            public MissingTokenException(string message, int expecting, Antlr.Runtime.IIntStream input, object inserted, System.Collections.Generic.IList<string> tokenNames) => throw null;
            public MissingTokenException(string message, System.Exception innerException) => throw null;
            public MissingTokenException(string message) => throw null;
            public MissingTokenException(int expecting, Antlr.Runtime.IIntStream input, object inserted, System.Collections.Generic.IList<string> tokenNames) => throw null;
            public MissingTokenException(int expecting, Antlr.Runtime.IIntStream input, object inserted) => throw null;
            public MissingTokenException() => throw null;
            public virtual int MissingType { get => throw null; }
            public override string ToString() => throw null;
        }

        // Generated from `Antlr.Runtime.NoViableAltException` in `Antlr3.Runtime, Version=3.5.0.2, Culture=neutral, PublicKeyToken=eb42632606e9261f`
        public class NoViableAltException : Antlr.Runtime.RecognitionException
        {
            public int DecisionNumber { get => throw null; }
            public string GrammarDecisionDescription { get => throw null; }
            public NoViableAltException(string message, string grammarDecisionDescription, int decisionNumber, int stateNumber, Antlr.Runtime.IIntStream input, int k, System.Exception innerException) => throw null;
            public NoViableAltException(string message, string grammarDecisionDescription, int decisionNumber, int stateNumber, Antlr.Runtime.IIntStream input, int k) => throw null;
            public NoViableAltException(string message, string grammarDecisionDescription, int decisionNumber, int stateNumber, Antlr.Runtime.IIntStream input, System.Exception innerException) => throw null;
            public NoViableAltException(string message, string grammarDecisionDescription, int decisionNumber, int stateNumber, Antlr.Runtime.IIntStream input) => throw null;
            public NoViableAltException(string message, string grammarDecisionDescription, System.Exception innerException) => throw null;
            public NoViableAltException(string message, string grammarDecisionDescription) => throw null;
            public NoViableAltException(string grammarDecisionDescription, int decisionNumber, int stateNumber, Antlr.Runtime.IIntStream input, int k) => throw null;
            public NoViableAltException(string grammarDecisionDescription, int decisionNumber, int stateNumber, Antlr.Runtime.IIntStream input) => throw null;
            public NoViableAltException(string grammarDecisionDescription) => throw null;
            public NoViableAltException() => throw null;
            public int StateNumber { get => throw null; }
            public override string ToString() => throw null;
        }

        // Generated from `Antlr.Runtime.Parser` in `Antlr3.Runtime, Version=3.5.0.2, Culture=neutral, PublicKeyToken=eb42632606e9261f`
        public class Parser : Antlr.Runtime.BaseRecognizer
        {
            protected override object GetCurrentInputSymbol(Antlr.Runtime.IIntStream input) => throw null;
            protected override object GetMissingSymbol(Antlr.Runtime.IIntStream input, Antlr.Runtime.RecognitionException e, int expectedTokenType, Antlr.Runtime.BitSet follow) => throw null;
            public Parser(Antlr.Runtime.ITokenStream input, Antlr.Runtime.RecognizerSharedState state) => throw null;
            public Parser(Antlr.Runtime.ITokenStream input) => throw null;
            public override void Reset() => throw null;
            public override string SourceName { get => throw null; }
            public virtual Antlr.Runtime.ITokenStream TokenStream { get => throw null; set => throw null; }
            public virtual void TraceIn(string ruleName, int ruleIndex) => throw null;
            public virtual void TraceOut(string ruleName, int ruleIndex) => throw null;
            public Antlr.Runtime.ITokenStream input;
        }

        // Generated from `Antlr.Runtime.ParserRuleReturnScope<>` in `Antlr3.Runtime, Version=3.5.0.2, Culture=neutral, PublicKeyToken=eb42632606e9261f`
        public class ParserRuleReturnScope<TToken> : Antlr.Runtime.IRuleReturnScope<TToken>, Antlr.Runtime.IRuleReturnScope
        {
            public ParserRuleReturnScope() => throw null;
            public TToken Start { get => throw null; set => throw null; }
            object Antlr.Runtime.IRuleReturnScope.Start { get => throw null; }
            public TToken Stop { get => throw null; set => throw null; }
            object Antlr.Runtime.IRuleReturnScope.Stop { get => throw null; }
        }

        // Generated from `Antlr.Runtime.RecognitionException` in `Antlr3.Runtime, Version=3.5.0.2, Culture=neutral, PublicKeyToken=eb42632606e9261f`
        public class RecognitionException : System.Exception
        {
            public bool ApproximateLineInfo { get => throw null; set => throw null; }
            public int CharPositionInLine { get => throw null; set => throw null; }
            public int Character { get => throw null; set => throw null; }
            protected virtual void ExtractInformationFromTreeNodeStream(Antlr.Runtime.Tree.ITreeNodeStream input, int k) => throw null;
            protected virtual void ExtractInformationFromTreeNodeStream(Antlr.Runtime.Tree.ITreeNodeStream input) => throw null;
            public int Index { get => throw null; set => throw null; }
            public Antlr.Runtime.IIntStream Input { get => throw null; set => throw null; }
            public int Line { get => throw null; set => throw null; }
            public int Lookahead { get => throw null; }
            public object Node { get => throw null; set => throw null; }
            public RecognitionException(string message, System.Exception innerException) => throw null;
            public RecognitionException(string message, Antlr.Runtime.IIntStream input, int k, System.Exception innerException) => throw null;
            public RecognitionException(string message, Antlr.Runtime.IIntStream input, int k) => throw null;
            public RecognitionException(string message, Antlr.Runtime.IIntStream input, System.Exception innerException) => throw null;
            public RecognitionException(string message, Antlr.Runtime.IIntStream input) => throw null;
            public RecognitionException(string message) => throw null;
            public RecognitionException(Antlr.Runtime.IIntStream input, int k) => throw null;
            public RecognitionException(Antlr.Runtime.IIntStream input) => throw null;
            public RecognitionException() => throw null;
            public Antlr.Runtime.IToken Token { get => throw null; set => throw null; }
            public virtual int UnexpectedType { get => throw null; }
        }

        // Generated from `Antlr.Runtime.RecognizerSharedState` in `Antlr3.Runtime, Version=3.5.0.2, Culture=neutral, PublicKeyToken=eb42632606e9261f`
        public class RecognizerSharedState
        {
            public RecognizerSharedState(Antlr.Runtime.RecognizerSharedState state) => throw null;
            public RecognizerSharedState() => throw null;
            public int _fsp;
            public int backtracking;
            public int channel;
            public bool errorRecovery;
            public bool failed;
            public Antlr.Runtime.BitSet[] following;
            public int lastErrorIndex;
            public System.Collections.Generic.IDictionary<int, int>[] ruleMemo;
            public int syntaxErrors;
            public string text;
            public Antlr.Runtime.IToken token;
            public int tokenStartCharIndex;
            public int tokenStartCharPositionInLine;
            public int tokenStartLine;
            public int type;
        }

        // Generated from `Antlr.Runtime.SpecialStateTransitionHandler` in `Antlr3.Runtime, Version=3.5.0.2, Culture=neutral, PublicKeyToken=eb42632606e9261f`
        public delegate int SpecialStateTransitionHandler(Antlr.Runtime.DFA dfa, int s, Antlr.Runtime.IIntStream input);

        // Generated from `Antlr.Runtime.TemplateParserRuleReturnScope<,>` in `Antlr3.Runtime, Version=3.5.0.2, Culture=neutral, PublicKeyToken=eb42632606e9261f`
        public class TemplateParserRuleReturnScope<TTemplate, TToken> : Antlr.Runtime.ParserRuleReturnScope<TToken>, Antlr.Runtime.ITemplateRuleReturnScope<TTemplate>, Antlr.Runtime.ITemplateRuleReturnScope
        {
            public TTemplate Template { get => throw null; set => throw null; }
            object Antlr.Runtime.ITemplateRuleReturnScope.Template { get => throw null; }
            public TemplateParserRuleReturnScope() => throw null;
        }

        // Generated from `Antlr.Runtime.TokenChannels` in `Antlr3.Runtime, Version=3.5.0.2, Culture=neutral, PublicKeyToken=eb42632606e9261f`
        public static class TokenChannels
        {
            public const int Default = default;
            public const int Hidden = default;
        }

        // Generated from `Antlr.Runtime.TokenRewriteStream` in `Antlr3.Runtime, Version=3.5.0.2, Culture=neutral, PublicKeyToken=eb42632606e9261f`
        public class TokenRewriteStream : Antlr.Runtime.CommonTokenStream
        {
            protected virtual string CatOpText(object a, object b) => throw null;
            public const string DEFAULT_PROGRAM_NAME = default;
            public virtual void Delete(string programName, int from, int to) => throw null;
            public virtual void Delete(string programName, Antlr.Runtime.IToken from, Antlr.Runtime.IToken to) => throw null;
            public virtual void Delete(int index) => throw null;
            public virtual void Delete(int from, int to) => throw null;
            public virtual void Delete(Antlr.Runtime.IToken indexT) => throw null;
            public virtual void Delete(Antlr.Runtime.IToken from, Antlr.Runtime.IToken to) => throw null;
            public virtual void DeleteProgram(string programName) => throw null;
            public virtual void DeleteProgram() => throw null;
            protected virtual System.Collections.Generic.IList<Antlr.Runtime.TokenRewriteStream.RewriteOperation> GetKindOfOps(System.Collections.Generic.IList<Antlr.Runtime.TokenRewriteStream.RewriteOperation> rewrites, System.Type kind, int before) => throw null;
            protected virtual System.Collections.Generic.IList<Antlr.Runtime.TokenRewriteStream.RewriteOperation> GetKindOfOps(System.Collections.Generic.IList<Antlr.Runtime.TokenRewriteStream.RewriteOperation> rewrites, System.Type kind) => throw null;
            public virtual int GetLastRewriteTokenIndex() => throw null;
            protected virtual int GetLastRewriteTokenIndex(string programName) => throw null;
            protected virtual System.Collections.Generic.IList<Antlr.Runtime.TokenRewriteStream.RewriteOperation> GetProgram(string name) => throw null;
            protected void Init() => throw null;
            public virtual void InsertAfter(string programName, int index, object text) => throw null;
            public virtual void InsertAfter(string programName, Antlr.Runtime.IToken t, object text) => throw null;
            public virtual void InsertAfter(int index, object text) => throw null;
            public virtual void InsertAfter(Antlr.Runtime.IToken t, object text) => throw null;
            public virtual void InsertBefore(string programName, int index, object text) => throw null;
            public virtual void InsertBefore(string programName, Antlr.Runtime.IToken t, object text) => throw null;
            public virtual void InsertBefore(int index, object text) => throw null;
            public virtual void InsertBefore(Antlr.Runtime.IToken t, object text) => throw null;
            public const int MIN_TOKEN_INDEX = default;
            public const int PROGRAM_INIT_SIZE = default;
            protected virtual System.Collections.Generic.IDictionary<int, Antlr.Runtime.TokenRewriteStream.RewriteOperation> ReduceToSingleOperationPerIndex(System.Collections.Generic.IList<Antlr.Runtime.TokenRewriteStream.RewriteOperation> rewrites) => throw null;
            public virtual void Replace(string programName, int from, int to, object text) => throw null;
            public virtual void Replace(string programName, Antlr.Runtime.IToken from, Antlr.Runtime.IToken to, object text) => throw null;
            public virtual void Replace(int index, object text) => throw null;
            public virtual void Replace(int from, int to, object text) => throw null;
            public virtual void Replace(Antlr.Runtime.IToken indexT, object text) => throw null;
            public virtual void Replace(Antlr.Runtime.IToken from, Antlr.Runtime.IToken to, object text) => throw null;
            // Generated from `Antlr.Runtime.TokenRewriteStream+RewriteOperation` in `Antlr3.Runtime, Version=3.5.0.2, Culture=neutral, PublicKeyToken=eb42632606e9261f`
            protected class RewriteOperation
            {
                public virtual int Execute(System.Text.StringBuilder buf) => throw null;
                protected RewriteOperation(Antlr.Runtime.TokenRewriteStream stream, int index, object text) => throw null;
                protected RewriteOperation(Antlr.Runtime.TokenRewriteStream stream, int index) => throw null;
                public override string ToString() => throw null;
                public int index;
                public int instructionIndex;
                protected Antlr.Runtime.TokenRewriteStream stream;
                public object text;
            }


            public virtual void Rollback(string programName, int instructionIndex) => throw null;
            public virtual void Rollback(int instructionIndex) => throw null;
            protected virtual void SetLastRewriteTokenIndex(string programName, int i) => throw null;
            public virtual string ToDebugString(int start, int end) => throw null;
            public virtual string ToDebugString() => throw null;
            public virtual string ToOriginalString(int start, int end) => throw null;
            public virtual string ToOriginalString() => throw null;
            public virtual string ToString(string programName, int start, int end) => throw null;
            public virtual string ToString(string programName) => throw null;
            public override string ToString(int start, int end) => throw null;
            public override string ToString() => throw null;
            public TokenRewriteStream(Antlr.Runtime.ITokenSource tokenSource, int channel) => throw null;
            public TokenRewriteStream(Antlr.Runtime.ITokenSource tokenSource) => throw null;
            public TokenRewriteStream() => throw null;
            protected System.Collections.Generic.IDictionary<string, int> lastRewriteTokenIndexes;
            protected System.Collections.Generic.IDictionary<string, System.Collections.Generic.IList<Antlr.Runtime.TokenRewriteStream.RewriteOperation>> programs;
        }

        // Generated from `Antlr.Runtime.TokenTypes` in `Antlr3.Runtime, Version=3.5.0.2, Culture=neutral, PublicKeyToken=eb42632606e9261f`
        public static class TokenTypes
        {
            public const int Down = default;
            public const int EndOfFile = default;
            public const int EndOfRule = default;
            public const int Invalid = default;
            public const int Min = default;
            public const int Up = default;
        }

        // Generated from `Antlr.Runtime.Tokens` in `Antlr3.Runtime, Version=3.5.0.2, Culture=neutral, PublicKeyToken=eb42632606e9261f`
        public static class Tokens
        {
            public static Antlr.Runtime.IToken Skip;
        }

        // Generated from `Antlr.Runtime.UnbufferedTokenStream` in `Antlr3.Runtime, Version=3.5.0.2, Culture=neutral, PublicKeyToken=eb42632606e9261f`
        public class UnbufferedTokenStream : Antlr.Runtime.Misc.LookaheadStream<Antlr.Runtime.IToken>, Antlr.Runtime.ITokenStreamInformation, Antlr.Runtime.ITokenStream, Antlr.Runtime.IIntStream
        {
            public override void Clear() => throw null;
            public override void Consume() => throw null;
            public Antlr.Runtime.IToken Get(int i) => throw null;
            public override bool IsEndOfFile(Antlr.Runtime.IToken o) => throw null;
            public int LA(int i) => throw null;
            public Antlr.Runtime.IToken LastRealToken { get => throw null; }
            public Antlr.Runtime.IToken LastToken { get => throw null; }
            public override int Mark() => throw null;
            public int MaxLookBehind { get => throw null; }
            public override Antlr.Runtime.IToken NextElement() => throw null;
            public override void Release(int marker) => throw null;
            public string SourceName { get => throw null; }
            public string ToString(int start, int stop) => throw null;
            public string ToString(Antlr.Runtime.IToken start, Antlr.Runtime.IToken stop) => throw null;
            public Antlr.Runtime.ITokenSource TokenSource { get => throw null; }
            public UnbufferedTokenStream(Antlr.Runtime.ITokenSource tokenSource) => throw null;
            protected int channel;
            protected int tokenIndex;
            protected Antlr.Runtime.ITokenSource tokenSource;
        }

        // Generated from `Antlr.Runtime.UnwantedTokenException` in `Antlr3.Runtime, Version=3.5.0.2, Culture=neutral, PublicKeyToken=eb42632606e9261f`
        public class UnwantedTokenException : Antlr.Runtime.MismatchedTokenException
        {
            public override string ToString() => throw null;
            public virtual Antlr.Runtime.IToken UnexpectedToken { get => throw null; }
            public UnwantedTokenException(string message, int expecting, Antlr.Runtime.IIntStream input, System.Collections.Generic.IList<string> tokenNames, System.Exception innerException) => throw null;
            public UnwantedTokenException(string message, int expecting, Antlr.Runtime.IIntStream input, System.Collections.Generic.IList<string> tokenNames) => throw null;
            public UnwantedTokenException(string message, System.Exception innerException) => throw null;
            public UnwantedTokenException(string message) => throw null;
            public UnwantedTokenException(int expecting, Antlr.Runtime.IIntStream input, System.Collections.Generic.IList<string> tokenNames) => throw null;
            public UnwantedTokenException(int expecting, Antlr.Runtime.IIntStream input) => throw null;
            public UnwantedTokenException() => throw null;
        }

        namespace Debug
        {
            // Generated from `Antlr.Runtime.Debug.IDebugEventListener` in `Antlr3.Runtime, Version=3.5.0.2, Culture=neutral, PublicKeyToken=eb42632606e9261f`
            public interface IDebugEventListener
            {
                void AddChild(object root, object child);
                void BecomeRoot(object newRoot, object oldRoot);
                void BeginBacktrack(int level);
                void BeginResync();
                void Commence();
                void ConsumeHiddenToken(Antlr.Runtime.IToken t);
                void ConsumeNode(object t);
                void ConsumeToken(Antlr.Runtime.IToken t);
                void CreateNode(object t);
                void CreateNode(object node, Antlr.Runtime.IToken token);
                void EndBacktrack(int level, bool successful);
                void EndResync();
                void EnterAlt(int alt);
                void EnterDecision(int decisionNumber, bool couldBacktrack);
                void EnterRule(string grammarFileName, string ruleName);
                void EnterSubRule(int decisionNumber);
                void ErrorNode(object t);
                void ExitDecision(int decisionNumber);
                void ExitRule(string grammarFileName, string ruleName);
                void ExitSubRule(int decisionNumber);
                void Initialize();
                void LT(int i, object t);
                void LT(int i, Antlr.Runtime.IToken t);
                void Location(int line, int pos);
                void Mark(int marker);
                void NilNode(object t);
                void RecognitionException(Antlr.Runtime.RecognitionException e);
                void Rewind(int marker);
                void Rewind();
                void SemanticPredicate(bool result, string predicate);
                void SetTokenBoundaries(object t, int tokenStartIndex, int tokenStopIndex);
                void Terminate();
            }

        }
        namespace Misc
        {
            // Generated from `Antlr.Runtime.Misc.Action` in `Antlr3.Runtime, Version=3.5.0.2, Culture=neutral, PublicKeyToken=eb42632606e9261f`
            public delegate void Action();

            // Generated from `Antlr.Runtime.Misc.FastQueue<>` in `Antlr3.Runtime, Version=3.5.0.2, Culture=neutral, PublicKeyToken=eb42632606e9261f`
            public class FastQueue<T>
            {
                public virtual void Clear() => throw null;
                public virtual int Count { get => throw null; }
                public virtual T Dequeue() => throw null;
                public virtual void Enqueue(T o) => throw null;
                public FastQueue() => throw null;
                public virtual T this[int i] { get => throw null; }
                public virtual T Peek() => throw null;
                public virtual int Range { get => throw null; set => throw null; }
                public override string ToString() => throw null;
            }

            // Generated from `Antlr.Runtime.Misc.Func<,>` in `Antlr3.Runtime, Version=3.5.0.2, Culture=neutral, PublicKeyToken=eb42632606e9261f`
            public delegate TResult Func<T, TResult>(T arg);

            // Generated from `Antlr.Runtime.Misc.Func<>` in `Antlr3.Runtime, Version=3.5.0.2, Culture=neutral, PublicKeyToken=eb42632606e9261f`
            public delegate TResult Func<TResult>();

            // Generated from `Antlr.Runtime.Misc.ListStack<>` in `Antlr3.Runtime, Version=3.5.0.2, Culture=neutral, PublicKeyToken=eb42632606e9261f`
            public class ListStack<T> : System.Collections.Generic.List<T>
            {
                public ListStack() => throw null;
                public T Peek(int depth) => throw null;
                public T Peek() => throw null;
                public T Pop() => throw null;
                public void Push(T item) => throw null;
                public bool TryPeek(out T item) => throw null;
                public bool TryPeek(int depth, out T item) => throw null;
                public bool TryPop(out T item) => throw null;
            }

            // Generated from `Antlr.Runtime.Misc.LookaheadStream<>` in `Antlr3.Runtime, Version=3.5.0.2, Culture=neutral, PublicKeyToken=eb42632606e9261f`
            public abstract class LookaheadStream<T> : Antlr.Runtime.Misc.FastQueue<T> where T : class
            {
                public virtual void Consume() => throw null;
                public override int Count { get => throw null; }
                public override T Dequeue() => throw null;
                public T EndOfFile { get => throw null; set => throw null; }
                public virtual void Fill(int n) => throw null;
                public virtual int Index { get => throw null; }
                public abstract bool IsEndOfFile(T o);
                protected virtual T LB(int k) => throw null;
                public virtual T LT(int k) => throw null;
                protected LookaheadStream() => throw null;
                public virtual int Mark() => throw null;
                public abstract T NextElement();
                public T PreviousElement { get => throw null; }
                public virtual void Release(int marker) => throw null;
                public virtual void Reset() => throw null;
                public virtual void Rewind(int marker) => throw null;
                public virtual void Rewind() => throw null;
                public virtual void Seek(int index) => throw null;
                protected virtual void SyncAhead(int need) => throw null;
            }

        }
        namespace Tree
        {
            // Generated from `Antlr.Runtime.Tree.AstTreeRuleReturnScope<,>` in `Antlr3.Runtime, Version=3.5.0.2, Culture=neutral, PublicKeyToken=eb42632606e9261f`
            public class AstTreeRuleReturnScope<TOutputTree, TInputTree> : Antlr.Runtime.Tree.TreeRuleReturnScope<TInputTree>, Antlr.Runtime.IRuleReturnScope, Antlr.Runtime.IAstRuleReturnScope<TOutputTree>, Antlr.Runtime.IAstRuleReturnScope
            {
                public AstTreeRuleReturnScope() => throw null;
                public TOutputTree Tree { get => throw null; set => throw null; }
                object Antlr.Runtime.IAstRuleReturnScope.Tree { get => throw null; }
            }

            // Generated from `Antlr.Runtime.Tree.BaseTree` in `Antlr3.Runtime, Version=3.5.0.2, Culture=neutral, PublicKeyToken=eb42632606e9261f`
            public abstract class BaseTree : Antlr.Runtime.Tree.ITree
            {
                public virtual void AddChild(Antlr.Runtime.Tree.ITree t) => throw null;
                public virtual void AddChildren(System.Collections.Generic.IEnumerable<Antlr.Runtime.Tree.ITree> kids) => throw null;
                public BaseTree(Antlr.Runtime.Tree.ITree node) => throw null;
                public BaseTree() => throw null;
                public virtual int CharPositionInLine { get => throw null; set => throw null; }
                public virtual int ChildCount { get => throw null; }
                public virtual int ChildIndex { get => throw null; set => throw null; }
                public virtual System.Collections.Generic.IList<Antlr.Runtime.Tree.ITree> Children { get => throw null; set => throw null; }
                protected virtual System.Collections.Generic.IList<Antlr.Runtime.Tree.ITree> CreateChildrenList() => throw null;
                public virtual object DeleteChild(int i) => throw null;
                public abstract Antlr.Runtime.Tree.ITree DupNode();
                public virtual void FreshenParentAndChildIndexes(int offset) => throw null;
                public virtual void FreshenParentAndChildIndexes() => throw null;
                public virtual void FreshenParentAndChildIndexesDeeply(int offset) => throw null;
                public virtual void FreshenParentAndChildIndexesDeeply() => throw null;
                public virtual Antlr.Runtime.Tree.ITree GetAncestor(int ttype) => throw null;
                public virtual System.Collections.Generic.IList<Antlr.Runtime.Tree.ITree> GetAncestors() => throw null;
                public virtual Antlr.Runtime.Tree.ITree GetChild(int i) => throw null;
                public virtual Antlr.Runtime.Tree.ITree GetFirstChildWithType(int type) => throw null;
                public virtual bool HasAncestor(int ttype) => throw null;
                public virtual void InsertChild(int i, Antlr.Runtime.Tree.ITree t) => throw null;
                public virtual bool IsNil { get => throw null; }
                public virtual int Line { get => throw null; set => throw null; }
                public virtual Antlr.Runtime.Tree.ITree Parent { get => throw null; set => throw null; }
                public virtual void ReplaceChildren(int startChildIndex, int stopChildIndex, object t) => throw null;
                public virtual void SanityCheckParentAndChildIndexes(Antlr.Runtime.Tree.ITree parent, int i) => throw null;
                public virtual void SanityCheckParentAndChildIndexes() => throw null;
                public virtual void SetChild(int i, Antlr.Runtime.Tree.ITree t) => throw null;
                public abstract string Text { get; set; }
                public abstract override string ToString();
                public virtual string ToStringTree() => throw null;
                public abstract int TokenStartIndex { get; set; }
                public abstract int TokenStopIndex { get; set; }
                public abstract int Type { get; set; }
            }

            // Generated from `Antlr.Runtime.Tree.BaseTreeAdaptor` in `Antlr3.Runtime, Version=3.5.0.2, Culture=neutral, PublicKeyToken=eb42632606e9261f`
            public abstract class BaseTreeAdaptor : Antlr.Runtime.Tree.ITreeAdaptor
            {
                public virtual void AddChild(object t, object child) => throw null;
                protected BaseTreeAdaptor() => throw null;
                public virtual object BecomeRoot(object newRoot, object oldRoot) => throw null;
                public virtual object BecomeRoot(Antlr.Runtime.IToken newRoot, object oldRoot) => throw null;
                public virtual object Create(int tokenType, string text) => throw null;
                public virtual object Create(int tokenType, Antlr.Runtime.IToken fromToken, string text) => throw null;
                public virtual object Create(int tokenType, Antlr.Runtime.IToken fromToken) => throw null;
                public virtual object Create(Antlr.Runtime.IToken fromToken, string text) => throw null;
                public abstract object Create(Antlr.Runtime.IToken payload);
                public abstract Antlr.Runtime.IToken CreateToken(int tokenType, string text);
                public abstract Antlr.Runtime.IToken CreateToken(Antlr.Runtime.IToken fromToken);
                public virtual object DeleteChild(object t, int i) => throw null;
                public virtual object DupNode(object treeNode, string text) => throw null;
                public virtual object DupNode(object treeNode) => throw null;
                public virtual object DupNode(int type, object treeNode, string text) => throw null;
                public virtual object DupNode(int type, object treeNode) => throw null;
                public virtual object DupTree(object tree) => throw null;
                public virtual object DupTree(object t, object parent) => throw null;
                public virtual object ErrorNode(Antlr.Runtime.ITokenStream input, Antlr.Runtime.IToken start, Antlr.Runtime.IToken stop, Antlr.Runtime.RecognitionException e) => throw null;
                public virtual object GetChild(object t, int i) => throw null;
                public virtual int GetChildCount(object t) => throw null;
                public virtual int GetChildIndex(object t) => throw null;
                public virtual object GetParent(object t) => throw null;
                public virtual string GetText(object t) => throw null;
                public abstract Antlr.Runtime.IToken GetToken(object t);
                public virtual int GetTokenStartIndex(object t) => throw null;
                public virtual int GetTokenStopIndex(object t) => throw null;
                protected virtual Antlr.Runtime.Tree.ITree GetTree(object t) => throw null;
                public virtual int GetType(object t) => throw null;
                public virtual int GetUniqueID(object node) => throw null;
                public virtual bool IsNil(object tree) => throw null;
                public virtual object Nil() => throw null;
                public virtual void ReplaceChildren(object parent, int startChildIndex, int stopChildIndex, object t) => throw null;
                public virtual object RulePostProcessing(object root) => throw null;
                public virtual void SetChild(object t, int i, object child) => throw null;
                public virtual void SetChildIndex(object t, int index) => throw null;
                public virtual void SetParent(object t, object parent) => throw null;
                public virtual void SetText(object t, string text) => throw null;
                public virtual void SetTokenBoundaries(object t, Antlr.Runtime.IToken startToken, Antlr.Runtime.IToken stopToken) => throw null;
                public virtual void SetType(object t, int type) => throw null;
                protected System.Collections.Generic.IDictionary<object, int> treeToUniqueIDMap;
                protected int uniqueNodeID;
            }

            // Generated from `Antlr.Runtime.Tree.BufferedTreeNodeStream` in `Antlr3.Runtime, Version=3.5.0.2, Culture=neutral, PublicKeyToken=eb42632606e9261f`
            public class BufferedTreeNodeStream : Antlr.Runtime.Tree.ITreeNodeStream, Antlr.Runtime.ITokenStreamInformation, Antlr.Runtime.IIntStream
            {
                protected virtual void AddNavigationNode(int ttype) => throw null;
                public BufferedTreeNodeStream(object tree) => throw null;
                public BufferedTreeNodeStream(Antlr.Runtime.Tree.ITreeAdaptor adaptor, object tree, int initialBufferSize) => throw null;
                public BufferedTreeNodeStream(Antlr.Runtime.Tree.ITreeAdaptor adaptor, object tree) => throw null;
                public virtual void Consume() => throw null;
                public virtual int Count { get => throw null; }
                public const int DEFAULT_INITIAL_BUFFER_SIZE = default;
                public virtual void FillBuffer(object t) => throw null;
                protected virtual void FillBuffer() => throw null;
                public virtual object GetCurrentSymbol() => throw null;
                protected virtual int GetNodeIndex(object node) => throw null;
                public const int INITIAL_CALL_STACK_SIZE = default;
                public virtual int Index { get => throw null; }
                public virtual object this[int i] { get => throw null; }
                public virtual System.Collections.Generic.IEnumerator<object> Iterator() => throw null;
                public virtual int LA(int i) => throw null;
                protected virtual object LB(int k) => throw null;
                public virtual object LT(int k) => throw null;
                public virtual Antlr.Runtime.IToken LastRealToken { get => throw null; }
                public virtual Antlr.Runtime.IToken LastToken { get => throw null; }
                public virtual int Mark() => throw null;
                public virtual int MaxLookBehind { get => throw null; }
                public virtual int Pop() => throw null;
                public virtual void Push(int index) => throw null;
                public virtual void Release(int marker) => throw null;
                public virtual void ReplaceChildren(object parent, int startChildIndex, int stopChildIndex, object t) => throw null;
                public virtual void Reset() => throw null;
                public virtual void Rewind(int marker) => throw null;
                public virtual void Rewind() => throw null;
                public virtual void Seek(int index) => throw null;
                public virtual string SourceName { get => throw null; }
                // Generated from `Antlr.Runtime.Tree.BufferedTreeNodeStream+StreamIterator` in `Antlr3.Runtime, Version=3.5.0.2, Culture=neutral, PublicKeyToken=eb42632606e9261f`
                protected class StreamIterator : System.IDisposable, System.Collections.IEnumerator, System.Collections.Generic.IEnumerator<object>
                {
                    public object Current { get => throw null; }
                    public void Dispose() => throw null;
                    public bool MoveNext() => throw null;
                    public void Reset() => throw null;
                    public StreamIterator(Antlr.Runtime.Tree.BufferedTreeNodeStream outer) => throw null;
                }


                public virtual string ToString(object start, object stop) => throw null;
                public virtual string ToTokenString(int start, int stop) => throw null;
                public virtual string ToTokenTypeString() => throw null;
                public virtual Antlr.Runtime.ITokenStream TokenStream { get => throw null; set => throw null; }
                public virtual Antlr.Runtime.Tree.ITreeAdaptor TreeAdaptor { get => throw null; set => throw null; }
                public virtual object TreeSource { get => throw null; }
                public virtual bool UniqueNavigationNodes { get => throw null; set => throw null; }
                protected System.Collections.Generic.Stack<int> calls;
                protected object down;
                protected object eof;
                protected int lastMarker;
                protected System.Collections.IList nodes;
                protected int p;
                protected object root;
                protected Antlr.Runtime.ITokenStream tokens;
                protected object up;
            }

            // Generated from `Antlr.Runtime.Tree.CommonErrorNode` in `Antlr3.Runtime, Version=3.5.0.2, Culture=neutral, PublicKeyToken=eb42632606e9261f`
            public class CommonErrorNode : Antlr.Runtime.Tree.CommonTree
            {
                public CommonErrorNode(Antlr.Runtime.ITokenStream input, Antlr.Runtime.IToken start, Antlr.Runtime.IToken stop, Antlr.Runtime.RecognitionException e) => throw null;
                public override bool IsNil { get => throw null; }
                public override string Text { get => throw null; set => throw null; }
                public override string ToString() => throw null;
                public override int Type { get => throw null; set => throw null; }
                public Antlr.Runtime.IIntStream input;
                public Antlr.Runtime.IToken start;
                public Antlr.Runtime.IToken stop;
                public Antlr.Runtime.RecognitionException trappedException;
            }

            // Generated from `Antlr.Runtime.Tree.CommonTree` in `Antlr3.Runtime, Version=3.5.0.2, Culture=neutral, PublicKeyToken=eb42632606e9261f`
            public class CommonTree : Antlr.Runtime.Tree.BaseTree
            {
                public override int CharPositionInLine { get => throw null; set => throw null; }
                public override int ChildIndex { get => throw null; set => throw null; }
                public CommonTree(Antlr.Runtime.Tree.CommonTree node) => throw null;
                public CommonTree(Antlr.Runtime.IToken t) => throw null;
                public CommonTree() => throw null;
                public override Antlr.Runtime.Tree.ITree DupNode() => throw null;
                public override bool IsNil { get => throw null; }
                public override int Line { get => throw null; set => throw null; }
                public override Antlr.Runtime.Tree.ITree Parent { get => throw null; set => throw null; }
                public virtual void SetUnknownTokenBoundaries() => throw null;
                public override string Text { get => throw null; set => throw null; }
                public override string ToString() => throw null;
                public Antlr.Runtime.IToken Token { get => throw null; set => throw null; }
                public override int TokenStartIndex { get => throw null; set => throw null; }
                public override int TokenStopIndex { get => throw null; set => throw null; }
                public override int Type { get => throw null; set => throw null; }
                protected int startIndex;
                protected int stopIndex;
            }

            // Generated from `Antlr.Runtime.Tree.CommonTreeAdaptor` in `Antlr3.Runtime, Version=3.5.0.2, Culture=neutral, PublicKeyToken=eb42632606e9261f`
            public class CommonTreeAdaptor : Antlr.Runtime.Tree.BaseTreeAdaptor
            {
                public CommonTreeAdaptor() => throw null;
                public override object Create(Antlr.Runtime.IToken payload) => throw null;
                public override Antlr.Runtime.IToken CreateToken(int tokenType, string text) => throw null;
                public override Antlr.Runtime.IToken CreateToken(Antlr.Runtime.IToken fromToken) => throw null;
                public override Antlr.Runtime.IToken GetToken(object t) => throw null;
            }

            // Generated from `Antlr.Runtime.Tree.CommonTreeNodeStream` in `Antlr3.Runtime, Version=3.5.0.2, Culture=neutral, PublicKeyToken=eb42632606e9261f`
            public class CommonTreeNodeStream : Antlr.Runtime.Misc.LookaheadStream<object>, Antlr.Runtime.Tree.ITreeNodeStream, Antlr.Runtime.Tree.IPositionTrackingStream, Antlr.Runtime.IIntStream
            {
                public CommonTreeNodeStream(object tree) => throw null;
                public CommonTreeNodeStream(Antlr.Runtime.Tree.ITreeAdaptor adaptor, object tree) => throw null;
                public const int DEFAULT_INITIAL_BUFFER_SIZE = default;
                public override object Dequeue() => throw null;
                public object GetKnownPositionElement(bool allowApproximateLocation) => throw null;
                public bool HasPositionInformation(object node) => throw null;
                public const int INITIAL_CALL_STACK_SIZE = default;
                public override bool IsEndOfFile(object o) => throw null;
                public virtual int LA(int i) => throw null;
                public override object NextElement() => throw null;
                public virtual int Pop() => throw null;
                public virtual void Push(int index) => throw null;
                public virtual void ReplaceChildren(object parent, int startChildIndex, int stopChildIndex, object t) => throw null;
                public override void Reset() => throw null;
                public virtual string SourceName { get => throw null; }
                public virtual string ToString(object start, object stop) => throw null;
                public virtual string ToTokenTypeString() => throw null;
                public virtual Antlr.Runtime.ITokenStream TokenStream { get => throw null; set => throw null; }
                public virtual Antlr.Runtime.Tree.ITreeAdaptor TreeAdaptor { get => throw null; set => throw null; }
                public virtual object TreeSource { get => throw null; }
                public virtual bool UniqueNavigationNodes { get => throw null; set => throw null; }
                protected Antlr.Runtime.ITokenStream tokens;
            }

            // Generated from `Antlr.Runtime.Tree.DotTreeGenerator` in `Antlr3.Runtime, Version=3.5.0.2, Culture=neutral, PublicKeyToken=eb42632606e9261f`
            public class DotTreeGenerator
            {
                protected virtual System.Collections.Generic.IEnumerable<string> DefineEdges(object tree, Antlr.Runtime.Tree.ITreeAdaptor adaptor) => throw null;
                protected virtual System.Collections.Generic.IEnumerable<string> DefineNodes(object tree, Antlr.Runtime.Tree.ITreeAdaptor adaptor) => throw null;
                public DotTreeGenerator() => throw null;
                protected virtual string FixString(string text) => throw null;
                protected virtual int GetNodeNumber(object t) => throw null;
                protected virtual string GetNodeText(Antlr.Runtime.Tree.ITreeAdaptor adaptor, object t) => throw null;
                public virtual string ToDot(object tree, Antlr.Runtime.Tree.ITreeAdaptor adaptor) => throw null;
                public virtual string ToDot(Antlr.Runtime.Tree.ITree tree) => throw null;
            }

            // Generated from `Antlr.Runtime.Tree.IPositionTrackingStream` in `Antlr3.Runtime, Version=3.5.0.2, Culture=neutral, PublicKeyToken=eb42632606e9261f`
            public interface IPositionTrackingStream
            {
                object GetKnownPositionElement(bool allowApproximateLocation);
                bool HasPositionInformation(object element);
            }

            // Generated from `Antlr.Runtime.Tree.ITree` in `Antlr3.Runtime, Version=3.5.0.2, Culture=neutral, PublicKeyToken=eb42632606e9261f`
            public interface ITree
            {
                void AddChild(Antlr.Runtime.Tree.ITree t);
                int CharPositionInLine { get; }
                int ChildCount { get; }
                int ChildIndex { get; set; }
                object DeleteChild(int i);
                Antlr.Runtime.Tree.ITree DupNode();
                void FreshenParentAndChildIndexes();
                Antlr.Runtime.Tree.ITree GetAncestor(int ttype);
                System.Collections.Generic.IList<Antlr.Runtime.Tree.ITree> GetAncestors();
                Antlr.Runtime.Tree.ITree GetChild(int i);
                bool HasAncestor(int ttype);
                bool IsNil { get; }
                int Line { get; }
                Antlr.Runtime.Tree.ITree Parent { get; set; }
                void ReplaceChildren(int startChildIndex, int stopChildIndex, object t);
                void SetChild(int i, Antlr.Runtime.Tree.ITree t);
                string Text { get; }
                string ToString();
                string ToStringTree();
                int TokenStartIndex { get; set; }
                int TokenStopIndex { get; set; }
                int Type { get; }
            }

            // Generated from `Antlr.Runtime.Tree.ITreeAdaptor` in `Antlr3.Runtime, Version=3.5.0.2, Culture=neutral, PublicKeyToken=eb42632606e9261f`
            public interface ITreeAdaptor
            {
                void AddChild(object t, object child);
                object BecomeRoot(object newRoot, object oldRoot);
                object BecomeRoot(Antlr.Runtime.IToken newRoot, object oldRoot);
                object Create(int tokenType, string text);
                object Create(int tokenType, Antlr.Runtime.IToken fromToken, string text);
                object Create(int tokenType, Antlr.Runtime.IToken fromToken);
                object Create(Antlr.Runtime.IToken payload);
                object Create(Antlr.Runtime.IToken fromToken, string text);
                object DeleteChild(object t, int i);
                object DupNode(object treeNode, string text);
                object DupNode(object treeNode);
                object DupNode(int type, object treeNode, string text);
                object DupNode(int type, object treeNode);
                object DupTree(object tree);
                object ErrorNode(Antlr.Runtime.ITokenStream input, Antlr.Runtime.IToken start, Antlr.Runtime.IToken stop, Antlr.Runtime.RecognitionException e);
                object GetChild(object t, int i);
                int GetChildCount(object t);
                int GetChildIndex(object t);
                object GetParent(object t);
                string GetText(object t);
                Antlr.Runtime.IToken GetToken(object t);
                int GetTokenStartIndex(object t);
                int GetTokenStopIndex(object t);
                int GetType(object t);
                int GetUniqueID(object node);
                bool IsNil(object tree);
                object Nil();
                void ReplaceChildren(object parent, int startChildIndex, int stopChildIndex, object t);
                object RulePostProcessing(object root);
                void SetChild(object t, int i, object child);
                void SetChildIndex(object t, int index);
                void SetParent(object t, object parent);
                void SetText(object t, string text);
                void SetTokenBoundaries(object t, Antlr.Runtime.IToken startToken, Antlr.Runtime.IToken stopToken);
                void SetType(object t, int type);
            }

            // Generated from `Antlr.Runtime.Tree.ITreeNodeStream` in `Antlr3.Runtime, Version=3.5.0.2, Culture=neutral, PublicKeyToken=eb42632606e9261f`
            public interface ITreeNodeStream : Antlr.Runtime.IIntStream
            {
                object this[int i] { get; }
                object LT(int k);
                void ReplaceChildren(object parent, int startChildIndex, int stopChildIndex, object t);
                string ToString(object start, object stop);
                Antlr.Runtime.ITokenStream TokenStream { get; }
                Antlr.Runtime.Tree.ITreeAdaptor TreeAdaptor { get; }
                object TreeSource { get; }
                bool UniqueNavigationNodes { get; set; }
            }

            // Generated from `Antlr.Runtime.Tree.ITreeVisitorAction` in `Antlr3.Runtime, Version=3.5.0.2, Culture=neutral, PublicKeyToken=eb42632606e9261f`
            public interface ITreeVisitorAction
            {
                object Post(object t);
                object Pre(object t);
            }

            // Generated from `Antlr.Runtime.Tree.ParseTree` in `Antlr3.Runtime, Version=3.5.0.2, Culture=neutral, PublicKeyToken=eb42632606e9261f`
            public class ParseTree : Antlr.Runtime.Tree.BaseTree
            {
                public override Antlr.Runtime.Tree.ITree DupNode() => throw null;
                public ParseTree(object label) => throw null;
                public override string Text { get => throw null; set => throw null; }
                public virtual string ToInputString() => throw null;
                public override string ToString() => throw null;
                protected virtual void ToStringLeaves(System.Text.StringBuilder buf) => throw null;
                public virtual string ToStringWithHiddenTokens() => throw null;
                public override int TokenStartIndex { get => throw null; set => throw null; }
                public override int TokenStopIndex { get => throw null; set => throw null; }
                public override int Type { get => throw null; set => throw null; }
                public System.Collections.Generic.List<Antlr.Runtime.IToken> hiddenTokens;
                public object payload;
            }

            // Generated from `Antlr.Runtime.Tree.RewriteCardinalityException` in `Antlr3.Runtime, Version=3.5.0.2, Culture=neutral, PublicKeyToken=eb42632606e9261f`
            public class RewriteCardinalityException : System.Exception
            {
                public RewriteCardinalityException(string message, string elementDescription, System.Exception innerException) => throw null;
                public RewriteCardinalityException(string message, string elementDescription) => throw null;
                public RewriteCardinalityException(string elementDescription, System.Exception innerException) => throw null;
                public RewriteCardinalityException(string elementDescription) => throw null;
                public RewriteCardinalityException() => throw null;
            }

            // Generated from `Antlr.Runtime.Tree.RewriteEarlyExitException` in `Antlr3.Runtime, Version=3.5.0.2, Culture=neutral, PublicKeyToken=eb42632606e9261f`
            public class RewriteEarlyExitException : Antlr.Runtime.Tree.RewriteCardinalityException
            {
                public RewriteEarlyExitException(string message, string elementDescription, System.Exception innerException) => throw null;
                public RewriteEarlyExitException(string message, string elementDescription) => throw null;
                public RewriteEarlyExitException(string elementDescription, System.Exception innerException) => throw null;
                public RewriteEarlyExitException(string elementDescription) => throw null;
                public RewriteEarlyExitException() => throw null;
            }

            // Generated from `Antlr.Runtime.Tree.RewriteEmptyStreamException` in `Antlr3.Runtime, Version=3.5.0.2, Culture=neutral, PublicKeyToken=eb42632606e9261f`
            public class RewriteEmptyStreamException : Antlr.Runtime.Tree.RewriteCardinalityException
            {
                public RewriteEmptyStreamException(string message, string elementDescription, System.Exception innerException) => throw null;
                public RewriteEmptyStreamException(string message, string elementDescription) => throw null;
                public RewriteEmptyStreamException(string elementDescription, System.Exception innerException) => throw null;
                public RewriteEmptyStreamException(string elementDescription) => throw null;
                public RewriteEmptyStreamException() => throw null;
            }

            // Generated from `Antlr.Runtime.Tree.RewriteRuleElementStream` in `Antlr3.Runtime, Version=3.5.0.2, Culture=neutral, PublicKeyToken=eb42632606e9261f`
            public abstract class RewriteRuleElementStream
            {
                public virtual void Add(object el) => throw null;
                public virtual int Count { get => throw null; }
                public virtual string Description { get => throw null; }
                protected abstract object Dup(object el);
                public virtual bool HasNext { get => throw null; }
                protected virtual object NextCore() => throw null;
                public virtual object NextTree() => throw null;
                public virtual void Reset() => throw null;
                public RewriteRuleElementStream(Antlr.Runtime.Tree.ITreeAdaptor adaptor, string elementDescription, object oneElement) => throw null;
                public RewriteRuleElementStream(Antlr.Runtime.Tree.ITreeAdaptor adaptor, string elementDescription, System.Collections.IList elements) => throw null;
                public RewriteRuleElementStream(Antlr.Runtime.Tree.ITreeAdaptor adaptor, string elementDescription) => throw null;
                protected virtual object ToTree(object el) => throw null;
                protected Antlr.Runtime.Tree.ITreeAdaptor adaptor;
                protected int cursor;
                protected bool dirty;
                protected string elementDescription;
                protected System.Collections.IList elements;
                protected object singleElement;
            }

            // Generated from `Antlr.Runtime.Tree.RewriteRuleNodeStream` in `Antlr3.Runtime, Version=3.5.0.2, Culture=neutral, PublicKeyToken=eb42632606e9261f`
            public class RewriteRuleNodeStream : Antlr.Runtime.Tree.RewriteRuleElementStream
            {
                protected override object Dup(object el) => throw null;
                public virtual object NextNode() => throw null;
                public RewriteRuleNodeStream(Antlr.Runtime.Tree.ITreeAdaptor adaptor, string elementDescription, object oneElement) : base(default(Antlr.Runtime.Tree.ITreeAdaptor), default(string)) => throw null;
                public RewriteRuleNodeStream(Antlr.Runtime.Tree.ITreeAdaptor adaptor, string elementDescription, System.Collections.IList elements) : base(default(Antlr.Runtime.Tree.ITreeAdaptor), default(string)) => throw null;
                public RewriteRuleNodeStream(Antlr.Runtime.Tree.ITreeAdaptor adaptor, string elementDescription) : base(default(Antlr.Runtime.Tree.ITreeAdaptor), default(string)) => throw null;
                protected override object ToTree(object el) => throw null;
            }

            // Generated from `Antlr.Runtime.Tree.RewriteRuleSubtreeStream` in `Antlr3.Runtime, Version=3.5.0.2, Culture=neutral, PublicKeyToken=eb42632606e9261f`
            public class RewriteRuleSubtreeStream : Antlr.Runtime.Tree.RewriteRuleElementStream
            {
                protected override object Dup(object el) => throw null;
                public virtual object NextNode() => throw null;
                public RewriteRuleSubtreeStream(Antlr.Runtime.Tree.ITreeAdaptor adaptor, string elementDescription, object oneElement) : base(default(Antlr.Runtime.Tree.ITreeAdaptor), default(string)) => throw null;
                public RewriteRuleSubtreeStream(Antlr.Runtime.Tree.ITreeAdaptor adaptor, string elementDescription, System.Collections.IList elements) : base(default(Antlr.Runtime.Tree.ITreeAdaptor), default(string)) => throw null;
                public RewriteRuleSubtreeStream(Antlr.Runtime.Tree.ITreeAdaptor adaptor, string elementDescription) : base(default(Antlr.Runtime.Tree.ITreeAdaptor), default(string)) => throw null;
            }

            // Generated from `Antlr.Runtime.Tree.RewriteRuleTokenStream` in `Antlr3.Runtime, Version=3.5.0.2, Culture=neutral, PublicKeyToken=eb42632606e9261f`
            public class RewriteRuleTokenStream : Antlr.Runtime.Tree.RewriteRuleElementStream
            {
                protected override object Dup(object el) => throw null;
                public virtual object NextNode() => throw null;
                public virtual Antlr.Runtime.IToken NextToken() => throw null;
                public RewriteRuleTokenStream(Antlr.Runtime.Tree.ITreeAdaptor adaptor, string elementDescription, object oneElement) : base(default(Antlr.Runtime.Tree.ITreeAdaptor), default(string)) => throw null;
                public RewriteRuleTokenStream(Antlr.Runtime.Tree.ITreeAdaptor adaptor, string elementDescription, System.Collections.IList elements) : base(default(Antlr.Runtime.Tree.ITreeAdaptor), default(string)) => throw null;
                public RewriteRuleTokenStream(Antlr.Runtime.Tree.ITreeAdaptor adaptor, string elementDescription) : base(default(Antlr.Runtime.Tree.ITreeAdaptor), default(string)) => throw null;
                protected override object ToTree(object el) => throw null;
            }

            // Generated from `Antlr.Runtime.Tree.TemplateTreeRuleReturnScope<,>` in `Antlr3.Runtime, Version=3.5.0.2, Culture=neutral, PublicKeyToken=eb42632606e9261f`
            public class TemplateTreeRuleReturnScope<TTemplate, TTree> : Antlr.Runtime.Tree.TreeRuleReturnScope<TTree>, Antlr.Runtime.ITemplateRuleReturnScope<TTemplate>, Antlr.Runtime.ITemplateRuleReturnScope
            {
                public TTemplate Template { get => throw null; set => throw null; }
                object Antlr.Runtime.ITemplateRuleReturnScope.Template { get => throw null; }
                public TemplateTreeRuleReturnScope() => throw null;
            }

            // Generated from `Antlr.Runtime.Tree.TreeFilter` in `Antlr3.Runtime, Version=3.5.0.2, Culture=neutral, PublicKeyToken=eb42632606e9261f`
            public class TreeFilter : Antlr.Runtime.Tree.TreeParser
            {
                public virtual void ApplyOnce(object t, Antlr.Runtime.Misc.Action whichRule) => throw null;
                protected virtual void Bottomup() => throw null;
                public virtual void Downup(object t) => throw null;
                protected virtual void Topdown() => throw null;
                public TreeFilter(Antlr.Runtime.Tree.ITreeNodeStream input, Antlr.Runtime.RecognizerSharedState state) : base(default(Antlr.Runtime.Tree.ITreeNodeStream)) => throw null;
                public TreeFilter(Antlr.Runtime.Tree.ITreeNodeStream input) : base(default(Antlr.Runtime.Tree.ITreeNodeStream)) => throw null;
                protected Antlr.Runtime.Tree.ITreeAdaptor originalAdaptor;
                protected Antlr.Runtime.ITokenStream originalTokenStream;
            }

            // Generated from `Antlr.Runtime.Tree.TreeIterator` in `Antlr3.Runtime, Version=3.5.0.2, Culture=neutral, PublicKeyToken=eb42632606e9261f`
            public class TreeIterator : System.IDisposable, System.Collections.IEnumerator, System.Collections.Generic.IEnumerator<object>
            {
                public object Current { get => throw null; set => throw null; }
                public void Dispose() => throw null;
                public bool MoveNext() => throw null;
                public void Reset() => throw null;
                public TreeIterator(Antlr.Runtime.Tree.ITreeAdaptor adaptor, object tree) => throw null;
                public TreeIterator(Antlr.Runtime.Tree.CommonTree tree) => throw null;
                protected Antlr.Runtime.Tree.ITreeAdaptor adaptor;
                public object down;
                public object eof;
                protected bool firstTime;
                protected System.Collections.Generic.Queue<object> nodes;
                protected object root;
                protected object tree;
                public object up;
            }

            // Generated from `Antlr.Runtime.Tree.TreeParser` in `Antlr3.Runtime, Version=3.5.0.2, Culture=neutral, PublicKeyToken=eb42632606e9261f`
            public class TreeParser : Antlr.Runtime.BaseRecognizer
            {
                public const int DOWN = default;
                protected override object GetCurrentInputSymbol(Antlr.Runtime.IIntStream input) => throw null;
                public override string GetErrorHeader(Antlr.Runtime.RecognitionException e) => throw null;
                public override string GetErrorMessage(Antlr.Runtime.RecognitionException e, string[] tokenNames) => throw null;
                protected override object GetMissingSymbol(Antlr.Runtime.IIntStream input, Antlr.Runtime.RecognitionException e, int expectedTokenType, Antlr.Runtime.BitSet follow) => throw null;
                public virtual Antlr.Runtime.Tree.ITreeNodeStream GetTreeNodeStream() => throw null;
                public override void MatchAny(Antlr.Runtime.IIntStream ignore) => throw null;
                protected override object RecoverFromMismatchedToken(Antlr.Runtime.IIntStream input, int ttype, Antlr.Runtime.BitSet follow) => throw null;
                public override void Reset() => throw null;
                public virtual void SetTreeNodeStream(Antlr.Runtime.Tree.ITreeNodeStream input) => throw null;
                public override string SourceName { get => throw null; }
                public virtual void TraceIn(string ruleName, int ruleIndex) => throw null;
                public virtual void TraceOut(string ruleName, int ruleIndex) => throw null;
                public TreeParser(Antlr.Runtime.Tree.ITreeNodeStream input, Antlr.Runtime.RecognizerSharedState state) => throw null;
                public TreeParser(Antlr.Runtime.Tree.ITreeNodeStream input) => throw null;
                public const int UP = default;
                protected Antlr.Runtime.Tree.ITreeNodeStream input;
            }

            // Generated from `Antlr.Runtime.Tree.TreePatternLexer` in `Antlr3.Runtime, Version=3.5.0.2, Culture=neutral, PublicKeyToken=eb42632606e9261f`
            public class TreePatternLexer
            {
                public const int Arg = default;
                public const int Begin = default;
                public const int Colon = default;
                protected virtual void Consume() => throw null;
                public const int Dot = default;
                public const int End = default;
                public const int Id = default;
                public virtual int NextToken() => throw null;
                public const int Percent = default;
                public TreePatternLexer(string pattern) => throw null;
                protected int c;
                public bool error;
                protected int n;
                protected int p;
                protected string pattern;
                public System.Text.StringBuilder sval;
            }

            // Generated from `Antlr.Runtime.Tree.TreePatternParser` in `Antlr3.Runtime, Version=3.5.0.2, Culture=neutral, PublicKeyToken=eb42632606e9261f`
            public class TreePatternParser
            {
                public virtual object ParseNode() => throw null;
                public virtual object ParseTree() => throw null;
                public virtual object Pattern() => throw null;
                public TreePatternParser(Antlr.Runtime.Tree.TreePatternLexer tokenizer, Antlr.Runtime.Tree.TreeWizard wizard, Antlr.Runtime.Tree.ITreeAdaptor adaptor) => throw null;
                protected Antlr.Runtime.Tree.ITreeAdaptor adaptor;
                protected Antlr.Runtime.Tree.TreePatternLexer tokenizer;
                protected int ttype;
                protected Antlr.Runtime.Tree.TreeWizard wizard;
            }

            // Generated from `Antlr.Runtime.Tree.TreeRewriter` in `Antlr3.Runtime, Version=3.5.0.2, Culture=neutral, PublicKeyToken=eb42632606e9261f`
            public class TreeRewriter : Antlr.Runtime.Tree.TreeParser
            {
                public virtual object ApplyOnce(object t, Antlr.Runtime.Misc.Func<Antlr.Runtime.IAstRuleReturnScope> whichRule) => throw null;
                public virtual object ApplyRepeatedly(object t, Antlr.Runtime.Misc.Func<Antlr.Runtime.IAstRuleReturnScope> whichRule) => throw null;
                protected virtual Antlr.Runtime.IAstRuleReturnScope Bottomup() => throw null;
                public virtual object Downup(object t, bool showTransformations) => throw null;
                public virtual object Downup(object t) => throw null;
                protected virtual void ReportTransformation(object oldTree, object newTree) => throw null;
                protected virtual Antlr.Runtime.IAstRuleReturnScope Topdown() => throw null;
                public TreeRewriter(Antlr.Runtime.Tree.ITreeNodeStream input, Antlr.Runtime.RecognizerSharedState state) : base(default(Antlr.Runtime.Tree.ITreeNodeStream)) => throw null;
                public TreeRewriter(Antlr.Runtime.Tree.ITreeNodeStream input) : base(default(Antlr.Runtime.Tree.ITreeNodeStream)) => throw null;
                protected Antlr.Runtime.Tree.ITreeAdaptor originalAdaptor;
                protected Antlr.Runtime.ITokenStream originalTokenStream;
                protected bool showTransformations;
            }

            // Generated from `Antlr.Runtime.Tree.TreeRuleReturnScope<>` in `Antlr3.Runtime, Version=3.5.0.2, Culture=neutral, PublicKeyToken=eb42632606e9261f`
            public class TreeRuleReturnScope<TTree> : Antlr.Runtime.IRuleReturnScope<TTree>, Antlr.Runtime.IRuleReturnScope
            {
                public TTree Start { get => throw null; set => throw null; }
                object Antlr.Runtime.IRuleReturnScope.Start { get => throw null; }
                object Antlr.Runtime.IRuleReturnScope.Stop { get => throw null; }
                TTree Antlr.Runtime.IRuleReturnScope<TTree>.Stop { get => throw null; }
                public TreeRuleReturnScope() => throw null;
            }

            // Generated from `Antlr.Runtime.Tree.TreeVisitor` in `Antlr3.Runtime, Version=3.5.0.2, Culture=neutral, PublicKeyToken=eb42632606e9261f`
            public class TreeVisitor
            {
                public TreeVisitor(Antlr.Runtime.Tree.ITreeAdaptor adaptor) => throw null;
                public TreeVisitor() => throw null;
                public object Visit(object t, Antlr.Runtime.Tree.ITreeVisitorAction action) => throw null;
                public object Visit(object t, Antlr.Runtime.Misc.Func<object, object> preAction, Antlr.Runtime.Misc.Func<object, object> postAction) => throw null;
                protected Antlr.Runtime.Tree.ITreeAdaptor adaptor;
            }

            // Generated from `Antlr.Runtime.Tree.TreeVisitorAction` in `Antlr3.Runtime, Version=3.5.0.2, Culture=neutral, PublicKeyToken=eb42632606e9261f`
            public class TreeVisitorAction : Antlr.Runtime.Tree.ITreeVisitorAction
            {
                public object Post(object t) => throw null;
                public object Pre(object t) => throw null;
                public TreeVisitorAction(Antlr.Runtime.Misc.Func<object, object> preAction, Antlr.Runtime.Misc.Func<object, object> postAction) => throw null;
            }

            // Generated from `Antlr.Runtime.Tree.TreeWizard` in `Antlr3.Runtime, Version=3.5.0.2, Culture=neutral, PublicKeyToken=eb42632606e9261f`
            public class TreeWizard
            {
                public virtual System.Collections.Generic.IDictionary<string, int> ComputeTokenTypes(string[] tokenNames) => throw null;
                public virtual object Create(string pattern) => throw null;
                public static bool Equals(object t1, object t2, Antlr.Runtime.Tree.ITreeAdaptor adaptor) => throw null;
                public bool Equals(object t1, object t2) => throw null;
                protected static bool EqualsCore(object t1, object t2, Antlr.Runtime.Tree.ITreeAdaptor adaptor) => throw null;
                public virtual System.Collections.IList Find(object t, string pattern) => throw null;
                public virtual System.Collections.IList Find(object t, int ttype) => throw null;
                public virtual object FindFirst(object t, string pattern) => throw null;
                public virtual object FindFirst(object t, int ttype) => throw null;
                public virtual int GetTokenType(string tokenName) => throw null;
                // Generated from `Antlr.Runtime.Tree.TreeWizard+IContextVisitor` in `Antlr3.Runtime, Version=3.5.0.2, Culture=neutral, PublicKeyToken=eb42632606e9261f`
                public interface IContextVisitor
                {
                    void Visit(object t, object parent, int childIndex, System.Collections.Generic.IDictionary<string, object> labels);
                }


                public System.Collections.Generic.IDictionary<int, System.Collections.IList> Index(object t) => throw null;
                protected virtual void IndexCore(object t, System.Collections.Generic.IDictionary<int, System.Collections.IList> m) => throw null;
                public bool Parse(object t, string pattern, System.Collections.Generic.IDictionary<string, object> labels) => throw null;
                public bool Parse(object t, string pattern) => throw null;
                protected virtual bool ParseCore(object t1, Antlr.Runtime.Tree.TreeWizard.TreePattern tpattern, System.Collections.Generic.IDictionary<string, object> labels) => throw null;
                // Generated from `Antlr.Runtime.Tree.TreeWizard+TreePattern` in `Antlr3.Runtime, Version=3.5.0.2, Culture=neutral, PublicKeyToken=eb42632606e9261f`
                public class TreePattern : Antlr.Runtime.Tree.CommonTree
                {
                    public override string ToString() => throw null;
                    public TreePattern(Antlr.Runtime.IToken payload) => throw null;
                    public bool hasTextArg;
                    public string label;
                }


                // Generated from `Antlr.Runtime.Tree.TreeWizard+TreePatternTreeAdaptor` in `Antlr3.Runtime, Version=3.5.0.2, Culture=neutral, PublicKeyToken=eb42632606e9261f`
                public class TreePatternTreeAdaptor : Antlr.Runtime.Tree.CommonTreeAdaptor
                {
                    public override object Create(Antlr.Runtime.IToken payload) => throw null;
                    public TreePatternTreeAdaptor() => throw null;
                }


                public TreeWizard(string[] tokenNames) => throw null;
                public TreeWizard(Antlr.Runtime.Tree.ITreeAdaptor adaptor, string[] tokenNames) => throw null;
                public TreeWizard(Antlr.Runtime.Tree.ITreeAdaptor adaptor, System.Collections.Generic.IDictionary<string, int> tokenNameToTypeMap) => throw null;
                public TreeWizard(Antlr.Runtime.Tree.ITreeAdaptor adaptor) => throw null;
                public void Visit(object t, string pattern, Antlr.Runtime.Tree.TreeWizard.IContextVisitor visitor) => throw null;
                public void Visit(object t, int ttype, System.Action<object> action) => throw null;
                public void Visit(object t, int ttype, Antlr.Runtime.Tree.TreeWizard.IContextVisitor visitor) => throw null;
                protected virtual void VisitCore(object t, object parent, int childIndex, int ttype, Antlr.Runtime.Tree.TreeWizard.IContextVisitor visitor) => throw null;
                // Generated from `Antlr.Runtime.Tree.TreeWizard+Visitor` in `Antlr3.Runtime, Version=3.5.0.2, Culture=neutral, PublicKeyToken=eb42632606e9261f`
                public abstract class Visitor : Antlr.Runtime.Tree.TreeWizard.IContextVisitor
                {
                    public virtual void Visit(object t, object parent, int childIndex, System.Collections.Generic.IDictionary<string, object> labels) => throw null;
                    public abstract void Visit(object t);
                    protected Visitor() => throw null;
                }


                // Generated from `Antlr.Runtime.Tree.TreeWizard+WildcardTreePattern` in `Antlr3.Runtime, Version=3.5.0.2, Culture=neutral, PublicKeyToken=eb42632606e9261f`
                public class WildcardTreePattern : Antlr.Runtime.Tree.TreeWizard.TreePattern
                {
                    public WildcardTreePattern(Antlr.Runtime.IToken payload) : base(default(Antlr.Runtime.IToken)) => throw null;
                }


                protected Antlr.Runtime.Tree.ITreeAdaptor adaptor;
                protected System.Collections.Generic.IDictionary<string, int> tokenNameToTypeMap;
            }

        }
    }
}
namespace System
{
    /* Duplicate type 'ICloneable' is not stubbed in this assembly 'Antlr3.Runtime, Version=3.5.0.2, Culture=neutral, PublicKeyToken=eb42632606e9261f'. */

    /* Duplicate type 'NonSerializedAttribute' is not stubbed in this assembly 'Antlr3.Runtime, Version=3.5.0.2, Culture=neutral, PublicKeyToken=eb42632606e9261f'. */

    /* Duplicate type 'SerializableAttribute' is not stubbed in this assembly 'Antlr3.Runtime, Version=3.5.0.2, Culture=neutral, PublicKeyToken=eb42632606e9261f'. */

    namespace Runtime
    {
        namespace Serialization
        {
            /* Duplicate type 'OnSerializingAttribute' is not stubbed in this assembly 'Antlr3.Runtime, Version=3.5.0.2, Culture=neutral, PublicKeyToken=eb42632606e9261f'. */

            /* Duplicate type 'StreamingContext' is not stubbed in this assembly 'Antlr3.Runtime, Version=3.5.0.2, Culture=neutral, PublicKeyToken=eb42632606e9261f'. */

        }
    }
}
