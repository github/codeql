String s = ...;
int n;

n = Integer.parseInt(s); // BAD: NumberFormatException is not caught.

try {
        n = Integer.parseInt(s);
} catch (NumberFormatException e) {  // GOOD: The exception is caught. 
        // Handle the exception
}
