#include <stdio.h>
#include <math.h>

int main()
{
	float a, b, c, D;
    double x, x1, x2;
    scanf(" %f %f %f", &a, &b, &c);

//    a^2 + b*x + c = 0;
// дискриминант
     
    D = b*b - 4*a*c;
//    printf("%.4f \n", D);

    if ((D == 0))
    {
        x = -b / 2*a;
        printf("%.4f \n", x);
    }
    else if (D < 0)
        printf("NO");
    else
    {
        if (D > 0)
        {
            x1 = (-b + sqrt(D)) / (2*a);
            x2 = (-b - sqrt(D)) / (2*a);
            if (x1<x2)
                printf("%.4f %.4f \n", x1, x2);
            else
                printf("%.4f %.4f \n", x2, x1);
        }        
    }   

	return 0;
}
