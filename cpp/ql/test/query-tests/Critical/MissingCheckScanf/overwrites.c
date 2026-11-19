typedef struct File FILE;

int scanf(const char *format, ...);
int fscanf(FILE *stream, const char *format, ...);
int sscanf(const char *input, const char *format, ...);
void finish_reading(FILE *stream);
void use(int value);
int maybe(void);

// Independently written regression for github/codeql#12412.
int read_sample(FILE *stream, int fallback) {
    int sample;
    int conversions = fscanf(stream, "%d", &sample);
    if (conversions < 1) {
        sample = fallback;
    }
    finish_reading(stream);
    return sample; // GOOD
}

void overwrite_with_parameter(int fallback) {
    int i;
    if (scanf("%d", &i) < 1) {
        i = fallback;
    }
    use(i); // GOOD
}

void saved_return_value(void) {
    int i;
    int result = scanf("%d", &i);
    if (result != 1) {
        i = 0;
    }
    use(i); // GOOD
}

void successful_branch(void) {
    int i;
    if (scanf("%d", &i) >= 1) {
        use(i); // GOOD
    } else {
        i = 0;
    }
    use(i); // GOOD
}

void overwrite_both_outputs(const char *input) {
    int i, j;
    if (sscanf(input, "%d %d", &i, &j) != 2) {
        i = 0;
        j = 0;
    }
    use(i); // GOOD
    use(j); // GOOD
}

void insufficient_conversion_count(void) {
    int i, j;
    if (scanf("%d %d", &i, &j) < 1) { // $ Source[cpp/missing-check-scanf]
        i = 0;
        j = 0;
    }
    use(i); // GOOD
    use(j); // $ Alert[cpp/missing-check-scanf]
}

void suppressed_conversion(const char *input) {
    int i;
    if (sscanf(input, "%*d %d", &i) != 1) {
        i = 0;
    }
    use(i); // GOOD
}

void count_conversion(const char *input) {
    int i, count;
    if (sscanf(input, "%d %n", &i, &count) != 1) {
        i = 0;
        count = 0;
    }
    use(i); // GOOD
    use(count); // GOOD
}

void conditional_overwrite(void) {
    int i;
    if (scanf("%d", &i) != 1) { // $ Source[cpp/missing-check-scanf]
        if (maybe()) {
            i = 0;
        }
    }
    use(i); // $ Alert[cpp/missing-check-scanf]
}

void overwrite_other_variable(void) {
    int i, j = 1;
    if (scanf("%d", &i) != 1) { // $ Source[cpp/missing-check-scanf]
        j = 0;
    }
    use(i); // $ Alert[cpp/missing-check-scanf]
}

void dependent_overwrite(void) {
    int i;
    if (scanf("%d", &i) != 1) { // $ Source[cpp/missing-check-scanf]
        i = i + 1; // $ Alert[cpp/missing-check-scanf]
    }
    use(i); // GOOD: the unsafe read was reported above
}

void increment_on_failure(void) {
    int i;
    if (scanf("%d", &i) != 1) { // $ Source[cpp/missing-check-scanf]
        ++i; // $ Alert[cpp/missing-check-scanf]
    }
    use(i); // GOOD: the unsafe read was reported above
}

void alias_read_on_failure(void) {
    int i;
    int *alias = &i;
    if (scanf("%d", &i) != 1) { // $ Source[cpp/missing-check-scanf]
        i = *alias + 1; // $ MISSING: Alert[cpp/missing-check-scanf]
    }
    use(i); // $ Alert[cpp/missing-check-scanf]
}

void read_before_overwrite(void) {
    int i;
    if (scanf("%d", &i) != 1) { // $ Source[cpp/missing-check-scanf]
        use(i); // $ Alert[cpp/missing-check-scanf]
        i = 0;
    }
    use(i); // GOOD
}

void check_other_output(void) {
    int i, j;
    scanf("%d", &i); // $ Source[cpp/missing-check-scanf]
    if (scanf("%d", &j) == 1) {
        use(i); // $ Alert[cpp/missing-check-scanf]
    }
}

void unchecked_call_then_overwrite(void) {
    int i;
    scanf("%d", &i); // $ Source[cpp/missing-check-scanf]
    use(i); // $ Alert[cpp/missing-check-scanf]
    if (scanf("%d", &i) != 1) {
        i = 0;
    }
    use(i); // GOOD
}

void overwritten_return_value(void) {
    int i;
    int result = scanf("%d", &i); // $ Source[cpp/missing-check-scanf]
    result = 1;
    if (result != 1) {
        i = 0;
    }
    use(i); // $ Alert[cpp/missing-check-scanf]
}

void only_one_output_is_overwritten(void) {
    int i, j;
    if (scanf("%d %d", &i, &j) != 2) { // $ Source[cpp/missing-check-scanf]
        i = 0;
    }
    use(i); // GOOD
    use(j); // $ Alert[cpp/missing-check-scanf]
}

void conditional_read_in_overwrite(void) {
    int i;
    if (scanf("%d", &i) != 1) { // $ Source[cpp/missing-check-scanf]
        i = maybe() ? i : 0; // $ Alert[cpp/missing-check-scanf]
    }
    use(i); // GOOD: the unsafe read was reported above
}

// Positional arguments are not currently mapped to conversion order.
void positional_partial_fallback(const char *input) {
    int first, second;
    if (sscanf(input, "%2$d %1$d", &first, &second) != 1) { // $ Source[cpp/missing-check-scanf]
        first = 0;
        second = 0;
    }
    use(first); // $ MISSING: Alert[cpp/missing-check-scanf] // BAD: one conversion writes second, not first
    use(second); // $ SPURIOUS: Alert[cpp/missing-check-scanf] // GOOD: initialized by either branch
}

void positional_complete_fallback(const char *input) {
    int first, second;
    if (sscanf(input, "%2$d %1$d", &first, &second) != 2) {
        first = 0;
        second = 0;
    }
    use(first); // GOOD
    use(second); // GOOD
}

void positional_unchecked(const char *input) {
    int first, second;
    sscanf(input, "%2$d %1$d", &first, &second); // $ Source[cpp/missing-check-scanf]
    use(first); // $ Alert[cpp/missing-check-scanf]
    use(second); // $ Alert[cpp/missing-check-scanf]
}

// The assignment count does not prove that a trailing %n was reached.
void count_after_literal(const char *input) {
    int value, count;
    if (sscanf(input, "%d:%n", &value, &count) != 1) {
        value = 0;
        count = 0;
    }
    use(value); // GOOD
    use(count); // $ MISSING: Alert[cpp/missing-check-scanf] // BAD: the colon can fail to match
}

void count_after_suppressed_conversion(const char *input) {
    int value, count;
    if (sscanf(input, "%d %*d%n", &value, &count) != 1) {
        value = 0;
        count = 0;
    }
    use(value); // GOOD
    use(count); // $ MISSING: Alert[cpp/missing-check-scanf] // BAD: the suppressed conversion can fail
}
