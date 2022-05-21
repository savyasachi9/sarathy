#include<stdio.h>
#include<curses.h>

void main() {
    system("clear");
    printf("Hello World C !\n");

    int a, b, c;
    a = 3;
    b = 6;
    c = a + b;

    printf("Sum of a(%d) + b(%d) is c(%d)", a, b, c);
    getch();
}

// cmd to run
// gcc -o hello hello.c -lncurses && ./hello