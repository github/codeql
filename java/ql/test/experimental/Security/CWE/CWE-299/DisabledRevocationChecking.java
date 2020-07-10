import java.security.KeyStore;
import java.security.cert.CertPath;
import java.security.cert.CertPathValidator;
import java.security.cert.PKIXCertPathChecker;
import java.security.cert.PKIXParameters;
import java.security.cert.PKIXRevocationChecker;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
import java.util.List;

public class DisabledRevocationChecking {

  private boolean flag = true;

  public void disableRevocationChecking() {
    flag = false;
  }

  public void testDisabledRevocationChecking(KeyStore cacerts, CertPath certPath) throws Exception {
    disableRevocationChecking();
    validate(cacerts, certPath);
  }

  public void validate(KeyStore cacerts, CertPath certPath) throws Exception {
    CertPathValidator validator = CertPathValidator.getInstance("PKIX");
    PKIXParameters params = new PKIXParameters(cacerts);
    params.setRevocationEnabled(flag);
    validator.validate(certPath, params);
  }

  public void testSettingRevocationCheckerWithCollectionsSingletonList(KeyStore cacerts, CertPath certPath) throws Exception {
    CertPathValidator validator = CertPathValidator.getInstance("PKIX");
    PKIXParameters params = new PKIXParameters(cacerts);
    params.setRevocationEnabled(false);
    PKIXRevocationChecker checker = (PKIXRevocationChecker) validator.getRevocationChecker();
    params.setCertPathCheckers(Collections.singletonList(checker));
    validator.validate(certPath, params);
  }

  public void testSettingRevocationCheckerWithArraysAsList(KeyStore cacerts, CertPath certPath) throws Exception {
    CertPathValidator validator = CertPathValidator.getInstance("PKIX");
    PKIXParameters params = new PKIXParameters(cacerts);
    params.setRevocationEnabled(false);
    PKIXRevocationChecker checker = (PKIXRevocationChecker) validator.getRevocationChecker();
    params.setCertPathCheckers(Arrays.asList(checker));
    validator.validate(certPath, params);
  }

  public void testSettingRevocationCheckerWithAddingToArrayList(KeyStore cacerts, CertPath certPath) throws Exception {
    CertPathValidator validator = CertPathValidator.getInstance("PKIX");
    PKIXParameters params = new PKIXParameters(cacerts);
    params.setRevocationEnabled(false);
    PKIXRevocationChecker checker = (PKIXRevocationChecker) validator.getRevocationChecker();
    List<PKIXCertPathChecker> checkers = new ArrayList<>();
    checkers.add(checker);
    params.setCertPathCheckers(checkers);
    validator.validate(certPath, params);
  }

  public void testSettingRevocationCheckerWithListOf(KeyStore cacerts, CertPath certPath) throws Exception {
    CertPathValidator validator = CertPathValidator.getInstance("PKIX");
    PKIXParameters params = new PKIXParameters(cacerts);
    params.setRevocationEnabled(false);
    PKIXRevocationChecker checker = (PKIXRevocationChecker) validator.getRevocationChecker();
    List<PKIXCertPathChecker> checkers = List.of(checker);
    params.setCertPathCheckers(checkers);
    validator.validate(certPath, params);
  }

  public void testAddingRevocationChecker(KeyStore cacerts, CertPath certPath) throws Exception {
    CertPathValidator validator = CertPathValidator.getInstance("PKIX");
    PKIXParameters params = new PKIXParameters(cacerts);
    params.setRevocationEnabled(false);
    PKIXRevocationChecker checker = (PKIXRevocationChecker) validator.getRevocationChecker();
    params.addCertPathChecker(checker);
    validator.validate(certPath, params);
  }

}
