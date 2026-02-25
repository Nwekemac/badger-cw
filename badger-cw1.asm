%include "/home/malware/asm/joey_lib_io_v9_release.asm"
global main

section .data
    year_prompt: db "Enter the current year", 0Ah, 0
    month_prompt: db "Enter the current month", 10, "1: January", 10, "2: February", 10, "3: March", 10, "4: April", 10, "5: May", 10, "6: June", 10, "7: July", 10, "8: August", 10, "9: September", 10, "10: October", 10, "11: November",10, "12: December", 10, 0
    main_menu: db "What would you like to do?", 10
               db "1: Add Staff", 10
               db "2: Add badger", 10
               db "3: Delete Staff", 10
               db "4: Delete Badger", 10
               db "5: Display all staff info", 10
               db "6: Display all badger info", 10
               db "7: Search Staff by ID", 10
               db "8: Search Badger by ID", 10
               db "9: Exit", 10, 10, 0
               
    msg_add_staff: db "You can now add a staff!", 0
    msg_invalid: db "Invalid input!", 0

section .bss
    current_year: resw 4 ; Reserve four bytes to store the current year
    current_month: resb 1  ; Buffer to Store the month



section .text
request_date:
    mov rdi, year_prompt
    call print_string_new
    ;Collect Year input
    call read_int_new
    ;mov rdi, rax
    mov [current_year], ax
    movzx rdi, WORD [current_year]
    call print_int_new
    call print_nl_new
    
    ;Collect Month Input
    call print_nl_new
    mov rdi, month_prompt
    call print_string_new
    mov rdi, rax
    call read_int_new
    mov [current_month], al
    mov rdi, rax
    call print_int_new
    call print_nl_new
    ret
 
display_menu:
    
    call print_nl_new
    mov rdi, main_menu
    call print_string_new
    call read_int_new
    
    ;Compare the input stored in RAX and compare to jump to the appropriate label.
    cmp rax, 1 
    je .call_add_staff
    
    cmp rax, 2
    je .call_add_badger
    
    cmp rax, 3
    je .call_delete_staff
    
    cmp rax, 4
    je .call_delete_badger
    
    cmp rax, 5
    je .call_display_all_staff
    
    cmp rax, 6
    je .call_display_all_badger
    
    cmp rax, 7
    je .call_search_staff
    
    cmp rax, 8
    je .call_search_badger
    
    cmp rax, 9
    je .call_exit_program
    
    ;If the input is not between 1 to 9
    mov rdi, msg_invalid
    call print_string_new
    ret
    
    
    ;each of the functions are created in isolation for easy debugging. This way, the function called will be independent
    .call_add_badger:
        call add_badger
        ret
    .call_add_staff:
        call add_staff
        ret
    .call_delete_staff:
        call delete_staff
        ret
    .call_delete_badger:
        call delete_badger
        ret
    .call_display_all_staff:
        call display_all_staff
        ret
    .call_display_all_badger:
        call display_all_badger
        ret
    .call_search_staff:
        call search_staff
        ret
    .call_search_badger:
        call search_badger
        ret
    .call_exit_program:
        call exit_program
        ret
    
    
;MAIN Functions
add_staff:
    push rbp
    mov rbp, rsp
    sub rsp, 32

    mov rdi, msg_add_staff
    call print_string_new
    
    ; Cleanup
    add rsp, 32
    pop rbp
    ret
    
add_badger:
    push rbp
    mov rbp, rsp
    sub rsp, 32
    
    
    
    add rsp, 32
    pop rbp
    ret ;

delete_staff:
    push rbp
    mov rbp, rsp
    sub rsp, 32
    
    
    
    add rsp, 32
    pop rbp
    ret ;
    
delete_badger:
    push rbp
    mov rbp, rsp
    sub rsp, 32
    
    
    
    add rsp, 32
    pop rbp
    ret ;    

display_all_staff:
    push rbp
    mov rbp, rsp
    sub rsp, 32
    
    
    
    add rsp, 32
    pop rbp
    ret ;
    
display_all_badger:
    push rbp
    mov rbp, rsp
    sub rsp, 32
    
    
    
    add rsp, 32
    pop rbp
    ret ;

search_staff:
    push rbp
    mov rbp, rsp
    sub rsp, 32
    
    
    
    add rsp, 32
    pop rbp
    ret ;

search_badger:
    push rbp
    mov rbp, rsp
    sub rsp, 32
    
    
    
    add rsp, 32
    pop rbp
    ret ;

exit_program:
    mov rax, 60        ; 60 is the 'sys_exit' system call
    xor rdi, rdi       ; Return code 0 (Success)
    syscall            ; The program ends here immediately
    
    
    
    
    main:
        mov rbp, rsp; for correct debugging
        ; Create a stack frame
        push rbp
        mov rbp, rsp
        sub rsp,32
    
        
        call request_date
        menu_loop:
            call display_menu
            jmp menu_loop
            
        
        ;movzx rdi, BYTE [current_month]
        ;call print_int_new
        
        
        
        
        
        
        
        
        add rsp, 32
        pop rbp
        ret ; Return from main function