#include "kernel/fcntl.h"
#include "kernel/types.h"
#include "user/user.h"

int main(int argc, char **argv) {
  int fid = fork();
  if (0 == fid) {
    sleep(100);
    exit(1);
  }

  printf("own pid: %d, child pid: %d\n", getpid(), fid);

  if (argc > 1) {
    if (kill(fid) < 0) {
      fprintf(2, "could not kill child process\n");
      exit(1);
    }
  }

  int child_status;
  if (wait(&child_status) < 0) {
    fprintf(2, "could not wait for child process exit\n");
    exit(1);
  }

  printf("child exit status: %d\n", child_status);
  exit(0);
}
