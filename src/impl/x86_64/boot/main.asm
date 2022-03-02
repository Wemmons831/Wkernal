global start


extern long_mode_start
section .text
global error
bits 32
start:
	
	; tells cpu where stack is located
	mov esp , stack_top

	; check multiboot 2
	call check_multiboot

	; gets cpu information
	call check_cpu_id

	; checks if cpu sopports long mode (64 bit)
	call check_long_mode

	
	;paging
	call setup_page_tables
	call enable_paging
	lgdt [gdt64.pointer]
	jmp gdt64.code_segment:long_mode_start
	
	hlt

check_multiboot:
	cmp eax, 0x36d76289
	; if above fales
	jne .no_multiboot
	;otherwise
	ret

.no_multiboot:
	mov al,"M"
	jmp error

check_cpu_id:
	; a bunch of random shit to check if cpu id is avalible by checking if we can flip a bit in the cpu falgs or something
	pushfd
	pop eax
	mov ecx, eax
	xor eax, 1 << 21
	push eax
	popfd
	pushfd
	pop eax
	push ecx
	popfd
	cmp eax, ecx
	je .no_cpuid
	ret

.no_cpuid:
	; only called when check_cpu_id fails and it calls an error with C as the error code
	mov al, "C"
	jmp error

check_long_mode:
	; some very specific stuuf to check if long mode is sopported 
	mov eax, 0x80000000
	cpuid
	cmp eax, 0x80000001
	jb .no_long_mode

	mov eax, 0x80000001
	cpuid
	test edx, 1 << 29
	jz .no_long_mode
	
	ret
.no_long_mode:
	; only called when check_long_mode fails and it calls an error with L as the error code
	mov al, "L"
	jmp error


setup_page_tables:
	mov eax, page_table_l3
	or eax, 0b11 ; present, writable
	mov [page_table_l4], eax
	
	mov eax, page_table_l2
	or eax, 0b11 ; present, writable
	mov [page_table_l3], eax

	mov ecx, 0 ; counter
.loop:

	mov eax, 0x200000 ; 2MiB
	mul ecx
	or eax, 0b10000011 ; present, writable, huge page
	mov [page_table_l2 + ecx * 8], eax

	inc ecx ; increment counter
	cmp ecx, 512 ; checks if the whole table is mapped
	jne .loop ; if not, continue

	ret

enable_paging:
	;gives the cpu exess to the page table]
	mov eax, page_table_l4
	mov cr3, eax

	;enable PAE (physical adress extention)
	mov eax, cr4 ; paging conditions
	or eax, 1 << 5 ; set the 5th bit to 1
	mov cr4, eax ; save changes

	; enable long mode
	mov ecx, 0xC0000080 ; magic value
	rdmsr ;moves cpu flages into eax ?
	or eax, 1 << 8 ; sets 8th bit to 1 to enable long mode
	wrmsr ; saves changes

	;enable paging
	mov eax, cr0
	or eax, 1 << 31
	mov cr0, eax

	ret


error:
	; print "ERR: X" where X is the error code
	mov dword [0xb8000], 0x4f524f45
	mov dword [0xb8004], 0x4f3a4f52
	mov dword [0xb8008], 0x4f204f20
	mov byte  [0xb800a], al
	hlt

section .bss
align 4096
page_table_l4:
	resb 4096
page_table_l3:
	resb 4096
page_table_l2:
	resb 4096

stack_bottum:
	resb 4096 * 4
stack_top:

section .rodata ;read only data
gdt64:
	dq 0 ; zero entery
.code_segment: equ $ - gdt64
	dq (1 << 43) | (1 << 44) | (1 << 47) | (1 << 53) ; code segment specifices a bunch of flags
.pointer:
	dw $ - gdt64 - 1 ; lengt
	dq gdt64 ; address
