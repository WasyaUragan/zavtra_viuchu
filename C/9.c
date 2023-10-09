#include <stdio.h>
#include <math.h>

int main(void)
{
	int a, b, c;
    float x, x1, x2;
    scanf(" %d %d %d", &a, &b, &c);

//    a*a + b*x + c = 0;
// дискриминант
    double sqrt(D);
    double D;
    D = b*b - 4*a*c;
    printf("%f \n", D);
    x = -b / 2*a;
    x1 = (-b + sqrt(D)) / 2*a; 
    x2 = (-b - sqrt(D)) / 2*a;

    if(D < 0)
        printf("NO");
    else if ((D = 0))
        printf("%.4f \n", x);
    else
    {
        if (D > 0)
        {
            if (x1<x2)
                printf("%.4f %.4f \n", x1, x2);
            else
                printf("%.4f %.4f \n", x2, x1);
        }        
    }   

	return 0;
}
