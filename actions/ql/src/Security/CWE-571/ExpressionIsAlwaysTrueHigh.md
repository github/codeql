# If Condition Always Evaluates to True

## Description

GitHub Workflow Expressions (`${{ ... }}`) used in the `if` condition of jobs or steps must not contain extra characters or spaces. Otherwise, the condition is invariably evaluated to `true`.

When an `if` condition erroneously evaluates to `true`, unintended steps may be executed, leading to logic bugs and potentially exposing parts of the workflow designed to run only in secure scenarios. This behavior subverts the intended conditional logic of the workflow, leading to potential security vulnerabilities and unintentional consequences.

## Recommendation

To avoid the vulnerability where an `if` condition always evaluates to `true`, it is crucial to eliminate any extra characters or spaces in your GitHub Actions expressions:

1. Do not use `${{` and `}}` for Workflow Expressions in `if` conditions.
2. Avoid multiline or spaced-out conditional expressions that might inadvertently introduce unwanted characters or formatting.
3. Test the workflow to ensure the `if` conditions behave as expected under different scenarios.

## Examples

### Correct Usage

1. Omit `${{` and `}}` in `if` conditions:

    ```yaml
    if: steps.checks.outputs.safe_to_run == true
    if: |-
        steps.checks.outputs.safe_to_run == true
    if: |
        steps.checks.outputs.safe_to_run == true
    ```

2. If using `${{` and `}}` Workflow Expressions, ensure the `if` condition is formatted correctly without extra spaces or characters:

    ```yaml
    if: ${{ steps.checks.outputs.safe_to_run == true }}
    if: |-
        ${{ steps.checks.outputs.safe_to_run == true }}
    ```

### Incorrect Usage

1. Do not mix Workflow Expressions with un-delimited expressions:

    ```yaml
    if: ${{ steps.checks.outputs.safe_to_run }} == true
    ```

2. Do not include trailing new lines or spaces:

    ```yaml
    if: |
      ${{ steps.checks.outputs.safe_to_run == true }}
    if: >
      ${{ steps.checks.outputs.safe_to_run == true }}
    if: " ${{ steps.checks.outputs.safe_to_run == true }}"
    if: |+
      ${{ steps.checks.outputs.safe_to_run == true }}
    if: >+
      ${{ steps.checks.outputs.safe_to_run == true }}
    ```

## References

- [Expression Always True Github Issue](https://github.com/actions/runner/issues/1173)
