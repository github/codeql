// This file contains auto-generated code.

namespace System
{
    namespace Reflection
    {
        namespace Emit
        {
            // Generated from `System.Reflection.Emit.FlowControl` in `System.Reflection.Primitives, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public enum FlowControl
            {
                Branch,
                Break,
                Call,
                Cond_Branch,
                Meta,
                Next,
                Phi,
                Return,
                Throw,
            }

            // Generated from `System.Reflection.Emit.OpCode` in `System.Reflection.Primitives, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public struct OpCode : System.IEquatable<System.Reflection.Emit.OpCode>
            {
                public static bool operator !=(System.Reflection.Emit.OpCode a, System.Reflection.Emit.OpCode b) => throw null;
                public static bool operator ==(System.Reflection.Emit.OpCode a, System.Reflection.Emit.OpCode b) => throw null;
                public bool Equals(System.Reflection.Emit.OpCode obj) => throw null;
                public override bool Equals(object obj) => throw null;
                public System.Reflection.Emit.FlowControl FlowControl { get => throw null; }
                public override int GetHashCode() => throw null;
                public string Name { get => throw null; }
                // Stub generator skipped constructor 
                public System.Reflection.Emit.OpCodeType OpCodeType { get => throw null; }
                public System.Reflection.Emit.OperandType OperandType { get => throw null; }
                public int Size { get => throw null; }
                public System.Reflection.Emit.StackBehaviour StackBehaviourPop { get => throw null; }
                public System.Reflection.Emit.StackBehaviour StackBehaviourPush { get => throw null; }
                public override string ToString() => throw null;
                public System.Int16 Value { get => throw null; }
            }

            // Generated from `System.Reflection.Emit.OpCodeType` in `System.Reflection.Primitives, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public enum OpCodeType
            {
                Annotation,
                Macro,
                Nternal,
                Objmodel,
                Prefix,
                Primitive,
            }

            // Generated from `System.Reflection.Emit.OpCodes` in `System.Reflection.Primitives, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class OpCodes
            {
                public static System.Reflection.Emit.OpCode Add;
                public static System.Reflection.Emit.OpCode Add_Ovf;
                public static System.Reflection.Emit.OpCode Add_Ovf_Un;
                public static System.Reflection.Emit.OpCode And;
                public static System.Reflection.Emit.OpCode Arglist;
                public static System.Reflection.Emit.OpCode Beq;
                public static System.Reflection.Emit.OpCode Beq_S;
                public static System.Reflection.Emit.OpCode Bge;
                public static System.Reflection.Emit.OpCode Bge_S;
                public static System.Reflection.Emit.OpCode Bge_Un;
                public static System.Reflection.Emit.OpCode Bge_Un_S;
                public static System.Reflection.Emit.OpCode Bgt;
                public static System.Reflection.Emit.OpCode Bgt_S;
                public static System.Reflection.Emit.OpCode Bgt_Un;
                public static System.Reflection.Emit.OpCode Bgt_Un_S;
                public static System.Reflection.Emit.OpCode Ble;
                public static System.Reflection.Emit.OpCode Ble_S;
                public static System.Reflection.Emit.OpCode Ble_Un;
                public static System.Reflection.Emit.OpCode Ble_Un_S;
                public static System.Reflection.Emit.OpCode Blt;
                public static System.Reflection.Emit.OpCode Blt_S;
                public static System.Reflection.Emit.OpCode Blt_Un;
                public static System.Reflection.Emit.OpCode Blt_Un_S;
                public static System.Reflection.Emit.OpCode Bne_Un;
                public static System.Reflection.Emit.OpCode Bne_Un_S;
                public static System.Reflection.Emit.OpCode Box;
                public static System.Reflection.Emit.OpCode Br;
                public static System.Reflection.Emit.OpCode Br_S;
                public static System.Reflection.Emit.OpCode Break;
                public static System.Reflection.Emit.OpCode Brfalse;
                public static System.Reflection.Emit.OpCode Brfalse_S;
                public static System.Reflection.Emit.OpCode Brtrue;
                public static System.Reflection.Emit.OpCode Brtrue_S;
                public static System.Reflection.Emit.OpCode Call;
                public static System.Reflection.Emit.OpCode Calli;
                public static System.Reflection.Emit.OpCode Callvirt;
                public static System.Reflection.Emit.OpCode Castclass;
                public static System.Reflection.Emit.OpCode Ceq;
                public static System.Reflection.Emit.OpCode Cgt;
                public static System.Reflection.Emit.OpCode Cgt_Un;
                public static System.Reflection.Emit.OpCode Ckfinite;
                public static System.Reflection.Emit.OpCode Clt;
                public static System.Reflection.Emit.OpCode Clt_Un;
                public static System.Reflection.Emit.OpCode Constrained;
                public static System.Reflection.Emit.OpCode Conv_I;
                public static System.Reflection.Emit.OpCode Conv_I1;
                public static System.Reflection.Emit.OpCode Conv_I2;
                public static System.Reflection.Emit.OpCode Conv_I4;
                public static System.Reflection.Emit.OpCode Conv_I8;
                public static System.Reflection.Emit.OpCode Conv_Ovf_I;
                public static System.Reflection.Emit.OpCode Conv_Ovf_I1;
                public static System.Reflection.Emit.OpCode Conv_Ovf_I1_Un;
                public static System.Reflection.Emit.OpCode Conv_Ovf_I2;
                public static System.Reflection.Emit.OpCode Conv_Ovf_I2_Un;
                public static System.Reflection.Emit.OpCode Conv_Ovf_I4;
                public static System.Reflection.Emit.OpCode Conv_Ovf_I4_Un;
                public static System.Reflection.Emit.OpCode Conv_Ovf_I8;
                public static System.Reflection.Emit.OpCode Conv_Ovf_I8_Un;
                public static System.Reflection.Emit.OpCode Conv_Ovf_I_Un;
                public static System.Reflection.Emit.OpCode Conv_Ovf_U;
                public static System.Reflection.Emit.OpCode Conv_Ovf_U1;
                public static System.Reflection.Emit.OpCode Conv_Ovf_U1_Un;
                public static System.Reflection.Emit.OpCode Conv_Ovf_U2;
                public static System.Reflection.Emit.OpCode Conv_Ovf_U2_Un;
                public static System.Reflection.Emit.OpCode Conv_Ovf_U4;
                public static System.Reflection.Emit.OpCode Conv_Ovf_U4_Un;
                public static System.Reflection.Emit.OpCode Conv_Ovf_U8;
                public static System.Reflection.Emit.OpCode Conv_Ovf_U8_Un;
                public static System.Reflection.Emit.OpCode Conv_Ovf_U_Un;
                public static System.Reflection.Emit.OpCode Conv_R4;
                public static System.Reflection.Emit.OpCode Conv_R8;
                public static System.Reflection.Emit.OpCode Conv_R_Un;
                public static System.Reflection.Emit.OpCode Conv_U;
                public static System.Reflection.Emit.OpCode Conv_U1;
                public static System.Reflection.Emit.OpCode Conv_U2;
                public static System.Reflection.Emit.OpCode Conv_U4;
                public static System.Reflection.Emit.OpCode Conv_U8;
                public static System.Reflection.Emit.OpCode Cpblk;
                public static System.Reflection.Emit.OpCode Cpobj;
                public static System.Reflection.Emit.OpCode Div;
                public static System.Reflection.Emit.OpCode Div_Un;
                public static System.Reflection.Emit.OpCode Dup;
                public static System.Reflection.Emit.OpCode Endfilter;
                public static System.Reflection.Emit.OpCode Endfinally;
                public static System.Reflection.Emit.OpCode Initblk;
                public static System.Reflection.Emit.OpCode Initobj;
                public static System.Reflection.Emit.OpCode Isinst;
                public static System.Reflection.Emit.OpCode Jmp;
                public static System.Reflection.Emit.OpCode Ldarg;
                public static System.Reflection.Emit.OpCode Ldarg_0;
                public static System.Reflection.Emit.OpCode Ldarg_1;
                public static System.Reflection.Emit.OpCode Ldarg_2;
                public static System.Reflection.Emit.OpCode Ldarg_3;
                public static System.Reflection.Emit.OpCode Ldarg_S;
                public static System.Reflection.Emit.OpCode Ldarga;
                public static System.Reflection.Emit.OpCode Ldarga_S;
                public static System.Reflection.Emit.OpCode Ldc_I4;
                public static System.Reflection.Emit.OpCode Ldc_I4_0;
                public static System.Reflection.Emit.OpCode Ldc_I4_1;
                public static System.Reflection.Emit.OpCode Ldc_I4_2;
                public static System.Reflection.Emit.OpCode Ldc_I4_3;
                public static System.Reflection.Emit.OpCode Ldc_I4_4;
                public static System.Reflection.Emit.OpCode Ldc_I4_5;
                public static System.Reflection.Emit.OpCode Ldc_I4_6;
                public static System.Reflection.Emit.OpCode Ldc_I4_7;
                public static System.Reflection.Emit.OpCode Ldc_I4_8;
                public static System.Reflection.Emit.OpCode Ldc_I4_M1;
                public static System.Reflection.Emit.OpCode Ldc_I4_S;
                public static System.Reflection.Emit.OpCode Ldc_I8;
                public static System.Reflection.Emit.OpCode Ldc_R4;
                public static System.Reflection.Emit.OpCode Ldc_R8;
                public static System.Reflection.Emit.OpCode Ldelem;
                public static System.Reflection.Emit.OpCode Ldelem_I;
                public static System.Reflection.Emit.OpCode Ldelem_I1;
                public static System.Reflection.Emit.OpCode Ldelem_I2;
                public static System.Reflection.Emit.OpCode Ldelem_I4;
                public static System.Reflection.Emit.OpCode Ldelem_I8;
                public static System.Reflection.Emit.OpCode Ldelem_R4;
                public static System.Reflection.Emit.OpCode Ldelem_R8;
                public static System.Reflection.Emit.OpCode Ldelem_Ref;
                public static System.Reflection.Emit.OpCode Ldelem_U1;
                public static System.Reflection.Emit.OpCode Ldelem_U2;
                public static System.Reflection.Emit.OpCode Ldelem_U4;
                public static System.Reflection.Emit.OpCode Ldelema;
                public static System.Reflection.Emit.OpCode Ldfld;
                public static System.Reflection.Emit.OpCode Ldflda;
                public static System.Reflection.Emit.OpCode Ldftn;
                public static System.Reflection.Emit.OpCode Ldind_I;
                public static System.Reflection.Emit.OpCode Ldind_I1;
                public static System.Reflection.Emit.OpCode Ldind_I2;
                public static System.Reflection.Emit.OpCode Ldind_I4;
                public static System.Reflection.Emit.OpCode Ldind_I8;
                public static System.Reflection.Emit.OpCode Ldind_R4;
                public static System.Reflection.Emit.OpCode Ldind_R8;
                public static System.Reflection.Emit.OpCode Ldind_Ref;
                public static System.Reflection.Emit.OpCode Ldind_U1;
                public static System.Reflection.Emit.OpCode Ldind_U2;
                public static System.Reflection.Emit.OpCode Ldind_U4;
                public static System.Reflection.Emit.OpCode Ldlen;
                public static System.Reflection.Emit.OpCode Ldloc;
                public static System.Reflection.Emit.OpCode Ldloc_0;
                public static System.Reflection.Emit.OpCode Ldloc_1;
                public static System.Reflection.Emit.OpCode Ldloc_2;
                public static System.Reflection.Emit.OpCode Ldloc_3;
                public static System.Reflection.Emit.OpCode Ldloc_S;
                public static System.Reflection.Emit.OpCode Ldloca;
                public static System.Reflection.Emit.OpCode Ldloca_S;
                public static System.Reflection.Emit.OpCode Ldnull;
                public static System.Reflection.Emit.OpCode Ldobj;
                public static System.Reflection.Emit.OpCode Ldsfld;
                public static System.Reflection.Emit.OpCode Ldsflda;
                public static System.Reflection.Emit.OpCode Ldstr;
                public static System.Reflection.Emit.OpCode Ldtoken;
                public static System.Reflection.Emit.OpCode Ldvirtftn;
                public static System.Reflection.Emit.OpCode Leave;
                public static System.Reflection.Emit.OpCode Leave_S;
                public static System.Reflection.Emit.OpCode Localloc;
                public static System.Reflection.Emit.OpCode Mkrefany;
                public static System.Reflection.Emit.OpCode Mul;
                public static System.Reflection.Emit.OpCode Mul_Ovf;
                public static System.Reflection.Emit.OpCode Mul_Ovf_Un;
                public static System.Reflection.Emit.OpCode Neg;
                public static System.Reflection.Emit.OpCode Newarr;
                public static System.Reflection.Emit.OpCode Newobj;
                public static System.Reflection.Emit.OpCode Nop;
                public static System.Reflection.Emit.OpCode Not;
                public static System.Reflection.Emit.OpCode Or;
                public static System.Reflection.Emit.OpCode Pop;
                public static System.Reflection.Emit.OpCode Prefix1;
                public static System.Reflection.Emit.OpCode Prefix2;
                public static System.Reflection.Emit.OpCode Prefix3;
                public static System.Reflection.Emit.OpCode Prefix4;
                public static System.Reflection.Emit.OpCode Prefix5;
                public static System.Reflection.Emit.OpCode Prefix6;
                public static System.Reflection.Emit.OpCode Prefix7;
                public static System.Reflection.Emit.OpCode Prefixref;
                public static System.Reflection.Emit.OpCode Readonly;
                public static System.Reflection.Emit.OpCode Refanytype;
                public static System.Reflection.Emit.OpCode Refanyval;
                public static System.Reflection.Emit.OpCode Rem;
                public static System.Reflection.Emit.OpCode Rem_Un;
                public static System.Reflection.Emit.OpCode Ret;
                public static System.Reflection.Emit.OpCode Rethrow;
                public static System.Reflection.Emit.OpCode Shl;
                public static System.Reflection.Emit.OpCode Shr;
                public static System.Reflection.Emit.OpCode Shr_Un;
                public static System.Reflection.Emit.OpCode Sizeof;
                public static System.Reflection.Emit.OpCode Starg;
                public static System.Reflection.Emit.OpCode Starg_S;
                public static System.Reflection.Emit.OpCode Stelem;
                public static System.Reflection.Emit.OpCode Stelem_I;
                public static System.Reflection.Emit.OpCode Stelem_I1;
                public static System.Reflection.Emit.OpCode Stelem_I2;
                public static System.Reflection.Emit.OpCode Stelem_I4;
                public static System.Reflection.Emit.OpCode Stelem_I8;
                public static System.Reflection.Emit.OpCode Stelem_R4;
                public static System.Reflection.Emit.OpCode Stelem_R8;
                public static System.Reflection.Emit.OpCode Stelem_Ref;
                public static System.Reflection.Emit.OpCode Stfld;
                public static System.Reflection.Emit.OpCode Stind_I;
                public static System.Reflection.Emit.OpCode Stind_I1;
                public static System.Reflection.Emit.OpCode Stind_I2;
                public static System.Reflection.Emit.OpCode Stind_I4;
                public static System.Reflection.Emit.OpCode Stind_I8;
                public static System.Reflection.Emit.OpCode Stind_R4;
                public static System.Reflection.Emit.OpCode Stind_R8;
                public static System.Reflection.Emit.OpCode Stind_Ref;
                public static System.Reflection.Emit.OpCode Stloc;
                public static System.Reflection.Emit.OpCode Stloc_0;
                public static System.Reflection.Emit.OpCode Stloc_1;
                public static System.Reflection.Emit.OpCode Stloc_2;
                public static System.Reflection.Emit.OpCode Stloc_3;
                public static System.Reflection.Emit.OpCode Stloc_S;
                public static System.Reflection.Emit.OpCode Stobj;
                public static System.Reflection.Emit.OpCode Stsfld;
                public static System.Reflection.Emit.OpCode Sub;
                public static System.Reflection.Emit.OpCode Sub_Ovf;
                public static System.Reflection.Emit.OpCode Sub_Ovf_Un;
                public static System.Reflection.Emit.OpCode Switch;
                public static System.Reflection.Emit.OpCode Tailcall;
                public static bool TakesSingleByteArgument(System.Reflection.Emit.OpCode inst) => throw null;
                public static System.Reflection.Emit.OpCode Throw;
                public static System.Reflection.Emit.OpCode Unaligned;
                public static System.Reflection.Emit.OpCode Unbox;
                public static System.Reflection.Emit.OpCode Unbox_Any;
                public static System.Reflection.Emit.OpCode Volatile;
                public static System.Reflection.Emit.OpCode Xor;
            }

            // Generated from `System.Reflection.Emit.OperandType` in `System.Reflection.Primitives, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public enum OperandType
            {
                InlineBrTarget,
                InlineField,
                InlineI,
                InlineI8,
                InlineMethod,
                InlineNone,
                InlinePhi,
                InlineR,
                InlineSig,
                InlineString,
                InlineSwitch,
                InlineTok,
                InlineType,
                InlineVar,
                ShortInlineBrTarget,
                ShortInlineI,
                ShortInlineR,
                ShortInlineVar,
            }

            // Generated from `System.Reflection.Emit.PackingSize` in `System.Reflection.Primitives, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public enum PackingSize
            {
                Size1,
                Size128,
                Size16,
                Size2,
                Size32,
                Size4,
                Size64,
                Size8,
                Unspecified,
            }

            // Generated from `System.Reflection.Emit.StackBehaviour` in `System.Reflection.Primitives, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public enum StackBehaviour
            {
                Pop0,
                Pop1,
                Pop1_pop1,
                Popi,
                Popi_pop1,
                Popi_popi,
                Popi_popi8,
                Popi_popi_popi,
                Popi_popr4,
                Popi_popr8,
                Popref,
                Popref_pop1,
                Popref_popi,
                Popref_popi_pop1,
                Popref_popi_popi,
                Popref_popi_popi8,
                Popref_popi_popr4,
                Popref_popi_popr8,
                Popref_popi_popref,
                Push0,
                Push1,
                Push1_push1,
                Pushi,
                Pushi8,
                Pushr4,
                Pushr8,
                Pushref,
                Varpop,
                Varpush,
            }

        }
    }
}
