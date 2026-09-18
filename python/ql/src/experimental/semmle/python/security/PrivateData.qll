/**
 * Provides classes and predicates for identifying private data and methods for security.
 *
 * 'Private' data in general is anything that should not be sent around in unencrypted form. This
 * library tries to guess where private data may either be stored in a variable or produced by a
 * method.
 *
 * In addition, there are methods that ought not to be executed or not in a fashion that the user
 * can control. This includes authorization methods such as logins, and sending of data, etc.
 */

import python
import semmle.python.security.TaintTracking
import semmle.python.web.HttpRequest

/**
 * Provides heuristics for identifying names related to private information.
 *
 * INTERNAL: Do not use directly.
 * This is copied from the sensitive data library (which was copied from a javascript library), but should be language independent.
 */
private module HeuristicNames {
    /**
     * Gets a regular expression that identifies strings that may indicate the presence of private data.
     */
    string maybeSocialSecurityNumber() { result = "(?is).*social.*security.*" }
    string maybePostCode() { result = "(?is).*postcode.*" }
    string maybeZipCode() { result = "(?is).*zipcode.*" }
    string maybeTelephone() { result = "(?is).*telephone.*" }
    string maybeLatitude() { result = "(?is).*latitude.*" }
    string maybeLongitude() { result = "(?is).*longitude.*" }
    string maybeCreditCard() { result = "(?is).*credit.*card.*" }
    string maybeSalary() { result = "(?is).*salary.*" }
    string maybeBankAccount() { result = "(?is).*bank.*account.*" }
    string maybeEmail() { result = "(?is).*email.*" }
    string maybeMobile() { result = "(?is).*mobile.*" }
    string maybeEmployer() { result = "(?is).*employer.*" }
    string maybeMedical() { result = "(?is).*medical.*" }

    /**
     * Gets a regular expression that identifies strings that may indicate the presence
     * of private data, with `classification` describing the kind of private data involved.
     */
    string maybePrivate(PrivateData data) {
        result = maybeSocialSecurityNumber() and data instanceof PrivateData::SocialSecurityNumber
        or
        result = maybePostCode() and data instanceof PrivateData::PostCode
        or
        result = maybeZipCode() and data instanceof PrivateData::ZipCode
        or
        result = maybeTelephone() and data instanceof PrivateData::Telephone
        or
        result = maybeLatitude() and data instanceof PrivateData::Latitude
        or
        result = maybeLongitude() and data instanceof PrivateData::Longitude
        or
        result = maybeCreditCard() and data instanceof PrivateData::CreditCard
        or
        result = maybeSalary() and data instanceof PrivateData::Salary
        or
        result = maybeBankAccount() and data instanceof PrivateData::BankAccount
        or
        result = maybeEmail() and data instanceof PrivateData::Email
        or
        result = maybeMobile() and data instanceof PrivateData::Mobile
        or
        result = maybeEmployer() and data instanceof PrivateData::Employer
        or
        result = maybeMedical() and data instanceof PrivateData::Medical
    }

    /**
     * Gets a regular expression that identifies strings that may indicate the presence of data
     * that is hashed or encrypted, and hence rendered non-private.
     */
    string notPrivate() {
        result = "(?is).*(redact|censor|obfuscate|hash|md5|sha|((?<!un)(en))?(crypt|code)).*"
    }

    bindingset[name]
    PrivateData getPrivateDataForName(string name) {
        name.regexpMatch(HeuristicNames::maybePrivate(result)) and
        not name.regexpMatch(HeuristicNames::notPrivate())
    }
}

abstract class PrivateData extends TaintKind {
    bindingset[this]
    PrivateData() { this = this }
}

module PrivateData {
    class SocialSecurityNumber extends PrivateData {
        SocialSecurityNumber() { this = "private.data.socialsecuritynumber" }

        override string repr() { result = "a social security number" }
    }

    class PostCode extends PrivateData {
        PostCode() { this = "private.data.postcode" }

        override string repr() { result = "a postcode" }
    }

    class ZipCode extends PrivateData {
        ZipCode() { this = "private.data.zipcode" }

        override string repr() { result = "a zipcode" }
    }

    class Telephone extends PrivateData {
        Telephone() { this = "private.data.telephone" }

        override string repr() { result = "a telephone number" }
    }

    class Latitude extends PrivateData {
        Latitude() { this = "private.data.latitude" }

        override string repr() { result = "a latitude" }
    }

    class Longitude extends PrivateData {
        Longitude() { this = "private.data.longitude" }

        override string repr() { result = "a longitude" }
    }

    class CreditCard extends PrivateData {
        CreditCard() { this = "private.data.creditcard" }

        override string repr() { result = "a credit card" }
    }

    class Salary extends PrivateData {
        Salary() { this = "private.data.salary" }

        override string repr() { result = "a salary" }
    }

    class BankAccount extends PrivateData {
        BankAccount() { this = "private.data.bankaccount" }

        override string repr() { result = "bank account related information" }
    }

    class Email extends PrivateData {
        Email() { this = "private.data.email" }

        override string repr() { result = "an email address" }
    }

    class Mobile extends PrivateData {
        Mobile() { this = "private.data.mobile" }

        override string repr() { result = "a mobile phone number" }
    }

    class Employer extends PrivateData {
        Employer() { this = "private.data.employer" }

        override string repr() { result = "an employer" }
    }

    class Medical extends PrivateData {
        Medical() { this = "private.data.medical" }

        override string repr() { result = "medical information" }
    }

    private PrivateData fromFunction(Value func) {
        result = HeuristicNames::getPrivateDataForName(func.getName())
    }

    abstract class Source extends TaintSource {
        abstract string repr();
    }

    private class PrivateCallSource extends Source {
        PrivateData data;

        PrivateCallSource() {
            exists(Value callee | callee.getACall() = this | data = fromFunction(callee))
        }

        override predicate isSourceOf(TaintKind kind) { kind = data }

        override string repr() { result = "a call returning " + data.repr() }
    }

    /** An access to a variable or property that might contain private data. */
    private class PrivateVariableAccess extends PrivateData::Source {
        PrivateData data;

        PrivateVariableAccess() {
            data = HeuristicNames::getPrivateDataForName(this.(AttrNode).getName())
        }

        override predicate isSourceOf(TaintKind kind) { kind = data }

        override string repr() { result = "an attribute or property containing " + data.repr() }
    }

    private class PrivateRequestParameter extends PrivateData::Source {
        PrivateData data;

        PrivateRequestParameter() {
            this.(CallNode).getFunction().(AttrNode).getName() = "get" and
            exists(StringValue private |
                this.(CallNode).getAnArg().pointsTo(private) and
                data = HeuristicNames::getPrivateDataForName(private.getText())
            )
        }

        override predicate isSourceOf(TaintKind kind) { kind = data }

        override string repr() { result = "a request parameter containing " + data.repr() }
    }
}

//Backwards compatibility
class PrivateDataSource = PrivateData::Source;
