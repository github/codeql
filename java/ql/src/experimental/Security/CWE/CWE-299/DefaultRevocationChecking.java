public void validate(KeyStore cacerts, CertPath chain) throws Exception {
    CertPathValidator validator = CertPathValidator.getInstance("PKIX");
    PKIXParameters params = new PKIXParameters(cacerts);
    validator.validate(chain, params);
}