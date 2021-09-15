//optexample.c
#include <stdio.h>
int exp_compute(int a,int b){
    int m = 4;
    int n = 8;
    int x = m * n;
    int y = n / m;
    int c = a - b;
    int d = a - b + y;
    printf("c = %d", c);
    printf("d = %d", d);
    return (c+d+x)*2;
}
int ccp(int z, int n){
    int y = z;
    int x = 1;
    while (n--){
        if (y!=z){x = 2;}
        x = 2-x;
        if (x!=1){y = 2;}
    }
    return x;
}
int squre(int num){
    int a[100];
    int i;
    for(i = 0;i < 100;i++){
        a[i] = i;
    }
    return num * num + a[num];
} 