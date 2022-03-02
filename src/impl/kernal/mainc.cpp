#include "../include/print.h"

#include <stdint.h>


extern "C" void kernel_main() {
    print_clear();
    
    print_set_color(PRINT_COLOR_BLACK, PRINT_COLOR_WHITE);
    set_screen_color(PRINT_COLOR_WHITE);
    print_str("booted :)");
    
    

    
    
}