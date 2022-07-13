class Diagnostic extends @diagnostic {
  string toString() { none() }
}

class Location extends @location_default {
  string toString() { none() }
}

from
  Diagnostic d, int severity, string error_tag, string error_message, string full_error_message,
  Location l
where diagnostics(d, severity, error_tag, error_message, full_error_message, l)
select d, /* generated_by */ "CodeQL Java extractor", severity, error_tag, error_message,
  full_error_message, l
