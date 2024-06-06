import okhttp3.OkHttpClient;
import okhttp3.CertificatePinner;
import okhttp3.Request;

class Test {
    void test1() throws Exception {
        CertificatePinner certificatePinner = new CertificatePinner.Builder()
                .add("good.example.com", "sha256/AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=")
                .build();
        OkHttpClient client =
                new OkHttpClient.Builder().certificatePinner(certificatePinner).build();

        client.newCall(new Request.Builder().url("https://good.example.com").build()).execute();
        client.newCall(new Request.Builder().url("https://bad.example.com").build()).execute(); // $hasUntrustedResult
        client.newCall(new Request.Builder().url("classpath:example/directory/test.class").build())
                .execute();
        client.newCall(new Request.Builder().url("file:///example/file").build()).execute();
        client.newCall(
                new Request.Builder().url("jar:file:///C:/example/test.jar!/test.xml").build())
                .execute();
    }
}
