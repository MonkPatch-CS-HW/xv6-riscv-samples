enum procinfo_state { PROC_SLEEPING, PROC_RUNNABLE, PROC_RUNNING, PROC_ZOMBIE };

struct procinfo {
  int pid;
  int parent_pid;
  enum procinfo_state state;
  char name[16];
};
