void sanitize(Fields[] record) {
    //The number of fields here can be put in a const
    for (fieldCtr = 0; field < 7; field++) {
        sanitize(fields[fieldCtr]);
    }
}

#define NUM_FIELDS 7

void process(Fields[] record) {
    //This avoids using a magic constant by using the macro instead
    for (fieldCtr = 0; field < NUM_FIELDS; field++) {
        process(fields[fieldCtr]);
    }
}

