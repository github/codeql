// semmle-extractor-options: /r:System.Security.Cryptography.X509Certificates.dll /r:System.Net.dll /r:System.Net.Http.dll /r:System.Net.Security.dll /r:System.Linq.dll /r:System.Net.Primitives.dll
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Net.Http.Headers;
using System.Net.Security;
using System.Security.Cryptography.X509Certificates;
using System.Text;
using System.Threading.Tasks;

namespace System.Net
{
    static class ServicePointManager
    {
        public static RemoteCertificateValidationCallback ServerCertificateValidationCallback { get; set; }
    }
}

namespace CertificateValidationDisabled
{
    class Program
    {
        static void Main(string[] args)
        {
            // BAD
            ServicePointManager.ServerCertificateValidationCallback += (sender, cert, chain, sslPolicyErrors) => { return true; };
            ServicePointManager.ServerCertificateValidationCallback += (a, b, c, d) => { return true; };
            ServicePointManager.ServerCertificateValidationCallback += (a, b, c, d) => true;
            ServicePointManager.ServerCertificateValidationCallback += delegate { return true; };

            // BAD
            ServicePointManager.ServerCertificateValidationCallback = new RemoteCertificateValidationCallback(AcceptAllCertifications);

            var m = new Program();
            // BAD
            ServicePointManager.ServerCertificateValidationCallback = new RemoteCertificateValidationCallback(m.AcceptAllCertificationsNonStatic);
            m.Test();

            // GOOD
            ServicePointManager.ServerCertificateValidationCallback += (a, b, c, d) =>
            {
                int x = 20;
                if (x < 100)
                {
                    return false;
                }
                else
                {
                    return true;
                }
            };

            // GOOD
            ServicePointManager.ServerCertificateValidationCallback += delegate (
                object sender,
                X509Certificate cert,
                X509Chain chain,
                SslPolicyErrors sslPolicyErrors)
            {
                if (cert == null)
                {
                    return false;
                }

                if (sslPolicyErrors != SslPolicyErrors.None)
                {
                    return false;
                }

                return true;
            };
        }

        void Test()
        {
            // BAD
            ServicePointManager.ServerCertificateValidationCallback = new RemoteCertificateValidationCallback(this.AcceptAllCertificationsNonStatic);
        }

        public static bool AcceptAllCertifications(object sender, X509Certificate certification, X509Chain chain, SslPolicyErrors sslPolicyErrors)
        {
            return true;
        }

        public bool AcceptAllCertificationsNonStatic(object sender, X509Certificate certification, X509Chain chain, SslPolicyErrors sslPolicyErrors)
        {
            return true;
        }
    }
}
