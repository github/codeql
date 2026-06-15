public class Test {
    void test_case_label_only_in_switch(int p) {
        switch (p) {
            case 1:
            case 2:
                break;
        }
        notcaselabelnotinswitch: for (;;) {}
    }

    void test_noncase_label_in_switch(int p) {
        switch (p) {
            case 1:
                notcaselabel1:; // $ Alert | Possibly erroneous non-case label in switch statement. The case keyword might be missing.
                break;
            case 2:
                notcaselabel2: for (;;) { break notcaselabel2; } // $ Alert | Confusing non-case label in switch statement.
                break;
        }
    }
}
