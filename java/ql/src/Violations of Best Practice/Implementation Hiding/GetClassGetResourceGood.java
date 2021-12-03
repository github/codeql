package framework;
class Address {
    public URL getPostalCodes() {
        // GOOD: The call is always made on an object of the same type.
        return Address.class.getResource("postal-codes.csv");
    }
}

package client;
class UKAddress extends Address {
    public void convert() {
        // Looks up "framework/postal-codes.csv"
        new Address().getPostalCodes();
        // Looks up "framework/postal-codes.csv"
        new UKAddress().getPostalCodes();
    }
}