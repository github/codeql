/**
 * @name Unrestricted file upload
 * @description Allowing file uploads without proper validation of file type
 *              or content may allow an attacker to upload and execute
 *              malicious code.
 * @kind problem
 * @problem.severity error
 * @security-severity 8.8
 * @precision medium
 * @id php/unrestricted-file-upload
 * @tags security
 *       external/cwe/cwe-434
 */

import codeql.php.AST

from FunctionCallExpr move
where
  move.getFunctionName() = "move_uploaded_file" and
  not exists(FunctionCallExpr check |
    check.getLocation().getFile() = move.getLocation().getFile() and
    (
      // Common file-type validation functions
      check.getFunctionName() =
        [
          "getimagesize", "finfo_file", "mime_content_type", "pathinfo",
          "exif_imagetype"
        ]
      or
      // Checking file extension via string functions
      check.getFunctionName() = ["strtolower", "in_array"] and
      exists(FunctionCallExpr inner |
        inner.getFunctionName() = ["pathinfo", "substr", "strrpos"] and
        inner.getLocation().getFile() = move.getLocation().getFile()
      )
    )
  )
select move, "Unrestricted file upload without validation of file type or content."
