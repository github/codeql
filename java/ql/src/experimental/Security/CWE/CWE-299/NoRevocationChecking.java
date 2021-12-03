public void validateUnsafe(KeyStore cacerts, CertPath chain) throws Exception {
    CertPathValidator validator = CertPathValidator.getInstance("PKIX");
    PKIXParameters params = new PKIXParameters(cacerts);
    params.setRevocationEnabled(false);
    validator.validate(chain, params);
}