import extlib.GenericTypeJava;
import extlib.RawTypesInSignatureJava;

class JavaUser {

  public static void user() {

    GenericTypeJava rawGt = GenericTypeJava.getRaw();
    RawTypesInSignatureJava rtis = new RawTypesInSignatureJava();
    rtis.directParameter(null);

  }

}
