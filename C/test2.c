#include <stdio.h>
#include <unistd.h>

int main(void)
{
	write(1, "privet", 6);
	printf("\n");
	printf("nu a kak?");
	
	return 0;
}
