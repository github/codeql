#include "misc/bazel/internal/zipmerge/zipmerge.h"

#include <array>
#include <fstream>
#include <sstream>
#include <string>
#include <cstring>
#include <filesystem>

#include <gtest/gtest.h>
#include <gmock/gmock.h>
#include "tools/cpp/runfiles/runfiles.h"

using bazel::tools::cpp::runfiles::Runfiles;
using namespace std::string_literals;
namespace fs = std::filesystem;

namespace codeql_testing {

TEST(Zipmerge, ReadAndWrite) {
  char buf[7] = {0};
  write2(buf + 1, 0xF2F1U);
  write4(buf + 3, 0xF6F5F4F3UL);
  EXPECT_STREQ(buf, "\x00\xF1\xF2\xF3\xF4\xF5\xF6");
  EXPECT_EQ(read2(buf + 1), 0xF2F1U);
  EXPECT_EQ(read4(buf + 3), 0xF6F5F4F3UL);
}

TEST(Zipmerge, AppendCd) {
  output_cd.length = 0;
  append_cd((const uint8_t*)"a", 1);
  append_cd((const uint8_t*)"bcd", 3);
  append_cd((const uint8_t*)"efghijklmno", 11);
  EXPECT_EQ(output_cd.length, 15);
  std::string_view bytes{reinterpret_cast<char*>(output_cd.bytes), 15};
  EXPECT_EQ(bytes, "abcdefghijklmno");
}

TEST(Zipmerge, ShouldIncludeFilenameNow) {
  EXPECT_TRUE(should_include_filename_now((const uint8_t*)"x", 1));
  EXPECT_FALSE(should_include_filename_now((const uint8_t*)"x", 1));
  EXPECT_TRUE(should_include_filename_now((const uint8_t*)"y", 1));
  EXPECT_TRUE(should_include_filename_now((const uint8_t*)"yy", 2));
  EXPECT_FALSE(should_include_filename_now((const uint8_t*)"x", 1));
  EXPECT_FALSE(should_include_filename_now((const uint8_t*)"yy", 2));
}

TEST(Zipmerge, FindEocd) {
  uint8_t buf[500] = {0};
  auto i = 0u;
  for (auto& b : buf) {
    b = i % 256;
  }
  memcpy(buf + 17, eocd_signature.data(), eocd_signature.size());
  memcpy(buf + 101, eocd_signature.data(), eocd_signature.size());
  EXPECT_EQ(find_eocd(buf, sizeof(buf)), buf + 101);
}

std::string read_file(const std::string& filename) {
  std::ifstream f(filename, std::ios::binary);
  EXPECT_TRUE(f) << "Could not open '" << filename << "' (" << std::strerror(errno) << ")";
  if (!f) {
    return 0;
  }
  std::stringstream contents;
  contents << f.rdbuf();
  return contents.str();
}

std::string get_file(const char* name) {
  static auto runfiles = [] {
    std::string error;
    auto ret = Runfiles::CreateForTest(&error);
    EXPECT_TRUE(ret) << error;
    return ret;
  }();
  // this works from both `codeql` and the internal repository
  for (auto prefix : {"_main", "ql+"}) {
    auto ret = runfiles->Rlocation(prefix + "/misc/bazel/internal/zipmerge/test-files/"s + name);
    if (fs::exists(ret)) {
      return ret;
    }
  }
  EXPECT_TRUE(false) << "test file " << name << " not found";
  return "";
}

void expect_same_file(const char* actual, const char* expected) {
  auto expected_file = get_file(expected);
  auto actual_contents = read_file(actual);
  unlink(actual);  // If tests start failing, you might want to comment out this unlink in order to
                   // inspect the output.
  ASSERT_EQ(actual_contents, read_file(expected_file))
      << "contents of " << actual << " do not match contents of " << expected_file;
}

template <typename... Args>
const char* zipmerge(Args*... inputs) {
  reset();
  const char* output = nullptr;
  std::vector<std::string> args{"self"};
  std::array<const char*, sizeof...(Args)> flags{{inputs...}};
  auto i = 0u;
  for (; i < flags.size() && std::string_view{flags[i]}.starts_with("-"); ++i) {
    args.push_back(flags[i]);
  }
  output = flags[i];
  args.push_back(output);
  ++i;
  for (; i < flags.size(); ++i) {
    args.push_back(std::string_view{flags[i]}.starts_with("-") ? flags[i] : get_file(flags[i]));
  }
  std::vector<const char*> argv;
  std::transform(args.begin(), args.end(), std::back_inserter(argv),
                 [](const std::string& s) { return s.c_str(); });
  EXPECT_EQ(zipmerge_main(argv.size(), argv.data()), 0);
  return output;
}

TEST(Zipmerge, Identity) {
  expect_same_file(zipmerge("out.zip", "directory.zip"), "directory.zip");
}

TEST(Zipmerge, Idempotent) {
  expect_same_file(zipmerge("out.zip", "directory.zip", "directory.zip", "directory.zip"),
                   "directory.zip");
}

TEST(Zipmerge, RemoveEverything) {
  expect_same_file(zipmerge("--remove=directory", "out.zip", "directory.zip"), "empty.zip");
}

TEST(Zipmerge, RemoveEverythingWildcard) {
  expect_same_file(zipmerge("--remove=*ory", "out.zip", "directory.zip"), "empty.zip");
}

TEST(Zipmerge, RemovePrefixedPaths) {
  expect_same_file(zipmerge("--remove=My/directory", "out.zip", "--prefix=My", "directory.zip"),
                   "empty.zip");
}
TEST(Zipmerge, RemoveSome) {
  expect_same_file(
      zipmerge("--remove=directory/b.txt", "--remove=directory/c.txt", "out.zip", "directory.zip"),
      "directory-partial.zip");
}

TEST(Zipmerge, RemoveSomeWildcard) {
  expect_same_file(zipmerge("--remove=directory/b*t", "--remove=directory/c*", "--remove=dir*t",
                            "out.zip", "directory.zip"),
                   "directory-partial.zip");
}

TEST(Zipmerge, Prefix) {
  expect_same_file(
      zipmerge("out.zip", "minimal.zip", "--prefix=a", "minimal.zip", "--prefix=b", "minimal.zip"),
      "minimal-x3.zip");
}

TEST(Zipmerge, InputFileOrder) {
  expect_same_file(zipmerge("out.zip", "minimal.zip", "almost-minimal.zip"), "almost-minimal.zip");
}

TEST(Zipmerge, LocalFileFooters) {
  expect_same_file(zipmerge("out.jar", "footers.jar"), "no-footers.jar");
}
}  // namespace codeql_testing
