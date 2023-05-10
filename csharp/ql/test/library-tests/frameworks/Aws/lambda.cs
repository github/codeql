using System.Net;
using System.Collections.Generic;

using Amazon.Lambda.Core;
using Amazon.Lambda.APIGatewayEvents;


namespace LambdaTests {
    public class Functions {
        public APIGatewayProxyResponse Get(APIGatewayHttpApiV2ProxyRequest request, ILambdaContext context) {
            string body = request.Body;  // source
            string cookie = request.Cookies[0];  // source

            string rawpath = request.RawPath;  // source
            string rawquery = request.RawQueryString;  // source
            request.PathParameters.TryGetValue("x", out var pathparameter);  // source

            string header = request.Headers["test"];  // source
            request.Headers.TryGetValue("test", out var header2);  // source


            return new APIGatewayProxyResponse {
                StatusCode = 200
            };
        }

        public void Logging(ILambdaContext context, string data)
        {
            // logging
            context.Logger.Log($"Log Data :: {data}");
            context.Logger.LogLine($"Log Data :: {data}");
            context.Logger.Log("Information", $"Log Data :: {data}");
            context.Logger.Log(LogLevel.Information, $"Log Data :: {data}");
            context.Logger.LogTrace($"Log Data :: {data}");
            context.Logger.LogDebug($"Log Data :: {data}");
            context.Logger.LogInformation($"Log Data :: {data}");
            context.Logger.LogWarning($"Log Data :: {data}");
            context.Logger.LogError($"Log Data :: {data}");
            context.Logger.LogCritical($"Log Data :: {data}");
        }
    }
}