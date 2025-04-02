.. _customizing-library-models-for-actions:

Customizing Library Models for GitHub Actions
=========================================

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