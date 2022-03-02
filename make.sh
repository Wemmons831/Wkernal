# asm -> o
for f in src/impl/x86_64/boot/*; do
i=${f/"src/impl/x86_64/boot/"/""}
nasm -f elf64 $f -o build/x86_64/boot/${i/asm/"o"}
done
# cpp -> o
for f in src/impl/kernal/*; do
i=${f/"src/impl/kernal"/""}
x86_64-elf-g++ -c -ffreestanding $f -o build/kernal/${i/cpp/"o"}
done
#*.o -> kernel.bin
x86_64-elf-ld -n -o dist/x86_64/kernel.bin -T targets/x86_64/linker.ld build/kernal/*.o build/x86_64/boot/*.o
#move around
cp dist/x86_64/kernel.bin targets/x86_64/iso/boot/kernel.bin
#make iso
grub-mkrescue /usr/lib/grub/i386-pc -o dist/x86_64/kernel.iso targets/x86_64/iso