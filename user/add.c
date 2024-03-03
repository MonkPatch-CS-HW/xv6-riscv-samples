#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"

#define BUF_SIZE 30

int
main(int argc, char *argv[])
{
  char buf[BUF_SIZE];
  gets(buf, BUF_SIZE);

  char *space = 0;
  int len = strlen(buf);
  for (int i = 0; i < len - 1; i++) {
    if (buf[i] == ' ') {
      if (i == 0 || i == len - 1 || space != 0) 
        goto err_space;
      space = buf + i;
    } else if (buf[i] < '0' || buf[i] > '9') {
      goto err_char;
    }
  }

  if (space == 0)
    goto err_space;

  char *buf_a = buf;
  char *buf_b = space + 1;

  int a = atoi(buf_a);
  int b = atoi(buf_b);

  printf("result: %d\n", a + b);

  exit(0);

err_space:
  fprintf(2, "need exactly one space between numbers\n");
  exit(1);

err_char:
  fprintf(2, "incorrect numbers\n");
  exit(1);
}
