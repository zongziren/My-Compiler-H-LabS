#include <stdio.h>
void sort(int l, int *a);
int main()
{
    int number = 0;
    int i = 0;
    int arry[2000];
    scanf("%d", &number);
    for (i = 0; i < number; i++)
        scanf("%d", &arry[i]);
    sort(number, arry);
    for (i = 0; i < number; i++)
        printf("%d ", arry[i]);
    return 0;
}

void sort(int l, int *a)
{
    int i, j;
    int v;
    for (i = 0; i < l - 1; i++)
        for (j = i + 1; j < l; j++)
        {
            if (a[i] > a[j])
            {
                v = a[i];
                a[i] = a[j];
                a[j] = v;
            }
        }
}