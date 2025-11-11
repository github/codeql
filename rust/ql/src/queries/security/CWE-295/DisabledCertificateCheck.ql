/**
 * @name Disabled TLS certificate check
 * @description If an application disables TLS certificate checking, it may be vulnerable to
 *              man-in-the-middle attacks.
 * @kind problem
 * @problem.severity warning
 * @security-severity 7.5
 * @precision high
 * @id rust/disabled-certificate-check
 * @tags security
 *       external/cwe/cwe-295
 */

import rust

from CallExprBase fc
where
    fc.getStaticTarget().(Function).getName().getText() = ["danger_accept_invalid_certs", "danger_accept_invalid_hostnames"] and
    fc.getArg(0).(BooleanLiteralExpr).getTextValue() = "true"
select
    fc,
    "Disabling TLS certificate validation with 'danger_accept_invalid_certs(true)' can expose the application to man-in-the-middle attacks." // TODO: proper message.
