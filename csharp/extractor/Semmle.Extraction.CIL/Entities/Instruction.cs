using System;
using System.Collections.Generic;
using System.Reflection.Metadata;
using System.Reflection.Metadata.Ecma335;

namespace Semmle.Extraction.CIL.Entities
{
    /// <summary>
    /// A CIL instruction.
    /// </summary>
    internal interface IInstruction : IExtractedEntity
    {
        /// <summary>
        /// Gets the extraction products for branches.
        /// </summary>
        /// <param name="jump_table">The map from offset to instruction.</param>
        /// <returns>The extraction products.</returns>
        IEnumerable<IExtractionProduct> JumpContents(Dictionary<int, IInstruction> jump_table);
    }

    /// <summary>
    /// A CIL instruction.
    /// </summary>
    internal class Instruction : UnlabelledEntity, IInstruction
    {
        /// <summary>
        /// The additional data following the opcode, if any.
        /// </summary>
        public enum Payload
        {
            None, TypeTok, Field, Target8, Class,
            Method, Arg8, Local8, Target32, Int8,
            Int16, Int32, Int64, Float32, Float64,
            CallSiteDesc, Switch, String, Constructor, ValueType,
            Type, Arg16, Ignore8, Token, Local16, MethodRef
        }

        /// <summary>
        /// For each Payload, how many additional bytes in the bytestream need to be read.
        /// </summary>
        private static readonly int[] payloadSizes = {
            0, 4, 4, 1, 4,
            4, 1, 1, 4, 1,
            2, 4, 8, 4, 8,
            4, -1, 4, 4, 4,
            4, 2, 1, 4, 2, 4 };

        // Maps opcodes to payloads for each instruction.
        private static readonly Dictionary<ILOpCode, Payload> opPayload = new Dictionary<ILOpCode, Payload>()
        {
            { ILOpCode.Nop, Payload.None },
            { ILOpCode.Break, Payload.None },
            { ILOpCode.Ldarg_0, Payload.None },
            { ILOpCode.Ldarg_1, Payload.None },
            { ILOpCode.Ldarg_2, Payload.None },
            { ILOpCode.Ldarg_3, Payload.None },
            { ILOpCode.Ldloc_0, Payload.None },
            { ILOpCode.Ldloc_1, Payload.None },
            { ILOpCode.Ldloc_2, Payload.None },
            { ILOpCode.Ldloc_3, Payload.None },
            { ILOpCode.Stloc_0, Payload.None },
            { ILOpCode.Stloc_1, Payload.None },
            { ILOpCode.Stloc_2, Payload.None },
            { ILOpCode.Stloc_3, Payload.None },
            { ILOpCode.Ldarg_s, Payload.Arg8 },
            { ILOpCode.Ldarga_s, Payload.Arg8 },
            { ILOpCode.Starg_s, Payload.Arg8 },
            { ILOpCode.Ldloc_s, Payload.Local8 },
            { ILOpCode.Ldloca_s, Payload.Local8 },
            { ILOpCode.Stloc_s, Payload.Local8 },
            { ILOpCode.Ldnull, Payload.None },
            { ILOpCode.Ldc_i4_m1, Payload.None },
            { ILOpCode.Ldc_i4_0, Payload.None },
            { ILOpCode.Ldc_i4_1, Payload.None },
            { ILOpCode.Ldc_i4_2, Payload.None },
            { ILOpCode.Ldc_i4_3, Payload.None },
            { ILOpCode.Ldc_i4_4, Payload.None },
            { ILOpCode.Ldc_i4_5, Payload.None },
            { ILOpCode.Ldc_i4_6, Payload.None },
            { ILOpCode.Ldc_i4_7, Payload.None },
            { ILOpCode.Ldc_i4_8, Payload.None },
            { ILOpCode.Ldc_i4_s, Payload.Int8 },
            { ILOpCode.Ldc_i4, Payload.Int32 },
            { ILOpCode.Ldc_i8, Payload.Int64 },
            { ILOpCode.Ldc_r4, Payload.Float32 },
            { ILOpCode.Ldc_r8, Payload.Float64 },
            { ILOpCode.Dup, Payload.None },
            { ILOpCode.Pop, Payload.None },
            { ILOpCode.Jmp, Payload.Method },
            { ILOpCode.Call, Payload.Method },
            { ILOpCode.Calli, Payload.CallSiteDesc },
            { ILOpCode.Ret, Payload.None },
            { ILOpCode.Br_s, Payload.Target8 },
            { ILOpCode.Brfalse_s, Payload.Target8 },
            { ILOpCode.Brtrue_s, Payload.Target8 },
            { ILOpCode.Beq_s, Payload.Target8 },
            { ILOpCode.Bge_s, Payload.Target8 },
            { ILOpCode.Bgt_s, Payload.Target8 },
            { ILOpCode.Ble_s, Payload.Target8 },
            { ILOpCode.Blt_s, Payload.Target8 },
            { ILOpCode.Bne_un_s, Payload.Target8 },
            { ILOpCode.Bge_un_s, Payload.Target8 },
            { ILOpCode.Bgt_un_s, Payload.Target8 },
            { ILOpCode.Ble_un_s, Payload.Target8 },
            { ILOpCode.Blt_un_s, Payload.Target8 },
            { ILOpCode.Br, Payload.Target32 },
            { ILOpCode.Brfalse, Payload.Target32 },
            { ILOpCode.Brtrue, Payload.Target32 },
            { ILOpCode.Beq, Payload.Target32 },
            { ILOpCode.Bge, Payload.Target32 },
            { ILOpCode.Bgt, Payload.Target32 },
            { ILOpCode.Ble, Payload.Target32 },
            { ILOpCode.Blt, Payload.Target32 },
            { ILOpCode.Bne_un, Payload.Target32 },
            { ILOpCode.Bge_un, Payload.Target32 },
            { ILOpCode.Bgt_un, Payload.Target32 },
            { ILOpCode.Ble_un, Payload.Target32 },
            { ILOpCode.Blt_un, Payload.Target32 },
            { ILOpCode.Switch, Payload.Switch },
            { ILOpCode.Ldind_i1, Payload.None },
            { ILOpCode.Ldind_u1, Payload.None },
            { ILOpCode.Ldind_i2, Payload.None },
            { ILOpCode.Ldind_u2, Payload.None },
            { ILOpCode.Ldind_i4, Payload.None },
            { ILOpCode.Ldind_u4, Payload.None },
            { ILOpCode.Ldind_i8, Payload.None },
            { ILOpCode.Ldind_i, Payload.None },
            { ILOpCode.Ldind_r4, Payload.None },
            { ILOpCode.Ldind_r8, Payload.None },
            { ILOpCode.Ldind_ref, Payload.None },
            { ILOpCode.Stind_ref, Payload.None },
            { ILOpCode.Stind_i1, Payload.None },
            { ILOpCode.Stind_i2, Payload.None },
            { ILOpCode.Stind_i4, Payload.None },
            { ILOpCode.Stind_i8, Payload.None },
            { ILOpCode.Stind_r4, Payload.None },
            { ILOpCode.Stind_r8, Payload.None },
            { ILOpCode.Add, Payload.None },
            { ILOpCode.Sub, Payload.None },
            { ILOpCode.Mul, Payload.None },
            { ILOpCode.Div, Payload.None },
            { ILOpCode.Div_un, Payload.None },
            { ILOpCode.Rem, Payload.None },
            { ILOpCode.Rem_un, Payload.None },
            { ILOpCode.And, Payload.None },
            { ILOpCode.Or, Payload.None },
            { ILOpCode.Xor, Payload.None },
            { ILOpCode.Shl, Payload.None },
            { ILOpCode.Shr, Payload.None },
            { ILOpCode.Shr_un, Payload.None },
            { ILOpCode.Neg, Payload.None },
            { ILOpCode.Not, Payload.None },
            { ILOpCode.Conv_i1, Payload.None },
            { ILOpCode.Conv_i2, Payload.None },
            { ILOpCode.Conv_i4, Payload.None },
            { ILOpCode.Conv_i8, Payload.None },
            { ILOpCode.Conv_r4, Payload.None },
            { ILOpCode.Conv_r8, Payload.None },
            { ILOpCode.Conv_u4, Payload.None },
            { ILOpCode.Conv_u8, Payload.None },
            { ILOpCode.Callvirt, Payload.MethodRef },
            { ILOpCode.Cpobj, Payload.TypeTok },
            { ILOpCode.Ldobj, Payload.TypeTok },
            { ILOpCode.Ldstr, Payload.String },
            { ILOpCode.Newobj, Payload.Constructor },
            { ILOpCode.Castclass, Payload.Class },
            { ILOpCode.Isinst, Payload.Class },
            { ILOpCode.Conv_r_un, Payload.None },
            { ILOpCode.Unbox, Payload.ValueType },
            { ILOpCode.Throw, Payload.None },
            { ILOpCode.Ldfld, Payload.Field },
            { ILOpCode.Ldflda, Payload.Field },
            { ILOpCode.Stfld, Payload.Field },
            { ILOpCode.Ldsfld, Payload.Field },
            { ILOpCode.Ldsflda, Payload.Field },
            { ILOpCode.Stsfld, Payload.Field },
            { ILOpCode.Stobj, Payload.Field },
            { ILOpCode.Conv_ovf_i1_un, Payload.None },
            { ILOpCode.Conv_ovf_i2_un, Payload.None },
            { ILOpCode.Conv_ovf_i4_un, Payload.None },
            { ILOpCode.Conv_ovf_i8_un, Payload.None },
            { ILOpCode.Conv_ovf_u1_un, Payload.None },
            { ILOpCode.Conv_ovf_u2_un, Payload.None },
            { ILOpCode.Conv_ovf_u4_un, Payload.None },
            { ILOpCode.Conv_ovf_u8_un, Payload.None },
            { ILOpCode.Conv_ovf_i_un, Payload.None },
            { ILOpCode.Conv_ovf_u_un, Payload.None },
            { ILOpCode.Box, Payload.TypeTok },
            { ILOpCode.Newarr, Payload.TypeTok },
            { ILOpCode.Ldlen, Payload.None },
            { ILOpCode.Ldelema, Payload.Class },
            { ILOpCode.Ldelem_i1, Payload.None },
            { ILOpCode.Ldelem_u1, Payload.None },
            { ILOpCode.Ldelem_i2, Payload.None },
            { ILOpCode.Ldelem_u2, Payload.None },
            { ILOpCode.Ldelem_i4, Payload.None },
            { ILOpCode.Ldelem_u4, Payload.None },
            { ILOpCode.Ldelem_i8, Payload.None },
            { ILOpCode.Ldelem_i, Payload.None },
            { ILOpCode.Ldelem_r4, Payload.None },
            { ILOpCode.Ldelem_r8, Payload.None },
            { ILOpCode.Ldelem_ref, Payload.None },
            { ILOpCode.Stelem_i, Payload.None },
            { ILOpCode.Stelem_i1, Payload.None },
            { ILOpCode.Stelem_i2, Payload.None },
            { ILOpCode.Stelem_i4, Payload.None },
            { ILOpCode.Stelem_i8, Payload.None },
            { ILOpCode.Stelem_r4, Payload.None },
            { ILOpCode.Stelem_r8, Payload.None },
            { ILOpCode.Stelem_ref, Payload.None },
            { ILOpCode.Ldelem, Payload.TypeTok },
            { ILOpCode.Stelem, Payload.TypeTok },
            { ILOpCode.Unbox_any, Payload.TypeTok },
            { ILOpCode.Conv_ovf_i1, Payload.None },
            { ILOpCode.Conv_ovf_u1, Payload.None },
            { ILOpCode.Conv_ovf_i2, Payload.None },
            { ILOpCode.Conv_ovf_u2, Payload.None },
            { ILOpCode.Conv_ovf_i4, Payload.None },
            { ILOpCode.Conv_ovf_u4, Payload.None },
            { ILOpCode.Conv_ovf_i8, Payload.None },
            { ILOpCode.Conv_ovf_u8, Payload.None },
            { ILOpCode.Refanyval, Payload.Type },
            { ILOpCode.Ckfinite, Payload.None },
            { ILOpCode.Mkrefany, Payload.Class },
            { ILOpCode.Ldtoken, Payload.Token },
            { ILOpCode.Conv_u2, Payload.None },
            { ILOpCode.Conv_u1, Payload.None },
            { ILOpCode.Conv_i, Payload.None },
            { ILOpCode.Conv_ovf_i, Payload.None },
            { ILOpCode.Conv_ovf_u, Payload.None },
            { ILOpCode.Add_ovf, Payload.None },
            { ILOpCode.Add_ovf_un, Payload.None },
            { ILOpCode.Mul_ovf, Payload.None },
            { ILOpCode.Mul_ovf_un, Payload.None },
            { ILOpCode.Sub_ovf, Payload.None },
            { ILOpCode.Sub_ovf_un, Payload.None },
            { ILOpCode.Endfinally, Payload.None },
            { ILOpCode.Leave, Payload.Target32 },
            { ILOpCode.Leave_s, Payload.Target8 },
            { ILOpCode.Stind_i, Payload.None },
            { ILOpCode.Conv_u, Payload.None },
            { ILOpCode.Arglist, Payload.None },
            { ILOpCode.Ceq, Payload.None },
            { ILOpCode.Cgt, Payload.None },
            { ILOpCode.Cgt_un, Payload.None },
            { ILOpCode.Clt, Payload.None },
            { ILOpCode.Clt_un, Payload.None },
            { ILOpCode.Ldftn, Payload.Method },
            { ILOpCode.Ldvirtftn, Payload.Method },
            { ILOpCode.Ldarg, Payload.Arg16 },
            { ILOpCode.Ldarga, Payload.Arg16 },
            { ILOpCode.Starg, Payload.Arg16 },
            { ILOpCode.Ldloc, Payload.Local16 },
            { ILOpCode.Ldloca, Payload.Local16 },
            { ILOpCode.Stloc, Payload.Local16 },
            { ILOpCode.Localloc, Payload.None },
            { ILOpCode.Endfilter, Payload.None },
            { ILOpCode.Unaligned, Payload.Ignore8 },
            { ILOpCode.Volatile, Payload.None },
            { ILOpCode.Tail, Payload.None },
            { ILOpCode.Initobj, Payload.TypeTok },
            { ILOpCode.Constrained, Payload.Type },
            { ILOpCode.Cpblk, Payload.None },
            { ILOpCode.Initblk, Payload.None },
            { ILOpCode.Rethrow, Payload.None },
            { ILOpCode.Sizeof, Payload.TypeTok },
            { ILOpCode.Refanytype, Payload.None },
            { ILOpCode.Readonly, Payload.None }
        };

        public DefinitionMethod Method { get; }
        public ILOpCode OpCode { get; }
        public int Offset { get; }
        public int Index { get; }
        private readonly int payloadValue;
        private readonly uint unsignedPayloadValue;

        public Payload PayloadType
        {
            get
            {
                if (!opPayload.TryGetValue(OpCode, out var result))
                    throw new InternalError("Unknown op code " + OpCode);
                return result;
            }
        }

        public override string ToString() => Index + ": " + OpCode;

        /// <summary>
        /// The number of bytes of this instruction,
        /// including the payload (if any).
        /// </summary>
        public int Width
        {
            get
            {
                if (OpCode == ILOpCode.Switch)
                    return 5 + 4 * payloadValue;

                return ((int)OpCode > 255 ? 2 : 1) + PayloadSize;
            }
        }

        Label IEntity.Label
        {
            get; set;
        }

        private readonly byte[] data;

        private int PayloadSize => payloadSizes[(int)PayloadType];

        /// <summary>
        /// Reads the instruction from a byte stream.
        /// </summary>
        /// <param name="data">The byte stream.</param>
        /// <param name="offset">The offset of the instruction.</param>
        /// <param name="index">The index of this instruction in the callable.</param>
        public Instruction(Context cx, DefinitionMethod method, byte[] data, int offset, int index) : base(cx)
        {
            Method = method;
            Offset = offset;
            Index = index;
            this.data = data;
            int opcode = data[offset];
            ++offset;

            /*
             * An opcode is either 1 or 2 bytes, followed by an optional payload depending on the instruction.
             * Instructions where the first byte is 0xfe are 2-byte instructions.
             */
            if (opcode == 0xfe)
                opcode = opcode << 8 | data[offset++];
            OpCode = (ILOpCode)opcode;

            switch (PayloadSize)
            {
                case 0:
                    payloadValue = 0;
                    break;
                case 1:
                    payloadValue = (sbyte)data[offset];
                    unsignedPayloadValue = data[offset];
                    break;
                case 2:
                    payloadValue = BitConverter.ToInt16(data, offset);
                    unsignedPayloadValue = BitConverter.ToUInt16(data, offset);
                    break;
                case -1:    // Switch
                case 4:
                    payloadValue = BitConverter.ToInt32(data, offset);
                    break;
                case 8: // Not handled here.
                    break;
                default:
                    throw new InternalError("Unhandled CIL instruction Payload");
            }
        }

        public override IEnumerable<IExtractionProduct> Contents
        {
            get
            {
                var offset = Offset;

                if (Method.Implementation is null)
                {
                    yield break;
                }

                yield return Tuples.cil_instruction(this, (int)OpCode, Index, Method.Implementation);

                switch (PayloadType)
                {
                    case Payload.String:
                        yield return Tuples.cil_value(this, Cx.MdReader.GetUserString(MetadataTokens.UserStringHandle(payloadValue)));
                        break;
                    case Payload.Float32:
                        yield return Tuples.cil_value(this, BitConverter.ToSingle(data, offset).ToString());
                        break;
                    case Payload.Float64:
                        yield return Tuples.cil_value(this, BitConverter.ToDouble(data, offset).ToString());
                        break;
                    case Payload.Int8:
                        yield return Tuples.cil_value(this, data[offset].ToString());
                        break;
                    case Payload.Int16:
                        yield return Tuples.cil_value(this, BitConverter.ToInt16(data, offset).ToString());
                        break;
                    case Payload.Int32:
                        yield return Tuples.cil_value(this, BitConverter.ToInt32(data, offset).ToString());
                        break;
                    case Payload.Int64:
                        yield return Tuples.cil_value(this, BitConverter.ToInt64(data, offset).ToString());
                        break;
                    case Payload.Constructor:
                    case Payload.Method:
                    case Payload.MethodRef:
                    case Payload.Class:
                    case Payload.TypeTok:
                    case Payload.Token:
                    case Payload.Type:
                    case Payload.Field:
                    case Payload.ValueType:
                        // A generic EntityHandle.
                        var handle = MetadataTokens.EntityHandle(payloadValue);
                        var target = Cx.CreateGeneric(Method, handle);
                        yield return target;
                        if (target != null)
                        {
                            yield return Tuples.cil_access(this, target);
                        }
                        else
                        {
                            throw new InternalError($"Unable to create payload type {PayloadType} for opcode {OpCode}");
                        }
                        break;
                    case Payload.Arg8:
                    case Payload.Arg16:
                        if (Method.Parameters is object)
                        {
                            yield return Tuples.cil_access(this, Method.Parameters[(int)unsignedPayloadValue]);
                        }
                        break;
                    case Payload.Local8:
                    case Payload.Local16:
                        if (Method.LocalVariables is object)
                        {
                            yield return Tuples.cil_access(this, Method.LocalVariables[(int)unsignedPayloadValue]);
                        }
                        break;
                    case Payload.None:
                    case Payload.Target8:
                    case Payload.Target32:
                    case Payload.Switch:
                    case Payload.Ignore8:
                    case Payload.CallSiteDesc:
                        // These are not handled here.
                        // Some of these are handled by JumpContents().
                        break;
                    default:
                        throw new InternalError($"Unhandled payload type {PayloadType}");
                }
            }
        }

        // Called to populate the jumps in each instruction.
        public IEnumerable<IExtractionProduct> JumpContents(Dictionary<int, IInstruction> jump_table)
        {
            int target;
            IInstruction? inst;

            switch (PayloadType)
            {
                case Payload.Target8:
                    target = Offset + payloadValue + 2;
                    break;
                case Payload.Target32:
                    target = Offset + payloadValue + 5;
                    break;
                case Payload.Switch:
                    var end = Offset + Width;

                    var offset = Offset + 5;

                    for (var b = 0; b < payloadValue; ++b, offset += 4)
                    {
                        target = BitConverter.ToInt32(data, offset) + end;
                        if (jump_table.TryGetValue(target, out inst))
                        {
                            yield return Tuples.cil_switch(this, b, inst);
                        }
                        else
                        {
                            throw new InternalError("Invalid jump target");
                        }
                    }

                    yield break;
                default:
                    // Not a jump
                    yield break;
            }


            if (jump_table.TryGetValue(target, out inst))
            {
                yield return Tuples.cil_jump(this, inst);
            }
            else
            {
                // Sometimes instructions can jump outside the current method.
                // TODO: Find a solution to this.

                // For now, just log the error
                Cx.Cx.ExtractionError("A CIL instruction jumps outside the current method", "", Extraction.Entities.GeneratedLocation.Create(Cx.Cx), "", Util.Logging.Severity.Warning);
            }
        }
    }
}
