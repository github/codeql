public void validate(KeyStore cacerts, CertPath certPath) throws Exception {
    CertPathValidator validator = CertPathValidator.getInstance("PKIX");
    PKIXParameters params = new PKIXParameters(cacerts);
    params.setRevocationEnabled(false);
    PKIXRevocationChecker checker = (PKIXRevocationChecker) validator.getRevocationChecker();
    checker.setOcspResponder(OCSP_RESPONDER_URL);
    checker.setOcspResponderCert(OCSP_RESPONDER_CERT);
    params.addCertPathChecker(checker);
    validator.validate(certPath, params);
}