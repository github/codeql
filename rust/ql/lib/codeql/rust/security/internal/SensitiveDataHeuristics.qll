/**
 * INTERNAL: Do not use.
 *
 * Provides classes and predicates for identifying strings that may indicate the presence of sensitive data.
 * Such that we can share this logic across our CodeQL analysis of different languages.
 *
 * 'Sensitive' data in general is anything that should not be sent around in unencrypted form.
 */

/**
 * A classification of different kinds of sensitive data:
 *
 *   - secret: generic secret or trusted data;
 *   - id: a user name or other account information;
 *   - password: a password or authorization key;
 *   - certificate: a certificate.
 *   - private: private data such as credit card numbers
 *
 * While classifications are represented as strings, this should not be relied upon.
 * Instead, use the predicates in `SensitiveDataClassification::` to work with
 * classifications.
 */
class SensitiveDataClassification extends string {
  SensitiveDataClassification() { this in ["secret", "id", "password", "certificate", "private"] }
}

/**
 * Provides predicates to select the different kinds of sensitive data we support.
 */
module SensitiveDataClassification {
  /** Gets the classification for secret or trusted data. */
  SensitiveDataClassification secret() { result = "secret" }

  /** Gets the classification for user names or other account information. */
  SensitiveDataClassification id() { result = "id" }

  /** Gets the classification for passwords or authorization keys. */
  SensitiveDataClassification password() { result = "password" }

  /** Gets the classification for certificates. */
  SensitiveDataClassification certificate() { result = "certificate" }

  /** Gets the classification for private data. */
  SensitiveDataClassification private() { result = "private" }
}

/**
 * INTERNAL: Do not use.
 *
 * Provides heuristics for identifying names related to sensitive information.
 */
module HeuristicNames {
  /**
   * Gets a regular expression that identifies strings that may indicate the presence of secret
   * or trusted data.
   */
  string maybeSecret() { result = "(?is).*((?<!is|is_)secret|(?<!un|un_|is|is_)trusted).*" }

  /**
   * Gets a regular expression that identifies strings that may indicate the presence of
   * user names or other account information.
   */
  string maybeAccountInfo() {
    result = "(?is).*acc(ou)?nt.*" or
    result = "(?is).*(puid|user.?name|user.?id|session.?(id|key)).*" or
    result = "(?s).*([uU]|^|_|[a-z](?=U))([uU][iI][dD]).*"
  }

  /**
   * Gets a regular expression that identifies strings that may indicate the presence of
   * a password or an authorization key.
   */
  string maybePassword() {
    result = "(?is).*pass(wd|word|code|.?phrase)(?!.*question).*" or
    result = "(?is).*(auth(entication|ori[sz]ation)?).?key.*"
  }

  /**
   * Gets a regular expression that identifies strings that may indicate the presence of
   * a certificate.
   */
  string maybeCertificate() { result = "(?is).*(cert)(?!.*(format|name|ification)).*" }

  /**
   * Gets a regular expression that identifies strings that may indicate the presence of
   * private data.
   */
  string maybePrivate() {
    result =
      "(?is).*(" +
        // Inspired by the list on https://cwe.mitre.org/data/definitions/359.html
        // Government identifiers, such as Social Security Numbers
        "social.?security|employer.?identification|national.?insurance|resident.?id|" +
        "passport.?(num|no)|([_-]|\\b)ssn([_-]|\\b)|" +
        // Contact information, such as home addresses
        "post.?code|zip.?code|home.?addr|" +
        // and telephone numbers
        "(mob(ile)?|home).?(num|no|tel|phone)|(tel|fax|phone).?(num|no)|telephone|" +
        "emergency.?contact|" +
        // Geographic location - where the user is (or was)
        "latitude|longitude|nationality|" +
        // Financial data - such as credit card numbers, salary, bank accounts, and debts
        "(credit|debit|bank|visa).?(card|num|no|acc(ou)?nt)|acc(ou)?nt.?(no|num|credit)|" +
        "salary|billing|credit.?(rating|score)|([_-]|\\b)ccn([_-]|\\b)|" +
        // Communications - e-mail addresses, private e-mail messages, SMS text messages, chat logs, etc.
        // "e(mail|_mail)|" + // this seems too noisy
        // Health - medical conditions, insurance status, prescription records
        "birth.?da(te|y)|da(te|y).?(of.?)?birth|" +
        "medical|(health|care).?plan|healthkit|appointment|prescription|" +
        "blood.?(type|alcohol|glucose|pressure)|heart.?(rate|rhythm)|body.?(mass|fat)|" +
        "menstrua|pregnan|insulin|inhaler|" +
        // Relationships - work and family
        "employ(er|ee)|spouse|maiden.?name" +
        // ---
        ").*"
  }

  /**
   * Gets a regular expression that identifies strings that may indicate the presence
   * of sensitive data, with `classification` describing the kind of sensitive data involved.
   */
  string maybeSensitiveRegexp(SensitiveDataClassification classification) {
    result = maybeSecret() and classification = SensitiveDataClassification::secret()
    or
    result = maybeAccountInfo() and classification = SensitiveDataClassification::id()
    or
    result = maybePassword() and classification = SensitiveDataClassification::password()
    or
    result = maybeCertificate() and
    classification = SensitiveDataClassification::certificate()
    or
    result = maybePrivate() and
    classification = SensitiveDataClassification::private()
  }

  /**
   * Gets a regular expression that identifies strings that may indicate the presence of data
   * that is hashed or encrypted, and hence rendered non-sensitive, or contains special characters
   * suggesting nouns within the string do not represent the meaning of the whole string (e.g. a URL or a SQL query).
   *
   * We also filter out common words like `certain` and `concert`, since otherwise these could
   * be matched by the certificate regular expressions. Same for `accountable` (account), or
   * `secretarial` (secret).
   */
  string notSensitiveRegexp() {
    result =
      "(?is).*([^\\w$.-]|redact|censor|obfuscate|hash|md5|sha|random|((?<!un)(en))?(crypt|(?<!pass)code)|certain|concert|secretar|accountant|accountab).*"
  }

  /**
   * Holds if `name` may indicate the presence of sensitive data, and `name` does not indicate that
   * the data is in fact non-sensitive (for example since it is hashed or encrypted).
   *
   * That is, one of the regexps from `maybeSensitiveRegexp` matches `name` (with the given
   * classification), and none of the regexps from `notSensitiveRegexp` matches `name`.
   */
  bindingset[name]
  predicate nameIndicatesSensitiveData(string name) {
    exists(string combinedRegexp |
      // Combine all the maybe-sensitive regexps into one using non-capturing groups and |.
      combinedRegexp =
        "(?:" + strictconcat(string r | r = maybeSensitiveRegexp(_) | r, ")|(?:") + ")"
    |
      name.regexpMatch(combinedRegexp)
    ) and
    not name.regexpMatch(notSensitiveRegexp())
  }

  /**
   * Holds if `name` may indicate the presence of sensitive data, and
   * `name` does not indicate that the data is in fact non-sensitive (for example since
   * it is hashed or encrypted). `classification` describes the kind of sensitive data
   * involved.
   *
   * That is, one of the regexps from `maybeSensitiveRegexp` matches `name` (with the
   * given classification), and none of the regexps from `notSensitiveRegexp` matches
   * `name`.
   *
   * When the set of names is large, it's worth using `nameIndicatesSensitiveData/1` as a first
   * pass, since that combines all the regexps into one, and should be faster. Then call this
   * predicate to get the classification(s).
   */
  bindingset[name]
  predicate nameIndicatesSensitiveData(string name, SensitiveDataClassification classification) {
    name.regexpMatch(maybeSensitiveRegexp(classification)) and
    not name.regexpMatch(notSensitiveRegexp())
  }
}
