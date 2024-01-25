// This file contains auto-generated code.
// Generated from `Microsoft.Extensions.Configuration.Xml, Version=8.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`.
namespace Microsoft
{
    namespace Extensions
    {
        namespace Configuration
        {
            namespace Xml
            {
                public class XmlConfigurationProvider : Microsoft.Extensions.Configuration.FileConfigurationProvider
                {
                    public XmlConfigurationProvider(Microsoft.Extensions.Configuration.Xml.XmlConfigurationSource source) : base(default(Microsoft.Extensions.Configuration.FileConfigurationSource)) => throw null;
                    public override void Load(System.IO.Stream stream) => throw null;
                }
                public class XmlConfigurationSource : Microsoft.Extensions.Configuration.FileConfigurationSource
                {
                    public override Microsoft.Extensions.Configuration.IConfigurationProvider Build(Microsoft.Extensions.Configuration.IConfigurationBuilder builder) => throw null;
                    public XmlConfigurationSource() => throw null;
                }
                public class XmlDocumentDecryptor
                {
                    public System.Xml.XmlReader CreateDecryptingXmlReader(System.IO.Stream input, System.Xml.XmlReaderSettings settings) => throw null;
                    protected XmlDocumentDecryptor() => throw null;
                    protected virtual System.Xml.XmlReader DecryptDocumentAndCreateXmlReader(System.Xml.XmlDocument document) => throw null;
                    public static readonly Microsoft.Extensions.Configuration.Xml.XmlDocumentDecryptor Instance;
                }
                public class XmlStreamConfigurationProvider : Microsoft.Extensions.Configuration.StreamConfigurationProvider
                {
                    public XmlStreamConfigurationProvider(Microsoft.Extensions.Configuration.Xml.XmlStreamConfigurationSource source) : base(default(Microsoft.Extensions.Configuration.StreamConfigurationSource)) => throw null;
                    public override void Load(System.IO.Stream stream) => throw null;
                    public static System.Collections.Generic.IDictionary<string, string> Read(System.IO.Stream stream, Microsoft.Extensions.Configuration.Xml.XmlDocumentDecryptor decryptor) => throw null;
                }
                public class XmlStreamConfigurationSource : Microsoft.Extensions.Configuration.StreamConfigurationSource
                {
                    public override Microsoft.Extensions.Configuration.IConfigurationProvider Build(Microsoft.Extensions.Configuration.IConfigurationBuilder builder) => throw null;
                    public XmlStreamConfigurationSource() => throw null;
                }
            }
            public static partial class XmlConfigurationExtensions
            {
                public static Microsoft.Extensions.Configuration.IConfigurationBuilder AddXmlFile(this Microsoft.Extensions.Configuration.IConfigurationBuilder builder, Microsoft.Extensions.FileProviders.IFileProvider provider, string path, bool optional, bool reloadOnChange) => throw null;
                public static Microsoft.Extensions.Configuration.IConfigurationBuilder AddXmlFile(this Microsoft.Extensions.Configuration.IConfigurationBuilder builder, System.Action<Microsoft.Extensions.Configuration.Xml.XmlConfigurationSource> configureSource) => throw null;
                public static Microsoft.Extensions.Configuration.IConfigurationBuilder AddXmlFile(this Microsoft.Extensions.Configuration.IConfigurationBuilder builder, string path) => throw null;
                public static Microsoft.Extensions.Configuration.IConfigurationBuilder AddXmlFile(this Microsoft.Extensions.Configuration.IConfigurationBuilder builder, string path, bool optional) => throw null;
                public static Microsoft.Extensions.Configuration.IConfigurationBuilder AddXmlFile(this Microsoft.Extensions.Configuration.IConfigurationBuilder builder, string path, bool optional, bool reloadOnChange) => throw null;
                public static Microsoft.Extensions.Configuration.IConfigurationBuilder AddXmlStream(this Microsoft.Extensions.Configuration.IConfigurationBuilder builder, System.IO.Stream stream) => throw null;
            }
        }
    }
}
