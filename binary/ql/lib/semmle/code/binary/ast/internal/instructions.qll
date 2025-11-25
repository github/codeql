private import semmle.code.binary.ast.Sections as Sections
private import semmle.code.binary.ast.Headers as Headers
private import semmle.code.binary.ast.Location

signature module InstructionInputSig {
  class BaseInstruction extends @x86_instruction {
    string toString();
  }

  class BaseOperand extends @operand {
    string toString();
  }

  class BaseRegister {
    string toString();
  }

  class BaseRipRegister extends BaseRegister;

  class BaseRspRegister extends BaseRegister;

  class BaseRbpRegister extends BaseRegister;

  class BaseRegisterAccess {
    string toString();

    BaseRegister getTarget();
  }

  class BaseUnusedOperand extends BaseOperand;

  class BaseRegisterOperand extends BaseOperand {
    BaseRegisterAccess getAccess();
  }

  class BaseMemoryOperand extends BaseOperand {
    predicate hasDisplacement();

    BaseRegisterAccess getSegmentRegister();

    BaseRegisterAccess getBaseRegister();

    BaseRegisterAccess getIndexRegister();

    int getScaleFactor();

    int getDisplacementValue();
  }

  class BasePointerOperand extends BaseOperand;

  class BaseImmediateOperand extends BaseOperand {
    int getValue();

    predicate isSigned();

    predicate isAddress();

    predicate isRelative();
  }

  default BaseInstruction getCallTarget(BaseInstruction call) { none() }

  default BaseInstruction getJumpTarget(BaseInstruction jump) { none() }
}

module MakeInstructions<InstructionInputSig InstructionInput> {
  private import InstructionInput

  final private class FinalBase = BaseInstruction;

  class Instruction extends FinalBase {
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

    Instruction getASuccessor() {
      result.getIndex() = this.getIndex() + this.getLength().toBigInt()
    }

    Operand getAnOperand() { result = this.getOperand(_) }

    Operand getOperand(int index) { operand(result, this, index, _) }
  }

  final private class FinalBaseOperand = BaseOperand;

  final class Operand extends FinalBaseOperand {
    Instruction getUse() { this = result.getAnOperand() }

    int getIndex() { this = this.getUse().getOperand(result) }
  }

  final private class FinalRegister = BaseRegister;

  class Register extends FinalRegister { }

  final private class FinalRipRegister = BaseRipRegister;

  class RipRegister extends FinalRipRegister { }

  final private class FinalRspRegister = BaseRspRegister;

  class RspRegister extends FinalRspRegister { }

  final private class FinalRbpRegister = BaseRbpRegister;

  class RbpRegister extends FinalRbpRegister { }

  final private class FinalRegisterAccess = BaseRegisterAccess;

  class RegisterAccess extends FinalRegisterAccess { }

  final private class FinalImmediateOperand = BaseImmediateOperand;

  final class ImmediateOperand extends Operand, FinalImmediateOperand { }

  final private class FinalUnusedOperand = BaseUnusedOperand;

  final class UnusedOperand extends Operand, FinalUnusedOperand { }

  final private class FinalBaseRegisterOperand = BaseRegisterOperand;

  final class RegisterOperand extends Operand, FinalBaseRegisterOperand {
    BaseRegister getRegister() { result = this.getAccess().getTarget() }
  }

  final private class FinalBaseMemoryOperand = BaseMemoryOperand;

  final class MemoryOperand extends Operand, FinalBaseMemoryOperand { }

  final private class FinalBasePointerOperand = BasePointerOperand;

  final class PointerOperand extends Operand, FinalBasePointerOperand { }

  class Aaa extends Instruction, @x86_aaa { }

  class Aad extends Instruction, @x86_aad { }

  class Aadd extends Instruction, @x86_aadd { }

  class Aam extends Instruction, @x86_aam { }

  class Aand extends Instruction, @x86_aand { }

  class Aas extends Instruction, @x86_aas { }

  class Adc extends Instruction, @x86_adc { }

  class Adcx extends Instruction, @x86_adcx { }

  class Add extends Instruction, @x86_add { }

  class Addpd extends Instruction, @x86_addpd { }

  class Addps extends Instruction, @x86_addps { }

  class Addsd extends Instruction, @x86_addsd { }

  class Addss extends Instruction, @x86_addss { }

  class Addsubpd extends Instruction, @x86_addsubpd { }

  class Addsubps extends Instruction, @x86_addsubps { }

  class Adox extends Instruction, @x86_adox { }

  class Aesdec extends Instruction, @x86_aesdec { }

  class Aesdec128Kl extends Instruction, @x86_aesdec128kl { }

  class Aesdec256Kl extends Instruction, @x86_aesdec256kl { }

  class Aesdeclast extends Instruction, @x86_aesdeclast { }

  class Aesdecwide128Kl extends Instruction, @x86_aesdecwide128kl { }

  class Aesdecwide256Kl extends Instruction, @x86_aesdecwide256kl { }

  class Aesenc extends Instruction, @x86_aesenc { }

  class Aesenc128Kl extends Instruction, @x86_aesenc128kl { }

  class Aesenc256Kl extends Instruction, @x86_aesenc256kl { }

  class Aesenclast extends Instruction, @x86_aesenclast { }

  class Aesencwide128Kl extends Instruction, @x86_aesencwide128kl { }

  class Aesencwide256Kl extends Instruction, @x86_aesencwide256kl { }

  class Aesimc extends Instruction, @x86_aesimc { }

  class Aeskeygenassist extends Instruction, @x86_aeskeygenassist { }

  class And extends Instruction, @x86_and { }

  class Andn extends Instruction, @x86_andn { }

  class Andnpd extends Instruction, @x86_andnpd { }

  class Andnps extends Instruction, @x86_andnps { }

  class Andpd extends Instruction, @x86_andpd { }

  class Andps extends Instruction, @x86_andps { }

  class Aor extends Instruction, @x86_aor { }

  class Arpl extends Instruction, @x86_arpl { }

  class Axor extends Instruction, @x86_axor { }

  class Bextr extends Instruction, @x86_bextr { }

  class Blcfill extends Instruction, @x86_blcfill { }

  class Blci extends Instruction, @x86_blci { }

  class Blcic extends Instruction, @x86_blcic { }

  class Blcmsk extends Instruction, @x86_blcmsk { }

  class Blcs extends Instruction, @x86_blcs { }

  class Blendpd extends Instruction, @x86_blendpd { }

  class Blendps extends Instruction, @x86_blendps { }

  class Blendvpd extends Instruction, @x86_blendvpd { }

  class Blendvps extends Instruction, @x86_blendvps { }

  class Blsfill extends Instruction, @x86_blsfill { }

  class Blsi extends Instruction, @x86_blsi { }

  class Blsic extends Instruction, @x86_blsic { }

  class Blsmsk extends Instruction, @x86_blsmsk { }

  class Blsr extends Instruction, @x86_blsr { }

  class Bndcl extends Instruction, @x86_bndcl { }

  class Bndcn extends Instruction, @x86_bndcn { }

  class Bndcu extends Instruction, @x86_bndcu { }

  class Bndldx extends Instruction, @x86_bndldx { }

  class Bndmk extends Instruction, @x86_bndmk { }

  class Bndmov extends Instruction, @x86_bndmov { }

  class Bndstx extends Instruction, @x86_bndstx { }

  class Bound extends Instruction, @x86_bound { }

  class Bsf extends Instruction, @x86_bsf { }

  class Bsr extends Instruction, @x86_bsr { }

  class Bswap extends Instruction, @x86_bswap { }

  class Bt extends Instruction, @x86_bt { }

  class Btc extends Instruction, @x86_btc { }

  class Btr extends Instruction, @x86_btr { }

  class Bts extends Instruction, @x86_bts { }

  class Bzhi extends Instruction, @x86_bzhi { }

  class Call extends Instruction, @x86_call {
    Instruction getTarget() { result = getCallTarget(this) }
  }

  class Cbw extends Instruction, @x86_cbw { }

  class Ccmpb extends Instruction, @x86_ccmpb { }

  class Ccmpbe extends Instruction, @x86_ccmpbe { }

  class Ccmpf extends Instruction, @x86_ccmpf { }

  class Ccmpl extends Instruction, @x86_ccmpl { }

  class Ccmple extends Instruction, @x86_ccmple { }

  class Ccmpnb extends Instruction, @x86_ccmpnb { }

  class Ccmpnbe extends Instruction, @x86_ccmpnbe { }

  class Ccmpnl extends Instruction, @x86_ccmpnl { }

  class Ccmpnle extends Instruction, @x86_ccmpnle { }

  class Ccmpno extends Instruction, @x86_ccmpno { }

  class Ccmpns extends Instruction, @x86_ccmpns { }

  class Ccmpnz extends Instruction, @x86_ccmpnz { }

  class Ccmpo extends Instruction, @x86_ccmpo { }

  class Ccmps extends Instruction, @x86_ccmps { }

  class Ccmpt extends Instruction, @x86_ccmpt { }

  class Ccmpz extends Instruction, @x86_ccmpz { }

  class Cdq extends Instruction, @x86_cdq { }

  class Cdqe extends Instruction, @x86_cdqe { }

  class Cfcmovb extends Instruction, @x86_cfcmovb { }

  class Cfcmovbe extends Instruction, @x86_cfcmovbe { }

  class Cfcmovl extends Instruction, @x86_cfcmovl { }

  class Cfcmovle extends Instruction, @x86_cfcmovle { }

  class Cfcmovnb extends Instruction, @x86_cfcmovnb { }

  class Cfcmovnbe extends Instruction, @x86_cfcmovnbe { }

  class Cfcmovnl extends Instruction, @x86_cfcmovnl { }

  class Cfcmovnle extends Instruction, @x86_cfcmovnle { }

  class Cfcmovno extends Instruction, @x86_cfcmovno { }

  class Cfcmovnp extends Instruction, @x86_cfcmovnp { }

  class Cfcmovns extends Instruction, @x86_cfcmovns { }

  class Cfcmovnz extends Instruction, @x86_cfcmovnz { }

  class Cfcmovo extends Instruction, @x86_cfcmovo { }

  class Cfcmovp extends Instruction, @x86_cfcmovp { }

  class Cfcmovs extends Instruction, @x86_cfcmovs { }

  class Cfcmovz extends Instruction, @x86_cfcmovz { }

  class Clac extends Instruction, @x86_clac { }

  class Clc extends Instruction, @x86_clc { }

  class Cld extends Instruction, @x86_cld { }

  class Cldemote extends Instruction, @x86_cldemote { }

  class Clevict0 extends Instruction, @x86_clevict0 { }

  class Clevict1 extends Instruction, @x86_clevict1 { }

  class Clflush extends Instruction, @x86_clflush { }

  class Clflushopt extends Instruction, @x86_clflushopt { }

  class Clgi extends Instruction, @x86_clgi { }

  class Cli extends Instruction, @x86_cli { }

  class Clrssbsy extends Instruction, @x86_clrssbsy { }

  class Clts extends Instruction, @x86_clts { }

  class Clui extends Instruction, @x86_clui { }

  class Clwb extends Instruction, @x86_clwb { }

  class Clzero extends Instruction, @x86_clzero { }

  class Cmc extends Instruction, @x86_cmc { }

  class Cmovb extends Instruction, @x86_cmovb { }

  class Cmovbe extends Instruction, @x86_cmovbe { }

  class Cmovl extends Instruction, @x86_cmovl { }

  class Cmovle extends Instruction, @x86_cmovle { }

  class Cmovnb extends Instruction, @x86_cmovnb { }

  class Cmovnbe extends Instruction, @x86_cmovnbe { }

  class Cmovnl extends Instruction, @x86_cmovnl { }

  class Cmovnle extends Instruction, @x86_cmovnle { }

  class Cmovno extends Instruction, @x86_cmovno { }

  class Cmovnp extends Instruction, @x86_cmovnp { }

  class Cmovns extends Instruction, @x86_cmovns { }

  class Cmovnz extends Instruction, @x86_cmovnz { }

  class Cmovo extends Instruction, @x86_cmovo { }

  class Cmovp extends Instruction, @x86_cmovp { }

  class Cmovs extends Instruction, @x86_cmovs { }

  class Cmovz extends Instruction, @x86_cmovz { }

  class Cmp extends Instruction, @x86_cmp { }

  class Cmpbexadd extends Instruction, @x86_cmpbexadd { }

  class Cmpbxadd extends Instruction, @x86_cmpbxadd { }

  class Cmplexadd extends Instruction, @x86_cmplexadd { }

  class Cmplxadd extends Instruction, @x86_cmplxadd { }

  class Cmpnbexadd extends Instruction, @x86_cmpnbexadd { }

  class Cmpnbxadd extends Instruction, @x86_cmpnbxadd { }

  class Cmpnlexadd extends Instruction, @x86_cmpnlexadd { }

  class Cmpnlxadd extends Instruction, @x86_cmpnlxadd { }

  class Cmpnoxadd extends Instruction, @x86_cmpnoxadd { }

  class Cmpnpxadd extends Instruction, @x86_cmpnpxadd { }

  class Cmpnsxadd extends Instruction, @x86_cmpnsxadd { }

  class Cmpnzxadd extends Instruction, @x86_cmpnzxadd { }

  class Cmpoxadd extends Instruction, @x86_cmpoxadd { }

  class Cmppd extends Instruction, @x86_cmppd { }

  class Cmpps extends Instruction, @x86_cmpps { }

  class Cmppxadd extends Instruction, @x86_cmppxadd { }

  class Cmpsb extends Instruction, @x86_cmpsb { }

  class Cmpsd extends Instruction, @x86_cmpsd { }

  class Cmpsq extends Instruction, @x86_cmpsq { }

  class Cmpss extends Instruction, @x86_cmpss { }

  class Cmpsw extends Instruction, @x86_cmpsw { }

  class Cmpsxadd extends Instruction, @x86_cmpsxadd { }

  class Cmpxchg extends Instruction, @x86_cmpxchg { }

  class Cmpxchg16B extends Instruction, @x86_cmpxchg16b { }

  class Cmpxchg8B extends Instruction, @x86_cmpxchg8b { }

  class Cmpzxadd extends Instruction, @x86_cmpzxadd { }

  class Comisd extends Instruction, @x86_comisd { }

  class Comiss extends Instruction, @x86_comiss { }

  class Cpuid extends Instruction, @x86_cpuid { }

  class Cqo extends Instruction, @x86_cqo { }

  class Crc32 extends Instruction, @x86_crc32 { }

  class Ctestb extends Instruction, @x86_ctestb { }

  class Ctestbe extends Instruction, @x86_ctestbe { }

  class Ctestf extends Instruction, @x86_ctestf { }

  class Ctestl extends Instruction, @x86_ctestl { }

  class Ctestle extends Instruction, @x86_ctestle { }

  class Ctestnb extends Instruction, @x86_ctestnb { }

  class Ctestnbe extends Instruction, @x86_ctestnbe { }

  class Ctestnl extends Instruction, @x86_ctestnl { }

  class Ctestnle extends Instruction, @x86_ctestnle { }

  class Ctestno extends Instruction, @x86_ctestno { }

  class Ctestns extends Instruction, @x86_ctestns { }

  class Ctestnz extends Instruction, @x86_ctestnz { }

  class Ctesto extends Instruction, @x86_ctesto { }

  class Ctests extends Instruction, @x86_ctests { }

  class Ctestt extends Instruction, @x86_ctestt { }

  class Ctestz extends Instruction, @x86_ctestz { }

  class Cvtdq2Pd extends Instruction, @x86_cvtdq2pd { }

  class Cvtdq2Ps extends Instruction, @x86_cvtdq2ps { }

  class Cvtpd2Dq extends Instruction, @x86_cvtpd2dq { }

  class Cvtpd2Pi extends Instruction, @x86_cvtpd2pi { }

  class Cvtpd2Ps extends Instruction, @x86_cvtpd2ps { }

  class Cvtpi2Pd extends Instruction, @x86_cvtpi2pd { }

  class Cvtpi2Ps extends Instruction, @x86_cvtpi2ps { }

  class Cvtps2Dq extends Instruction, @x86_cvtps2dq { }

  class Cvtps2Pd extends Instruction, @x86_cvtps2pd { }

  class Cvtps2Pi extends Instruction, @x86_cvtps2pi { }

  class Cvtsd2Si extends Instruction, @x86_cvtsd2si { }

  class Cvtsd2Ss extends Instruction, @x86_cvtsd2ss { }

  class Cvtsi2Sd extends Instruction, @x86_cvtsi2sd { }

  class Cvtsi2Ss extends Instruction, @x86_cvtsi2ss { }

  class Cvtss2Sd extends Instruction, @x86_cvtss2sd { }

  class Cvtss2Si extends Instruction, @x86_cvtss2si { }

  class Cvttpd2Dq extends Instruction, @x86_cvttpd2dq { }

  class Cvttpd2Pi extends Instruction, @x86_cvttpd2pi { }

  class Cvttps2Dq extends Instruction, @x86_cvttps2dq { }

  class Cvttps2Pi extends Instruction, @x86_cvttps2pi { }

  class Cvttsd2Si extends Instruction, @x86_cvttsd2si { }

  class Cvttss2Si extends Instruction, @x86_cvttss2si { }

  class Cwd extends Instruction, @x86_cwd { }

  class Cwde extends Instruction, @x86_cwde { }

  class Daa extends Instruction, @x86_daa { }

  class Das extends Instruction, @x86_das { }

  class Dec extends Instruction, @x86_dec { }

  class Delay extends Instruction, @x86_delay { }

  class Div extends Instruction, @x86_div { }

  class Divpd extends Instruction, @x86_divpd { }

  class Divps extends Instruction, @x86_divps { }

  class Divsd extends Instruction, @x86_divsd { }

  class Divss extends Instruction, @x86_divss { }

  class Dppd extends Instruction, @x86_dppd { }

  class Dpps extends Instruction, @x86_dpps { }

  class Emms extends Instruction, @x86_emms { }

  class Encls extends Instruction, @x86_encls { }

  class Enclu extends Instruction, @x86_enclu { }

  class Enclv extends Instruction, @x86_enclv { }

  class Encodekey128 extends Instruction, @x86_encodekey128 { }

  class Encodekey256 extends Instruction, @x86_encodekey256 { }

  class Endbr32 extends Instruction, @x86_endbr32 { }

  class Endbr64 extends Instruction, @x86_endbr64 { }

  class Enqcmd extends Instruction, @x86_enqcmd { }

  class Enqcmds extends Instruction, @x86_enqcmds { }

  class Enter extends Instruction, @x86_enter { }

  class Erets extends Instruction, @x86_erets { }

  class Eretu extends Instruction, @x86_eretu { }

  class Extractps extends Instruction, @x86_extractps { }

  class Extrq extends Instruction, @x86_extrq { }

  class F2Xm1 extends Instruction, @x86_f2xm1 { }

  class Fabs extends Instruction, @x86_fabs { }

  class Fadd extends Instruction, @x86_fadd { }

  class Faddp extends Instruction, @x86_faddp { }

  class Fbld extends Instruction, @x86_fbld { }

  class Fbstp extends Instruction, @x86_fbstp { }

  class Fchs extends Instruction, @x86_fchs { }

  class Fcmovb extends Instruction, @x86_fcmovb { }

  class Fcmovbe extends Instruction, @x86_fcmovbe { }

  class Fcmove extends Instruction, @x86_fcmove { }

  class Fcmovnb extends Instruction, @x86_fcmovnb { }

  class Fcmovnbe extends Instruction, @x86_fcmovnbe { }

  class Fcmovne extends Instruction, @x86_fcmovne { }

  class Fcmovnu extends Instruction, @x86_fcmovnu { }

  class Fcmovu extends Instruction, @x86_fcmovu { }

  class Fcom extends Instruction, @x86_fcom { }

  class Fcomi extends Instruction, @x86_fcomi { }

  class Fcomip extends Instruction, @x86_fcomip { }

  class Fcomp extends Instruction, @x86_fcomp { }

  class Fcompp extends Instruction, @x86_fcompp { }

  class Fcos extends Instruction, @x86_fcos { }

  class Fdecstp extends Instruction, @x86_fdecstp { }

  class Fdisi8087Nop extends Instruction, @x86_fdisi8087nop { }

  class Fdiv extends Instruction, @x86_fdiv { }

  class Fdivp extends Instruction, @x86_fdivp { }

  class Fdivr extends Instruction, @x86_fdivr { }

  class Fdivrp extends Instruction, @x86_fdivrp { }

  class Femms extends Instruction, @x86_femms { }

  class Feni8087Nop extends Instruction, @x86_feni8087nop { }

  class Ffree extends Instruction, @x86_ffree { }

  class Ffreep extends Instruction, @x86_ffreep { }

  class Fiadd extends Instruction, @x86_fiadd { }

  class Ficom extends Instruction, @x86_ficom { }

  class Ficomp extends Instruction, @x86_ficomp { }

  class Fidiv extends Instruction, @x86_fidiv { }

  class Fidivr extends Instruction, @x86_fidivr { }

  class Fild extends Instruction, @x86_fild { }

  class Fimul extends Instruction, @x86_fimul { }

  class Fincstp extends Instruction, @x86_fincstp { }

  class Fist extends Instruction, @x86_fist { }

  class Fistp extends Instruction, @x86_fistp { }

  class Fisttp extends Instruction, @x86_fisttp { }

  class Fisub extends Instruction, @x86_fisub { }

  class Fisubr extends Instruction, @x86_fisubr { }

  class Fld extends Instruction, @x86_fld { }

  class Fld1 extends Instruction, @x86_fld1 { }

  class Fldcw extends Instruction, @x86_fldcw { }

  class Fldenv extends Instruction, @x86_fldenv { }

  class Fldl2E extends Instruction, @x86_fldl2e { }

  class Fldl2T extends Instruction, @x86_fldl2t { }

  class Fldlg2 extends Instruction, @x86_fldlg2 { }

  class Fldln2 extends Instruction, @x86_fldln2 { }

  class Fldpi extends Instruction, @x86_fldpi { }

  class Fldz extends Instruction, @x86_fldz { }

  class Fmul extends Instruction, @x86_fmul { }

  class Fmulp extends Instruction, @x86_fmulp { }

  class Fnclex extends Instruction, @x86_fnclex { }

  class Fninit extends Instruction, @x86_fninit { }

  class Fnop extends Instruction, @x86_fnop { }

  class Fnsave extends Instruction, @x86_fnsave { }

  class Fnstcw extends Instruction, @x86_fnstcw { }

  class Fnstenv extends Instruction, @x86_fnstenv { }

  class Fnstsw extends Instruction, @x86_fnstsw { }

  class Fpatan extends Instruction, @x86_fpatan { }

  class Fprem extends Instruction, @x86_fprem { }

  class Fprem1 extends Instruction, @x86_fprem1 { }

  class Fptan extends Instruction, @x86_fptan { }

  class Frndint extends Instruction, @x86_frndint { }

  class Frstor extends Instruction, @x86_frstor { }

  class Fscale extends Instruction, @x86_fscale { }

  class Fsetpm287Nop extends Instruction, @x86_fsetpm287nop { }

  class Fsin extends Instruction, @x86_fsin { }

  class Fsincos extends Instruction, @x86_fsincos { }

  class Fsqrt extends Instruction, @x86_fsqrt { }

  class Fst extends Instruction, @x86_fst { }

  class Fstp extends Instruction, @x86_fstp { }

  class Fstpnce extends Instruction, @x86_fstpnce { }

  class Fsub extends Instruction, @x86_fsub { }

  class Fsubp extends Instruction, @x86_fsubp { }

  class Fsubr extends Instruction, @x86_fsubr { }

  class Fsubrp extends Instruction, @x86_fsubrp { }

  class Ftst extends Instruction, @x86_ftst { }

  class Fucom extends Instruction, @x86_fucom { }

  class Fucomi extends Instruction, @x86_fucomi { }

  class Fucomip extends Instruction, @x86_fucomip { }

  class Fucomp extends Instruction, @x86_fucomp { }

  class Fucompp extends Instruction, @x86_fucompp { }

  class Fwait extends Instruction, @x86_fwait { }

  class Fxam extends Instruction, @x86_fxam { }

  class Fxch extends Instruction, @x86_fxch { }

  class Fxrstor extends Instruction, @x86_fxrstor { }

  class Fxrstor64 extends Instruction, @x86_fxrstor64 { }

  class Fxsave extends Instruction, @x86_fxsave { }

  class Fxsave64 extends Instruction, @x86_fxsave64 { }

  class Fxtract extends Instruction, @x86_fxtract { }

  class Fyl2X extends Instruction, @x86_fyl2x { }

  class Fyl2Xp1 extends Instruction, @x86_fyl2xp1 { }

  class Getsec extends Instruction, @x86_getsec { }

  class Gf2P8Affineinvqb extends Instruction, @x86_gf2p8affineinvqb { }

  class Gf2P8Affineqb extends Instruction, @x86_gf2p8affineqb { }

  class Gf2P8Mulb extends Instruction, @x86_gf2p8mulb { }

  class Haddpd extends Instruction, @x86_haddpd { }

  class Haddps extends Instruction, @x86_haddps { }

  class Hlt extends Instruction, @x86_hlt { }

  class Hreset extends Instruction, @x86_hreset { }

  class Hsubpd extends Instruction, @x86_hsubpd { }

  class Hsubps extends Instruction, @x86_hsubps { }

  class Idiv extends Instruction, @x86_idiv { }

  class Imul extends Instruction, @x86_imul { }

  class Imulzu extends Instruction, @x86_imulzu { }

  class In extends Instruction, @x86_in { }

  class Inc extends Instruction, @x86_inc { }

  class Incsspd extends Instruction, @x86_incsspd { }

  class Incsspq extends Instruction, @x86_incsspq { }

  class Insb extends Instruction, @x86_insb { }

  class Insd extends Instruction, @x86_insd { }

  class Insertps extends Instruction, @x86_insertps { }

  class Insertq extends Instruction, @x86_insertq { }

  class Insw extends Instruction, @x86_insw { }

  class Int extends Instruction, @x86_int { }

  class Int1 extends Instruction, @x86_int1 { }

  class Int3 extends Instruction, @x86_int3 {
    override Instruction getASuccessor() { none() }
  }

  class Into extends Instruction, @x86_into { }

  class Invd extends Instruction, @x86_invd { }

  class Invept extends Instruction, @x86_invept { }

  class Invlpg extends Instruction, @x86_invlpg { }

  class Invlpga extends Instruction, @x86_invlpga { }

  class Invlpgb extends Instruction, @x86_invlpgb { }

  class Invpcid extends Instruction, @x86_invpcid { }

  class Invvpid extends Instruction, @x86_invvpid { }

  class Iret extends Instruction, @x86_iret { }

  class Iretd extends Instruction, @x86_iretd { }

  class Iretq extends Instruction, @x86_iretq { }

  abstract class JumpingInstruction extends Instruction {
    final Instruction getTarget() { result = getJumpTarget(this) }
  }

  abstract class ConditionalJumpInstruction extends JumpingInstruction {
    override Instruction getASuccessor() {
      result = super.getASuccessor() or result = this.getTarget()
    }

    final Instruction getFallThrough() {
      result = this.getASuccessor() and
      result != this.getTarget()
    }
  }

  class Jb extends ConditionalJumpInstruction, @x86_jb { }

  class Jbe extends ConditionalJumpInstruction, @x86_jbe { }

  class Jcxz extends ConditionalJumpInstruction, @x86_jcxz { }

  class Jecxz extends ConditionalJumpInstruction, @x86_jecxz { }

  class Jknzd extends ConditionalJumpInstruction, @x86_jknzd { }

  class Jkzd extends ConditionalJumpInstruction, @x86_jkzd { }

  class Jl extends ConditionalJumpInstruction, @x86_jl { }

  class Jle extends ConditionalJumpInstruction, @x86_jle { }

  class Jmp extends JumpingInstruction, @x86_jmp {
    override Instruction getASuccessor() { result = this.getTarget() }
  }

  class Jmpabs extends ConditionalJumpInstruction, @x86_jmpabs { }

  class Jnb extends ConditionalJumpInstruction, @x86_jnb { }

  class Jnbe extends ConditionalJumpInstruction, @x86_jnbe { }

  class Jnl extends ConditionalJumpInstruction, @x86_jnl { }

  class Jnle extends ConditionalJumpInstruction, @x86_jnle { }

  class Jno extends ConditionalJumpInstruction, @x86_jno { }

  class Jnp extends ConditionalJumpInstruction, @x86_jnp { }

  class Jns extends ConditionalJumpInstruction, @x86_jns { }

  class Jnz extends ConditionalJumpInstruction, @x86_jnz { }

  class Jo extends ConditionalJumpInstruction, @x86_jo { }

  class Jp extends ConditionalJumpInstruction, @x86_jp { }

  class Jrcxz extends ConditionalJumpInstruction, @x86_jrcxz { }

  class Js extends ConditionalJumpInstruction, @x86_js { }

  class Jz extends ConditionalJumpInstruction, @x86_jz { }

  class Kaddb extends Instruction, @x86_kaddb { }

  class Kaddd extends Instruction, @x86_kaddd { }

  class Kaddq extends Instruction, @x86_kaddq { }

  class Kaddw extends Instruction, @x86_kaddw { }

  class Kand extends Instruction, @x86_kand { }

  class Kandb extends Instruction, @x86_kandb { }

  class Kandd extends Instruction, @x86_kandd { }

  class Kandn extends Instruction, @x86_kandn { }

  class Kandnb extends Instruction, @x86_kandnb { }

  class Kandnd extends Instruction, @x86_kandnd { }

  class Kandnq extends Instruction, @x86_kandnq { }

  class Kandnr extends Instruction, @x86_kandnr { }

  class Kandnw extends Instruction, @x86_kandnw { }

  class Kandq extends Instruction, @x86_kandq { }

  class Kandw extends Instruction, @x86_kandw { }

  class Kconcath extends Instruction, @x86_kconcath { }

  class Kconcatl extends Instruction, @x86_kconcatl { }

  class Kextract extends Instruction, @x86_kextract { }

  class Kmerge2L1H extends Instruction, @x86_kmerge2l1h { }

  class Kmerge2L1L extends Instruction, @x86_kmerge2l1l { }

  class Kmov extends Instruction, @x86_kmov { }

  class Kmovb extends Instruction, @x86_kmovb { }

  class Kmovd extends Instruction, @x86_kmovd { }

  class Kmovq extends Instruction, @x86_kmovq { }

  class Kmovw extends Instruction, @x86_kmovw { }

  class Knot extends Instruction, @x86_knot { }

  class Knotb extends Instruction, @x86_knotb { }

  class Knotd extends Instruction, @x86_knotd { }

  class Knotq extends Instruction, @x86_knotq { }

  class Knotw extends Instruction, @x86_knotw { }

  class Kor extends Instruction, @x86_kor { }

  class Korb extends Instruction, @x86_korb { }

  class Kord extends Instruction, @x86_kord { }

  class Korq extends Instruction, @x86_korq { }

  class Kortest extends Instruction, @x86_kortest { }

  class Kortestb extends Instruction, @x86_kortestb { }

  class Kortestd extends Instruction, @x86_kortestd { }

  class Kortestq extends Instruction, @x86_kortestq { }

  class Kortestw extends Instruction, @x86_kortestw { }

  class Korw extends Instruction, @x86_korw { }

  class Kshiftlb extends Instruction, @x86_kshiftlb { }

  class Kshiftld extends Instruction, @x86_kshiftld { }

  class Kshiftlq extends Instruction, @x86_kshiftlq { }

  class Kshiftlw extends Instruction, @x86_kshiftlw { }

  class Kshiftrb extends Instruction, @x86_kshiftrb { }

  class Kshiftrd extends Instruction, @x86_kshiftrd { }

  class Kshiftrq extends Instruction, @x86_kshiftrq { }

  class Kshiftrw extends Instruction, @x86_kshiftrw { }

  class Ktestb extends Instruction, @x86_ktestb { }

  class Ktestd extends Instruction, @x86_ktestd { }

  class Ktestq extends Instruction, @x86_ktestq { }

  class Ktestw extends Instruction, @x86_ktestw { }

  class Kunpckbw extends Instruction, @x86_kunpckbw { }

  class Kunpckdq extends Instruction, @x86_kunpckdq { }

  class Kunpckwd extends Instruction, @x86_kunpckwd { }

  class Kxnor extends Instruction, @x86_kxnor { }

  class Kxnorb extends Instruction, @x86_kxnorb { }

  class Kxnord extends Instruction, @x86_kxnord { }

  class Kxnorq extends Instruction, @x86_kxnorq { }

  class Kxnorw extends Instruction, @x86_kxnorw { }

  class Kxor extends Instruction, @x86_kxor { }

  class Kxorb extends Instruction, @x86_kxorb { }

  class Kxord extends Instruction, @x86_kxord { }

  class Kxorq extends Instruction, @x86_kxorq { }

  class Kxorw extends Instruction, @x86_kxorw { }

  class Lahf extends Instruction, @x86_lahf { }

  class Lar extends Instruction, @x86_lar { }

  class Lddqu extends Instruction, @x86_lddqu { }

  class Ldmxcsr extends Instruction, @x86_ldmxcsr { }

  class Lds extends Instruction, @x86_lds { }

  class Ldtilecfg extends Instruction, @x86_ldtilecfg { }

  class Lea extends Instruction, @x86_lea { }

  class Leave extends Instruction, @x86_leave { }

  class Les extends Instruction, @x86_les { }

  class Lfence extends Instruction, @x86_lfence { }

  class Lfs extends Instruction, @x86_lfs { }

  class Lgdt extends Instruction, @x86_lgdt { }

  class Lgs extends Instruction, @x86_lgs { }

  class Lidt extends Instruction, @x86_lidt { }

  class Lkgs extends Instruction, @x86_lkgs { }

  class Lldt extends Instruction, @x86_lldt { }

  class Llwpcb extends Instruction, @x86_llwpcb { }

  class Lmsw extends Instruction, @x86_lmsw { }

  class Loadiwkey extends Instruction, @x86_loadiwkey { }

  class Lodsb extends Instruction, @x86_lodsb { }

  class Lodsd extends Instruction, @x86_lodsd { }

  class Lodsq extends Instruction, @x86_lodsq { }

  class Lodsw extends Instruction, @x86_lodsw { }

  class Loop extends Instruction, @x86_loop { }

  class Loope extends Instruction, @x86_loope { }

  class Loopne extends Instruction, @x86_loopne { }

  class Lsl extends Instruction, @x86_lsl { }

  class Lss extends Instruction, @x86_lss { }

  class Ltr extends Instruction, @x86_ltr { }

  class Lwpins extends Instruction, @x86_lwpins { }

  class Lwpval extends Instruction, @x86_lwpval { }

  class Lzcnt extends Instruction, @x86_lzcnt { }

  class Maskmovdqu extends Instruction, @x86_maskmovdqu { }

  class Maskmovq extends Instruction, @x86_maskmovq { }

  class Maxpd extends Instruction, @x86_maxpd { }

  class Maxps extends Instruction, @x86_maxps { }

  class Maxsd extends Instruction, @x86_maxsd { }

  class Maxss extends Instruction, @x86_maxss { }

  class Mcommit extends Instruction, @x86_mcommit { }

  class Mfence extends Instruction, @x86_mfence { }

  class Minpd extends Instruction, @x86_minpd { }

  class Minps extends Instruction, @x86_minps { }

  class Minsd extends Instruction, @x86_minsd { }

  class Minss extends Instruction, @x86_minss { }

  class Monitor extends Instruction, @x86_monitor { }

  class Monitorx extends Instruction, @x86_monitorx { }

  class Montmul extends Instruction, @x86_montmul { }

  class Mov extends Instruction, @x86_mov { }

  class Movapd extends Instruction, @x86_movapd { }

  class Movaps extends Instruction, @x86_movaps { }

  class Movbe extends Instruction, @x86_movbe { }

  class Movd extends Instruction, @x86_movd { }

  class Movddup extends Instruction, @x86_movddup { }

  class Movdir64B extends Instruction, @x86_movdir64b { }

  class Movdiri extends Instruction, @x86_movdiri { }

  class Movdq2Q extends Instruction, @x86_movdq2q { }

  class Movdqa extends Instruction, @x86_movdqa { }

  class Movdqu extends Instruction, @x86_movdqu { }

  class Movhlps extends Instruction, @x86_movhlps { }

  class Movhpd extends Instruction, @x86_movhpd { }

  class Movhps extends Instruction, @x86_movhps { }

  class Movlhps extends Instruction, @x86_movlhps { }

  class Movlpd extends Instruction, @x86_movlpd { }

  class Movlps extends Instruction, @x86_movlps { }

  class Movmskpd extends Instruction, @x86_movmskpd { }

  class Movmskps extends Instruction, @x86_movmskps { }

  class Movntdq extends Instruction, @x86_movntdq { }

  class Movntdqa extends Instruction, @x86_movntdqa { }

  class Movnti extends Instruction, @x86_movnti { }

  class Movntpd extends Instruction, @x86_movntpd { }

  class Movntps extends Instruction, @x86_movntps { }

  class Movntq extends Instruction, @x86_movntq { }

  class Movntsd extends Instruction, @x86_movntsd { }

  class Movntss extends Instruction, @x86_movntss { }

  class Movq extends Instruction, @x86_movq { }

  class Movq2Dq extends Instruction, @x86_movq2dq { }

  class Movsb extends Instruction, @x86_movsb { }

  class Movsd extends Instruction, @x86_movsd { }

  class Movshdup extends Instruction, @x86_movshdup { }

  class Movsldup extends Instruction, @x86_movsldup { }

  class Movsq extends Instruction, @x86_movsq { }

  class Movss extends Instruction, @x86_movss { }

  class Movsw extends Instruction, @x86_movsw { }

  class Movsx extends Instruction, @x86_movsx { }

  class Movsxd extends Instruction, @x86_movsxd { }

  class Movupd extends Instruction, @x86_movupd { }

  class Movups extends Instruction, @x86_movups { }

  class Movzx extends Instruction, @x86_movzx { }

  class Mpsadbw extends Instruction, @x86_mpsadbw { }

  class Mul extends Instruction, @x86_mul { }

  class Mulpd extends Instruction, @x86_mulpd { }

  class Mulps extends Instruction, @x86_mulps { }

  class Mulsd extends Instruction, @x86_mulsd { }

  class Mulss extends Instruction, @x86_mulss { }

  class Mulx extends Instruction, @x86_mulx { }

  class Mwait extends Instruction, @x86_mwait { }

  class Mwaitx extends Instruction, @x86_mwaitx { }

  class Neg extends Instruction, @x86_neg { }

  class Nop extends Instruction, @x86_nop { }

  class Not extends Instruction, @x86_not { }

  class Or extends Instruction, @x86_or { }

  class Orpd extends Instruction, @x86_orpd { }

  class Orps extends Instruction, @x86_orps { }

  class Out extends Instruction, @x86_out { }

  class Outsb extends Instruction, @x86_outsb { }

  class Outsd extends Instruction, @x86_outsd { }

  class Outsw extends Instruction, @x86_outsw { }

  class Pabsb extends Instruction, @x86_pabsb { }

  class Pabsd extends Instruction, @x86_pabsd { }

  class Pabsw extends Instruction, @x86_pabsw { }

  class Packssdw extends Instruction, @x86_packssdw { }

  class Packsswb extends Instruction, @x86_packsswb { }

  class Packusdw extends Instruction, @x86_packusdw { }

  class Packuswb extends Instruction, @x86_packuswb { }

  class Paddb extends Instruction, @x86_paddb { }

  class Paddd extends Instruction, @x86_paddd { }

  class Paddq extends Instruction, @x86_paddq { }

  class Paddsb extends Instruction, @x86_paddsb { }

  class Paddsw extends Instruction, @x86_paddsw { }

  class Paddusb extends Instruction, @x86_paddusb { }

  class Paddusw extends Instruction, @x86_paddusw { }

  class Paddw extends Instruction, @x86_paddw { }

  class Palignr extends Instruction, @x86_palignr { }

  class Pand extends Instruction, @x86_pand { }

  class Pandn extends Instruction, @x86_pandn { }

  class Pause extends Instruction, @x86_pause { }

  class Pavgb extends Instruction, @x86_pavgb { }

  class Pavgusb extends Instruction, @x86_pavgusb { }

  class Pavgw extends Instruction, @x86_pavgw { }

  class Pblendvb extends Instruction, @x86_pblendvb { }

  class Pblendw extends Instruction, @x86_pblendw { }

  class Pbndkb extends Instruction, @x86_pbndkb { }

  class Pclmulqdq extends Instruction, @x86_pclmulqdq { }

  class Pcmpeqb extends Instruction, @x86_pcmpeqb { }

  class Pcmpeqd extends Instruction, @x86_pcmpeqd { }

  class Pcmpeqq extends Instruction, @x86_pcmpeqq { }

  class Pcmpeqw extends Instruction, @x86_pcmpeqw { }

  class Pcmpestri extends Instruction, @x86_pcmpestri { }

  class Pcmpestrm extends Instruction, @x86_pcmpestrm { }

  class Pcmpgtb extends Instruction, @x86_pcmpgtb { }

  class Pcmpgtd extends Instruction, @x86_pcmpgtd { }

  class Pcmpgtq extends Instruction, @x86_pcmpgtq { }

  class Pcmpgtw extends Instruction, @x86_pcmpgtw { }

  class Pcmpistri extends Instruction, @x86_pcmpistri { }

  class Pcmpistrm extends Instruction, @x86_pcmpistrm { }

  class Pcommit extends Instruction, @x86_pcommit { }

  class Pconfig extends Instruction, @x86_pconfig { }

  class Pdep extends Instruction, @x86_pdep { }

  class Pext extends Instruction, @x86_pext { }

  class Pextrb extends Instruction, @x86_pextrb { }

  class Pextrd extends Instruction, @x86_pextrd { }

  class Pextrq extends Instruction, @x86_pextrq { }

  class Pextrw extends Instruction, @x86_pextrw { }

  class Pf2Id extends Instruction, @x86_pf2id { }

  class Pf2Iw extends Instruction, @x86_pf2iw { }

  class Pfacc extends Instruction, @x86_pfacc { }

  class Pfadd extends Instruction, @x86_pfadd { }

  class Pfcmpeq extends Instruction, @x86_pfcmpeq { }

  class Pfcmpge extends Instruction, @x86_pfcmpge { }

  class Pfcmpgt extends Instruction, @x86_pfcmpgt { }

  class Pfcpit1 extends Instruction, @x86_pfcpit1 { }

  class Pfmax extends Instruction, @x86_pfmax { }

  class Pfmin extends Instruction, @x86_pfmin { }

  class Pfmul extends Instruction, @x86_pfmul { }

  class Pfnacc extends Instruction, @x86_pfnacc { }

  class Pfpnacc extends Instruction, @x86_pfpnacc { }

  class Pfrcp extends Instruction, @x86_pfrcp { }

  class Pfrcpit2 extends Instruction, @x86_pfrcpit2 { }

  class Pfrsqit1 extends Instruction, @x86_pfrsqit1 { }

  class Pfsqrt extends Instruction, @x86_pfsqrt { }

  class Pfsub extends Instruction, @x86_pfsub { }

  class Pfsubr extends Instruction, @x86_pfsubr { }

  class Phaddd extends Instruction, @x86_phaddd { }

  class Phaddsw extends Instruction, @x86_phaddsw { }

  class Phaddw extends Instruction, @x86_phaddw { }

  class Phminposuw extends Instruction, @x86_phminposuw { }

  class Phsubd extends Instruction, @x86_phsubd { }

  class Phsubsw extends Instruction, @x86_phsubsw { }

  class Phsubw extends Instruction, @x86_phsubw { }

  class Pi2Fd extends Instruction, @x86_pi2fd { }

  class Pi2Fw extends Instruction, @x86_pi2fw { }

  class Pinsrb extends Instruction, @x86_pinsrb { }

  class Pinsrd extends Instruction, @x86_pinsrd { }

  class Pinsrq extends Instruction, @x86_pinsrq { }

  class Pinsrw extends Instruction, @x86_pinsrw { }

  class Pmaddubsw extends Instruction, @x86_pmaddubsw { }

  class Pmaddwd extends Instruction, @x86_pmaddwd { }

  class Pmaxsb extends Instruction, @x86_pmaxsb { }

  class Pmaxsd extends Instruction, @x86_pmaxsd { }

  class Pmaxsw extends Instruction, @x86_pmaxsw { }

  class Pmaxub extends Instruction, @x86_pmaxub { }

  class Pmaxud extends Instruction, @x86_pmaxud { }

  class Pmaxuw extends Instruction, @x86_pmaxuw { }

  class Pminsb extends Instruction, @x86_pminsb { }

  class Pminsd extends Instruction, @x86_pminsd { }

  class Pminsw extends Instruction, @x86_pminsw { }

  class Pminub extends Instruction, @x86_pminub { }

  class Pminud extends Instruction, @x86_pminud { }

  class Pminuw extends Instruction, @x86_pminuw { }

  class Pmovmskb extends Instruction, @x86_pmovmskb { }

  class Pmovsxbd extends Instruction, @x86_pmovsxbd { }

  class Pmovsxbq extends Instruction, @x86_pmovsxbq { }

  class Pmovsxbw extends Instruction, @x86_pmovsxbw { }

  class Pmovsxdq extends Instruction, @x86_pmovsxdq { }

  class Pmovsxwd extends Instruction, @x86_pmovsxwd { }

  class Pmovsxwq extends Instruction, @x86_pmovsxwq { }

  class Pmovzxbd extends Instruction, @x86_pmovzxbd { }

  class Pmovzxbq extends Instruction, @x86_pmovzxbq { }

  class Pmovzxbw extends Instruction, @x86_pmovzxbw { }

  class Pmovzxdq extends Instruction, @x86_pmovzxdq { }

  class Pmovzxwd extends Instruction, @x86_pmovzxwd { }

  class Pmovzxwq extends Instruction, @x86_pmovzxwq { }

  class Pmuldq extends Instruction, @x86_pmuldq { }

  class Pmulhrsw extends Instruction, @x86_pmulhrsw { }

  class Pmulhrw extends Instruction, @x86_pmulhrw { }

  class Pmulhuw extends Instruction, @x86_pmulhuw { }

  class Pmulhw extends Instruction, @x86_pmulhw { }

  class Pmulld extends Instruction, @x86_pmulld { }

  class Pmullw extends Instruction, @x86_pmullw { }

  class Pmuludq extends Instruction, @x86_pmuludq { }

  class Pop extends Instruction, @x86_pop { }

  class Pop2 extends Instruction, @x86_pop2 { }

  class Pop2P extends Instruction, @x86_pop2p { }

  class Popa extends Instruction, @x86_popa { }

  class Popad extends Instruction, @x86_popad { }

  class Popcnt extends Instruction, @x86_popcnt { }

  class Popf extends Instruction, @x86_popf { }

  class Popfd extends Instruction, @x86_popfd { }

  class Popfq extends Instruction, @x86_popfq { }

  class Popp extends Instruction, @x86_popp { }

  class Por extends Instruction, @x86_por { }

  class Prefetch extends Instruction, @x86_prefetch { }

  class Prefetchit0 extends Instruction, @x86_prefetchit0 { }

  class Prefetchit1 extends Instruction, @x86_prefetchit1 { }

  class Prefetchnta extends Instruction, @x86_prefetchnta { }

  class Prefetcht0 extends Instruction, @x86_prefetcht0 { }

  class Prefetcht1 extends Instruction, @x86_prefetcht1 { }

  class Prefetcht2 extends Instruction, @x86_prefetcht2 { }

  class Prefetchw extends Instruction, @x86_prefetchw { }

  class Prefetchwt1 extends Instruction, @x86_prefetchwt1 { }

  class Psadbw extends Instruction, @x86_psadbw { }

  class Pshufb extends Instruction, @x86_pshufb { }

  class Pshufd extends Instruction, @x86_pshufd { }

  class Pshufhw extends Instruction, @x86_pshufhw { }

  class Pshuflw extends Instruction, @x86_pshuflw { }

  class Pshufw extends Instruction, @x86_pshufw { }

  class Psignb extends Instruction, @x86_psignb { }

  class Psignd extends Instruction, @x86_psignd { }

  class Psignw extends Instruction, @x86_psignw { }

  class Pslld extends Instruction, @x86_pslld { }

  class Pslldq extends Instruction, @x86_pslldq { }

  class Psllq extends Instruction, @x86_psllq { }

  class Psllw extends Instruction, @x86_psllw { }

  class Psmash extends Instruction, @x86_psmash { }

  class Psrad extends Instruction, @x86_psrad { }

  class Psraw extends Instruction, @x86_psraw { }

  class Psrld extends Instruction, @x86_psrld { }

  class Psrldq extends Instruction, @x86_psrldq { }

  class Psrlq extends Instruction, @x86_psrlq { }

  class Psrlw extends Instruction, @x86_psrlw { }

  class Psubb extends Instruction, @x86_psubb { }

  class Psubd extends Instruction, @x86_psubd { }

  class Psubq extends Instruction, @x86_psubq { }

  class Psubsb extends Instruction, @x86_psubsb { }

  class Psubsw extends Instruction, @x86_psubsw { }

  class Psubusb extends Instruction, @x86_psubusb { }

  class Psubusw extends Instruction, @x86_psubusw { }

  class Psubw extends Instruction, @x86_psubw { }

  class Pswapd extends Instruction, @x86_pswapd { }

  class Ptest extends Instruction, @x86_ptest { }

  class Ptwrite extends Instruction, @x86_ptwrite { }

  class Punpckhbw extends Instruction, @x86_punpckhbw { }

  class Punpckhdq extends Instruction, @x86_punpckhdq { }

  class Punpckhqdq extends Instruction, @x86_punpckhqdq { }

  class Punpckhwd extends Instruction, @x86_punpckhwd { }

  class Punpcklbw extends Instruction, @x86_punpcklbw { }

  class Punpckldq extends Instruction, @x86_punpckldq { }

  class Punpcklqdq extends Instruction, @x86_punpcklqdq { }

  class Punpcklwd extends Instruction, @x86_punpcklwd { }

  class Push extends Instruction, @x86_push { }

  class Push2 extends Instruction, @x86_push2 { }

  class Push2P extends Instruction, @x86_push2p { }

  class Pusha extends Instruction, @x86_pusha { }

  class Pushad extends Instruction, @x86_pushad { }

  class Pushf extends Instruction, @x86_pushf { }

  class Pushfd extends Instruction, @x86_pushfd { }

  class Pushfq extends Instruction, @x86_pushfq { }

  class Pushp extends Instruction, @x86_pushp { }

  class Pvalidate extends Instruction, @x86_pvalidate { }

  class Pxor extends Instruction, @x86_pxor { }

  class Rcl extends Instruction, @x86_rcl { }

  class Rcpps extends Instruction, @x86_rcpps { }

  class Rcpss extends Instruction, @x86_rcpss { }

  class Rcr extends Instruction, @x86_rcr { }

  class Rdfsbase extends Instruction, @x86_rdfsbase { }

  class Rdgsbase extends Instruction, @x86_rdgsbase { }

  class Rdmsr extends Instruction, @x86_rdmsr { }

  class Rdmsrlist extends Instruction, @x86_rdmsrlist { }

  class Rdpid extends Instruction, @x86_rdpid { }

  class Rdpkru extends Instruction, @x86_rdpkru { }

  class Rdpmc extends Instruction, @x86_rdpmc { }

  class Rdpru extends Instruction, @x86_rdpru { }

  class Rdrand extends Instruction, @x86_rdrand { }

  class Rdseed extends Instruction, @x86_rdseed { }

  class Rdsspd extends Instruction, @x86_rdsspd { }

  class Rdsspq extends Instruction, @x86_rdsspq { }

  class Rdtsc extends Instruction, @x86_rdtsc { }

  class Rdtscp extends Instruction, @x86_rdtscp { }

  class Ret extends Instruction, @x86_ret {
    override Instruction getASuccessor() { none() }
  }

  class Rmpadjust extends Instruction, @x86_rmpadjust { }

  class Rmpupdate extends Instruction, @x86_rmpupdate { }

  class Rol extends Instruction, @x86_rol { }

  class Ror extends Instruction, @x86_ror { }

  class Rorx extends Instruction, @x86_rorx { }

  class Roundpd extends Instruction, @x86_roundpd { }

  class Roundps extends Instruction, @x86_roundps { }

  class Roundsd extends Instruction, @x86_roundsd { }

  class Roundss extends Instruction, @x86_roundss { }

  class Rsm extends Instruction, @x86_rsm { }

  class Rsqrtps extends Instruction, @x86_rsqrtps { }

  class Rsqrtss extends Instruction, @x86_rsqrtss { }

  class Rstorssp extends Instruction, @x86_rstorssp { }

  class Sahf extends Instruction, @x86_sahf { }

  class Salc extends Instruction, @x86_salc { }

  class Sar extends Instruction, @x86_sar { }

  class Sarx extends Instruction, @x86_sarx { }

  class Saveprevssp extends Instruction, @x86_saveprevssp { }

  class Sbb extends Instruction, @x86_sbb { }

  class Scasb extends Instruction, @x86_scasb { }

  class Scasd extends Instruction, @x86_scasd { }

  class Scasq extends Instruction, @x86_scasq { }

  class Scasw extends Instruction, @x86_scasw { }

  class Seamcall extends Instruction, @x86_seamcall { }

  class Seamops extends Instruction, @x86_seamops { }

  class Seamret extends Instruction, @x86_seamret { }

  class Senduipi extends Instruction, @x86_senduipi { }

  class Serialize extends Instruction, @x86_serialize { }

  class Setb extends Instruction, @x86_setb { }

  class Setbe extends Instruction, @x86_setbe { }

  class Setl extends Instruction, @x86_setl { }

  class Setle extends Instruction, @x86_setle { }

  class Setnb extends Instruction, @x86_setnb { }

  class Setnbe extends Instruction, @x86_setnbe { }

  class Setnl extends Instruction, @x86_setnl { }

  class Setnle extends Instruction, @x86_setnle { }

  class Setno extends Instruction, @x86_setno { }

  class Setnp extends Instruction, @x86_setnp { }

  class Setns extends Instruction, @x86_setns { }

  class Setnz extends Instruction, @x86_setnz { }

  class Seto extends Instruction, @x86_seto { }

  class Setp extends Instruction, @x86_setp { }

  class Sets extends Instruction, @x86_sets { }

  class Setssbsy extends Instruction, @x86_setssbsy { }

  class Setz extends Instruction, @x86_setz { }

  class Setzub extends Instruction, @x86_setzub { }

  class Setzube extends Instruction, @x86_setzube { }

  class Setzul extends Instruction, @x86_setzul { }

  class Setzule extends Instruction, @x86_setzule { }

  class Setzunb extends Instruction, @x86_setzunb { }

  class Setzunbe extends Instruction, @x86_setzunbe { }

  class Setzunl extends Instruction, @x86_setzunl { }

  class Setzunle extends Instruction, @x86_setzunle { }

  class Setzuno extends Instruction, @x86_setzuno { }

  class Setzunp extends Instruction, @x86_setzunp { }

  class Setzuns extends Instruction, @x86_setzuns { }

  class Setzunz extends Instruction, @x86_setzunz { }

  class Setzuo extends Instruction, @x86_setzuo { }

  class Setzup extends Instruction, @x86_setzup { }

  class Setzus extends Instruction, @x86_setzus { }

  class Setzuz extends Instruction, @x86_setzuz { }

  class Sfence extends Instruction, @x86_sfence { }

  class Sgdt extends Instruction, @x86_sgdt { }

  class Sha1Msg1 extends Instruction, @x86_sha1msg1 { }

  class Sha1Msg2 extends Instruction, @x86_sha1msg2 { }

  class Sha1Nexte extends Instruction, @x86_sha1nexte { }

  class Sha1Rnds4 extends Instruction, @x86_sha1rnds4 { }

  class Sha256Msg1 extends Instruction, @x86_sha256msg1 { }

  class Sha256Msg2 extends Instruction, @x86_sha256msg2 { }

  class Sha256Rnds2 extends Instruction, @x86_sha256rnds2 { }

  class Shl extends Instruction, @x86_shl { }

  class Shld extends Instruction, @x86_shld { }

  class Shlx extends Instruction, @x86_shlx { }

  class Shr extends Instruction, @x86_shr { }

  class Shrd extends Instruction, @x86_shrd { }

  class Shrx extends Instruction, @x86_shrx { }

  class Shufpd extends Instruction, @x86_shufpd { }

  class Shufps extends Instruction, @x86_shufps { }

  class Sidt extends Instruction, @x86_sidt { }

  class Skinit extends Instruction, @x86_skinit { }

  class Sldt extends Instruction, @x86_sldt { }

  class Slwpcb extends Instruction, @x86_slwpcb { }

  class Smsw extends Instruction, @x86_smsw { }

  class Spflt extends Instruction, @x86_spflt { }

  class Sqrtpd extends Instruction, @x86_sqrtpd { }

  class Sqrtps extends Instruction, @x86_sqrtps { }

  class Sqrtsd extends Instruction, @x86_sqrtsd { }

  class Sqrtss extends Instruction, @x86_sqrtss { }

  class Stac extends Instruction, @x86_stac { }

  class Stc extends Instruction, @x86_stc { }

  class Std extends Instruction, @x86_std { }

  class Stgi extends Instruction, @x86_stgi { }

  class Sti extends Instruction, @x86_sti { }

  class Stmxcsr extends Instruction, @x86_stmxcsr { }

  class Stosb extends Instruction, @x86_stosb { }

  class Stosd extends Instruction, @x86_stosd { }

  class Stosq extends Instruction, @x86_stosq { }

  class Stosw extends Instruction, @x86_stosw { }

  class Str extends Instruction, @x86_str { }

  class Sttilecfg extends Instruction, @x86_sttilecfg { }

  class Stui extends Instruction, @x86_stui { }

  class Sub extends Instruction, @x86_sub { }

  class Subpd extends Instruction, @x86_subpd { }

  class Subps extends Instruction, @x86_subps { }

  class Subsd extends Instruction, @x86_subsd { }

  class Subss extends Instruction, @x86_subss { }

  class Swapgs extends Instruction, @x86_swapgs { }

  class Syscall extends Instruction, @x86_syscall { }

  class Sysenter extends Instruction, @x86_sysenter { }

  class Sysexit extends Instruction, @x86_sysexit { }

  class Sysret extends Instruction, @x86_sysret { }

  class T1Mskc extends Instruction, @x86_t1mskc { }

  class Tdcall extends Instruction, @x86_tdcall { }

  class Tdpbf16Ps extends Instruction, @x86_tdpbf16ps { }

  class Tdpbssd extends Instruction, @x86_tdpbssd { }

  class Tdpbsud extends Instruction, @x86_tdpbsud { }

  class Tdpbusd extends Instruction, @x86_tdpbusd { }

  class Tdpbuud extends Instruction, @x86_tdpbuud { }

  class Tdpfp16Ps extends Instruction, @x86_tdpfp16ps { }

  class Test extends Instruction, @x86_test { }

  class Testui extends Instruction, @x86_testui { }

  class Tileloadd extends Instruction, @x86_tileloadd { }

  class Tileloaddt1 extends Instruction, @x86_tileloaddt1 { }

  class Tilerelease extends Instruction, @x86_tilerelease { }

  class Tilestored extends Instruction, @x86_tilestored { }

  class Tilezero extends Instruction, @x86_tilezero { }

  class Tlbsync extends Instruction, @x86_tlbsync { }

  class Tpause extends Instruction, @x86_tpause { }

  class Tzcnt extends Instruction, @x86_tzcnt { }

  class Tzcnti extends Instruction, @x86_tzcnti { }

  class Tzmsk extends Instruction, @x86_tzmsk { }

  class Ucomisd extends Instruction, @x86_ucomisd { }

  class Ucomiss extends Instruction, @x86_ucomiss { }

  class Ud0 extends Instruction, @x86_ud0 { }

  class Ud1 extends Instruction, @x86_ud1 { }

  class Ud2 extends Instruction, @x86_ud2 { }

  class Uiret extends Instruction, @x86_uiret { }

  class Umonitor extends Instruction, @x86_umonitor { }

  class Umwait extends Instruction, @x86_umwait { }

  class Unpckhpd extends Instruction, @x86_unpckhpd { }

  class Unpckhps extends Instruction, @x86_unpckhps { }

  class Unpcklpd extends Instruction, @x86_unpcklpd { }

  class Unpcklps extends Instruction, @x86_unpcklps { }

  class Urdmsr extends Instruction, @x86_urdmsr { }

  class Uwrmsr extends Instruction, @x86_uwrmsr { }

  class V4Fmaddps extends Instruction, @x86_v4fmaddps { }

  class V4Fmaddss extends Instruction, @x86_v4fmaddss { }

  class V4Fnmaddps extends Instruction, @x86_v4fnmaddps { }

  class V4Fnmaddss extends Instruction, @x86_v4fnmaddss { }

  class Vaddnpd extends Instruction, @x86_vaddnpd { }

  class Vaddnps extends Instruction, @x86_vaddnps { }

  class Vaddpd extends Instruction, @x86_vaddpd { }

  class Vaddph extends Instruction, @x86_vaddph { }

  class Vaddps extends Instruction, @x86_vaddps { }

  class Vaddsd extends Instruction, @x86_vaddsd { }

  class Vaddsetsps extends Instruction, @x86_vaddsetsps { }

  class Vaddsh extends Instruction, @x86_vaddsh { }

  class Vaddss extends Instruction, @x86_vaddss { }

  class Vaddsubpd extends Instruction, @x86_vaddsubpd { }

  class Vaddsubps extends Instruction, @x86_vaddsubps { }

  class Vaesdec extends Instruction, @x86_vaesdec { }

  class Vaesdeclast extends Instruction, @x86_vaesdeclast { }

  class Vaesenc extends Instruction, @x86_vaesenc { }

  class Vaesenclast extends Instruction, @x86_vaesenclast { }

  class Vaesimc extends Instruction, @x86_vaesimc { }

  class Vaeskeygenassist extends Instruction, @x86_vaeskeygenassist { }

  class Valignd extends Instruction, @x86_valignd { }

  class Valignq extends Instruction, @x86_valignq { }

  class Vandnpd extends Instruction, @x86_vandnpd { }

  class Vandnps extends Instruction, @x86_vandnps { }

  class Vandpd extends Instruction, @x86_vandpd { }

  class Vandps extends Instruction, @x86_vandps { }

  class Vbcstnebf162Ps extends Instruction, @x86_vbcstnebf162ps { }

  class Vbcstnesh2Ps extends Instruction, @x86_vbcstnesh2ps { }

  class Vblendmpd extends Instruction, @x86_vblendmpd { }

  class Vblendmps extends Instruction, @x86_vblendmps { }

  class Vblendpd extends Instruction, @x86_vblendpd { }

  class Vblendps extends Instruction, @x86_vblendps { }

  class Vblendvpd extends Instruction, @x86_vblendvpd { }

  class Vblendvps extends Instruction, @x86_vblendvps { }

  class Vbroadcastf128 extends Instruction, @x86_vbroadcastf128 { }

  class Vbroadcastf32X2 extends Instruction, @x86_vbroadcastf32x2 { }

  class Vbroadcastf32X4 extends Instruction, @x86_vbroadcastf32x4 { }

  class Vbroadcastf32X8 extends Instruction, @x86_vbroadcastf32x8 { }

  class Vbroadcastf64X2 extends Instruction, @x86_vbroadcastf64x2 { }

  class Vbroadcastf64X4 extends Instruction, @x86_vbroadcastf64x4 { }

  class Vbroadcasti128 extends Instruction, @x86_vbroadcasti128 { }

  class Vbroadcasti32X2 extends Instruction, @x86_vbroadcasti32x2 { }

  class Vbroadcasti32X4 extends Instruction, @x86_vbroadcasti32x4 { }

  class Vbroadcasti32X8 extends Instruction, @x86_vbroadcasti32x8 { }

  class Vbroadcasti64X2 extends Instruction, @x86_vbroadcasti64x2 { }

  class Vbroadcasti64X4 extends Instruction, @x86_vbroadcasti64x4 { }

  class Vbroadcastsd extends Instruction, @x86_vbroadcastsd { }

  class Vbroadcastss extends Instruction, @x86_vbroadcastss { }

  class Vcmppd extends Instruction, @x86_vcmppd { }

  class Vcmpph extends Instruction, @x86_vcmpph { }

  class Vcmpps extends Instruction, @x86_vcmpps { }

  class Vcmpsd extends Instruction, @x86_vcmpsd { }

  class Vcmpsh extends Instruction, @x86_vcmpsh { }

  class Vcmpss extends Instruction, @x86_vcmpss { }

  class Vcomisd extends Instruction, @x86_vcomisd { }

  class Vcomish extends Instruction, @x86_vcomish { }

  class Vcomiss extends Instruction, @x86_vcomiss { }

  class Vcompresspd extends Instruction, @x86_vcompresspd { }

  class Vcompressps extends Instruction, @x86_vcompressps { }

  class Vcvtdq2Pd extends Instruction, @x86_vcvtdq2pd { }

  class Vcvtdq2Ph extends Instruction, @x86_vcvtdq2ph { }

  class Vcvtdq2Ps extends Instruction, @x86_vcvtdq2ps { }

  class Vcvtfxpntdq2Ps extends Instruction, @x86_vcvtfxpntdq2ps { }

  class Vcvtfxpntpd2Dq extends Instruction, @x86_vcvtfxpntpd2dq { }

  class Vcvtfxpntpd2Udq extends Instruction, @x86_vcvtfxpntpd2udq { }

  class Vcvtfxpntps2Dq extends Instruction, @x86_vcvtfxpntps2dq { }

  class Vcvtfxpntps2Udq extends Instruction, @x86_vcvtfxpntps2udq { }

  class Vcvtfxpntudq2Ps extends Instruction, @x86_vcvtfxpntudq2ps { }

  class Vcvtne2Ps2Bf16 extends Instruction, @x86_vcvtne2ps2bf16 { }

  class Vcvtneebf162Ps extends Instruction, @x86_vcvtneebf162ps { }

  class Vcvtneeph2Ps extends Instruction, @x86_vcvtneeph2ps { }

  class Vcvtneobf162Ps extends Instruction, @x86_vcvtneobf162ps { }

  class Vcvtneoph2Ps extends Instruction, @x86_vcvtneoph2ps { }

  class Vcvtneps2Bf16 extends Instruction, @x86_vcvtneps2bf16 { }

  class Vcvtpd2Dq extends Instruction, @x86_vcvtpd2dq { }

  class Vcvtpd2Ph extends Instruction, @x86_vcvtpd2ph { }

  class Vcvtpd2Ps extends Instruction, @x86_vcvtpd2ps { }

  class Vcvtpd2Qq extends Instruction, @x86_vcvtpd2qq { }

  class Vcvtpd2Udq extends Instruction, @x86_vcvtpd2udq { }

  class Vcvtpd2Uqq extends Instruction, @x86_vcvtpd2uqq { }

  class Vcvtph2Dq extends Instruction, @x86_vcvtph2dq { }

  class Vcvtph2Pd extends Instruction, @x86_vcvtph2pd { }

  class Vcvtph2Ps extends Instruction, @x86_vcvtph2ps { }

  class Vcvtph2Psx extends Instruction, @x86_vcvtph2psx { }

  class Vcvtph2Qq extends Instruction, @x86_vcvtph2qq { }

  class Vcvtph2Udq extends Instruction, @x86_vcvtph2udq { }

  class Vcvtph2Uqq extends Instruction, @x86_vcvtph2uqq { }

  class Vcvtph2Uw extends Instruction, @x86_vcvtph2uw { }

  class Vcvtph2W extends Instruction, @x86_vcvtph2w { }

  class Vcvtps2Dq extends Instruction, @x86_vcvtps2dq { }

  class Vcvtps2Pd extends Instruction, @x86_vcvtps2pd { }

  class Vcvtps2Ph extends Instruction, @x86_vcvtps2ph { }

  class Vcvtps2Phx extends Instruction, @x86_vcvtps2phx { }

  class Vcvtps2Qq extends Instruction, @x86_vcvtps2qq { }

  class Vcvtps2Udq extends Instruction, @x86_vcvtps2udq { }

  class Vcvtps2Uqq extends Instruction, @x86_vcvtps2uqq { }

  class Vcvtqq2Pd extends Instruction, @x86_vcvtqq2pd { }

  class Vcvtqq2Ph extends Instruction, @x86_vcvtqq2ph { }

  class Vcvtqq2Ps extends Instruction, @x86_vcvtqq2ps { }

  class Vcvtsd2Sh extends Instruction, @x86_vcvtsd2sh { }

  class Vcvtsd2Si extends Instruction, @x86_vcvtsd2si { }

  class Vcvtsd2Ss extends Instruction, @x86_vcvtsd2ss { }

  class Vcvtsd2Usi extends Instruction, @x86_vcvtsd2usi { }

  class Vcvtsh2Sd extends Instruction, @x86_vcvtsh2sd { }

  class Vcvtsh2Si extends Instruction, @x86_vcvtsh2si { }

  class Vcvtsh2Ss extends Instruction, @x86_vcvtsh2ss { }

  class Vcvtsh2Usi extends Instruction, @x86_vcvtsh2usi { }

  class Vcvtsi2Sd extends Instruction, @x86_vcvtsi2sd { }

  class Vcvtsi2Sh extends Instruction, @x86_vcvtsi2sh { }

  class Vcvtsi2Ss extends Instruction, @x86_vcvtsi2ss { }

  class Vcvtss2Sd extends Instruction, @x86_vcvtss2sd { }

  class Vcvtss2Sh extends Instruction, @x86_vcvtss2sh { }

  class Vcvtss2Si extends Instruction, @x86_vcvtss2si { }

  class Vcvtss2Usi extends Instruction, @x86_vcvtss2usi { }

  class Vcvttpd2Dq extends Instruction, @x86_vcvttpd2dq { }

  class Vcvttpd2Qq extends Instruction, @x86_vcvttpd2qq { }

  class Vcvttpd2Udq extends Instruction, @x86_vcvttpd2udq { }

  class Vcvttpd2Uqq extends Instruction, @x86_vcvttpd2uqq { }

  class Vcvttph2Dq extends Instruction, @x86_vcvttph2dq { }

  class Vcvttph2Qq extends Instruction, @x86_vcvttph2qq { }

  class Vcvttph2Udq extends Instruction, @x86_vcvttph2udq { }

  class Vcvttph2Uqq extends Instruction, @x86_vcvttph2uqq { }

  class Vcvttph2Uw extends Instruction, @x86_vcvttph2uw { }

  class Vcvttph2W extends Instruction, @x86_vcvttph2w { }

  class Vcvttps2Dq extends Instruction, @x86_vcvttps2dq { }

  class Vcvttps2Qq extends Instruction, @x86_vcvttps2qq { }

  class Vcvttps2Udq extends Instruction, @x86_vcvttps2udq { }

  class Vcvttps2Uqq extends Instruction, @x86_vcvttps2uqq { }

  class Vcvttsd2Si extends Instruction, @x86_vcvttsd2si { }

  class Vcvttsd2Usi extends Instruction, @x86_vcvttsd2usi { }

  class Vcvttsh2Si extends Instruction, @x86_vcvttsh2si { }

  class Vcvttsh2Usi extends Instruction, @x86_vcvttsh2usi { }

  class Vcvttss2Si extends Instruction, @x86_vcvttss2si { }

  class Vcvttss2Usi extends Instruction, @x86_vcvttss2usi { }

  class Vcvtudq2Pd extends Instruction, @x86_vcvtudq2pd { }

  class Vcvtudq2Ph extends Instruction, @x86_vcvtudq2ph { }

  class Vcvtudq2Ps extends Instruction, @x86_vcvtudq2ps { }

  class Vcvtuqq2Pd extends Instruction, @x86_vcvtuqq2pd { }

  class Vcvtuqq2Ph extends Instruction, @x86_vcvtuqq2ph { }

  class Vcvtuqq2Ps extends Instruction, @x86_vcvtuqq2ps { }

  class Vcvtusi2Sd extends Instruction, @x86_vcvtusi2sd { }

  class Vcvtusi2Sh extends Instruction, @x86_vcvtusi2sh { }

  class Vcvtusi2Ss extends Instruction, @x86_vcvtusi2ss { }

  class Vcvtuw2Ph extends Instruction, @x86_vcvtuw2ph { }

  class Vcvtw2Ph extends Instruction, @x86_vcvtw2ph { }

  class Vdbpsadbw extends Instruction, @x86_vdbpsadbw { }

  class Vdivpd extends Instruction, @x86_vdivpd { }

  class Vdivph extends Instruction, @x86_vdivph { }

  class Vdivps extends Instruction, @x86_vdivps { }

  class Vdivsd extends Instruction, @x86_vdivsd { }

  class Vdivsh extends Instruction, @x86_vdivsh { }

  class Vdivss extends Instruction, @x86_vdivss { }

  class Vdpbf16Ps extends Instruction, @x86_vdpbf16ps { }

  class Vdppd extends Instruction, @x86_vdppd { }

  class Vdpps extends Instruction, @x86_vdpps { }

  class Verr extends Instruction, @x86_verr { }

  class Verw extends Instruction, @x86_verw { }

  class Vexp223Ps extends Instruction, @x86_vexp223ps { }

  class Vexp2Pd extends Instruction, @x86_vexp2pd { }

  class Vexp2Ps extends Instruction, @x86_vexp2ps { }

  class Vexpandpd extends Instruction, @x86_vexpandpd { }

  class Vexpandps extends Instruction, @x86_vexpandps { }

  class Vextractf128 extends Instruction, @x86_vextractf128 { }

  class Vextractf32X4 extends Instruction, @x86_vextractf32x4 { }

  class Vextractf32X8 extends Instruction, @x86_vextractf32x8 { }

  class Vextractf64X2 extends Instruction, @x86_vextractf64x2 { }

  class Vextractf64X4 extends Instruction, @x86_vextractf64x4 { }

  class Vextracti128 extends Instruction, @x86_vextracti128 { }

  class Vextracti32X4 extends Instruction, @x86_vextracti32x4 { }

  class Vextracti32X8 extends Instruction, @x86_vextracti32x8 { }

  class Vextracti64X2 extends Instruction, @x86_vextracti64x2 { }

  class Vextracti64X4 extends Instruction, @x86_vextracti64x4 { }

  class Vextractps extends Instruction, @x86_vextractps { }

  class Vfcmaddcph extends Instruction, @x86_vfcmaddcph { }

  class Vfcmaddcsh extends Instruction, @x86_vfcmaddcsh { }

  class Vfcmulcph extends Instruction, @x86_vfcmulcph { }

  class Vfcmulcsh extends Instruction, @x86_vfcmulcsh { }

  class Vfixupimmpd extends Instruction, @x86_vfixupimmpd { }

  class Vfixupimmps extends Instruction, @x86_vfixupimmps { }

  class Vfixupimmsd extends Instruction, @x86_vfixupimmsd { }

  class Vfixupimmss extends Instruction, @x86_vfixupimmss { }

  class Vfixupnanpd extends Instruction, @x86_vfixupnanpd { }

  class Vfixupnanps extends Instruction, @x86_vfixupnanps { }

  class Vfmadd132Pd extends Instruction, @x86_vfmadd132pd { }

  class Vfmadd132Ph extends Instruction, @x86_vfmadd132ph { }

  class Vfmadd132Ps extends Instruction, @x86_vfmadd132ps { }

  class Vfmadd132Sd extends Instruction, @x86_vfmadd132sd { }

  class Vfmadd132Sh extends Instruction, @x86_vfmadd132sh { }

  class Vfmadd132Ss extends Instruction, @x86_vfmadd132ss { }

  class Vfmadd213Pd extends Instruction, @x86_vfmadd213pd { }

  class Vfmadd213Ph extends Instruction, @x86_vfmadd213ph { }

  class Vfmadd213Ps extends Instruction, @x86_vfmadd213ps { }

  class Vfmadd213Sd extends Instruction, @x86_vfmadd213sd { }

  class Vfmadd213Sh extends Instruction, @x86_vfmadd213sh { }

  class Vfmadd213Ss extends Instruction, @x86_vfmadd213ss { }

  class Vfmadd231Pd extends Instruction, @x86_vfmadd231pd { }

  class Vfmadd231Ph extends Instruction, @x86_vfmadd231ph { }

  class Vfmadd231Ps extends Instruction, @x86_vfmadd231ps { }

  class Vfmadd231Sd extends Instruction, @x86_vfmadd231sd { }

  class Vfmadd231Sh extends Instruction, @x86_vfmadd231sh { }

  class Vfmadd231Ss extends Instruction, @x86_vfmadd231ss { }

  class Vfmadd233Ps extends Instruction, @x86_vfmadd233ps { }

  class Vfmaddcph extends Instruction, @x86_vfmaddcph { }

  class Vfmaddcsh extends Instruction, @x86_vfmaddcsh { }

  class Vfmaddpd extends Instruction, @x86_vfmaddpd { }

  class Vfmaddps extends Instruction, @x86_vfmaddps { }

  class Vfmaddsd extends Instruction, @x86_vfmaddsd { }

  class Vfmaddss extends Instruction, @x86_vfmaddss { }

  class Vfmaddsub132Pd extends Instruction, @x86_vfmaddsub132pd { }

  class Vfmaddsub132Ph extends Instruction, @x86_vfmaddsub132ph { }

  class Vfmaddsub132Ps extends Instruction, @x86_vfmaddsub132ps { }

  class Vfmaddsub213Pd extends Instruction, @x86_vfmaddsub213pd { }

  class Vfmaddsub213Ph extends Instruction, @x86_vfmaddsub213ph { }

  class Vfmaddsub213Ps extends Instruction, @x86_vfmaddsub213ps { }

  class Vfmaddsub231Pd extends Instruction, @x86_vfmaddsub231pd { }

  class Vfmaddsub231Ph extends Instruction, @x86_vfmaddsub231ph { }

  class Vfmaddsub231Ps extends Instruction, @x86_vfmaddsub231ps { }

  class Vfmaddsubpd extends Instruction, @x86_vfmaddsubpd { }

  class Vfmaddsubps extends Instruction, @x86_vfmaddsubps { }

  class Vfmsub132Pd extends Instruction, @x86_vfmsub132pd { }

  class Vfmsub132Ph extends Instruction, @x86_vfmsub132ph { }

  class Vfmsub132Ps extends Instruction, @x86_vfmsub132ps { }

  class Vfmsub132Sd extends Instruction, @x86_vfmsub132sd { }

  class Vfmsub132Sh extends Instruction, @x86_vfmsub132sh { }

  class Vfmsub132Ss extends Instruction, @x86_vfmsub132ss { }

  class Vfmsub213Pd extends Instruction, @x86_vfmsub213pd { }

  class Vfmsub213Ph extends Instruction, @x86_vfmsub213ph { }

  class Vfmsub213Ps extends Instruction, @x86_vfmsub213ps { }

  class Vfmsub213Sd extends Instruction, @x86_vfmsub213sd { }

  class Vfmsub213Sh extends Instruction, @x86_vfmsub213sh { }

  class Vfmsub213Ss extends Instruction, @x86_vfmsub213ss { }

  class Vfmsub231Pd extends Instruction, @x86_vfmsub231pd { }

  class Vfmsub231Ph extends Instruction, @x86_vfmsub231ph { }

  class Vfmsub231Ps extends Instruction, @x86_vfmsub231ps { }

  class Vfmsub231Sd extends Instruction, @x86_vfmsub231sd { }

  class Vfmsub231Sh extends Instruction, @x86_vfmsub231sh { }

  class Vfmsub231Ss extends Instruction, @x86_vfmsub231ss { }

  class Vfmsubadd132Pd extends Instruction, @x86_vfmsubadd132pd { }

  class Vfmsubadd132Ph extends Instruction, @x86_vfmsubadd132ph { }

  class Vfmsubadd132Ps extends Instruction, @x86_vfmsubadd132ps { }

  class Vfmsubadd213Pd extends Instruction, @x86_vfmsubadd213pd { }

  class Vfmsubadd213Ph extends Instruction, @x86_vfmsubadd213ph { }

  class Vfmsubadd213Ps extends Instruction, @x86_vfmsubadd213ps { }

  class Vfmsubadd231Pd extends Instruction, @x86_vfmsubadd231pd { }

  class Vfmsubadd231Ph extends Instruction, @x86_vfmsubadd231ph { }

  class Vfmsubadd231Ps extends Instruction, @x86_vfmsubadd231ps { }

  class Vfmsubaddpd extends Instruction, @x86_vfmsubaddpd { }

  class Vfmsubaddps extends Instruction, @x86_vfmsubaddps { }

  class Vfmsubpd extends Instruction, @x86_vfmsubpd { }

  class Vfmsubps extends Instruction, @x86_vfmsubps { }

  class Vfmsubsd extends Instruction, @x86_vfmsubsd { }

  class Vfmsubss extends Instruction, @x86_vfmsubss { }

  class Vfmulcph extends Instruction, @x86_vfmulcph { }

  class Vfmulcsh extends Instruction, @x86_vfmulcsh { }

  class Vfnmadd132Pd extends Instruction, @x86_vfnmadd132pd { }

  class Vfnmadd132Ph extends Instruction, @x86_vfnmadd132ph { }

  class Vfnmadd132Ps extends Instruction, @x86_vfnmadd132ps { }

  class Vfnmadd132Sd extends Instruction, @x86_vfnmadd132sd { }

  class Vfnmadd132Sh extends Instruction, @x86_vfnmadd132sh { }

  class Vfnmadd132Ss extends Instruction, @x86_vfnmadd132ss { }

  class Vfnmadd213Pd extends Instruction, @x86_vfnmadd213pd { }

  class Vfnmadd213Ph extends Instruction, @x86_vfnmadd213ph { }

  class Vfnmadd213Ps extends Instruction, @x86_vfnmadd213ps { }

  class Vfnmadd213Sd extends Instruction, @x86_vfnmadd213sd { }

  class Vfnmadd213Sh extends Instruction, @x86_vfnmadd213sh { }

  class Vfnmadd213Ss extends Instruction, @x86_vfnmadd213ss { }

  class Vfnmadd231Pd extends Instruction, @x86_vfnmadd231pd { }

  class Vfnmadd231Ph extends Instruction, @x86_vfnmadd231ph { }

  class Vfnmadd231Ps extends Instruction, @x86_vfnmadd231ps { }

  class Vfnmadd231Sd extends Instruction, @x86_vfnmadd231sd { }

  class Vfnmadd231Sh extends Instruction, @x86_vfnmadd231sh { }

  class Vfnmadd231Ss extends Instruction, @x86_vfnmadd231ss { }

  class Vfnmaddpd extends Instruction, @x86_vfnmaddpd { }

  class Vfnmaddps extends Instruction, @x86_vfnmaddps { }

  class Vfnmaddsd extends Instruction, @x86_vfnmaddsd { }

  class Vfnmaddss extends Instruction, @x86_vfnmaddss { }

  class Vfnmsub132Pd extends Instruction, @x86_vfnmsub132pd { }

  class Vfnmsub132Ph extends Instruction, @x86_vfnmsub132ph { }

  class Vfnmsub132Ps extends Instruction, @x86_vfnmsub132ps { }

  class Vfnmsub132Sd extends Instruction, @x86_vfnmsub132sd { }

  class Vfnmsub132Sh extends Instruction, @x86_vfnmsub132sh { }

  class Vfnmsub132Ss extends Instruction, @x86_vfnmsub132ss { }

  class Vfnmsub213Pd extends Instruction, @x86_vfnmsub213pd { }

  class Vfnmsub213Ph extends Instruction, @x86_vfnmsub213ph { }

  class Vfnmsub213Ps extends Instruction, @x86_vfnmsub213ps { }

  class Vfnmsub213Sd extends Instruction, @x86_vfnmsub213sd { }

  class Vfnmsub213Sh extends Instruction, @x86_vfnmsub213sh { }

  class Vfnmsub213Ss extends Instruction, @x86_vfnmsub213ss { }

  class Vfnmsub231Pd extends Instruction, @x86_vfnmsub231pd { }

  class Vfnmsub231Ph extends Instruction, @x86_vfnmsub231ph { }

  class Vfnmsub231Ps extends Instruction, @x86_vfnmsub231ps { }

  class Vfnmsub231Sd extends Instruction, @x86_vfnmsub231sd { }

  class Vfnmsub231Sh extends Instruction, @x86_vfnmsub231sh { }

  class Vfnmsub231Ss extends Instruction, @x86_vfnmsub231ss { }

  class Vfnmsubpd extends Instruction, @x86_vfnmsubpd { }

  class Vfnmsubps extends Instruction, @x86_vfnmsubps { }

  class Vfnmsubsd extends Instruction, @x86_vfnmsubsd { }

  class Vfnmsubss extends Instruction, @x86_vfnmsubss { }

  class Vfpclasspd extends Instruction, @x86_vfpclasspd { }

  class Vfpclassph extends Instruction, @x86_vfpclassph { }

  class Vfpclassps extends Instruction, @x86_vfpclassps { }

  class Vfpclasssd extends Instruction, @x86_vfpclasssd { }

  class Vfpclasssh extends Instruction, @x86_vfpclasssh { }

  class Vfpclassss extends Instruction, @x86_vfpclassss { }

  class Vfrczpd extends Instruction, @x86_vfrczpd { }

  class Vfrczps extends Instruction, @x86_vfrczps { }

  class Vfrczsd extends Instruction, @x86_vfrczsd { }

  class Vfrczss extends Instruction, @x86_vfrczss { }

  class Vgatherdpd extends Instruction, @x86_vgatherdpd { }

  class Vgatherdps extends Instruction, @x86_vgatherdps { }

  class Vgatherpf0Dpd extends Instruction, @x86_vgatherpf0dpd { }

  class Vgatherpf0Dps extends Instruction, @x86_vgatherpf0dps { }

  class Vgatherpf0Hintdpd extends Instruction, @x86_vgatherpf0hintdpd { }

  class Vgatherpf0Hintdps extends Instruction, @x86_vgatherpf0hintdps { }

  class Vgatherpf0Qpd extends Instruction, @x86_vgatherpf0qpd { }

  class Vgatherpf0Qps extends Instruction, @x86_vgatherpf0qps { }

  class Vgatherpf1Dpd extends Instruction, @x86_vgatherpf1dpd { }

  class Vgatherpf1Dps extends Instruction, @x86_vgatherpf1dps { }

  class Vgatherpf1Qpd extends Instruction, @x86_vgatherpf1qpd { }

  class Vgatherpf1Qps extends Instruction, @x86_vgatherpf1qps { }

  class Vgatherqpd extends Instruction, @x86_vgatherqpd { }

  class Vgatherqps extends Instruction, @x86_vgatherqps { }

  class Vgetexppd extends Instruction, @x86_vgetexppd { }

  class Vgetexpph extends Instruction, @x86_vgetexpph { }

  class Vgetexpps extends Instruction, @x86_vgetexpps { }

  class Vgetexpsd extends Instruction, @x86_vgetexpsd { }

  class Vgetexpsh extends Instruction, @x86_vgetexpsh { }

  class Vgetexpss extends Instruction, @x86_vgetexpss { }

  class Vgetmantpd extends Instruction, @x86_vgetmantpd { }

  class Vgetmantph extends Instruction, @x86_vgetmantph { }

  class Vgetmantps extends Instruction, @x86_vgetmantps { }

  class Vgetmantsd extends Instruction, @x86_vgetmantsd { }

  class Vgetmantsh extends Instruction, @x86_vgetmantsh { }

  class Vgetmantss extends Instruction, @x86_vgetmantss { }

  class Vgf2P8Affineinvqb extends Instruction, @x86_vgf2p8affineinvqb { }

  class Vgf2P8Affineqb extends Instruction, @x86_vgf2p8affineqb { }

  class Vgf2P8Mulb extends Instruction, @x86_vgf2p8mulb { }

  class Vgmaxabsps extends Instruction, @x86_vgmaxabsps { }

  class Vgmaxpd extends Instruction, @x86_vgmaxpd { }

  class Vgmaxps extends Instruction, @x86_vgmaxps { }

  class Vgminpd extends Instruction, @x86_vgminpd { }

  class Vgminps extends Instruction, @x86_vgminps { }

  class Vhaddpd extends Instruction, @x86_vhaddpd { }

  class Vhaddps extends Instruction, @x86_vhaddps { }

  class Vhsubpd extends Instruction, @x86_vhsubpd { }

  class Vhsubps extends Instruction, @x86_vhsubps { }

  class Vinsertf128 extends Instruction, @x86_vinsertf128 { }

  class Vinsertf32X4 extends Instruction, @x86_vinsertf32x4 { }

  class Vinsertf32X8 extends Instruction, @x86_vinsertf32x8 { }

  class Vinsertf64X2 extends Instruction, @x86_vinsertf64x2 { }

  class Vinsertf64X4 extends Instruction, @x86_vinsertf64x4 { }

  class Vinserti128 extends Instruction, @x86_vinserti128 { }

  class Vinserti32X4 extends Instruction, @x86_vinserti32x4 { }

  class Vinserti32X8 extends Instruction, @x86_vinserti32x8 { }

  class Vinserti64X2 extends Instruction, @x86_vinserti64x2 { }

  class Vinserti64X4 extends Instruction, @x86_vinserti64x4 { }

  class Vinsertps extends Instruction, @x86_vinsertps { }

  class Vlddqu extends Instruction, @x86_vlddqu { }

  class Vldmxcsr extends Instruction, @x86_vldmxcsr { }

  class Vloadunpackhd extends Instruction, @x86_vloadunpackhd { }

  class Vloadunpackhpd extends Instruction, @x86_vloadunpackhpd { }

  class Vloadunpackhps extends Instruction, @x86_vloadunpackhps { }

  class Vloadunpackhq extends Instruction, @x86_vloadunpackhq { }

  class Vloadunpackld extends Instruction, @x86_vloadunpackld { }

  class Vloadunpacklpd extends Instruction, @x86_vloadunpacklpd { }

  class Vloadunpacklps extends Instruction, @x86_vloadunpacklps { }

  class Vloadunpacklq extends Instruction, @x86_vloadunpacklq { }

  class Vlog2Ps extends Instruction, @x86_vlog2ps { }

  class Vmaskmovdqu extends Instruction, @x86_vmaskmovdqu { }

  class Vmaskmovpd extends Instruction, @x86_vmaskmovpd { }

  class Vmaskmovps extends Instruction, @x86_vmaskmovps { }

  class Vmaxpd extends Instruction, @x86_vmaxpd { }

  class Vmaxph extends Instruction, @x86_vmaxph { }

  class Vmaxps extends Instruction, @x86_vmaxps { }

  class Vmaxsd extends Instruction, @x86_vmaxsd { }

  class Vmaxsh extends Instruction, @x86_vmaxsh { }

  class Vmaxss extends Instruction, @x86_vmaxss { }

  class Vmcall extends Instruction, @x86_vmcall { }

  class Vmclear extends Instruction, @x86_vmclear { }

  class Vmfunc extends Instruction, @x86_vmfunc { }

  class Vminpd extends Instruction, @x86_vminpd { }

  class Vminph extends Instruction, @x86_vminph { }

  class Vminps extends Instruction, @x86_vminps { }

  class Vminsd extends Instruction, @x86_vminsd { }

  class Vminsh extends Instruction, @x86_vminsh { }

  class Vminss extends Instruction, @x86_vminss { }

  class Vmlaunch extends Instruction, @x86_vmlaunch { }

  class Vmload extends Instruction, @x86_vmload { }

  class Vmmcall extends Instruction, @x86_vmmcall { }

  class Vmovapd extends Instruction, @x86_vmovapd { }

  class Vmovaps extends Instruction, @x86_vmovaps { }

  class Vmovd extends Instruction, @x86_vmovd { }

  class Vmovddup extends Instruction, @x86_vmovddup { }

  class Vmovdqa extends Instruction, @x86_vmovdqa { }

  class Vmovdqa32 extends Instruction, @x86_vmovdqa32 { }

  class Vmovdqa64 extends Instruction, @x86_vmovdqa64 { }

  class Vmovdqu extends Instruction, @x86_vmovdqu { }

  class Vmovdqu16 extends Instruction, @x86_vmovdqu16 { }

  class Vmovdqu32 extends Instruction, @x86_vmovdqu32 { }

  class Vmovdqu64 extends Instruction, @x86_vmovdqu64 { }

  class Vmovdqu8 extends Instruction, @x86_vmovdqu8 { }

  class Vmovhlps extends Instruction, @x86_vmovhlps { }

  class Vmovhpd extends Instruction, @x86_vmovhpd { }

  class Vmovhps extends Instruction, @x86_vmovhps { }

  class Vmovlhps extends Instruction, @x86_vmovlhps { }

  class Vmovlpd extends Instruction, @x86_vmovlpd { }

  class Vmovlps extends Instruction, @x86_vmovlps { }

  class Vmovmskpd extends Instruction, @x86_vmovmskpd { }

  class Vmovmskps extends Instruction, @x86_vmovmskps { }

  class Vmovnrapd extends Instruction, @x86_vmovnrapd { }

  class Vmovnraps extends Instruction, @x86_vmovnraps { }

  class Vmovnrngoapd extends Instruction, @x86_vmovnrngoapd { }

  class Vmovnrngoaps extends Instruction, @x86_vmovnrngoaps { }

  class Vmovntdq extends Instruction, @x86_vmovntdq { }

  class Vmovntdqa extends Instruction, @x86_vmovntdqa { }

  class Vmovntpd extends Instruction, @x86_vmovntpd { }

  class Vmovntps extends Instruction, @x86_vmovntps { }

  class Vmovq extends Instruction, @x86_vmovq { }

  class Vmovsd extends Instruction, @x86_vmovsd { }

  class Vmovsh extends Instruction, @x86_vmovsh { }

  class Vmovshdup extends Instruction, @x86_vmovshdup { }

  class Vmovsldup extends Instruction, @x86_vmovsldup { }

  class Vmovss extends Instruction, @x86_vmovss { }

  class Vmovupd extends Instruction, @x86_vmovupd { }

  class Vmovups extends Instruction, @x86_vmovups { }

  class Vmovw extends Instruction, @x86_vmovw { }

  class Vmpsadbw extends Instruction, @x86_vmpsadbw { }

  class Vmptrld extends Instruction, @x86_vmptrld { }

  class Vmptrst extends Instruction, @x86_vmptrst { }

  class Vmread extends Instruction, @x86_vmread { }

  class Vmresume extends Instruction, @x86_vmresume { }

  class Vmrun extends Instruction, @x86_vmrun { }

  class Vmsave extends Instruction, @x86_vmsave { }

  class Vmulpd extends Instruction, @x86_vmulpd { }

  class Vmulph extends Instruction, @x86_vmulph { }

  class Vmulps extends Instruction, @x86_vmulps { }

  class Vmulsd extends Instruction, @x86_vmulsd { }

  class Vmulsh extends Instruction, @x86_vmulsh { }

  class Vmulss extends Instruction, @x86_vmulss { }

  class Vmwrite extends Instruction, @x86_vmwrite { }

  class Vmxoff extends Instruction, @x86_vmxoff { }

  class Vmxon extends Instruction, @x86_vmxon { }

  class Vorpd extends Instruction, @x86_vorpd { }

  class Vorps extends Instruction, @x86_vorps { }

  class Vp2Intersectd extends Instruction, @x86_vp2intersectd { }

  class Vp2Intersectq extends Instruction, @x86_vp2intersectq { }

  class Vp4Dpwssd extends Instruction, @x86_vp4dpwssd { }

  class Vp4Dpwssds extends Instruction, @x86_vp4dpwssds { }

  class Vpabsb extends Instruction, @x86_vpabsb { }

  class Vpabsd extends Instruction, @x86_vpabsd { }

  class Vpabsq extends Instruction, @x86_vpabsq { }

  class Vpabsw extends Instruction, @x86_vpabsw { }

  class Vpackssdw extends Instruction, @x86_vpackssdw { }

  class Vpacksswb extends Instruction, @x86_vpacksswb { }

  class Vpackstorehd extends Instruction, @x86_vpackstorehd { }

  class Vpackstorehpd extends Instruction, @x86_vpackstorehpd { }

  class Vpackstorehps extends Instruction, @x86_vpackstorehps { }

  class Vpackstorehq extends Instruction, @x86_vpackstorehq { }

  class Vpackstoreld extends Instruction, @x86_vpackstoreld { }

  class Vpackstorelpd extends Instruction, @x86_vpackstorelpd { }

  class Vpackstorelps extends Instruction, @x86_vpackstorelps { }

  class Vpackstorelq extends Instruction, @x86_vpackstorelq { }

  class Vpackusdw extends Instruction, @x86_vpackusdw { }

  class Vpackuswb extends Instruction, @x86_vpackuswb { }

  class Vpadcd extends Instruction, @x86_vpadcd { }

  class Vpaddb extends Instruction, @x86_vpaddb { }

  class Vpaddd extends Instruction, @x86_vpaddd { }

  class Vpaddq extends Instruction, @x86_vpaddq { }

  class Vpaddsb extends Instruction, @x86_vpaddsb { }

  class Vpaddsetcd extends Instruction, @x86_vpaddsetcd { }

  class Vpaddsetsd extends Instruction, @x86_vpaddsetsd { }

  class Vpaddsw extends Instruction, @x86_vpaddsw { }

  class Vpaddusb extends Instruction, @x86_vpaddusb { }

  class Vpaddusw extends Instruction, @x86_vpaddusw { }

  class Vpaddw extends Instruction, @x86_vpaddw { }

  class Vpalignr extends Instruction, @x86_vpalignr { }

  class Vpand extends Instruction, @x86_vpand { }

  class Vpandd extends Instruction, @x86_vpandd { }

  class Vpandn extends Instruction, @x86_vpandn { }

  class Vpandnd extends Instruction, @x86_vpandnd { }

  class Vpandnq extends Instruction, @x86_vpandnq { }

  class Vpandq extends Instruction, @x86_vpandq { }

  class Vpavgb extends Instruction, @x86_vpavgb { }

  class Vpavgw extends Instruction, @x86_vpavgw { }

  class Vpblendd extends Instruction, @x86_vpblendd { }

  class Vpblendmb extends Instruction, @x86_vpblendmb { }

  class Vpblendmd extends Instruction, @x86_vpblendmd { }

  class Vpblendmq extends Instruction, @x86_vpblendmq { }

  class Vpblendmw extends Instruction, @x86_vpblendmw { }

  class Vpblendvb extends Instruction, @x86_vpblendvb { }

  class Vpblendw extends Instruction, @x86_vpblendw { }

  class Vpbroadcastb extends Instruction, @x86_vpbroadcastb { }

  class Vpbroadcastd extends Instruction, @x86_vpbroadcastd { }

  class Vpbroadcastmb2Q extends Instruction, @x86_vpbroadcastmb2q { }

  class Vpbroadcastmw2D extends Instruction, @x86_vpbroadcastmw2d { }

  class Vpbroadcastq extends Instruction, @x86_vpbroadcastq { }

  class Vpbroadcastw extends Instruction, @x86_vpbroadcastw { }

  class Vpclmulqdq extends Instruction, @x86_vpclmulqdq { }

  class Vpcmov extends Instruction, @x86_vpcmov { }

  class Vpcmpb extends Instruction, @x86_vpcmpb { }

  class Vpcmpd extends Instruction, @x86_vpcmpd { }

  class Vpcmpeqb extends Instruction, @x86_vpcmpeqb { }

  class Vpcmpeqd extends Instruction, @x86_vpcmpeqd { }

  class Vpcmpeqq extends Instruction, @x86_vpcmpeqq { }

  class Vpcmpeqw extends Instruction, @x86_vpcmpeqw { }

  class Vpcmpestri extends Instruction, @x86_vpcmpestri { }

  class Vpcmpestrm extends Instruction, @x86_vpcmpestrm { }

  class Vpcmpgtb extends Instruction, @x86_vpcmpgtb { }

  class Vpcmpgtd extends Instruction, @x86_vpcmpgtd { }

  class Vpcmpgtq extends Instruction, @x86_vpcmpgtq { }

  class Vpcmpgtw extends Instruction, @x86_vpcmpgtw { }

  class Vpcmpistri extends Instruction, @x86_vpcmpistri { }

  class Vpcmpistrm extends Instruction, @x86_vpcmpistrm { }

  class Vpcmpltd extends Instruction, @x86_vpcmpltd { }

  class Vpcmpq extends Instruction, @x86_vpcmpq { }

  class Vpcmpub extends Instruction, @x86_vpcmpub { }

  class Vpcmpud extends Instruction, @x86_vpcmpud { }

  class Vpcmpuq extends Instruction, @x86_vpcmpuq { }

  class Vpcmpuw extends Instruction, @x86_vpcmpuw { }

  class Vpcmpw extends Instruction, @x86_vpcmpw { }

  class Vpcomb extends Instruction, @x86_vpcomb { }

  class Vpcomd extends Instruction, @x86_vpcomd { }

  class Vpcompressb extends Instruction, @x86_vpcompressb { }

  class Vpcompressd extends Instruction, @x86_vpcompressd { }

  class Vpcompressq extends Instruction, @x86_vpcompressq { }

  class Vpcompressw extends Instruction, @x86_vpcompressw { }

  class Vpcomq extends Instruction, @x86_vpcomq { }

  class Vpcomub extends Instruction, @x86_vpcomub { }

  class Vpcomud extends Instruction, @x86_vpcomud { }

  class Vpcomuq extends Instruction, @x86_vpcomuq { }

  class Vpcomuw extends Instruction, @x86_vpcomuw { }

  class Vpcomw extends Instruction, @x86_vpcomw { }

  class Vpconflictd extends Instruction, @x86_vpconflictd { }

  class Vpconflictq extends Instruction, @x86_vpconflictq { }

  class Vpdpbssd extends Instruction, @x86_vpdpbssd { }

  class Vpdpbssds extends Instruction, @x86_vpdpbssds { }

  class Vpdpbsud extends Instruction, @x86_vpdpbsud { }

  class Vpdpbsuds extends Instruction, @x86_vpdpbsuds { }

  class Vpdpbusd extends Instruction, @x86_vpdpbusd { }

  class Vpdpbusds extends Instruction, @x86_vpdpbusds { }

  class Vpdpbuud extends Instruction, @x86_vpdpbuud { }

  class Vpdpbuuds extends Instruction, @x86_vpdpbuuds { }

  class Vpdpwssd extends Instruction, @x86_vpdpwssd { }

  class Vpdpwssds extends Instruction, @x86_vpdpwssds { }

  class Vpdpwsud extends Instruction, @x86_vpdpwsud { }

  class Vpdpwsuds extends Instruction, @x86_vpdpwsuds { }

  class Vpdpwusd extends Instruction, @x86_vpdpwusd { }

  class Vpdpwusds extends Instruction, @x86_vpdpwusds { }

  class Vpdpwuud extends Instruction, @x86_vpdpwuud { }

  class Vpdpwuuds extends Instruction, @x86_vpdpwuuds { }

  class Vperm2F128 extends Instruction, @x86_vperm2f128 { }

  class Vperm2I128 extends Instruction, @x86_vperm2i128 { }

  class Vpermb extends Instruction, @x86_vpermb { }

  class Vpermd extends Instruction, @x86_vpermd { }

  class Vpermf32X4 extends Instruction, @x86_vpermf32x4 { }

  class Vpermi2B extends Instruction, @x86_vpermi2b { }

  class Vpermi2D extends Instruction, @x86_vpermi2d { }

  class Vpermi2Pd extends Instruction, @x86_vpermi2pd { }

  class Vpermi2Ps extends Instruction, @x86_vpermi2ps { }

  class Vpermi2Q extends Instruction, @x86_vpermi2q { }

  class Vpermi2W extends Instruction, @x86_vpermi2w { }

  class Vpermil2Pd extends Instruction, @x86_vpermil2pd { }

  class Vpermil2Ps extends Instruction, @x86_vpermil2ps { }

  class Vpermilpd extends Instruction, @x86_vpermilpd { }

  class Vpermilps extends Instruction, @x86_vpermilps { }

  class Vpermpd extends Instruction, @x86_vpermpd { }

  class Vpermps extends Instruction, @x86_vpermps { }

  class Vpermq extends Instruction, @x86_vpermq { }

  class Vpermt2B extends Instruction, @x86_vpermt2b { }

  class Vpermt2D extends Instruction, @x86_vpermt2d { }

  class Vpermt2Pd extends Instruction, @x86_vpermt2pd { }

  class Vpermt2Ps extends Instruction, @x86_vpermt2ps { }

  class Vpermt2Q extends Instruction, @x86_vpermt2q { }

  class Vpermt2W extends Instruction, @x86_vpermt2w { }

  class Vpermw extends Instruction, @x86_vpermw { }

  class Vpexpandb extends Instruction, @x86_vpexpandb { }

  class Vpexpandd extends Instruction, @x86_vpexpandd { }

  class Vpexpandq extends Instruction, @x86_vpexpandq { }

  class Vpexpandw extends Instruction, @x86_vpexpandw { }

  class Vpextrb extends Instruction, @x86_vpextrb { }

  class Vpextrd extends Instruction, @x86_vpextrd { }

  class Vpextrq extends Instruction, @x86_vpextrq { }

  class Vpextrw extends Instruction, @x86_vpextrw { }

  class Vpgatherdd extends Instruction, @x86_vpgatherdd { }

  class Vpgatherdq extends Instruction, @x86_vpgatherdq { }

  class Vpgatherqd extends Instruction, @x86_vpgatherqd { }

  class Vpgatherqq extends Instruction, @x86_vpgatherqq { }

  class Vphaddbd extends Instruction, @x86_vphaddbd { }

  class Vphaddbq extends Instruction, @x86_vphaddbq { }

  class Vphaddbw extends Instruction, @x86_vphaddbw { }

  class Vphaddd extends Instruction, @x86_vphaddd { }

  class Vphadddq extends Instruction, @x86_vphadddq { }

  class Vphaddsw extends Instruction, @x86_vphaddsw { }

  class Vphaddubd extends Instruction, @x86_vphaddubd { }

  class Vphaddubq extends Instruction, @x86_vphaddubq { }

  class Vphaddubw extends Instruction, @x86_vphaddubw { }

  class Vphaddudq extends Instruction, @x86_vphaddudq { }

  class Vphadduwd extends Instruction, @x86_vphadduwd { }

  class Vphadduwq extends Instruction, @x86_vphadduwq { }

  class Vphaddw extends Instruction, @x86_vphaddw { }

  class Vphaddwd extends Instruction, @x86_vphaddwd { }

  class Vphaddwq extends Instruction, @x86_vphaddwq { }

  class Vphminposuw extends Instruction, @x86_vphminposuw { }

  class Vphsubbw extends Instruction, @x86_vphsubbw { }

  class Vphsubd extends Instruction, @x86_vphsubd { }

  class Vphsubdq extends Instruction, @x86_vphsubdq { }

  class Vphsubsw extends Instruction, @x86_vphsubsw { }

  class Vphsubw extends Instruction, @x86_vphsubw { }

  class Vphsubwd extends Instruction, @x86_vphsubwd { }

  class Vpinsrb extends Instruction, @x86_vpinsrb { }

  class Vpinsrd extends Instruction, @x86_vpinsrd { }

  class Vpinsrq extends Instruction, @x86_vpinsrq { }

  class Vpinsrw extends Instruction, @x86_vpinsrw { }

  class Vplzcntd extends Instruction, @x86_vplzcntd { }

  class Vplzcntq extends Instruction, @x86_vplzcntq { }

  class Vpmacsdd extends Instruction, @x86_vpmacsdd { }

  class Vpmacsdqh extends Instruction, @x86_vpmacsdqh { }

  class Vpmacsdql extends Instruction, @x86_vpmacsdql { }

  class Vpmacssdd extends Instruction, @x86_vpmacssdd { }

  class Vpmacssdqh extends Instruction, @x86_vpmacssdqh { }

  class Vpmacssdql extends Instruction, @x86_vpmacssdql { }

  class Vpmacsswd extends Instruction, @x86_vpmacsswd { }

  class Vpmacssww extends Instruction, @x86_vpmacssww { }

  class Vpmacswd extends Instruction, @x86_vpmacswd { }

  class Vpmacsww extends Instruction, @x86_vpmacsww { }

  class Vpmadcsswd extends Instruction, @x86_vpmadcsswd { }

  class Vpmadcswd extends Instruction, @x86_vpmadcswd { }

  class Vpmadd231D extends Instruction, @x86_vpmadd231d { }

  class Vpmadd233D extends Instruction, @x86_vpmadd233d { }

  class Vpmadd52Huq extends Instruction, @x86_vpmadd52huq { }

  class Vpmadd52Luq extends Instruction, @x86_vpmadd52luq { }

  class Vpmaddubsw extends Instruction, @x86_vpmaddubsw { }

  class Vpmaddwd extends Instruction, @x86_vpmaddwd { }

  class Vpmaskmovd extends Instruction, @x86_vpmaskmovd { }

  class Vpmaskmovq extends Instruction, @x86_vpmaskmovq { }

  class Vpmaxsb extends Instruction, @x86_vpmaxsb { }

  class Vpmaxsd extends Instruction, @x86_vpmaxsd { }

  class Vpmaxsq extends Instruction, @x86_vpmaxsq { }

  class Vpmaxsw extends Instruction, @x86_vpmaxsw { }

  class Vpmaxub extends Instruction, @x86_vpmaxub { }

  class Vpmaxud extends Instruction, @x86_vpmaxud { }

  class Vpmaxuq extends Instruction, @x86_vpmaxuq { }

  class Vpmaxuw extends Instruction, @x86_vpmaxuw { }

  class Vpminsb extends Instruction, @x86_vpminsb { }

  class Vpminsd extends Instruction, @x86_vpminsd { }

  class Vpminsq extends Instruction, @x86_vpminsq { }

  class Vpminsw extends Instruction, @x86_vpminsw { }

  class Vpminub extends Instruction, @x86_vpminub { }

  class Vpminud extends Instruction, @x86_vpminud { }

  class Vpminuq extends Instruction, @x86_vpminuq { }

  class Vpminuw extends Instruction, @x86_vpminuw { }

  class Vpmovb2M extends Instruction, @x86_vpmovb2m { }

  class Vpmovd2M extends Instruction, @x86_vpmovd2m { }

  class Vpmovdb extends Instruction, @x86_vpmovdb { }

  class Vpmovdw extends Instruction, @x86_vpmovdw { }

  class Vpmovm2B extends Instruction, @x86_vpmovm2b { }

  class Vpmovm2D extends Instruction, @x86_vpmovm2d { }

  class Vpmovm2Q extends Instruction, @x86_vpmovm2q { }

  class Vpmovm2W extends Instruction, @x86_vpmovm2w { }

  class Vpmovmskb extends Instruction, @x86_vpmovmskb { }

  class Vpmovq2M extends Instruction, @x86_vpmovq2m { }

  class Vpmovqb extends Instruction, @x86_vpmovqb { }

  class Vpmovqd extends Instruction, @x86_vpmovqd { }

  class Vpmovqw extends Instruction, @x86_vpmovqw { }

  class Vpmovsdb extends Instruction, @x86_vpmovsdb { }

  class Vpmovsdw extends Instruction, @x86_vpmovsdw { }

  class Vpmovsqb extends Instruction, @x86_vpmovsqb { }

  class Vpmovsqd extends Instruction, @x86_vpmovsqd { }

  class Vpmovsqw extends Instruction, @x86_vpmovsqw { }

  class Vpmovswb extends Instruction, @x86_vpmovswb { }

  class Vpmovsxbd extends Instruction, @x86_vpmovsxbd { }

  class Vpmovsxbq extends Instruction, @x86_vpmovsxbq { }

  class Vpmovsxbw extends Instruction, @x86_vpmovsxbw { }

  class Vpmovsxdq extends Instruction, @x86_vpmovsxdq { }

  class Vpmovsxwd extends Instruction, @x86_vpmovsxwd { }

  class Vpmovsxwq extends Instruction, @x86_vpmovsxwq { }

  class Vpmovusdb extends Instruction, @x86_vpmovusdb { }

  class Vpmovusdw extends Instruction, @x86_vpmovusdw { }

  class Vpmovusqb extends Instruction, @x86_vpmovusqb { }

  class Vpmovusqd extends Instruction, @x86_vpmovusqd { }

  class Vpmovusqw extends Instruction, @x86_vpmovusqw { }

  class Vpmovuswb extends Instruction, @x86_vpmovuswb { }

  class Vpmovw2M extends Instruction, @x86_vpmovw2m { }

  class Vpmovwb extends Instruction, @x86_vpmovwb { }

  class Vpmovzxbd extends Instruction, @x86_vpmovzxbd { }

  class Vpmovzxbq extends Instruction, @x86_vpmovzxbq { }

  class Vpmovzxbw extends Instruction, @x86_vpmovzxbw { }

  class Vpmovzxdq extends Instruction, @x86_vpmovzxdq { }

  class Vpmovzxwd extends Instruction, @x86_vpmovzxwd { }

  class Vpmovzxwq extends Instruction, @x86_vpmovzxwq { }

  class Vpmuldq extends Instruction, @x86_vpmuldq { }

  class Vpmulhd extends Instruction, @x86_vpmulhd { }

  class Vpmulhrsw extends Instruction, @x86_vpmulhrsw { }

  class Vpmulhud extends Instruction, @x86_vpmulhud { }

  class Vpmulhuw extends Instruction, @x86_vpmulhuw { }

  class Vpmulhw extends Instruction, @x86_vpmulhw { }

  class Vpmulld extends Instruction, @x86_vpmulld { }

  class Vpmullq extends Instruction, @x86_vpmullq { }

  class Vpmullw extends Instruction, @x86_vpmullw { }

  class Vpmultishiftqb extends Instruction, @x86_vpmultishiftqb { }

  class Vpmuludq extends Instruction, @x86_vpmuludq { }

  class Vpopcntb extends Instruction, @x86_vpopcntb { }

  class Vpopcntd extends Instruction, @x86_vpopcntd { }

  class Vpopcntq extends Instruction, @x86_vpopcntq { }

  class Vpopcntw extends Instruction, @x86_vpopcntw { }

  class Vpor extends Instruction, @x86_vpor { }

  class Vpord extends Instruction, @x86_vpord { }

  class Vporq extends Instruction, @x86_vporq { }

  class Vpperm extends Instruction, @x86_vpperm { }

  class Vprefetch0 extends Instruction, @x86_vprefetch0 { }

  class Vprefetch1 extends Instruction, @x86_vprefetch1 { }

  class Vprefetch2 extends Instruction, @x86_vprefetch2 { }

  class Vprefetche0 extends Instruction, @x86_vprefetche0 { }

  class Vprefetche1 extends Instruction, @x86_vprefetche1 { }

  class Vprefetche2 extends Instruction, @x86_vprefetche2 { }

  class Vprefetchenta extends Instruction, @x86_vprefetchenta { }

  class Vprefetchnta extends Instruction, @x86_vprefetchnta { }

  class Vprold extends Instruction, @x86_vprold { }

  class Vprolq extends Instruction, @x86_vprolq { }

  class Vprolvd extends Instruction, @x86_vprolvd { }

  class Vprolvq extends Instruction, @x86_vprolvq { }

  class Vprord extends Instruction, @x86_vprord { }

  class Vprorq extends Instruction, @x86_vprorq { }

  class Vprorvd extends Instruction, @x86_vprorvd { }

  class Vprorvq extends Instruction, @x86_vprorvq { }

  class Vprotb extends Instruction, @x86_vprotb { }

  class Vprotd extends Instruction, @x86_vprotd { }

  class Vprotq extends Instruction, @x86_vprotq { }

  class Vprotw extends Instruction, @x86_vprotw { }

  class Vpsadbw extends Instruction, @x86_vpsadbw { }

  class Vpsbbd extends Instruction, @x86_vpsbbd { }

  class Vpsbbrd extends Instruction, @x86_vpsbbrd { }

  class Vpscatterdd extends Instruction, @x86_vpscatterdd { }

  class Vpscatterdq extends Instruction, @x86_vpscatterdq { }

  class Vpscatterqd extends Instruction, @x86_vpscatterqd { }

  class Vpscatterqq extends Instruction, @x86_vpscatterqq { }

  class Vpshab extends Instruction, @x86_vpshab { }

  class Vpshad extends Instruction, @x86_vpshad { }

  class Vpshaq extends Instruction, @x86_vpshaq { }

  class Vpshaw extends Instruction, @x86_vpshaw { }

  class Vpshlb extends Instruction, @x86_vpshlb { }

  class Vpshld extends Instruction, @x86_vpshld { }

  class Vpshldd extends Instruction, @x86_vpshldd { }

  class Vpshldq extends Instruction, @x86_vpshldq { }

  class Vpshldvd extends Instruction, @x86_vpshldvd { }

  class Vpshldvq extends Instruction, @x86_vpshldvq { }

  class Vpshldvw extends Instruction, @x86_vpshldvw { }

  class Vpshldw extends Instruction, @x86_vpshldw { }

  class Vpshlq extends Instruction, @x86_vpshlq { }

  class Vpshlw extends Instruction, @x86_vpshlw { }

  class Vpshrdd extends Instruction, @x86_vpshrdd { }

  class Vpshrdq extends Instruction, @x86_vpshrdq { }

  class Vpshrdvd extends Instruction, @x86_vpshrdvd { }

  class Vpshrdvq extends Instruction, @x86_vpshrdvq { }

  class Vpshrdvw extends Instruction, @x86_vpshrdvw { }

  class Vpshrdw extends Instruction, @x86_vpshrdw { }

  class Vpshufb extends Instruction, @x86_vpshufb { }

  class Vpshufbitqmb extends Instruction, @x86_vpshufbitqmb { }

  class Vpshufd extends Instruction, @x86_vpshufd { }

  class Vpshufhw extends Instruction, @x86_vpshufhw { }

  class Vpshuflw extends Instruction, @x86_vpshuflw { }

  class Vpsignb extends Instruction, @x86_vpsignb { }

  class Vpsignd extends Instruction, @x86_vpsignd { }

  class Vpsignw extends Instruction, @x86_vpsignw { }

  class Vpslld extends Instruction, @x86_vpslld { }

  class Vpslldq extends Instruction, @x86_vpslldq { }

  class Vpsllq extends Instruction, @x86_vpsllq { }

  class Vpsllvd extends Instruction, @x86_vpsllvd { }

  class Vpsllvq extends Instruction, @x86_vpsllvq { }

  class Vpsllvw extends Instruction, @x86_vpsllvw { }

  class Vpsllw extends Instruction, @x86_vpsllw { }

  class Vpsrad extends Instruction, @x86_vpsrad { }

  class Vpsraq extends Instruction, @x86_vpsraq { }

  class Vpsravd extends Instruction, @x86_vpsravd { }

  class Vpsravq extends Instruction, @x86_vpsravq { }

  class Vpsravw extends Instruction, @x86_vpsravw { }

  class Vpsraw extends Instruction, @x86_vpsraw { }

  class Vpsrld extends Instruction, @x86_vpsrld { }

  class Vpsrldq extends Instruction, @x86_vpsrldq { }

  class Vpsrlq extends Instruction, @x86_vpsrlq { }

  class Vpsrlvd extends Instruction, @x86_vpsrlvd { }

  class Vpsrlvq extends Instruction, @x86_vpsrlvq { }

  class Vpsrlvw extends Instruction, @x86_vpsrlvw { }

  class Vpsrlw extends Instruction, @x86_vpsrlw { }

  class Vpsubb extends Instruction, @x86_vpsubb { }

  class Vpsubd extends Instruction, @x86_vpsubd { }

  class Vpsubq extends Instruction, @x86_vpsubq { }

  class Vpsubrd extends Instruction, @x86_vpsubrd { }

  class Vpsubrsetbd extends Instruction, @x86_vpsubrsetbd { }

  class Vpsubsb extends Instruction, @x86_vpsubsb { }

  class Vpsubsetbd extends Instruction, @x86_vpsubsetbd { }

  class Vpsubsw extends Instruction, @x86_vpsubsw { }

  class Vpsubusb extends Instruction, @x86_vpsubusb { }

  class Vpsubusw extends Instruction, @x86_vpsubusw { }

  class Vpsubw extends Instruction, @x86_vpsubw { }

  class Vpternlogd extends Instruction, @x86_vpternlogd { }

  class Vpternlogq extends Instruction, @x86_vpternlogq { }

  class Vptest extends Instruction, @x86_vptest { }

  class Vptestmb extends Instruction, @x86_vptestmb { }

  class Vptestmd extends Instruction, @x86_vptestmd { }

  class Vptestmq extends Instruction, @x86_vptestmq { }

  class Vptestmw extends Instruction, @x86_vptestmw { }

  class Vptestnmb extends Instruction, @x86_vptestnmb { }

  class Vptestnmd extends Instruction, @x86_vptestnmd { }

  class Vptestnmq extends Instruction, @x86_vptestnmq { }

  class Vptestnmw extends Instruction, @x86_vptestnmw { }

  class Vpunpckhbw extends Instruction, @x86_vpunpckhbw { }

  class Vpunpckhdq extends Instruction, @x86_vpunpckhdq { }

  class Vpunpckhqdq extends Instruction, @x86_vpunpckhqdq { }

  class Vpunpckhwd extends Instruction, @x86_vpunpckhwd { }

  class Vpunpcklbw extends Instruction, @x86_vpunpcklbw { }

  class Vpunpckldq extends Instruction, @x86_vpunpckldq { }

  class Vpunpcklqdq extends Instruction, @x86_vpunpcklqdq { }

  class Vpunpcklwd extends Instruction, @x86_vpunpcklwd { }

  class Vpxor extends Instruction, @x86_vpxor { }

  class Vpxord extends Instruction, @x86_vpxord { }

  class Vpxorq extends Instruction, @x86_vpxorq { }

  class Vrangepd extends Instruction, @x86_vrangepd { }

  class Vrangeps extends Instruction, @x86_vrangeps { }

  class Vrangesd extends Instruction, @x86_vrangesd { }

  class Vrangess extends Instruction, @x86_vrangess { }

  class Vrcp14Pd extends Instruction, @x86_vrcp14pd { }

  class Vrcp14Ps extends Instruction, @x86_vrcp14ps { }

  class Vrcp14Sd extends Instruction, @x86_vrcp14sd { }

  class Vrcp14Ss extends Instruction, @x86_vrcp14ss { }

  class Vrcp23Ps extends Instruction, @x86_vrcp23ps { }

  class Vrcp28Pd extends Instruction, @x86_vrcp28pd { }

  class Vrcp28Ps extends Instruction, @x86_vrcp28ps { }

  class Vrcp28Sd extends Instruction, @x86_vrcp28sd { }

  class Vrcp28Ss extends Instruction, @x86_vrcp28ss { }

  class Vrcpph extends Instruction, @x86_vrcpph { }

  class Vrcpps extends Instruction, @x86_vrcpps { }

  class Vrcpsh extends Instruction, @x86_vrcpsh { }

  class Vrcpss extends Instruction, @x86_vrcpss { }

  class Vreducepd extends Instruction, @x86_vreducepd { }

  class Vreduceph extends Instruction, @x86_vreduceph { }

  class Vreduceps extends Instruction, @x86_vreduceps { }

  class Vreducesd extends Instruction, @x86_vreducesd { }

  class Vreducesh extends Instruction, @x86_vreducesh { }

  class Vreducess extends Instruction, @x86_vreducess { }

  class Vrndfxpntpd extends Instruction, @x86_vrndfxpntpd { }

  class Vrndfxpntps extends Instruction, @x86_vrndfxpntps { }

  class Vrndscalepd extends Instruction, @x86_vrndscalepd { }

  class Vrndscaleph extends Instruction, @x86_vrndscaleph { }

  class Vrndscaleps extends Instruction, @x86_vrndscaleps { }

  class Vrndscalesd extends Instruction, @x86_vrndscalesd { }

  class Vrndscalesh extends Instruction, @x86_vrndscalesh { }

  class Vrndscaless extends Instruction, @x86_vrndscaless { }

  class Vroundpd extends Instruction, @x86_vroundpd { }

  class Vroundps extends Instruction, @x86_vroundps { }

  class Vroundsd extends Instruction, @x86_vroundsd { }

  class Vroundss extends Instruction, @x86_vroundss { }

  class Vrsqrt14Pd extends Instruction, @x86_vrsqrt14pd { }

  class Vrsqrt14Ps extends Instruction, @x86_vrsqrt14ps { }

  class Vrsqrt14Sd extends Instruction, @x86_vrsqrt14sd { }

  class Vrsqrt14Ss extends Instruction, @x86_vrsqrt14ss { }

  class Vrsqrt23Ps extends Instruction, @x86_vrsqrt23ps { }

  class Vrsqrt28Pd extends Instruction, @x86_vrsqrt28pd { }

  class Vrsqrt28Ps extends Instruction, @x86_vrsqrt28ps { }

  class Vrsqrt28Sd extends Instruction, @x86_vrsqrt28sd { }

  class Vrsqrt28Ss extends Instruction, @x86_vrsqrt28ss { }

  class Vrsqrtph extends Instruction, @x86_vrsqrtph { }

  class Vrsqrtps extends Instruction, @x86_vrsqrtps { }

  class Vrsqrtsh extends Instruction, @x86_vrsqrtsh { }

  class Vrsqrtss extends Instruction, @x86_vrsqrtss { }

  class Vscalefpd extends Instruction, @x86_vscalefpd { }

  class Vscalefph extends Instruction, @x86_vscalefph { }

  class Vscalefps extends Instruction, @x86_vscalefps { }

  class Vscalefsd extends Instruction, @x86_vscalefsd { }

  class Vscalefsh extends Instruction, @x86_vscalefsh { }

  class Vscalefss extends Instruction, @x86_vscalefss { }

  class Vscaleps extends Instruction, @x86_vscaleps { }

  class Vscatterdpd extends Instruction, @x86_vscatterdpd { }

  class Vscatterdps extends Instruction, @x86_vscatterdps { }

  class Vscatterpf0Dpd extends Instruction, @x86_vscatterpf0dpd { }

  class Vscatterpf0Dps extends Instruction, @x86_vscatterpf0dps { }

  class Vscatterpf0Hintdpd extends Instruction, @x86_vscatterpf0hintdpd { }

  class Vscatterpf0Hintdps extends Instruction, @x86_vscatterpf0hintdps { }

  class Vscatterpf0Qpd extends Instruction, @x86_vscatterpf0qpd { }

  class Vscatterpf0Qps extends Instruction, @x86_vscatterpf0qps { }

  class Vscatterpf1Dpd extends Instruction, @x86_vscatterpf1dpd { }

  class Vscatterpf1Dps extends Instruction, @x86_vscatterpf1dps { }

  class Vscatterpf1Qpd extends Instruction, @x86_vscatterpf1qpd { }

  class Vscatterpf1Qps extends Instruction, @x86_vscatterpf1qps { }

  class Vscatterqpd extends Instruction, @x86_vscatterqpd { }

  class Vscatterqps extends Instruction, @x86_vscatterqps { }

  class Vsha512Msg1 extends Instruction, @x86_vsha512msg1 { }

  class Vsha512Msg2 extends Instruction, @x86_vsha512msg2 { }

  class Vsha512Rnds2 extends Instruction, @x86_vsha512rnds2 { }

  class Vshuff32X4 extends Instruction, @x86_vshuff32x4 { }

  class Vshuff64X2 extends Instruction, @x86_vshuff64x2 { }

  class Vshufi32X4 extends Instruction, @x86_vshufi32x4 { }

  class Vshufi64X2 extends Instruction, @x86_vshufi64x2 { }

  class Vshufpd extends Instruction, @x86_vshufpd { }

  class Vshufps extends Instruction, @x86_vshufps { }

  class Vsm3Msg1 extends Instruction, @x86_vsm3msg1 { }

  class Vsm3Msg2 extends Instruction, @x86_vsm3msg2 { }

  class Vsm3Rnds2 extends Instruction, @x86_vsm3rnds2 { }

  class Vsm4Key4 extends Instruction, @x86_vsm4key4 { }

  class Vsm4Rnds4 extends Instruction, @x86_vsm4rnds4 { }

  class Vsqrtpd extends Instruction, @x86_vsqrtpd { }

  class Vsqrtph extends Instruction, @x86_vsqrtph { }

  class Vsqrtps extends Instruction, @x86_vsqrtps { }

  class Vsqrtsd extends Instruction, @x86_vsqrtsd { }

  class Vsqrtsh extends Instruction, @x86_vsqrtsh { }

  class Vsqrtss extends Instruction, @x86_vsqrtss { }

  class Vstmxcsr extends Instruction, @x86_vstmxcsr { }

  class Vsubpd extends Instruction, @x86_vsubpd { }

  class Vsubph extends Instruction, @x86_vsubph { }

  class Vsubps extends Instruction, @x86_vsubps { }

  class Vsubrpd extends Instruction, @x86_vsubrpd { }

  class Vsubrps extends Instruction, @x86_vsubrps { }

  class Vsubsd extends Instruction, @x86_vsubsd { }

  class Vsubsh extends Instruction, @x86_vsubsh { }

  class Vsubss extends Instruction, @x86_vsubss { }

  class Vtestpd extends Instruction, @x86_vtestpd { }

  class Vtestps extends Instruction, @x86_vtestps { }

  class Vucomisd extends Instruction, @x86_vucomisd { }

  class Vucomish extends Instruction, @x86_vucomish { }

  class Vucomiss extends Instruction, @x86_vucomiss { }

  class Vunpckhpd extends Instruction, @x86_vunpckhpd { }

  class Vunpckhps extends Instruction, @x86_vunpckhps { }

  class Vunpcklpd extends Instruction, @x86_vunpcklpd { }

  class Vunpcklps extends Instruction, @x86_vunpcklps { }

  class Vxorpd extends Instruction, @x86_vxorpd { }

  class Vxorps extends Instruction, @x86_vxorps { }

  class Vzeroall extends Instruction, @x86_vzeroall { }

  class Vzeroupper extends Instruction, @x86_vzeroupper { }

  class Wbinvd extends Instruction, @x86_wbinvd { }

  class Wrfsbase extends Instruction, @x86_wrfsbase { }

  class Wrgsbase extends Instruction, @x86_wrgsbase { }

  class Wrmsr extends Instruction, @x86_wrmsr { }

  class Wrmsrlist extends Instruction, @x86_wrmsrlist { }

  class Wrmsrns extends Instruction, @x86_wrmsrns { }

  class Wrpkru extends Instruction, @x86_wrpkru { }

  class Wrssd extends Instruction, @x86_wrssd { }

  class Wrssq extends Instruction, @x86_wrssq { }

  class Wrussd extends Instruction, @x86_wrussd { }

  class Wrussq extends Instruction, @x86_wrussq { }

  class Xabort extends Instruction, @x86_xabort { }

  class Xadd extends Instruction, @x86_xadd { }

  class Xbegin extends Instruction, @x86_xbegin { }

  class Xchg extends Instruction, @x86_xchg { }

  class XcryptCbc extends Instruction, @x86_xcryptcbc { }

  class XcryptCfb extends Instruction, @x86_xcryptcfb { }

  class XcryptCtr extends Instruction, @x86_xcryptctr { }

  class XcryptEcb extends Instruction, @x86_xcryptecb { }

  class XcryptOfb extends Instruction, @x86_xcryptofb { }

  class Xend extends Instruction, @x86_xend { }

  class Xgetbv extends Instruction, @x86_xgetbv { }

  class Xlat extends Instruction, @x86_xlat { }

  class Xor extends Instruction, @x86_xor { }

  class Xorpd extends Instruction, @x86_xorpd { }

  class Xorps extends Instruction, @x86_xorps { }

  class Xresldtrk extends Instruction, @x86_xresldtrk { }

  class Xrstor extends Instruction, @x86_xrstor { }

  class Xrstor64 extends Instruction, @x86_xrstor64 { }

  class Xrstors extends Instruction, @x86_xrstors { }

  class Xrstors64 extends Instruction, @x86_xrstors64 { }

  class Xsave extends Instruction, @x86_xsave { }

  class Xsave64 extends Instruction, @x86_xsave64 { }

  class Xsavec extends Instruction, @x86_xsavec { }

  class Xsavec64 extends Instruction, @x86_xsavec64 { }

  class Xsaveopt extends Instruction, @x86_xsaveopt { }

  class Xsaveopt64 extends Instruction, @x86_xsaveopt64 { }

  class Xsaves extends Instruction, @x86_xsaves { }

  class Xsaves64 extends Instruction, @x86_xsaves64 { }

  class Xsetbv extends Instruction, @x86_xsetbv { }

  class Xsha1 extends Instruction, @x86_xsha1 { }

  class Xsha256 extends Instruction, @x86_xsha256 { }

  class Xstore extends Instruction, @x86_xstore { }

  class Xsusldtrk extends Instruction, @x86_xsusldtrk { }

  class Xtest extends Instruction, @x86_xtest { }
}

private module InstructionInput0 implements InstructionInputSig {
  class BaseInstruction extends @x86_instruction {
    string toString() { instruction_string(this, result) }
  }

  class BaseOperand extends @operand {
    string toString() { operand_string(this, result) }
  }

  class BaseRegister extends @register {
    string toString() { register(this, result) }
  }

  class BaseRipRegister extends BaseRegister {
    BaseRipRegister() { register(this, "rip") } // TODO: Or eip?
  }

  class BaseRspRegister extends BaseRegister {
    BaseRspRegister() { register(this, "rsp") } // TODO: Or esp?
  }

  class BaseRbpRegister extends BaseRegister {
    BaseRbpRegister() { register(this, "rbp") } // TODO: Or ebp?
  }

  class BaseRegisterAccess extends @register_access {
    BaseRegister getTarget() { register_access(this, result) }

    string toString() { result = this.getTarget().toString() }
  }

  class BaseUnusedOperand extends Operand {
    BaseUnusedOperand() { operand_unused(this) }
  }

  class BaseRegisterOperand extends Operand {
    BaseRegisterOperand() { operand_reg(this, _) }

    BaseRegisterAccess getAccess() { operand_reg(this, result) }
    // Register getRegister() { result = this.getAccess().getTarget() }
  }

  class BaseMemoryOperand extends Operand {
    BaseMemoryOperand() { operand_mem(this) }

    predicate hasDisplacement() { operand_mem_displacement(this, _) }

    BaseRegisterAccess getSegmentRegister() { operand_mem_segment_register(this, result) }

    BaseRegisterAccess getBaseRegister() { operand_mem_base_register(this, result) }

    BaseRegisterAccess getIndexRegister() { operand_mem_index_register(this, result) }

    int getScaleFactor() { operand_mem_scale_factor(this, result) }

    int getDisplacementValue() { operand_mem_displacement(this, result) }
  }

  class BasePointerOperand extends Operand {
    BasePointerOperand() { operand_ptr(this, _, _) }
  }

  class BaseImmediateOperand extends Operand {
    BaseImmediateOperand() { operand_imm(this, _, _, _) }

    int getValue() { operand_imm(this, result, _, _) }

    predicate isSigned() { operand_imm_is_signed(this) }

    predicate isAddress() { operand_imm_is_address(this) }

    predicate isRelative() { operand_imm_is_relative(this) }
  }
}

import MakeInstructions<InstructionInput0>
