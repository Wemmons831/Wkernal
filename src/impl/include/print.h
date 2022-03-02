#pragma once

#include <stddef.h>
#include <stdint.h>



enum {
    PRINT_COLOR_BLACK = 0,
	PRINT_COLOR_BLUE = 1,
	PRINT_COLOR_GREEN = 2,
	PRINT_COLOR_CYAN = 3,
	PRINT_COLOR_RED = 4,
	PRINT_COLOR_MAGENTA = 5,
	PRINT_COLOR_BROWN = 6,
	PRINT_COLOR_LIGHT_GRAY = 7,
	PRINT_COLOR_DARK_GRAY = 8,
	PRINT_COLOR_LIGHT_BLUE = 9,
	PRINT_COLOR_LIGHT_GREEN = 10,
	PRINT_COLOR_LIGHT_CYAN = 11,
	PRINT_COLOR_LIGHT_RED = 12,
	PRINT_COLOR_PINK = 13,
	PRINT_COLOR_YELLOW = 14,
	PRINT_COLOR_WHITE = 15,
};

const static size_t NUM_COLS = 80;
const static size_t NUM_ROWS = 25;

struct Message {
    uint8_t character;
    uint8_t color;
};
struct Message* buffer = (struct Message*) 0xb8000;

size_t col = 0;
size_t row = 0;
uint8_t color = PRINT_COLOR_WHITE | PRINT_COLOR_BLACK << 4;

void clear_row(size_t row) {
    
	Message empty;
	empty.character = ' ';
	empty.color = color;


    for(size_t col = 0; col < NUM_COLS; col++) {
        buffer[col + NUM_COLS * row] = empty;
    }
}

void print_clear() {
    for (size_t i = 0; i < NUM_ROWS; i++) {
        clear_row(i);
    }
}

void print_newline() {
    col = 0;

    if (row < NUM_ROWS - 1) {
        row++;
        return;
    }

    for (size_t row = 1; row < NUM_ROWS; row++) {
        for (size_t col = 0; col < NUM_COLS; col++) {
            Message character = buffer[col + NUM_COLS * row];
            buffer[col + NUM_COLS * (row - 1)] = character;
        }
    }

    clear_row(NUM_COLS - 1);
}

void print_char(char character) {
    if (character == '\n') {
        print_newline();
        return;
    }

    if (col > NUM_COLS) {
        print_newline();
    }
	Message mes;
	mes.character = (uint8_t) character;
	mes.color = color;
    buffer[col + NUM_COLS * row] = mes;

    col++;
}
void print_str(char* str) {
    for (size_t i = 0; 1; i++) {
        char character = (uint8_t) str[i];

        if (character == '\0') {
            return;
        }

        print_char(character);
    }
}
void print_set_color(uint8_t foreground, uint8_t background) {
    color = foreground + (background << 4);
}
void set_screen_color(uint8_t set_color){
    uint8_t temp_color = color;
    print_set_color(set_color,set_color);
    Message set;
	set.character = ' ';
	set.color = color;
    
    for (size_t i = 0; i < NUM_ROWS; i++) {
        for(size_t col = 0; col < NUM_COLS; col++) {
            buffer[col + NUM_COLS * i] = set;
    }
    }
    color = temp_color;
};


