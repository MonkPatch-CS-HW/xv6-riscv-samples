#include "kernel/fcntl.h"
#include "kernel/types.h"
#include "user/user.h"

#define MAX_LEN 100

int main(int argc, char **argv) {
  int fd[2];

  if (pipe(fd) < 0) {
    fprintf(2, "could not create pipe\n");
    exit(1);
  }

  int fid = fork();
  if (0 == fid) {
    close(fd[1]);

    close(0);
    if (dup(fd[0]) < 0) {
      fprintf(2, "could not dup channel\n");
      exit(1);
    }
    close(fd[0]);

    char *argv[] = { "wc", 0 };
    exec("/wc", argv);

    fprintf(2, "could not exec wc\n");
    exit(1);
  }

  close(fd[0]);
  for (int i = 1; i < argc; i++) {
    fprintf(fd[1], "%s\n", argv[i]);
  }

  if (close(fd[1]) < 0) {
    fprintf(2, "could not close write pipe\n");
    exit(1);
  }

  int child_status;
  if (wait(&child_status) < 0) {
    fprintf(2, "could not wait for child process exit\n");
    exit(1);
  }

  exit(0);
}
