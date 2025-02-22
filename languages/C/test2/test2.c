#include <stdio.h>

// int main()
// {
// 	int a, b, c, d;
// 	scanf("%d %d", &a, &b);

// 	c=a%b;
// 	d=b%a;

// 	if(c<d)
// 		printf("%d \n", c);
// 	else
// 		printf("%d \n", d);

//     return 0;
// }

/*
int main() {
    int a, b;
    scanf("%d%d", &a, &b);
    printf("%d", a%b < b%a ? a%b : b%a);
    return 0;
}
*/

int main()
{
	int a;
	scanf("%d", &a);

	if (a % 4 == 0)
		printf("YES");
	else
		printf("NO");

	return 0;
}