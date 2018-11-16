# Improvements to Python analysis


## General improvements

> Changes that affect alerts in many files or from many queries
> For example, changes to file classification

## New queries

| **Query**                   | **Tags**  | **Purpose**                                                        |
|-----------------------------|-----------|--------------------------------------------------------------------|
| *@name of query (Query ID)* | *Tags*    |*Aim of the new query and whether it is enabled by default or not*  |

## Changes to existing queries

All taint-tracking queries now support visualization of paths in QL for Eclipse.
Most security alerts are now visible on LGTM by default.

| **Query**                  | **Expected impact**    | **Change**                                                       |
|----------------------------|------------------------|------------------------------------------------------------------|
| Code injection (`py/code-injection`) | Supports path visualization and is now visible on LGTM by default | No change to expected results |
| Deserializing untrusted input (`py/unsafe-deserialization`) | Supports path visualization | No change to expected results |
| Information exposure through an exception (`py/stack-trace-exposure`) | Now visible on LGTM by default | No change to expected results |
| Reflected server-side cross-site scripting (`py/reflective-xss`) | Supports path visualization and is now visible on LGTM by default | No change to expected results |
| SQL query built from user-controlled sources (`py/sql-injection`) | Supports path visualization and is now visible on LGTM by default | No change to expected results |
| Uncontrolled data used in path expression (`py/path-injection`) | Supports path visualization and is now visible on LGTM by default | No change to expected results |
| Uncontrolled command line (`py/command-line-injection`) | Supports path visualization and is now visible on LGTM by default | No change to expected results |
| URL redirection from remote source (`py/url-redirection`) | Supports path visualization and is now visible on LGTM by default | No change to expected results |

## Changes to code extraction

* *Series of bullet points*

## Changes to QL libraries

* *Series of bullet points*

