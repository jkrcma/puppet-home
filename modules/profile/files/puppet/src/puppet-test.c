#include <unistd.h>
#include <stdlib.h>

int main() {
    int ret;

    setuid(0);
    setgid(0);
    ret = system("/usr/bin/puppet agent -t --noop");
    return ret > -1 ? ret : 1;
}
