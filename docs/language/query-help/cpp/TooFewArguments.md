# Call to function with fewer arguments than declared parameters

```
ID: cpp/too-few-arguments
Kind: problem
Severity: error
Precision: very-high
Tags: correctness maintainability security

```
[Click to see the query in the CodeQL repository](https://github.com/github/codeql/tree/main/cpp/ql/src/Likely%20Bugs/Underspecified%20Functions/TooFewArguments.ql)

A function is called with fewer arguments than there are parameters of the function.

This may indicate that an incorrect function is being called, or that the signature (parameter list) of the called function is not known to the author.

In C, function calls generally need to provide the same number of arguments as there are arguments to the function. (Variadic functions can accept additional arguments.) Providing fewer arguments than there are parameters is extremely dangerous, as the called function will nevertheless try to obtain the missing arguments' values, either from the stack or from machine registers. As a result, the function may behave unpredictably.

If the called function *modifies* a parameter corresponding to a missing argument, it may alter the state of the program upon its return. An attacker could use this to, for example, alter the control flow of the program to access forbidden resources.


## Recommendation
Call the function with the correct number of arguments.


## Example

```c
void one_argument();

void calls() {
	one_argument(1); // GOOD: `one_argument` will accept and use the argument
	
	one_argument(); // BAD: `one_argument` will receive an undefined value
}

void one_argument(int x);

```

## References
* SEI CERT C Coding Standard: [ DCL20-C. Explicitly specify void when a function accepts no arguments ](https://wiki.sei.cmu.edu/confluence/display/c/DCL20-C.+Explicitly+specify+void+when+a+function+accepts+no+arguments)