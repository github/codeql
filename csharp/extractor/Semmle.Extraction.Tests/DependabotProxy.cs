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

        [Fact]
        public void TestDependabotProxyCreation1()
        {
            // Setup
            var config = new DependabotConfigurationStub
            {
                Host = "my.private.server",
                Port = "",
            };

            // Execute
            using var tempWorkingDirectory = MakeTemporaryDirectory();
            using var proxy = DependabotProxy.MakeAux(config, new LoggerStub(), new DiagnosticsWriterStub(), tempWorkingDirectory);

            // Verify
            Assert.Null(proxy);
        }

        [Fact]
        public void TestDependabotProxyCreation2()
        {
            // Setup
            var config = new DependabotConfigurationStub
            {
                Port = "8080",
            };

            // Execute
            using var tempWorkingDirectory = MakeTemporaryDirectory();
            using var proxy = DependabotProxy.MakeAux(config, new LoggerStub(), new DiagnosticsWriterStub(), tempWorkingDirectory);

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

        [Fact]
        public void TestDependabotProxyCertificate()
        {
            // Setup
            var config = new DependabotConfigurationStub
            {
                Port = "8080",
                Host = "my.private.server",
                Certificate = ExampleCertificate
            };

            // Execute
            using var tempWorkingDirectory = MakeTemporaryDirectory();
            using var proxy = DependabotProxy.MakeAux(config, new LoggerStub(), new DiagnosticsWriterStub(), tempWorkingDirectory);

            // Verify
            Assert.NotNull(proxy);
            Assert.Equal("http://my.private.server:8080", proxy.Address);
            Assert.NotNull(proxy.Certificate);
            Assert.NotNull(proxy.CertificatePath);
        }

        [Fact]
        public void TestDependabotRegistryUrls1()
        {
            // Setup
            var config = new DependabotConfigurationStub
            {
                Port = "8080",
                Host = "my.private.server",
                RegistryURLs = "Doesn't parse as a JSON list"
            };

            // Execute
            using var tempWorkingDirectory = MakeTemporaryDirectory();
            using var proxy = DependabotProxy.MakeAux(config, new LoggerStub(), new DiagnosticsWriterStub(), tempWorkingDirectory);

            // Verify
            Assert.NotNull(proxy);
            Assert.Equal([], proxy.RegistryURLs);
        }

        [Fact]
        public void TestDependabotRegistryUrls2()
        {
            // Setup
            var config = new DependabotConfigurationStub
            {
                Port = "8080",
                Host = "my.private.server",
                RegistryURLs = "[ { \"type\": \"nuget_feed\", \"url\": \"https://nuget.pkg.github.com/org/index.json\" } ]"
            };

            // Execute
            using var tempWorkingDirectory = MakeTemporaryDirectory();
            using var proxy = DependabotProxy.MakeAux(config, new LoggerStub(), new DiagnosticsWriterStub(), tempWorkingDirectory);

            // Verify
            Assert.NotNull(proxy);
            Assert.Equal([
                "https://nuget.pkg.github.com/org/index.json"
            ], proxy.RegistryURLs);
        }

        [Fact]
        public void TestDependabotRegistryUrls3()
        {
            // Setup
            var config = new DependabotConfigurationStub
            {
                Port = "8080",
                Host = "my.private.server",
                RegistryURLs = "[ { \"type\": \"nuget_feed\", \"url\": \"https://example.com/org/index.json\" }, { \"type\": \"wrong_type\", \"url\": \"https://nuget.pkg.github.com/org/index.json\" } ]"
            };

            // Execute
            using var tempWorkingDirectory = MakeTemporaryDirectory();
            using var proxy = DependabotProxy.MakeAux(config, new LoggerStub(), new DiagnosticsWriterStub(), tempWorkingDirectory);

            // Verify
            Assert.NotNull(proxy);
            Assert.Equal([
                "https://example.com/org/index.json"
            ], proxy.RegistryURLs);
        }
    }
}
