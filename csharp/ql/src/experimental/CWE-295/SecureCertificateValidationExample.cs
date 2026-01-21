ServicePointManager.ServerCertificateValidationCallback += 
        (sender, cert, chain, sslPolicyErrors) => {
            if (cert.Issuer == "TrustedIssuer" /* && other conditions */)
                return true;
            return false;
        };