#include <unistd.h>
#include <stdlib.h>

int main() {
    int ret;

    // Get rid of Ubuntu 20.04 Ruby deprecation warnings
    setenv("RUBYOPT", "-W0", 1);
    setuid(0);
    setgid(0);
    ret = system("/usr/bin/puppet agent --verbose --onetime --no-daemonize --show_diff --ignorecache --no-usecacheonfailure");
    return ret > -1 ? ret : 1;
}
