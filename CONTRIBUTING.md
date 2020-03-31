# Contributing to CodeQL

We welcome contributions to our CodeQL libraries and queries. Got an idea for a new check, or how to improve an existing query? Then please go ahead and open a pull request!

There is lots of useful documentation to help you write queries, ranging from information about query file structure to tutorials for specific target languages. For more information on the documentation available, see [Writing CodeQL queries](https://help.semmle.com/QL/learn-ql/writing-queries/writing-queries.html) on [help.semmle.com](https://help.semmle.com).


## Submitting a new experimental query

If you have an idea for a query that you would like to share with other CodeQL users, please open a pull request to add it to this repository. New queries start out in a `<language>/ql/src/experimental` directory, to which they can be merged when they meet the following requirements.

1. **Directory structure**

    There are five language-specific query directories in this repository:

      * C/C++: `cpp/ql/src`
      * C#: `csharp/ql/src`
      * Java: `java/ql/src`
      * JavaScript: `javascript/ql/src`
      * Python: `python/ql/src`

    Each language-specific directory contains further subdirectories that group queries based on their `@tags` or purpose.
    - Experimental queries and libraries are stored in the `experimental` subdirectory within each language-specific directory in the [CodeQL repository](https://github.com/Semmle/ql). For example, experimental Java queries and libraries are stored in `java/ql/src/experimental` and any corresponding tests in `java/ql/test/experimental`.
    - The structure of an `experimental` subdirectory mirrors the structure of its parent directory.
    - Select or create an appropriate directory in `experimental` based on the existing directory structure of `experimental` or its parent directory.

2. **Query metadata**

    - The query `@id` must conform to all the requirements in the [guide on query metadata](docs/query-metadata-style-guide.md#query-id-id). In particular, it must not clash with any other queries in the repository, and it must start with the appropriate language-specific prefix.
    - The query must have a `@name` and `@description` to explain its purpose.
    - The query must have a `@kind` and `@problem.severity` as required by CodeQL tools.

    For details, see the [guide on query metadata](docs/query-metadata-style-guide.md).

    Make sure the `select` statement is compatible with the query `@kind`. See [Introduction to query files](https://help.semmle.com/QL/learn-ql/writing-queries/introduction-to-queries.html#select-clause) on help.semmle.com.

3. **Formatting**

    - The queries and libraries must be [autoformatted](https://help.semmle.com/codeql/codeql-for-vscode/reference/editor.html#autoformatting).

4. **Compilation**

    - Compilation of the query and any associated libraries and tests must be resilient to future development of the [supported](docs/supported-queries.md) libraries. This means that the functionality cannot use internal libraries, cannot depend on the output of `getAQlClass`, and cannot make use of regexp matching on `toString`.
    - The query and any associated libraries and tests must not cause any compiler warnings to be emitted (such as use of deprecated functionality or missing `override` annotations).

5. **Results**

    - The query must have at least one true positive result on some revision of a real project.

6. **Contributor License Agreement**

    - The contributor can satisfy the [CLA](#contributor-license-agreement).

Experimental queries and libraries may not be actively maintained as the [supported](docs/supported-queries.md) libraries evolve. They may also be changed in backwards-incompatible ways or may be removed entirely in the future without deprecation warnings.

After the experimental query is merged, we welcome pull requests to improve it. Before a query can be moved out of the `experimental` subdirectory, it must satisfy [the requirements for being a supported query](docs/supported-queries.md).

## Using your personal data

If you contribute to this project, we will record your name and email
address (as provided by you with your contributions) as part of the code
repositories, which are public. We might also use this information
to contact you in relation to your contributions, as well as in the
normal course of software development. We also store records of your
CLA agreements. Under GDPR legislation, we do this
on the basis of our legitimate interest in creating the CodeQL product.

Please do get in touch (privacy@semmle.com) if you have any questions about
this or our data protection policies.

## Contributor License Agreement

This Contributor License Agreement (“Agreement”) is entered into between Semmle Limited (“Semmle,” “we” or “us” etc.), and You (as defined and further identified below).

Accordingly, You hereby agree to the following terms for Your present and future Contributions submitted to Semmle:

1. **Definitions**.

   * "You" (or "Your") shall mean the Contribution copyright owner (whether an individual or organization) or legal entity authorized by the copyright owner that is making this Agreement with Semmle. For legal entities, the entity making a Contribution and all other entities that control, are controlled by, or are under common control with that entity are considered to be a single Contributor. For the purposes of this definition, "control" means (i) the power, direct or indirect, to cause the direction or management of such entity, whether by contract or otherwise, or (ii) ownership of fifty percent (50%) or more of the outstanding shares, or (iii) beneficial ownership of such entity.

   * "Contribution(s)" shall mean the code, documentation or other original works of authorship, including any modifications or additions to an existing work, submitted by You to Semmle for inclusion in, or documentation of, any of the products or projects owned or managed by Semmle (the "Work(s)").  For the purposes of this definition, "submitted" means any form of electronic, verbal, or written communication sent to Semmle or its representatives, including but not limited to communication on electronic mailing lists, source code control systems, and issue tracking systems that are managed by, or on behalf of, Semmle for the purpose of discussing and/or improving the Work, but excluding communication that is conspicuously marked or otherwise designated in writing by You as "Not a Contribution."

2. **Grant of Copyright License**. You hereby grant to Semmle and to recipients of software distributed by Semmle a perpetual, worldwide, non-exclusive, no-charge, royalty-free, irrevocable copyright license to reproduce, prepare derivative works of, publicly display, publicly perform, sublicense, and distribute Your Contributions and such derivative works.

3. **Grant of Patent License**. You hereby grant to Semmle and to recipients of software distributed by Semmle a perpetual, worldwide, non-exclusive, no-charge, royalty-free, irrevocable (except as stated in this section) patent license to make, have made, use, offer to sell, sell, import, and otherwise transfer the Work, where such license applies only to those patent claims licensable by You that are necessarily infringed by Your Contribution(s) alone or by combination of Your Contribution(s) with the Work to which such Contribution(s) was submitted. If any entity institutes patent litigation against You or any other entity (including a cross-claim or counterclaim in a lawsuit) alleging that Your Contribution, or the Work to which You have contributed, constitutes direct or contributory patent infringement, then any patent licenses granted to that entity under this Agreement for that Contribution or Work shall terminate as of the date such litigation is filed.  

4. **Ownership**.  Except as set out above, You keep all right, title, and interest in Your Contribution. The rights that You grant to us under this Agreement are effective on the date You first submitted a Contribution to us, even if Your submission took place before the date You entered this Agreement.

5. **Representations**.  You represent and warrant that: (i) the Contributions are an original work and that You can legally grant the rights set out in this Agreement; (ii) the Contributions and Semmle’s exercise of any license rights granted hereunder, does not and will not, infringe the rights of any third party; (iii) You are not aware of any pending or threatened claims, suits, actions, or charges pertaining to the Contributions, including without limitation any claims or allegations that any or all of the Contributions infringes, violates, or misappropriate the intellectual property rights of any third party (You further agree that You will notify Semmle immediately if You become aware of any such actual or potential claims, suits, actions, allegations or charges).

6. **Employer**.  If Your employer(s) has rights to intellectual property that You create that includes Your Contributions, You represent and warrant that Your employer has waived such rights for Your Contributions to Semmle, or that You have received permission to make Contributions on behalf of that employer and that You are authorized to execute this Agreement on behalf of Your employer.

7. **Inclusion of Code**. We determine the code that is in our Works. You understand that the decision to include the Contribution in any project or source repository is entirely that of Semmle, and this agreement does not guarantee that the Contributions will be included in any product.

8. **Disclaimer**.  You are not expected to provide support for Your Contributions, except to the extent You desire to provide support. You may provide support for free, for a fee, or not at all. Except as set forth herein, and unless required by applicable law or agreed to in writing, You provide Your Contributions on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND.

9. **General**.  The failure of either party to enforce its rights under this Agreement for any period shall not be construed as a waiver of such rights.  No changes or modifications or waivers to this Agreement will be effective unless in writing and signed by both parties.  In the event that any provision of this Agreement shall be determined to be illegal or unenforceable, that provision will be limited or eliminated to the minimum extent necessary so that this Agreement shall otherwise remain in full force and effect and enforceable.  This Agreement shall be governed by and construed in accordance with the laws of the State of California in the United States without regard to the conflicts of laws provisions thereof.  In any action or proceeding to enforce rights under this Agreement, the prevailing party will be entitled to recover costs and attorneys’ fees.  
