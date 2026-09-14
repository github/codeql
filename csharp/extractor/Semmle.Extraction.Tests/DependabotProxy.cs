using Xunit;
using System;
using System.IO;
using Semmle.Extraction.CSharp.DependencyFetching;
using Semmle.Util;

namespace Semmle.Extraction.Tests
{
    public class DependabotConfigurationStub : IDependabotProxyConfiguration
    {
        public string? Host { get; set; }
        public string? Port { get; set; }
        public string? Certificate { get; set; }
        public string? RegistryURLs { get; set; }
    }

    public class DiagnosticsWriterStub : IDiagnosticsWriter
    {
        public void AddEntry(Semmle.Util.DiagnosticMessage entry) { }
        public void Dispose() { }
    }

    public class DependabotProxyTests
    {
        private static TemporaryDirectory MakeTemporaryDirectory()
        {
            var tmp = Path.Join(Path.GetTempPath(), "DependabotProxyTests", Guid.NewGuid().ToString());
            return new TemporaryDirectory(tmp, "testing", new LoggerStub());
        }

        /// <summary>
        /// The purpose of this test is to verify that the registry proxy correctly handles the case where the port is not specified.
        /// In this case, the registry proxy should not be created.
        /// </summary>
        [Fact]
        public void TestDependabotProxyNoPort()
        {
            // Setup
            var config = new DependabotConfigurationStub
            {
                Host = "localhost",
                Port = "",
            };

            // Execute
            using var tempWorkingDirectory = MakeTemporaryDirectory();
            using var proxy = DependabotProxy.Make(config, new LoggerStub(), new DiagnosticsWriterStub(), tempWorkingDirectory);

            // Verify
            Assert.Null(proxy);
        }

        /// <summary>
        /// The purpose of this test is to verify that the registry proxy correctly handles the case where the host is not specified.
        /// In this case, the registry proxy should not be created.
        /// </summary>
        [Fact]
        public void TestDependabotProxyNoHost()
        {
            // Setup
            var config = new DependabotConfigurationStub
            {
                Port = "8080",
            };

            // Execute
            using var tempWorkingDirectory = MakeTemporaryDirectory();
            using var proxy = DependabotProxy.Make(config, new LoggerStub(), new DiagnosticsWriterStub(), tempWorkingDirectory);

            // Verify
            Assert.Null(proxy);
        }

        private const string ExampleCertificate = """
        -----BEGIN CERTIFICATE-----
        MIIFJTCCAw2gAwIBAgIUDImU6YnuAqJ1QuRp+OpJQPnPu6wwDQYJKoZIhvcNAQEL
        BQAwFDESMBAGA1UEAwwJbG9jYWxob3N0MB4XDTI2MDkwMTEyMjUzMVoXDTI3MDkw
        MTEyMjUzMVowFDESMBAGA1UEAwwJbG9jYWxob3N0MIICIjANBgkqhkiG9w0BAQEF
        AAOCAg8AMIICCgKCAgEAnlp7yQ1VuocMwIZWlCle3bEM86+1ED6BFfPFpIrRhfUT
        c+5IvPng8TIZPO4mROp5G9YDZfOtXW2bwktyZNUhsBcxqUT1lmXit21vc5W9Gxx5
        4G8nyF4/FcjFkmxkZifxiUCdBceDcE7+kx2itq/a7gLPlyTzvz5etu1nHEC3Jg/y
        TVhAwdwysgAo9WymFCczDa2ga6nOPBOaxwLnoPl9041KSu5oIo9QC0Im+US1R18Q
        /mXa+wkmjf+bYAkE/pZie8z8Q7h9yppTngGzkoDEebFYyaMr8MXlFdWS8f/eMwSp
        iMFSsmlCqgUbA672APxzOcuSMMYrblzGkvZp23qbNjwQuQKlgAYBTSGltLv4U8JF
        ePNcgDCY6RG55rNvF1gk1L2h25jcw1LX6fSvQGCOkzNmP03AhqZBUigO1Zt0zLwi
        K4m0bH7nPLJFEN6tI3tybyZeC2RVyiSHvOkgx35Qj8RQ3XMVkImJNBYOMc2MkmMZ
        ux6XMiHqXCON4zaWuWSovciZeMAQAspCrzVDLH6p2DWEfw/zDfQNU3iLk21sZGei
        0GKzs8zrxUcqOU9V4Cnm+7JJ6eqS72f1+wX0ROb3djC6KgCE/NaHqo4apiI3K+CH
        T0rVRsJIHyT39YO1c1I1vhAKRSH5kQVe3qRfIT/AuaDLQY6WqGPzrOkem78sjtsC
        AwEAAaNvMG0wHQYDVR0OBBYEFK0DP5MD6mhEcdcm346uwoPL2NFGMB8GA1UdIwQY
        MBaAFK0DP5MD6mhEcdcm346uwoPL2NFGMA8GA1UdEwEB/wQFMAMBAf8wGgYDVR0R
        BBMwEYIJbG9jYWxob3N0hwR/AAABMA0GCSqGSIb3DQEBCwUAA4ICAQCc5u8qNHHG
        kONjfvq7Denq6QaEt4dZZDDODAvgUzZnnBjEhgrp7zfxtbyU/I0+DWnKQMKA9wPM
        ktiFGd0lldEqoT+E7b0kN124lBGqZ/uYkhsWZ0Nc5dD+UB9oJszwOc5KNuquOnr6
        SbsfXVm4yLvVLXl67c0jvqvRgGg9/6Q6eMzohW6abMdbYhS28/DsJhCea/dV3+L1
        oVJ3O/A8e86m174ZCGE8s9UtnVYylBkAryDqaaQLdOBQ2C7uxdRAUNHSIa2JlqUc
        5+cod8lFojKb74hbgj6wkXyajsFttqYMh7CeASsnjZXDQ4MC3DqqDVCZuNvJ85Rt
        ya3Tljp4Ln2AAAoKC3REUeU8PQqpk1vVIj0FSr3RvBTvwzyNfWFVqyBiXTATuV9n
        6AemqqXo5MZrHHeRaSTF8A70Jxbt9yx75xQxp3O3tdEL1Mxbl9X7c/hizOfLbeHH
        IkAgzALQgi87Zbf2tOhRwH5NrB4ijyUUfovRHUwzsZOoTNqlVeNzbDRVbegx9V99
        /3vwNZgpStGl/JYhN9qY5hJKnC64ltMvuNGpLeJCGyFkrtFS8gKkgR7VKrGo7h3+
        Zo8rz8TFjP7RmSgQbrmFuPqNOGXzPidu2sMMFacKV7Rn4bEtHzW3MDhqVD4w/pGD
        L0xpnWjzLYltVjz8mo07yh+zQ10G71Cl1w==
        -----END CERTIFICATE-----
        """;

        /// <summary>
        /// The purpose of this test is to verify that the registry proxy correctly handles the case
        /// where the port, host, and certificate are specified.
        /// </summary>
        [Fact]
        public void TestDependabotProxyCertificate()
        {
            // Setup
            var config = new DependabotConfigurationStub
            {
                Port = "8080",
                Host = "localhost",
                Certificate = ExampleCertificate
            };

            // Execute
            using var tempWorkingDirectory = MakeTemporaryDirectory();
            using var proxy = DependabotProxy.Make(config, new LoggerStub(), new DiagnosticsWriterStub(), tempWorkingDirectory);

            // Verify
            Assert.NotNull(proxy);
            Assert.Equal("http://localhost:8080", proxy.Address);
            Assert.NotNull(proxy.Certificate);
            Assert.NotNull(proxy.CertificatePath);
        }

        /// <summary>
        /// The purpose of this test is to verify that the registry proxy correctly handles the case
        /// where the RegistryURLs environment variable is not a valid JSON list.
        /// In this case, the registry proxy should be created, but the list of private registries should be empty.
        /// </summary>
        [Fact]
        public void TestDependabotRegistryUrlsParseError()
        {
            // Setup
            var config = new DependabotConfigurationStub
            {
                Port = "8080",
                Host = "localhost",
                RegistryURLs = "Doesn't parse as a JSON list"
            };

            // Execute
            using var tempWorkingDirectory = MakeTemporaryDirectory();
            using var proxy = DependabotProxy.Make(config, new LoggerStub(), new DiagnosticsWriterStub(), tempWorkingDirectory);

            // Verify
            Assert.NotNull(proxy);
            Assert.Empty(proxy.RegistryURLs);
            Assert.Empty(proxy.RegistryBaseURLs);
        }

        /// <summary>
        /// The purpose of this test is to verify that the registry proxy correctly handles the case
        /// where the RegistryURLs environment variable is a valid JSON list with a single entry.
        /// In this case, the registry proxy should be created, and the list of private registries should contain the single entry.
        /// </summary>
        [Fact]
        public void TestDependabotRegistryUrlsSingle()
        {
            // Setup
            var config = new DependabotConfigurationStub
            {
                Port = "8080",
                Host = "localhost",
                RegistryURLs = "[ { \"type\": \"nuget_feed\", \"url\": \"https://nuget.pkg.github.com/org/index.json\" } ]"
            };

            // Execute
            using var tempWorkingDirectory = MakeTemporaryDirectory();
            using var proxy = DependabotProxy.Make(config, new LoggerStub(), new DiagnosticsWriterStub(), tempWorkingDirectory);

            // Verify
            Assert.NotNull(proxy);
            Assert.Equal([
                "https://nuget.pkg.github.com/org/index.json"
            ], proxy.RegistryURLs);
            Assert.Empty(proxy.RegistryBaseURLs);
        }

        /// <summary>
        /// The purpose of this test is to verify that the registry proxy correctly handles the case
        /// where the RegistryURLs environment variable is a valid JSON list with multiple entries, but only one of them
        /// is of type "nuget_feed", which is relevant for C#.
        /// In this case, the registry proxy should be created, and the list of private registries should
        /// contain only the entry of type "nuget_feed".
        /// </summary>
        [Fact]
        public void TestDependabotRegistryUrls3()
        {
            // Setup
            var config = new DependabotConfigurationStub
            {
                Port = "8080",
                Host = "localhost",
                RegistryURLs = "[ { \"type\": \"nuget_feed\", \"url\": \"https://example.com/org/index.json\" }, { \"type\": \"wrong_type\", \"url\": \"https://nuget.pkg.github.com/org/index.json\" } ]"
            };

            // Execute
            using var tempWorkingDirectory = MakeTemporaryDirectory();
            using var proxy = DependabotProxy.Make(config, new LoggerStub(), new DiagnosticsWriterStub(), tempWorkingDirectory);

            // Verify
            Assert.NotNull(proxy);
            Assert.Equal([
                "https://example.com/org/index.json"
            ], proxy.RegistryURLs);
            Assert.Empty(proxy.RegistryBaseURLs);
        }

        /// <summary>
        /// The purpose of this test is to verify that the registry proxy correctly handles the case
        /// where the RegistryURLs environment variable is a valid JSON list with multiple entries and one of them
        /// is configured to replace the base feeds.
        /// In this case, the registry proxy should be created, and the list of private registries should contain all
        /// entries, while the list of base registries should contain only the entry that replaces the base feeds.
        /// </summary>
        [Fact]
        public void TestDependabotRegistryUrlsReplacesBase()
        {
            // Setup
            var config = new DependabotConfigurationStub
            {
                Port = "8080",
                Host = "localhost",
                RegistryURLs = "[ { \"type\": \"nuget_feed\", \"url\": \"https://example.com/org/index.json\", \"replaces-base\": true }, { \"type\": \"nuget_feed\", \"url\": \"https://example2.com/org/index.json\", \"replaces-base\": false } ]"
            };

            // Execute
            using var tempWorkingDirectory = MakeTemporaryDirectory();
            using var proxy = DependabotProxy.Make(config, new LoggerStub(), new DiagnosticsWriterStub(), tempWorkingDirectory);

            // Verify
            Assert.NotNull(proxy);
            Assert.Equal([
                "https://example.com/org/index.json",
                "https://example2.com/org/index.json"
            ], proxy.RegistryURLs);
            Assert.Equal([
                "https://example.com/org/index.json",
            ], proxy.RegistryBaseURLs);
        }
    }
}
