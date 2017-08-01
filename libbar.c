#include <stdio.h>

extern void foo();

void bar() {
  foo();
  puts("bar");
}
