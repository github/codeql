for (int i=0; i<10; i++) {
    for (int j=0; i<10; j++) { // BAD: Potential infinite loop: i should be j
        // do stuff
        if (shouldBreak()) break;
    }
}
