# Potentially overflowing call to snprintf

```
ID: cpp/overflowing-snprintf
Kind: problem
Severity: warning
Precision: high
Tags: reliability correctness security

```
[Click to see the query in the CodeQL repository](https://github.com/github/codeql/tree/main/cpp/ql/src/Likely%20Bugs/Format/SnprintfOverflow.ql)

The return value of a call to `snprintf` is the number of characters that *would have* been written to the buffer assuming there was sufficient space. In the event that the operation reaches the end of the buffer and more than one character is discarded, the return value will be greater than the buffer size. This can cause incorrect behaviour, for example:


## Example

```cpp
#define BUF_SIZE (32)

int main(int argc, char *argv[])
{
	char buffer[BUF_SIZE];
	size_t pos = 0;
	int i;

	for (i = 0; i < argc; i++)
	{
		pos += snprintf(buffer + pos, BUF_SIZE - pos, "%s", argv[i]);
			// BUF_SIZE - pos may overflow
	}
}

```

## Recommendation
The return value of `snprintf` should always be checked if it is used, and values larger than the buffer size should be accounted for.


## Example

```cpp
#define BUF_SIZE (32)

int main(int argc, char *argv[])
{
	char buffer[BUF_SIZE];
	size_t pos = 0;
	int i;

	for (i = 0; i < argc; i++)
	{
		int n = snprintf(buffer + pos, BUF_SIZE - pos, "%s", argv[i]);
		if (n < 0 || n >= BUF_SIZE - pos)
		{
			break;
		}
		pos += n;
	}
}

```

## References
* cplusplus.com: [snprintf](http://www.cplusplus.com/reference/cstdio/snprintf/).
* Red Hat Customer Portal: [The trouble with snprintf](https://access.redhat.com/blogs/766093/posts/1976193).