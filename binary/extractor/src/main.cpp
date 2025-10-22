extern "C"
{
#include <Zydis/Zydis.h>
#include <Zydis/SharedTypes.h>
}
#include <stdio.h>
#include <LIEF/LIEF.hpp>
#include <iostream>
#include <fstream>
#include <vector>
#include <cstdlib>
#include <utility>
#include <optional>
#include <variant>
#include <filesystem>
#include <fmt/core.h>
#include <fmt/ranges.h>
#include <boost/range/adaptor/transformed.hpp>
#include <boost/algorithm/string/replace.hpp>
#include <args.hxx>

using skip_pair = std::pair<size_t, size_t>;
using skips_t = std::vector<skip_pair>;

class Decoder
{
private:
    ZydisDecoder decoder;

public:
    Decoder()
    {
        if (ZYAN_FAILED(ZydisDecoderInit(&decoder, ZYDIS_MACHINE_MODE_LONG_64, ZYDIS_STACK_WIDTH_64)))
        {
            throw std::exception("Failed to initialize Zydis decoder");
        }
    }

    bool set_mode(ZydisDecoderMode mode)
    {
        if (ZYAN_FAILED(ZydisDecoderEnableMode(&decoder, mode, ZYAN_TRUE)))
        {
            return false;
        }
        return true;
    }

    bool unset_mode(ZydisDecoderMode mode)
    {
        if (ZYAN_FAILED(ZydisDecoderEnableMode(&decoder, mode, ZYAN_FALSE)))
        {
            return false;
        }
        return true;
    }

    template <typename Container>
    bool decode(Container &code, size_t offset, ZydisDecodedInstruction *instruction, ZydisDecodedOperand *operands)
    {
        if (ZYAN_SUCCESS(ZydisDecoderDecodeFull(&decoder, code.data() + offset, code.size() - offset, instruction, operands)))
        {
            return true;
        }
        return false;
    }
};

class Formatter
{
private:
    ZydisFormatter formatter;

public:
    Formatter()
    {
        if (ZYAN_FAILED(ZydisFormatterInit(&formatter, ZYDIS_FORMATTER_STYLE_INTEL)))
        {
            throw std::exception("Failed to initialize Zydis formatter");
        }
    }

    bool format_instruction(const ZydisDecodedInstruction &instruction, char *buffer, size_t length)
    {
        const char *mnemonic = ZydisMnemonicGetString(instruction.mnemonic);
        if (mnemonic && strlen(mnemonic) < length)
        {
            strcpy(buffer, mnemonic);
            return true;
        }
        return false;
    }

    bool format_operand(const ZydisDecodedInstruction &instruction, const ZydisDecodedOperand &operand, char *buffer, size_t length)
    {
        if (ZYAN_SUCCESS(ZydisFormatterFormatOperand(&formatter, &instruction, &operand, buffer, length, ZYDIS_RUNTIME_ADDRESS_NONE, ZYAN_NULL)))
        {

            return true;
        }
        else
        {
            return false;
        }
    }
};

using Label = unsigned;

template <class... Ts>
struct overloaded : Ts...
{
    using Ts::operator()...;
};
template <class... Ts>
overloaded(Ts...) -> overloaded<Ts...>;

class Entry
{
public:
    using MapLabelToKey = std::pair<Label, std::string>;
    class Arg
    {
    public:
        static Arg FromLabel(Label lab)
        {
            return Arg(lab);
        }

        static Arg FromInt(int n)
        {
            return Arg(n);
        }

        static Arg FromString(const std::string &s)
        {
            return Arg(s);
        }

        template <typename... F>
        auto visit(F &&...f)
        {
            return std::visit(overloaded{f...}, this->var);
        }

        template <typename... F>
        auto visit(F &&...f) const
        {
            return std::visit(overloaded{f...}, this->var);
        }

    private:
        std::variant<Label, int, std::string> var;

        Arg(const std::variant<Label, int, std::string> &var) : var(var) {}
    };
    using GenericTuple = std::pair<std::string, std::vector<Arg>>;
    using Comment = std::string;

    static Entry FromLabel(Label l)
    {
        return Entry(l);
    }

    static Entry FromMapLabelToKey(Label l, const std::string &key)
    {
        return Entry(MapLabelToKey(l, key));
    }

    template <typename... Args>
    static Entry fromGenericTuple(const std::string &t, Args &&...args)
    {
        return Entry(GenericTuple(t, {std::forward<Args>(args)...}));
    }

    static Entry FromComment(const std::string &c)
    {
        return Entry(c);
    }

    template <typename... F>
    auto visit(F &&...f)
    {
        return std::visit(overloaded{f...}, this->var);
    }

    template <typename... F>
    auto visit(F &&...f) const
    {
        return std::visit(overloaded{f...}, this->var);
    }

private:
    std::variant<Label, MapLabelToKey, GenericTuple, Comment> var;
    friend std::ostream &operator<<(std::ostream &, const Entry &);

    Entry(const std::variant<Label, MapLabelToKey, GenericTuple, Comment> &var) : var(var) {}
};

std::ostream &operator<<(std::ostream &out, const Entry &e)
{
    e.visit([&](Label label)
            { out << fmt::format("#{:x}=*", label); },
            [&](const Entry::MapLabelToKey &x)
            {
                auto [label, key] = x;
                boost::replace_all(key, "\"", "\"\"");
                out << fmt::format("{}=@\"{}\"", label, key);
            },
            [&](const Entry::GenericTuple &x)
            {
                auto [name, args] = x;

                auto string_args =
                    args |
                    boost::adaptors::transformed(
                        [](auto arg)
                        {
                            return arg.visit(
                                [](auto x)
                                {
                                    return std::to_string(x);
                                },
                                [](std::string s)
                                {
                                    boost::replace_all(s, "\"", "\"\"");
                                    return fmt::format("\"{}\"", s);
                                });
                        });
                out << fmt::format("{}({})", name, fmt::join(string_args, ","));
            },
            [&](const Entry::Comment &line)
            {
                out << fmt::format("// {}", line);
            });
    return out;
}

class TrapWriter
{
private:
    std::vector<Entry> entries;
    unsigned next;

public:
    TrapWriter() : next(0)
    {
    }
    void add(const Entry &e)
    {
        entries.push_back(e);
    }

    template <typename It>
    void add_all(It begin, It end)
    {
        std::move(begin, end, std::back_inserter(entries));
    }

    void write(std::ostream &out)
    {
        for (const auto &e : entries)
        {
            out << e << '\n';
        }
        out.flush();
    }

    Label fresh_id()
    {
        entries.push_back(Entry::FromLabel(next));
        return next++;
    }
};

class Archiver
{
    std::filesystem::path archive_dir;

public:
    Archiver() : archive_dir(getenv("CODEQL_EXTRACTOR_BINARY_SOURCE_ARCHIVE_DIR"))
    {
    }

    void archive(const std::filesystem::path &binary)
    {
        std::string p(binary.string());
        boost::replace_all(p, ":", "_");
        auto binary_in_archive_dir = archive_dir / p;
        std::filesystem::create_directories(binary_in_archive_dir.parent_path());
        std::filesystem::copy_file(binary, binary_in_archive_dir);
    }
};

Label cache[ZYDIS_REGISTER_MAX_VALUE];

template <typename Container, typename Callback>
auto register_access(TrapWriter &writer, Container &entries, ZydisRegister reg, Callback callback)
{
    if (reg == ZYDIS_REGISTER_NONE)
    {
        return;
    }
    auto id = writer.fresh_id();

    if (!cache[reg])
    {
        auto reg_id = writer.fresh_id();
        cache[reg] = reg_id;

        auto str = ZydisRegisterGetString(reg);

        entries.push_back(
            Entry::fromGenericTuple("register",
                                    Entry::Arg::FromLabel(reg_id),
                                    Entry::Arg::FromString(str)));
    }

    entries.push_back(
        Entry::fromGenericTuple("register_access",
                                Entry::Arg::FromLabel(id),
                                Entry::Arg::FromLabel(cache[reg])));

    return callback(id);
}

void encodeOffset(size_t offset, int &a, int &b)
{
    static const auto M = 4294967297ULL;

    a = offset / M;
    b = offset % M;
}

template <typename Container>
Label instruction(TrapWriter &writer, Container &entries, size_t offset, const ZydisDecodedInstruction &instr, const char *buffer)
{
    auto id = writer.fresh_id();

    auto mnemonic = instr.mnemonic;
    auto length = instr.length;

    int a, b;
    encodeOffset(offset, a, b);
    entries.push_back(
        Entry::fromGenericTuple("instruction",
                                Entry::Arg::FromLabel(id),
                                Entry::Arg::FromInt(a),
                                Entry::Arg::FromInt(b),
                                Entry::Arg::FromLabel(mnemonic))
    );

    entries.push_back(
        Entry::fromGenericTuple("instruction_length",
                                Entry::Arg::FromLabel(id),
                                Entry::Arg::FromInt(length))
    );

    entries.push_back(
        Entry::fromGenericTuple("instruction_string",
                                Entry::Arg::FromLabel(id),
                                Entry::Arg::FromString(buffer)));

    return id;
}

template<typename Container>
void operand_type(TrapWriter& writer, Container& entries, const ZydisDecodedOperand& operand, Label op_lab) {
    switch (operand.type)
    {
        case ZYDIS_OPERAND_TYPE_UNUSED:
        {
            break;
        }
        case ZYDIS_OPERAND_TYPE_REGISTER:
        {
            register_access(
                writer,
                entries,
                operand.reg.value,
                [&](auto reg)
                {
                    entries.push_back(
                        Entry::fromGenericTuple("operand_reg",
                                                Entry::Arg::FromLabel(op_lab),
                                                Entry::Arg::FromLabel(reg)));
                });
            break;
        }
        case ZYDIS_OPERAND_TYPE_MEMORY:
        {
            auto typ = operand.mem.type;
            register_access(
                writer,
                entries,
                operand.mem.segment,
                [&](auto segment)
                {
                    entries.push_back(
                        Entry::fromGenericTuple(
                            "operand_mem_segment_register",
                            Entry::Arg::FromLabel(op_lab),
                            Entry::Arg::FromLabel(segment)));
                });
            register_access(
                writer,
                entries,
                operand.mem.base,
                [&](auto base)
                {
                    entries.push_back(
                        Entry::fromGenericTuple(
                            "operand_mem_base_register",
                            Entry::Arg::FromLabel(op_lab),
                            Entry::Arg::FromLabel(base)));
                });
            register_access(
                writer,
                entries,
                operand.mem.index,
                [&](auto index)
                {
                    entries.push_back(
                        Entry::fromGenericTuple(
                            "operand_mem_index_register",
                            Entry::Arg::FromLabel(op_lab),
                            Entry::Arg::FromLabel(index)));
                });
            auto scale = operand.mem.scale;
            auto displacement = operand.mem.disp;
            entries.push_back(
                Entry::fromGenericTuple(
                    "operand_mem",
                    Entry::Arg::FromLabel(op_lab)));
            if (scale != 0)
            {
                entries.push_back(
                    Entry::fromGenericTuple(
                        "operand_mem_scale_factor",
                        Entry::Arg::FromLabel(op_lab),
                        Entry::Arg::FromInt(scale)));
            }

            auto size = displacement.size;
            // A size of 0 means there is no displacement
            if (size != 0)
            {
                auto value = displacement.value;
                entries.push_back(
                    Entry::fromGenericTuple(
                        "operand_mem_displacement",
                        Entry::Arg::FromLabel(op_lab),
                        Entry::Arg::FromInt(value)));
            }
            break;
        }
        case ZYDIS_OPERAND_TYPE_POINTER:
        {
            auto offset = operand.ptr.offset;
            auto segment = operand.ptr.segment;
            entries.push_back(
                Entry::fromGenericTuple(
                    "operand_ptr",
                    Entry::Arg::FromLabel(op_lab),
                    Entry::Arg::FromInt(offset),
                    Entry::Arg::FromInt(segment)));
            break;
        }
        case ZYDIS_OPERAND_TYPE_IMMEDIATE:
        {
            auto value = operand.imm.value;
            auto offset = operand.imm.offset;
            auto size = operand.imm.size;
            bool is_signed = operand.imm.is_signed;
            entries.push_back(
                Entry::fromGenericTuple(
                    "operand_imm",
                    Entry::Arg::FromLabel(op_lab),
                    Entry::Arg::FromInt(is_signed ? value.s : value.u),
                    Entry::Arg::FromInt(offset),
                    Entry::Arg::FromInt(size)));
            if (is_signed)
            {
                entries.push_back(
                    Entry::fromGenericTuple(
                        "operand_imm_is_signed",
                        Entry::Arg::FromLabel(op_lab)));
            }
            if (operand.imm.is_address)
            {
                entries.push_back(
                    Entry::fromGenericTuple(
                        "operand_imm_is_address",
                        Entry::Arg::FromLabel(op_lab)));
            }
            if (operand.imm.is_relative)
            {
                entries.push_back(
                    Entry::fromGenericTuple(
                        "operand_imm_is_relative",
                        Entry::Arg::FromLabel(op_lab)));
            }
            break;
        }
    }
}

void disassemble(TrapWriter &writer, const tcb::span<const uint8_t> &code, const std::filesystem::path &binary)
{
    Decoder decoder;
    Formatter formatter;
    Archiver archiver;

    for (size_t offset = 0; offset < code.size(); ++offset)
    {
        std::vector<Entry> entries;
        ZydisDecodedInstruction instr;
        ZydisDecodedOperand operands[ZYDIS_MAX_OPERAND_COUNT];
        char buffer[256];
        if (decoder.decode(code, offset, &instr, operands))
        {
            std::memset(buffer, 0, sizeof(buffer));
            if (!formatter.format_instruction(instr, buffer, sizeof(buffer)))
            {
                continue;
            }
            Label instr_lab = instruction(writer, entries, offset, instr, buffer);

            // TODO: Location
            bool success = true;
            for (int i = 0, next_index = 0; i < instr.operand_count; ++i)
            {
                auto operand = operands[i];
                if(operand.visibility == ZYDIS_OPERAND_VISIBILITY_HIDDEN) {
                    continue;
                }
                std::memset(buffer, 0, sizeof(buffer));
                if (!formatter.format_operand(instr, operand, buffer, sizeof(buffer)))
                {
                    success = false;
                    break;
                }
                Label op_lab = writer.fresh_id();
                uint16_t size = operand.size;
                entries.push_back(
                    Entry::fromGenericTuple("operand",
                                            Entry::Arg::FromLabel(op_lab),
                                            Entry::Arg::FromLabel(instr_lab),
                                            Entry::Arg::FromInt(next_index),
                                            Entry::Arg::FromInt(size)));
                entries.push_back(
                    Entry::fromGenericTuple("operand_string",
                                            Entry::Arg::FromLabel(op_lab),
                                            Entry::Arg::FromString(buffer)));
                operand_type(writer, entries, operand, op_lab);
                ++next_index;
            }
            if (success)
            {
                writer.add_all(entries.begin(), entries.end());
            }
        }
    }

    archiver.archive(binary);
}

Label extract_section(TrapWriter &writer, const LIEF::PE::Section *section, bool extractBytes)
{
    auto section_id = writer.fresh_id();

    writer.add(
        Entry::fromGenericTuple(
            "section",
            Entry::Arg::FromLabel(section_id),
            Entry::Arg::FromString(section->name()),
            Entry::Arg::FromInt(section->virtual_address()), // TODO: Split into (a, b)?
            Entry::Arg::FromInt(section->pointerto_raw_data())));

    if (extractBytes)
    {
        auto &content = section->content();
        for (size_t offset = 0; offset < content.size(); ++offset)
        {
            int a, b;
            encodeOffset(offset, a, b);
            writer.add(
                Entry::fromGenericTuple(
                    "section_byte",
                    Entry::Arg::FromLabel(section_id),
                    Entry::Arg::FromInt(a),
                    Entry::Arg::FromInt(b),
                    Entry::Arg::FromInt(content[offset])));
        }
    }

    return section_id;
}

Label extract_text_section(TrapWriter &writer, const LIEF::PE::Section *text_section)
{
    auto id = extract_section(writer, text_section, false);

    writer.add(Entry::fromGenericTuple("text_section", Entry::Arg::FromLabel(id)));
    return id;
}

Label extract_rdata_section(TrapWriter &writer, const LIEF::PE::Section *rdata_section)
{
    auto id = extract_section(writer, rdata_section, true);

    writer.add(Entry::fromGenericTuple("rdata_section", Entry::Arg::FromLabel(id)));
    return id;
}

Label extract_optional_header(TrapWriter &writer, const LIEF::PE::OptionalHeader &optional_header)
{
    auto id = writer.fresh_id();

    int a, b;
    encodeOffset(optional_header.imagebase(), a, b);

    writer.add(Entry::fromGenericTuple("optional_header",
                                       Entry::Arg::FromLabel(id),
                                       Entry::Arg::FromInt(a),
                                       Entry::Arg::FromInt(b),
                                       Entry::Arg::FromInt(optional_header.addressof_entrypoint())));

    return id;
}

Label extract_export_entry(TrapWriter &writer, const LIEF::PE::ExportEntry &entry, Label export_table_id)
{
    auto id = writer.fresh_id();

    

    return id;
}

Label extract_exports(TrapWriter &writer, const LIEF::PE::Export &export_table)
{
    auto id = writer.fresh_id();

    auto name = export_table.name();
    writer.add(Entry::fromGenericTuple("export_table",
        Entry::Arg::FromLabel(id),
        Entry::Arg::FromString(name),
        Entry::Arg::FromInt(export_table.ordinal_base())
    ));

    auto entries = export_table.entries();
    for (const auto& entry : entries) {
        auto entry_id = writer.fresh_id();
        auto ordinal = entry.ordinal();
        auto demangled_name = entry.demangled_name();
        auto address = entry.address();
        writer.add(Entry::fromGenericTuple("export_table_entry",
            Entry::Arg::FromLabel(entry_id),
            Entry::Arg::FromLabel(id),
            Entry::Arg::FromInt(ordinal),
            Entry::Arg::FromString(demangled_name),
            Entry::Arg::FromInt(address)
        ));
    }

    return id;
}

void extract_file(std::string file_path)
{
    TrapWriter writer;
    std::unique_ptr<LIEF::PE::Binary> binary{
        LIEF::PE::Parser::parse(file_path)};

    const LIEF::PE::Section *text_section = binary->get_section(".text");
    if (!text_section)
    {
        std::cerr << "No .text section found\n";
        return;
    }
    auto optional_header = binary->optional_header();
    auto &code = text_section->content();
    disassemble(writer, code, file_path);
    extract_text_section(writer, text_section);
    const LIEF::PE::Section *rdata_section = binary->get_section(".rdata");
    if (rdata_section)
    {
        extract_rdata_section(writer, rdata_section);
    }
    extract_optional_header(writer, optional_header);

    const LIEF::PE::Export* export_table = binary->get_export();
    if(export_table) {
        extract_exports(writer, *export_table);
    }

    std::filesystem::path trap_dir(getenv("CODEQL_EXTRACTOR_BINARY_TRAP_DIR"));
    boost::replace_all(file_path, ":", "_");
    auto trap_file = trap_dir / file_path;
    trap_file.replace_extension(".trap");
    std::filesystem::create_directories(trap_file.parent_path());
    std::ofstream outfile(trap_file);
    writer.write(outfile);
}

int main(int argc, char **argv)
{
    args::ArgumentParser parser("CodeQL extractor for binary executables.");
    args::HelpFlag help(parser, "help", "Display this help menu", {'h', "help"});
    args::ValueFlag<std::string> files(parser, "path", "The file containing files to index", {"file-list"});
    try
    {
        parser.ParseCLI(argc, argv);
    }
    catch (const args::Help &)
    {
        std::cout << parser;
        return 0;
    }
    catch (const args::ParseError &e)
    {
        std::cerr << e.what() << std::endl;
        std::cerr << parser;
        return 1;
    }
    if (files)
    {
        std::ifstream fileList(args::get(files));
        std::string file_path;
        while (std::getline(fileList, file_path))
        {
            extract_file(file_path);
        }
    }

    return 0;
}