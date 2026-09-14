
using System;
using System.IO;
using Semmle.Util.Logging;
using System.Net.Http;
using System.Net;
using System.Security.Cryptography.X509Certificates;
using System.Threading;
using System.Threading.Tasks;

namespace Semmle.Extraction.CSharp.DependencyFetching
{
    public class FeedManagerIO : IFeedManagerIO
    {
        private readonly ILogger logger;
        private readonly IDependabotProxy? dependabotProxy;

        public FeedManagerIO(ILogger logger, IDependabotProxy? dependabotProxy)
        {
            this.logger = logger;
            this.dependabotProxy = dependabotProxy;
        }

        public string? GetDirectoryName(string path)
        {
            try
            {
                return new FileInfo(path).Directory?.FullName;
            }
            catch (Exception exc)
            {
                logger.LogWarning($"Failed to get directory of '{path}': {exc}");
            }
            return null;
        }

        private static async Task<HttpResponseMessage> ExecuteGetRequest(string address, HttpClient httpClient, CancellationToken cancellationToken)
        {
            return await httpClient.GetAsync(address, HttpCompletionOption.ResponseHeadersRead, cancellationToken);
        }

        public bool IsFeedReachable(string feed, int timeoutMilliSeconds, int tryCount)
        {
            logger.LogInfo($"Checking if NuGet feed '{feed}' is reachable...");

            // Configure the HttpClient to be aware of the Dependabot Proxy, if used.
            HttpClientHandler httpClientHandler = new();
            if (dependabotProxy != null)
            {
                httpClientHandler.Proxy = new WebProxy(dependabotProxy.Address);

                if (dependabotProxy.Certificate != null)
                {
                    httpClientHandler.ServerCertificateCustomValidationCallback = (message, cert, chain, _) =>
                    {
                        if (chain is null || cert is null)
                        {
                            var msg = cert is null && chain is null
                                ? "certificate and chain"
                                : chain is null
                                    ? "chain"
                                    : "certificate";
                            logger.LogWarning($"Dependabot proxy certificate validation failed due to missing {msg}");
                            return false;
                        }
                        chain.ChainPolicy.TrustMode = X509ChainTrustMode.CustomRootTrust;
                        chain.ChainPolicy.CustomTrustStore.Add(dependabotProxy.Certificate);
                        return chain.Build(cert);
                    };
                }
            }

            using HttpClient client = new(httpClientHandler);

            for (var i = 0; i < tryCount; i++)
            {
                using var cts = new CancellationTokenSource();
                cts.CancelAfter(timeoutMilliSeconds);
                try
                {
                    logger.LogInfo($"Attempt {i + 1}/{tryCount} to reach NuGet feed '{feed}'.");
                    using var response = ExecuteGetRequest(feed, client, cts.Token).GetAwaiter().GetResult();
                    response.EnsureSuccessStatusCode();
                    logger.LogInfo($"Querying NuGet feed '{feed}' succeeded.");
                    return true;
                }
                catch (Exception exc)
                {
                    if (exc is TaskCanceledException tce &&
                        tce.CancellationToken == cts.Token &&
                        cts.Token.IsCancellationRequested)
                    {
                        logger.LogInfo($"Didn't receive answer from NuGet feed '{feed}' in {timeoutMilliSeconds}ms.");
                        timeoutMilliSeconds *= 2;
                        continue;
                    }

                    logger.LogInfo($"Querying NuGet feed '{feed}' failed. The reason for the failure: {exc.Message}");
                    return false;
                }
            }

            logger.LogWarning($"Didn't receive answer from NuGet feed '{feed}'. Tried it {tryCount} times.");
            return false;
        }


    }
}
