#include <stdio.h>
#include <re.h>

int main() {
    printf("libre version: %s\n", RE_VERSION);
    printf("Testing basic functionality...\n");

    // Test basic memory functions
    struct pl str;
    pl_set_str(&str, "Hello libre!");
    printf("String test: %.*s\n", (int)str.l, str.p);

    return 0;
}
