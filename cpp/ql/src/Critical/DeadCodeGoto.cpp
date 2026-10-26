goto err1;
free(pointer); // BAD: this line is unreachable
err1: return -1;

free(pointer); // GOOD: this line is reachable
goto err2;
err2: return -1;
