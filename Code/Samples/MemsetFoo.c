#include <string.h>

void foo(int x) {
  char buf[10];
  int i;
  for (i=0; i<sizeof(buf); ++i)
    buf[i]=x++;
  memset(buf,0,sizeof(buf));
  asm volatile("" : : "r"(&buf) : "memory");
  	
}
