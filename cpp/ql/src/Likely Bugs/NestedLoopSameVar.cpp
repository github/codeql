int x1 = 0;
for (x1 = 0; x1 < 100; x1++) {
    int x2 = 0;
    for (x1 = 0; x1 < 300; x1++) {
    // this is most likely a typo
    // the outer loop will exit immediately
    } 
}

for (x1 = 0; x1 < 100; x1++) {
  if(x1 == 10 && condition) {
    for (; x1 < 75; x1++) {
      // this should be written as a while loop
    }   
  }
}
