// This file contains auto-generated code.
// Generated from `Amazon.Lambda.APIGatewayEvents, Version=1.0.0.0, Culture=neutral, PublicKeyToken=885c28607f98e604`.
namespace Amazon
{
    namespace Lambda
    {
        namespace APIGatewayEvents
        {
            public class APIGatewayCustomAuthorizerContext : System.Collections.Generic.Dictionary<string, object>
            {
                public bool? BoolKey { get => throw null; set { } }
                public System.Collections.Generic.Dictionary<string, string> Claims { get => throw null; set { } }
                public APIGatewayCustomAuthorizerContext() => throw null;
                public int? NumKey { get => throw null; set { } }
                public string PrincipalId { get => throw null; set { } }
                public string StringKey { get => throw null; set { } }
            }
            public class APIGatewayCustomAuthorizerContextOutput : System.Collections.Generic.Dictionary<string, object>
            {
                public bool? BoolKey { get => throw null; set { } }
                public APIGatewayCustomAuthorizerContextOutput() => throw null;
                public int? NumKey { get => throw null; set { } }
                public string StringKey { get => throw null; set { } }
            }
            public class APIGatewayCustomAuthorizerPolicy
            {
                public APIGatewayCustomAuthorizerPolicy() => throw null;
                public class IAMPolicyStatement
                {
                    public System.Collections.Generic.HashSet<string> Action { get => throw null; set { } }
                    public IAMPolicyStatement() => throw null;
                    public string Effect { get => throw null; set { } }
                    public System.Collections.Generic.HashSet<string> Resource { get => throw null; set { } }
                }
                public System.Collections.Generic.List<Amazon.Lambda.APIGatewayEvents.APIGatewayCustomAuthorizerPolicy.IAMPolicyStatement> Statement { get => throw null; set { } }
                public string Version { get => throw null; set { } }
            }
            public class APIGatewayCustomAuthorizerRequest
            {
                public string AuthorizationToken { get => throw null; set { } }
                public APIGatewayCustomAuthorizerRequest() => throw null;
                public System.Collections.Generic.IDictionary<string, string> Headers { get => throw null; set { } }
                public string HttpMethod { get => throw null; set { } }
                public string MethodArn { get => throw null; set { } }
                public string Path { get => throw null; set { } }
                public System.Collections.Generic.IDictionary<string, string> PathParameters { get => throw null; set { } }
                public System.Collections.Generic.IDictionary<string, string> QueryStringParameters { get => throw null; set { } }
                public Amazon.Lambda.APIGatewayEvents.APIGatewayProxyRequest.ProxyRequestContext RequestContext { get => throw null; set { } }
                public System.Collections.Generic.IDictionary<string, string> StageVariables { get => throw null; set { } }
                public string Type { get => throw null; set { } }
            }
            public class APIGatewayCustomAuthorizerResponse
            {
                public Amazon.Lambda.APIGatewayEvents.APIGatewayCustomAuthorizerContextOutput Context { get => throw null; set { } }
                public APIGatewayCustomAuthorizerResponse() => throw null;
                public Amazon.Lambda.APIGatewayEvents.APIGatewayCustomAuthorizerPolicy PolicyDocument { get => throw null; set { } }
                public string PrincipalID { get => throw null; set { } }
                public string UsageIdentifierKey { get => throw null; set { } }
            }
            public class APIGatewayCustomAuthorizerV2IamResponse
            {
                public System.Collections.Generic.Dictionary<string, object> Context { get => throw null; set { } }
                public APIGatewayCustomAuthorizerV2IamResponse() => throw null;
                public Amazon.Lambda.APIGatewayEvents.APIGatewayCustomAuthorizerPolicy PolicyDocument { get => throw null; set { } }
                public string PrincipalID { get => throw null; set { } }
            }
            public class APIGatewayCustomAuthorizerV2Request
            {
                public System.Collections.Generic.List<string> Cookies { get => throw null; set { } }
                public APIGatewayCustomAuthorizerV2Request() => throw null;
                public System.Collections.Generic.Dictionary<string, string> Headers { get => throw null; set { } }
                public System.Collections.Generic.List<string> IdentitySource { get => throw null; set { } }
                public System.Collections.Generic.Dictionary<string, string> PathParameters { get => throw null; set { } }
                public System.Collections.Generic.Dictionary<string, string> QueryStringParameters { get => throw null; set { } }
                public string RawPath { get => throw null; set { } }
                public string RawQueryString { get => throw null; set { } }
                public Amazon.Lambda.APIGatewayEvents.APIGatewayHttpApiV2ProxyRequest.ProxyRequestContext RequestContext { get => throw null; set { } }
                public string RouteArn { get => throw null; set { } }
                public string RouteKey { get => throw null; set { } }
                public System.Collections.Generic.Dictionary<string, string> StageVariables { get => throw null; set { } }
                public string Type { get => throw null; set { } }
            }
            public class APIGatewayCustomAuthorizerV2SimpleResponse
            {
                public System.Collections.Generic.Dictionary<string, object> Context { get => throw null; set { } }
                public APIGatewayCustomAuthorizerV2SimpleResponse() => throw null;
                public bool IsAuthorized { get => throw null; set { } }
            }
            public class APIGatewayHttpApiV2ProxyRequest
            {
                public class AuthorizerDescription
                {
                    public class CognitoIdentityDescription
                    {
                        public System.Collections.Generic.IList<string> AMR { get => throw null; set { } }
                        public CognitoIdentityDescription() => throw null;
                        public string IdentityId { get => throw null; set { } }
                        public string IdentityPoolId { get => throw null; set { } }
                    }
                    public AuthorizerDescription() => throw null;
                    public Amazon.Lambda.APIGatewayEvents.APIGatewayHttpApiV2ProxyRequest.AuthorizerDescription.IAMDescription IAM { get => throw null; set { } }
                    public class IAMDescription
                    {
                        public string AccessKey { get => throw null; set { } }
                        public string AccountId { get => throw null; set { } }
                        public string CallerId { get => throw null; set { } }
                        public Amazon.Lambda.APIGatewayEvents.APIGatewayHttpApiV2ProxyRequest.AuthorizerDescription.CognitoIdentityDescription CognitoIdentity { get => throw null; set { } }
                        public IAMDescription() => throw null;
                        public string PrincipalOrgId { get => throw null; set { } }
                        public string UserARN { get => throw null; set { } }
                        public string UserId { get => throw null; set { } }
                    }
                    public Amazon.Lambda.APIGatewayEvents.APIGatewayHttpApiV2ProxyRequest.AuthorizerDescription.JwtDescription Jwt { get => throw null; set { } }
                    public class JwtDescription
                    {
                        public System.Collections.Generic.IDictionary<string, string> Claims { get => throw null; set { } }
                        public JwtDescription() => throw null;
                        public string[] Scopes { get => throw null; set { } }
                    }
                    public System.Collections.Generic.IDictionary<string, object> Lambda { get => throw null; set { } }
                }
                public string Body { get => throw null; set { } }
                public class ClientCertValidity
                {
                    public ClientCertValidity() => throw null;
                    public string NotAfter { get => throw null; set { } }
                    public string NotBefore { get => throw null; set { } }
                }
                public string[] Cookies { get => throw null; set { } }
                public APIGatewayHttpApiV2ProxyRequest() => throw null;
                public System.Collections.Generic.IDictionary<string, string> Headers { get => throw null; set { } }
                public class HttpDescription
                {
                    public HttpDescription() => throw null;
                    public string Method { get => throw null; set { } }
                    public string Path { get => throw null; set { } }
                    public string Protocol { get => throw null; set { } }
                    public string SourceIp { get => throw null; set { } }
                    public string UserAgent { get => throw null; set { } }
                }
                public bool IsBase64Encoded { get => throw null; set { } }
                public System.Collections.Generic.IDictionary<string, string> PathParameters { get => throw null; set { } }
                public class ProxyRequestAuthentication
                {
                    public Amazon.Lambda.APIGatewayEvents.APIGatewayHttpApiV2ProxyRequest.ProxyRequestClientCert ClientCert { get => throw null; set { } }
                    public ProxyRequestAuthentication() => throw null;
                }
                public class ProxyRequestClientCert
                {
                    public string ClientCertPem { get => throw null; set { } }
                    public ProxyRequestClientCert() => throw null;
                    public string IssuerDN { get => throw null; set { } }
                    public string SerialNumber { get => throw null; set { } }
                    public string SubjectDN { get => throw null; set { } }
                    public Amazon.Lambda.APIGatewayEvents.APIGatewayHttpApiV2ProxyRequest.ClientCertValidity Validity { get => throw null; set { } }
                }
                public class ProxyRequestContext
                {
                    public string AccountId { get => throw null; set { } }
                    public string ApiId { get => throw null; set { } }
                    public Amazon.Lambda.APIGatewayEvents.APIGatewayHttpApiV2ProxyRequest.ProxyRequestAuthentication Authentication { get => throw null; set { } }
                    public Amazon.Lambda.APIGatewayEvents.APIGatewayHttpApiV2ProxyRequest.AuthorizerDescription Authorizer { get => throw null; set { } }
                    public ProxyRequestContext() => throw null;
                    public string DomainName { get => throw null; set { } }
                    public string DomainPrefix { get => throw null; set { } }
                    public Amazon.Lambda.APIGatewayEvents.APIGatewayHttpApiV2ProxyRequest.HttpDescription Http { get => throw null; set { } }
                    public string RequestId { get => throw null; set { } }
                    public string RouteId { get => throw null; set { } }
                    public string RouteKey { get => throw null; set { } }
                    public string Stage { get => throw null; set { } }
                    public string Time { get => throw null; set { } }
                    public long TimeEpoch { get => throw null; set { } }
                }
                public System.Collections.Generic.IDictionary<string, string> QueryStringParameters { get => throw null; set { } }
                public string RawPath { get => throw null; set { } }
                public string RawQueryString { get => throw null; set { } }
                public Amazon.Lambda.APIGatewayEvents.APIGatewayHttpApiV2ProxyRequest.ProxyRequestContext RequestContext { get => throw null; set { } }
                public string RouteKey { get => throw null; set { } }
                public System.Collections.Generic.IDictionary<string, string> StageVariables { get => throw null; set { } }
                public string Version { get => throw null; set { } }
            }
            public class APIGatewayHttpApiV2ProxyResponse
            {
                public string Body { get => throw null; set { } }
                public string[] Cookies { get => throw null; set { } }
                public APIGatewayHttpApiV2ProxyResponse() => throw null;
                public System.Collections.Generic.IDictionary<string, string> Headers { get => throw null; set { } }
                public bool IsBase64Encoded { get => throw null; set { } }
                public void SetHeaderValues(string headerName, string value, bool append) => throw null;
                public void SetHeaderValues(string headerName, System.Collections.Generic.IEnumerable<string> values, bool append) => throw null;
                public int StatusCode { get => throw null; set { } }
            }
            public class APIGatewayProxyRequest
            {
                public string Body { get => throw null; set { } }
                public class ClientCertValidity
                {
                    public ClientCertValidity() => throw null;
                    public string NotAfter { get => throw null; set { } }
                    public string NotBefore { get => throw null; set { } }
                }
                public APIGatewayProxyRequest() => throw null;
                public System.Collections.Generic.IDictionary<string, string> Headers { get => throw null; set { } }
                public string HttpMethod { get => throw null; set { } }
                public bool IsBase64Encoded { get => throw null; set { } }
                public System.Collections.Generic.IDictionary<string, System.Collections.Generic.IList<string>> MultiValueHeaders { get => throw null; set { } }
                public System.Collections.Generic.IDictionary<string, System.Collections.Generic.IList<string>> MultiValueQueryStringParameters { get => throw null; set { } }
                public string Path { get => throw null; set { } }
                public System.Collections.Generic.IDictionary<string, string> PathParameters { get => throw null; set { } }
                public class ProxyRequestClientCert
                {
                    public string ClientCertPem { get => throw null; set { } }
                    public ProxyRequestClientCert() => throw null;
                    public string IssuerDN { get => throw null; set { } }
                    public string SerialNumber { get => throw null; set { } }
                    public string SubjectDN { get => throw null; set { } }
                    public Amazon.Lambda.APIGatewayEvents.APIGatewayProxyRequest.ClientCertValidity Validity { get => throw null; set { } }
                }
                public class ProxyRequestContext
                {
                    public string AccountId { get => throw null; set { } }
                    public string ApiId { get => throw null; set { } }
                    public Amazon.Lambda.APIGatewayEvents.APIGatewayCustomAuthorizerContext Authorizer { get => throw null; set { } }
                    public long ConnectedAt { get => throw null; set { } }
                    public string ConnectionId { get => throw null; set { } }
                    public ProxyRequestContext() => throw null;
                    public string DomainName { get => throw null; set { } }
                    public string DomainPrefix { get => throw null; set { } }
                    public string Error { get => throw null; set { } }
                    public string EventType { get => throw null; set { } }
                    public string ExtendedRequestId { get => throw null; set { } }
                    public string HttpMethod { get => throw null; set { } }
                    public Amazon.Lambda.APIGatewayEvents.APIGatewayProxyRequest.RequestIdentity Identity { get => throw null; set { } }
                    public string IntegrationLatency { get => throw null; set { } }
                    public string MessageDirection { get => throw null; set { } }
                    public string MessageId { get => throw null; set { } }
                    public string OperationName { get => throw null; set { } }
                    public string Path { get => throw null; set { } }
                    public string RequestId { get => throw null; set { } }
                    public string RequestTime { get => throw null; set { } }
                    public long RequestTimeEpoch { get => throw null; set { } }
                    public string ResourceId { get => throw null; set { } }
                    public string ResourcePath { get => throw null; set { } }
                    public string RouteKey { get => throw null; set { } }
                    public string Stage { get => throw null; set { } }
                    public string Status { get => throw null; set { } }
                }
                public System.Collections.Generic.IDictionary<string, string> QueryStringParameters { get => throw null; set { } }
                public Amazon.Lambda.APIGatewayEvents.APIGatewayProxyRequest.ProxyRequestContext RequestContext { get => throw null; set { } }
                public class RequestIdentity
                {
                    public string AccessKey { get => throw null; set { } }
                    public string AccountId { get => throw null; set { } }
                    public string ApiKey { get => throw null; set { } }
                    public string ApiKeyId { get => throw null; set { } }
                    public string Caller { get => throw null; set { } }
                    public Amazon.Lambda.APIGatewayEvents.APIGatewayProxyRequest.ProxyRequestClientCert ClientCert { get => throw null; set { } }
                    public string CognitoAuthenticationProvider { get => throw null; set { } }
                    public string CognitoAuthenticationType { get => throw null; set { } }
                    public string CognitoIdentityId { get => throw null; set { } }
                    public string CognitoIdentityPoolId { get => throw null; set { } }
                    public RequestIdentity() => throw null;
                    public string SourceIp { get => throw null; set { } }
                    public string User { get => throw null; set { } }
                    public string UserAgent { get => throw null; set { } }
                    public string UserArn { get => throw null; set { } }
                }
                public string Resource { get => throw null; set { } }
                public System.Collections.Generic.IDictionary<string, string> StageVariables { get => throw null; set { } }
            }
            public class APIGatewayProxyResponse
            {
                public string Body { get => throw null; set { } }
                public APIGatewayProxyResponse() => throw null;
                public System.Collections.Generic.IDictionary<string, string> Headers { get => throw null; set { } }
                public bool IsBase64Encoded { get => throw null; set { } }
                public System.Collections.Generic.IDictionary<string, System.Collections.Generic.IList<string>> MultiValueHeaders { get => throw null; set { } }
                public int StatusCode { get => throw null; set { } }
            }
        }
    }
}
