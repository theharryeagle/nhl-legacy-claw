#define NOMINMAX
#include <windows.h>
#include <cstdint>
#include <cstdio>
#include <chrono>
inline uint64_t NhlThreadCpuNs() {
#ifdef _WIN32
  FILETIME creation{}, exit{}, kernel{}, user{};
  if (!GetThreadTimes(GetCurrentThread(), &creation, &exit, &kernel, &user)) {
    return UINT64_MAX;
  }
  const auto ticks = [](FILETIME t) {
    return (uint64_t(t.dwHighDateTime) << 32) | t.dwLowDateTime;
  };
  return (ticks(kernel) + ticks(user)) * 100ull;
#else
  timespec ts{};
  if (clock_gettime(CLOCK_THREAD_CPUTIME_ID, &ts) != 0) return UINT64_MAX;
  return uint64_t(ts.tv_sec) * 1000000000ull + uint64_t(ts.tv_nsec);
#endif
}
int main() {
  auto a=NhlThreadCpuNs(); Sleep(100); auto b=NhlThreadCpuNs();
  auto start=std::chrono::steady_clock::now();
  while (std::chrono::steady_clock::now()-start < std::chrono::milliseconds(250)) {}
  auto c=NhlThreadCpuNs();
  printf("sleep_cpu_ms=%.3f busy_cpu_ms=%.3f\n", (b-a)/1e6, (c-b)/1e6);
  return a==UINT64_MAX || b<a || c<=b || (c-b)>350000000ull;
}
