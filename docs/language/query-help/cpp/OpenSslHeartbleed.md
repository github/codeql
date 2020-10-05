# Use of a version of OpenSSL with Heartbleed

```
ID: cpp/openssl-heartbleed
Kind: problem
Severity: error
Precision: very-high
Tags: security external/cwe/cwe-327 external/cwe/cwe-788

```
[Click to see the query in the CodeQL repository](https://github.com/github/codeql/tree/main/cpp/ql/src/Security/CWE/CWE-327/OpenSslHeartbleed.ql)

Earlier versions of the popular OpenSSL library suffer from a buffer overflow in its "heartbeat" code. Because of the location of the problematic code, this vulnerability is often called "Heartbleed".

Software that includes a copy of OpenSSL should be sure to use a current version of the library. If it uses an older version, it will be vulnerable to any network site it connects with.


## Recommendation
Upgrade to the latest version of OpenSSL. This problem was fixed in version 1.0.1g.


## Example
The following code is present in earlier versions of OpenSSL. The `payload` variable is the number of bytes that should be copied from the request back into the response. The call to `memcpy` does this copy. The problem is that `payload` is supplied as part of the remote request, and there is no code that checks the size of it. If the caller supplies a very large value, then the `memcpy` call will copy memory that is outside the request packet.


```c
int
tls1_process_heartbeat(SSL *s)
    {
    unsigned char *p = &s->s3->rrec.data[0], *pl;
    unsigned short hbtype;
    unsigned int payload;
 
    /* ... */
 
    hbtype = *p++;
    n2s(p, payload);
    pl = p;
 
    /* ... */
 
    if (hbtype == TLS1_HB_REQUEST)
            {
            /* ... */
            memcpy(bp, pl, payload);  // BAD: overflow here
            /* ... */
            }
 
 
    /* ... */
 
    }

```

## References
* Common Vulnerabilities and Exposures: [CVE-2014-0160](https://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2014-0160).
* OpenSSL News: [OpenSSL Security Advisory [07 Apr 2014]](https://www.openssl.org/news/secadv_20140407.txt).
* Common Weakness Enumeration: [CWE-327](https://cwe.mitre.org/data/definitions/327.html).
* Common Weakness Enumeration: [CWE-788](https://cwe.mitre.org/data/definitions/788.html).