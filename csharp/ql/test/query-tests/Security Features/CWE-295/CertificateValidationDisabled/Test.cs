// semmle-extractor-options: /nostdlib /noconfig /r:${env.windir}\Microsoft.NET\Framework64\v4.0.30319\mscorlib.dll /r:${env.windir}\Microsoft.NET\Framework64\v4.0.30319\System.dll /r:${env.windir}\Microsoft.NET\Framework64\v4.0.30319\System.Net.dll /r:${env.windir}\Microsoft.NET\Framework64\v4.0.30319\System.Net.Http.dll /r:${env.windir}\Microsoft.NET\Framework64\v4.0.30319\System.Linq.dll
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

namespace SemmleTestCertValidation
{
    class Program
    {
        static void Main(string[] args)
        {
            // Bad (Simple)
            ServicePointManager.ServerCertificateValidationCallback += (sender, cert, chain, sslPolicyErrors) => { return true; };
            ServicePointManager.ServerCertificateValidationCallback += (a, b, c, d) => { return true; };
            ServicePointManager.ServerCertificateValidationCallback += (a, b, c, d) => true;
            ServicePointManager.ServerCertificateValidationCallback += delegate { return true; };

            // Bad (Simple Function)
            ServicePointManager.ServerCertificateValidationCallback = new RemoteCertificateValidationCallback(AcceptAllCertifications);

            var m = new Program();
            ServicePointManager.ServerCertificateValidationCallback = new RemoteCertificateValidationCallback(m.AcceptAllCertificationsNonStatic);
            m.Test();

            // Don't know
            ServicePointManager.ServerCertificateValidationCallback += (a, b, c, d) => {
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

            // Good
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
