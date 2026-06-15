import javax.crypto.KDF;
import javax.crypto.spec.HKDFParameterSpec;

public class KDFDataflowTest {
    public static String source(String label) {
        return "tainted";
    }

    public static void sink(Object o) {}

    public static void main(String[] args) throws Exception {
        String userInput = source("");
        byte[] taintedBytes = userInput.getBytes();

        testBuilderPattern(taintedBytes);
        testSeparateBuilder(taintedBytes);
        testKDFWithSalt(taintedBytes);
        testStaticParameterSpec(taintedBytes);
        testCleanUsage();
    }

    public static void testBuilderPattern(byte[] taintedIKM) throws Exception {
        HKDFParameterSpec.Builder builder = HKDFParameterSpec.ofExtract();
        builder.addIKM(taintedIKM);
        HKDFParameterSpec spec = builder.thenExpand("info".getBytes(), 32);

        KDF kdf = KDF.getInstance("HKDF-SHA256");
        byte[] result = kdf.deriveData(spec);
        sink(result); // $ hasTaintFlow
    }

    public static void testSeparateBuilder(byte[] taintedIKM) throws Exception {
        HKDFParameterSpec.Builder builder1 = HKDFParameterSpec.ofExtract();
        HKDFParameterSpec.Builder builder2 = builder1.addIKM(taintedIKM);
        HKDFParameterSpec spec = builder2.thenExpand("info".getBytes(), 32);

        KDF kdf = KDF.getInstance("HKDF-SHA256");
        byte[] result = kdf.deriveData(spec);
        sink(result); // $ hasTaintFlow
    }

    public static void testKDFWithSalt(byte[] taintedIKM) throws Exception {
        HKDFParameterSpec.Builder builder = HKDFParameterSpec.ofExtract();
        builder.addIKM(taintedIKM);
        builder.addSalt("sensitive-salt".getBytes());
        HKDFParameterSpec spec = builder.thenExpand("info".getBytes(), 32);

        KDF kdf = KDF.getInstance("HKDF-SHA256");
        byte[] result = kdf.deriveData(spec);
        sink(result); // $ hasTaintFlow
    }

    public static void testStaticParameterSpec(byte[] taintedIKM) throws Exception {
        javax.crypto.spec.SecretKeySpec secretKey = new javax.crypto.spec.SecretKeySpec(taintedIKM, "AES");
        HKDFParameterSpec spec = HKDFParameterSpec.expandOnly(
            secretKey, "info".getBytes(), 32);

        KDF kdf = KDF.getInstance("HKDF-SHA256");
        byte[] result = kdf.deriveData(spec);
        sink(result); // $ hasTaintFlow
    }

    public static void testCleanUsage() throws Exception {
        byte[] cleanKeyMaterial = "static-key-material".getBytes();

        HKDFParameterSpec.Builder builder = HKDFParameterSpec.ofExtract();
        builder.addIKM(cleanKeyMaterial);
        HKDFParameterSpec spec = builder.thenExpand("info".getBytes(), 32);

        KDF kdf = KDF.getInstance("HKDF-SHA256");
        byte[] cleanResult = kdf.deriveData(spec);
        sink(cleanResult); // Safe - no taint
    }

    public static void testThenExpand(byte[] cleanIKM) throws Exception {
        String userInput = source("");
        byte[] taintedInfo = userInput.getBytes();

        HKDFParameterSpec.Builder builder = HKDFParameterSpec.ofExtract();
        builder.addIKM(cleanIKM);
        HKDFParameterSpec spec = builder.thenExpand(taintedInfo, 32);

        KDF kdf = KDF.getInstance("HKDF-SHA256");
        byte[] result = kdf.deriveData(spec);
        sink(result); // $ hasTaintFlow
    }
}