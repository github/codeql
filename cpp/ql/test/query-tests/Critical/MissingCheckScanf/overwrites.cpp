int scanf(const char *format, ...);
void use(int value);

void reference_read_on_failure() {
    int value;
    int &alias = value;
    if (scanf("%d", &value) != 1) { // $ Source[cpp/missing-check-scanf]
        value = alias + 1; // $ MISSING: Alert[cpp/missing-check-scanf]
    }
    use(value); // $ Alert[cpp/missing-check-scanf]
}

void reference_with_safe_overwrite() {
    int value;
    int &alias = value;
    if (scanf("%d", &value) != 1) { // $ Source[cpp/missing-check-scanf]
        value = 0;
    }
    use(value); // $ SPURIOUS: Alert[cpp/missing-check-scanf]
}

void scanf_through_alias() {
    int value;
    int *alias = &value;
    if (scanf("%d", alias) != 1) {
        value = 0;
    }
    use(value); // GOOD
}

void reference_output_with_unsafe_alias() {
    int value;
    int &output = value;
    int *alias = &value;
    if (scanf("%d", &output) != 1) { // $ Source[cpp/missing-check-scanf]
        output = *alias + 1; // $ MISSING: Alert[cpp/missing-check-scanf]
    }
    use(output); // $ Alert[cpp/missing-check-scanf]
}

void typedef_reference_output_with_safe_overwrite() {
    typedef int &Output;
    int value;
    Output output = value;
    if (scanf("%d", &output) != 1) { // $ Source[cpp/missing-check-scanf]
        output = 0;
    }
    use(output); // $ SPURIOUS: Alert[cpp/missing-check-scanf]
}
