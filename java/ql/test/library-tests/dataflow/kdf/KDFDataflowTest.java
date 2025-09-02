import javax.crypto.KDF;
import javax.crypto.spec.HKDFParameterSpec;

public class KDFDataflowTest {
    public static void main(String[] args) throws Exception {
        String userInput = args[0]; // source
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
        sink(result); // should flag
    }

    public static void testSeparateBuilder(byte[] taintedIKM) throws Exception {
        HKDFParameterSpec.Builder builder1 = HKDFParameterSpec.ofExtract();
        HKDFParameterSpec.Builder builder2 = builder1.addIKM(taintedIKM);
        HKDFParameterSpec spec = builder2.thenExpand("info".getBytes(), 32);

        KDF kdf = KDF.getInstance("HKDF-SHA256");
        byte[] result = kdf.deriveData(spec);
        sink(result); // should flag
    }

    public static void sink(Object o) {}

    public static void testKDFWithSalt(byte[] taintedIKM) throws Exception {
        HKDFParameterSpec.Builder builder = HKDFParameterSpec.ofExtract();
        builder.addIKM(taintedIKM);
        builder.addSalt("sensitive-salt".getBytes());
        HKDFParameterSpec spec = builder.thenExpand("info".getBytes(), 32);

        KDF kdf = KDF.getInstance("HKDF-SHA256");
        byte[] result = kdf.deriveData(spec);
        sink(result); // should flag
    }

    public static void testStaticParameterSpec(byte[] taintedIKM) throws Exception {
        javax.crypto.spec.SecretKeySpec secretKey = new javax.crypto.spec.SecretKeySpec(taintedIKM, "AES");
        HKDFParameterSpec spec = HKDFParameterSpec.expandOnly(
            secretKey, "info".getBytes(), 32);

        KDF kdf = KDF.getInstance("HKDF-SHA256");
        byte[] result = kdf.deriveData(spec);
        sink(result); // should flag
    }

    public static void testCleanUsage() throws Exception {
        byte[] cleanKeyMaterial = "static-key-material".getBytes();

        HKDFParameterSpec.Builder builder = HKDFParameterSpec.ofExtract();
        builder.addIKM(cleanKeyMaterial); // clean input
        HKDFParameterSpec spec = builder.thenExpand("info".getBytes(), 32);

        KDF kdf = KDF.getInstance("HKDF-SHA256");
        byte[] cleanResult = kdf.deriveData(spec);
        sink(cleanResult); // should NOT flag - no taint source
    }
}