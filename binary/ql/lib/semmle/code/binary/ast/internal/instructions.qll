private import semmle.code.binary.ast.Sections as Sections
private import semmle.code.binary.ast.Headers as Headers
private import semmle.code.binary.ast.Location

signature module InstructionInputSig {
  class BaseInstruction extends @instruction {
    string toString();
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
        instruction(this, a, b, _, _, _) and
        result = a.toBigInt() * "4294967297".toBigInt() + b.toBigInt()
      )
    }

    QlBuiltins::BigInt getVirtualAddress() {
      result = any(Sections::TextSection s).getVirtualAddress().toBigInt() + this.getIndex()
    }

    int getLength() { instruction(this, _, _, _, _, result) }

    Location getLocation() { result instanceof EmptyLocation }

    Instruction getASuccessor() {
      result.getIndex() = this.getIndex() + this.getLength().toBigInt()
    }
  }

  class Aaa extends Instruction, @aaa { }

  class Aad extends Instruction, @aad { }

  class Aadd extends Instruction, @aadd { }

  class Aam extends Instruction, @aam { }

  class Aand extends Instruction, @aand { }

  class Aas extends Instruction, @aas { }

  class Adc extends Instruction, @adc { }

  class Adcx extends Instruction, @adcx { }

  class Add extends Instruction, @add { }

  class Addpd extends Instruction, @addpd { }

  class Addps extends Instruction, @addps { }

  class Addsd extends Instruction, @addsd { }

  class Addss extends Instruction, @addss { }

  class Addsubpd extends Instruction, @addsubpd { }

  class Addsubps extends Instruction, @addsubps { }

  class Adox extends Instruction, @adox { }

  class Aesdec extends Instruction, @aesdec { }

  class Aesdec128Kl extends Instruction, @aesdec128kl { }

  class Aesdec256Kl extends Instruction, @aesdec256kl { }

  class Aesdeclast extends Instruction, @aesdeclast { }

  class Aesdecwide128Kl extends Instruction, @aesdecwide128kl { }

  class Aesdecwide256Kl extends Instruction, @aesdecwide256kl { }

  class Aesenc extends Instruction, @aesenc { }

  class Aesenc128Kl extends Instruction, @aesenc128kl { }

  class Aesenc256Kl extends Instruction, @aesenc256kl { }

  class Aesenclast extends Instruction, @aesenclast { }

  class Aesencwide128Kl extends Instruction, @aesencwide128kl { }

  class Aesencwide256Kl extends Instruction, @aesencwide256kl { }

  class Aesimc extends Instruction, @aesimc { }

  class Aeskeygenassist extends Instruction, @aeskeygenassist { }

  class And extends Instruction, @and { }

  class Andn extends Instruction, @andn { }

  class Andnpd extends Instruction, @andnpd { }

  class Andnps extends Instruction, @andnps { }

  class Andpd extends Instruction, @andpd { }

  class Andps extends Instruction, @andps { }

  class Aor extends Instruction, @aor { }

  class Arpl extends Instruction, @arpl { }

  class Axor extends Instruction, @axor { }

  class Bextr extends Instruction, @bextr { }

  class Blcfill extends Instruction, @blcfill { }

  class Blci extends Instruction, @blci { }

  class Blcic extends Instruction, @blcic { }

  class Blcmsk extends Instruction, @blcmsk { }

  class Blcs extends Instruction, @blcs { }

  class Blendpd extends Instruction, @blendpd { }

  class Blendps extends Instruction, @blendps { }

  class Blendvpd extends Instruction, @blendvpd { }

  class Blendvps extends Instruction, @blendvps { }

  class Blsfill extends Instruction, @blsfill { }

  class Blsi extends Instruction, @blsi { }

  class Blsic extends Instruction, @blsic { }

  class Blsmsk extends Instruction, @blsmsk { }

  class Blsr extends Instruction, @blsr { }

  class Bndcl extends Instruction, @bndcl { }

  class Bndcn extends Instruction, @bndcn { }

  class Bndcu extends Instruction, @bndcu { }

  class Bndldx extends Instruction, @bndldx { }

  class Bndmk extends Instruction, @bndmk { }

  class Bndmov extends Instruction, @bndmov { }

  class Bndstx extends Instruction, @bndstx { }

  class Bound extends Instruction, @bound { }

  class Bsf extends Instruction, @bsf { }

  class Bsr extends Instruction, @bsr { }

  class Bswap extends Instruction, @bswap { }

  class Bt extends Instruction, @bt { }

  class Btc extends Instruction, @btc { }

  class Btr extends Instruction, @btr { }

  class Bts extends Instruction, @bts { }

  class Bzhi extends Instruction, @bzhi { }

  class Call extends Instruction, @call {
    Instruction getTarget() { result = getCallTarget(this) }
  }

  class Cbw extends Instruction, @cbw { }

  class Ccmpb extends Instruction, @ccmpb { }

  class Ccmpbe extends Instruction, @ccmpbe { }

  class Ccmpf extends Instruction, @ccmpf { }

  class Ccmpl extends Instruction, @ccmpl { }

  class Ccmple extends Instruction, @ccmple { }

  class Ccmpnb extends Instruction, @ccmpnb { }

  class Ccmpnbe extends Instruction, @ccmpnbe { }

  class Ccmpnl extends Instruction, @ccmpnl { }

  class Ccmpnle extends Instruction, @ccmpnle { }

  class Ccmpno extends Instruction, @ccmpno { }

  class Ccmpns extends Instruction, @ccmpns { }

  class Ccmpnz extends Instruction, @ccmpnz { }

  class Ccmpo extends Instruction, @ccmpo { }

  class Ccmps extends Instruction, @ccmps { }

  class Ccmpt extends Instruction, @ccmpt { }

  class Ccmpz extends Instruction, @ccmpz { }

  class Cdq extends Instruction, @cdq { }

  class Cdqe extends Instruction, @cdqe { }

  class Cfcmovb extends Instruction, @cfcmovb { }

  class Cfcmovbe extends Instruction, @cfcmovbe { }

  class Cfcmovl extends Instruction, @cfcmovl { }

  class Cfcmovle extends Instruction, @cfcmovle { }

  class Cfcmovnb extends Instruction, @cfcmovnb { }

  class Cfcmovnbe extends Instruction, @cfcmovnbe { }

  class Cfcmovnl extends Instruction, @cfcmovnl { }

  class Cfcmovnle extends Instruction, @cfcmovnle { }

  class Cfcmovno extends Instruction, @cfcmovno { }

  class Cfcmovnp extends Instruction, @cfcmovnp { }

  class Cfcmovns extends Instruction, @cfcmovns { }

  class Cfcmovnz extends Instruction, @cfcmovnz { }

  class Cfcmovo extends Instruction, @cfcmovo { }

  class Cfcmovp extends Instruction, @cfcmovp { }

  class Cfcmovs extends Instruction, @cfcmovs { }

  class Cfcmovz extends Instruction, @cfcmovz { }

  class Clac extends Instruction, @clac { }

  class Clc extends Instruction, @clc { }

  class Cld extends Instruction, @cld { }

  class Cldemote extends Instruction, @cldemote { }

  class Clevict0 extends Instruction, @clevict0 { }

  class Clevict1 extends Instruction, @clevict1 { }

  class Clflush extends Instruction, @clflush { }

  class Clflushopt extends Instruction, @clflushopt { }

  class Clgi extends Instruction, @clgi { }

  class Cli extends Instruction, @cli { }

  class Clrssbsy extends Instruction, @clrssbsy { }

  class Clts extends Instruction, @clts { }

  class Clui extends Instruction, @clui { }

  class Clwb extends Instruction, @clwb { }

  class Clzero extends Instruction, @clzero { }

  class Cmc extends Instruction, @cmc { }

  class Cmovb extends Instruction, @cmovb { }

  class Cmovbe extends Instruction, @cmovbe { }

  class Cmovl extends Instruction, @cmovl { }

  class Cmovle extends Instruction, @cmovle { }

  class Cmovnb extends Instruction, @cmovnb { }

  class Cmovnbe extends Instruction, @cmovnbe { }

  class Cmovnl extends Instruction, @cmovnl { }

  class Cmovnle extends Instruction, @cmovnle { }

  class Cmovno extends Instruction, @cmovno { }

  class Cmovnp extends Instruction, @cmovnp { }

  class Cmovns extends Instruction, @cmovns { }

  class Cmovnz extends Instruction, @cmovnz { }

  class Cmovo extends Instruction, @cmovo { }

  class Cmovp extends Instruction, @cmovp { }

  class Cmovs extends Instruction, @cmovs { }

  class Cmovz extends Instruction, @cmovz { }

  class Cmp extends Instruction, @cmp { }

  class Cmpbexadd extends Instruction, @cmpbexadd { }

  class Cmpbxadd extends Instruction, @cmpbxadd { }

  class Cmplexadd extends Instruction, @cmplexadd { }

  class Cmplxadd extends Instruction, @cmplxadd { }

  class Cmpnbexadd extends Instruction, @cmpnbexadd { }

  class Cmpnbxadd extends Instruction, @cmpnbxadd { }

  class Cmpnlexadd extends Instruction, @cmpnlexadd { }

  class Cmpnlxadd extends Instruction, @cmpnlxadd { }

  class Cmpnoxadd extends Instruction, @cmpnoxadd { }

  class Cmpnpxadd extends Instruction, @cmpnpxadd { }

  class Cmpnsxadd extends Instruction, @cmpnsxadd { }

  class Cmpnzxadd extends Instruction, @cmpnzxadd { }

  class Cmpoxadd extends Instruction, @cmpoxadd { }

  class Cmppd extends Instruction, @cmppd { }

  class Cmpps extends Instruction, @cmpps { }

  class Cmppxadd extends Instruction, @cmppxadd { }

  class Cmpsb extends Instruction, @cmpsb { }

  class Cmpsd extends Instruction, @cmpsd { }

  class Cmpsq extends Instruction, @cmpsq { }

  class Cmpss extends Instruction, @cmpss { }

  class Cmpsw extends Instruction, @cmpsw { }

  class Cmpsxadd extends Instruction, @cmpsxadd { }

  class Cmpxchg extends Instruction, @cmpxchg { }

  class Cmpxchg16B extends Instruction, @cmpxchg16b { }

  class Cmpxchg8B extends Instruction, @cmpxchg8b { }

  class Cmpzxadd extends Instruction, @cmpzxadd { }

  class Comisd extends Instruction, @comisd { }

  class Comiss extends Instruction, @comiss { }

  class Cpuid extends Instruction, @cpuid { }

  class Cqo extends Instruction, @cqo { }

  class Crc32 extends Instruction, @crc32 { }

  class Ctestb extends Instruction, @ctestb { }

  class Ctestbe extends Instruction, @ctestbe { }

  class Ctestf extends Instruction, @ctestf { }

  class Ctestl extends Instruction, @ctestl { }

  class Ctestle extends Instruction, @ctestle { }

  class Ctestnb extends Instruction, @ctestnb { }

  class Ctestnbe extends Instruction, @ctestnbe { }

  class Ctestnl extends Instruction, @ctestnl { }

  class Ctestnle extends Instruction, @ctestnle { }

  class Ctestno extends Instruction, @ctestno { }

  class Ctestns extends Instruction, @ctestns { }

  class Ctestnz extends Instruction, @ctestnz { }

  class Ctesto extends Instruction, @ctesto { }

  class Ctests extends Instruction, @ctests { }

  class Ctestt extends Instruction, @ctestt { }

  class Ctestz extends Instruction, @ctestz { }

  class Cvtdq2Pd extends Instruction, @cvtdq2pd { }

  class Cvtdq2Ps extends Instruction, @cvtdq2ps { }

  class Cvtpd2Dq extends Instruction, @cvtpd2dq { }

  class Cvtpd2Pi extends Instruction, @cvtpd2pi { }

  class Cvtpd2Ps extends Instruction, @cvtpd2ps { }

  class Cvtpi2Pd extends Instruction, @cvtpi2pd { }

  class Cvtpi2Ps extends Instruction, @cvtpi2ps { }

  class Cvtps2Dq extends Instruction, @cvtps2dq { }

  class Cvtps2Pd extends Instruction, @cvtps2pd { }

  class Cvtps2Pi extends Instruction, @cvtps2pi { }

  class Cvtsd2Si extends Instruction, @cvtsd2si { }

  class Cvtsd2Ss extends Instruction, @cvtsd2ss { }

  class Cvtsi2Sd extends Instruction, @cvtsi2sd { }

  class Cvtsi2Ss extends Instruction, @cvtsi2ss { }

  class Cvtss2Sd extends Instruction, @cvtss2sd { }

  class Cvtss2Si extends Instruction, @cvtss2si { }

  class Cvttpd2Dq extends Instruction, @cvttpd2dq { }

  class Cvttpd2Pi extends Instruction, @cvttpd2pi { }

  class Cvttps2Dq extends Instruction, @cvttps2dq { }

  class Cvttps2Pi extends Instruction, @cvttps2pi { }

  class Cvttsd2Si extends Instruction, @cvttsd2si { }

  class Cvttss2Si extends Instruction, @cvttss2si { }

  class Cwd extends Instruction, @cwd { }

  class Cwde extends Instruction, @cwde { }

  class Daa extends Instruction, @daa { }

  class Das extends Instruction, @das { }

  class Dec extends Instruction, @dec { }

  class Delay extends Instruction, @delay { }

  class Div extends Instruction, @div { }

  class Divpd extends Instruction, @divpd { }

  class Divps extends Instruction, @divps { }

  class Divsd extends Instruction, @divsd { }

  class Divss extends Instruction, @divss { }

  class Dppd extends Instruction, @dppd { }

  class Dpps extends Instruction, @dpps { }

  class Emms extends Instruction, @emms { }

  class Encls extends Instruction, @encls { }

  class Enclu extends Instruction, @enclu { }

  class Enclv extends Instruction, @enclv { }

  class Encodekey128 extends Instruction, @encodekey128 { }

  class Encodekey256 extends Instruction, @encodekey256 { }

  class Endbr32 extends Instruction, @endbr32 { }

  class Endbr64 extends Instruction, @endbr64 { }

  class Enqcmd extends Instruction, @enqcmd { }

  class Enqcmds extends Instruction, @enqcmds { }

  class Enter extends Instruction, @enter { }

  class Erets extends Instruction, @erets { }

  class Eretu extends Instruction, @eretu { }

  class Extractps extends Instruction, @extractps { }

  class Extrq extends Instruction, @extrq { }

  class F2Xm1 extends Instruction, @f2xm1 { }

  class Fabs extends Instruction, @fabs { }

  class Fadd extends Instruction, @fadd { }

  class Faddp extends Instruction, @faddp { }

  class Fbld extends Instruction, @fbld { }

  class Fbstp extends Instruction, @fbstp { }

  class Fchs extends Instruction, @fchs { }

  class Fcmovb extends Instruction, @fcmovb { }

  class Fcmovbe extends Instruction, @fcmovbe { }

  class Fcmove extends Instruction, @fcmove { }

  class Fcmovnb extends Instruction, @fcmovnb { }

  class Fcmovnbe extends Instruction, @fcmovnbe { }

  class Fcmovne extends Instruction, @fcmovne { }

  class Fcmovnu extends Instruction, @fcmovnu { }

  class Fcmovu extends Instruction, @fcmovu { }

  class Fcom extends Instruction, @fcom { }

  class Fcomi extends Instruction, @fcomi { }

  class Fcomip extends Instruction, @fcomip { }

  class Fcomp extends Instruction, @fcomp { }

  class Fcompp extends Instruction, @fcompp { }

  class Fcos extends Instruction, @fcos { }

  class Fdecstp extends Instruction, @fdecstp { }

  class Fdisi8087Nop extends Instruction, @fdisi8087nop { }

  class Fdiv extends Instruction, @fdiv { }

  class Fdivp extends Instruction, @fdivp { }

  class Fdivr extends Instruction, @fdivr { }

  class Fdivrp extends Instruction, @fdivrp { }

  class Femms extends Instruction, @femms { }

  class Feni8087Nop extends Instruction, @feni8087nop { }

  class Ffree extends Instruction, @ffree { }

  class Ffreep extends Instruction, @ffreep { }

  class Fiadd extends Instruction, @fiadd { }

  class Ficom extends Instruction, @ficom { }

  class Ficomp extends Instruction, @ficomp { }

  class Fidiv extends Instruction, @fidiv { }

  class Fidivr extends Instruction, @fidivr { }

  class Fild extends Instruction, @fild { }

  class Fimul extends Instruction, @fimul { }

  class Fincstp extends Instruction, @fincstp { }

  class Fist extends Instruction, @fist { }

  class Fistp extends Instruction, @fistp { }

  class Fisttp extends Instruction, @fisttp { }

  class Fisub extends Instruction, @fisub { }

  class Fisubr extends Instruction, @fisubr { }

  class Fld extends Instruction, @fld { }

  class Fld1 extends Instruction, @fld1 { }

  class Fldcw extends Instruction, @fldcw { }

  class Fldenv extends Instruction, @fldenv { }

  class Fldl2E extends Instruction, @fldl2e { }

  class Fldl2T extends Instruction, @fldl2t { }

  class Fldlg2 extends Instruction, @fldlg2 { }

  class Fldln2 extends Instruction, @fldln2 { }

  class Fldpi extends Instruction, @fldpi { }

  class Fldz extends Instruction, @fldz { }

  class Fmul extends Instruction, @fmul { }

  class Fmulp extends Instruction, @fmulp { }

  class Fnclex extends Instruction, @fnclex { }

  class Fninit extends Instruction, @fninit { }

  class Fnop extends Instruction, @fnop { }

  class Fnsave extends Instruction, @fnsave { }

  class Fnstcw extends Instruction, @fnstcw { }

  class Fnstenv extends Instruction, @fnstenv { }

  class Fnstsw extends Instruction, @fnstsw { }

  class Fpatan extends Instruction, @fpatan { }

  class Fprem extends Instruction, @fprem { }

  class Fprem1 extends Instruction, @fprem1 { }

  class Fptan extends Instruction, @fptan { }

  class Frndint extends Instruction, @frndint { }

  class Frstor extends Instruction, @frstor { }

  class Fscale extends Instruction, @fscale { }

  class Fsetpm287Nop extends Instruction, @fsetpm287nop { }

  class Fsin extends Instruction, @fsin { }

  class Fsincos extends Instruction, @fsincos { }

  class Fsqrt extends Instruction, @fsqrt { }

  class Fst extends Instruction, @fst { }

  class Fstp extends Instruction, @fstp { }

  class Fstpnce extends Instruction, @fstpnce { }

  class Fsub extends Instruction, @fsub { }

  class Fsubp extends Instruction, @fsubp { }

  class Fsubr extends Instruction, @fsubr { }

  class Fsubrp extends Instruction, @fsubrp { }

  class Ftst extends Instruction, @ftst { }

  class Fucom extends Instruction, @fucom { }

  class Fucomi extends Instruction, @fucomi { }

  class Fucomip extends Instruction, @fucomip { }

  class Fucomp extends Instruction, @fucomp { }

  class Fucompp extends Instruction, @fucompp { }

  class Fwait extends Instruction, @fwait { }

  class Fxam extends Instruction, @fxam { }

  class Fxch extends Instruction, @fxch { }

  class Fxrstor extends Instruction, @fxrstor { }

  class Fxrstor64 extends Instruction, @fxrstor64 { }

  class Fxsave extends Instruction, @fxsave { }

  class Fxsave64 extends Instruction, @fxsave64 { }

  class Fxtract extends Instruction, @fxtract { }

  class Fyl2X extends Instruction, @fyl2x { }

  class Fyl2Xp1 extends Instruction, @fyl2xp1 { }

  class Getsec extends Instruction, @getsec { }

  class Gf2P8Affineinvqb extends Instruction, @gf2p8affineinvqb { }

  class Gf2P8Affineqb extends Instruction, @gf2p8affineqb { }

  class Gf2P8Mulb extends Instruction, @gf2p8mulb { }

  class Haddpd extends Instruction, @haddpd { }

  class Haddps extends Instruction, @haddps { }

  class Hlt extends Instruction, @hlt { }

  class Hreset extends Instruction, @hreset { }

  class Hsubpd extends Instruction, @hsubpd { }

  class Hsubps extends Instruction, @hsubps { }

  class Idiv extends Instruction, @idiv { }

  class Imul extends Instruction, @imul { }

  class Imulzu extends Instruction, @imulzu { }

  class In extends Instruction, @in { }

  class Inc extends Instruction, @inc { }

  class Incsspd extends Instruction, @incsspd { }

  class Incsspq extends Instruction, @incsspq { }

  class Insb extends Instruction, @insb { }

  class Insd extends Instruction, @insd { }

  class Insertps extends Instruction, @insertps { }

  class Insertq extends Instruction, @insertq { }

  class Insw extends Instruction, @insw { }

  class Int extends Instruction, @int { }

  class Int1 extends Instruction, @int1 { }

  class Int3 extends Instruction, @int3 {
    override Instruction getASuccessor() { none() }
  }

  class Into extends Instruction, @into { }

  class Invd extends Instruction, @invd { }

  class Invept extends Instruction, @invept { }

  class Invlpg extends Instruction, @invlpg { }

  class Invlpga extends Instruction, @invlpga { }

  class Invlpgb extends Instruction, @invlpgb { }

  class Invpcid extends Instruction, @invpcid { }

  class Invvpid extends Instruction, @invvpid { }

  class Iret extends Instruction, @iret { }

  class Iretd extends Instruction, @iretd { }

  class Iretq extends Instruction, @iretq { }

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

  class Jb extends ConditionalJumpInstruction, @jb { }

  class Jbe extends ConditionalJumpInstruction, @jbe { }

  class Jcxz extends ConditionalJumpInstruction, @jcxz { }

  class Jecxz extends ConditionalJumpInstruction, @jecxz { }

  class Jknzd extends ConditionalJumpInstruction, @jknzd { }

  class Jkzd extends ConditionalJumpInstruction, @jkzd { }

  class Jl extends ConditionalJumpInstruction, @jl { }

  class Jle extends ConditionalJumpInstruction, @jle { }

  class Jmp extends JumpingInstruction, @jmp {
    override Instruction getASuccessor() { result = this.getTarget() }
  }

  class Jmpabs extends ConditionalJumpInstruction, @jmpabs { }

  class Jnb extends ConditionalJumpInstruction, @jnb { }

  class Jnbe extends ConditionalJumpInstruction, @jnbe { }

  class Jnl extends ConditionalJumpInstruction, @jnl { }

  class Jnle extends ConditionalJumpInstruction, @jnle { }

  class Jno extends ConditionalJumpInstruction, @jno { }

  class Jnp extends ConditionalJumpInstruction, @jnp { }

  class Jns extends ConditionalJumpInstruction, @jns { }

  class Jnz extends ConditionalJumpInstruction, @jnz { }

  class Jo extends ConditionalJumpInstruction, @jo { }

  class Jp extends ConditionalJumpInstruction, @jp { }

  class Jrcxz extends ConditionalJumpInstruction, @jrcxz { }

  class Js extends ConditionalJumpInstruction, @js { }

  class Jz extends ConditionalJumpInstruction, @jz { }

  class Kaddb extends Instruction, @kaddb { }

  class Kaddd extends Instruction, @kaddd { }

  class Kaddq extends Instruction, @kaddq { }

  class Kaddw extends Instruction, @kaddw { }

  class Kand extends Instruction, @kand { }

  class Kandb extends Instruction, @kandb { }

  class Kandd extends Instruction, @kandd { }

  class Kandn extends Instruction, @kandn { }

  class Kandnb extends Instruction, @kandnb { }

  class Kandnd extends Instruction, @kandnd { }

  class Kandnq extends Instruction, @kandnq { }

  class Kandnr extends Instruction, @kandnr { }

  class Kandnw extends Instruction, @kandnw { }

  class Kandq extends Instruction, @kandq { }

  class Kandw extends Instruction, @kandw { }

  class Kconcath extends Instruction, @kconcath { }

  class Kconcatl extends Instruction, @kconcatl { }

  class Kextract extends Instruction, @kextract { }

  class Kmerge2L1H extends Instruction, @kmerge2l1h { }

  class Kmerge2L1L extends Instruction, @kmerge2l1l { }

  class Kmov extends Instruction, @kmov { }

  class Kmovb extends Instruction, @kmovb { }

  class Kmovd extends Instruction, @kmovd { }

  class Kmovq extends Instruction, @kmovq { }

  class Kmovw extends Instruction, @kmovw { }

  class Knot extends Instruction, @knot { }

  class Knotb extends Instruction, @knotb { }

  class Knotd extends Instruction, @knotd { }

  class Knotq extends Instruction, @knotq { }

  class Knotw extends Instruction, @knotw { }

  class Kor extends Instruction, @kor { }

  class Korb extends Instruction, @korb { }

  class Kord extends Instruction, @kord { }

  class Korq extends Instruction, @korq { }

  class Kortest extends Instruction, @kortest { }

  class Kortestb extends Instruction, @kortestb { }

  class Kortestd extends Instruction, @kortestd { }

  class Kortestq extends Instruction, @kortestq { }

  class Kortestw extends Instruction, @kortestw { }

  class Korw extends Instruction, @korw { }

  class Kshiftlb extends Instruction, @kshiftlb { }

  class Kshiftld extends Instruction, @kshiftld { }

  class Kshiftlq extends Instruction, @kshiftlq { }

  class Kshiftlw extends Instruction, @kshiftlw { }

  class Kshiftrb extends Instruction, @kshiftrb { }

  class Kshiftrd extends Instruction, @kshiftrd { }

  class Kshiftrq extends Instruction, @kshiftrq { }

  class Kshiftrw extends Instruction, @kshiftrw { }

  class Ktestb extends Instruction, @ktestb { }

  class Ktestd extends Instruction, @ktestd { }

  class Ktestq extends Instruction, @ktestq { }

  class Ktestw extends Instruction, @ktestw { }

  class Kunpckbw extends Instruction, @kunpckbw { }

  class Kunpckdq extends Instruction, @kunpckdq { }

  class Kunpckwd extends Instruction, @kunpckwd { }

  class Kxnor extends Instruction, @kxnor { }

  class Kxnorb extends Instruction, @kxnorb { }

  class Kxnord extends Instruction, @kxnord { }

  class Kxnorq extends Instruction, @kxnorq { }

  class Kxnorw extends Instruction, @kxnorw { }

  class Kxor extends Instruction, @kxor { }

  class Kxorb extends Instruction, @kxorb { }

  class Kxord extends Instruction, @kxord { }

  class Kxorq extends Instruction, @kxorq { }

  class Kxorw extends Instruction, @kxorw { }

  class Lahf extends Instruction, @lahf { }

  class Lar extends Instruction, @lar { }

  class Lddqu extends Instruction, @lddqu { }

  class Ldmxcsr extends Instruction, @ldmxcsr { }

  class Lds extends Instruction, @lds { }

  class Ldtilecfg extends Instruction, @ldtilecfg { }

  class Lea extends Instruction, @lea { }

  class Leave extends Instruction, @leave { }

  class Les extends Instruction, @les { }

  class Lfence extends Instruction, @lfence { }

  class Lfs extends Instruction, @lfs { }

  class Lgdt extends Instruction, @lgdt { }

  class Lgs extends Instruction, @lgs { }

  class Lidt extends Instruction, @lidt { }

  class Lkgs extends Instruction, @lkgs { }

  class Lldt extends Instruction, @lldt { }

  class Llwpcb extends Instruction, @llwpcb { }

  class Lmsw extends Instruction, @lmsw { }

  class Loadiwkey extends Instruction, @loadiwkey { }

  class Lodsb extends Instruction, @lodsb { }

  class Lodsd extends Instruction, @lodsd { }

  class Lodsq extends Instruction, @lodsq { }

  class Lodsw extends Instruction, @lodsw { }

  class Loop extends Instruction, @loop { }

  class Loope extends Instruction, @loope { }

  class Loopne extends Instruction, @loopne { }

  class Lsl extends Instruction, @lsl { }

  class Lss extends Instruction, @lss { }

  class Ltr extends Instruction, @ltr { }

  class Lwpins extends Instruction, @lwpins { }

  class Lwpval extends Instruction, @lwpval { }

  class Lzcnt extends Instruction, @lzcnt { }

  class Maskmovdqu extends Instruction, @maskmovdqu { }

  class Maskmovq extends Instruction, @maskmovq { }

  class Maxpd extends Instruction, @maxpd { }

  class Maxps extends Instruction, @maxps { }

  class Maxsd extends Instruction, @maxsd { }

  class Maxss extends Instruction, @maxss { }

  class Mcommit extends Instruction, @mcommit { }

  class Mfence extends Instruction, @mfence { }

  class Minpd extends Instruction, @minpd { }

  class Minps extends Instruction, @minps { }

  class Minsd extends Instruction, @minsd { }

  class Minss extends Instruction, @minss { }

  class Monitor extends Instruction, @monitor { }

  class Monitorx extends Instruction, @monitorx { }

  class Montmul extends Instruction, @montmul { }

  class Mov extends Instruction, @mov { }

  class Movapd extends Instruction, @movapd { }

  class Movaps extends Instruction, @movaps { }

  class Movbe extends Instruction, @movbe { }

  class Movd extends Instruction, @movd { }

  class Movddup extends Instruction, @movddup { }

  class Movdir64B extends Instruction, @movdir64b { }

  class Movdiri extends Instruction, @movdiri { }

  class Movdq2Q extends Instruction, @movdq2q { }

  class Movdqa extends Instruction, @movdqa { }

  class Movdqu extends Instruction, @movdqu { }

  class Movhlps extends Instruction, @movhlps { }

  class Movhpd extends Instruction, @movhpd { }

  class Movhps extends Instruction, @movhps { }

  class Movlhps extends Instruction, @movlhps { }

  class Movlpd extends Instruction, @movlpd { }

  class Movlps extends Instruction, @movlps { }

  class Movmskpd extends Instruction, @movmskpd { }

  class Movmskps extends Instruction, @movmskps { }

  class Movntdq extends Instruction, @movntdq { }

  class Movntdqa extends Instruction, @movntdqa { }

  class Movnti extends Instruction, @movnti { }

  class Movntpd extends Instruction, @movntpd { }

  class Movntps extends Instruction, @movntps { }

  class Movntq extends Instruction, @movntq { }

  class Movntsd extends Instruction, @movntsd { }

  class Movntss extends Instruction, @movntss { }

  class Movq extends Instruction, @movq { }

  class Movq2Dq extends Instruction, @movq2dq { }

  class Movsb extends Instruction, @movsb { }

  class Movsd extends Instruction, @movsd { }

  class Movshdup extends Instruction, @movshdup { }

  class Movsldup extends Instruction, @movsldup { }

  class Movsq extends Instruction, @movsq { }

  class Movss extends Instruction, @movss { }

  class Movsw extends Instruction, @movsw { }

  class Movsx extends Instruction, @movsx { }

  class Movsxd extends Instruction, @movsxd { }

  class Movupd extends Instruction, @movupd { }

  class Movups extends Instruction, @movups { }

  class Movzx extends Instruction, @movzx { }

  class Mpsadbw extends Instruction, @mpsadbw { }

  class Mul extends Instruction, @mul { }

  class Mulpd extends Instruction, @mulpd { }

  class Mulps extends Instruction, @mulps { }

  class Mulsd extends Instruction, @mulsd { }

  class Mulss extends Instruction, @mulss { }

  class Mulx extends Instruction, @mulx { }

  class Mwait extends Instruction, @mwait { }

  class Mwaitx extends Instruction, @mwaitx { }

  class Neg extends Instruction, @neg { }

  class Nop extends Instruction, @nop { }

  class Not extends Instruction, @not { }

  class Or extends Instruction, @or { }

  class Orpd extends Instruction, @orpd { }

  class Orps extends Instruction, @orps { }

  class Out extends Instruction, @out { }

  class Outsb extends Instruction, @outsb { }

  class Outsd extends Instruction, @outsd { }

  class Outsw extends Instruction, @outsw { }

  class Pabsb extends Instruction, @pabsb { }

  class Pabsd extends Instruction, @pabsd { }

  class Pabsw extends Instruction, @pabsw { }

  class Packssdw extends Instruction, @packssdw { }

  class Packsswb extends Instruction, @packsswb { }

  class Packusdw extends Instruction, @packusdw { }

  class Packuswb extends Instruction, @packuswb { }

  class Paddb extends Instruction, @paddb { }

  class Paddd extends Instruction, @paddd { }

  class Paddq extends Instruction, @paddq { }

  class Paddsb extends Instruction, @paddsb { }

  class Paddsw extends Instruction, @paddsw { }

  class Paddusb extends Instruction, @paddusb { }

  class Paddusw extends Instruction, @paddusw { }

  class Paddw extends Instruction, @paddw { }

  class Palignr extends Instruction, @palignr { }

  class Pand extends Instruction, @pand { }

  class Pandn extends Instruction, @pandn { }

  class Pause extends Instruction, @pause { }

  class Pavgb extends Instruction, @pavgb { }

  class Pavgusb extends Instruction, @pavgusb { }

  class Pavgw extends Instruction, @pavgw { }

  class Pblendvb extends Instruction, @pblendvb { }

  class Pblendw extends Instruction, @pblendw { }

  class Pbndkb extends Instruction, @pbndkb { }

  class Pclmulqdq extends Instruction, @pclmulqdq { }

  class Pcmpeqb extends Instruction, @pcmpeqb { }

  class Pcmpeqd extends Instruction, @pcmpeqd { }

  class Pcmpeqq extends Instruction, @pcmpeqq { }

  class Pcmpeqw extends Instruction, @pcmpeqw { }

  class Pcmpestri extends Instruction, @pcmpestri { }

  class Pcmpestrm extends Instruction, @pcmpestrm { }

  class Pcmpgtb extends Instruction, @pcmpgtb { }

  class Pcmpgtd extends Instruction, @pcmpgtd { }

  class Pcmpgtq extends Instruction, @pcmpgtq { }

  class Pcmpgtw extends Instruction, @pcmpgtw { }

  class Pcmpistri extends Instruction, @pcmpistri { }

  class Pcmpistrm extends Instruction, @pcmpistrm { }

  class Pcommit extends Instruction, @pcommit { }

  class Pconfig extends Instruction, @pconfig { }

  class Pdep extends Instruction, @pdep { }

  class Pext extends Instruction, @pext { }

  class Pextrb extends Instruction, @pextrb { }

  class Pextrd extends Instruction, @pextrd { }

  class Pextrq extends Instruction, @pextrq { }

  class Pextrw extends Instruction, @pextrw { }

  class Pf2Id extends Instruction, @pf2id { }

  class Pf2Iw extends Instruction, @pf2iw { }

  class Pfacc extends Instruction, @pfacc { }

  class Pfadd extends Instruction, @pfadd { }

  class Pfcmpeq extends Instruction, @pfcmpeq { }

  class Pfcmpge extends Instruction, @pfcmpge { }

  class Pfcmpgt extends Instruction, @pfcmpgt { }

  class Pfcpit1 extends Instruction, @pfcpit1 { }

  class Pfmax extends Instruction, @pfmax { }

  class Pfmin extends Instruction, @pfmin { }

  class Pfmul extends Instruction, @pfmul { }

  class Pfnacc extends Instruction, @pfnacc { }

  class Pfpnacc extends Instruction, @pfpnacc { }

  class Pfrcp extends Instruction, @pfrcp { }

  class Pfrcpit2 extends Instruction, @pfrcpit2 { }

  class Pfrsqit1 extends Instruction, @pfrsqit1 { }

  class Pfsqrt extends Instruction, @pfsqrt { }

  class Pfsub extends Instruction, @pfsub { }

  class Pfsubr extends Instruction, @pfsubr { }

  class Phaddd extends Instruction, @phaddd { }

  class Phaddsw extends Instruction, @phaddsw { }

  class Phaddw extends Instruction, @phaddw { }

  class Phminposuw extends Instruction, @phminposuw { }

  class Phsubd extends Instruction, @phsubd { }

  class Phsubsw extends Instruction, @phsubsw { }

  class Phsubw extends Instruction, @phsubw { }

  class Pi2Fd extends Instruction, @pi2fd { }

  class Pi2Fw extends Instruction, @pi2fw { }

  class Pinsrb extends Instruction, @pinsrb { }

  class Pinsrd extends Instruction, @pinsrd { }

  class Pinsrq extends Instruction, @pinsrq { }

  class Pinsrw extends Instruction, @pinsrw { }

  class Pmaddubsw extends Instruction, @pmaddubsw { }

  class Pmaddwd extends Instruction, @pmaddwd { }

  class Pmaxsb extends Instruction, @pmaxsb { }

  class Pmaxsd extends Instruction, @pmaxsd { }

  class Pmaxsw extends Instruction, @pmaxsw { }

  class Pmaxub extends Instruction, @pmaxub { }

  class Pmaxud extends Instruction, @pmaxud { }

  class Pmaxuw extends Instruction, @pmaxuw { }

  class Pminsb extends Instruction, @pminsb { }

  class Pminsd extends Instruction, @pminsd { }

  class Pminsw extends Instruction, @pminsw { }

  class Pminub extends Instruction, @pminub { }

  class Pminud extends Instruction, @pminud { }

  class Pminuw extends Instruction, @pminuw { }

  class Pmovmskb extends Instruction, @pmovmskb { }

  class Pmovsxbd extends Instruction, @pmovsxbd { }

  class Pmovsxbq extends Instruction, @pmovsxbq { }

  class Pmovsxbw extends Instruction, @pmovsxbw { }

  class Pmovsxdq extends Instruction, @pmovsxdq { }

  class Pmovsxwd extends Instruction, @pmovsxwd { }

  class Pmovsxwq extends Instruction, @pmovsxwq { }

  class Pmovzxbd extends Instruction, @pmovzxbd { }

  class Pmovzxbq extends Instruction, @pmovzxbq { }

  class Pmovzxbw extends Instruction, @pmovzxbw { }

  class Pmovzxdq extends Instruction, @pmovzxdq { }

  class Pmovzxwd extends Instruction, @pmovzxwd { }

  class Pmovzxwq extends Instruction, @pmovzxwq { }

  class Pmuldq extends Instruction, @pmuldq { }

  class Pmulhrsw extends Instruction, @pmulhrsw { }

  class Pmulhrw extends Instruction, @pmulhrw { }

  class Pmulhuw extends Instruction, @pmulhuw { }

  class Pmulhw extends Instruction, @pmulhw { }

  class Pmulld extends Instruction, @pmulld { }

  class Pmullw extends Instruction, @pmullw { }

  class Pmuludq extends Instruction, @pmuludq { }

  class Pop extends Instruction, @pop { }

  class Pop2 extends Instruction, @pop2 { }

  class Pop2P extends Instruction, @pop2p { }

  class Popa extends Instruction, @popa { }

  class Popad extends Instruction, @popad { }

  class Popcnt extends Instruction, @popcnt { }

  class Popf extends Instruction, @popf { }

  class Popfd extends Instruction, @popfd { }

  class Popfq extends Instruction, @popfq { }

  class Popp extends Instruction, @popp { }

  class Por extends Instruction, @por { }

  class Prefetch extends Instruction, @prefetch { }

  class Prefetchit0 extends Instruction, @prefetchit0 { }

  class Prefetchit1 extends Instruction, @prefetchit1 { }

  class Prefetchnta extends Instruction, @prefetchnta { }

  class Prefetcht0 extends Instruction, @prefetcht0 { }

  class Prefetcht1 extends Instruction, @prefetcht1 { }

  class Prefetcht2 extends Instruction, @prefetcht2 { }

  class Prefetchw extends Instruction, @prefetchw { }

  class Prefetchwt1 extends Instruction, @prefetchwt1 { }

  class Psadbw extends Instruction, @psadbw { }

  class Pshufb extends Instruction, @pshufb { }

  class Pshufd extends Instruction, @pshufd { }

  class Pshufhw extends Instruction, @pshufhw { }

  class Pshuflw extends Instruction, @pshuflw { }

  class Pshufw extends Instruction, @pshufw { }

  class Psignb extends Instruction, @psignb { }

  class Psignd extends Instruction, @psignd { }

  class Psignw extends Instruction, @psignw { }

  class Pslld extends Instruction, @pslld { }

  class Pslldq extends Instruction, @pslldq { }

  class Psllq extends Instruction, @psllq { }

  class Psllw extends Instruction, @psllw { }

  class Psmash extends Instruction, @psmash { }

  class Psrad extends Instruction, @psrad { }

  class Psraw extends Instruction, @psraw { }

  class Psrld extends Instruction, @psrld { }

  class Psrldq extends Instruction, @psrldq { }

  class Psrlq extends Instruction, @psrlq { }

  class Psrlw extends Instruction, @psrlw { }

  class Psubb extends Instruction, @psubb { }

  class Psubd extends Instruction, @psubd { }

  class Psubq extends Instruction, @psubq { }

  class Psubsb extends Instruction, @psubsb { }

  class Psubsw extends Instruction, @psubsw { }

  class Psubusb extends Instruction, @psubusb { }

  class Psubusw extends Instruction, @psubusw { }

  class Psubw extends Instruction, @psubw { }

  class Pswapd extends Instruction, @pswapd { }

  class Ptest extends Instruction, @ptest { }

  class Ptwrite extends Instruction, @ptwrite { }

  class Punpckhbw extends Instruction, @punpckhbw { }

  class Punpckhdq extends Instruction, @punpckhdq { }

  class Punpckhqdq extends Instruction, @punpckhqdq { }

  class Punpckhwd extends Instruction, @punpckhwd { }

  class Punpcklbw extends Instruction, @punpcklbw { }

  class Punpckldq extends Instruction, @punpckldq { }

  class Punpcklqdq extends Instruction, @punpcklqdq { }

  class Punpcklwd extends Instruction, @punpcklwd { }

  class Push extends Instruction, @push { }

  class Push2 extends Instruction, @push2 { }

  class Push2P extends Instruction, @push2p { }

  class Pusha extends Instruction, @pusha { }

  class Pushad extends Instruction, @pushad { }

  class Pushf extends Instruction, @pushf { }

  class Pushfd extends Instruction, @pushfd { }

  class Pushfq extends Instruction, @pushfq { }

  class Pushp extends Instruction, @pushp { }

  class Pvalidate extends Instruction, @pvalidate { }

  class Pxor extends Instruction, @pxor { }

  class Rcl extends Instruction, @rcl { }

  class Rcpps extends Instruction, @rcpps { }

  class Rcpss extends Instruction, @rcpss { }

  class Rcr extends Instruction, @rcr { }

  class Rdfsbase extends Instruction, @rdfsbase { }

  class Rdgsbase extends Instruction, @rdgsbase { }

  class Rdmsr extends Instruction, @rdmsr { }

  class Rdmsrlist extends Instruction, @rdmsrlist { }

  class Rdpid extends Instruction, @rdpid { }

  class Rdpkru extends Instruction, @rdpkru { }

  class Rdpmc extends Instruction, @rdpmc { }

  class Rdpru extends Instruction, @rdpru { }

  class Rdrand extends Instruction, @rdrand { }

  class Rdseed extends Instruction, @rdseed { }

  class Rdsspd extends Instruction, @rdsspd { }

  class Rdsspq extends Instruction, @rdsspq { }

  class Rdtsc extends Instruction, @rdtsc { }

  class Rdtscp extends Instruction, @rdtscp { }

  class Ret extends Instruction, @ret {
    override Instruction getASuccessor() { none() }
  }

  class Rmpadjust extends Instruction, @rmpadjust { }

  class Rmpupdate extends Instruction, @rmpupdate { }

  class Rol extends Instruction, @rol { }

  class Ror extends Instruction, @ror { }

  class Rorx extends Instruction, @rorx { }

  class Roundpd extends Instruction, @roundpd { }

  class Roundps extends Instruction, @roundps { }

  class Roundsd extends Instruction, @roundsd { }

  class Roundss extends Instruction, @roundss { }

  class Rsm extends Instruction, @rsm { }

  class Rsqrtps extends Instruction, @rsqrtps { }

  class Rsqrtss extends Instruction, @rsqrtss { }

  class Rstorssp extends Instruction, @rstorssp { }

  class Sahf extends Instruction, @sahf { }

  class Salc extends Instruction, @salc { }

  class Sar extends Instruction, @sar { }

  class Sarx extends Instruction, @sarx { }

  class Saveprevssp extends Instruction, @saveprevssp { }

  class Sbb extends Instruction, @sbb { }

  class Scasb extends Instruction, @scasb { }

  class Scasd extends Instruction, @scasd { }

  class Scasq extends Instruction, @scasq { }

  class Scasw extends Instruction, @scasw { }

  class Seamcall extends Instruction, @seamcall { }

  class Seamops extends Instruction, @seamops { }

  class Seamret extends Instruction, @seamret { }

  class Senduipi extends Instruction, @senduipi { }

  class Serialize extends Instruction, @serialize { }

  class Setb extends Instruction, @setb { }

  class Setbe extends Instruction, @setbe { }

  class Setl extends Instruction, @setl { }

  class Setle extends Instruction, @setle { }

  class Setnb extends Instruction, @setnb { }

  class Setnbe extends Instruction, @setnbe { }

  class Setnl extends Instruction, @setnl { }

  class Setnle extends Instruction, @setnle { }

  class Setno extends Instruction, @setno { }

  class Setnp extends Instruction, @setnp { }

  class Setns extends Instruction, @setns { }

  class Setnz extends Instruction, @setnz { }

  class Seto extends Instruction, @seto { }

  class Setp extends Instruction, @setp { }

  class Sets extends Instruction, @sets { }

  class Setssbsy extends Instruction, @setssbsy { }

  class Setz extends Instruction, @setz { }

  class Setzub extends Instruction, @setzub { }

  class Setzube extends Instruction, @setzube { }

  class Setzul extends Instruction, @setzul { }

  class Setzule extends Instruction, @setzule { }

  class Setzunb extends Instruction, @setzunb { }

  class Setzunbe extends Instruction, @setzunbe { }

  class Setzunl extends Instruction, @setzunl { }

  class Setzunle extends Instruction, @setzunle { }

  class Setzuno extends Instruction, @setzuno { }

  class Setzunp extends Instruction, @setzunp { }

  class Setzuns extends Instruction, @setzuns { }

  class Setzunz extends Instruction, @setzunz { }

  class Setzuo extends Instruction, @setzuo { }

  class Setzup extends Instruction, @setzup { }

  class Setzus extends Instruction, @setzus { }

  class Setzuz extends Instruction, @setzuz { }

  class Sfence extends Instruction, @sfence { }

  class Sgdt extends Instruction, @sgdt { }

  class Sha1Msg1 extends Instruction, @sha1msg1 { }

  class Sha1Msg2 extends Instruction, @sha1msg2 { }

  class Sha1Nexte extends Instruction, @sha1nexte { }

  class Sha1Rnds4 extends Instruction, @sha1rnds4 { }

  class Sha256Msg1 extends Instruction, @sha256msg1 { }

  class Sha256Msg2 extends Instruction, @sha256msg2 { }

  class Sha256Rnds2 extends Instruction, @sha256rnds2 { }

  class Shl extends Instruction, @shl { }

  class Shld extends Instruction, @shld { }

  class Shlx extends Instruction, @shlx { }

  class Shr extends Instruction, @shr { }

  class Shrd extends Instruction, @shrd { }

  class Shrx extends Instruction, @shrx { }

  class Shufpd extends Instruction, @shufpd { }

  class Shufps extends Instruction, @shufps { }

  class Sidt extends Instruction, @sidt { }

  class Skinit extends Instruction, @skinit { }

  class Sldt extends Instruction, @sldt { }

  class Slwpcb extends Instruction, @slwpcb { }

  class Smsw extends Instruction, @smsw { }

  class Spflt extends Instruction, @spflt { }

  class Sqrtpd extends Instruction, @sqrtpd { }

  class Sqrtps extends Instruction, @sqrtps { }

  class Sqrtsd extends Instruction, @sqrtsd { }

  class Sqrtss extends Instruction, @sqrtss { }

  class Stac extends Instruction, @stac { }

  class Stc extends Instruction, @stc { }

  class Std extends Instruction, @std { }

  class Stgi extends Instruction, @stgi { }

  class Sti extends Instruction, @sti { }

  class Stmxcsr extends Instruction, @stmxcsr { }

  class Stosb extends Instruction, @stosb { }

  class Stosd extends Instruction, @stosd { }

  class Stosq extends Instruction, @stosq { }

  class Stosw extends Instruction, @stosw { }

  class Str extends Instruction, @str { }

  class Sttilecfg extends Instruction, @sttilecfg { }

  class Stui extends Instruction, @stui { }

  class Sub extends Instruction, @sub { }

  class Subpd extends Instruction, @subpd { }

  class Subps extends Instruction, @subps { }

  class Subsd extends Instruction, @subsd { }

  class Subss extends Instruction, @subss { }

  class Swapgs extends Instruction, @swapgs { }

  class Syscall extends Instruction, @syscall { }

  class Sysenter extends Instruction, @sysenter { }

  class Sysexit extends Instruction, @sysexit { }

  class Sysret extends Instruction, @sysret { }

  class T1Mskc extends Instruction, @t1mskc { }

  class Tdcall extends Instruction, @tdcall { }

  class Tdpbf16Ps extends Instruction, @tdpbf16ps { }

  class Tdpbssd extends Instruction, @tdpbssd { }

  class Tdpbsud extends Instruction, @tdpbsud { }

  class Tdpbusd extends Instruction, @tdpbusd { }

  class Tdpbuud extends Instruction, @tdpbuud { }

  class Tdpfp16Ps extends Instruction, @tdpfp16ps { }

  class Test extends Instruction, @test { }

  class Testui extends Instruction, @testui { }

  class Tileloadd extends Instruction, @tileloadd { }

  class Tileloaddt1 extends Instruction, @tileloaddt1 { }

  class Tilerelease extends Instruction, @tilerelease { }

  class Tilestored extends Instruction, @tilestored { }

  class Tilezero extends Instruction, @tilezero { }

  class Tlbsync extends Instruction, @tlbsync { }

  class Tpause extends Instruction, @tpause { }

  class Tzcnt extends Instruction, @tzcnt { }

  class Tzcnti extends Instruction, @tzcnti { }

  class Tzmsk extends Instruction, @tzmsk { }

  class Ucomisd extends Instruction, @ucomisd { }

  class Ucomiss extends Instruction, @ucomiss { }

  class Ud0 extends Instruction, @ud0 { }

  class Ud1 extends Instruction, @ud1 { }

  class Ud2 extends Instruction, @ud2 { }

  class Uiret extends Instruction, @uiret { }

  class Umonitor extends Instruction, @umonitor { }

  class Umwait extends Instruction, @umwait { }

  class Unpckhpd extends Instruction, @unpckhpd { }

  class Unpckhps extends Instruction, @unpckhps { }

  class Unpcklpd extends Instruction, @unpcklpd { }

  class Unpcklps extends Instruction, @unpcklps { }

  class Urdmsr extends Instruction, @urdmsr { }

  class Uwrmsr extends Instruction, @uwrmsr { }

  class V4Fmaddps extends Instruction, @v4fmaddps { }

  class V4Fmaddss extends Instruction, @v4fmaddss { }

  class V4Fnmaddps extends Instruction, @v4fnmaddps { }

  class V4Fnmaddss extends Instruction, @v4fnmaddss { }

  class Vaddnpd extends Instruction, @vaddnpd { }

  class Vaddnps extends Instruction, @vaddnps { }

  class Vaddpd extends Instruction, @vaddpd { }

  class Vaddph extends Instruction, @vaddph { }

  class Vaddps extends Instruction, @vaddps { }

  class Vaddsd extends Instruction, @vaddsd { }

  class Vaddsetsps extends Instruction, @vaddsetsps { }

  class Vaddsh extends Instruction, @vaddsh { }

  class Vaddss extends Instruction, @vaddss { }

  class Vaddsubpd extends Instruction, @vaddsubpd { }

  class Vaddsubps extends Instruction, @vaddsubps { }

  class Vaesdec extends Instruction, @vaesdec { }

  class Vaesdeclast extends Instruction, @vaesdeclast { }

  class Vaesenc extends Instruction, @vaesenc { }

  class Vaesenclast extends Instruction, @vaesenclast { }

  class Vaesimc extends Instruction, @vaesimc { }

  class Vaeskeygenassist extends Instruction, @vaeskeygenassist { }

  class Valignd extends Instruction, @valignd { }

  class Valignq extends Instruction, @valignq { }

  class Vandnpd extends Instruction, @vandnpd { }

  class Vandnps extends Instruction, @vandnps { }

  class Vandpd extends Instruction, @vandpd { }

  class Vandps extends Instruction, @vandps { }

  class Vbcstnebf162Ps extends Instruction, @vbcstnebf162ps { }

  class Vbcstnesh2Ps extends Instruction, @vbcstnesh2ps { }

  class Vblendmpd extends Instruction, @vblendmpd { }

  class Vblendmps extends Instruction, @vblendmps { }

  class Vblendpd extends Instruction, @vblendpd { }

  class Vblendps extends Instruction, @vblendps { }

  class Vblendvpd extends Instruction, @vblendvpd { }

  class Vblendvps extends Instruction, @vblendvps { }

  class Vbroadcastf128 extends Instruction, @vbroadcastf128 { }

  class Vbroadcastf32X2 extends Instruction, @vbroadcastf32x2 { }

  class Vbroadcastf32X4 extends Instruction, @vbroadcastf32x4 { }

  class Vbroadcastf32X8 extends Instruction, @vbroadcastf32x8 { }

  class Vbroadcastf64X2 extends Instruction, @vbroadcastf64x2 { }

  class Vbroadcastf64X4 extends Instruction, @vbroadcastf64x4 { }

  class Vbroadcasti128 extends Instruction, @vbroadcasti128 { }

  class Vbroadcasti32X2 extends Instruction, @vbroadcasti32x2 { }

  class Vbroadcasti32X4 extends Instruction, @vbroadcasti32x4 { }

  class Vbroadcasti32X8 extends Instruction, @vbroadcasti32x8 { }

  class Vbroadcasti64X2 extends Instruction, @vbroadcasti64x2 { }

  class Vbroadcasti64X4 extends Instruction, @vbroadcasti64x4 { }

  class Vbroadcastsd extends Instruction, @vbroadcastsd { }

  class Vbroadcastss extends Instruction, @vbroadcastss { }

  class Vcmppd extends Instruction, @vcmppd { }

  class Vcmpph extends Instruction, @vcmpph { }

  class Vcmpps extends Instruction, @vcmpps { }

  class Vcmpsd extends Instruction, @vcmpsd { }

  class Vcmpsh extends Instruction, @vcmpsh { }

  class Vcmpss extends Instruction, @vcmpss { }

  class Vcomisd extends Instruction, @vcomisd { }

  class Vcomish extends Instruction, @vcomish { }

  class Vcomiss extends Instruction, @vcomiss { }

  class Vcompresspd extends Instruction, @vcompresspd { }

  class Vcompressps extends Instruction, @vcompressps { }

  class Vcvtdq2Pd extends Instruction, @vcvtdq2pd { }

  class Vcvtdq2Ph extends Instruction, @vcvtdq2ph { }

  class Vcvtdq2Ps extends Instruction, @vcvtdq2ps { }

  class Vcvtfxpntdq2Ps extends Instruction, @vcvtfxpntdq2ps { }

  class Vcvtfxpntpd2Dq extends Instruction, @vcvtfxpntpd2dq { }

  class Vcvtfxpntpd2Udq extends Instruction, @vcvtfxpntpd2udq { }

  class Vcvtfxpntps2Dq extends Instruction, @vcvtfxpntps2dq { }

  class Vcvtfxpntps2Udq extends Instruction, @vcvtfxpntps2udq { }

  class Vcvtfxpntudq2Ps extends Instruction, @vcvtfxpntudq2ps { }

  class Vcvtne2Ps2Bf16 extends Instruction, @vcvtne2ps2bf16 { }

  class Vcvtneebf162Ps extends Instruction, @vcvtneebf162ps { }

  class Vcvtneeph2Ps extends Instruction, @vcvtneeph2ps { }

  class Vcvtneobf162Ps extends Instruction, @vcvtneobf162ps { }

  class Vcvtneoph2Ps extends Instruction, @vcvtneoph2ps { }

  class Vcvtneps2Bf16 extends Instruction, @vcvtneps2bf16 { }

  class Vcvtpd2Dq extends Instruction, @vcvtpd2dq { }

  class Vcvtpd2Ph extends Instruction, @vcvtpd2ph { }

  class Vcvtpd2Ps extends Instruction, @vcvtpd2ps { }

  class Vcvtpd2Qq extends Instruction, @vcvtpd2qq { }

  class Vcvtpd2Udq extends Instruction, @vcvtpd2udq { }

  class Vcvtpd2Uqq extends Instruction, @vcvtpd2uqq { }

  class Vcvtph2Dq extends Instruction, @vcvtph2dq { }

  class Vcvtph2Pd extends Instruction, @vcvtph2pd { }

  class Vcvtph2Ps extends Instruction, @vcvtph2ps { }

  class Vcvtph2Psx extends Instruction, @vcvtph2psx { }

  class Vcvtph2Qq extends Instruction, @vcvtph2qq { }

  class Vcvtph2Udq extends Instruction, @vcvtph2udq { }

  class Vcvtph2Uqq extends Instruction, @vcvtph2uqq { }

  class Vcvtph2Uw extends Instruction, @vcvtph2uw { }

  class Vcvtph2W extends Instruction, @vcvtph2w { }

  class Vcvtps2Dq extends Instruction, @vcvtps2dq { }

  class Vcvtps2Pd extends Instruction, @vcvtps2pd { }

  class Vcvtps2Ph extends Instruction, @vcvtps2ph { }

  class Vcvtps2Phx extends Instruction, @vcvtps2phx { }

  class Vcvtps2Qq extends Instruction, @vcvtps2qq { }

  class Vcvtps2Udq extends Instruction, @vcvtps2udq { }

  class Vcvtps2Uqq extends Instruction, @vcvtps2uqq { }

  class Vcvtqq2Pd extends Instruction, @vcvtqq2pd { }

  class Vcvtqq2Ph extends Instruction, @vcvtqq2ph { }

  class Vcvtqq2Ps extends Instruction, @vcvtqq2ps { }

  class Vcvtsd2Sh extends Instruction, @vcvtsd2sh { }

  class Vcvtsd2Si extends Instruction, @vcvtsd2si { }

  class Vcvtsd2Ss extends Instruction, @vcvtsd2ss { }

  class Vcvtsd2Usi extends Instruction, @vcvtsd2usi { }

  class Vcvtsh2Sd extends Instruction, @vcvtsh2sd { }

  class Vcvtsh2Si extends Instruction, @vcvtsh2si { }

  class Vcvtsh2Ss extends Instruction, @vcvtsh2ss { }

  class Vcvtsh2Usi extends Instruction, @vcvtsh2usi { }

  class Vcvtsi2Sd extends Instruction, @vcvtsi2sd { }

  class Vcvtsi2Sh extends Instruction, @vcvtsi2sh { }

  class Vcvtsi2Ss extends Instruction, @vcvtsi2ss { }

  class Vcvtss2Sd extends Instruction, @vcvtss2sd { }

  class Vcvtss2Sh extends Instruction, @vcvtss2sh { }

  class Vcvtss2Si extends Instruction, @vcvtss2si { }

  class Vcvtss2Usi extends Instruction, @vcvtss2usi { }

  class Vcvttpd2Dq extends Instruction, @vcvttpd2dq { }

  class Vcvttpd2Qq extends Instruction, @vcvttpd2qq { }

  class Vcvttpd2Udq extends Instruction, @vcvttpd2udq { }

  class Vcvttpd2Uqq extends Instruction, @vcvttpd2uqq { }

  class Vcvttph2Dq extends Instruction, @vcvttph2dq { }

  class Vcvttph2Qq extends Instruction, @vcvttph2qq { }

  class Vcvttph2Udq extends Instruction, @vcvttph2udq { }

  class Vcvttph2Uqq extends Instruction, @vcvttph2uqq { }

  class Vcvttph2Uw extends Instruction, @vcvttph2uw { }

  class Vcvttph2W extends Instruction, @vcvttph2w { }

  class Vcvttps2Dq extends Instruction, @vcvttps2dq { }

  class Vcvttps2Qq extends Instruction, @vcvttps2qq { }

  class Vcvttps2Udq extends Instruction, @vcvttps2udq { }

  class Vcvttps2Uqq extends Instruction, @vcvttps2uqq { }

  class Vcvttsd2Si extends Instruction, @vcvttsd2si { }

  class Vcvttsd2Usi extends Instruction, @vcvttsd2usi { }

  class Vcvttsh2Si extends Instruction, @vcvttsh2si { }

  class Vcvttsh2Usi extends Instruction, @vcvttsh2usi { }

  class Vcvttss2Si extends Instruction, @vcvttss2si { }

  class Vcvttss2Usi extends Instruction, @vcvttss2usi { }

  class Vcvtudq2Pd extends Instruction, @vcvtudq2pd { }

  class Vcvtudq2Ph extends Instruction, @vcvtudq2ph { }

  class Vcvtudq2Ps extends Instruction, @vcvtudq2ps { }

  class Vcvtuqq2Pd extends Instruction, @vcvtuqq2pd { }

  class Vcvtuqq2Ph extends Instruction, @vcvtuqq2ph { }

  class Vcvtuqq2Ps extends Instruction, @vcvtuqq2ps { }

  class Vcvtusi2Sd extends Instruction, @vcvtusi2sd { }

  class Vcvtusi2Sh extends Instruction, @vcvtusi2sh { }

  class Vcvtusi2Ss extends Instruction, @vcvtusi2ss { }

  class Vcvtuw2Ph extends Instruction, @vcvtuw2ph { }

  class Vcvtw2Ph extends Instruction, @vcvtw2ph { }

  class Vdbpsadbw extends Instruction, @vdbpsadbw { }

  class Vdivpd extends Instruction, @vdivpd { }

  class Vdivph extends Instruction, @vdivph { }

  class Vdivps extends Instruction, @vdivps { }

  class Vdivsd extends Instruction, @vdivsd { }

  class Vdivsh extends Instruction, @vdivsh { }

  class Vdivss extends Instruction, @vdivss { }

  class Vdpbf16Ps extends Instruction, @vdpbf16ps { }

  class Vdppd extends Instruction, @vdppd { }

  class Vdpps extends Instruction, @vdpps { }

  class Verr extends Instruction, @verr { }

  class Verw extends Instruction, @verw { }

  class Vexp223Ps extends Instruction, @vexp223ps { }

  class Vexp2Pd extends Instruction, @vexp2pd { }

  class Vexp2Ps extends Instruction, @vexp2ps { }

  class Vexpandpd extends Instruction, @vexpandpd { }

  class Vexpandps extends Instruction, @vexpandps { }

  class Vextractf128 extends Instruction, @vextractf128 { }

  class Vextractf32X4 extends Instruction, @vextractf32x4 { }

  class Vextractf32X8 extends Instruction, @vextractf32x8 { }

  class Vextractf64X2 extends Instruction, @vextractf64x2 { }

  class Vextractf64X4 extends Instruction, @vextractf64x4 { }

  class Vextracti128 extends Instruction, @vextracti128 { }

  class Vextracti32X4 extends Instruction, @vextracti32x4 { }

  class Vextracti32X8 extends Instruction, @vextracti32x8 { }

  class Vextracti64X2 extends Instruction, @vextracti64x2 { }

  class Vextracti64X4 extends Instruction, @vextracti64x4 { }

  class Vextractps extends Instruction, @vextractps { }

  class Vfcmaddcph extends Instruction, @vfcmaddcph { }

  class Vfcmaddcsh extends Instruction, @vfcmaddcsh { }

  class Vfcmulcph extends Instruction, @vfcmulcph { }

  class Vfcmulcsh extends Instruction, @vfcmulcsh { }

  class Vfixupimmpd extends Instruction, @vfixupimmpd { }

  class Vfixupimmps extends Instruction, @vfixupimmps { }

  class Vfixupimmsd extends Instruction, @vfixupimmsd { }

  class Vfixupimmss extends Instruction, @vfixupimmss { }

  class Vfixupnanpd extends Instruction, @vfixupnanpd { }

  class Vfixupnanps extends Instruction, @vfixupnanps { }

  class Vfmadd132Pd extends Instruction, @vfmadd132pd { }

  class Vfmadd132Ph extends Instruction, @vfmadd132ph { }

  class Vfmadd132Ps extends Instruction, @vfmadd132ps { }

  class Vfmadd132Sd extends Instruction, @vfmadd132sd { }

  class Vfmadd132Sh extends Instruction, @vfmadd132sh { }

  class Vfmadd132Ss extends Instruction, @vfmadd132ss { }

  class Vfmadd213Pd extends Instruction, @vfmadd213pd { }

  class Vfmadd213Ph extends Instruction, @vfmadd213ph { }

  class Vfmadd213Ps extends Instruction, @vfmadd213ps { }

  class Vfmadd213Sd extends Instruction, @vfmadd213sd { }

  class Vfmadd213Sh extends Instruction, @vfmadd213sh { }

  class Vfmadd213Ss extends Instruction, @vfmadd213ss { }

  class Vfmadd231Pd extends Instruction, @vfmadd231pd { }

  class Vfmadd231Ph extends Instruction, @vfmadd231ph { }

  class Vfmadd231Ps extends Instruction, @vfmadd231ps { }

  class Vfmadd231Sd extends Instruction, @vfmadd231sd { }

  class Vfmadd231Sh extends Instruction, @vfmadd231sh { }

  class Vfmadd231Ss extends Instruction, @vfmadd231ss { }

  class Vfmadd233Ps extends Instruction, @vfmadd233ps { }

  class Vfmaddcph extends Instruction, @vfmaddcph { }

  class Vfmaddcsh extends Instruction, @vfmaddcsh { }

  class Vfmaddpd extends Instruction, @vfmaddpd { }

  class Vfmaddps extends Instruction, @vfmaddps { }

  class Vfmaddsd extends Instruction, @vfmaddsd { }

  class Vfmaddss extends Instruction, @vfmaddss { }

  class Vfmaddsub132Pd extends Instruction, @vfmaddsub132pd { }

  class Vfmaddsub132Ph extends Instruction, @vfmaddsub132ph { }

  class Vfmaddsub132Ps extends Instruction, @vfmaddsub132ps { }

  class Vfmaddsub213Pd extends Instruction, @vfmaddsub213pd { }

  class Vfmaddsub213Ph extends Instruction, @vfmaddsub213ph { }

  class Vfmaddsub213Ps extends Instruction, @vfmaddsub213ps { }

  class Vfmaddsub231Pd extends Instruction, @vfmaddsub231pd { }

  class Vfmaddsub231Ph extends Instruction, @vfmaddsub231ph { }

  class Vfmaddsub231Ps extends Instruction, @vfmaddsub231ps { }

  class Vfmaddsubpd extends Instruction, @vfmaddsubpd { }

  class Vfmaddsubps extends Instruction, @vfmaddsubps { }

  class Vfmsub132Pd extends Instruction, @vfmsub132pd { }

  class Vfmsub132Ph extends Instruction, @vfmsub132ph { }

  class Vfmsub132Ps extends Instruction, @vfmsub132ps { }

  class Vfmsub132Sd extends Instruction, @vfmsub132sd { }

  class Vfmsub132Sh extends Instruction, @vfmsub132sh { }

  class Vfmsub132Ss extends Instruction, @vfmsub132ss { }

  class Vfmsub213Pd extends Instruction, @vfmsub213pd { }

  class Vfmsub213Ph extends Instruction, @vfmsub213ph { }

  class Vfmsub213Ps extends Instruction, @vfmsub213ps { }

  class Vfmsub213Sd extends Instruction, @vfmsub213sd { }

  class Vfmsub213Sh extends Instruction, @vfmsub213sh { }

  class Vfmsub213Ss extends Instruction, @vfmsub213ss { }

  class Vfmsub231Pd extends Instruction, @vfmsub231pd { }

  class Vfmsub231Ph extends Instruction, @vfmsub231ph { }

  class Vfmsub231Ps extends Instruction, @vfmsub231ps { }

  class Vfmsub231Sd extends Instruction, @vfmsub231sd { }

  class Vfmsub231Sh extends Instruction, @vfmsub231sh { }

  class Vfmsub231Ss extends Instruction, @vfmsub231ss { }

  class Vfmsubadd132Pd extends Instruction, @vfmsubadd132pd { }

  class Vfmsubadd132Ph extends Instruction, @vfmsubadd132ph { }

  class Vfmsubadd132Ps extends Instruction, @vfmsubadd132ps { }

  class Vfmsubadd213Pd extends Instruction, @vfmsubadd213pd { }

  class Vfmsubadd213Ph extends Instruction, @vfmsubadd213ph { }

  class Vfmsubadd213Ps extends Instruction, @vfmsubadd213ps { }

  class Vfmsubadd231Pd extends Instruction, @vfmsubadd231pd { }

  class Vfmsubadd231Ph extends Instruction, @vfmsubadd231ph { }

  class Vfmsubadd231Ps extends Instruction, @vfmsubadd231ps { }

  class Vfmsubaddpd extends Instruction, @vfmsubaddpd { }

  class Vfmsubaddps extends Instruction, @vfmsubaddps { }

  class Vfmsubpd extends Instruction, @vfmsubpd { }

  class Vfmsubps extends Instruction, @vfmsubps { }

  class Vfmsubsd extends Instruction, @vfmsubsd { }

  class Vfmsubss extends Instruction, @vfmsubss { }

  class Vfmulcph extends Instruction, @vfmulcph { }

  class Vfmulcsh extends Instruction, @vfmulcsh { }

  class Vfnmadd132Pd extends Instruction, @vfnmadd132pd { }

  class Vfnmadd132Ph extends Instruction, @vfnmadd132ph { }

  class Vfnmadd132Ps extends Instruction, @vfnmadd132ps { }

  class Vfnmadd132Sd extends Instruction, @vfnmadd132sd { }

  class Vfnmadd132Sh extends Instruction, @vfnmadd132sh { }

  class Vfnmadd132Ss extends Instruction, @vfnmadd132ss { }

  class Vfnmadd213Pd extends Instruction, @vfnmadd213pd { }

  class Vfnmadd213Ph extends Instruction, @vfnmadd213ph { }

  class Vfnmadd213Ps extends Instruction, @vfnmadd213ps { }

  class Vfnmadd213Sd extends Instruction, @vfnmadd213sd { }

  class Vfnmadd213Sh extends Instruction, @vfnmadd213sh { }

  class Vfnmadd213Ss extends Instruction, @vfnmadd213ss { }

  class Vfnmadd231Pd extends Instruction, @vfnmadd231pd { }

  class Vfnmadd231Ph extends Instruction, @vfnmadd231ph { }

  class Vfnmadd231Ps extends Instruction, @vfnmadd231ps { }

  class Vfnmadd231Sd extends Instruction, @vfnmadd231sd { }

  class Vfnmadd231Sh extends Instruction, @vfnmadd231sh { }

  class Vfnmadd231Ss extends Instruction, @vfnmadd231ss { }

  class Vfnmaddpd extends Instruction, @vfnmaddpd { }

  class Vfnmaddps extends Instruction, @vfnmaddps { }

  class Vfnmaddsd extends Instruction, @vfnmaddsd { }

  class Vfnmaddss extends Instruction, @vfnmaddss { }

  class Vfnmsub132Pd extends Instruction, @vfnmsub132pd { }

  class Vfnmsub132Ph extends Instruction, @vfnmsub132ph { }

  class Vfnmsub132Ps extends Instruction, @vfnmsub132ps { }

  class Vfnmsub132Sd extends Instruction, @vfnmsub132sd { }

  class Vfnmsub132Sh extends Instruction, @vfnmsub132sh { }

  class Vfnmsub132Ss extends Instruction, @vfnmsub132ss { }

  class Vfnmsub213Pd extends Instruction, @vfnmsub213pd { }

  class Vfnmsub213Ph extends Instruction, @vfnmsub213ph { }

  class Vfnmsub213Ps extends Instruction, @vfnmsub213ps { }

  class Vfnmsub213Sd extends Instruction, @vfnmsub213sd { }

  class Vfnmsub213Sh extends Instruction, @vfnmsub213sh { }

  class Vfnmsub213Ss extends Instruction, @vfnmsub213ss { }

  class Vfnmsub231Pd extends Instruction, @vfnmsub231pd { }

  class Vfnmsub231Ph extends Instruction, @vfnmsub231ph { }

  class Vfnmsub231Ps extends Instruction, @vfnmsub231ps { }

  class Vfnmsub231Sd extends Instruction, @vfnmsub231sd { }

  class Vfnmsub231Sh extends Instruction, @vfnmsub231sh { }

  class Vfnmsub231Ss extends Instruction, @vfnmsub231ss { }

  class Vfnmsubpd extends Instruction, @vfnmsubpd { }

  class Vfnmsubps extends Instruction, @vfnmsubps { }

  class Vfnmsubsd extends Instruction, @vfnmsubsd { }

  class Vfnmsubss extends Instruction, @vfnmsubss { }

  class Vfpclasspd extends Instruction, @vfpclasspd { }

  class Vfpclassph extends Instruction, @vfpclassph { }

  class Vfpclassps extends Instruction, @vfpclassps { }

  class Vfpclasssd extends Instruction, @vfpclasssd { }

  class Vfpclasssh extends Instruction, @vfpclasssh { }

  class Vfpclassss extends Instruction, @vfpclassss { }

  class Vfrczpd extends Instruction, @vfrczpd { }

  class Vfrczps extends Instruction, @vfrczps { }

  class Vfrczsd extends Instruction, @vfrczsd { }

  class Vfrczss extends Instruction, @vfrczss { }

  class Vgatherdpd extends Instruction, @vgatherdpd { }

  class Vgatherdps extends Instruction, @vgatherdps { }

  class Vgatherpf0Dpd extends Instruction, @vgatherpf0dpd { }

  class Vgatherpf0Dps extends Instruction, @vgatherpf0dps { }

  class Vgatherpf0Hintdpd extends Instruction, @vgatherpf0hintdpd { }

  class Vgatherpf0Hintdps extends Instruction, @vgatherpf0hintdps { }

  class Vgatherpf0Qpd extends Instruction, @vgatherpf0qpd { }

  class Vgatherpf0Qps extends Instruction, @vgatherpf0qps { }

  class Vgatherpf1Dpd extends Instruction, @vgatherpf1dpd { }

  class Vgatherpf1Dps extends Instruction, @vgatherpf1dps { }

  class Vgatherpf1Qpd extends Instruction, @vgatherpf1qpd { }

  class Vgatherpf1Qps extends Instruction, @vgatherpf1qps { }

  class Vgatherqpd extends Instruction, @vgatherqpd { }

  class Vgatherqps extends Instruction, @vgatherqps { }

  class Vgetexppd extends Instruction, @vgetexppd { }

  class Vgetexpph extends Instruction, @vgetexpph { }

  class Vgetexpps extends Instruction, @vgetexpps { }

  class Vgetexpsd extends Instruction, @vgetexpsd { }

  class Vgetexpsh extends Instruction, @vgetexpsh { }

  class Vgetexpss extends Instruction, @vgetexpss { }

  class Vgetmantpd extends Instruction, @vgetmantpd { }

  class Vgetmantph extends Instruction, @vgetmantph { }

  class Vgetmantps extends Instruction, @vgetmantps { }

  class Vgetmantsd extends Instruction, @vgetmantsd { }

  class Vgetmantsh extends Instruction, @vgetmantsh { }

  class Vgetmantss extends Instruction, @vgetmantss { }

  class Vgf2P8Affineinvqb extends Instruction, @vgf2p8affineinvqb { }

  class Vgf2P8Affineqb extends Instruction, @vgf2p8affineqb { }

  class Vgf2P8Mulb extends Instruction, @vgf2p8mulb { }

  class Vgmaxabsps extends Instruction, @vgmaxabsps { }

  class Vgmaxpd extends Instruction, @vgmaxpd { }

  class Vgmaxps extends Instruction, @vgmaxps { }

  class Vgminpd extends Instruction, @vgminpd { }

  class Vgminps extends Instruction, @vgminps { }

  class Vhaddpd extends Instruction, @vhaddpd { }

  class Vhaddps extends Instruction, @vhaddps { }

  class Vhsubpd extends Instruction, @vhsubpd { }

  class Vhsubps extends Instruction, @vhsubps { }

  class Vinsertf128 extends Instruction, @vinsertf128 { }

  class Vinsertf32X4 extends Instruction, @vinsertf32x4 { }

  class Vinsertf32X8 extends Instruction, @vinsertf32x8 { }

  class Vinsertf64X2 extends Instruction, @vinsertf64x2 { }

  class Vinsertf64X4 extends Instruction, @vinsertf64x4 { }

  class Vinserti128 extends Instruction, @vinserti128 { }

  class Vinserti32X4 extends Instruction, @vinserti32x4 { }

  class Vinserti32X8 extends Instruction, @vinserti32x8 { }

  class Vinserti64X2 extends Instruction, @vinserti64x2 { }

  class Vinserti64X4 extends Instruction, @vinserti64x4 { }

  class Vinsertps extends Instruction, @vinsertps { }

  class Vlddqu extends Instruction, @vlddqu { }

  class Vldmxcsr extends Instruction, @vldmxcsr { }

  class Vloadunpackhd extends Instruction, @vloadunpackhd { }

  class Vloadunpackhpd extends Instruction, @vloadunpackhpd { }

  class Vloadunpackhps extends Instruction, @vloadunpackhps { }

  class Vloadunpackhq extends Instruction, @vloadunpackhq { }

  class Vloadunpackld extends Instruction, @vloadunpackld { }

  class Vloadunpacklpd extends Instruction, @vloadunpacklpd { }

  class Vloadunpacklps extends Instruction, @vloadunpacklps { }

  class Vloadunpacklq extends Instruction, @vloadunpacklq { }

  class Vlog2Ps extends Instruction, @vlog2ps { }

  class Vmaskmovdqu extends Instruction, @vmaskmovdqu { }

  class Vmaskmovpd extends Instruction, @vmaskmovpd { }

  class Vmaskmovps extends Instruction, @vmaskmovps { }

  class Vmaxpd extends Instruction, @vmaxpd { }

  class Vmaxph extends Instruction, @vmaxph { }

  class Vmaxps extends Instruction, @vmaxps { }

  class Vmaxsd extends Instruction, @vmaxsd { }

  class Vmaxsh extends Instruction, @vmaxsh { }

  class Vmaxss extends Instruction, @vmaxss { }

  class Vmcall extends Instruction, @vmcall { }

  class Vmclear extends Instruction, @vmclear { }

  class Vmfunc extends Instruction, @vmfunc { }

  class Vminpd extends Instruction, @vminpd { }

  class Vminph extends Instruction, @vminph { }

  class Vminps extends Instruction, @vminps { }

  class Vminsd extends Instruction, @vminsd { }

  class Vminsh extends Instruction, @vminsh { }

  class Vminss extends Instruction, @vminss { }

  class Vmlaunch extends Instruction, @vmlaunch { }

  class Vmload extends Instruction, @vmload { }

  class Vmmcall extends Instruction, @vmmcall { }

  class Vmovapd extends Instruction, @vmovapd { }

  class Vmovaps extends Instruction, @vmovaps { }

  class Vmovd extends Instruction, @vmovd { }

  class Vmovddup extends Instruction, @vmovddup { }

  class Vmovdqa extends Instruction, @vmovdqa { }

  class Vmovdqa32 extends Instruction, @vmovdqa32 { }

  class Vmovdqa64 extends Instruction, @vmovdqa64 { }

  class Vmovdqu extends Instruction, @vmovdqu { }

  class Vmovdqu16 extends Instruction, @vmovdqu16 { }

  class Vmovdqu32 extends Instruction, @vmovdqu32 { }

  class Vmovdqu64 extends Instruction, @vmovdqu64 { }

  class Vmovdqu8 extends Instruction, @vmovdqu8 { }

  class Vmovhlps extends Instruction, @vmovhlps { }

  class Vmovhpd extends Instruction, @vmovhpd { }

  class Vmovhps extends Instruction, @vmovhps { }

  class Vmovlhps extends Instruction, @vmovlhps { }

  class Vmovlpd extends Instruction, @vmovlpd { }

  class Vmovlps extends Instruction, @vmovlps { }

  class Vmovmskpd extends Instruction, @vmovmskpd { }

  class Vmovmskps extends Instruction, @vmovmskps { }

  class Vmovnrapd extends Instruction, @vmovnrapd { }

  class Vmovnraps extends Instruction, @vmovnraps { }

  class Vmovnrngoapd extends Instruction, @vmovnrngoapd { }

  class Vmovnrngoaps extends Instruction, @vmovnrngoaps { }

  class Vmovntdq extends Instruction, @vmovntdq { }

  class Vmovntdqa extends Instruction, @vmovntdqa { }

  class Vmovntpd extends Instruction, @vmovntpd { }

  class Vmovntps extends Instruction, @vmovntps { }

  class Vmovq extends Instruction, @vmovq { }

  class Vmovsd extends Instruction, @vmovsd { }

  class Vmovsh extends Instruction, @vmovsh { }

  class Vmovshdup extends Instruction, @vmovshdup { }

  class Vmovsldup extends Instruction, @vmovsldup { }

  class Vmovss extends Instruction, @vmovss { }

  class Vmovupd extends Instruction, @vmovupd { }

  class Vmovups extends Instruction, @vmovups { }

  class Vmovw extends Instruction, @vmovw { }

  class Vmpsadbw extends Instruction, @vmpsadbw { }

  class Vmptrld extends Instruction, @vmptrld { }

  class Vmptrst extends Instruction, @vmptrst { }

  class Vmread extends Instruction, @vmread { }

  class Vmresume extends Instruction, @vmresume { }

  class Vmrun extends Instruction, @vmrun { }

  class Vmsave extends Instruction, @vmsave { }

  class Vmulpd extends Instruction, @vmulpd { }

  class Vmulph extends Instruction, @vmulph { }

  class Vmulps extends Instruction, @vmulps { }

  class Vmulsd extends Instruction, @vmulsd { }

  class Vmulsh extends Instruction, @vmulsh { }

  class Vmulss extends Instruction, @vmulss { }

  class Vmwrite extends Instruction, @vmwrite { }

  class Vmxoff extends Instruction, @vmxoff { }

  class Vmxon extends Instruction, @vmxon { }

  class Vorpd extends Instruction, @vorpd { }

  class Vorps extends Instruction, @vorps { }

  class Vp2Intersectd extends Instruction, @vp2intersectd { }

  class Vp2Intersectq extends Instruction, @vp2intersectq { }

  class Vp4Dpwssd extends Instruction, @vp4dpwssd { }

  class Vp4Dpwssds extends Instruction, @vp4dpwssds { }

  class Vpabsb extends Instruction, @vpabsb { }

  class Vpabsd extends Instruction, @vpabsd { }

  class Vpabsq extends Instruction, @vpabsq { }

  class Vpabsw extends Instruction, @vpabsw { }

  class Vpackssdw extends Instruction, @vpackssdw { }

  class Vpacksswb extends Instruction, @vpacksswb { }

  class Vpackstorehd extends Instruction, @vpackstorehd { }

  class Vpackstorehpd extends Instruction, @vpackstorehpd { }

  class Vpackstorehps extends Instruction, @vpackstorehps { }

  class Vpackstorehq extends Instruction, @vpackstorehq { }

  class Vpackstoreld extends Instruction, @vpackstoreld { }

  class Vpackstorelpd extends Instruction, @vpackstorelpd { }

  class Vpackstorelps extends Instruction, @vpackstorelps { }

  class Vpackstorelq extends Instruction, @vpackstorelq { }

  class Vpackusdw extends Instruction, @vpackusdw { }

  class Vpackuswb extends Instruction, @vpackuswb { }

  class Vpadcd extends Instruction, @vpadcd { }

  class Vpaddb extends Instruction, @vpaddb { }

  class Vpaddd extends Instruction, @vpaddd { }

  class Vpaddq extends Instruction, @vpaddq { }

  class Vpaddsb extends Instruction, @vpaddsb { }

  class Vpaddsetcd extends Instruction, @vpaddsetcd { }

  class Vpaddsetsd extends Instruction, @vpaddsetsd { }

  class Vpaddsw extends Instruction, @vpaddsw { }

  class Vpaddusb extends Instruction, @vpaddusb { }

  class Vpaddusw extends Instruction, @vpaddusw { }

  class Vpaddw extends Instruction, @vpaddw { }

  class Vpalignr extends Instruction, @vpalignr { }

  class Vpand extends Instruction, @vpand { }

  class Vpandd extends Instruction, @vpandd { }

  class Vpandn extends Instruction, @vpandn { }

  class Vpandnd extends Instruction, @vpandnd { }

  class Vpandnq extends Instruction, @vpandnq { }

  class Vpandq extends Instruction, @vpandq { }

  class Vpavgb extends Instruction, @vpavgb { }

  class Vpavgw extends Instruction, @vpavgw { }

  class Vpblendd extends Instruction, @vpblendd { }

  class Vpblendmb extends Instruction, @vpblendmb { }

  class Vpblendmd extends Instruction, @vpblendmd { }

  class Vpblendmq extends Instruction, @vpblendmq { }

  class Vpblendmw extends Instruction, @vpblendmw { }

  class Vpblendvb extends Instruction, @vpblendvb { }

  class Vpblendw extends Instruction, @vpblendw { }

  class Vpbroadcastb extends Instruction, @vpbroadcastb { }

  class Vpbroadcastd extends Instruction, @vpbroadcastd { }

  class Vpbroadcastmb2Q extends Instruction, @vpbroadcastmb2q { }

  class Vpbroadcastmw2D extends Instruction, @vpbroadcastmw2d { }

  class Vpbroadcastq extends Instruction, @vpbroadcastq { }

  class Vpbroadcastw extends Instruction, @vpbroadcastw { }

  class Vpclmulqdq extends Instruction, @vpclmulqdq { }

  class Vpcmov extends Instruction, @vpcmov { }

  class Vpcmpb extends Instruction, @vpcmpb { }

  class Vpcmpd extends Instruction, @vpcmpd { }

  class Vpcmpeqb extends Instruction, @vpcmpeqb { }

  class Vpcmpeqd extends Instruction, @vpcmpeqd { }

  class Vpcmpeqq extends Instruction, @vpcmpeqq { }

  class Vpcmpeqw extends Instruction, @vpcmpeqw { }

  class Vpcmpestri extends Instruction, @vpcmpestri { }

  class Vpcmpestrm extends Instruction, @vpcmpestrm { }

  class Vpcmpgtb extends Instruction, @vpcmpgtb { }

  class Vpcmpgtd extends Instruction, @vpcmpgtd { }

  class Vpcmpgtq extends Instruction, @vpcmpgtq { }

  class Vpcmpgtw extends Instruction, @vpcmpgtw { }

  class Vpcmpistri extends Instruction, @vpcmpistri { }

  class Vpcmpistrm extends Instruction, @vpcmpistrm { }

  class Vpcmpltd extends Instruction, @vpcmpltd { }

  class Vpcmpq extends Instruction, @vpcmpq { }

  class Vpcmpub extends Instruction, @vpcmpub { }

  class Vpcmpud extends Instruction, @vpcmpud { }

  class Vpcmpuq extends Instruction, @vpcmpuq { }

  class Vpcmpuw extends Instruction, @vpcmpuw { }

  class Vpcmpw extends Instruction, @vpcmpw { }

  class Vpcomb extends Instruction, @vpcomb { }

  class Vpcomd extends Instruction, @vpcomd { }

  class Vpcompressb extends Instruction, @vpcompressb { }

  class Vpcompressd extends Instruction, @vpcompressd { }

  class Vpcompressq extends Instruction, @vpcompressq { }

  class Vpcompressw extends Instruction, @vpcompressw { }

  class Vpcomq extends Instruction, @vpcomq { }

  class Vpcomub extends Instruction, @vpcomub { }

  class Vpcomud extends Instruction, @vpcomud { }

  class Vpcomuq extends Instruction, @vpcomuq { }

  class Vpcomuw extends Instruction, @vpcomuw { }

  class Vpcomw extends Instruction, @vpcomw { }

  class Vpconflictd extends Instruction, @vpconflictd { }

  class Vpconflictq extends Instruction, @vpconflictq { }

  class Vpdpbssd extends Instruction, @vpdpbssd { }

  class Vpdpbssds extends Instruction, @vpdpbssds { }

  class Vpdpbsud extends Instruction, @vpdpbsud { }

  class Vpdpbsuds extends Instruction, @vpdpbsuds { }

  class Vpdpbusd extends Instruction, @vpdpbusd { }

  class Vpdpbusds extends Instruction, @vpdpbusds { }

  class Vpdpbuud extends Instruction, @vpdpbuud { }

  class Vpdpbuuds extends Instruction, @vpdpbuuds { }

  class Vpdpwssd extends Instruction, @vpdpwssd { }

  class Vpdpwssds extends Instruction, @vpdpwssds { }

  class Vpdpwsud extends Instruction, @vpdpwsud { }

  class Vpdpwsuds extends Instruction, @vpdpwsuds { }

  class Vpdpwusd extends Instruction, @vpdpwusd { }

  class Vpdpwusds extends Instruction, @vpdpwusds { }

  class Vpdpwuud extends Instruction, @vpdpwuud { }

  class Vpdpwuuds extends Instruction, @vpdpwuuds { }

  class Vperm2F128 extends Instruction, @vperm2f128 { }

  class Vperm2I128 extends Instruction, @vperm2i128 { }

  class Vpermb extends Instruction, @vpermb { }

  class Vpermd extends Instruction, @vpermd { }

  class Vpermf32X4 extends Instruction, @vpermf32x4 { }

  class Vpermi2B extends Instruction, @vpermi2b { }

  class Vpermi2D extends Instruction, @vpermi2d { }

  class Vpermi2Pd extends Instruction, @vpermi2pd { }

  class Vpermi2Ps extends Instruction, @vpermi2ps { }

  class Vpermi2Q extends Instruction, @vpermi2q { }

  class Vpermi2W extends Instruction, @vpermi2w { }

  class Vpermil2Pd extends Instruction, @vpermil2pd { }

  class Vpermil2Ps extends Instruction, @vpermil2ps { }

  class Vpermilpd extends Instruction, @vpermilpd { }

  class Vpermilps extends Instruction, @vpermilps { }

  class Vpermpd extends Instruction, @vpermpd { }

  class Vpermps extends Instruction, @vpermps { }

  class Vpermq extends Instruction, @vpermq { }

  class Vpermt2B extends Instruction, @vpermt2b { }

  class Vpermt2D extends Instruction, @vpermt2d { }

  class Vpermt2Pd extends Instruction, @vpermt2pd { }

  class Vpermt2Ps extends Instruction, @vpermt2ps { }

  class Vpermt2Q extends Instruction, @vpermt2q { }

  class Vpermt2W extends Instruction, @vpermt2w { }

  class Vpermw extends Instruction, @vpermw { }

  class Vpexpandb extends Instruction, @vpexpandb { }

  class Vpexpandd extends Instruction, @vpexpandd { }

  class Vpexpandq extends Instruction, @vpexpandq { }

  class Vpexpandw extends Instruction, @vpexpandw { }

  class Vpextrb extends Instruction, @vpextrb { }

  class Vpextrd extends Instruction, @vpextrd { }

  class Vpextrq extends Instruction, @vpextrq { }

  class Vpextrw extends Instruction, @vpextrw { }

  class Vpgatherdd extends Instruction, @vpgatherdd { }

  class Vpgatherdq extends Instruction, @vpgatherdq { }

  class Vpgatherqd extends Instruction, @vpgatherqd { }

  class Vpgatherqq extends Instruction, @vpgatherqq { }

  class Vphaddbd extends Instruction, @vphaddbd { }

  class Vphaddbq extends Instruction, @vphaddbq { }

  class Vphaddbw extends Instruction, @vphaddbw { }

  class Vphaddd extends Instruction, @vphaddd { }

  class Vphadddq extends Instruction, @vphadddq { }

  class Vphaddsw extends Instruction, @vphaddsw { }

  class Vphaddubd extends Instruction, @vphaddubd { }

  class Vphaddubq extends Instruction, @vphaddubq { }

  class Vphaddubw extends Instruction, @vphaddubw { }

  class Vphaddudq extends Instruction, @vphaddudq { }

  class Vphadduwd extends Instruction, @vphadduwd { }

  class Vphadduwq extends Instruction, @vphadduwq { }

  class Vphaddw extends Instruction, @vphaddw { }

  class Vphaddwd extends Instruction, @vphaddwd { }

  class Vphaddwq extends Instruction, @vphaddwq { }

  class Vphminposuw extends Instruction, @vphminposuw { }

  class Vphsubbw extends Instruction, @vphsubbw { }

  class Vphsubd extends Instruction, @vphsubd { }

  class Vphsubdq extends Instruction, @vphsubdq { }

  class Vphsubsw extends Instruction, @vphsubsw { }

  class Vphsubw extends Instruction, @vphsubw { }

  class Vphsubwd extends Instruction, @vphsubwd { }

  class Vpinsrb extends Instruction, @vpinsrb { }

  class Vpinsrd extends Instruction, @vpinsrd { }

  class Vpinsrq extends Instruction, @vpinsrq { }

  class Vpinsrw extends Instruction, @vpinsrw { }

  class Vplzcntd extends Instruction, @vplzcntd { }

  class Vplzcntq extends Instruction, @vplzcntq { }

  class Vpmacsdd extends Instruction, @vpmacsdd { }

  class Vpmacsdqh extends Instruction, @vpmacsdqh { }

  class Vpmacsdql extends Instruction, @vpmacsdql { }

  class Vpmacssdd extends Instruction, @vpmacssdd { }

  class Vpmacssdqh extends Instruction, @vpmacssdqh { }

  class Vpmacssdql extends Instruction, @vpmacssdql { }

  class Vpmacsswd extends Instruction, @vpmacsswd { }

  class Vpmacssww extends Instruction, @vpmacssww { }

  class Vpmacswd extends Instruction, @vpmacswd { }

  class Vpmacsww extends Instruction, @vpmacsww { }

  class Vpmadcsswd extends Instruction, @vpmadcsswd { }

  class Vpmadcswd extends Instruction, @vpmadcswd { }

  class Vpmadd231D extends Instruction, @vpmadd231d { }

  class Vpmadd233D extends Instruction, @vpmadd233d { }

  class Vpmadd52Huq extends Instruction, @vpmadd52huq { }

  class Vpmadd52Luq extends Instruction, @vpmadd52luq { }

  class Vpmaddubsw extends Instruction, @vpmaddubsw { }

  class Vpmaddwd extends Instruction, @vpmaddwd { }

  class Vpmaskmovd extends Instruction, @vpmaskmovd { }

  class Vpmaskmovq extends Instruction, @vpmaskmovq { }

  class Vpmaxsb extends Instruction, @vpmaxsb { }

  class Vpmaxsd extends Instruction, @vpmaxsd { }

  class Vpmaxsq extends Instruction, @vpmaxsq { }

  class Vpmaxsw extends Instruction, @vpmaxsw { }

  class Vpmaxub extends Instruction, @vpmaxub { }

  class Vpmaxud extends Instruction, @vpmaxud { }

  class Vpmaxuq extends Instruction, @vpmaxuq { }

  class Vpmaxuw extends Instruction, @vpmaxuw { }

  class Vpminsb extends Instruction, @vpminsb { }

  class Vpminsd extends Instruction, @vpminsd { }

  class Vpminsq extends Instruction, @vpminsq { }

  class Vpminsw extends Instruction, @vpminsw { }

  class Vpminub extends Instruction, @vpminub { }

  class Vpminud extends Instruction, @vpminud { }

  class Vpminuq extends Instruction, @vpminuq { }

  class Vpminuw extends Instruction, @vpminuw { }

  class Vpmovb2M extends Instruction, @vpmovb2m { }

  class Vpmovd2M extends Instruction, @vpmovd2m { }

  class Vpmovdb extends Instruction, @vpmovdb { }

  class Vpmovdw extends Instruction, @vpmovdw { }

  class Vpmovm2B extends Instruction, @vpmovm2b { }

  class Vpmovm2D extends Instruction, @vpmovm2d { }

  class Vpmovm2Q extends Instruction, @vpmovm2q { }

  class Vpmovm2W extends Instruction, @vpmovm2w { }

  class Vpmovmskb extends Instruction, @vpmovmskb { }

  class Vpmovq2M extends Instruction, @vpmovq2m { }

  class Vpmovqb extends Instruction, @vpmovqb { }

  class Vpmovqd extends Instruction, @vpmovqd { }

  class Vpmovqw extends Instruction, @vpmovqw { }

  class Vpmovsdb extends Instruction, @vpmovsdb { }

  class Vpmovsdw extends Instruction, @vpmovsdw { }

  class Vpmovsqb extends Instruction, @vpmovsqb { }

  class Vpmovsqd extends Instruction, @vpmovsqd { }

  class Vpmovsqw extends Instruction, @vpmovsqw { }

  class Vpmovswb extends Instruction, @vpmovswb { }

  class Vpmovsxbd extends Instruction, @vpmovsxbd { }

  class Vpmovsxbq extends Instruction, @vpmovsxbq { }

  class Vpmovsxbw extends Instruction, @vpmovsxbw { }

  class Vpmovsxdq extends Instruction, @vpmovsxdq { }

  class Vpmovsxwd extends Instruction, @vpmovsxwd { }

  class Vpmovsxwq extends Instruction, @vpmovsxwq { }

  class Vpmovusdb extends Instruction, @vpmovusdb { }

  class Vpmovusdw extends Instruction, @vpmovusdw { }

  class Vpmovusqb extends Instruction, @vpmovusqb { }

  class Vpmovusqd extends Instruction, @vpmovusqd { }

  class Vpmovusqw extends Instruction, @vpmovusqw { }

  class Vpmovuswb extends Instruction, @vpmovuswb { }

  class Vpmovw2M extends Instruction, @vpmovw2m { }

  class Vpmovwb extends Instruction, @vpmovwb { }

  class Vpmovzxbd extends Instruction, @vpmovzxbd { }

  class Vpmovzxbq extends Instruction, @vpmovzxbq { }

  class Vpmovzxbw extends Instruction, @vpmovzxbw { }

  class Vpmovzxdq extends Instruction, @vpmovzxdq { }

  class Vpmovzxwd extends Instruction, @vpmovzxwd { }

  class Vpmovzxwq extends Instruction, @vpmovzxwq { }

  class Vpmuldq extends Instruction, @vpmuldq { }

  class Vpmulhd extends Instruction, @vpmulhd { }

  class Vpmulhrsw extends Instruction, @vpmulhrsw { }

  class Vpmulhud extends Instruction, @vpmulhud { }

  class Vpmulhuw extends Instruction, @vpmulhuw { }

  class Vpmulhw extends Instruction, @vpmulhw { }

  class Vpmulld extends Instruction, @vpmulld { }

  class Vpmullq extends Instruction, @vpmullq { }

  class Vpmullw extends Instruction, @vpmullw { }

  class Vpmultishiftqb extends Instruction, @vpmultishiftqb { }

  class Vpmuludq extends Instruction, @vpmuludq { }

  class Vpopcntb extends Instruction, @vpopcntb { }

  class Vpopcntd extends Instruction, @vpopcntd { }

  class Vpopcntq extends Instruction, @vpopcntq { }

  class Vpopcntw extends Instruction, @vpopcntw { }

  class Vpor extends Instruction, @vpor { }

  class Vpord extends Instruction, @vpord { }

  class Vporq extends Instruction, @vporq { }

  class Vpperm extends Instruction, @vpperm { }

  class Vprefetch0 extends Instruction, @vprefetch0 { }

  class Vprefetch1 extends Instruction, @vprefetch1 { }

  class Vprefetch2 extends Instruction, @vprefetch2 { }

  class Vprefetche0 extends Instruction, @vprefetche0 { }

  class Vprefetche1 extends Instruction, @vprefetche1 { }

  class Vprefetche2 extends Instruction, @vprefetche2 { }

  class Vprefetchenta extends Instruction, @vprefetchenta { }

  class Vprefetchnta extends Instruction, @vprefetchnta { }

  class Vprold extends Instruction, @vprold { }

  class Vprolq extends Instruction, @vprolq { }

  class Vprolvd extends Instruction, @vprolvd { }

  class Vprolvq extends Instruction, @vprolvq { }

  class Vprord extends Instruction, @vprord { }

  class Vprorq extends Instruction, @vprorq { }

  class Vprorvd extends Instruction, @vprorvd { }

  class Vprorvq extends Instruction, @vprorvq { }

  class Vprotb extends Instruction, @vprotb { }

  class Vprotd extends Instruction, @vprotd { }

  class Vprotq extends Instruction, @vprotq { }

  class Vprotw extends Instruction, @vprotw { }

  class Vpsadbw extends Instruction, @vpsadbw { }

  class Vpsbbd extends Instruction, @vpsbbd { }

  class Vpsbbrd extends Instruction, @vpsbbrd { }

  class Vpscatterdd extends Instruction, @vpscatterdd { }

  class Vpscatterdq extends Instruction, @vpscatterdq { }

  class Vpscatterqd extends Instruction, @vpscatterqd { }

  class Vpscatterqq extends Instruction, @vpscatterqq { }

  class Vpshab extends Instruction, @vpshab { }

  class Vpshad extends Instruction, @vpshad { }

  class Vpshaq extends Instruction, @vpshaq { }

  class Vpshaw extends Instruction, @vpshaw { }

  class Vpshlb extends Instruction, @vpshlb { }

  class Vpshld extends Instruction, @vpshld { }

  class Vpshldd extends Instruction, @vpshldd { }

  class Vpshldq extends Instruction, @vpshldq { }

  class Vpshldvd extends Instruction, @vpshldvd { }

  class Vpshldvq extends Instruction, @vpshldvq { }

  class Vpshldvw extends Instruction, @vpshldvw { }

  class Vpshldw extends Instruction, @vpshldw { }

  class Vpshlq extends Instruction, @vpshlq { }

  class Vpshlw extends Instruction, @vpshlw { }

  class Vpshrdd extends Instruction, @vpshrdd { }

  class Vpshrdq extends Instruction, @vpshrdq { }

  class Vpshrdvd extends Instruction, @vpshrdvd { }

  class Vpshrdvq extends Instruction, @vpshrdvq { }

  class Vpshrdvw extends Instruction, @vpshrdvw { }

  class Vpshrdw extends Instruction, @vpshrdw { }

  class Vpshufb extends Instruction, @vpshufb { }

  class Vpshufbitqmb extends Instruction, @vpshufbitqmb { }

  class Vpshufd extends Instruction, @vpshufd { }

  class Vpshufhw extends Instruction, @vpshufhw { }

  class Vpshuflw extends Instruction, @vpshuflw { }

  class Vpsignb extends Instruction, @vpsignb { }

  class Vpsignd extends Instruction, @vpsignd { }

  class Vpsignw extends Instruction, @vpsignw { }

  class Vpslld extends Instruction, @vpslld { }

  class Vpslldq extends Instruction, @vpslldq { }

  class Vpsllq extends Instruction, @vpsllq { }

  class Vpsllvd extends Instruction, @vpsllvd { }

  class Vpsllvq extends Instruction, @vpsllvq { }

  class Vpsllvw extends Instruction, @vpsllvw { }

  class Vpsllw extends Instruction, @vpsllw { }

  class Vpsrad extends Instruction, @vpsrad { }

  class Vpsraq extends Instruction, @vpsraq { }

  class Vpsravd extends Instruction, @vpsravd { }

  class Vpsravq extends Instruction, @vpsravq { }

  class Vpsravw extends Instruction, @vpsravw { }

  class Vpsraw extends Instruction, @vpsraw { }

  class Vpsrld extends Instruction, @vpsrld { }

  class Vpsrldq extends Instruction, @vpsrldq { }

  class Vpsrlq extends Instruction, @vpsrlq { }

  class Vpsrlvd extends Instruction, @vpsrlvd { }

  class Vpsrlvq extends Instruction, @vpsrlvq { }

  class Vpsrlvw extends Instruction, @vpsrlvw { }

  class Vpsrlw extends Instruction, @vpsrlw { }

  class Vpsubb extends Instruction, @vpsubb { }

  class Vpsubd extends Instruction, @vpsubd { }

  class Vpsubq extends Instruction, @vpsubq { }

  class Vpsubrd extends Instruction, @vpsubrd { }

  class Vpsubrsetbd extends Instruction, @vpsubrsetbd { }

  class Vpsubsb extends Instruction, @vpsubsb { }

  class Vpsubsetbd extends Instruction, @vpsubsetbd { }

  class Vpsubsw extends Instruction, @vpsubsw { }

  class Vpsubusb extends Instruction, @vpsubusb { }

  class Vpsubusw extends Instruction, @vpsubusw { }

  class Vpsubw extends Instruction, @vpsubw { }

  class Vpternlogd extends Instruction, @vpternlogd { }

  class Vpternlogq extends Instruction, @vpternlogq { }

  class Vptest extends Instruction, @vptest { }

  class Vptestmb extends Instruction, @vptestmb { }

  class Vptestmd extends Instruction, @vptestmd { }

  class Vptestmq extends Instruction, @vptestmq { }

  class Vptestmw extends Instruction, @vptestmw { }

  class Vptestnmb extends Instruction, @vptestnmb { }

  class Vptestnmd extends Instruction, @vptestnmd { }

  class Vptestnmq extends Instruction, @vptestnmq { }

  class Vptestnmw extends Instruction, @vptestnmw { }

  class Vpunpckhbw extends Instruction, @vpunpckhbw { }

  class Vpunpckhdq extends Instruction, @vpunpckhdq { }

  class Vpunpckhqdq extends Instruction, @vpunpckhqdq { }

  class Vpunpckhwd extends Instruction, @vpunpckhwd { }

  class Vpunpcklbw extends Instruction, @vpunpcklbw { }

  class Vpunpckldq extends Instruction, @vpunpckldq { }

  class Vpunpcklqdq extends Instruction, @vpunpcklqdq { }

  class Vpunpcklwd extends Instruction, @vpunpcklwd { }

  class Vpxor extends Instruction, @vpxor { }

  class Vpxord extends Instruction, @vpxord { }

  class Vpxorq extends Instruction, @vpxorq { }

  class Vrangepd extends Instruction, @vrangepd { }

  class Vrangeps extends Instruction, @vrangeps { }

  class Vrangesd extends Instruction, @vrangesd { }

  class Vrangess extends Instruction, @vrangess { }

  class Vrcp14Pd extends Instruction, @vrcp14pd { }

  class Vrcp14Ps extends Instruction, @vrcp14ps { }

  class Vrcp14Sd extends Instruction, @vrcp14sd { }

  class Vrcp14Ss extends Instruction, @vrcp14ss { }

  class Vrcp23Ps extends Instruction, @vrcp23ps { }

  class Vrcp28Pd extends Instruction, @vrcp28pd { }

  class Vrcp28Ps extends Instruction, @vrcp28ps { }

  class Vrcp28Sd extends Instruction, @vrcp28sd { }

  class Vrcp28Ss extends Instruction, @vrcp28ss { }

  class Vrcpph extends Instruction, @vrcpph { }

  class Vrcpps extends Instruction, @vrcpps { }

  class Vrcpsh extends Instruction, @vrcpsh { }

  class Vrcpss extends Instruction, @vrcpss { }

  class Vreducepd extends Instruction, @vreducepd { }

  class Vreduceph extends Instruction, @vreduceph { }

  class Vreduceps extends Instruction, @vreduceps { }

  class Vreducesd extends Instruction, @vreducesd { }

  class Vreducesh extends Instruction, @vreducesh { }

  class Vreducess extends Instruction, @vreducess { }

  class Vrndfxpntpd extends Instruction, @vrndfxpntpd { }

  class Vrndfxpntps extends Instruction, @vrndfxpntps { }

  class Vrndscalepd extends Instruction, @vrndscalepd { }

  class Vrndscaleph extends Instruction, @vrndscaleph { }

  class Vrndscaleps extends Instruction, @vrndscaleps { }

  class Vrndscalesd extends Instruction, @vrndscalesd { }

  class Vrndscalesh extends Instruction, @vrndscalesh { }

  class Vrndscaless extends Instruction, @vrndscaless { }

  class Vroundpd extends Instruction, @vroundpd { }

  class Vroundps extends Instruction, @vroundps { }

  class Vroundsd extends Instruction, @vroundsd { }

  class Vroundss extends Instruction, @vroundss { }

  class Vrsqrt14Pd extends Instruction, @vrsqrt14pd { }

  class Vrsqrt14Ps extends Instruction, @vrsqrt14ps { }

  class Vrsqrt14Sd extends Instruction, @vrsqrt14sd { }

  class Vrsqrt14Ss extends Instruction, @vrsqrt14ss { }

  class Vrsqrt23Ps extends Instruction, @vrsqrt23ps { }

  class Vrsqrt28Pd extends Instruction, @vrsqrt28pd { }

  class Vrsqrt28Ps extends Instruction, @vrsqrt28ps { }

  class Vrsqrt28Sd extends Instruction, @vrsqrt28sd { }

  class Vrsqrt28Ss extends Instruction, @vrsqrt28ss { }

  class Vrsqrtph extends Instruction, @vrsqrtph { }

  class Vrsqrtps extends Instruction, @vrsqrtps { }

  class Vrsqrtsh extends Instruction, @vrsqrtsh { }

  class Vrsqrtss extends Instruction, @vrsqrtss { }

  class Vscalefpd extends Instruction, @vscalefpd { }

  class Vscalefph extends Instruction, @vscalefph { }

  class Vscalefps extends Instruction, @vscalefps { }

  class Vscalefsd extends Instruction, @vscalefsd { }

  class Vscalefsh extends Instruction, @vscalefsh { }

  class Vscalefss extends Instruction, @vscalefss { }

  class Vscaleps extends Instruction, @vscaleps { }

  class Vscatterdpd extends Instruction, @vscatterdpd { }

  class Vscatterdps extends Instruction, @vscatterdps { }

  class Vscatterpf0Dpd extends Instruction, @vscatterpf0dpd { }

  class Vscatterpf0Dps extends Instruction, @vscatterpf0dps { }

  class Vscatterpf0Hintdpd extends Instruction, @vscatterpf0hintdpd { }

  class Vscatterpf0Hintdps extends Instruction, @vscatterpf0hintdps { }

  class Vscatterpf0Qpd extends Instruction, @vscatterpf0qpd { }

  class Vscatterpf0Qps extends Instruction, @vscatterpf0qps { }

  class Vscatterpf1Dpd extends Instruction, @vscatterpf1dpd { }

  class Vscatterpf1Dps extends Instruction, @vscatterpf1dps { }

  class Vscatterpf1Qpd extends Instruction, @vscatterpf1qpd { }

  class Vscatterpf1Qps extends Instruction, @vscatterpf1qps { }

  class Vscatterqpd extends Instruction, @vscatterqpd { }

  class Vscatterqps extends Instruction, @vscatterqps { }

  class Vsha512Msg1 extends Instruction, @vsha512msg1 { }

  class Vsha512Msg2 extends Instruction, @vsha512msg2 { }

  class Vsha512Rnds2 extends Instruction, @vsha512rnds2 { }

  class Vshuff32X4 extends Instruction, @vshuff32x4 { }

  class Vshuff64X2 extends Instruction, @vshuff64x2 { }

  class Vshufi32X4 extends Instruction, @vshufi32x4 { }

  class Vshufi64X2 extends Instruction, @vshufi64x2 { }

  class Vshufpd extends Instruction, @vshufpd { }

  class Vshufps extends Instruction, @vshufps { }

  class Vsm3Msg1 extends Instruction, @vsm3msg1 { }

  class Vsm3Msg2 extends Instruction, @vsm3msg2 { }

  class Vsm3Rnds2 extends Instruction, @vsm3rnds2 { }

  class Vsm4Key4 extends Instruction, @vsm4key4 { }

  class Vsm4Rnds4 extends Instruction, @vsm4rnds4 { }

  class Vsqrtpd extends Instruction, @vsqrtpd { }

  class Vsqrtph extends Instruction, @vsqrtph { }

  class Vsqrtps extends Instruction, @vsqrtps { }

  class Vsqrtsd extends Instruction, @vsqrtsd { }

  class Vsqrtsh extends Instruction, @vsqrtsh { }

  class Vsqrtss extends Instruction, @vsqrtss { }

  class Vstmxcsr extends Instruction, @vstmxcsr { }

  class Vsubpd extends Instruction, @vsubpd { }

  class Vsubph extends Instruction, @vsubph { }

  class Vsubps extends Instruction, @vsubps { }

  class Vsubrpd extends Instruction, @vsubrpd { }

  class Vsubrps extends Instruction, @vsubrps { }

  class Vsubsd extends Instruction, @vsubsd { }

  class Vsubsh extends Instruction, @vsubsh { }

  class Vsubss extends Instruction, @vsubss { }

  class Vtestpd extends Instruction, @vtestpd { }

  class Vtestps extends Instruction, @vtestps { }

  class Vucomisd extends Instruction, @vucomisd { }

  class Vucomish extends Instruction, @vucomish { }

  class Vucomiss extends Instruction, @vucomiss { }

  class Vunpckhpd extends Instruction, @vunpckhpd { }

  class Vunpckhps extends Instruction, @vunpckhps { }

  class Vunpcklpd extends Instruction, @vunpcklpd { }

  class Vunpcklps extends Instruction, @vunpcklps { }

  class Vxorpd extends Instruction, @vxorpd { }

  class Vxorps extends Instruction, @vxorps { }

  class Vzeroall extends Instruction, @vzeroall { }

  class Vzeroupper extends Instruction, @vzeroupper { }

  class Wbinvd extends Instruction, @wbinvd { }

  class Wrfsbase extends Instruction, @wrfsbase { }

  class Wrgsbase extends Instruction, @wrgsbase { }

  class Wrmsr extends Instruction, @wrmsr { }

  class Wrmsrlist extends Instruction, @wrmsrlist { }

  class Wrmsrns extends Instruction, @wrmsrns { }

  class Wrpkru extends Instruction, @wrpkru { }

  class Wrssd extends Instruction, @wrssd { }

  class Wrssq extends Instruction, @wrssq { }

  class Wrussd extends Instruction, @wrussd { }

  class Wrussq extends Instruction, @wrussq { }

  class Xabort extends Instruction, @xabort { }

  class Xadd extends Instruction, @xadd { }

  class Xbegin extends Instruction, @xbegin { }

  class Xchg extends Instruction, @xchg { }

  class XcryptCbc extends Instruction, @xcryptcbc { }

  class XcryptCfb extends Instruction, @xcryptcfb { }

  class XcryptCtr extends Instruction, @xcryptctr { }

  class XcryptEcb extends Instruction, @xcryptecb { }

  class XcryptOfb extends Instruction, @xcryptofb { }

  class Xend extends Instruction, @xend { }

  class Xgetbv extends Instruction, @xgetbv { }

  class Xlat extends Instruction, @xlat { }

  class Xor extends Instruction, @xor { }

  class Xorpd extends Instruction, @xorpd { }

  class Xorps extends Instruction, @xorps { }

  class Xresldtrk extends Instruction, @xresldtrk { }

  class Xrstor extends Instruction, @xrstor { }

  class Xrstor64 extends Instruction, @xrstor64 { }

  class Xrstors extends Instruction, @xrstors { }

  class Xrstors64 extends Instruction, @xrstors64 { }

  class Xsave extends Instruction, @xsave { }

  class Xsave64 extends Instruction, @xsave64 { }

  class Xsavec extends Instruction, @xsavec { }

  class Xsavec64 extends Instruction, @xsavec64 { }

  class Xsaveopt extends Instruction, @xsaveopt { }

  class Xsaveopt64 extends Instruction, @xsaveopt64 { }

  class Xsaves extends Instruction, @xsaves { }

  class Xsaves64 extends Instruction, @xsaves64 { }

  class Xsetbv extends Instruction, @xsetbv { }

  class Xsha1 extends Instruction, @xsha1 { }

  class Xsha256 extends Instruction, @xsha256 { }

  class Xstore extends Instruction, @xstore { }

  class Xsusldtrk extends Instruction, @xsusldtrk { }

  class Xtest extends Instruction, @xtest { }
}

private module InstructionInput0 implements InstructionInputSig {
  class BaseInstruction extends @instruction {
    string toString() { instruction_string(this, result) }
  }
}

import MakeInstructions<InstructionInput0>
