%include "/home/malware/asm/joey_lib_io_v9_release.asm"
global main

section .data
    year_prompt: db "Enter the current year", 0Ah, 0
    month_prompt: db "Enter the current month", 10, "1: January", 10, "2: February", 10, "3: March", 10, "4: May", 10, "5: April", 10, "6: June", 10, "7: July", 10, "8: August", 10, "10: September", 10, "10: October", 10, "11: November",10, "12: December", 10, 0
    main_menu: db "What would you like to do?", 10
               db "1: Add Staff", 10
               db "2: Add badger", 10
               db "3: Delete Staff", 10
               db "4: Delete Badger", 10
               db "5: Display all staff info", 10
               db "6: Display all bagdger info", 10
               db "7: Search Staff by ID", 10
               db "8: Search Badger by ID", 10
               db "9: Exit", 10, 0
    

section .text
request_date:
    mov rdi, year_prompt
    call print_string_new
    ;Collect Year input
    call read_int_new
    mov rdi, rax
    call print_int_new
    call print_nl_new
    
    ;Collect Month Input
    call print_nl_new
    mov rdi, month_prompt
    call print_string_new
    mov rdi, rax
    call read_int_new
    mov rdi, rax
    call print_int_new
    call print_nl_new
    ret
 
 display_menu:
    call print_nl_new
    mov rdi, main_menu
    call print_string_new
    call read_int_new
    mov rdi, rax
    call print_int_new
    call print_nl_new
    ret

    main:
    mov rbp, rsp; for correct debugging
        ; Create a stack frame
        push rbp
        mov rbp, rsp
        sub rsp,32
    
        
        call request_date
        call display_menu
        
        
        
        
        
        
        
        
        
        add rsp, 32
        pop rbp
        
        ret ; Return from main function