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

    int res;
    char str[MAX_LEN] = {0};
    while ((res = read(fd[0], str, MAX_LEN)) > 0) {
      printf("%s", str);
    }

    if (res < 0) {
      fprintf(2, "could not read from pipe\n");
      exit(1);
    }

    printf("\n");

    close(fd[0]);
    exit(0);
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
