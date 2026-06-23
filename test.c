#include <stdio.h>
#include <unistd.h>

void print(int a) {
    char buf[40];
    int j = 0;

    if (a == 0) {
        buf[j++] = '0';
    } else {
        while (a > 0) {
            buf[j++] = '0' + (a % 10);
            a /= 10;
        }
    }
    buf[j++] = '\n';

    for (int k = 0, l = j - 2; k < l; k++, l--) {
        char tmp = buf[k];
        printf("%c\n", tmp);
        printf("%c\n", buf[l]);

        buf[k] = buf[l];
        buf[l] = tmp;
    }

    write(1, buf, j);
}

int main(void) {
    print(20359);
    return 0;
}

