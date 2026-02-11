int instanceField = 10;
static final int STATIC_CONSTANT = 42;
private String privateField = "data";

void main() {
    processData();
    testStaticAccess();
}

// Test instance methods
void processData() {
    instanceField++;
    updatePrivateField();
}

private void updatePrivateField() {
    privateField = "updated";
}

// Test static method access
static void testStaticAccess() {
    IO.println("Static access test");
}

class NotCompact {
//Test explict class
    void methodNotCompact() {
    }
}