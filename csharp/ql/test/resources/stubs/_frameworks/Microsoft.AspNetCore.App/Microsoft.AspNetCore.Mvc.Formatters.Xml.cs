// This file contains auto-generated code.
// Generated from `Microsoft.AspNetCore.Mvc.Formatters.Xml, Version=8.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`.
namespace Microsoft
{
    namespace AspNetCore
    {
        namespace Mvc
        {
            namespace Formatters
            {
                namespace Xml
                {
                    public class DelegatingEnumerable<TWrapped, TDeclared> : System.Collections.Generic.IEnumerable<TWrapped>, System.Collections.IEnumerable
                    {
                        public void Add(object item) => throw null;
                        public DelegatingEnumerable() => throw null;
                        public DelegatingEnumerable(System.Collections.Generic.IEnumerable<TDeclared> source, Microsoft.AspNetCore.Mvc.Formatters.Xml.IWrapperProvider elementWrapperProvider) => throw null;
                        public System.Collections.Generic.IEnumerator<TWrapped> GetEnumerator() => throw null;
                        System.Collections.IEnumerator System.Collections.IEnumerable.GetEnumerator() => throw null;
                    }
                    public class DelegatingEnumerator<TWrapped, TDeclared> : System.IDisposable, System.Collections.Generic.IEnumerator<TWrapped>, System.Collections.IEnumerator
                    {
                        public DelegatingEnumerator(System.Collections.Generic.IEnumerator<TDeclared> inner, Microsoft.AspNetCore.Mvc.Formatters.Xml.IWrapperProvider wrapperProvider) => throw null;
                        public TWrapped Current { get => throw null; }
                        object System.Collections.IEnumerator.Current { get => throw null; }
                        public void Dispose() => throw null;
                        public bool MoveNext() => throw null;
                        public void Reset() => throw null;
                    }
                    public class EnumerableWrapperProvider : Microsoft.AspNetCore.Mvc.Formatters.Xml.IWrapperProvider
                    {
                        public EnumerableWrapperProvider(System.Type sourceEnumerableOfT, Microsoft.AspNetCore.Mvc.Formatters.Xml.IWrapperProvider elementWrapperProvider) => throw null;
                        public object Wrap(object original) => throw null;
                        public System.Type WrappingType { get => throw null; }
                    }
                    public class EnumerableWrapperProviderFactory : Microsoft.AspNetCore.Mvc.Formatters.Xml.IWrapperProviderFactory
                    {
                        public EnumerableWrapperProviderFactory(System.Collections.Generic.IEnumerable<Microsoft.AspNetCore.Mvc.Formatters.Xml.IWrapperProviderFactory> wrapperProviderFactories) => throw null;
                        public Microsoft.AspNetCore.Mvc.Formatters.Xml.IWrapperProvider GetProvider(Microsoft.AspNetCore.Mvc.Formatters.Xml.WrapperProviderContext context) => throw null;
                    }
                    public interface IUnwrappable
                    {
                        object Unwrap(System.Type declaredType);
                    }
                    public interface IWrapperProvider
                    {
                        object Wrap(object original);
                        System.Type WrappingType { get; }
                    }
                    public interface IWrapperProviderFactory
                    {
                        Microsoft.AspNetCore.Mvc.Formatters.Xml.IWrapperProvider GetProvider(Microsoft.AspNetCore.Mvc.Formatters.Xml.WrapperProviderContext context);
                    }
                    public class MvcXmlOptions : System.Collections.Generic.IEnumerable<Microsoft.AspNetCore.Mvc.Infrastructure.ICompatibilitySwitch>, System.Collections.IEnumerable
                    {
                        public MvcXmlOptions() => throw null;
                        System.Collections.Generic.IEnumerator<Microsoft.AspNetCore.Mvc.Infrastructure.ICompatibilitySwitch> System.Collections.Generic.IEnumerable<Microsoft.AspNetCore.Mvc.Infrastructure.ICompatibilitySwitch>.GetEnumerator() => throw null;
                        System.Collections.IEnumerator System.Collections.IEnumerable.GetEnumerator() => throw null;
                    }
                    public class ProblemDetailsWrapper : Microsoft.AspNetCore.Mvc.Formatters.Xml.IUnwrappable, System.Xml.Serialization.IXmlSerializable
                    {
                        public ProblemDetailsWrapper() => throw null;
                        public ProblemDetailsWrapper(Microsoft.AspNetCore.Mvc.ProblemDetails problemDetails) => throw null;
                        protected static readonly string EmptyKey;
                        public System.Xml.Schema.XmlSchema GetSchema() => throw null;
                        protected virtual void ReadValue(System.Xml.XmlReader reader, string name) => throw null;
                        public virtual void ReadXml(System.Xml.XmlReader reader) => throw null;
                        object Microsoft.AspNetCore.Mvc.Formatters.Xml.IUnwrappable.Unwrap(System.Type declaredType) => throw null;
                        public virtual void WriteXml(System.Xml.XmlWriter writer) => throw null;
                    }
                    public sealed class SerializableErrorWrapper : Microsoft.AspNetCore.Mvc.Formatters.Xml.IUnwrappable, System.Xml.Serialization.IXmlSerializable
                    {
                        public SerializableErrorWrapper() => throw null;
                        public SerializableErrorWrapper(Microsoft.AspNetCore.Mvc.SerializableError error) => throw null;
                        public System.Xml.Schema.XmlSchema GetSchema() => throw null;
                        public void ReadXml(System.Xml.XmlReader reader) => throw null;
                        public Microsoft.AspNetCore.Mvc.SerializableError SerializableError { get => throw null; }
                        public object Unwrap(System.Type declaredType) => throw null;
                        public void WriteXml(System.Xml.XmlWriter writer) => throw null;
                    }
                    public class SerializableErrorWrapperProvider : Microsoft.AspNetCore.Mvc.Formatters.Xml.IWrapperProvider
                    {
                        public SerializableErrorWrapperProvider() => throw null;
                        public object Wrap(object original) => throw null;
                        public System.Type WrappingType { get => throw null; }
                    }
                    public class SerializableErrorWrapperProviderFactory : Microsoft.AspNetCore.Mvc.Formatters.Xml.IWrapperProviderFactory
                    {
                        public SerializableErrorWrapperProviderFactory() => throw null;
                        public Microsoft.AspNetCore.Mvc.Formatters.Xml.IWrapperProvider GetProvider(Microsoft.AspNetCore.Mvc.Formatters.Xml.WrapperProviderContext context) => throw null;
                    }
                    public class ValidationProblemDetailsWrapper : Microsoft.AspNetCore.Mvc.Formatters.Xml.ProblemDetailsWrapper, Microsoft.AspNetCore.Mvc.Formatters.Xml.IUnwrappable
                    {
                        public ValidationProblemDetailsWrapper() => throw null;
                        public ValidationProblemDetailsWrapper(Microsoft.AspNetCore.Mvc.ValidationProblemDetails problemDetails) => throw null;
                        protected override void ReadValue(System.Xml.XmlReader reader, string name) => throw null;
                        object Microsoft.AspNetCore.Mvc.Formatters.Xml.IUnwrappable.Unwrap(System.Type declaredType) => throw null;
                        public override void WriteXml(System.Xml.XmlWriter writer) => throw null;
                    }
                    public class WrapperProviderContext
                    {
                        public WrapperProviderContext(System.Type declaredType, bool isSerialization) => throw null;
                        public System.Type DeclaredType { get => throw null; }
                        public bool IsSerialization { get => throw null; }
                    }
                    public static partial class WrapperProviderFactoriesExtensions
                    {
                        public static Microsoft.AspNetCore.Mvc.Formatters.Xml.IWrapperProvider GetWrapperProvider(this System.Collections.Generic.IEnumerable<Microsoft.AspNetCore.Mvc.Formatters.Xml.IWrapperProviderFactory> wrapperProviderFactories, Microsoft.AspNetCore.Mvc.Formatters.Xml.WrapperProviderContext wrapperProviderContext) => throw null;
                    }
                }
                public class XmlDataContractSerializerInputFormatter : Microsoft.AspNetCore.Mvc.Formatters.TextInputFormatter, Microsoft.AspNetCore.Mvc.Formatters.IInputFormatterExceptionPolicy
                {
                    protected override bool CanReadType(System.Type type) => throw null;
                    protected virtual System.Runtime.Serialization.DataContractSerializer CreateSerializer(System.Type type) => throw null;
                    protected virtual System.Xml.XmlReader CreateXmlReader(System.IO.Stream readStream, System.Text.Encoding encoding) => throw null;
                    public XmlDataContractSerializerInputFormatter(Microsoft.AspNetCore.Mvc.MvcOptions options) => throw null;
                    public virtual Microsoft.AspNetCore.Mvc.Formatters.InputFormatterExceptionPolicy ExceptionPolicy { get => throw null; }
                    protected virtual System.Runtime.Serialization.DataContractSerializer GetCachedSerializer(System.Type type) => throw null;
                    protected virtual System.Type GetSerializableType(System.Type declaredType) => throw null;
                    public int MaxDepth { get => throw null; set { } }
                    public override System.Threading.Tasks.Task<Microsoft.AspNetCore.Mvc.Formatters.InputFormatterResult> ReadRequestBodyAsync(Microsoft.AspNetCore.Mvc.Formatters.InputFormatterContext context, System.Text.Encoding encoding) => throw null;
                    public System.Runtime.Serialization.DataContractSerializerSettings SerializerSettings { get => throw null; set { } }
                    public System.Collections.Generic.IList<Microsoft.AspNetCore.Mvc.Formatters.Xml.IWrapperProviderFactory> WrapperProviderFactories { get => throw null; }
                    public System.Xml.XmlDictionaryReaderQuotas XmlDictionaryReaderQuotas { get => throw null; }
                }
                public class XmlDataContractSerializerOutputFormatter : Microsoft.AspNetCore.Mvc.Formatters.TextOutputFormatter
                {
                    protected override bool CanWriteType(System.Type type) => throw null;
                    protected virtual System.Runtime.Serialization.DataContractSerializer CreateSerializer(System.Type type) => throw null;
                    public virtual System.Xml.XmlWriter CreateXmlWriter(System.IO.TextWriter writer, System.Xml.XmlWriterSettings xmlWriterSettings) => throw null;
                    public virtual System.Xml.XmlWriter CreateXmlWriter(Microsoft.AspNetCore.Mvc.Formatters.OutputFormatterWriteContext context, System.IO.TextWriter writer, System.Xml.XmlWriterSettings xmlWriterSettings) => throw null;
                    public XmlDataContractSerializerOutputFormatter() => throw null;
                    public XmlDataContractSerializerOutputFormatter(Microsoft.Extensions.Logging.ILoggerFactory loggerFactory) => throw null;
                    public XmlDataContractSerializerOutputFormatter(System.Xml.XmlWriterSettings writerSettings) => throw null;
                    public XmlDataContractSerializerOutputFormatter(System.Xml.XmlWriterSettings writerSettings, Microsoft.Extensions.Logging.ILoggerFactory loggerFactory) => throw null;
                    protected virtual System.Runtime.Serialization.DataContractSerializer GetCachedSerializer(System.Type type) => throw null;
                    protected virtual System.Type GetSerializableType(System.Type type) => throw null;
                    public System.Runtime.Serialization.DataContractSerializerSettings SerializerSettings { get => throw null; set { } }
                    public System.Collections.Generic.IList<Microsoft.AspNetCore.Mvc.Formatters.Xml.IWrapperProviderFactory> WrapperProviderFactories { get => throw null; }
                    public override System.Threading.Tasks.Task WriteResponseBodyAsync(Microsoft.AspNetCore.Mvc.Formatters.OutputFormatterWriteContext context, System.Text.Encoding selectedEncoding) => throw null;
                    public System.Xml.XmlWriterSettings WriterSettings { get => throw null; }
                }
                public class XmlSerializerInputFormatter : Microsoft.AspNetCore.Mvc.Formatters.TextInputFormatter, Microsoft.AspNetCore.Mvc.Formatters.IInputFormatterExceptionPolicy
                {
                    protected override bool CanReadType(System.Type type) => throw null;
                    protected virtual System.Xml.Serialization.XmlSerializer CreateSerializer(System.Type type) => throw null;
                    protected virtual System.Xml.XmlReader CreateXmlReader(System.IO.Stream readStream, System.Text.Encoding encoding, System.Type type) => throw null;
                    protected virtual System.Xml.XmlReader CreateXmlReader(System.IO.Stream readStream, System.Text.Encoding encoding) => throw null;
                    public XmlSerializerInputFormatter(Microsoft.AspNetCore.Mvc.MvcOptions options) => throw null;
                    public virtual Microsoft.AspNetCore.Mvc.Formatters.InputFormatterExceptionPolicy ExceptionPolicy { get => throw null; }
                    protected virtual System.Xml.Serialization.XmlSerializer GetCachedSerializer(System.Type type) => throw null;
                    protected virtual System.Type GetSerializableType(System.Type declaredType) => throw null;
                    public int MaxDepth { get => throw null; set { } }
                    public override System.Threading.Tasks.Task<Microsoft.AspNetCore.Mvc.Formatters.InputFormatterResult> ReadRequestBodyAsync(Microsoft.AspNetCore.Mvc.Formatters.InputFormatterContext context, System.Text.Encoding encoding) => throw null;
                    public System.Collections.Generic.IList<Microsoft.AspNetCore.Mvc.Formatters.Xml.IWrapperProviderFactory> WrapperProviderFactories { get => throw null; }
                    public System.Xml.XmlDictionaryReaderQuotas XmlDictionaryReaderQuotas { get => throw null; }
                }
                public class XmlSerializerOutputFormatter : Microsoft.AspNetCore.Mvc.Formatters.TextOutputFormatter
                {
                    protected override bool CanWriteType(System.Type type) => throw null;
                    protected virtual System.Xml.Serialization.XmlSerializer CreateSerializer(System.Type type) => throw null;
                    public virtual System.Xml.XmlWriter CreateXmlWriter(System.IO.TextWriter writer, System.Xml.XmlWriterSettings xmlWriterSettings) => throw null;
                    public virtual System.Xml.XmlWriter CreateXmlWriter(Microsoft.AspNetCore.Mvc.Formatters.OutputFormatterWriteContext context, System.IO.TextWriter writer, System.Xml.XmlWriterSettings xmlWriterSettings) => throw null;
                    public XmlSerializerOutputFormatter() => throw null;
                    public XmlSerializerOutputFormatter(Microsoft.Extensions.Logging.ILoggerFactory loggerFactory) => throw null;
                    public XmlSerializerOutputFormatter(System.Xml.XmlWriterSettings writerSettings) => throw null;
                    public XmlSerializerOutputFormatter(System.Xml.XmlWriterSettings writerSettings, Microsoft.Extensions.Logging.ILoggerFactory loggerFactory) => throw null;
                    protected virtual System.Xml.Serialization.XmlSerializer GetCachedSerializer(System.Type type) => throw null;
                    protected virtual System.Type GetSerializableType(System.Type type) => throw null;
                    protected virtual void Serialize(System.Xml.Serialization.XmlSerializer xmlSerializer, System.Xml.XmlWriter xmlWriter, object value) => throw null;
                    public System.Collections.Generic.IList<Microsoft.AspNetCore.Mvc.Formatters.Xml.IWrapperProviderFactory> WrapperProviderFactories { get => throw null; }
                    public override System.Threading.Tasks.Task WriteResponseBodyAsync(Microsoft.AspNetCore.Mvc.Formatters.OutputFormatterWriteContext context, System.Text.Encoding selectedEncoding) => throw null;
                    public System.Xml.XmlWriterSettings WriterSettings { get => throw null; }
                }
            }
            namespace ModelBinding
            {
                namespace Metadata
                {
                    public class DataMemberRequiredBindingMetadataProvider : Microsoft.AspNetCore.Mvc.ModelBinding.Metadata.IBindingMetadataProvider, Microsoft.AspNetCore.Mvc.ModelBinding.Metadata.IMetadataDetailsProvider
                    {
                        public void CreateBindingMetadata(Microsoft.AspNetCore.Mvc.ModelBinding.Metadata.BindingMetadataProviderContext context) => throw null;
                        public DataMemberRequiredBindingMetadataProvider() => throw null;
                    }
                }
            }
        }
    }
    namespace Extensions
    {
        namespace DependencyInjection
        {
            public static partial class MvcXmlMvcBuilderExtensions
            {
                public static Microsoft.Extensions.DependencyInjection.IMvcBuilder AddXmlDataContractSerializerFormatters(this Microsoft.Extensions.DependencyInjection.IMvcBuilder builder) => throw null;
                public static Microsoft.Extensions.DependencyInjection.IMvcBuilder AddXmlDataContractSerializerFormatters(this Microsoft.Extensions.DependencyInjection.IMvcBuilder builder, System.Action<Microsoft.AspNetCore.Mvc.Formatters.Xml.MvcXmlOptions> setupAction) => throw null;
                public static Microsoft.Extensions.DependencyInjection.IMvcBuilder AddXmlOptions(this Microsoft.Extensions.DependencyInjection.IMvcBuilder builder, System.Action<Microsoft.AspNetCore.Mvc.Formatters.Xml.MvcXmlOptions> setupAction) => throw null;
                public static Microsoft.Extensions.DependencyInjection.IMvcBuilder AddXmlSerializerFormatters(this Microsoft.Extensions.DependencyInjection.IMvcBuilder builder) => throw null;
                public static Microsoft.Extensions.DependencyInjection.IMvcBuilder AddXmlSerializerFormatters(this Microsoft.Extensions.DependencyInjection.IMvcBuilder builder, System.Action<Microsoft.AspNetCore.Mvc.Formatters.Xml.MvcXmlOptions> setupAction) => throw null;
            }
            public static partial class MvcXmlMvcCoreBuilderExtensions
            {
                public static Microsoft.Extensions.DependencyInjection.IMvcCoreBuilder AddXmlDataContractSerializerFormatters(this Microsoft.Extensions.DependencyInjection.IMvcCoreBuilder builder) => throw null;
                public static Microsoft.Extensions.DependencyInjection.IMvcCoreBuilder AddXmlDataContractSerializerFormatters(this Microsoft.Extensions.DependencyInjection.IMvcCoreBuilder builder, System.Action<Microsoft.AspNetCore.Mvc.Formatters.Xml.MvcXmlOptions> setupAction) => throw null;
                public static Microsoft.Extensions.DependencyInjection.IMvcCoreBuilder AddXmlOptions(this Microsoft.Extensions.DependencyInjection.IMvcCoreBuilder builder, System.Action<Microsoft.AspNetCore.Mvc.Formatters.Xml.MvcXmlOptions> setupAction) => throw null;
                public static Microsoft.Extensions.DependencyInjection.IMvcCoreBuilder AddXmlSerializerFormatters(this Microsoft.Extensions.DependencyInjection.IMvcCoreBuilder builder) => throw null;
                public static Microsoft.Extensions.DependencyInjection.IMvcCoreBuilder AddXmlSerializerFormatters(this Microsoft.Extensions.DependencyInjection.IMvcCoreBuilder builder, System.Action<Microsoft.AspNetCore.Mvc.Formatters.Xml.MvcXmlOptions> setupAction) => throw null;
            }
        }
    }
}
