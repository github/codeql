
using System;
using System.Collections.Generic;
using System.Text;

namespace Amazon.Lambda.APIGatewayEvents
{
    public class APIGatewayHttpApiV2ProxyRequest
    {
        public string RawPath { get; set; }

        public string RawQueryString { get; set; }

        public string[] Cookies { get; set; }

        public IDictionary<string, string> Headers { get; set; }

        public IDictionary<string, string> QueryStringParameters { get; set; }

        public ProxyRequestContext RequestContext { get; set; }

        public string Body { get; set; }

        public IDictionary<string, string> PathParameters { get; set; }

        public bool IsBase64Encoded { get; set; }

        public IDictionary<string, string> StageVariables { get; set; }

        public class ProxyRequestContext
        {
            public string AccountId { get; set; }

            public string ApiId { get; set; }
        }
    }

    public class APIGatewayProxyResponse
    {
        public int StatusCode { get; set; }

        public IDictionary<string, string> Headers { get; set; }

        public string Body { get; set; }
    }
}
