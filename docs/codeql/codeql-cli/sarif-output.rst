.. _sarif-output:

SARIF output
============

.. pull-quote:: 
  This article was moved to "`CodeQL CLI SARIF output <https://docs.github.com/en/code-security/codeql-cli/codeql-cli-reference/sarif-output>`__" on the `GitHub Docs <https://docs.github.com/en/code-security/codeql-cli>`__ site as of January 2023.
  
  .. include:: ../reusables/codeql-cli-articles-migration-note.rst

.. include:: ../reusables/codeql-cli-migration-toc-note.rst

* `SARIF specification and schema <https://docs.github.com/en/code-security/codeql-cli/codeql-cli-reference/sarif-output#sarif-specification-and-schema>`__
* `Change notes <https://docs.github.com/en/code-security/codeql-cli/codeql-cli-reference/sarif-output#change-notes>`__
    * `Changes between versions <https://docs.github.com/en/code-security/codeql-cli/codeql-cli-reference/sarif-output#changes-between-versions>`__
    * `Future changes to the output <https://docs.github.com/en/code-security/codeql-cli/codeql-cli-reference/sarif-output#future-changes-to-the-output>`__
* `Generated SARIF objects <https://docs.github.com/en/code-security/codeql-cli/codeql-cli-reference/sarif-output#generated-sarif-objects>`__
    * `sarifLog object <https://docs.github.com/en/code-security/codeql-cli/codeql-cli-reference/sarif-output#sariflog-object>`__
    * `run object <https://docs.github.com/en/code-security/codeql-cli/codeql-cli-reference/sarif-output#run-object>`__
    * `tool object <https://docs.github.com/en/code-security/codeql-cli/codeql-cli-reference/sarif-output#tool-object>`__
    * `toolComponent object <https://docs.github.com/en/code-security/codeql-cli/codeql-cli-reference/sarif-output#toolcomponent-object>`__
    * `reportingDescriptor object for rule <https://docs.github.com/en/code-security/codeql-cli/codeql-cli-reference/sarif-output#reportingdescriptor-object-for-rule>`__
    * `artifact object <https://docs.github.com/en/code-security/codeql-cli/codeql-cli-reference/sarif-output#artifact-object>`__
    * `artifactLocation object <https://docs.github.com/en/code-security/codeql-cli/codeql-cli-reference/sarif-output#artifactlocation-object>`__
    * `result object <https://docs.github.com/en/code-security/codeql-cli/codeql-cli-reference/sarif-output#result-object>`__
    * `location object <https://docs.github.com/en/code-security/codeql-cli/codeql-cli-reference/sarif-output#location-object>`__
    * `physicalLocation object <https://docs.github.com/en/code-security/codeql-cli/codeql-cli-reference/sarif-output#physicallocation-object>`__
    * `region object <https://docs.github.com/en/code-security/codeql-cli/codeql-cli-reference/sarif-output#region-object>`__
    * `codeFlow object <https://docs.github.com/en/code-security/codeql-cli/codeql-cli-reference/sarif-output#codeflow-object>`__
    * `threadFlow object <https://docs.github.com/en/code-security/codeql-cli/codeql-cli-reference/sarif-output#threadflow-object>`__
    * `threadFlowLocation object <https://docs.github.com/en/code-security/codeql-cli/codeql-cli-reference/sarif-output#threadflowlocation-object>`__