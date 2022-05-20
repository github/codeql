package framework;
class Address {
    public URL getPostalCodes() {
        // AVOID: The call is made on the run-time type of 'this'.
        return this.getClass().getResource("postal-codes.csv");
    }
}

package client;
class UKAddress extends Address {
    public void convert() {
        // Looks up "framework/postal-codes.csv"
        new Address().getPostalCodes();
        // Looks up "client/postal-codes.csv"
        new UKAddress().getPostalCodes();
    }
}