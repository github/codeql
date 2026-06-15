for (int i=0; i<10; i++) {
    for (int j=0; j<10; j++) { // GOOD: correct variable j
        // do stuff
        if (shouldBreak()) break;
    }
}
