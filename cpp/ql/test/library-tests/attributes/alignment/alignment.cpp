namespace AlignAs {
struct alignas(16) sse_t
{
  float sse_data[4];
};

struct alignas(sse_t) avx_t
{
  float avx_data[8];
};

}
namespace AttributeAlign {

struct [[align(16)]] sse_t
{
  float sse_data[4];
};

struct [[align(sse_t)]] avx_t
{
  float avx_data[8];
};

struct [[align(1024 * 8)]] align_to_8_kilobytes
{
  int x;
};

struct [[align(1024 * 1024 * 256)]] align_to_256_megabytes
{
  int x;
};

}
