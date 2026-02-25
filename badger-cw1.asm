%include "/home/malware/asm/joey_lib_io_v9_release.asm"
global main

section .data
    year_prompt: db "Enter the current year", 0Ah, 0
    month_prompt: db "Enter the current month", 10, "1: January", 10, "2: February", 10, "3: March", 10, "4: May", 10, "5: April", 10, "6: June", 10, "7: July", 10, "8: August", 10, "9: September", 10, "10: October", 10, "11: November",10, "12: December", 10, 0
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
    
    cmp rax, 1 ;If the input is 1
    je add_staff
    
    cmp rax, 2
    je add_badger
    
    cmp rax, 3
    je delete_staff
    
    cmp rax, 4
    je delete_badger
    
    cmp rax, 5
    je display_all_staff
    
    cmp rax, 6
    je display_all_badger
    
    cmp rax, 7
    je search_staff
    
    cmp rax, 8
    je search_badger
    cmp rax, 9
    je exit_program
    
    ;If the input is not between 1 to 9
    mov rdi, msg_invalid
    call print_string_new 
    
    
    
    ret
    
add_staff:
    mov rdi, msg_add_staff
    call print_string_new
    jmp menu_loop
    ret
    
add_badger:
    jmp menu_loop
    ret

delete_staff:
    jmp menu_loop
    ret

delete_badger:
    jmp menu_loop
    ret    

display_all_staff:
    jmp menu_loop
    ret
    
display_all_badger:
    jmp menu_loop
    ret

search_staff:
    jmp menu_loop
    ret

search_badger:
    jmp menu_loop
    ret

exit_program:
    jmp end
    ret
    
    
    
    
    main:
        mov rbp, rsp; for correct debugging
        ; Create a stack frame
        push rbp
        mov rbp, rsp
        sub rsp,32
    
        
        call request_date
        menu_loop:
            call display_menu
            
        
        ;movzx rdi, BYTE [current_month]
        ;call print_int_new
        
        
        
        
        
        
        
        
        add rsp, 32
        pop rbp
        end:
        ret ; Return from main function