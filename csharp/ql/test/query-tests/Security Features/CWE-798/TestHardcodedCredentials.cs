using System;
using System.Web.Security;
using Microsoft.VisualStudio.TestTools.UnitTesting;

namespace Moq.Language
{
    class TestReturn
    {
        public static void Returns(Func<MembershipUser> objFunc) { }
    }
}

[TestClass]
public class HardCodedCredentialsTest
{

    [TestMethod]
    public void TestUnsafe()
    {
        // GOOD: Create test user
        Membership.CreateUser("myusername", "mypassword");

        // BAD: Create a membership user with hardcoded username
        MembershipUser user = new MembershipUser(
            providerName: "provider",
            name: "username",
            providerUserKey: "username",
            email: "foo@bar.com",
            passwordQuestion: "Hardcoded question.",
            comment: "",
            isApproved: true,
            isLockedOut: false,
            creationDate: DateTime.Now,
            lastLoginDate: DateTime.Now,
            lastActivityDate: DateTime.Now,
            lastPasswordChangedDate: DateTime.Now,
            lastLockoutDate: DateTime.Now
            );

        // GOOD: Create a membership user which will be returned by a mock
        MembershipUser mockUser = new MembershipUser(
            providerName: "provider",
            name: "username",
            providerUserKey: "username",
            email: "foo@bar.com",
            passwordQuestion: "Hardcoded question.",
            comment: "",
            isApproved: true,
            isLockedOut: false,
            creationDate: DateTime.Now,
            lastLoginDate: DateTime.Now,
            lastActivityDate: DateTime.Now,
            lastPasswordChangedDate: DateTime.Now,
            lastLockoutDate: DateTime.Now
            );
        Moq.Language.TestReturn.Returns(() => mockUser);
    }
}

// semmle-extractor-options: ${testdir}/../../../resources/stubs/Microsoft.VisualStudio.TestTools.UnitTesting.cs
