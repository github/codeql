// semmle-extractor-options: /r:System.Security.Cryptography.Csp.dll /r:System.Security.Cryptography.Algorithms.dll /r:System.Security.Cryptography.Primitives.dll
using System;
using System.Collections.Generic;
using System.Security.Cryptography;

public class Nest01
{
    private readonly SHA256 _sha;

    public Nest01()
    {
        _sha = SHA256.Create();
    }
}

public class Nest02
{
    private readonly Nest01 _n;

    public Nest02()
    {
        _n = new Nest01();
    }
}

public class ListNonStatic
{
    private List<SHA512> _shaList;

    public ListNonStatic()
    {
        _shaList = new List<SHA512>();
    }
}

/// <summary>
/// Positive results (classes are not thread safe)
/// </summary>
public class Nest03
{
    private static readonly Nest01 _n = new Nest01();
}

public class Nest04
{
    static ListNonStatic _list = new ListNonStatic();
}

public static class StaticMemberChildUsage
{
    public enum DigestAlgorithm
    {
        SHA1,
        SHA256,
    }

    private static readonly IDictionary<DigestAlgorithm, HashAlgorithm> HashMap = new Dictionary<DigestAlgorithm, HashAlgorithm>
        {
            { DigestAlgorithm.SHA1, SHA1.Create() },
            { DigestAlgorithm.SHA256, SHA256.Create() },
        };
}

public class StaticMember
{
    private static SHA1 _sha1 = SHA1.Create();
}

public class IndirectStatic2
{
    static Nest02 _n = new Nest02();
}

/// <summary>
/// Should not be flagged (thread safe)
/// </summary>

public class IndirectStatic
{
    StaticMember tc;
}

public class TokenCacheFP
{
    /// <summary>
    ///  Should be OK. Not shared between threads
    /// </summary>
    [ThreadStatic]
    private static SHA1 _sha1 = SHA1.Create();

    private string ComputeHash(string password)
    {
        return password;
    }
}

public class TokenCacheNonStat
{
    /// <summary>
    ///  Should be OK. Not shared between threads
    /// </summary>
    private SHA1 _sha1;

    public TokenCacheNonStat()
    {
        _sha1 = SHA1.Create();
    }

    private string ComputeHash(string password)
    {
        return password;
    }
}

public class FuncTest
{
    /// <summary>
    /// Should be OK. Does not store the field.
    /// </summary>
    public static Func<SHA1> function;
}
