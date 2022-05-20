package p;

enum SomeEnum {

    FOO("input");

    private String input;

    private SomeEnum(String input) {
        this.input = input;
    }

    public String getValue() {
        return input;
    }

}