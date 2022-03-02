#include "../include/print.h"
#include "../include/time.h"
#include <stdint.h>


extern "C" void kernel_main() {
    print_clear();
    
    print_set_color(PRINT_COLOR_BLACK, PRINT_COLOR_WHITE);
    set_screen_color(PRINT_COLOR_WHITE);
    read_rtc();
    print_str(reinterpret_cast<char*>(second));
    
    

    
    
}