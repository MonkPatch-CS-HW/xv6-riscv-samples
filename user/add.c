#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"

#define BUF_SIZE 20

int
main(int argc, char *argv[])
{
  char buf[BUF_SIZE];
  gets(buf, BUF_SIZE);

  char *space = strchr(buf, ' ');
  if (space == 0)
    goto fmt_err;

  char *buf_a = buf;
  char *buf_b = space + 1;

  int a = atoi(buf_a);
  int b = atoi(buf_b);

  printf("%d\n", a + b);

  exit(0);

fmt_err:
  printf("two numbers needed\n");
  exit(1);
}
