#include <stdio.h>

int main(void)
{
    int n;
    int i;
    int posledniy_znak;
    int count;

    scanf("%d", &n);
    posledniy_znak=0;
    count=0;

    for (i=0; n; i++)
    {
        posledniy_znak=n%10;
        count=count+posledniy_znak;
        n=n/10;
    }
    
    printf("%d \n", count);
    return 0;
}
