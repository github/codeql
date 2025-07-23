/**
 * @name Insecure SMB settings
 * @description Use of insecure SMB configurations allow attackers to access connections
 * @kind problem
 * @problem.severity error
 * @security-severity 8.8
 * @precision high
 * @id powershell/microsoft/public/insecure-smb-setting
 * @tags correctness
 *       security
 *       external/cwe/cwe-315
 */

import powershell

abstract class SMBConfiguration extends CmdCall {
  abstract Expr getAMisconfiguredSetting();

  /** Gets the minimum version of the SMB protocol to be used */
  Expr getMisconfiguredSmb2DialectMin() {
    exists(Expr dialectMin |
      dialectMin = this.getNamedArgument("smb2dialectmin") and
      dialectMin.getValue().stringMatches(["none", "smb202", "smb210"]) and
      result = dialectMin
    )
  }
}

/** A call to `Set-SmbServerConfiguration`. */
class SetSMBClientConfiguration extends SMBConfiguration {
  SetSMBClientConfiguration() { this.getAName() = "Set-SmbClientConfiguration" }

  /** holds if the argument `requireencryption` is supplied with a `$false` value. */
  Expr getMisconfiguredRequireEncryption() {
    exists(Expr requireEncryption |
      requireEncryption = this.getNamedArgument("requireencryption") and
      requireEncryption.getValue().asBoolean() = false and
      result = requireEncryption
    )
  }

  /** Holds if the argument `blockntlm` is supplied with a `$false` value. */
  Expr getMisconfiguredBlocksNTLM() {
    exists(Expr blocksNTLM |
      blocksNTLM = this.getNamedArgument("blockntlm") and
      blocksNTLM.getValue().asBoolean() = false and
      result = blocksNTLM
    )
  }

  override Expr getAMisconfiguredSetting() {
    result = this.getMisconfiguredRequireEncryption() or
    result = this.getMisconfiguredBlocksNTLM() or
    result = this.getMisconfiguredSmb2DialectMin()
  }
}

/** A call to `Set-SmbServerConfiguration`. */
class SetSMBServerConfiguration extends SMBConfiguration {
  SetSMBServerConfiguration() { this.getAName() = "Set-SmbServerConfiguration" }

  /** holds if the argument `encryptdata` is supplied with a `$false` value. */
  Expr getMisconfiguredEncryptData() {
    exists(Expr encryptData |
      encryptData = this.getNamedArgument("encryptdata") and
      encryptData.getValue().asBoolean() = false and
      result = encryptData
    )
  }

  /** holds if the argument `encryptdata` is supplied with a `$false` value. */
  Expr getMisconfiguredRejectUnencryptedAccess() {
    exists(Expr rejectUnencryptedAccess |
      rejectUnencryptedAccess = this.getNamedArgument("rejectunencryptedaccess") and
      rejectUnencryptedAccess.getValue().asBoolean() = false and
      result = rejectUnencryptedAccess
    )
  }

  override Expr getAMisconfiguredSetting() {
    result = this.getMisconfiguredEncryptData() or
    result = this.getMisconfiguredRejectUnencryptedAccess() or
    result = this.getMisconfiguredSmb2DialectMin()
  }
}

from SMBConfiguration config
select config.getAMisconfiguredSetting(), "Unsafe SMB setting"
