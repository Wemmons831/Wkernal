kernel_source_files := $(shell find src/impl/kernal/ -name *.cpp)
kernel_object_files := build/kernal/mainc.o
x86_64-elf-ld -n -o dist/x86_64/kernel.bin -T targets/x86_64/linker.ld build/kernal/mainc.o $(x86_64_object_files)