lgtm,codescanning
* Two new queries, both titled "Temporary directory Local information disclosure" 
  (`java/local-temp-file-or-directory-information-disclosure-path`, `java/local-temp-file-or-directory-information-disclosure-method`), has been added.
  This query finds uses of APIs that leak potentially sensitive information to other local users via the system temporary directory.