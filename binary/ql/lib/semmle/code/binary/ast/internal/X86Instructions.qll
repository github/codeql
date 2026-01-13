private import semmle.code.binary.ast.Sections as Sections
private import semmle.code.binary.ast.Headers as Headers
private import semmle.code.binary.ast.Location

signature module InstructionInputSig {
  class BaseX86Instruction extends @x86_instruction {
    string toString();
  }

  class BaseX86Operand extends @operand {
    string toString();
  }

  class BaseX86Register {
    string toString();

    BaseX86Register getASubRegister();
  }

  class BaseRipRegister extends BaseX86Register;

  class BaseRspRegister extends BaseX86Register;

  class BaseRbpRegister extends BaseX86Register;

  class BaseRcxRegister extends BaseX86Register;

  class BaseRdxRegister extends BaseX86Register;

  class BaseR8Register extends BaseX86Register;

  class BaseR9Register extends BaseX86Register;

  class BaseX86RegisterAccess {
    string toString();

    BaseX86Register getTarget();
  }

  class BaseX86UnusedOperand extends BaseX86Operand;

  class BaseX86RegisterOperand extends BaseX86Operand {
    BaseX86RegisterAccess getAccess();
  }

  class BaseX86MemoryOperand extends BaseX86Operand {
    predicate hasDisplacement();

    BaseX86RegisterAccess getSegmentRegister();

    BaseX86RegisterAccess getBaseRegister();

    BaseX86RegisterAccess getIndexRegister();

    int getScaleFactor();

    int getDisplacementValue();
  }

  class BaseX86PointerOperand extends BaseX86Operand;

  class BaseX86ImmediateOperand extends BaseX86Operand {
    int getValue();

    predicate isSigned();

    predicate isAddress();

    predicate isRelative();
  }

  default BaseX86Instruction getCallTarget(BaseX86Instruction call) { none() }

  default BaseX86Instruction getJumpTarget(BaseX86Instruction jump) { none() }
}

module MakeInstructions<InstructionInputSig InstructionInput> {
  private import InstructionInput

  final private class FinalBase = BaseX86Instruction;

  class X86Instruction extends FinalBase {
    QlBuiltins::BigInt getIndex() {
      exists(int a, int b |
        instruction(this, a, b, _) and
        result = a.toBigInt() * "4294967297".toBigInt() + b.toBigInt()
      )
    }

    QlBuiltins::BigInt getVirtualAddress() {
      result = any(Sections::TextSection s).getVirtualAddress().toBigInt() + this.getIndex()
    }

    int getLength() { instruction_length(this, result) }

    Location getLocation() { result instanceof EmptyLocation }

    X86Instruction getAPredecessor() { this = result.getASuccessor() }

    X86Instruction getASuccessor() {
      result.getIndex() = this.getIndex() + this.getLength().toBigInt()
    }

    X86Operand getAnOperand() { result = this.getOperand(_) }

    X86Operand getOperand(int index) { operand(result, this, index, _) }

    string toString() { none() }
  }

  final private class FinalBaseX86Operand = BaseX86Operand;

  final class X86Operand extends FinalBaseX86Operand {
    X86Instruction getUse() { this = result.getAnOperand() }

    int getIndex() { this = this.getUse().getOperand(result) }
  }

  final private class FinalX86Register = BaseX86Register;

  class X86Register extends FinalX86Register { }

  final private class FinalRipRegister = BaseRipRegister;

  class RipRegister extends FinalRipRegister { }

  final private class FinalRspRegister = BaseRspRegister;

  class RspRegister extends FinalRspRegister { }

  final private class FinalRbpRegister = BaseRbpRegister;

  class RbpRegister extends FinalRbpRegister { }

  final private class FinalRcxRegister = BaseRcxRegister;

  class RcxRegister extends FinalRcxRegister { }

  final private class FinalRdxRegister = BaseRdxRegister;

  class RdxRegister extends FinalRdxRegister { }

  final private class FinalR8Register = BaseR8Register;

  class R8Register extends FinalR8Register { }

  final private class FinalR9Register = BaseR9Register;

  class R9Register extends FinalR9Register { }

  final private class FinalX86RegisterAccess = BaseX86RegisterAccess;

  class X86RegisterAccess extends FinalX86RegisterAccess { }

  final private class FinalX86ImmediateOperand = BaseX86ImmediateOperand;

  final class X86ImmediateOperand extends X86Operand, FinalX86ImmediateOperand { }

  final private class FinalX86UnusedOperand = BaseX86UnusedOperand;

  final class X86UnusedOperand extends X86Operand, FinalX86UnusedOperand { }

  final private class FinalBaseX86RegisterOperand = BaseX86RegisterOperand;

  final class X86RegisterOperand extends X86Operand, FinalBaseX86RegisterOperand {
    BaseX86Register getRegister() { result = this.getAccess().getTarget() }
  }

  final private class FinalBaseX86MemoryOperand = BaseX86MemoryOperand;

  final class X86MemoryOperand extends X86Operand, FinalBaseX86MemoryOperand { }

  final private class FinalBaseX86PointerOperand = BaseX86PointerOperand;

  final class X86PointerOperand extends X86Operand, FinalBaseX86PointerOperand { }

  class X86Aaa extends X86Instruction, @x86_aaa { }

  class X86Aad extends X86Instruction, @x86_aad { }

  class X86Aadd extends X86Instruction, @x86_aadd { }

  class X86Aam extends X86Instruction, @x86_aam { }

  class X86Aand extends X86Instruction, @x86_aand { }

  class X86Aas extends X86Instruction, @x86_aas { }

  class X86Adc extends X86Instruction, @x86_adc { }

  class X86Adcx extends X86Instruction, @x86_adcx { }

  class X86Add extends X86Instruction, @x86_add { }

  class X86Addpd extends X86Instruction, @x86_addpd { }

  class X86Addps extends X86Instruction, @x86_addps { }

  class X86Addsd extends X86Instruction, @x86_addsd { }

  class X86Addss extends X86Instruction, @x86_addss { }

  class X86Addsubpd extends X86Instruction, @x86_addsubpd { }

  class X86Addsubps extends X86Instruction, @x86_addsubps { }

  class X86Adox extends X86Instruction, @x86_adox { }

  class X86Aesdec extends X86Instruction, @x86_aesdec { }

  class X86Aesdec128Kl extends X86Instruction, @x86_aesdec128kl { }

  class X86Aesdec256Kl extends X86Instruction, @x86_aesdec256kl { }

  class X86Aesdeclast extends X86Instruction, @x86_aesdeclast { }

  class X86Aesdecwide128Kl extends X86Instruction, @x86_aesdecwide128kl { }

  class X86Aesdecwide256Kl extends X86Instruction, @x86_aesdecwide256kl { }

  class X86Aesenc extends X86Instruction, @x86_aesenc { }

  class X86Aesenc128Kl extends X86Instruction, @x86_aesenc128kl { }

  class X86Aesenc256Kl extends X86Instruction, @x86_aesenc256kl { }

  class X86Aesenclast extends X86Instruction, @x86_aesenclast { }

  class X86Aesencwide128Kl extends X86Instruction, @x86_aesencwide128kl { }

  class X86Aesencwide256Kl extends X86Instruction, @x86_aesencwide256kl { }

  class X86Aesimc extends X86Instruction, @x86_aesimc { }

  class X86Aeskeygenassist extends X86Instruction, @x86_aeskeygenassist { }

  class X86And extends X86Instruction, @x86_and { }

  class X86Andn extends X86Instruction, @x86_andn { }

  class X86Andnpd extends X86Instruction, @x86_andnpd { }

  class X86Andnps extends X86Instruction, @x86_andnps { }

  class X86Andpd extends X86Instruction, @x86_andpd { }

  class X86Andps extends X86Instruction, @x86_andps { }

  class X86Aor extends X86Instruction, @x86_aor { }

  class X86Arpl extends X86Instruction, @x86_arpl { }

  class X86Axor extends X86Instruction, @x86_axor { }

  class X86Bextr extends X86Instruction, @x86_bextr { }

  class X86Blcfill extends X86Instruction, @x86_blcfill { }

  class X86Blci extends X86Instruction, @x86_blci { }

  class X86Blcic extends X86Instruction, @x86_blcic { }

  class X86Blcmsk extends X86Instruction, @x86_blcmsk { }

  class X86Blcs extends X86Instruction, @x86_blcs { }

  class X86Blendpd extends X86Instruction, @x86_blendpd { }

  class X86Blendps extends X86Instruction, @x86_blendps { }

  class X86Blendvpd extends X86Instruction, @x86_blendvpd { }

  class X86Blendvps extends X86Instruction, @x86_blendvps { }

  class X86Blsfill extends X86Instruction, @x86_blsfill { }

  class X86Blsi extends X86Instruction, @x86_blsi { }

  class X86Blsic extends X86Instruction, @x86_blsic { }

  class X86Blsmsk extends X86Instruction, @x86_blsmsk { }

  class X86Blsr extends X86Instruction, @x86_blsr { }

  class X86Bndcl extends X86Instruction, @x86_bndcl { }

  class X86Bndcn extends X86Instruction, @x86_bndcn { }

  class X86Bndcu extends X86Instruction, @x86_bndcu { }

  class X86Bndldx extends X86Instruction, @x86_bndldx { }

  class X86Bndmk extends X86Instruction, @x86_bndmk { }

  class X86Bndmov extends X86Instruction, @x86_bndmov { }

  class X86Bndstx extends X86Instruction, @x86_bndstx { }

  class X86Bound extends X86Instruction, @x86_bound { }

  class X86Bsf extends X86Instruction, @x86_bsf { }

  class X86Bsr extends X86Instruction, @x86_bsr { }

  class X86Bswap extends X86Instruction, @x86_bswap { }

  class X86Bt extends X86Instruction, @x86_bt { }

  class X86Btc extends X86Instruction, @x86_btc { }

  class X86Btr extends X86Instruction, @x86_btr { }

  class X86Bts extends X86Instruction, @x86_bts { }

  class X86Bzhi extends X86Instruction, @x86_bzhi { }

  class X86Call extends X86Instruction, @x86_call {
    X86Instruction getTarget() { result = getCallTarget(this) }
  }

  class X86Cbw extends X86Instruction, @x86_cbw { }

  class X86Ccmpb extends X86Instruction, @x86_ccmpb { }

  class X86Ccmpbe extends X86Instruction, @x86_ccmpbe { }

  class X86Ccmpf extends X86Instruction, @x86_ccmpf { }

  class X86Ccmpl extends X86Instruction, @x86_ccmpl { }

  class X86Ccmple extends X86Instruction, @x86_ccmple { }

  class X86Ccmpnb extends X86Instruction, @x86_ccmpnb { }

  class X86Ccmpnbe extends X86Instruction, @x86_ccmpnbe { }

  class X86Ccmpnl extends X86Instruction, @x86_ccmpnl { }

  class X86Ccmpnle extends X86Instruction, @x86_ccmpnle { }

  class X86Ccmpno extends X86Instruction, @x86_ccmpno { }

  class X86Ccmpns extends X86Instruction, @x86_ccmpns { }

  class X86Ccmpnz extends X86Instruction, @x86_ccmpnz { }

  class X86Ccmpo extends X86Instruction, @x86_ccmpo { }

  class X86Ccmps extends X86Instruction, @x86_ccmps { }

  class X86Ccmpt extends X86Instruction, @x86_ccmpt { }

  class X86Ccmpz extends X86Instruction, @x86_ccmpz { }

  class X86Cdq extends X86Instruction, @x86_cdq { }

  class X86Cdqe extends X86Instruction, @x86_cdqe { }

  class X86Cfcmovb extends X86Instruction, @x86_cfcmovb { }

  class X86Cfcmovbe extends X86Instruction, @x86_cfcmovbe { }

  class X86Cfcmovl extends X86Instruction, @x86_cfcmovl { }

  class X86Cfcmovle extends X86Instruction, @x86_cfcmovle { }

  class X86Cfcmovnb extends X86Instruction, @x86_cfcmovnb { }

  class X86Cfcmovnbe extends X86Instruction, @x86_cfcmovnbe { }

  class X86Cfcmovnl extends X86Instruction, @x86_cfcmovnl { }

  class X86Cfcmovnle extends X86Instruction, @x86_cfcmovnle { }

  class X86Cfcmovno extends X86Instruction, @x86_cfcmovno { }

  class X86Cfcmovnp extends X86Instruction, @x86_cfcmovnp { }

  class X86Cfcmovns extends X86Instruction, @x86_cfcmovns { }

  class X86Cfcmovnz extends X86Instruction, @x86_cfcmovnz { }

  class X86Cfcmovo extends X86Instruction, @x86_cfcmovo { }

  class X86Cfcmovp extends X86Instruction, @x86_cfcmovp { }

  class X86Cfcmovs extends X86Instruction, @x86_cfcmovs { }

  class X86Cfcmovz extends X86Instruction, @x86_cfcmovz { }

  class X86Clac extends X86Instruction, @x86_clac { }

  class X86Clc extends X86Instruction, @x86_clc { }

  class X86Cld extends X86Instruction, @x86_cld { }

  class X86Cldemote extends X86Instruction, @x86_cldemote { }

  class X86Clevict0 extends X86Instruction, @x86_clevict0 { }

  class X86Clevict1 extends X86Instruction, @x86_clevict1 { }

  class X86Clflush extends X86Instruction, @x86_clflush { }

  class X86Clflushopt extends X86Instruction, @x86_clflushopt { }

  class X86Clgi extends X86Instruction, @x86_clgi { }

  class X86Cli extends X86Instruction, @x86_cli { }

  class X86Clrssbsy extends X86Instruction, @x86_clrssbsy { }

  class X86Clts extends X86Instruction, @x86_clts { }

  class X86Clui extends X86Instruction, @x86_clui { }

  class X86Clwb extends X86Instruction, @x86_clwb { }

  class X86Clzero extends X86Instruction, @x86_clzero { }

  class X86Cmc extends X86Instruction, @x86_cmc { }

  class X86Cmovb extends X86Instruction, @x86_cmovb { }

  class X86Cmovbe extends X86Instruction, @x86_cmovbe { }

  class X86Cmovl extends X86Instruction, @x86_cmovl { }

  class X86Cmovle extends X86Instruction, @x86_cmovle { }

  class X86Cmovnb extends X86Instruction, @x86_cmovnb { }

  class X86Cmovnbe extends X86Instruction, @x86_cmovnbe { }

  class X86Cmovnl extends X86Instruction, @x86_cmovnl { }

  class X86Cmovnle extends X86Instruction, @x86_cmovnle { }

  class X86Cmovno extends X86Instruction, @x86_cmovno { }

  class X86Cmovnp extends X86Instruction, @x86_cmovnp { }

  class X86Cmovns extends X86Instruction, @x86_cmovns { }

  class X86Cmovnz extends X86Instruction, @x86_cmovnz { }

  class X86Cmovo extends X86Instruction, @x86_cmovo { }

  class X86Cmovp extends X86Instruction, @x86_cmovp { }

  class X86Cmovs extends X86Instruction, @x86_cmovs { }

  class X86Cmovz extends X86Instruction, @x86_cmovz { }

  class X86Cmp extends X86Instruction, @x86_cmp { }

  class X86Cmpbexadd extends X86Instruction, @x86_cmpbexadd { }

  class X86Cmpbxadd extends X86Instruction, @x86_cmpbxadd { }

  class X86Cmplexadd extends X86Instruction, @x86_cmplexadd { }

  class X86Cmplxadd extends X86Instruction, @x86_cmplxadd { }

  class X86Cmpnbexadd extends X86Instruction, @x86_cmpnbexadd { }

  class X86Cmpnbxadd extends X86Instruction, @x86_cmpnbxadd { }

  class X86Cmpnlexadd extends X86Instruction, @x86_cmpnlexadd { }

  class X86Cmpnlxadd extends X86Instruction, @x86_cmpnlxadd { }

  class X86Cmpnoxadd extends X86Instruction, @x86_cmpnoxadd { }

  class X86Cmpnpxadd extends X86Instruction, @x86_cmpnpxadd { }

  class X86Cmpnsxadd extends X86Instruction, @x86_cmpnsxadd { }

  class X86Cmpnzxadd extends X86Instruction, @x86_cmpnzxadd { }

  class X86Cmpoxadd extends X86Instruction, @x86_cmpoxadd { }

  class X86Cmppd extends X86Instruction, @x86_cmppd { }

  class X86Cmpps extends X86Instruction, @x86_cmpps { }

  class X86Cmppxadd extends X86Instruction, @x86_cmppxadd { }

  class X86Cmpsb extends X86Instruction, @x86_cmpsb { }

  class X86Cmpsd extends X86Instruction, @x86_cmpsd { }

  class X86Cmpsq extends X86Instruction, @x86_cmpsq { }

  class X86Cmpss extends X86Instruction, @x86_cmpss { }

  class X86Cmpsw extends X86Instruction, @x86_cmpsw { }

  class X86Cmpsxadd extends X86Instruction, @x86_cmpsxadd { }

  class X86Cmpxchg extends X86Instruction, @x86_cmpxchg { }

  class X86Cmpxchg16B extends X86Instruction, @x86_cmpxchg16b { }

  class X86Cmpxchg8B extends X86Instruction, @x86_cmpxchg8b { }

  class X86Cmpzxadd extends X86Instruction, @x86_cmpzxadd { }

  class X86Comisd extends X86Instruction, @x86_comisd { }

  class X86Comiss extends X86Instruction, @x86_comiss { }

  class X86Cpuid extends X86Instruction, @x86_cpuid { }

  class X86Cqo extends X86Instruction, @x86_cqo { }

  class X86Crc32 extends X86Instruction, @x86_crc32 { }

  class X86Ctestb extends X86Instruction, @x86_ctestb { }

  class X86Ctestbe extends X86Instruction, @x86_ctestbe { }

  class X86Ctestf extends X86Instruction, @x86_ctestf { }

  class X86Ctestl extends X86Instruction, @x86_ctestl { }

  class X86Ctestle extends X86Instruction, @x86_ctestle { }

  class X86Ctestnb extends X86Instruction, @x86_ctestnb { }

  class X86Ctestnbe extends X86Instruction, @x86_ctestnbe { }

  class X86Ctestnl extends X86Instruction, @x86_ctestnl { }

  class X86Ctestnle extends X86Instruction, @x86_ctestnle { }

  class X86Ctestno extends X86Instruction, @x86_ctestno { }

  class X86Ctestns extends X86Instruction, @x86_ctestns { }

  class X86Ctestnz extends X86Instruction, @x86_ctestnz { }

  class X86Ctesto extends X86Instruction, @x86_ctesto { }

  class X86Ctests extends X86Instruction, @x86_ctests { }

  class X86Ctestt extends X86Instruction, @x86_ctestt { }

  class X86Ctestz extends X86Instruction, @x86_ctestz { }

  class X86Cvtdq2Pd extends X86Instruction, @x86_cvtdq2pd { }

  class X86Cvtdq2Ps extends X86Instruction, @x86_cvtdq2ps { }

  class X86Cvtpd2Dq extends X86Instruction, @x86_cvtpd2dq { }

  class X86Cvtpd2Pi extends X86Instruction, @x86_cvtpd2pi { }

  class X86Cvtpd2Ps extends X86Instruction, @x86_cvtpd2ps { }

  class X86Cvtpi2Pd extends X86Instruction, @x86_cvtpi2pd { }

  class X86Cvtpi2Ps extends X86Instruction, @x86_cvtpi2ps { }

  class X86Cvtps2Dq extends X86Instruction, @x86_cvtps2dq { }

  class X86Cvtps2Pd extends X86Instruction, @x86_cvtps2pd { }

  class X86Cvtps2Pi extends X86Instruction, @x86_cvtps2pi { }

  class X86Cvtsd2Si extends X86Instruction, @x86_cvtsd2si { }

  class X86Cvtsd2Ss extends X86Instruction, @x86_cvtsd2ss { }

  class X86Cvtsi2Sd extends X86Instruction, @x86_cvtsi2sd { }

  class X86Cvtsi2Ss extends X86Instruction, @x86_cvtsi2ss { }

  class X86Cvtss2Sd extends X86Instruction, @x86_cvtss2sd { }

  class X86Cvtss2Si extends X86Instruction, @x86_cvtss2si { }

  class X86Cvttpd2Dq extends X86Instruction, @x86_cvttpd2dq { }

  class X86Cvttpd2Pi extends X86Instruction, @x86_cvttpd2pi { }

  class X86Cvttps2Dq extends X86Instruction, @x86_cvttps2dq { }

  class X86Cvttps2Pi extends X86Instruction, @x86_cvttps2pi { }

  class X86Cvttsd2Si extends X86Instruction, @x86_cvttsd2si { }

  class X86Cvttss2Si extends X86Instruction, @x86_cvttss2si { }

  class X86Cwd extends X86Instruction, @x86_cwd { }

  class X86Cwde extends X86Instruction, @x86_cwde { }

  class X86Daa extends X86Instruction, @x86_daa { }

  class X86Das extends X86Instruction, @x86_das { }

  class X86Dec extends X86Instruction, @x86_dec { }

  class X86Delay extends X86Instruction, @x86_delay { }

  class X86Div extends X86Instruction, @x86_div { }

  class X86Divpd extends X86Instruction, @x86_divpd { }

  class X86Divps extends X86Instruction, @x86_divps { }

  class X86Divsd extends X86Instruction, @x86_divsd { }

  class X86Divss extends X86Instruction, @x86_divss { }

  class X86Dppd extends X86Instruction, @x86_dppd { }

  class X86Dpps extends X86Instruction, @x86_dpps { }

  class X86Emms extends X86Instruction, @x86_emms { }

  class X86Encls extends X86Instruction, @x86_encls { }

  class X86Enclu extends X86Instruction, @x86_enclu { }

  class X86Enclv extends X86Instruction, @x86_enclv { }

  class X86Encodekey128 extends X86Instruction, @x86_encodekey128 { }

  class X86Encodekey256 extends X86Instruction, @x86_encodekey256 { }

  class X86Endbr32 extends X86Instruction, @x86_endbr32 { }

  class X86Endbr64 extends X86Instruction, @x86_endbr64 { }

  class X86Enqcmd extends X86Instruction, @x86_enqcmd { }

  class X86Enqcmds extends X86Instruction, @x86_enqcmds { }

  class X86Enter extends X86Instruction, @x86_enter { }

  class X86Erets extends X86Instruction, @x86_erets { }

  class X86Eretu extends X86Instruction, @x86_eretu { }

  class X86Extractps extends X86Instruction, @x86_extractps { }

  class X86Extrq extends X86Instruction, @x86_extrq { }

  class X86F2Xm1 extends X86Instruction, @x86_f2xm1 { }

  class X86Fabs extends X86Instruction, @x86_fabs { }

  class X86Fadd extends X86Instruction, @x86_fadd { }

  class X86Faddp extends X86Instruction, @x86_faddp { }

  class X86Fbld extends X86Instruction, @x86_fbld { }

  class X86Fbstp extends X86Instruction, @x86_fbstp { }

  class X86Fchs extends X86Instruction, @x86_fchs { }

  class X86Fcmovb extends X86Instruction, @x86_fcmovb { }

  class X86Fcmovbe extends X86Instruction, @x86_fcmovbe { }

  class X86Fcmove extends X86Instruction, @x86_fcmove { }

  class X86Fcmovnb extends X86Instruction, @x86_fcmovnb { }

  class X86Fcmovnbe extends X86Instruction, @x86_fcmovnbe { }

  class X86Fcmovne extends X86Instruction, @x86_fcmovne { }

  class X86Fcmovnu extends X86Instruction, @x86_fcmovnu { }

  class X86Fcmovu extends X86Instruction, @x86_fcmovu { }

  class X86Fcom extends X86Instruction, @x86_fcom { }

  class X86Fcomi extends X86Instruction, @x86_fcomi { }

  class X86Fcomip extends X86Instruction, @x86_fcomip { }

  class X86Fcomp extends X86Instruction, @x86_fcomp { }

  class X86Fcompp extends X86Instruction, @x86_fcompp { }

  class X86Fcos extends X86Instruction, @x86_fcos { }

  class X86Fdecstp extends X86Instruction, @x86_fdecstp { }

  class X86Fdisi8087Nop extends X86Instruction, @x86_fdisi8087nop { }

  class X86Fdiv extends X86Instruction, @x86_fdiv { }

  class X86Fdivp extends X86Instruction, @x86_fdivp { }

  class X86Fdivr extends X86Instruction, @x86_fdivr { }

  class X86Fdivrp extends X86Instruction, @x86_fdivrp { }

  class X86Femms extends X86Instruction, @x86_femms { }

  class X86Feni8087Nop extends X86Instruction, @x86_feni8087nop { }

  class X86Ffree extends X86Instruction, @x86_ffree { }

  class X86Ffreep extends X86Instruction, @x86_ffreep { }

  class X86Fiadd extends X86Instruction, @x86_fiadd { }

  class X86Ficom extends X86Instruction, @x86_ficom { }

  class X86Ficomp extends X86Instruction, @x86_ficomp { }

  class X86Fidiv extends X86Instruction, @x86_fidiv { }

  class X86Fidivr extends X86Instruction, @x86_fidivr { }

  class X86Fild extends X86Instruction, @x86_fild { }

  class X86Fimul extends X86Instruction, @x86_fimul { }

  class X86Fincstp extends X86Instruction, @x86_fincstp { }

  class X86Fist extends X86Instruction, @x86_fist { }

  class X86Fistp extends X86Instruction, @x86_fistp { }

  class X86Fisttp extends X86Instruction, @x86_fisttp { }

  class X86Fisub extends X86Instruction, @x86_fisub { }

  class X86Fisubr extends X86Instruction, @x86_fisubr { }

  class X86Fld extends X86Instruction, @x86_fld { }

  class X86Fld1 extends X86Instruction, @x86_fld1 { }

  class X86Fldcw extends X86Instruction, @x86_fldcw { }

  class X86Fldenv extends X86Instruction, @x86_fldenv { }

  class X86Fldl2E extends X86Instruction, @x86_fldl2e { }

  class X86Fldl2T extends X86Instruction, @x86_fldl2t { }

  class X86Fldlg2 extends X86Instruction, @x86_fldlg2 { }

  class X86Fldln2 extends X86Instruction, @x86_fldln2 { }

  class X86Fldpi extends X86Instruction, @x86_fldpi { }

  class X86Fldz extends X86Instruction, @x86_fldz { }

  class X86Fmul extends X86Instruction, @x86_fmul { }

  class X86Fmulp extends X86Instruction, @x86_fmulp { }

  class X86Fnclex extends X86Instruction, @x86_fnclex { }

  class X86Fninit extends X86Instruction, @x86_fninit { }

  class X86Fnop extends X86Instruction, @x86_fnop { }

  class X86Fnsave extends X86Instruction, @x86_fnsave { }

  class X86Fnstcw extends X86Instruction, @x86_fnstcw { }

  class X86Fnstenv extends X86Instruction, @x86_fnstenv { }

  class X86Fnstsw extends X86Instruction, @x86_fnstsw { }

  class X86Fpatan extends X86Instruction, @x86_fpatan { }

  class X86Fprem extends X86Instruction, @x86_fprem { }

  class X86Fprem1 extends X86Instruction, @x86_fprem1 { }

  class X86Fptan extends X86Instruction, @x86_fptan { }

  class X86Frndint extends X86Instruction, @x86_frndint { }

  class X86Frstor extends X86Instruction, @x86_frstor { }

  class X86Fscale extends X86Instruction, @x86_fscale { }

  class X86Fsetpm287Nop extends X86Instruction, @x86_fsetpm287nop { }

  class X86Fsin extends X86Instruction, @x86_fsin { }

  class X86Fsincos extends X86Instruction, @x86_fsincos { }

  class X86Fsqrt extends X86Instruction, @x86_fsqrt { }

  class X86Fst extends X86Instruction, @x86_fst { }

  class X86Fstp extends X86Instruction, @x86_fstp { }

  class X86Fstpnce extends X86Instruction, @x86_fstpnce { }

  class X86Fsub extends X86Instruction, @x86_fsub { }

  class X86Fsubp extends X86Instruction, @x86_fsubp { }

  class X86Fsubr extends X86Instruction, @x86_fsubr { }

  class X86Fsubrp extends X86Instruction, @x86_fsubrp { }

  class X86Ftst extends X86Instruction, @x86_ftst { }

  class X86Fucom extends X86Instruction, @x86_fucom { }

  class X86Fucomi extends X86Instruction, @x86_fucomi { }

  class X86Fucomip extends X86Instruction, @x86_fucomip { }

  class X86Fucomp extends X86Instruction, @x86_fucomp { }

  class X86Fucompp extends X86Instruction, @x86_fucompp { }

  class X86Fwait extends X86Instruction, @x86_fwait { }

  class X86Fxam extends X86Instruction, @x86_fxam { }

  class X86Fxch extends X86Instruction, @x86_fxch { }

  class X86Fxrstor extends X86Instruction, @x86_fxrstor { }

  class X86Fxrstor64 extends X86Instruction, @x86_fxrstor64 { }

  class X86Fxsave extends X86Instruction, @x86_fxsave { }

  class X86Fxsave64 extends X86Instruction, @x86_fxsave64 { }

  class X86Fxtract extends X86Instruction, @x86_fxtract { }

  class X86Fyl2X extends X86Instruction, @x86_fyl2x { }

  class X86Fyl2Xp1 extends X86Instruction, @x86_fyl2xp1 { }

  class X86Getsec extends X86Instruction, @x86_getsec { }

  class X86Gf2P8Affineinvqb extends X86Instruction, @x86_gf2p8affineinvqb { }

  class X86Gf2P8Affineqb extends X86Instruction, @x86_gf2p8affineqb { }

  class X86Gf2P8Mulb extends X86Instruction, @x86_gf2p8mulb { }

  class X86Haddpd extends X86Instruction, @x86_haddpd { }

  class X86Haddps extends X86Instruction, @x86_haddps { }

  class X86Hlt extends X86Instruction, @x86_hlt { }

  class X86Hreset extends X86Instruction, @x86_hreset { }

  class X86Hsubpd extends X86Instruction, @x86_hsubpd { }

  class X86Hsubps extends X86Instruction, @x86_hsubps { }

  class X86Idiv extends X86Instruction, @x86_idiv { }

  class X86Imul extends X86Instruction, @x86_imul { }

  class X86Imulzu extends X86Instruction, @x86_imulzu { }

  class X86In extends X86Instruction, @x86_in { }

  class X86Inc extends X86Instruction, @x86_inc { }

  class X86Incsspd extends X86Instruction, @x86_incsspd { }

  class X86Incsspq extends X86Instruction, @x86_incsspq { }

  class X86Insb extends X86Instruction, @x86_insb { }

  class X86Insd extends X86Instruction, @x86_insd { }

  class X86Insertps extends X86Instruction, @x86_insertps { }

  class X86Insertq extends X86Instruction, @x86_insertq { }

  class X86Insw extends X86Instruction, @x86_insw { }

  class X86Int extends X86Instruction, @x86_int { }

  class X86Int1 extends X86Instruction, @x86_int1 { }

  class X86Int3 extends X86Instruction, @x86_int3 {
    override X86Instruction getASuccessor() { none() }
  }

  class X86Into extends X86Instruction, @x86_into { }

  class X86Invd extends X86Instruction, @x86_invd { }

  class X86Invept extends X86Instruction, @x86_invept { }

  class X86Invlpg extends X86Instruction, @x86_invlpg { }

  class X86Invlpga extends X86Instruction, @x86_invlpga { }

  class X86Invlpgb extends X86Instruction, @x86_invlpgb { }

  class X86Invpcid extends X86Instruction, @x86_invpcid { }

  class X86Invvpid extends X86Instruction, @x86_invvpid { }

  class X86Iret extends X86Instruction, @x86_iret { }

  class X86Iretd extends X86Instruction, @x86_iretd { }

  class X86Iretq extends X86Instruction, @x86_iretq { }

  abstract class X86JumpingInstruction extends X86Instruction {
    final X86Instruction getTarget() { result = getJumpTarget(this) }
  }

  abstract class X86ConditionalJumpInstruction extends X86JumpingInstruction {
    override X86Instruction getASuccessor() {
      result = super.getASuccessor() or result = this.getTarget()
    }

    final X86Instruction getFallThrough() {
      result = this.getASuccessor() and
      result != this.getTarget()
    }
  }

  class X86Jb extends X86ConditionalJumpInstruction, @x86_jb { }

  class X86Jbe extends X86ConditionalJumpInstruction, @x86_jbe { }

  class X86Jcxz extends X86ConditionalJumpInstruction, @x86_jcxz { }

  class X86Jecxz extends X86ConditionalJumpInstruction, @x86_jecxz { }

  class X86Jknzd extends X86ConditionalJumpInstruction, @x86_jknzd { }

  class X86Jkzd extends X86ConditionalJumpInstruction, @x86_jkzd { }

  class X86Jl extends X86ConditionalJumpInstruction, @x86_jl { }

  class X86Jle extends X86ConditionalJumpInstruction, @x86_jle { }

  class X86Jmp extends X86JumpingInstruction, @x86_jmp {
    override X86Instruction getASuccessor() { result = this.getTarget() }
  }

  class X86Jmpabs extends X86ConditionalJumpInstruction, @x86_jmpabs { }

  class X86Jnb extends X86ConditionalJumpInstruction, @x86_jnb { }

  class X86Jnbe extends X86ConditionalJumpInstruction, @x86_jnbe { }

  class X86Jnl extends X86ConditionalJumpInstruction, @x86_jnl { }

  class X86Jnle extends X86ConditionalJumpInstruction, @x86_jnle { }

  class X86Jno extends X86ConditionalJumpInstruction, @x86_jno { }

  class X86Jnp extends X86ConditionalJumpInstruction, @x86_jnp { }

  class X86Jns extends X86ConditionalJumpInstruction, @x86_jns { }

  class X86Jnz extends X86ConditionalJumpInstruction, @x86_jnz { }

  class X86Jo extends X86ConditionalJumpInstruction, @x86_jo { }

  class X86Jp extends X86ConditionalJumpInstruction, @x86_jp { }

  class X86Jrcxz extends X86ConditionalJumpInstruction, @x86_jrcxz { }

  class X86Js extends X86ConditionalJumpInstruction, @x86_js { }

  class X86Jz extends X86ConditionalJumpInstruction, @x86_jz { }

  class X86Kaddb extends X86Instruction, @x86_kaddb { }

  class X86Kaddd extends X86Instruction, @x86_kaddd { }

  class X86Kaddq extends X86Instruction, @x86_kaddq { }

  class X86Kaddw extends X86Instruction, @x86_kaddw { }

  class X86Kand extends X86Instruction, @x86_kand { }

  class X86Kandb extends X86Instruction, @x86_kandb { }

  class X86Kandd extends X86Instruction, @x86_kandd { }

  class X86Kandn extends X86Instruction, @x86_kandn { }

  class X86Kandnb extends X86Instruction, @x86_kandnb { }

  class X86Kandnd extends X86Instruction, @x86_kandnd { }

  class X86Kandnq extends X86Instruction, @x86_kandnq { }

  class X86Kandnr extends X86Instruction, @x86_kandnr { }

  class X86Kandnw extends X86Instruction, @x86_kandnw { }

  class X86Kandq extends X86Instruction, @x86_kandq { }

  class X86Kandw extends X86Instruction, @x86_kandw { }

  class X86Kconcath extends X86Instruction, @x86_kconcath { }

  class X86Kconcatl extends X86Instruction, @x86_kconcatl { }

  class X86Kextract extends X86Instruction, @x86_kextract { }

  class X86Kmerge2L1H extends X86Instruction, @x86_kmerge2l1h { }

  class X86Kmerge2L1L extends X86Instruction, @x86_kmerge2l1l { }

  class X86Kmov extends X86Instruction, @x86_kmov { }

  class X86Kmovb extends X86Instruction, @x86_kmovb { }

  class X86Kmovd extends X86Instruction, @x86_kmovd { }

  class X86Kmovq extends X86Instruction, @x86_kmovq { }

  class X86Kmovw extends X86Instruction, @x86_kmovw { }

  class X86Knot extends X86Instruction, @x86_knot { }

  class X86Knotb extends X86Instruction, @x86_knotb { }

  class X86Knotd extends X86Instruction, @x86_knotd { }

  class X86Knotq extends X86Instruction, @x86_knotq { }

  class X86Knotw extends X86Instruction, @x86_knotw { }

  class X86Kor extends X86Instruction, @x86_kor { }

  class X86Korb extends X86Instruction, @x86_korb { }

  class X86Kord extends X86Instruction, @x86_kord { }

  class X86Korq extends X86Instruction, @x86_korq { }

  class X86Kortest extends X86Instruction, @x86_kortest { }

  class X86Kortestb extends X86Instruction, @x86_kortestb { }

  class X86Kortestd extends X86Instruction, @x86_kortestd { }

  class X86Kortestq extends X86Instruction, @x86_kortestq { }

  class X86Kortestw extends X86Instruction, @x86_kortestw { }

  class X86Korw extends X86Instruction, @x86_korw { }

  class X86Kshiftlb extends X86Instruction, @x86_kshiftlb { }

  class X86Kshiftld extends X86Instruction, @x86_kshiftld { }

  class X86Kshiftlq extends X86Instruction, @x86_kshiftlq { }

  class X86Kshiftlw extends X86Instruction, @x86_kshiftlw { }

  class X86Kshiftrb extends X86Instruction, @x86_kshiftrb { }

  class X86Kshiftrd extends X86Instruction, @x86_kshiftrd { }

  class X86Kshiftrq extends X86Instruction, @x86_kshiftrq { }

  class X86Kshiftrw extends X86Instruction, @x86_kshiftrw { }

  class X86Ktestb extends X86Instruction, @x86_ktestb { }

  class X86Ktestd extends X86Instruction, @x86_ktestd { }

  class X86Ktestq extends X86Instruction, @x86_ktestq { }

  class X86Ktestw extends X86Instruction, @x86_ktestw { }

  class X86Kunpckbw extends X86Instruction, @x86_kunpckbw { }

  class X86Kunpckdq extends X86Instruction, @x86_kunpckdq { }

  class X86Kunpckwd extends X86Instruction, @x86_kunpckwd { }

  class X86Kxnor extends X86Instruction, @x86_kxnor { }

  class X86Kxnorb extends X86Instruction, @x86_kxnorb { }

  class X86Kxnord extends X86Instruction, @x86_kxnord { }

  class X86Kxnorq extends X86Instruction, @x86_kxnorq { }

  class X86Kxnorw extends X86Instruction, @x86_kxnorw { }

  class X86Kxor extends X86Instruction, @x86_kxor { }

  class X86Kxorb extends X86Instruction, @x86_kxorb { }

  class X86Kxord extends X86Instruction, @x86_kxord { }

  class X86Kxorq extends X86Instruction, @x86_kxorq { }

  class X86Kxorw extends X86Instruction, @x86_kxorw { }

  class X86Lahf extends X86Instruction, @x86_lahf { }

  class X86Lar extends X86Instruction, @x86_lar { }

  class X86Lddqu extends X86Instruction, @x86_lddqu { }

  class X86Ldmxcsr extends X86Instruction, @x86_ldmxcsr { }

  class X86Lds extends X86Instruction, @x86_lds { }

  class X86Ldtilecfg extends X86Instruction, @x86_ldtilecfg { }

  class X86Lea extends X86Instruction, @x86_lea { }

  class X86Leave extends X86Instruction, @x86_leave { }

  class X86Les extends X86Instruction, @x86_les { }

  class X86Lfence extends X86Instruction, @x86_lfence { }

  class X86Lfs extends X86Instruction, @x86_lfs { }

  class X86Lgdt extends X86Instruction, @x86_lgdt { }

  class X86Lgs extends X86Instruction, @x86_lgs { }

  class X86Lidt extends X86Instruction, @x86_lidt { }

  class X86Lkgs extends X86Instruction, @x86_lkgs { }

  class X86Lldt extends X86Instruction, @x86_lldt { }

  class X86Llwpcb extends X86Instruction, @x86_llwpcb { }

  class X86Lmsw extends X86Instruction, @x86_lmsw { }

  class X86Loadiwkey extends X86Instruction, @x86_loadiwkey { }

  class X86Lodsb extends X86Instruction, @x86_lodsb { }

  class X86Lodsd extends X86Instruction, @x86_lodsd { }

  class X86Lodsq extends X86Instruction, @x86_lodsq { }

  class X86Lodsw extends X86Instruction, @x86_lodsw { }

  class X86Loop extends X86Instruction, @x86_loop { }

  class X86Loope extends X86Instruction, @x86_loope { }

  class X86Loopne extends X86Instruction, @x86_loopne { }

  class X86Lsl extends X86Instruction, @x86_lsl { }

  class X86Lss extends X86Instruction, @x86_lss { }

  class X86Ltr extends X86Instruction, @x86_ltr { }

  class X86Lwpins extends X86Instruction, @x86_lwpins { }

  class X86Lwpval extends X86Instruction, @x86_lwpval { }

  class X86Lzcnt extends X86Instruction, @x86_lzcnt { }

  class X86Maskmovdqu extends X86Instruction, @x86_maskmovdqu { }

  class X86Maskmovq extends X86Instruction, @x86_maskmovq { }

  class X86Maxpd extends X86Instruction, @x86_maxpd { }

  class X86Maxps extends X86Instruction, @x86_maxps { }

  class X86Maxsd extends X86Instruction, @x86_maxsd { }

  class X86Maxss extends X86Instruction, @x86_maxss { }

  class X86Mcommit extends X86Instruction, @x86_mcommit { }

  class X86Mfence extends X86Instruction, @x86_mfence { }

  class X86Minpd extends X86Instruction, @x86_minpd { }

  class X86Minps extends X86Instruction, @x86_minps { }

  class X86Minsd extends X86Instruction, @x86_minsd { }

  class X86Minss extends X86Instruction, @x86_minss { }

  class X86Monitor extends X86Instruction, @x86_monitor { }

  class X86Monitorx extends X86Instruction, @x86_monitorx { }

  class X86Montmul extends X86Instruction, @x86_montmul { }

  class X86Mov extends X86Instruction, @x86_mov { }

  class X86Movapd extends X86Instruction, @x86_movapd { }

  class X86Movaps extends X86Instruction, @x86_movaps { }

  class X86Movbe extends X86Instruction, @x86_movbe { }

  class X86Movd extends X86Instruction, @x86_movd { }

  class X86Movddup extends X86Instruction, @x86_movddup { }

  class X86Movdir64B extends X86Instruction, @x86_movdir64b { }

  class X86Movdiri extends X86Instruction, @x86_movdiri { }

  class X86Movdq2Q extends X86Instruction, @x86_movdq2q { }

  class X86Movdqa extends X86Instruction, @x86_movdqa { }

  class X86Movdqu extends X86Instruction, @x86_movdqu { }

  class X86Movhlps extends X86Instruction, @x86_movhlps { }

  class X86Movhpd extends X86Instruction, @x86_movhpd { }

  class X86Movhps extends X86Instruction, @x86_movhps { }

  class X86Movlhps extends X86Instruction, @x86_movlhps { }

  class X86Movlpd extends X86Instruction, @x86_movlpd { }

  class X86Movlps extends X86Instruction, @x86_movlps { }

  class X86Movmskpd extends X86Instruction, @x86_movmskpd { }

  class X86Movmskps extends X86Instruction, @x86_movmskps { }

  class X86Movntdq extends X86Instruction, @x86_movntdq { }

  class X86Movntdqa extends X86Instruction, @x86_movntdqa { }

  class X86Movnti extends X86Instruction, @x86_movnti { }

  class X86Movntpd extends X86Instruction, @x86_movntpd { }

  class X86Movntps extends X86Instruction, @x86_movntps { }

  class X86Movntq extends X86Instruction, @x86_movntq { }

  class X86Movntsd extends X86Instruction, @x86_movntsd { }

  class X86Movntss extends X86Instruction, @x86_movntss { }

  class X86Movq extends X86Instruction, @x86_movq { }

  class X86Movq2Dq extends X86Instruction, @x86_movq2dq { }

  class X86Movsb extends X86Instruction, @x86_movsb { }

  class X86Movsd extends X86Instruction, @x86_movsd { }

  class X86Movshdup extends X86Instruction, @x86_movshdup { }

  class X86Movsldup extends X86Instruction, @x86_movsldup { }

  class X86Movsq extends X86Instruction, @x86_movsq { }

  class X86Movss extends X86Instruction, @x86_movss { }

  class X86Movsw extends X86Instruction, @x86_movsw { }

  class X86Movsx extends X86Instruction, @x86_movsx { }

  class X86Movsxd extends X86Instruction, @x86_movsxd { }

  class X86Movupd extends X86Instruction, @x86_movupd { }

  class X86Movups extends X86Instruction, @x86_movups { }

  class X86Movzx extends X86Instruction, @x86_movzx { }

  class X86Mpsadbw extends X86Instruction, @x86_mpsadbw { }

  class X86Mul extends X86Instruction, @x86_mul { }

  class X86Mulpd extends X86Instruction, @x86_mulpd { }

  class X86Mulps extends X86Instruction, @x86_mulps { }

  class X86Mulsd extends X86Instruction, @x86_mulsd { }

  class X86Mulss extends X86Instruction, @x86_mulss { }

  class X86Mulx extends X86Instruction, @x86_mulx { }

  class X86Mwait extends X86Instruction, @x86_mwait { }

  class X86Mwaitx extends X86Instruction, @x86_mwaitx { }

  class X86Neg extends X86Instruction, @x86_neg { }

  class X86Nop extends X86Instruction, @x86_nop { }

  class X86Not extends X86Instruction, @x86_not { }

  class X86Or extends X86Instruction, @x86_or { }

  class X86Orpd extends X86Instruction, @x86_orpd { }

  class X86Orps extends X86Instruction, @x86_orps { }

  class X86Out extends X86Instruction, @x86_out { }

  class X86Outsb extends X86Instruction, @x86_outsb { }

  class X86Outsd extends X86Instruction, @x86_outsd { }

  class X86Outsw extends X86Instruction, @x86_outsw { }

  class X86Pabsb extends X86Instruction, @x86_pabsb { }

  class X86Pabsd extends X86Instruction, @x86_pabsd { }

  class X86Pabsw extends X86Instruction, @x86_pabsw { }

  class X86Packssdw extends X86Instruction, @x86_packssdw { }

  class X86Packsswb extends X86Instruction, @x86_packsswb { }

  class X86Packusdw extends X86Instruction, @x86_packusdw { }

  class X86Packuswb extends X86Instruction, @x86_packuswb { }

  class X86Paddb extends X86Instruction, @x86_paddb { }

  class X86Paddd extends X86Instruction, @x86_paddd { }

  class X86Paddq extends X86Instruction, @x86_paddq { }

  class X86Paddsb extends X86Instruction, @x86_paddsb { }

  class X86Paddsw extends X86Instruction, @x86_paddsw { }

  class X86Paddusb extends X86Instruction, @x86_paddusb { }

  class X86Paddusw extends X86Instruction, @x86_paddusw { }

  class X86Paddw extends X86Instruction, @x86_paddw { }

  class X86Palignr extends X86Instruction, @x86_palignr { }

  class X86Pand extends X86Instruction, @x86_pand { }

  class X86Pandn extends X86Instruction, @x86_pandn { }

  class X86Pause extends X86Instruction, @x86_pause { }

  class X86Pavgb extends X86Instruction, @x86_pavgb { }

  class X86Pavgusb extends X86Instruction, @x86_pavgusb { }

  class X86Pavgw extends X86Instruction, @x86_pavgw { }

  class X86Pblendvb extends X86Instruction, @x86_pblendvb { }

  class X86Pblendw extends X86Instruction, @x86_pblendw { }

  class X86Pbndkb extends X86Instruction, @x86_pbndkb { }

  class X86Pclmulqdq extends X86Instruction, @x86_pclmulqdq { }

  class X86Pcmpeqb extends X86Instruction, @x86_pcmpeqb { }

  class X86Pcmpeqd extends X86Instruction, @x86_pcmpeqd { }

  class X86Pcmpeqq extends X86Instruction, @x86_pcmpeqq { }

  class X86Pcmpeqw extends X86Instruction, @x86_pcmpeqw { }

  class X86Pcmpestri extends X86Instruction, @x86_pcmpestri { }

  class X86Pcmpestrm extends X86Instruction, @x86_pcmpestrm { }

  class X86Pcmpgtb extends X86Instruction, @x86_pcmpgtb { }

  class X86Pcmpgtd extends X86Instruction, @x86_pcmpgtd { }

  class X86Pcmpgtq extends X86Instruction, @x86_pcmpgtq { }

  class X86Pcmpgtw extends X86Instruction, @x86_pcmpgtw { }

  class X86Pcmpistri extends X86Instruction, @x86_pcmpistri { }

  class X86Pcmpistrm extends X86Instruction, @x86_pcmpistrm { }

  class X86Pcommit extends X86Instruction, @x86_pcommit { }

  class X86Pconfig extends X86Instruction, @x86_pconfig { }

  class X86Pdep extends X86Instruction, @x86_pdep { }

  class X86Pext extends X86Instruction, @x86_pext { }

  class X86Pextrb extends X86Instruction, @x86_pextrb { }

  class X86Pextrd extends X86Instruction, @x86_pextrd { }

  class X86Pextrq extends X86Instruction, @x86_pextrq { }

  class X86Pextrw extends X86Instruction, @x86_pextrw { }

  class X86Pf2Id extends X86Instruction, @x86_pf2id { }

  class X86Pf2Iw extends X86Instruction, @x86_pf2iw { }

  class X86Pfacc extends X86Instruction, @x86_pfacc { }

  class X86Pfadd extends X86Instruction, @x86_pfadd { }

  class X86Pfcmpeq extends X86Instruction, @x86_pfcmpeq { }

  class X86Pfcmpge extends X86Instruction, @x86_pfcmpge { }

  class X86Pfcmpgt extends X86Instruction, @x86_pfcmpgt { }

  class X86Pfcpit1 extends X86Instruction, @x86_pfcpit1 { }

  class X86Pfmax extends X86Instruction, @x86_pfmax { }

  class X86Pfmin extends X86Instruction, @x86_pfmin { }

  class X86Pfmul extends X86Instruction, @x86_pfmul { }

  class X86Pfnacc extends X86Instruction, @x86_pfnacc { }

  class X86Pfpnacc extends X86Instruction, @x86_pfpnacc { }

  class X86Pfrcp extends X86Instruction, @x86_pfrcp { }

  class X86Pfrcpit2 extends X86Instruction, @x86_pfrcpit2 { }

  class X86Pfrsqit1 extends X86Instruction, @x86_pfrsqit1 { }

  class X86Pfsqrt extends X86Instruction, @x86_pfsqrt { }

  class X86Pfsub extends X86Instruction, @x86_pfsub { }

  class X86Pfsubr extends X86Instruction, @x86_pfsubr { }

  class X86Phaddd extends X86Instruction, @x86_phaddd { }

  class X86Phaddsw extends X86Instruction, @x86_phaddsw { }

  class X86Phaddw extends X86Instruction, @x86_phaddw { }

  class X86Phminposuw extends X86Instruction, @x86_phminposuw { }

  class X86Phsubd extends X86Instruction, @x86_phsubd { }

  class X86Phsubsw extends X86Instruction, @x86_phsubsw { }

  class X86Phsubw extends X86Instruction, @x86_phsubw { }

  class X86Pi2Fd extends X86Instruction, @x86_pi2fd { }

  class X86Pi2Fw extends X86Instruction, @x86_pi2fw { }

  class X86Pinsrb extends X86Instruction, @x86_pinsrb { }

  class X86Pinsrd extends X86Instruction, @x86_pinsrd { }

  class X86Pinsrq extends X86Instruction, @x86_pinsrq { }

  class X86Pinsrw extends X86Instruction, @x86_pinsrw { }

  class X86Pmaddubsw extends X86Instruction, @x86_pmaddubsw { }

  class X86Pmaddwd extends X86Instruction, @x86_pmaddwd { }

  class X86Pmaxsb extends X86Instruction, @x86_pmaxsb { }

  class X86Pmaxsd extends X86Instruction, @x86_pmaxsd { }

  class X86Pmaxsw extends X86Instruction, @x86_pmaxsw { }

  class X86Pmaxub extends X86Instruction, @x86_pmaxub { }

  class X86Pmaxud extends X86Instruction, @x86_pmaxud { }

  class X86Pmaxuw extends X86Instruction, @x86_pmaxuw { }

  class X86Pminsb extends X86Instruction, @x86_pminsb { }

  class X86Pminsd extends X86Instruction, @x86_pminsd { }

  class X86Pminsw extends X86Instruction, @x86_pminsw { }

  class X86Pminub extends X86Instruction, @x86_pminub { }

  class X86Pminud extends X86Instruction, @x86_pminud { }

  class X86Pminuw extends X86Instruction, @x86_pminuw { }

  class X86Pmovmskb extends X86Instruction, @x86_pmovmskb { }

  class X86Pmovsxbd extends X86Instruction, @x86_pmovsxbd { }

  class X86Pmovsxbq extends X86Instruction, @x86_pmovsxbq { }

  class X86Pmovsxbw extends X86Instruction, @x86_pmovsxbw { }

  class X86Pmovsxdq extends X86Instruction, @x86_pmovsxdq { }

  class X86Pmovsxwd extends X86Instruction, @x86_pmovsxwd { }

  class X86Pmovsxwq extends X86Instruction, @x86_pmovsxwq { }

  class X86Pmovzxbd extends X86Instruction, @x86_pmovzxbd { }

  class X86Pmovzxbq extends X86Instruction, @x86_pmovzxbq { }

  class X86Pmovzxbw extends X86Instruction, @x86_pmovzxbw { }

  class X86Pmovzxdq extends X86Instruction, @x86_pmovzxdq { }

  class X86Pmovzxwd extends X86Instruction, @x86_pmovzxwd { }

  class X86Pmovzxwq extends X86Instruction, @x86_pmovzxwq { }

  class X86Pmuldq extends X86Instruction, @x86_pmuldq { }

  class X86Pmulhrsw extends X86Instruction, @x86_pmulhrsw { }

  class X86Pmulhrw extends X86Instruction, @x86_pmulhrw { }

  class X86Pmulhuw extends X86Instruction, @x86_pmulhuw { }

  class X86Pmulhw extends X86Instruction, @x86_pmulhw { }

  class X86Pmulld extends X86Instruction, @x86_pmulld { }

  class X86Pmullw extends X86Instruction, @x86_pmullw { }

  class X86Pmuludq extends X86Instruction, @x86_pmuludq { }

  class X86Pop extends X86Instruction, @x86_pop { }

  class X86Pop2 extends X86Instruction, @x86_pop2 { }

  class X86Pop2P extends X86Instruction, @x86_pop2p { }

  class X86Popa extends X86Instruction, @x86_popa { }

  class X86Popad extends X86Instruction, @x86_popad { }

  class X86Popcnt extends X86Instruction, @x86_popcnt { }

  class X86Popf extends X86Instruction, @x86_popf { }

  class X86Popfd extends X86Instruction, @x86_popfd { }

  class X86Popfq extends X86Instruction, @x86_popfq { }

  class X86Popp extends X86Instruction, @x86_popp { }

  class X86Por extends X86Instruction, @x86_por { }

  class X86Prefetch extends X86Instruction, @x86_prefetch { }

  class X86Prefetchit0 extends X86Instruction, @x86_prefetchit0 { }

  class X86Prefetchit1 extends X86Instruction, @x86_prefetchit1 { }

  class X86Prefetchnta extends X86Instruction, @x86_prefetchnta { }

  class X86Prefetcht0 extends X86Instruction, @x86_prefetcht0 { }

  class X86Prefetcht1 extends X86Instruction, @x86_prefetcht1 { }

  class X86Prefetcht2 extends X86Instruction, @x86_prefetcht2 { }

  class X86Prefetchw extends X86Instruction, @x86_prefetchw { }

  class X86Prefetchwt1 extends X86Instruction, @x86_prefetchwt1 { }

  class X86Psadbw extends X86Instruction, @x86_psadbw { }

  class X86Pshufb extends X86Instruction, @x86_pshufb { }

  class X86Pshufd extends X86Instruction, @x86_pshufd { }

  class X86Pshufhw extends X86Instruction, @x86_pshufhw { }

  class X86Pshuflw extends X86Instruction, @x86_pshuflw { }

  class X86Pshufw extends X86Instruction, @x86_pshufw { }

  class X86Psignb extends X86Instruction, @x86_psignb { }

  class X86Psignd extends X86Instruction, @x86_psignd { }

  class X86Psignw extends X86Instruction, @x86_psignw { }

  class X86Pslld extends X86Instruction, @x86_pslld { }

  class X86Pslldq extends X86Instruction, @x86_pslldq { }

  class X86Psllq extends X86Instruction, @x86_psllq { }

  class X86Psllw extends X86Instruction, @x86_psllw { }

  class X86Psmash extends X86Instruction, @x86_psmash { }

  class X86Psrad extends X86Instruction, @x86_psrad { }

  class X86Psraw extends X86Instruction, @x86_psraw { }

  class X86Psrld extends X86Instruction, @x86_psrld { }

  class X86Psrldq extends X86Instruction, @x86_psrldq { }

  class X86Psrlq extends X86Instruction, @x86_psrlq { }

  class X86Psrlw extends X86Instruction, @x86_psrlw { }

  class X86Psubb extends X86Instruction, @x86_psubb { }

  class X86Psubd extends X86Instruction, @x86_psubd { }

  class X86Psubq extends X86Instruction, @x86_psubq { }

  class X86Psubsb extends X86Instruction, @x86_psubsb { }

  class X86Psubsw extends X86Instruction, @x86_psubsw { }

  class X86Psubusb extends X86Instruction, @x86_psubusb { }

  class X86Psubusw extends X86Instruction, @x86_psubusw { }

  class X86Psubw extends X86Instruction, @x86_psubw { }

  class X86Pswapd extends X86Instruction, @x86_pswapd { }

  class X86Ptest extends X86Instruction, @x86_ptest { }

  class X86Ptwrite extends X86Instruction, @x86_ptwrite { }

  class X86Punpckhbw extends X86Instruction, @x86_punpckhbw { }

  class X86Punpckhdq extends X86Instruction, @x86_punpckhdq { }

  class X86Punpckhqdq extends X86Instruction, @x86_punpckhqdq { }

  class X86Punpckhwd extends X86Instruction, @x86_punpckhwd { }

  class X86Punpcklbw extends X86Instruction, @x86_punpcklbw { }

  class X86Punpckldq extends X86Instruction, @x86_punpckldq { }

  class X86Punpcklqdq extends X86Instruction, @x86_punpcklqdq { }

  class X86Punpcklwd extends X86Instruction, @x86_punpcklwd { }

  class X86Push extends X86Instruction, @x86_push { }

  class X86Push2 extends X86Instruction, @x86_push2 { }

  class X86Push2P extends X86Instruction, @x86_push2p { }

  class X86Pusha extends X86Instruction, @x86_pusha { }

  class X86Pushad extends X86Instruction, @x86_pushad { }

  class X86Pushf extends X86Instruction, @x86_pushf { }

  class X86Pushfd extends X86Instruction, @x86_pushfd { }

  class X86Pushfq extends X86Instruction, @x86_pushfq { }

  class X86Pushp extends X86Instruction, @x86_pushp { }

  class X86Pvalidate extends X86Instruction, @x86_pvalidate { }

  class X86Pxor extends X86Instruction, @x86_pxor { }

  class X86Rcl extends X86Instruction, @x86_rcl { }

  class X86Rcpps extends X86Instruction, @x86_rcpps { }

  class X86Rcpss extends X86Instruction, @x86_rcpss { }

  class X86Rcr extends X86Instruction, @x86_rcr { }

  class X86Rdfsbase extends X86Instruction, @x86_rdfsbase { }

  class X86Rdgsbase extends X86Instruction, @x86_rdgsbase { }

  class X86Rdmsr extends X86Instruction, @x86_rdmsr { }

  class X86Rdmsrlist extends X86Instruction, @x86_rdmsrlist { }

  class X86Rdpid extends X86Instruction, @x86_rdpid { }

  class X86Rdpkru extends X86Instruction, @x86_rdpkru { }

  class X86Rdpmc extends X86Instruction, @x86_rdpmc { }

  class X86Rdpru extends X86Instruction, @x86_rdpru { }

  class X86Rdrand extends X86Instruction, @x86_rdrand { }

  class X86Rdseed extends X86Instruction, @x86_rdseed { }

  class X86Rdsspd extends X86Instruction, @x86_rdsspd { }

  class X86Rdsspq extends X86Instruction, @x86_rdsspq { }

  class X86Rdtsc extends X86Instruction, @x86_rdtsc { }

  class X86Rdtscp extends X86Instruction, @x86_rdtscp { }

  class X86Ret extends X86Instruction, @x86_ret {
    override X86Instruction getASuccessor() { none() }
  }

  class X86Rmpadjust extends X86Instruction, @x86_rmpadjust { }

  class X86Rmpupdate extends X86Instruction, @x86_rmpupdate { }

  class X86Rol extends X86Instruction, @x86_rol { }

  class X86Ror extends X86Instruction, @x86_ror { }

  class X86Rorx extends X86Instruction, @x86_rorx { }

  class X86Roundpd extends X86Instruction, @x86_roundpd { }

  class X86Roundps extends X86Instruction, @x86_roundps { }

  class X86Roundsd extends X86Instruction, @x86_roundsd { }

  class X86Roundss extends X86Instruction, @x86_roundss { }

  class X86Rsm extends X86Instruction, @x86_rsm { }

  class X86Rsqrtps extends X86Instruction, @x86_rsqrtps { }

  class X86Rsqrtss extends X86Instruction, @x86_rsqrtss { }

  class X86Rstorssp extends X86Instruction, @x86_rstorssp { }

  class X86Sahf extends X86Instruction, @x86_sahf { }

  class X86Salc extends X86Instruction, @x86_salc { }

  class X86Sar extends X86Instruction, @x86_sar { }

  class X86Sarx extends X86Instruction, @x86_sarx { }

  class X86Saveprevssp extends X86Instruction, @x86_saveprevssp { }

  class X86Sbb extends X86Instruction, @x86_sbb { }

  class X86Scasb extends X86Instruction, @x86_scasb { }

  class X86Scasd extends X86Instruction, @x86_scasd { }

  class X86Scasq extends X86Instruction, @x86_scasq { }

  class X86Scasw extends X86Instruction, @x86_scasw { }

  class X86Seamcall extends X86Instruction, @x86_seamcall { }

  class X86Seamops extends X86Instruction, @x86_seamops { }

  class X86Seamret extends X86Instruction, @x86_seamret { }

  class X86Senduipi extends X86Instruction, @x86_senduipi { }

  class X86Serialize extends X86Instruction, @x86_serialize { }

  class X86Setb extends X86Instruction, @x86_setb { }

  class X86Setbe extends X86Instruction, @x86_setbe { }

  class X86Setl extends X86Instruction, @x86_setl { }

  class X86Setle extends X86Instruction, @x86_setle { }

  class X86Setnb extends X86Instruction, @x86_setnb { }

  class X86Setnbe extends X86Instruction, @x86_setnbe { }

  class X86Setnl extends X86Instruction, @x86_setnl { }

  class X86Setnle extends X86Instruction, @x86_setnle { }

  class X86Setno extends X86Instruction, @x86_setno { }

  class X86Setnp extends X86Instruction, @x86_setnp { }

  class X86Setns extends X86Instruction, @x86_setns { }

  class X86Setnz extends X86Instruction, @x86_setnz { }

  class X86Seto extends X86Instruction, @x86_seto { }

  class X86Setp extends X86Instruction, @x86_setp { }

  class X86Sets extends X86Instruction, @x86_sets { }

  class X86Setssbsy extends X86Instruction, @x86_setssbsy { }

  class X86Setz extends X86Instruction, @x86_setz { }

  class X86Setzub extends X86Instruction, @x86_setzub { }

  class X86Setzube extends X86Instruction, @x86_setzube { }

  class X86Setzul extends X86Instruction, @x86_setzul { }

  class X86Setzule extends X86Instruction, @x86_setzule { }

  class X86Setzunb extends X86Instruction, @x86_setzunb { }

  class X86Setzunbe extends X86Instruction, @x86_setzunbe { }

  class X86Setzunl extends X86Instruction, @x86_setzunl { }

  class X86Setzunle extends X86Instruction, @x86_setzunle { }

  class X86Setzuno extends X86Instruction, @x86_setzuno { }

  class X86Setzunp extends X86Instruction, @x86_setzunp { }

  class X86Setzuns extends X86Instruction, @x86_setzuns { }

  class X86Setzunz extends X86Instruction, @x86_setzunz { }

  class X86Setzuo extends X86Instruction, @x86_setzuo { }

  class X86Setzup extends X86Instruction, @x86_setzup { }

  class X86Setzus extends X86Instruction, @x86_setzus { }

  class X86Setzuz extends X86Instruction, @x86_setzuz { }

  class X86Sfence extends X86Instruction, @x86_sfence { }

  class X86Sgdt extends X86Instruction, @x86_sgdt { }

  class X86Sha1Msg1 extends X86Instruction, @x86_sha1msg1 { }

  class X86Sha1Msg2 extends X86Instruction, @x86_sha1msg2 { }

  class X86Sha1Nexte extends X86Instruction, @x86_sha1nexte { }

  class X86Sha1Rnds4 extends X86Instruction, @x86_sha1rnds4 { }

  class X86Sha256Msg1 extends X86Instruction, @x86_sha256msg1 { }

  class X86Sha256Msg2 extends X86Instruction, @x86_sha256msg2 { }

  class X86Sha256Rnds2 extends X86Instruction, @x86_sha256rnds2 { }

  class X86Shl extends X86Instruction, @x86_shl { }

  class X86Shld extends X86Instruction, @x86_shld { }

  class X86Shlx extends X86Instruction, @x86_shlx { }

  class X86Shr extends X86Instruction, @x86_shr { }

  class X86Shrd extends X86Instruction, @x86_shrd { }

  class X86Shrx extends X86Instruction, @x86_shrx { }

  class X86Shufpd extends X86Instruction, @x86_shufpd { }

  class X86Shufps extends X86Instruction, @x86_shufps { }

  class X86Sidt extends X86Instruction, @x86_sidt { }

  class X86Skinit extends X86Instruction, @x86_skinit { }

  class X86Sldt extends X86Instruction, @x86_sldt { }

  class X86Slwpcb extends X86Instruction, @x86_slwpcb { }

  class X86Smsw extends X86Instruction, @x86_smsw { }

  class X86Spflt extends X86Instruction, @x86_spflt { }

  class X86Sqrtpd extends X86Instruction, @x86_sqrtpd { }

  class X86Sqrtps extends X86Instruction, @x86_sqrtps { }

  class X86Sqrtsd extends X86Instruction, @x86_sqrtsd { }

  class X86Sqrtss extends X86Instruction, @x86_sqrtss { }

  class X86Stac extends X86Instruction, @x86_stac { }

  class X86Stc extends X86Instruction, @x86_stc { }

  class X86Std extends X86Instruction, @x86_std { }

  class X86Stgi extends X86Instruction, @x86_stgi { }

  class X86Sti extends X86Instruction, @x86_sti { }

  class X86Stmxcsr extends X86Instruction, @x86_stmxcsr { }

  class X86Stosb extends X86Instruction, @x86_stosb { }

  class X86Stosd extends X86Instruction, @x86_stosd { }

  class X86Stosq extends X86Instruction, @x86_stosq { }

  class X86Stosw extends X86Instruction, @x86_stosw { }

  class X86Str extends X86Instruction, @x86_str { }

  class X86Sttilecfg extends X86Instruction, @x86_sttilecfg { }

  class X86Stui extends X86Instruction, @x86_stui { }

  class X86Sub extends X86Instruction, @x86_sub { }

  class X86Subpd extends X86Instruction, @x86_subpd { }

  class X86Subps extends X86Instruction, @x86_subps { }

  class X86Subsd extends X86Instruction, @x86_subsd { }

  class X86Subss extends X86Instruction, @x86_subss { }

  class X86Swapgs extends X86Instruction, @x86_swapgs { }

  class X86Syscall extends X86Instruction, @x86_syscall { }

  class X86Sysenter extends X86Instruction, @x86_sysenter { }

  class X86Sysexit extends X86Instruction, @x86_sysexit { }

  class X86Sysret extends X86Instruction, @x86_sysret { }

  class X86T1Mskc extends X86Instruction, @x86_t1mskc { }

  class X86Tdcall extends X86Instruction, @x86_tdcall { }

  class X86Tdpbf16Ps extends X86Instruction, @x86_tdpbf16ps { }

  class X86Tdpbssd extends X86Instruction, @x86_tdpbssd { }

  class X86Tdpbsud extends X86Instruction, @x86_tdpbsud { }

  class X86Tdpbusd extends X86Instruction, @x86_tdpbusd { }

  class X86Tdpbuud extends X86Instruction, @x86_tdpbuud { }

  class X86Tdpfp16Ps extends X86Instruction, @x86_tdpfp16ps { }

  class X86Test extends X86Instruction, @x86_test { }

  class X86Testui extends X86Instruction, @x86_testui { }

  class X86Tileloadd extends X86Instruction, @x86_tileloadd { }

  class X86Tileloaddt1 extends X86Instruction, @x86_tileloaddt1 { }

  class X86Tilerelease extends X86Instruction, @x86_tilerelease { }

  class X86Tilestored extends X86Instruction, @x86_tilestored { }

  class X86Tilezero extends X86Instruction, @x86_tilezero { }

  class X86Tlbsync extends X86Instruction, @x86_tlbsync { }

  class X86Tpause extends X86Instruction, @x86_tpause { }

  class X86Tzcnt extends X86Instruction, @x86_tzcnt { }

  class X86Tzcnti extends X86Instruction, @x86_tzcnti { }

  class X86Tzmsk extends X86Instruction, @x86_tzmsk { }

  class X86Ucomisd extends X86Instruction, @x86_ucomisd { }

  class X86Ucomiss extends X86Instruction, @x86_ucomiss { }

  class X86Ud0 extends X86Instruction, @x86_ud0 { }

  class X86Ud1 extends X86Instruction, @x86_ud1 { }

  class X86Ud2 extends X86Instruction, @x86_ud2 { }

  class X86Uiret extends X86Instruction, @x86_uiret { }

  class X86Umonitor extends X86Instruction, @x86_umonitor { }

  class X86Umwait extends X86Instruction, @x86_umwait { }

  class X86Unpckhpd extends X86Instruction, @x86_unpckhpd { }

  class X86Unpckhps extends X86Instruction, @x86_unpckhps { }

  class X86Unpcklpd extends X86Instruction, @x86_unpcklpd { }

  class X86Unpcklps extends X86Instruction, @x86_unpcklps { }

  class X86Urdmsr extends X86Instruction, @x86_urdmsr { }

  class X86Uwrmsr extends X86Instruction, @x86_uwrmsr { }

  class X86V4Fmaddps extends X86Instruction, @x86_v4fmaddps { }

  class X86V4Fmaddss extends X86Instruction, @x86_v4fmaddss { }

  class X86V4Fnmaddps extends X86Instruction, @x86_v4fnmaddps { }

  class X86V4Fnmaddss extends X86Instruction, @x86_v4fnmaddss { }

  class X86Vaddnpd extends X86Instruction, @x86_vaddnpd { }

  class X86Vaddnps extends X86Instruction, @x86_vaddnps { }

  class X86Vaddpd extends X86Instruction, @x86_vaddpd { }

  class X86Vaddph extends X86Instruction, @x86_vaddph { }

  class X86Vaddps extends X86Instruction, @x86_vaddps { }

  class X86Vaddsd extends X86Instruction, @x86_vaddsd { }

  class X86Vaddsetsps extends X86Instruction, @x86_vaddsetsps { }

  class X86Vaddsh extends X86Instruction, @x86_vaddsh { }

  class X86Vaddss extends X86Instruction, @x86_vaddss { }

  class X86Vaddsubpd extends X86Instruction, @x86_vaddsubpd { }

  class X86Vaddsubps extends X86Instruction, @x86_vaddsubps { }

  class X86Vaesdec extends X86Instruction, @x86_vaesdec { }

  class X86Vaesdeclast extends X86Instruction, @x86_vaesdeclast { }

  class X86Vaesenc extends X86Instruction, @x86_vaesenc { }

  class X86Vaesenclast extends X86Instruction, @x86_vaesenclast { }

  class X86Vaesimc extends X86Instruction, @x86_vaesimc { }

  class X86Vaeskeygenassist extends X86Instruction, @x86_vaeskeygenassist { }

  class X86Valignd extends X86Instruction, @x86_valignd { }

  class X86Valignq extends X86Instruction, @x86_valignq { }

  class X86Vandnpd extends X86Instruction, @x86_vandnpd { }

  class X86Vandnps extends X86Instruction, @x86_vandnps { }

  class X86Vandpd extends X86Instruction, @x86_vandpd { }

  class X86Vandps extends X86Instruction, @x86_vandps { }

  class X86Vbcstnebf162Ps extends X86Instruction, @x86_vbcstnebf162ps { }

  class X86Vbcstnesh2Ps extends X86Instruction, @x86_vbcstnesh2ps { }

  class X86Vblendmpd extends X86Instruction, @x86_vblendmpd { }

  class X86Vblendmps extends X86Instruction, @x86_vblendmps { }

  class X86Vblendpd extends X86Instruction, @x86_vblendpd { }

  class X86Vblendps extends X86Instruction, @x86_vblendps { }

  class X86Vblendvpd extends X86Instruction, @x86_vblendvpd { }

  class X86Vblendvps extends X86Instruction, @x86_vblendvps { }

  class X86Vbroadcastf128 extends X86Instruction, @x86_vbroadcastf128 { }

  class X86Vbroadcastf32X2 extends X86Instruction, @x86_vbroadcastf32x2 { }

  class X86Vbroadcastf32X4 extends X86Instruction, @x86_vbroadcastf32x4 { }

  class X86Vbroadcastf32X8 extends X86Instruction, @x86_vbroadcastf32x8 { }

  class X86Vbroadcastf64X2 extends X86Instruction, @x86_vbroadcastf64x2 { }

  class X86Vbroadcastf64X4 extends X86Instruction, @x86_vbroadcastf64x4 { }

  class X86Vbroadcasti128 extends X86Instruction, @x86_vbroadcasti128 { }

  class X86Vbroadcasti32X2 extends X86Instruction, @x86_vbroadcasti32x2 { }

  class X86Vbroadcasti32X4 extends X86Instruction, @x86_vbroadcasti32x4 { }

  class X86Vbroadcasti32X8 extends X86Instruction, @x86_vbroadcasti32x8 { }

  class X86Vbroadcasti64X2 extends X86Instruction, @x86_vbroadcasti64x2 { }

  class X86Vbroadcasti64X4 extends X86Instruction, @x86_vbroadcasti64x4 { }

  class X86Vbroadcastsd extends X86Instruction, @x86_vbroadcastsd { }

  class X86Vbroadcastss extends X86Instruction, @x86_vbroadcastss { }

  class X86Vcmppd extends X86Instruction, @x86_vcmppd { }

  class X86Vcmpph extends X86Instruction, @x86_vcmpph { }

  class X86Vcmpps extends X86Instruction, @x86_vcmpps { }

  class X86Vcmpsd extends X86Instruction, @x86_vcmpsd { }

  class X86Vcmpsh extends X86Instruction, @x86_vcmpsh { }

  class X86Vcmpss extends X86Instruction, @x86_vcmpss { }

  class X86Vcomisd extends X86Instruction, @x86_vcomisd { }

  class X86Vcomish extends X86Instruction, @x86_vcomish { }

  class X86Vcomiss extends X86Instruction, @x86_vcomiss { }

  class X86Vcompresspd extends X86Instruction, @x86_vcompresspd { }

  class X86Vcompressps extends X86Instruction, @x86_vcompressps { }

  class X86Vcvtdq2Pd extends X86Instruction, @x86_vcvtdq2pd { }

  class X86Vcvtdq2Ph extends X86Instruction, @x86_vcvtdq2ph { }

  class X86Vcvtdq2Ps extends X86Instruction, @x86_vcvtdq2ps { }

  class X86Vcvtfxpntdq2Ps extends X86Instruction, @x86_vcvtfxpntdq2ps { }

  class X86Vcvtfxpntpd2Dq extends X86Instruction, @x86_vcvtfxpntpd2dq { }

  class X86Vcvtfxpntpd2Udq extends X86Instruction, @x86_vcvtfxpntpd2udq { }

  class X86Vcvtfxpntps2Dq extends X86Instruction, @x86_vcvtfxpntps2dq { }

  class X86Vcvtfxpntps2Udq extends X86Instruction, @x86_vcvtfxpntps2udq { }

  class X86Vcvtfxpntudq2Ps extends X86Instruction, @x86_vcvtfxpntudq2ps { }

  class X86Vcvtne2Ps2Bf16 extends X86Instruction, @x86_vcvtne2ps2bf16 { }

  class X86Vcvtneebf162Ps extends X86Instruction, @x86_vcvtneebf162ps { }

  class X86Vcvtneeph2Ps extends X86Instruction, @x86_vcvtneeph2ps { }

  class X86Vcvtneobf162Ps extends X86Instruction, @x86_vcvtneobf162ps { }

  class X86Vcvtneoph2Ps extends X86Instruction, @x86_vcvtneoph2ps { }

  class X86Vcvtneps2Bf16 extends X86Instruction, @x86_vcvtneps2bf16 { }

  class X86Vcvtpd2Dq extends X86Instruction, @x86_vcvtpd2dq { }

  class X86Vcvtpd2Ph extends X86Instruction, @x86_vcvtpd2ph { }

  class X86Vcvtpd2Ps extends X86Instruction, @x86_vcvtpd2ps { }

  class X86Vcvtpd2Qq extends X86Instruction, @x86_vcvtpd2qq { }

  class X86Vcvtpd2Udq extends X86Instruction, @x86_vcvtpd2udq { }

  class X86Vcvtpd2Uqq extends X86Instruction, @x86_vcvtpd2uqq { }

  class X86Vcvtph2Dq extends X86Instruction, @x86_vcvtph2dq { }

  class X86Vcvtph2Pd extends X86Instruction, @x86_vcvtph2pd { }

  class X86Vcvtph2Ps extends X86Instruction, @x86_vcvtph2ps { }

  class X86Vcvtph2Psx extends X86Instruction, @x86_vcvtph2psx { }

  class X86Vcvtph2Qq extends X86Instruction, @x86_vcvtph2qq { }

  class X86Vcvtph2Udq extends X86Instruction, @x86_vcvtph2udq { }

  class X86Vcvtph2Uqq extends X86Instruction, @x86_vcvtph2uqq { }

  class X86Vcvtph2Uw extends X86Instruction, @x86_vcvtph2uw { }

  class X86Vcvtph2W extends X86Instruction, @x86_vcvtph2w { }

  class X86Vcvtps2Dq extends X86Instruction, @x86_vcvtps2dq { }

  class X86Vcvtps2Pd extends X86Instruction, @x86_vcvtps2pd { }

  class X86Vcvtps2Ph extends X86Instruction, @x86_vcvtps2ph { }

  class X86Vcvtps2Phx extends X86Instruction, @x86_vcvtps2phx { }

  class X86Vcvtps2Qq extends X86Instruction, @x86_vcvtps2qq { }

  class X86Vcvtps2Udq extends X86Instruction, @x86_vcvtps2udq { }

  class X86Vcvtps2Uqq extends X86Instruction, @x86_vcvtps2uqq { }

  class X86Vcvtqq2Pd extends X86Instruction, @x86_vcvtqq2pd { }

  class X86Vcvtqq2Ph extends X86Instruction, @x86_vcvtqq2ph { }

  class X86Vcvtqq2Ps extends X86Instruction, @x86_vcvtqq2ps { }

  class X86Vcvtsd2Sh extends X86Instruction, @x86_vcvtsd2sh { }

  class X86Vcvtsd2Si extends X86Instruction, @x86_vcvtsd2si { }

  class X86Vcvtsd2Ss extends X86Instruction, @x86_vcvtsd2ss { }

  class X86Vcvtsd2Usi extends X86Instruction, @x86_vcvtsd2usi { }

  class X86Vcvtsh2Sd extends X86Instruction, @x86_vcvtsh2sd { }

  class X86Vcvtsh2Si extends X86Instruction, @x86_vcvtsh2si { }

  class X86Vcvtsh2Ss extends X86Instruction, @x86_vcvtsh2ss { }

  class X86Vcvtsh2Usi extends X86Instruction, @x86_vcvtsh2usi { }

  class X86Vcvtsi2Sd extends X86Instruction, @x86_vcvtsi2sd { }

  class X86Vcvtsi2Sh extends X86Instruction, @x86_vcvtsi2sh { }

  class X86Vcvtsi2Ss extends X86Instruction, @x86_vcvtsi2ss { }

  class X86Vcvtss2Sd extends X86Instruction, @x86_vcvtss2sd { }

  class X86Vcvtss2Sh extends X86Instruction, @x86_vcvtss2sh { }

  class X86Vcvtss2Si extends X86Instruction, @x86_vcvtss2si { }

  class X86Vcvtss2Usi extends X86Instruction, @x86_vcvtss2usi { }

  class X86Vcvttpd2Dq extends X86Instruction, @x86_vcvttpd2dq { }

  class X86Vcvttpd2Qq extends X86Instruction, @x86_vcvttpd2qq { }

  class X86Vcvttpd2Udq extends X86Instruction, @x86_vcvttpd2udq { }

  class X86Vcvttpd2Uqq extends X86Instruction, @x86_vcvttpd2uqq { }

  class X86Vcvttph2Dq extends X86Instruction, @x86_vcvttph2dq { }

  class X86Vcvttph2Qq extends X86Instruction, @x86_vcvttph2qq { }

  class X86Vcvttph2Udq extends X86Instruction, @x86_vcvttph2udq { }

  class X86Vcvttph2Uqq extends X86Instruction, @x86_vcvttph2uqq { }

  class X86Vcvttph2Uw extends X86Instruction, @x86_vcvttph2uw { }

  class X86Vcvttph2W extends X86Instruction, @x86_vcvttph2w { }

  class X86Vcvttps2Dq extends X86Instruction, @x86_vcvttps2dq { }

  class X86Vcvttps2Qq extends X86Instruction, @x86_vcvttps2qq { }

  class X86Vcvttps2Udq extends X86Instruction, @x86_vcvttps2udq { }

  class X86Vcvttps2Uqq extends X86Instruction, @x86_vcvttps2uqq { }

  class X86Vcvttsd2Si extends X86Instruction, @x86_vcvttsd2si { }

  class X86Vcvttsd2Usi extends X86Instruction, @x86_vcvttsd2usi { }

  class X86Vcvttsh2Si extends X86Instruction, @x86_vcvttsh2si { }

  class X86Vcvttsh2Usi extends X86Instruction, @x86_vcvttsh2usi { }

  class X86Vcvttss2Si extends X86Instruction, @x86_vcvttss2si { }

  class X86Vcvttss2Usi extends X86Instruction, @x86_vcvttss2usi { }

  class X86Vcvtudq2Pd extends X86Instruction, @x86_vcvtudq2pd { }

  class X86Vcvtudq2Ph extends X86Instruction, @x86_vcvtudq2ph { }

  class X86Vcvtudq2Ps extends X86Instruction, @x86_vcvtudq2ps { }

  class X86Vcvtuqq2Pd extends X86Instruction, @x86_vcvtuqq2pd { }

  class X86Vcvtuqq2Ph extends X86Instruction, @x86_vcvtuqq2ph { }

  class X86Vcvtuqq2Ps extends X86Instruction, @x86_vcvtuqq2ps { }

  class X86Vcvtusi2Sd extends X86Instruction, @x86_vcvtusi2sd { }

  class X86Vcvtusi2Sh extends X86Instruction, @x86_vcvtusi2sh { }

  class X86Vcvtusi2Ss extends X86Instruction, @x86_vcvtusi2ss { }

  class X86Vcvtuw2Ph extends X86Instruction, @x86_vcvtuw2ph { }

  class X86Vcvtw2Ph extends X86Instruction, @x86_vcvtw2ph { }

  class X86Vdbpsadbw extends X86Instruction, @x86_vdbpsadbw { }

  class X86Vdivpd extends X86Instruction, @x86_vdivpd { }

  class X86Vdivph extends X86Instruction, @x86_vdivph { }

  class X86Vdivps extends X86Instruction, @x86_vdivps { }

  class X86Vdivsd extends X86Instruction, @x86_vdivsd { }

  class X86Vdivsh extends X86Instruction, @x86_vdivsh { }

  class X86Vdivss extends X86Instruction, @x86_vdivss { }

  class X86Vdpbf16Ps extends X86Instruction, @x86_vdpbf16ps { }

  class X86Vdppd extends X86Instruction, @x86_vdppd { }

  class X86Vdpps extends X86Instruction, @x86_vdpps { }

  class X86Verr extends X86Instruction, @x86_verr { }

  class X86Verw extends X86Instruction, @x86_verw { }

  class X86Vexp223Ps extends X86Instruction, @x86_vexp223ps { }

  class X86Vexp2Pd extends X86Instruction, @x86_vexp2pd { }

  class X86Vexp2Ps extends X86Instruction, @x86_vexp2ps { }

  class X86Vexpandpd extends X86Instruction, @x86_vexpandpd { }

  class X86Vexpandps extends X86Instruction, @x86_vexpandps { }

  class X86Vextractf128 extends X86Instruction, @x86_vextractf128 { }

  class X86Vextractf32X4 extends X86Instruction, @x86_vextractf32x4 { }

  class X86Vextractf32X8 extends X86Instruction, @x86_vextractf32x8 { }

  class X86Vextractf64X2 extends X86Instruction, @x86_vextractf64x2 { }

  class X86Vextractf64X4 extends X86Instruction, @x86_vextractf64x4 { }

  class X86Vextracti128 extends X86Instruction, @x86_vextracti128 { }

  class X86Vextracti32X4 extends X86Instruction, @x86_vextracti32x4 { }

  class X86Vextracti32X8 extends X86Instruction, @x86_vextracti32x8 { }

  class X86Vextracti64X2 extends X86Instruction, @x86_vextracti64x2 { }

  class X86Vextracti64X4 extends X86Instruction, @x86_vextracti64x4 { }

  class X86Vextractps extends X86Instruction, @x86_vextractps { }

  class X86Vfcmaddcph extends X86Instruction, @x86_vfcmaddcph { }

  class X86Vfcmaddcsh extends X86Instruction, @x86_vfcmaddcsh { }

  class X86Vfcmulcph extends X86Instruction, @x86_vfcmulcph { }

  class X86Vfcmulcsh extends X86Instruction, @x86_vfcmulcsh { }

  class X86Vfixupimmpd extends X86Instruction, @x86_vfixupimmpd { }

  class X86Vfixupimmps extends X86Instruction, @x86_vfixupimmps { }

  class X86Vfixupimmsd extends X86Instruction, @x86_vfixupimmsd { }

  class X86Vfixupimmss extends X86Instruction, @x86_vfixupimmss { }

  class X86Vfixupnanpd extends X86Instruction, @x86_vfixupnanpd { }

  class X86Vfixupnanps extends X86Instruction, @x86_vfixupnanps { }

  class X86Vfmadd132Pd extends X86Instruction, @x86_vfmadd132pd { }

  class X86Vfmadd132Ph extends X86Instruction, @x86_vfmadd132ph { }

  class X86Vfmadd132Ps extends X86Instruction, @x86_vfmadd132ps { }

  class X86Vfmadd132Sd extends X86Instruction, @x86_vfmadd132sd { }

  class X86Vfmadd132Sh extends X86Instruction, @x86_vfmadd132sh { }

  class X86Vfmadd132Ss extends X86Instruction, @x86_vfmadd132ss { }

  class X86Vfmadd213Pd extends X86Instruction, @x86_vfmadd213pd { }

  class X86Vfmadd213Ph extends X86Instruction, @x86_vfmadd213ph { }

  class X86Vfmadd213Ps extends X86Instruction, @x86_vfmadd213ps { }

  class X86Vfmadd213Sd extends X86Instruction, @x86_vfmadd213sd { }

  class X86Vfmadd213Sh extends X86Instruction, @x86_vfmadd213sh { }

  class X86Vfmadd213Ss extends X86Instruction, @x86_vfmadd213ss { }

  class X86Vfmadd231Pd extends X86Instruction, @x86_vfmadd231pd { }

  class X86Vfmadd231Ph extends X86Instruction, @x86_vfmadd231ph { }

  class X86Vfmadd231Ps extends X86Instruction, @x86_vfmadd231ps { }

  class X86Vfmadd231Sd extends X86Instruction, @x86_vfmadd231sd { }

  class X86Vfmadd231Sh extends X86Instruction, @x86_vfmadd231sh { }

  class X86Vfmadd231Ss extends X86Instruction, @x86_vfmadd231ss { }

  class X86Vfmadd233Ps extends X86Instruction, @x86_vfmadd233ps { }

  class X86Vfmaddcph extends X86Instruction, @x86_vfmaddcph { }

  class X86Vfmaddcsh extends X86Instruction, @x86_vfmaddcsh { }

  class X86Vfmaddpd extends X86Instruction, @x86_vfmaddpd { }

  class X86Vfmaddps extends X86Instruction, @x86_vfmaddps { }

  class X86Vfmaddsd extends X86Instruction, @x86_vfmaddsd { }

  class X86Vfmaddss extends X86Instruction, @x86_vfmaddss { }

  class X86Vfmaddsub132Pd extends X86Instruction, @x86_vfmaddsub132pd { }

  class X86Vfmaddsub132Ph extends X86Instruction, @x86_vfmaddsub132ph { }

  class X86Vfmaddsub132Ps extends X86Instruction, @x86_vfmaddsub132ps { }

  class X86Vfmaddsub213Pd extends X86Instruction, @x86_vfmaddsub213pd { }

  class X86Vfmaddsub213Ph extends X86Instruction, @x86_vfmaddsub213ph { }

  class X86Vfmaddsub213Ps extends X86Instruction, @x86_vfmaddsub213ps { }

  class X86Vfmaddsub231Pd extends X86Instruction, @x86_vfmaddsub231pd { }

  class X86Vfmaddsub231Ph extends X86Instruction, @x86_vfmaddsub231ph { }

  class X86Vfmaddsub231Ps extends X86Instruction, @x86_vfmaddsub231ps { }

  class X86Vfmaddsubpd extends X86Instruction, @x86_vfmaddsubpd { }

  class X86Vfmaddsubps extends X86Instruction, @x86_vfmaddsubps { }

  class X86Vfmsub132Pd extends X86Instruction, @x86_vfmsub132pd { }

  class X86Vfmsub132Ph extends X86Instruction, @x86_vfmsub132ph { }

  class X86Vfmsub132Ps extends X86Instruction, @x86_vfmsub132ps { }

  class X86Vfmsub132Sd extends X86Instruction, @x86_vfmsub132sd { }

  class X86Vfmsub132Sh extends X86Instruction, @x86_vfmsub132sh { }

  class X86Vfmsub132Ss extends X86Instruction, @x86_vfmsub132ss { }

  class X86Vfmsub213Pd extends X86Instruction, @x86_vfmsub213pd { }

  class X86Vfmsub213Ph extends X86Instruction, @x86_vfmsub213ph { }

  class X86Vfmsub213Ps extends X86Instruction, @x86_vfmsub213ps { }

  class X86Vfmsub213Sd extends X86Instruction, @x86_vfmsub213sd { }

  class X86Vfmsub213Sh extends X86Instruction, @x86_vfmsub213sh { }

  class X86Vfmsub213Ss extends X86Instruction, @x86_vfmsub213ss { }

  class X86Vfmsub231Pd extends X86Instruction, @x86_vfmsub231pd { }

  class X86Vfmsub231Ph extends X86Instruction, @x86_vfmsub231ph { }

  class X86Vfmsub231Ps extends X86Instruction, @x86_vfmsub231ps { }

  class X86Vfmsub231Sd extends X86Instruction, @x86_vfmsub231sd { }

  class X86Vfmsub231Sh extends X86Instruction, @x86_vfmsub231sh { }

  class X86Vfmsub231Ss extends X86Instruction, @x86_vfmsub231ss { }

  class X86Vfmsubadd132Pd extends X86Instruction, @x86_vfmsubadd132pd { }

  class X86Vfmsubadd132Ph extends X86Instruction, @x86_vfmsubadd132ph { }

  class X86Vfmsubadd132Ps extends X86Instruction, @x86_vfmsubadd132ps { }

  class X86Vfmsubadd213Pd extends X86Instruction, @x86_vfmsubadd213pd { }

  class X86Vfmsubadd213Ph extends X86Instruction, @x86_vfmsubadd213ph { }

  class X86Vfmsubadd213Ps extends X86Instruction, @x86_vfmsubadd213ps { }

  class X86Vfmsubadd231Pd extends X86Instruction, @x86_vfmsubadd231pd { }

  class X86Vfmsubadd231Ph extends X86Instruction, @x86_vfmsubadd231ph { }

  class X86Vfmsubadd231Ps extends X86Instruction, @x86_vfmsubadd231ps { }

  class X86Vfmsubaddpd extends X86Instruction, @x86_vfmsubaddpd { }

  class X86Vfmsubaddps extends X86Instruction, @x86_vfmsubaddps { }

  class X86Vfmsubpd extends X86Instruction, @x86_vfmsubpd { }

  class X86Vfmsubps extends X86Instruction, @x86_vfmsubps { }

  class X86Vfmsubsd extends X86Instruction, @x86_vfmsubsd { }

  class X86Vfmsubss extends X86Instruction, @x86_vfmsubss { }

  class X86Vfmulcph extends X86Instruction, @x86_vfmulcph { }

  class X86Vfmulcsh extends X86Instruction, @x86_vfmulcsh { }

  class X86Vfnmadd132Pd extends X86Instruction, @x86_vfnmadd132pd { }

  class X86Vfnmadd132Ph extends X86Instruction, @x86_vfnmadd132ph { }

  class X86Vfnmadd132Ps extends X86Instruction, @x86_vfnmadd132ps { }

  class X86Vfnmadd132Sd extends X86Instruction, @x86_vfnmadd132sd { }

  class X86Vfnmadd132Sh extends X86Instruction, @x86_vfnmadd132sh { }

  class X86Vfnmadd132Ss extends X86Instruction, @x86_vfnmadd132ss { }

  class X86Vfnmadd213Pd extends X86Instruction, @x86_vfnmadd213pd { }

  class X86Vfnmadd213Ph extends X86Instruction, @x86_vfnmadd213ph { }

  class X86Vfnmadd213Ps extends X86Instruction, @x86_vfnmadd213ps { }

  class X86Vfnmadd213Sd extends X86Instruction, @x86_vfnmadd213sd { }

  class X86Vfnmadd213Sh extends X86Instruction, @x86_vfnmadd213sh { }

  class X86Vfnmadd213Ss extends X86Instruction, @x86_vfnmadd213ss { }

  class X86Vfnmadd231Pd extends X86Instruction, @x86_vfnmadd231pd { }

  class X86Vfnmadd231Ph extends X86Instruction, @x86_vfnmadd231ph { }

  class X86Vfnmadd231Ps extends X86Instruction, @x86_vfnmadd231ps { }

  class X86Vfnmadd231Sd extends X86Instruction, @x86_vfnmadd231sd { }

  class X86Vfnmadd231Sh extends X86Instruction, @x86_vfnmadd231sh { }

  class X86Vfnmadd231Ss extends X86Instruction, @x86_vfnmadd231ss { }

  class X86Vfnmaddpd extends X86Instruction, @x86_vfnmaddpd { }

  class X86Vfnmaddps extends X86Instruction, @x86_vfnmaddps { }

  class X86Vfnmaddsd extends X86Instruction, @x86_vfnmaddsd { }

  class X86Vfnmaddss extends X86Instruction, @x86_vfnmaddss { }

  class X86Vfnmsub132Pd extends X86Instruction, @x86_vfnmsub132pd { }

  class X86Vfnmsub132Ph extends X86Instruction, @x86_vfnmsub132ph { }

  class X86Vfnmsub132Ps extends X86Instruction, @x86_vfnmsub132ps { }

  class X86Vfnmsub132Sd extends X86Instruction, @x86_vfnmsub132sd { }

  class X86Vfnmsub132Sh extends X86Instruction, @x86_vfnmsub132sh { }

  class X86Vfnmsub132Ss extends X86Instruction, @x86_vfnmsub132ss { }

  class X86Vfnmsub213Pd extends X86Instruction, @x86_vfnmsub213pd { }

  class X86Vfnmsub213Ph extends X86Instruction, @x86_vfnmsub213ph { }

  class X86Vfnmsub213Ps extends X86Instruction, @x86_vfnmsub213ps { }

  class X86Vfnmsub213Sd extends X86Instruction, @x86_vfnmsub213sd { }

  class X86Vfnmsub213Sh extends X86Instruction, @x86_vfnmsub213sh { }

  class X86Vfnmsub213Ss extends X86Instruction, @x86_vfnmsub213ss { }

  class X86Vfnmsub231Pd extends X86Instruction, @x86_vfnmsub231pd { }

  class X86Vfnmsub231Ph extends X86Instruction, @x86_vfnmsub231ph { }

  class X86Vfnmsub231Ps extends X86Instruction, @x86_vfnmsub231ps { }

  class X86Vfnmsub231Sd extends X86Instruction, @x86_vfnmsub231sd { }

  class X86Vfnmsub231Sh extends X86Instruction, @x86_vfnmsub231sh { }

  class X86Vfnmsub231Ss extends X86Instruction, @x86_vfnmsub231ss { }

  class X86Vfnmsubpd extends X86Instruction, @x86_vfnmsubpd { }

  class X86Vfnmsubps extends X86Instruction, @x86_vfnmsubps { }

  class X86Vfnmsubsd extends X86Instruction, @x86_vfnmsubsd { }

  class X86Vfnmsubss extends X86Instruction, @x86_vfnmsubss { }

  class X86Vfpclasspd extends X86Instruction, @x86_vfpclasspd { }

  class X86Vfpclassph extends X86Instruction, @x86_vfpclassph { }

  class X86Vfpclassps extends X86Instruction, @x86_vfpclassps { }

  class X86Vfpclasssd extends X86Instruction, @x86_vfpclasssd { }

  class X86Vfpclasssh extends X86Instruction, @x86_vfpclasssh { }

  class X86Vfpclassss extends X86Instruction, @x86_vfpclassss { }

  class X86Vfrczpd extends X86Instruction, @x86_vfrczpd { }

  class X86Vfrczps extends X86Instruction, @x86_vfrczps { }

  class X86Vfrczsd extends X86Instruction, @x86_vfrczsd { }

  class X86Vfrczss extends X86Instruction, @x86_vfrczss { }

  class X86Vgatherdpd extends X86Instruction, @x86_vgatherdpd { }

  class X86Vgatherdps extends X86Instruction, @x86_vgatherdps { }

  class X86Vgatherpf0Dpd extends X86Instruction, @x86_vgatherpf0dpd { }

  class X86Vgatherpf0Dps extends X86Instruction, @x86_vgatherpf0dps { }

  class X86Vgatherpf0Hintdpd extends X86Instruction, @x86_vgatherpf0hintdpd { }

  class X86Vgatherpf0Hintdps extends X86Instruction, @x86_vgatherpf0hintdps { }

  class X86Vgatherpf0Qpd extends X86Instruction, @x86_vgatherpf0qpd { }

  class X86Vgatherpf0Qps extends X86Instruction, @x86_vgatherpf0qps { }

  class X86Vgatherpf1Dpd extends X86Instruction, @x86_vgatherpf1dpd { }

  class X86Vgatherpf1Dps extends X86Instruction, @x86_vgatherpf1dps { }

  class X86Vgatherpf1Qpd extends X86Instruction, @x86_vgatherpf1qpd { }

  class X86Vgatherpf1Qps extends X86Instruction, @x86_vgatherpf1qps { }

  class X86Vgatherqpd extends X86Instruction, @x86_vgatherqpd { }

  class X86Vgatherqps extends X86Instruction, @x86_vgatherqps { }

  class X86Vgetexppd extends X86Instruction, @x86_vgetexppd { }

  class X86Vgetexpph extends X86Instruction, @x86_vgetexpph { }

  class X86Vgetexpps extends X86Instruction, @x86_vgetexpps { }

  class X86Vgetexpsd extends X86Instruction, @x86_vgetexpsd { }

  class X86Vgetexpsh extends X86Instruction, @x86_vgetexpsh { }

  class X86Vgetexpss extends X86Instruction, @x86_vgetexpss { }

  class X86Vgetmantpd extends X86Instruction, @x86_vgetmantpd { }

  class X86Vgetmantph extends X86Instruction, @x86_vgetmantph { }

  class X86Vgetmantps extends X86Instruction, @x86_vgetmantps { }

  class X86Vgetmantsd extends X86Instruction, @x86_vgetmantsd { }

  class X86Vgetmantsh extends X86Instruction, @x86_vgetmantsh { }

  class X86Vgetmantss extends X86Instruction, @x86_vgetmantss { }

  class X86Vgf2P8Affineinvqb extends X86Instruction, @x86_vgf2p8affineinvqb { }

  class X86Vgf2P8Affineqb extends X86Instruction, @x86_vgf2p8affineqb { }

  class X86Vgf2P8Mulb extends X86Instruction, @x86_vgf2p8mulb { }

  class X86Vgmaxabsps extends X86Instruction, @x86_vgmaxabsps { }

  class X86Vgmaxpd extends X86Instruction, @x86_vgmaxpd { }

  class X86Vgmaxps extends X86Instruction, @x86_vgmaxps { }

  class X86Vgminpd extends X86Instruction, @x86_vgminpd { }

  class X86Vgminps extends X86Instruction, @x86_vgminps { }

  class X86Vhaddpd extends X86Instruction, @x86_vhaddpd { }

  class X86Vhaddps extends X86Instruction, @x86_vhaddps { }

  class X86Vhsubpd extends X86Instruction, @x86_vhsubpd { }

  class X86Vhsubps extends X86Instruction, @x86_vhsubps { }

  class X86Vinsertf128 extends X86Instruction, @x86_vinsertf128 { }

  class X86Vinsertf32X4 extends X86Instruction, @x86_vinsertf32x4 { }

  class X86Vinsertf32X8 extends X86Instruction, @x86_vinsertf32x8 { }

  class X86Vinsertf64X2 extends X86Instruction, @x86_vinsertf64x2 { }

  class X86Vinsertf64X4 extends X86Instruction, @x86_vinsertf64x4 { }

  class X86Vinserti128 extends X86Instruction, @x86_vinserti128 { }

  class X86Vinserti32X4 extends X86Instruction, @x86_vinserti32x4 { }

  class X86Vinserti32X8 extends X86Instruction, @x86_vinserti32x8 { }

  class X86Vinserti64X2 extends X86Instruction, @x86_vinserti64x2 { }

  class X86Vinserti64X4 extends X86Instruction, @x86_vinserti64x4 { }

  class X86Vinsertps extends X86Instruction, @x86_vinsertps { }

  class X86Vlddqu extends X86Instruction, @x86_vlddqu { }

  class X86Vldmxcsr extends X86Instruction, @x86_vldmxcsr { }

  class X86Vloadunpackhd extends X86Instruction, @x86_vloadunpackhd { }

  class X86Vloadunpackhpd extends X86Instruction, @x86_vloadunpackhpd { }

  class X86Vloadunpackhps extends X86Instruction, @x86_vloadunpackhps { }

  class X86Vloadunpackhq extends X86Instruction, @x86_vloadunpackhq { }

  class X86Vloadunpackld extends X86Instruction, @x86_vloadunpackld { }

  class X86Vloadunpacklpd extends X86Instruction, @x86_vloadunpacklpd { }

  class X86Vloadunpacklps extends X86Instruction, @x86_vloadunpacklps { }

  class X86Vloadunpacklq extends X86Instruction, @x86_vloadunpacklq { }

  class X86Vlog2Ps extends X86Instruction, @x86_vlog2ps { }

  class X86Vmaskmovdqu extends X86Instruction, @x86_vmaskmovdqu { }

  class X86Vmaskmovpd extends X86Instruction, @x86_vmaskmovpd { }

  class X86Vmaskmovps extends X86Instruction, @x86_vmaskmovps { }

  class X86Vmaxpd extends X86Instruction, @x86_vmaxpd { }

  class X86Vmaxph extends X86Instruction, @x86_vmaxph { }

  class X86Vmaxps extends X86Instruction, @x86_vmaxps { }

  class X86Vmaxsd extends X86Instruction, @x86_vmaxsd { }

  class X86Vmaxsh extends X86Instruction, @x86_vmaxsh { }

  class X86Vmaxss extends X86Instruction, @x86_vmaxss { }

  class X86Vmcall extends X86Instruction, @x86_vmcall { }

  class X86Vmclear extends X86Instruction, @x86_vmclear { }

  class X86Vmfunc extends X86Instruction, @x86_vmfunc { }

  class X86Vminpd extends X86Instruction, @x86_vminpd { }

  class X86Vminph extends X86Instruction, @x86_vminph { }

  class X86Vminps extends X86Instruction, @x86_vminps { }

  class X86Vminsd extends X86Instruction, @x86_vminsd { }

  class X86Vminsh extends X86Instruction, @x86_vminsh { }

  class X86Vminss extends X86Instruction, @x86_vminss { }

  class X86Vmlaunch extends X86Instruction, @x86_vmlaunch { }

  class X86Vmload extends X86Instruction, @x86_vmload { }

  class X86Vmmcall extends X86Instruction, @x86_vmmcall { }

  class X86Vmovapd extends X86Instruction, @x86_vmovapd { }

  class X86Vmovaps extends X86Instruction, @x86_vmovaps { }

  class X86Vmovd extends X86Instruction, @x86_vmovd { }

  class X86Vmovddup extends X86Instruction, @x86_vmovddup { }

  class X86Vmovdqa extends X86Instruction, @x86_vmovdqa { }

  class X86Vmovdqa32 extends X86Instruction, @x86_vmovdqa32 { }

  class X86Vmovdqa64 extends X86Instruction, @x86_vmovdqa64 { }

  class X86Vmovdqu extends X86Instruction, @x86_vmovdqu { }

  class X86Vmovdqu16 extends X86Instruction, @x86_vmovdqu16 { }

  class X86Vmovdqu32 extends X86Instruction, @x86_vmovdqu32 { }

  class X86Vmovdqu64 extends X86Instruction, @x86_vmovdqu64 { }

  class X86Vmovdqu8 extends X86Instruction, @x86_vmovdqu8 { }

  class X86Vmovhlps extends X86Instruction, @x86_vmovhlps { }

  class X86Vmovhpd extends X86Instruction, @x86_vmovhpd { }

  class X86Vmovhps extends X86Instruction, @x86_vmovhps { }

  class X86Vmovlhps extends X86Instruction, @x86_vmovlhps { }

  class X86Vmovlpd extends X86Instruction, @x86_vmovlpd { }

  class X86Vmovlps extends X86Instruction, @x86_vmovlps { }

  class X86Vmovmskpd extends X86Instruction, @x86_vmovmskpd { }

  class X86Vmovmskps extends X86Instruction, @x86_vmovmskps { }

  class X86Vmovnrapd extends X86Instruction, @x86_vmovnrapd { }

  class X86Vmovnraps extends X86Instruction, @x86_vmovnraps { }

  class X86Vmovnrngoapd extends X86Instruction, @x86_vmovnrngoapd { }

  class X86Vmovnrngoaps extends X86Instruction, @x86_vmovnrngoaps { }

  class X86Vmovntdq extends X86Instruction, @x86_vmovntdq { }

  class X86Vmovntdqa extends X86Instruction, @x86_vmovntdqa { }

  class X86Vmovntpd extends X86Instruction, @x86_vmovntpd { }

  class X86Vmovntps extends X86Instruction, @x86_vmovntps { }

  class X86Vmovq extends X86Instruction, @x86_vmovq { }

  class X86Vmovsd extends X86Instruction, @x86_vmovsd { }

  class X86Vmovsh extends X86Instruction, @x86_vmovsh { }

  class X86Vmovshdup extends X86Instruction, @x86_vmovshdup { }

  class X86Vmovsldup extends X86Instruction, @x86_vmovsldup { }

  class X86Vmovss extends X86Instruction, @x86_vmovss { }

  class X86Vmovupd extends X86Instruction, @x86_vmovupd { }

  class X86Vmovups extends X86Instruction, @x86_vmovups { }

  class X86Vmovw extends X86Instruction, @x86_vmovw { }

  class X86Vmpsadbw extends X86Instruction, @x86_vmpsadbw { }

  class X86Vmptrld extends X86Instruction, @x86_vmptrld { }

  class X86Vmptrst extends X86Instruction, @x86_vmptrst { }

  class X86Vmread extends X86Instruction, @x86_vmread { }

  class X86Vmresume extends X86Instruction, @x86_vmresume { }

  class X86Vmrun extends X86Instruction, @x86_vmrun { }

  class X86Vmsave extends X86Instruction, @x86_vmsave { }

  class X86Vmulpd extends X86Instruction, @x86_vmulpd { }

  class X86Vmulph extends X86Instruction, @x86_vmulph { }

  class X86Vmulps extends X86Instruction, @x86_vmulps { }

  class X86Vmulsd extends X86Instruction, @x86_vmulsd { }

  class X86Vmulsh extends X86Instruction, @x86_vmulsh { }

  class X86Vmulss extends X86Instruction, @x86_vmulss { }

  class X86Vmwrite extends X86Instruction, @x86_vmwrite { }

  class X86Vmxoff extends X86Instruction, @x86_vmxoff { }

  class X86Vmxon extends X86Instruction, @x86_vmxon { }

  class X86Vorpd extends X86Instruction, @x86_vorpd { }

  class X86Vorps extends X86Instruction, @x86_vorps { }

  class X86Vp2Intersectd extends X86Instruction, @x86_vp2intersectd { }

  class X86Vp2Intersectq extends X86Instruction, @x86_vp2intersectq { }

  class X86Vp4Dpwssd extends X86Instruction, @x86_vp4dpwssd { }

  class X86Vp4Dpwssds extends X86Instruction, @x86_vp4dpwssds { }

  class X86Vpabsb extends X86Instruction, @x86_vpabsb { }

  class X86Vpabsd extends X86Instruction, @x86_vpabsd { }

  class X86Vpabsq extends X86Instruction, @x86_vpabsq { }

  class X86Vpabsw extends X86Instruction, @x86_vpabsw { }

  class X86Vpackssdw extends X86Instruction, @x86_vpackssdw { }

  class X86Vpacksswb extends X86Instruction, @x86_vpacksswb { }

  class X86Vpackstorehd extends X86Instruction, @x86_vpackstorehd { }

  class X86Vpackstorehpd extends X86Instruction, @x86_vpackstorehpd { }

  class X86Vpackstorehps extends X86Instruction, @x86_vpackstorehps { }

  class X86Vpackstorehq extends X86Instruction, @x86_vpackstorehq { }

  class X86Vpackstoreld extends X86Instruction, @x86_vpackstoreld { }

  class X86Vpackstorelpd extends X86Instruction, @x86_vpackstorelpd { }

  class X86Vpackstorelps extends X86Instruction, @x86_vpackstorelps { }

  class X86Vpackstorelq extends X86Instruction, @x86_vpackstorelq { }

  class X86Vpackusdw extends X86Instruction, @x86_vpackusdw { }

  class X86Vpackuswb extends X86Instruction, @x86_vpackuswb { }

  class X86Vpadcd extends X86Instruction, @x86_vpadcd { }

  class X86Vpaddb extends X86Instruction, @x86_vpaddb { }

  class X86Vpaddd extends X86Instruction, @x86_vpaddd { }

  class X86Vpaddq extends X86Instruction, @x86_vpaddq { }

  class X86Vpaddsb extends X86Instruction, @x86_vpaddsb { }

  class X86Vpaddsetcd extends X86Instruction, @x86_vpaddsetcd { }

  class X86Vpaddsetsd extends X86Instruction, @x86_vpaddsetsd { }

  class X86Vpaddsw extends X86Instruction, @x86_vpaddsw { }

  class X86Vpaddusb extends X86Instruction, @x86_vpaddusb { }

  class X86Vpaddusw extends X86Instruction, @x86_vpaddusw { }

  class X86Vpaddw extends X86Instruction, @x86_vpaddw { }

  class X86Vpalignr extends X86Instruction, @x86_vpalignr { }

  class X86Vpand extends X86Instruction, @x86_vpand { }

  class X86Vpandd extends X86Instruction, @x86_vpandd { }

  class X86Vpandn extends X86Instruction, @x86_vpandn { }

  class X86Vpandnd extends X86Instruction, @x86_vpandnd { }

  class X86Vpandnq extends X86Instruction, @x86_vpandnq { }

  class X86Vpandq extends X86Instruction, @x86_vpandq { }

  class X86Vpavgb extends X86Instruction, @x86_vpavgb { }

  class X86Vpavgw extends X86Instruction, @x86_vpavgw { }

  class X86Vpblendd extends X86Instruction, @x86_vpblendd { }

  class X86Vpblendmb extends X86Instruction, @x86_vpblendmb { }

  class X86Vpblendmd extends X86Instruction, @x86_vpblendmd { }

  class X86Vpblendmq extends X86Instruction, @x86_vpblendmq { }

  class X86Vpblendmw extends X86Instruction, @x86_vpblendmw { }

  class X86Vpblendvb extends X86Instruction, @x86_vpblendvb { }

  class X86Vpblendw extends X86Instruction, @x86_vpblendw { }

  class X86Vpbroadcastb extends X86Instruction, @x86_vpbroadcastb { }

  class X86Vpbroadcastd extends X86Instruction, @x86_vpbroadcastd { }

  class X86Vpbroadcastmb2Q extends X86Instruction, @x86_vpbroadcastmb2q { }

  class X86Vpbroadcastmw2D extends X86Instruction, @x86_vpbroadcastmw2d { }

  class X86Vpbroadcastq extends X86Instruction, @x86_vpbroadcastq { }

  class X86Vpbroadcastw extends X86Instruction, @x86_vpbroadcastw { }

  class X86Vpclmulqdq extends X86Instruction, @x86_vpclmulqdq { }

  class X86Vpcmov extends X86Instruction, @x86_vpcmov { }

  class X86Vpcmpb extends X86Instruction, @x86_vpcmpb { }

  class X86Vpcmpd extends X86Instruction, @x86_vpcmpd { }

  class X86Vpcmpeqb extends X86Instruction, @x86_vpcmpeqb { }

  class X86Vpcmpeqd extends X86Instruction, @x86_vpcmpeqd { }

  class X86Vpcmpeqq extends X86Instruction, @x86_vpcmpeqq { }

  class X86Vpcmpeqw extends X86Instruction, @x86_vpcmpeqw { }

  class X86Vpcmpestri extends X86Instruction, @x86_vpcmpestri { }

  class X86Vpcmpestrm extends X86Instruction, @x86_vpcmpestrm { }

  class X86Vpcmpgtb extends X86Instruction, @x86_vpcmpgtb { }

  class X86Vpcmpgtd extends X86Instruction, @x86_vpcmpgtd { }

  class X86Vpcmpgtq extends X86Instruction, @x86_vpcmpgtq { }

  class X86Vpcmpgtw extends X86Instruction, @x86_vpcmpgtw { }

  class X86Vpcmpistri extends X86Instruction, @x86_vpcmpistri { }

  class X86Vpcmpistrm extends X86Instruction, @x86_vpcmpistrm { }

  class X86Vpcmpltd extends X86Instruction, @x86_vpcmpltd { }

  class X86Vpcmpq extends X86Instruction, @x86_vpcmpq { }

  class X86Vpcmpub extends X86Instruction, @x86_vpcmpub { }

  class X86Vpcmpud extends X86Instruction, @x86_vpcmpud { }

  class X86Vpcmpuq extends X86Instruction, @x86_vpcmpuq { }

  class X86Vpcmpuw extends X86Instruction, @x86_vpcmpuw { }

  class X86Vpcmpw extends X86Instruction, @x86_vpcmpw { }

  class X86Vpcomb extends X86Instruction, @x86_vpcomb { }

  class X86Vpcomd extends X86Instruction, @x86_vpcomd { }

  class X86Vpcompressb extends X86Instruction, @x86_vpcompressb { }

  class X86Vpcompressd extends X86Instruction, @x86_vpcompressd { }

  class X86Vpcompressq extends X86Instruction, @x86_vpcompressq { }

  class X86Vpcompressw extends X86Instruction, @x86_vpcompressw { }

  class X86Vpcomq extends X86Instruction, @x86_vpcomq { }

  class X86Vpcomub extends X86Instruction, @x86_vpcomub { }

  class X86Vpcomud extends X86Instruction, @x86_vpcomud { }

  class X86Vpcomuq extends X86Instruction, @x86_vpcomuq { }

  class X86Vpcomuw extends X86Instruction, @x86_vpcomuw { }

  class X86Vpcomw extends X86Instruction, @x86_vpcomw { }

  class X86Vpconflictd extends X86Instruction, @x86_vpconflictd { }

  class X86Vpconflictq extends X86Instruction, @x86_vpconflictq { }

  class X86Vpdpbssd extends X86Instruction, @x86_vpdpbssd { }

  class X86Vpdpbssds extends X86Instruction, @x86_vpdpbssds { }

  class X86Vpdpbsud extends X86Instruction, @x86_vpdpbsud { }

  class X86Vpdpbsuds extends X86Instruction, @x86_vpdpbsuds { }

  class X86Vpdpbusd extends X86Instruction, @x86_vpdpbusd { }

  class X86Vpdpbusds extends X86Instruction, @x86_vpdpbusds { }

  class X86Vpdpbuud extends X86Instruction, @x86_vpdpbuud { }

  class X86Vpdpbuuds extends X86Instruction, @x86_vpdpbuuds { }

  class X86Vpdpwssd extends X86Instruction, @x86_vpdpwssd { }

  class X86Vpdpwssds extends X86Instruction, @x86_vpdpwssds { }

  class X86Vpdpwsud extends X86Instruction, @x86_vpdpwsud { }

  class X86Vpdpwsuds extends X86Instruction, @x86_vpdpwsuds { }

  class X86Vpdpwusd extends X86Instruction, @x86_vpdpwusd { }

  class X86Vpdpwusds extends X86Instruction, @x86_vpdpwusds { }

  class X86Vpdpwuud extends X86Instruction, @x86_vpdpwuud { }

  class X86Vpdpwuuds extends X86Instruction, @x86_vpdpwuuds { }

  class X86Vperm2F128 extends X86Instruction, @x86_vperm2f128 { }

  class X86Vperm2I128 extends X86Instruction, @x86_vperm2i128 { }

  class X86Vpermb extends X86Instruction, @x86_vpermb { }

  class X86Vpermd extends X86Instruction, @x86_vpermd { }

  class X86Vpermf32X4 extends X86Instruction, @x86_vpermf32x4 { }

  class X86Vpermi2B extends X86Instruction, @x86_vpermi2b { }

  class X86Vpermi2D extends X86Instruction, @x86_vpermi2d { }

  class X86Vpermi2Pd extends X86Instruction, @x86_vpermi2pd { }

  class X86Vpermi2Ps extends X86Instruction, @x86_vpermi2ps { }

  class X86Vpermi2Q extends X86Instruction, @x86_vpermi2q { }

  class X86Vpermi2W extends X86Instruction, @x86_vpermi2w { }

  class X86Vpermil2Pd extends X86Instruction, @x86_vpermil2pd { }

  class X86Vpermil2Ps extends X86Instruction, @x86_vpermil2ps { }

  class X86Vpermilpd extends X86Instruction, @x86_vpermilpd { }

  class X86Vpermilps extends X86Instruction, @x86_vpermilps { }

  class X86Vpermpd extends X86Instruction, @x86_vpermpd { }

  class X86Vpermps extends X86Instruction, @x86_vpermps { }

  class X86Vpermq extends X86Instruction, @x86_vpermq { }

  class X86Vpermt2B extends X86Instruction, @x86_vpermt2b { }

  class X86Vpermt2D extends X86Instruction, @x86_vpermt2d { }

  class X86Vpermt2Pd extends X86Instruction, @x86_vpermt2pd { }

  class X86Vpermt2Ps extends X86Instruction, @x86_vpermt2ps { }

  class X86Vpermt2Q extends X86Instruction, @x86_vpermt2q { }

  class X86Vpermt2W extends X86Instruction, @x86_vpermt2w { }

  class X86Vpermw extends X86Instruction, @x86_vpermw { }

  class X86Vpexpandb extends X86Instruction, @x86_vpexpandb { }

  class X86Vpexpandd extends X86Instruction, @x86_vpexpandd { }

  class X86Vpexpandq extends X86Instruction, @x86_vpexpandq { }

  class X86Vpexpandw extends X86Instruction, @x86_vpexpandw { }

  class X86Vpextrb extends X86Instruction, @x86_vpextrb { }

  class X86Vpextrd extends X86Instruction, @x86_vpextrd { }

  class X86Vpextrq extends X86Instruction, @x86_vpextrq { }

  class X86Vpextrw extends X86Instruction, @x86_vpextrw { }

  class X86Vpgatherdd extends X86Instruction, @x86_vpgatherdd { }

  class X86Vpgatherdq extends X86Instruction, @x86_vpgatherdq { }

  class X86Vpgatherqd extends X86Instruction, @x86_vpgatherqd { }

  class X86Vpgatherqq extends X86Instruction, @x86_vpgatherqq { }

  class X86Vphaddbd extends X86Instruction, @x86_vphaddbd { }

  class X86Vphaddbq extends X86Instruction, @x86_vphaddbq { }

  class X86Vphaddbw extends X86Instruction, @x86_vphaddbw { }

  class X86Vphaddd extends X86Instruction, @x86_vphaddd { }

  class X86Vphadddq extends X86Instruction, @x86_vphadddq { }

  class X86Vphaddsw extends X86Instruction, @x86_vphaddsw { }

  class X86Vphaddubd extends X86Instruction, @x86_vphaddubd { }

  class X86Vphaddubq extends X86Instruction, @x86_vphaddubq { }

  class X86Vphaddubw extends X86Instruction, @x86_vphaddubw { }

  class X86Vphaddudq extends X86Instruction, @x86_vphaddudq { }

  class X86Vphadduwd extends X86Instruction, @x86_vphadduwd { }

  class X86Vphadduwq extends X86Instruction, @x86_vphadduwq { }

  class X86Vphaddw extends X86Instruction, @x86_vphaddw { }

  class X86Vphaddwd extends X86Instruction, @x86_vphaddwd { }

  class X86Vphaddwq extends X86Instruction, @x86_vphaddwq { }

  class X86Vphminposuw extends X86Instruction, @x86_vphminposuw { }

  class X86Vphsubbw extends X86Instruction, @x86_vphsubbw { }

  class X86Vphsubd extends X86Instruction, @x86_vphsubd { }

  class X86Vphsubdq extends X86Instruction, @x86_vphsubdq { }

  class X86Vphsubsw extends X86Instruction, @x86_vphsubsw { }

  class X86Vphsubw extends X86Instruction, @x86_vphsubw { }

  class X86Vphsubwd extends X86Instruction, @x86_vphsubwd { }

  class X86Vpinsrb extends X86Instruction, @x86_vpinsrb { }

  class X86Vpinsrd extends X86Instruction, @x86_vpinsrd { }

  class X86Vpinsrq extends X86Instruction, @x86_vpinsrq { }

  class X86Vpinsrw extends X86Instruction, @x86_vpinsrw { }

  class X86Vplzcntd extends X86Instruction, @x86_vplzcntd { }

  class X86Vplzcntq extends X86Instruction, @x86_vplzcntq { }

  class X86Vpmacsdd extends X86Instruction, @x86_vpmacsdd { }

  class X86Vpmacsdqh extends X86Instruction, @x86_vpmacsdqh { }

  class X86Vpmacsdql extends X86Instruction, @x86_vpmacsdql { }

  class X86Vpmacssdd extends X86Instruction, @x86_vpmacssdd { }

  class X86Vpmacssdqh extends X86Instruction, @x86_vpmacssdqh { }

  class X86Vpmacssdql extends X86Instruction, @x86_vpmacssdql { }

  class X86Vpmacsswd extends X86Instruction, @x86_vpmacsswd { }

  class X86Vpmacssww extends X86Instruction, @x86_vpmacssww { }

  class X86Vpmacswd extends X86Instruction, @x86_vpmacswd { }

  class X86Vpmacsww extends X86Instruction, @x86_vpmacsww { }

  class X86Vpmadcsswd extends X86Instruction, @x86_vpmadcsswd { }

  class X86Vpmadcswd extends X86Instruction, @x86_vpmadcswd { }

  class X86Vpmadd231D extends X86Instruction, @x86_vpmadd231d { }

  class X86Vpmadd233D extends X86Instruction, @x86_vpmadd233d { }

  class X86Vpmadd52Huq extends X86Instruction, @x86_vpmadd52huq { }

  class X86Vpmadd52Luq extends X86Instruction, @x86_vpmadd52luq { }

  class X86Vpmaddubsw extends X86Instruction, @x86_vpmaddubsw { }

  class X86Vpmaddwd extends X86Instruction, @x86_vpmaddwd { }

  class X86Vpmaskmovd extends X86Instruction, @x86_vpmaskmovd { }

  class X86Vpmaskmovq extends X86Instruction, @x86_vpmaskmovq { }

  class X86Vpmaxsb extends X86Instruction, @x86_vpmaxsb { }

  class X86Vpmaxsd extends X86Instruction, @x86_vpmaxsd { }

  class X86Vpmaxsq extends X86Instruction, @x86_vpmaxsq { }

  class X86Vpmaxsw extends X86Instruction, @x86_vpmaxsw { }

  class X86Vpmaxub extends X86Instruction, @x86_vpmaxub { }

  class X86Vpmaxud extends X86Instruction, @x86_vpmaxud { }

  class X86Vpmaxuq extends X86Instruction, @x86_vpmaxuq { }

  class X86Vpmaxuw extends X86Instruction, @x86_vpmaxuw { }

  class X86Vpminsb extends X86Instruction, @x86_vpminsb { }

  class X86Vpminsd extends X86Instruction, @x86_vpminsd { }

  class X86Vpminsq extends X86Instruction, @x86_vpminsq { }

  class X86Vpminsw extends X86Instruction, @x86_vpminsw { }

  class X86Vpminub extends X86Instruction, @x86_vpminub { }

  class X86Vpminud extends X86Instruction, @x86_vpminud { }

  class X86Vpminuq extends X86Instruction, @x86_vpminuq { }

  class X86Vpminuw extends X86Instruction, @x86_vpminuw { }

  class X86Vpmovb2M extends X86Instruction, @x86_vpmovb2m { }

  class X86Vpmovd2M extends X86Instruction, @x86_vpmovd2m { }

  class X86Vpmovdb extends X86Instruction, @x86_vpmovdb { }

  class X86Vpmovdw extends X86Instruction, @x86_vpmovdw { }

  class X86Vpmovm2B extends X86Instruction, @x86_vpmovm2b { }

  class X86Vpmovm2D extends X86Instruction, @x86_vpmovm2d { }

  class X86Vpmovm2Q extends X86Instruction, @x86_vpmovm2q { }

  class X86Vpmovm2W extends X86Instruction, @x86_vpmovm2w { }

  class X86Vpmovmskb extends X86Instruction, @x86_vpmovmskb { }

  class X86Vpmovq2M extends X86Instruction, @x86_vpmovq2m { }

  class X86Vpmovqb extends X86Instruction, @x86_vpmovqb { }

  class X86Vpmovqd extends X86Instruction, @x86_vpmovqd { }

  class X86Vpmovqw extends X86Instruction, @x86_vpmovqw { }

  class X86Vpmovsdb extends X86Instruction, @x86_vpmovsdb { }

  class X86Vpmovsdw extends X86Instruction, @x86_vpmovsdw { }

  class X86Vpmovsqb extends X86Instruction, @x86_vpmovsqb { }

  class X86Vpmovsqd extends X86Instruction, @x86_vpmovsqd { }

  class X86Vpmovsqw extends X86Instruction, @x86_vpmovsqw { }

  class X86Vpmovswb extends X86Instruction, @x86_vpmovswb { }

  class X86Vpmovsxbd extends X86Instruction, @x86_vpmovsxbd { }

  class X86Vpmovsxbq extends X86Instruction, @x86_vpmovsxbq { }

  class X86Vpmovsxbw extends X86Instruction, @x86_vpmovsxbw { }

  class X86Vpmovsxdq extends X86Instruction, @x86_vpmovsxdq { }

  class X86Vpmovsxwd extends X86Instruction, @x86_vpmovsxwd { }

  class X86Vpmovsxwq extends X86Instruction, @x86_vpmovsxwq { }

  class X86Vpmovusdb extends X86Instruction, @x86_vpmovusdb { }

  class X86Vpmovusdw extends X86Instruction, @x86_vpmovusdw { }

  class X86Vpmovusqb extends X86Instruction, @x86_vpmovusqb { }

  class X86Vpmovusqd extends X86Instruction, @x86_vpmovusqd { }

  class X86Vpmovusqw extends X86Instruction, @x86_vpmovusqw { }

  class X86Vpmovuswb extends X86Instruction, @x86_vpmovuswb { }

  class X86Vpmovw2M extends X86Instruction, @x86_vpmovw2m { }

  class X86Vpmovwb extends X86Instruction, @x86_vpmovwb { }

  class X86Vpmovzxbd extends X86Instruction, @x86_vpmovzxbd { }

  class X86Vpmovzxbq extends X86Instruction, @x86_vpmovzxbq { }

  class X86Vpmovzxbw extends X86Instruction, @x86_vpmovzxbw { }

  class X86Vpmovzxdq extends X86Instruction, @x86_vpmovzxdq { }

  class X86Vpmovzxwd extends X86Instruction, @x86_vpmovzxwd { }

  class X86Vpmovzxwq extends X86Instruction, @x86_vpmovzxwq { }

  class X86Vpmuldq extends X86Instruction, @x86_vpmuldq { }

  class X86Vpmulhd extends X86Instruction, @x86_vpmulhd { }

  class X86Vpmulhrsw extends X86Instruction, @x86_vpmulhrsw { }

  class X86Vpmulhud extends X86Instruction, @x86_vpmulhud { }

  class X86Vpmulhuw extends X86Instruction, @x86_vpmulhuw { }

  class X86Vpmulhw extends X86Instruction, @x86_vpmulhw { }

  class X86Vpmulld extends X86Instruction, @x86_vpmulld { }

  class X86Vpmullq extends X86Instruction, @x86_vpmullq { }

  class X86Vpmullw extends X86Instruction, @x86_vpmullw { }

  class X86Vpmultishiftqb extends X86Instruction, @x86_vpmultishiftqb { }

  class X86Vpmuludq extends X86Instruction, @x86_vpmuludq { }

  class X86Vpopcntb extends X86Instruction, @x86_vpopcntb { }

  class X86Vpopcntd extends X86Instruction, @x86_vpopcntd { }

  class X86Vpopcntq extends X86Instruction, @x86_vpopcntq { }

  class X86Vpopcntw extends X86Instruction, @x86_vpopcntw { }

  class X86Vpor extends X86Instruction, @x86_vpor { }

  class X86Vpord extends X86Instruction, @x86_vpord { }

  class X86Vporq extends X86Instruction, @x86_vporq { }

  class X86Vpperm extends X86Instruction, @x86_vpperm { }

  class X86Vprefetch0 extends X86Instruction, @x86_vprefetch0 { }

  class X86Vprefetch1 extends X86Instruction, @x86_vprefetch1 { }

  class X86Vprefetch2 extends X86Instruction, @x86_vprefetch2 { }

  class X86Vprefetche0 extends X86Instruction, @x86_vprefetche0 { }

  class X86Vprefetche1 extends X86Instruction, @x86_vprefetche1 { }

  class X86Vprefetche2 extends X86Instruction, @x86_vprefetche2 { }

  class X86Vprefetchenta extends X86Instruction, @x86_vprefetchenta { }

  class X86Vprefetchnta extends X86Instruction, @x86_vprefetchnta { }

  class X86Vprold extends X86Instruction, @x86_vprold { }

  class X86Vprolq extends X86Instruction, @x86_vprolq { }

  class X86Vprolvd extends X86Instruction, @x86_vprolvd { }

  class X86Vprolvq extends X86Instruction, @x86_vprolvq { }

  class X86Vprord extends X86Instruction, @x86_vprord { }

  class X86Vprorq extends X86Instruction, @x86_vprorq { }

  class X86Vprorvd extends X86Instruction, @x86_vprorvd { }

  class X86Vprorvq extends X86Instruction, @x86_vprorvq { }

  class X86Vprotb extends X86Instruction, @x86_vprotb { }

  class X86Vprotd extends X86Instruction, @x86_vprotd { }

  class X86Vprotq extends X86Instruction, @x86_vprotq { }

  class X86Vprotw extends X86Instruction, @x86_vprotw { }

  class X86Vpsadbw extends X86Instruction, @x86_vpsadbw { }

  class X86Vpsbbd extends X86Instruction, @x86_vpsbbd { }

  class X86Vpsbbrd extends X86Instruction, @x86_vpsbbrd { }

  class X86Vpscatterdd extends X86Instruction, @x86_vpscatterdd { }

  class X86Vpscatterdq extends X86Instruction, @x86_vpscatterdq { }

  class X86Vpscatterqd extends X86Instruction, @x86_vpscatterqd { }

  class X86Vpscatterqq extends X86Instruction, @x86_vpscatterqq { }

  class X86Vpshab extends X86Instruction, @x86_vpshab { }

  class X86Vpshad extends X86Instruction, @x86_vpshad { }

  class X86Vpshaq extends X86Instruction, @x86_vpshaq { }

  class X86Vpshaw extends X86Instruction, @x86_vpshaw { }

  class X86Vpshlb extends X86Instruction, @x86_vpshlb { }

  class X86Vpshld extends X86Instruction, @x86_vpshld { }

  class X86Vpshldd extends X86Instruction, @x86_vpshldd { }

  class X86Vpshldq extends X86Instruction, @x86_vpshldq { }

  class X86Vpshldvd extends X86Instruction, @x86_vpshldvd { }

  class X86Vpshldvq extends X86Instruction, @x86_vpshldvq { }

  class X86Vpshldvw extends X86Instruction, @x86_vpshldvw { }

  class X86Vpshldw extends X86Instruction, @x86_vpshldw { }

  class X86Vpshlq extends X86Instruction, @x86_vpshlq { }

  class X86Vpshlw extends X86Instruction, @x86_vpshlw { }

  class X86Vpshrdd extends X86Instruction, @x86_vpshrdd { }

  class X86Vpshrdq extends X86Instruction, @x86_vpshrdq { }

  class X86Vpshrdvd extends X86Instruction, @x86_vpshrdvd { }

  class X86Vpshrdvq extends X86Instruction, @x86_vpshrdvq { }

  class X86Vpshrdvw extends X86Instruction, @x86_vpshrdvw { }

  class X86Vpshrdw extends X86Instruction, @x86_vpshrdw { }

  class X86Vpshufb extends X86Instruction, @x86_vpshufb { }

  class X86Vpshufbitqmb extends X86Instruction, @x86_vpshufbitqmb { }

  class X86Vpshufd extends X86Instruction, @x86_vpshufd { }

  class X86Vpshufhw extends X86Instruction, @x86_vpshufhw { }

  class X86Vpshuflw extends X86Instruction, @x86_vpshuflw { }

  class X86Vpsignb extends X86Instruction, @x86_vpsignb { }

  class X86Vpsignd extends X86Instruction, @x86_vpsignd { }

  class X86Vpsignw extends X86Instruction, @x86_vpsignw { }

  class X86Vpslld extends X86Instruction, @x86_vpslld { }

  class X86Vpslldq extends X86Instruction, @x86_vpslldq { }

  class X86Vpsllq extends X86Instruction, @x86_vpsllq { }

  class X86Vpsllvd extends X86Instruction, @x86_vpsllvd { }

  class X86Vpsllvq extends X86Instruction, @x86_vpsllvq { }

  class X86Vpsllvw extends X86Instruction, @x86_vpsllvw { }

  class X86Vpsllw extends X86Instruction, @x86_vpsllw { }

  class X86Vpsrad extends X86Instruction, @x86_vpsrad { }

  class X86Vpsraq extends X86Instruction, @x86_vpsraq { }

  class X86Vpsravd extends X86Instruction, @x86_vpsravd { }

  class X86Vpsravq extends X86Instruction, @x86_vpsravq { }

  class X86Vpsravw extends X86Instruction, @x86_vpsravw { }

  class X86Vpsraw extends X86Instruction, @x86_vpsraw { }

  class X86Vpsrld extends X86Instruction, @x86_vpsrld { }

  class X86Vpsrldq extends X86Instruction, @x86_vpsrldq { }

  class X86Vpsrlq extends X86Instruction, @x86_vpsrlq { }

  class X86Vpsrlvd extends X86Instruction, @x86_vpsrlvd { }

  class X86Vpsrlvq extends X86Instruction, @x86_vpsrlvq { }

  class X86Vpsrlvw extends X86Instruction, @x86_vpsrlvw { }

  class X86Vpsrlw extends X86Instruction, @x86_vpsrlw { }

  class X86Vpsubb extends X86Instruction, @x86_vpsubb { }

  class X86Vpsubd extends X86Instruction, @x86_vpsubd { }

  class X86Vpsubq extends X86Instruction, @x86_vpsubq { }

  class X86Vpsubrd extends X86Instruction, @x86_vpsubrd { }

  class X86Vpsubrsetbd extends X86Instruction, @x86_vpsubrsetbd { }

  class X86Vpsubsb extends X86Instruction, @x86_vpsubsb { }

  class X86Vpsubsetbd extends X86Instruction, @x86_vpsubsetbd { }

  class X86Vpsubsw extends X86Instruction, @x86_vpsubsw { }

  class X86Vpsubusb extends X86Instruction, @x86_vpsubusb { }

  class X86Vpsubusw extends X86Instruction, @x86_vpsubusw { }

  class X86Vpsubw extends X86Instruction, @x86_vpsubw { }

  class X86Vpternlogd extends X86Instruction, @x86_vpternlogd { }

  class X86Vpternlogq extends X86Instruction, @x86_vpternlogq { }

  class X86Vptest extends X86Instruction, @x86_vptest { }

  class X86Vptestmb extends X86Instruction, @x86_vptestmb { }

  class X86Vptestmd extends X86Instruction, @x86_vptestmd { }

  class X86Vptestmq extends X86Instruction, @x86_vptestmq { }

  class X86Vptestmw extends X86Instruction, @x86_vptestmw { }

  class X86Vptestnmb extends X86Instruction, @x86_vptestnmb { }

  class X86Vptestnmd extends X86Instruction, @x86_vptestnmd { }

  class X86Vptestnmq extends X86Instruction, @x86_vptestnmq { }

  class X86Vptestnmw extends X86Instruction, @x86_vptestnmw { }

  class X86Vpunpckhbw extends X86Instruction, @x86_vpunpckhbw { }

  class X86Vpunpckhdq extends X86Instruction, @x86_vpunpckhdq { }

  class X86Vpunpckhqdq extends X86Instruction, @x86_vpunpckhqdq { }

  class X86Vpunpckhwd extends X86Instruction, @x86_vpunpckhwd { }

  class X86Vpunpcklbw extends X86Instruction, @x86_vpunpcklbw { }

  class X86Vpunpckldq extends X86Instruction, @x86_vpunpckldq { }

  class X86Vpunpcklqdq extends X86Instruction, @x86_vpunpcklqdq { }

  class X86Vpunpcklwd extends X86Instruction, @x86_vpunpcklwd { }

  class X86Vpxor extends X86Instruction, @x86_vpxor { }

  class X86Vpxord extends X86Instruction, @x86_vpxord { }

  class X86Vpxorq extends X86Instruction, @x86_vpxorq { }

  class X86Vrangepd extends X86Instruction, @x86_vrangepd { }

  class X86Vrangeps extends X86Instruction, @x86_vrangeps { }

  class X86Vrangesd extends X86Instruction, @x86_vrangesd { }

  class X86Vrangess extends X86Instruction, @x86_vrangess { }

  class X86Vrcp14Pd extends X86Instruction, @x86_vrcp14pd { }

  class X86Vrcp14Ps extends X86Instruction, @x86_vrcp14ps { }

  class X86Vrcp14Sd extends X86Instruction, @x86_vrcp14sd { }

  class X86Vrcp14Ss extends X86Instruction, @x86_vrcp14ss { }

  class X86Vrcp23Ps extends X86Instruction, @x86_vrcp23ps { }

  class X86Vrcp28Pd extends X86Instruction, @x86_vrcp28pd { }

  class X86Vrcp28Ps extends X86Instruction, @x86_vrcp28ps { }

  class X86Vrcp28Sd extends X86Instruction, @x86_vrcp28sd { }

  class X86Vrcp28Ss extends X86Instruction, @x86_vrcp28ss { }

  class X86Vrcpph extends X86Instruction, @x86_vrcpph { }

  class X86Vrcpps extends X86Instruction, @x86_vrcpps { }

  class X86Vrcpsh extends X86Instruction, @x86_vrcpsh { }

  class X86Vrcpss extends X86Instruction, @x86_vrcpss { }

  class X86Vreducepd extends X86Instruction, @x86_vreducepd { }

  class X86Vreduceph extends X86Instruction, @x86_vreduceph { }

  class X86Vreduceps extends X86Instruction, @x86_vreduceps { }

  class X86Vreducesd extends X86Instruction, @x86_vreducesd { }

  class X86Vreducesh extends X86Instruction, @x86_vreducesh { }

  class X86Vreducess extends X86Instruction, @x86_vreducess { }

  class X86Vrndfxpntpd extends X86Instruction, @x86_vrndfxpntpd { }

  class X86Vrndfxpntps extends X86Instruction, @x86_vrndfxpntps { }

  class X86Vrndscalepd extends X86Instruction, @x86_vrndscalepd { }

  class X86Vrndscaleph extends X86Instruction, @x86_vrndscaleph { }

  class X86Vrndscaleps extends X86Instruction, @x86_vrndscaleps { }

  class X86Vrndscalesd extends X86Instruction, @x86_vrndscalesd { }

  class X86Vrndscalesh extends X86Instruction, @x86_vrndscalesh { }

  class X86Vrndscaless extends X86Instruction, @x86_vrndscaless { }

  class X86Vroundpd extends X86Instruction, @x86_vroundpd { }

  class X86Vroundps extends X86Instruction, @x86_vroundps { }

  class X86Vroundsd extends X86Instruction, @x86_vroundsd { }

  class X86Vroundss extends X86Instruction, @x86_vroundss { }

  class X86Vrsqrt14Pd extends X86Instruction, @x86_vrsqrt14pd { }

  class X86Vrsqrt14Ps extends X86Instruction, @x86_vrsqrt14ps { }

  class X86Vrsqrt14Sd extends X86Instruction, @x86_vrsqrt14sd { }

  class X86Vrsqrt14Ss extends X86Instruction, @x86_vrsqrt14ss { }

  class X86Vrsqrt23Ps extends X86Instruction, @x86_vrsqrt23ps { }

  class X86Vrsqrt28Pd extends X86Instruction, @x86_vrsqrt28pd { }

  class X86Vrsqrt28Ps extends X86Instruction, @x86_vrsqrt28ps { }

  class X86Vrsqrt28Sd extends X86Instruction, @x86_vrsqrt28sd { }

  class X86Vrsqrt28Ss extends X86Instruction, @x86_vrsqrt28ss { }

  class X86Vrsqrtph extends X86Instruction, @x86_vrsqrtph { }

  class X86Vrsqrtps extends X86Instruction, @x86_vrsqrtps { }

  class X86Vrsqrtsh extends X86Instruction, @x86_vrsqrtsh { }

  class X86Vrsqrtss extends X86Instruction, @x86_vrsqrtss { }

  class X86Vscalefpd extends X86Instruction, @x86_vscalefpd { }

  class X86Vscalefph extends X86Instruction, @x86_vscalefph { }

  class X86Vscalefps extends X86Instruction, @x86_vscalefps { }

  class X86Vscalefsd extends X86Instruction, @x86_vscalefsd { }

  class X86Vscalefsh extends X86Instruction, @x86_vscalefsh { }

  class X86Vscalefss extends X86Instruction, @x86_vscalefss { }

  class X86Vscaleps extends X86Instruction, @x86_vscaleps { }

  class X86Vscatterdpd extends X86Instruction, @x86_vscatterdpd { }

  class X86Vscatterdps extends X86Instruction, @x86_vscatterdps { }

  class X86Vscatterpf0Dpd extends X86Instruction, @x86_vscatterpf0dpd { }

  class X86Vscatterpf0Dps extends X86Instruction, @x86_vscatterpf0dps { }

  class X86Vscatterpf0Hintdpd extends X86Instruction, @x86_vscatterpf0hintdpd { }

  class X86Vscatterpf0Hintdps extends X86Instruction, @x86_vscatterpf0hintdps { }

  class X86Vscatterpf0Qpd extends X86Instruction, @x86_vscatterpf0qpd { }

  class X86Vscatterpf0Qps extends X86Instruction, @x86_vscatterpf0qps { }

  class X86Vscatterpf1Dpd extends X86Instruction, @x86_vscatterpf1dpd { }

  class X86Vscatterpf1Dps extends X86Instruction, @x86_vscatterpf1dps { }

  class X86Vscatterpf1Qpd extends X86Instruction, @x86_vscatterpf1qpd { }

  class X86Vscatterpf1Qps extends X86Instruction, @x86_vscatterpf1qps { }

  class X86Vscatterqpd extends X86Instruction, @x86_vscatterqpd { }

  class X86Vscatterqps extends X86Instruction, @x86_vscatterqps { }

  class X86Vsha512Msg1 extends X86Instruction, @x86_vsha512msg1 { }

  class X86Vsha512Msg2 extends X86Instruction, @x86_vsha512msg2 { }

  class X86Vsha512Rnds2 extends X86Instruction, @x86_vsha512rnds2 { }

  class X86Vshuff32X4 extends X86Instruction, @x86_vshuff32x4 { }

  class X86Vshuff64X2 extends X86Instruction, @x86_vshuff64x2 { }

  class X86Vshufi32X4 extends X86Instruction, @x86_vshufi32x4 { }

  class X86Vshufi64X2 extends X86Instruction, @x86_vshufi64x2 { }

  class X86Vshufpd extends X86Instruction, @x86_vshufpd { }

  class X86Vshufps extends X86Instruction, @x86_vshufps { }

  class X86Vsm3Msg1 extends X86Instruction, @x86_vsm3msg1 { }

  class X86Vsm3Msg2 extends X86Instruction, @x86_vsm3msg2 { }

  class X86Vsm3Rnds2 extends X86Instruction, @x86_vsm3rnds2 { }

  class X86Vsm4Key4 extends X86Instruction, @x86_vsm4key4 { }

  class X86Vsm4Rnds4 extends X86Instruction, @x86_vsm4rnds4 { }

  class X86Vsqrtpd extends X86Instruction, @x86_vsqrtpd { }

  class X86Vsqrtph extends X86Instruction, @x86_vsqrtph { }

  class X86Vsqrtps extends X86Instruction, @x86_vsqrtps { }

  class X86Vsqrtsd extends X86Instruction, @x86_vsqrtsd { }

  class X86Vsqrtsh extends X86Instruction, @x86_vsqrtsh { }

  class X86Vsqrtss extends X86Instruction, @x86_vsqrtss { }

  class X86Vstmxcsr extends X86Instruction, @x86_vstmxcsr { }

  class X86Vsubpd extends X86Instruction, @x86_vsubpd { }

  class X86Vsubph extends X86Instruction, @x86_vsubph { }

  class X86Vsubps extends X86Instruction, @x86_vsubps { }

  class X86Vsubrpd extends X86Instruction, @x86_vsubrpd { }

  class X86Vsubrps extends X86Instruction, @x86_vsubrps { }

  class X86Vsubsd extends X86Instruction, @x86_vsubsd { }

  class X86Vsubsh extends X86Instruction, @x86_vsubsh { }

  class X86Vsubss extends X86Instruction, @x86_vsubss { }

  class X86Vtestpd extends X86Instruction, @x86_vtestpd { }

  class X86Vtestps extends X86Instruction, @x86_vtestps { }

  class X86Vucomisd extends X86Instruction, @x86_vucomisd { }

  class X86Vucomish extends X86Instruction, @x86_vucomish { }

  class X86Vucomiss extends X86Instruction, @x86_vucomiss { }

  class X86Vunpckhpd extends X86Instruction, @x86_vunpckhpd { }

  class X86Vunpckhps extends X86Instruction, @x86_vunpckhps { }

  class X86Vunpcklpd extends X86Instruction, @x86_vunpcklpd { }

  class X86Vunpcklps extends X86Instruction, @x86_vunpcklps { }

  class X86Vxorpd extends X86Instruction, @x86_vxorpd { }

  class X86Vxorps extends X86Instruction, @x86_vxorps { }

  class X86Vzeroall extends X86Instruction, @x86_vzeroall { }

  class X86Vzeroupper extends X86Instruction, @x86_vzeroupper { }

  class X86Wbinvd extends X86Instruction, @x86_wbinvd { }

  class X86Wrfsbase extends X86Instruction, @x86_wrfsbase { }

  class X86Wrgsbase extends X86Instruction, @x86_wrgsbase { }

  class X86Wrmsr extends X86Instruction, @x86_wrmsr { }

  class X86Wrmsrlist extends X86Instruction, @x86_wrmsrlist { }

  class X86Wrmsrns extends X86Instruction, @x86_wrmsrns { }

  class X86Wrpkru extends X86Instruction, @x86_wrpkru { }

  class X86Wrssd extends X86Instruction, @x86_wrssd { }

  class X86Wrssq extends X86Instruction, @x86_wrssq { }

  class X86Wrussd extends X86Instruction, @x86_wrussd { }

  class X86Wrussq extends X86Instruction, @x86_wrussq { }

  class X86Xabort extends X86Instruction, @x86_xabort { }

  class X86Xadd extends X86Instruction, @x86_xadd { }

  class X86Xbegin extends X86Instruction, @x86_xbegin { }

  class X86Xchg extends X86Instruction, @x86_xchg { }

  class X86XcryptCbc extends X86Instruction, @x86_xcryptcbc { }

  class X86XcryptCfb extends X86Instruction, @x86_xcryptcfb { }

  class X86XcryptCtr extends X86Instruction, @x86_xcryptctr { }

  class X86XcryptEcb extends X86Instruction, @x86_xcryptecb { }

  class X86XcryptOfb extends X86Instruction, @x86_xcryptofb { }

  class X86Xend extends X86Instruction, @x86_xend { }

  class X86Xgetbv extends X86Instruction, @x86_xgetbv { }

  class X86Xlat extends X86Instruction, @x86_xlat { }

  class X86Xor extends X86Instruction, @x86_xor { }

  class X86Xorpd extends X86Instruction, @x86_xorpd { }

  class X86Xorps extends X86Instruction, @x86_xorps { }

  class X86Xresldtrk extends X86Instruction, @x86_xresldtrk { }

  class X86Xrstor extends X86Instruction, @x86_xrstor { }

  class X86Xrstor64 extends X86Instruction, @x86_xrstor64 { }

  class X86Xrstors extends X86Instruction, @x86_xrstors { }

  class X86Xrstors64 extends X86Instruction, @x86_xrstors64 { }

  class X86Xsave extends X86Instruction, @x86_xsave { }

  class X86Xsave64 extends X86Instruction, @x86_xsave64 { }

  class X86Xsavec extends X86Instruction, @x86_xsavec { }

  class X86Xsavec64 extends X86Instruction, @x86_xsavec64 { }

  class X86Xsaveopt extends X86Instruction, @x86_xsaveopt { }

  class X86Xsaveopt64 extends X86Instruction, @x86_xsaveopt64 { }

  class X86Xsaves extends X86Instruction, @x86_xsaves { }

  class X86Xsaves64 extends X86Instruction, @x86_xsaves64 { }

  class X86Xsetbv extends X86Instruction, @x86_xsetbv { }

  class X86Xsha1 extends X86Instruction, @x86_xsha1 { }

  class X86Xsha256 extends X86Instruction, @x86_xsha256 { }

  class X86Xstore extends X86Instruction, @x86_xstore { }

  class X86Xsusldtrk extends X86Instruction, @x86_xsusldtrk { }

  class X86Xtest extends X86Instruction, @x86_xtest { }
}

private module InstructionInput0 implements InstructionInputSig {
  class BaseX86Instruction extends @x86_instruction {
    string toString() { instruction_string(this, result) }
  }

  class BaseX86Operand extends @operand {
    string toString() { operand_string(this, result) }
  }

  class BaseX86Register extends @register {
    string toString() { register(this, result) }

    abstract BaseX86Register getASubRegister();
  }

  class BaseRipRegister extends BaseX86Register {
    BaseRipRegister() { register(this, "rip") } // TODO: Or eip?

    final override BaseX86Register getASubRegister() { register(result, "eip") }
  }

  class BaseRspRegister extends BaseX86Register {
    BaseRspRegister() { register(this, "rsp") } // TODO: Or esp?

    final override BaseX86Register getASubRegister() { register(result, "esp") }
  }

  class BaseRbpRegister extends BaseX86Register {
    BaseRbpRegister() { register(this, "rbp") } // TODO: Or ebp?

    final override BaseX86Register getASubRegister() { register(result, "rbp") }
  }

  class BaseRcxRegister extends BaseX86Register {
    BaseRcxRegister() { register(this, "rcx") } // TODO: Or ecx?

    final override BaseX86Register getASubRegister() { register(result, "ecx") }
  }

  class BaseRdxRegister extends BaseX86Register {
    BaseRdxRegister() { register(this, "rdx") } // TODO: Or edx?

    final override BaseX86Register getASubRegister() { register(result, "edx") }
  }

  class BaseR8Register extends BaseX86Register {
    BaseR8Register() { register(this, "r8") }

    final override BaseX86Register getASubRegister() { register(result, "r8d") }
  }

  class BaseR9Register extends BaseX86Register {
    BaseR9Register() { register(this, "r9") }

    final override BaseX86Register getASubRegister() { register(result, "r9d") }
  }

  class BaseX86RegisterAccess extends @register_access {
    BaseX86Register getTarget() { register_access(this, result) }

    string toString() { result = this.getTarget().toString() }
  }

  class BaseX86UnusedOperand extends BaseX86Operand {
    BaseX86UnusedOperand() { operand_unused(this) }
  }

  class BaseX86RegisterOperand extends BaseX86Operand {
    BaseX86RegisterOperand() { operand_reg(this, _) }

    BaseX86RegisterAccess getAccess() { operand_reg(this, result) }
  }

  class BaseX86MemoryOperand extends BaseX86Operand {
    BaseX86MemoryOperand() { operand_mem(this) }

    predicate hasDisplacement() { operand_mem_displacement(this, _) }

    BaseX86RegisterAccess getSegmentRegister() { operand_mem_segment_register(this, result) }

    BaseX86RegisterAccess getBaseRegister() { operand_mem_base_register(this, result) }

    BaseX86RegisterAccess getIndexRegister() { operand_mem_index_register(this, result) }

    int getScaleFactor() { operand_mem_scale_factor(this, result) }

    int getDisplacementValue() { operand_mem_displacement(this, result) }
  }

  class BaseX86PointerOperand extends BaseX86Operand {
    BaseX86PointerOperand() { operand_ptr(this, _, _) }
  }

  class BaseX86ImmediateOperand extends BaseX86Operand {
    BaseX86ImmediateOperand() { operand_imm(this, _, _, _) }

    int getValue() { operand_imm(this, result, _, _) }

    predicate isSigned() { operand_imm_is_signed(this) }

    predicate isAddress() { operand_imm_is_address(this) }

    predicate isRelative() { operand_imm_is_relative(this) }
  }
}

module Internal = MakeInstructions<InstructionInput0>;

private module Pre {
  module PreInput implements InstructionInputSig {
    class BaseX86Instruction extends Internal::X86Instruction {
      private string toString0() { instruction_string(this, result) }

      override string toString() {
        if exists(this.getAnOperand())
        then
          result =
            this.toString0() + " " +
              strictconcat(int i, string s | s = this.getOperand(i).toString() | s, ", " order by i)
        else result = this.toString0()
      }
    }

    class BaseX86Register extends Internal::X86Register {
      BaseX86Register getASubRegister() { result = super.getASubRegister() }
    }

    class BaseRipRegister extends BaseX86Register instanceof Internal::RipRegister { }

    class BaseRspRegister extends BaseX86Register instanceof Internal::RspRegister { }

    class BaseRbpRegister extends BaseX86Register instanceof Internal::RbpRegister { }

    class BaseRcxRegister extends BaseX86Register instanceof Internal::RcxRegister { }

    class BaseRdxRegister extends BaseX86Register instanceof Internal::RdxRegister { }

    class BaseR8Register extends BaseX86Register instanceof Internal::R8Register { }

    class BaseR9Register extends BaseX86Register instanceof Internal::R9Register { }

    class BaseX86Operand extends Internal::X86Operand { }

    class BaseX86RegisterAccess extends Internal::X86RegisterAccess {
      BaseX86Register getTarget() { result = super.getTarget() }
    }

    class BaseX86UnusedOperand extends BaseX86Operand, Internal::X86UnusedOperand { }

    class BaseX86RegisterOperand extends BaseX86Operand, Internal::X86RegisterOperand {
      BaseX86RegisterAccess getAccess() { result = super.getAccess() }
    }

    class BaseX86PointerOperand extends BaseX86Operand, Internal::X86PointerOperand { }

    class BaseX86ImmediateOperand extends BaseX86Operand, Internal::X86ImmediateOperand { }

    abstract private class MyCall extends BaseX86Instruction instanceof Internal::X86Call {
      Internal::X86Operand op;

      MyCall() { op = this.getOperand(0) }

      abstract Internal::X86Instruction getTarget();
    }

    private class CallImmediate extends MyCall {
      override Internal::X86ImmediateOperand op;
      BaseX86Instruction target;

      CallImmediate() {
        op.isRelative() and
        op.getValue().toBigInt() + this.getIndex() + this.getLength().toBigInt() = target.getIndex()
      }

      override Internal::X86Instruction getTarget() { result = target }
    }

    class BaseX86MemoryOperand extends BaseX86Operand instanceof Internal::X86MemoryOperand {
      predicate hasDisplacement() { super.hasDisplacement() }

      BaseX86RegisterAccess getSegmentRegister() { result = super.getSegmentRegister() }

      BaseX86RegisterAccess getBaseRegister() { result = super.getBaseRegister() }

      BaseX86RegisterAccess getIndexRegister() { result = super.getIndexRegister() }

      int getScaleFactor() { result = super.getScaleFactor() }

      int getDisplacementValue() { result = super.getDisplacementValue() }
    }

    private class CallConstantMemoryOperand extends MyCall {
      override Internal::X86MemoryOperand op;
      int displacement;

      CallConstantMemoryOperand() {
        op.getBaseRegister().getTarget() instanceof Internal::RipRegister and
        not exists(op.getIndexRegister()) and
        displacement = op.getDisplacementValue()
      }

      final override BaseX86Instruction getTarget() {
        exists(
          QlBuiltins::BigInt rip, QlBuiltins::BigInt effectiveVA,
          QlBuiltins::BigInt offsetWithinSection, Sections::RDataSection rdata,
          QlBuiltins::BigInt address
        |
          rip = this.getVirtualAddress() + this.getLength().toBigInt() and
          effectiveVA = rip + displacement.toBigInt() and
          offsetWithinSection = effectiveVA - rdata.getVirtualAddress().toBigInt() and
          address =
            rdata.read8Bytes(offsetWithinSection) - any(Headers::OptionalHeader h).getImageBase() and
          result.getVirtualAddress() = address
        )
      }
    }

    BaseX86Instruction getCallTarget(BaseX86Instruction b) { result = b.(MyCall).getTarget() }

    abstract private class MyJumping extends BaseX86Instruction instanceof Internal::X86JumpingInstruction
    {
      abstract BaseX86Instruction getTarget();
    }

    private class ImmediateRelativeJumping extends MyJumping {
      X86ImmediateOperand op;

      ImmediateRelativeJumping() { op = this.getOperand(0) and op.isRelative() }

      final override BaseX86Instruction getTarget() {
        op.getValue().toBigInt() + this.getIndex() + this.getLength().toBigInt() = result.getIndex()
      }
    }

    BaseX86Instruction getJumpTarget(BaseX86Instruction b) { result = b.(MyJumping).getTarget() }
  }

  import MakeInstructions<PreInput> as Instructions
}

private int getOffsetOfEntryPoint() {
  result =
    any(Headers::OptionalHeader x).getEntryPoint() -
      any(Sections::TextSection s).getVirtualAddress()
}

private int getOffsetOfAnExportedFunction() {
  result =
    any(Sections::ExportTableEntry e).getAddress() -
      any(Sections::TextSection s).getVirtualAddress()
}

private module Input implements InstructionInputSig {
  private class ProgramEntryInstruction0 extends Pre::Instructions::X86Instruction {
    ProgramEntryInstruction0() { this.getIndex() = getOffsetOfEntryPoint().toBigInt() }
  }

  private class ExportedInstruction0 extends Pre::Instructions::X86Instruction {
    ExportedInstruction0() { this.getIndex() = getOffsetOfAnExportedFunction().toBigInt() }
  }

  private predicate fwd(Pre::Instructions::X86Instruction i) {
    i instanceof ProgramEntryInstruction0
    or
    i instanceof ExportedInstruction0
    or
    exists(Pre::Instructions::X86Instruction i0 | fwd(i0) |
      i0.getASuccessor() = i
      or
      Pre::PreInput::getCallTarget(i0) = i
    )
  }

  class BaseX86Instruction extends Pre::Instructions::X86Instruction {
    BaseX86Instruction() { fwd(this) }
  }

  BaseX86Instruction getCallTarget(BaseX86Instruction b) {
    result = Pre::PreInput::getCallTarget(b)
  }

  BaseX86Instruction getJumpTarget(BaseX86Instruction b) {
    result = Pre::PreInput::getJumpTarget(b)
  }

  class BaseX86Register extends Pre::Instructions::X86Register {
    BaseX86Register getASubRegister() { result = super.getASubRegister() }
  }

  class BaseRipRegister extends BaseX86Register instanceof Pre::Instructions::RipRegister { }

  class BaseRspRegister extends BaseX86Register instanceof Pre::Instructions::RspRegister { }

  class BaseRbpRegister extends BaseX86Register instanceof Pre::Instructions::RbpRegister { }

  class BaseRcxRegister extends BaseX86Register instanceof Pre::Instructions::RcxRegister { }

  class BaseRdxRegister extends BaseX86Register instanceof Pre::Instructions::RdxRegister { }

  class BaseR8Register extends BaseX86Register instanceof Pre::Instructions::R8Register { }

  class BaseR9Register extends BaseX86Register instanceof Pre::Instructions::R9Register { }

  class BaseX86Operand extends Pre::Instructions::X86Operand {
    BaseX86Operand() { this.getUse() instanceof BaseX86Instruction }
  }

  class BaseX86RegisterAccess extends Pre::Instructions::X86RegisterAccess {
    BaseX86Register getTarget() { result = super.getTarget() }
  }

  class BaseX86UnusedOperand extends BaseX86Operand, Pre::Instructions::X86UnusedOperand { }

  class BaseX86RegisterOperand extends BaseX86Operand, Pre::Instructions::X86RegisterOperand {
    BaseX86RegisterAccess getAccess() { result = super.getAccess() }
  }

  final private class FinalBaseX86Operand = BaseX86Operand;

  class BaseX86MemoryOperand extends FinalBaseX86Operand, Pre::Instructions::X86MemoryOperand {
    BaseX86RegisterAccess getSegmentRegister() { result = super.getSegmentRegister() }

    BaseX86RegisterAccess getBaseRegister() { result = super.getBaseRegister() }

    BaseX86RegisterAccess getIndexRegister() { result = super.getIndexRegister() }
  }

  class BaseX86PointerOperand extends BaseX86Operand, Pre::Instructions::X86PointerOperand { }

  class BaseX86ImmediateOperand extends BaseX86Operand, Pre::Instructions::X86ImmediateOperand { }
}

class X86ProgramEntryInstruction extends X86Instruction {
  X86ProgramEntryInstruction() { this.getIndex() = getOffsetOfEntryPoint().toBigInt() }
}

class X86ExportedEntryInstruction extends X86Instruction {
  X86ExportedEntryInstruction() { this.getIndex() = getOffsetOfAnExportedFunction().toBigInt() }
}

import MakeInstructions<Input>
