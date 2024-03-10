#include "kernel/types.h"
#include "kernel/stat.h"
#include "kernel/procinfo.h"
#include "user/user.h"

struct procinfo procs[100];

int main()
{
  int count = ps_listinfo(procs, 100);
  printf("total: %d\n", count);
  printf("PID\tNAME\tSTATE\tPARENT\n");
  for (int i = 0; i < count; i++) {
    printf("%d\t%s\t%s\t%d\n", procs[i].pid, procs[i].name, procs[i].state, procs[i].parent_pid);
  }
  exit(0);
}
