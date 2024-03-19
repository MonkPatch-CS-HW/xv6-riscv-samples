#include "kernel/procinfo.h"
#include "kernel/types.h"
#include "user/user.h"

static char *states[] = {
    [PROC_SLEEPING] = "sleep",
    [PROC_RUNNABLE] = "runble", [PROC_RUNNING] = "run", [PROC_ZOMBIE] = "zombie"};

int main() {
  int procsize = ps_listinfo(0, 0);

  if (procsize <= 0) {
    fprintf(2, "error happened at initial ps_listinfo\n");
    exit(1);
  }

  int res;
  struct procinfo *oprocs = 0;
  int oprocsize = 0;

  struct procinfo *procs = malloc(procsize * sizeof(struct procinfo));

  while ((res = ps_listinfo(procs, procsize)) > procsize) {
    oprocsize = procsize;
    oprocs = procs;

    procsize = 2 * procsize;
    procs = malloc(procsize * sizeof(struct procinfo));
    
    for (int i = 0; i < oprocsize; i++)
      procs[i] = oprocs[i];

    free(oprocs);
  }

  if (res <= 0) {
    fprintf(2, "error happened at ps_listinfo: %d\n", res);
    exit(1);
  }

  printf("total: %d\n", procsize);
  printf("PID\tNAME\tSTATE\tPARENT\n");
  for (int i = 0; i < procsize; i++) {
    printf("%d\t%s\t%s\t%d\n", procs[i].pid, procs[i].name, states[procs[i].state],
           procs[i].parent_pid);
  }
  exit(0);
}
