.. _customizing-library-models-for-actions:

Customizing library models for GitHub Actions
=============================================

.. include:: ../reusables/beta-note-customizing-library-models.rst

GitHub Actions analysis can be customized by adding library models in data extension files.

A data extension for GitHub Actions is a YAML file of the form:

.. code-block:: yaml

  extensions:
    - addsTo:
        pack: codeql/actions-all
        extensible: <name of extensible predicate>
      data:
        - <tuple1>
        - <tuple2>
        - ...

The CodeQL library for GitHub Actions exposes the following extensible predicates:

Customizing data flow and taint tracking:

- **actionsSourceModel**\(action, version, output, kind, provenance)
- **actionsSinkModel**\(action, version, input, kind, provenance)
- **actionsSummaryModel**\(action, version, input, output, kind, provenance)

Customizing Actions-specific analysis:

- **argumentInjectionSinksDataModel**\(regexp, command_group, argument_group)
- **contextTriggerDataModel**\(trigger, context_prefix)
- **externallyTriggerableEventsDataModel**\(event)
- **immutableActionsDataModel**\(action)
- **poisonableActionsDataModel**\(action)
- **poisonableCommandsDataModel**\(regexp)
- **poisonableLocalScriptsDataModel**\(regexp, group)
- **repositoryDataModel**\(visibility, default_branch_name)
- **trustedActionsOwnerDataModel**\(owner)
- **untrustedEventPropertiesDataModel**\(property, kind)
- **untrustedGhCommandDataModel**\(cmd_regex, flag)
- **untrustedGitCommandDataModel**\(cmd_regex, flag)
- **vulnerableActionsDataModel**\(action, vulnerable_version, vulnerable_sha, fixed_version)
- **workflowDataModel**\(path, trigger, job, secrets_source, permissions, runner)

Examples of custom model definitions
------------------------------------

The examples in this section are taken from the standard CodeQL Actions query pack published by GitHub. They demonstrate how to add tuples to extend extensible predicates that are used by the standard queries.

Example: Extend the trusted Actions publishers for the ``actions/unpinned-tag`` query
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

If there is an Action publisher that you trust, you can include the owner name/organization in a data extension model pack to add it to the allow list for this query. Adding owners to this list will prevent security alerts when using unpinned tags for Actions published by that owner.

To allow any Action from the publisher ``octodemo``, such as ``octodemo/3rd-party-action``, follow these steps:

1. Create a data extension file ``/models/trusted-owner.model.yml`` with the following content:

   .. code-block:: yaml

      extensions:
        - addsTo: 
            pack: codeql/actions-all
            extensible: trustedActionsOwnerDataModel 
          data:
            - ["octodemo"]

2. Create a model pack file ``/codeql-pack.yml`` with the following content:

   .. code-block:: yaml

      name: my-org/actions-extensions-model-pack
      version: 0.0.0
      library: true
      extensionTargets:
        codeql/actions-all: '*'
      dataExtensions:
        - models/**/*.yml

3. Ensure that the model pack is included in your CodeQL analysis.

By following these steps, you will add ``octodemo`` to the list of trusted Action publishers, and the query will no longer generate security alerts for unpinned tags from this publisher.  For more information, see `Extending CodeQL coverage with CodeQL model packs in default setup <https://docs.github.com/en/code-security/code-scanning/managing-your-code-scanning-configuration/editing-your-configuration-of-default-setup#extending-codeql-coverage-with-codeql-model-packs-in-default-setup>`_ and `Creating and working with CodeQL packs <https://docs.github.com/en/code-security/codeql-cli/using-the-advanced-functionality-of-the-codeql-cli/creating-and-working-with-codeql-packs#creating-a-codeql-model-pack>`_.
