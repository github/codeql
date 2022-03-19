lgtm,codescanning
* The security queries now track taint through the format string of a date-formatting operation.
  Affected packages are
    [moment](https://npmjs.com/package/moment),
    [moment-timezone](https://npmjs.com/package/moment-timezone),
    [date-fns](https://npmjs.com/package/date-fns), and
    [dateformat](https://npmjs.com/package/dateformat).
