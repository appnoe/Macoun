#include <string.h>
#include <stdio.h>

void bar(int x) {
	printf("Bar!\n");
	char foobar[10];
	int i;
	for (i=0; i<sizeof(foobar); ++i)
		foobar[i]=x++;
	memset(foobar,0,sizeof(foobar));
	asm volatile("" : : "r"(&foobar) : "memory");
}

int main()
{
	printf("Foobar!\n");
	bar(23);
	return 0; 
}