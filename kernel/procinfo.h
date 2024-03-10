struct procinfo {
  int pid;
  int parent_pid;
  char state[16];
  char name[16];
};
