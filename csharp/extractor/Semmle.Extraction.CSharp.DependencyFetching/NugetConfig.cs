using System;
using System.Collections.Generic;
using System.IO;
using System.Text;
using Semmle.Util;

namespace Semmle.Extraction.CSharp.DependencyFetching
{
    public class NugetConfig
    {
        internal class NugetFeed : IComparable<NugetFeed>
        {
            internal string Value { get; }
            internal bool DisableTlsCertificateValidation { get; set; }

            internal NugetFeed(string value)
            {
                this.Value = value;
                this.DisableTlsCertificateValidation = false;
            }

            public override string ToString()
            {
                return this.Value;
            }

            public int CompareTo(NugetFeed? other)
            {
                return this.Value.CompareTo(other?.Value);
            }
        }

        internal IEnumerable<NugetFeed> Feeds { get; }

        public NugetConfig()
        {
            this.Feeds = new List<NugetFeed>();
        }

        /// <summary>
        /// Writes this configuration to a file located at <paramref name="nugetConfigPath"/>.
        /// </summary>
        /// <param name="nugetConfigPath">The path of the file to which the configuration should be written to.</param>
        public void Write(string nugetConfigPath)
        {
            var sb = new StringBuilder();
            this.Feeds.ForEach((feed, index) => sb.AppendLine($"<add key=\"feed{index}\" value=\"{feed.Value}\" disableTLSCertificateValidation=\"{feed.DisableTlsCertificateValidation}\" />"));

            File.WriteAllText(nugetConfigPath,
                $"""
                <?xml version="1.0" encoding="utf-8"?>
                <configuration>
                    <packageSources>
                        <clear />
                {sb}
                    </packageSources>
                </configuration>
                """);
        }
    }
}
