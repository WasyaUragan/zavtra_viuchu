#include <stdio.h>
#include <unistd.h>

int main(void)
{
    int n, i, j;

    scanf("%d", &n);
    i=1;

    while (i<=n)
    {   
        j=1;
        while(j<=i)
        {   
            write(1,"*",1);
            j++;
        }
        write(1,"\n",1);
        i++;    
    }
    return 0;
}
