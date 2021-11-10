package p;

public final class InnerHolder {

    private class Context {
        private String value;

        Context(String value) {
            this.value = value;
        }

        public String getValue() {
            return value;
        }
    }

    private Context context = null;

    public void setContext(String value) {
        context = new Context(value);
    }

    public void explicitSetContext(String value) {
        this.context = new Context(value);
    }

    public String getValue() {
        return context.getValue();
    }

}