#include "kernel/types.h"
#include "kernel/stat.h"
#include "kernel/procinfo.h"
#include "user/user.h"

int current_count = 1;
struct procinfo *old_procs;
struct procinfo *procs;

void alloc() {
  procs = malloc(current_count * sizeof(struct procinfo));
}

void realloc() {
  old_procs = procs;
  current_count *= 2;
  alloc();
  for (int i = 0; i * 2 < current_count; i++) {
    procs[i] = old_procs[i];
  }
  free(old_procs);
}

int main()
{
  alloc();
  int original_count = ps_listinfo(procs, 0);
  int original_count2 = ps_listinfo(0, 1234);

  int ret;
  int realloc_count = 0;
  while ((ret = ps_listinfo(procs, current_count)) > current_count) {
    realloc();
    realloc_count += 1;
  }

  printf("count got by zero limit: %d\n", original_count);
  printf("count got by zero addr: %d\n", original_count2);
  printf("reallocs doubling buf size (def=1): %d\n", realloc_count);
}
