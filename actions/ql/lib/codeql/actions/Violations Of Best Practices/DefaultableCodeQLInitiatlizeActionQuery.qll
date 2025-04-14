private import actions

/**
 * Holds if workflow step uses the github/codeql-action/init action with no customizations.
 * e.g.
 *     - name: Initialize
 *       uses: github/codeql-action/init@v2
 *       with:
 *         languages: ruby, javascript
 */
class DefaultableCodeQLInitiatlizeActionQuery extends UsesStep {
  DefaultableCodeQLInitiatlizeActionQuery() {
    this.getCallee() = "github/codeql-action/init" and
    not customizedWorkflowStep(this)
  }
}

/**
 * Holds if the with: part of the workflow step contains any arguments for with: other than "languages".
 * e.g.
 *  - name: Initialize CodeQL
 *       uses: github/codeql-action/init@v3
 *       with:
 *         languages: ${{ matrix.language }}
 *         config-file: ./.github/codeql/${{ matrix.language }}/codeql-config.yml
 */
predicate customizedWorkflowStep(UsesStep codeQLInitStep) {
  exists(string arg |
    exists(codeQLInitStep.getArgument(arg)) and
    arg != "languages"
  )
}
