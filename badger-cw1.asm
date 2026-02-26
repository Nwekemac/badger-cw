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
               
    ; - - - - - ADD_Staff Prompts - - - - - - - - - 
    enter_surname:    db "Enter Surname: ", 0
    enter_firstname:  db "Enter First Name: ", 0
    enter_staff_id:   db "Enter Staff ID (pXXXXXXX): ", 0
    enter_dept:       db "Enter Dept (1: Keeper, 2: Shop, 3: Cafe): ", 0
    enter_salary:     db "Enter Annual Salary: ", 0
    enter_year:       db "Enter Year of Joining: ", 0
    enter_email:      db "Enter Email Address: ", 0
    staff_full:       db "Error: Staff list is full.", 10, 0
    
    ; - - - - Display Staff Labels - - - - - - - -
    lbl_surname:    db "Surname: ", 0
    lbl_firstname:  db "First Name: ", 0
    lbl_service:    db "Years of Service: ", 0
    lbl_salary:     db "Current Salary: £", 0
    lbl_email:      db "Email: ", 0
    
               
    msg_add_staff: db "You can now add a staff!", 0
    msg_invalid: db "Invalid input!", 0

section .bss
    current_year: resw 4 ; Reserve four bytes to store the current year
    current_month: resb 1  ; Buffer to Store the month
    
;   ------- Initialising Staff Records ----------
    ; Defining the size of each input in the record.
    size_staff_surname    equ 64 ;Name and Surname Expected to be a maximum of 63 + 1 null
    size_staff_firstname  equ 64
    size_staff_id         equ 9   ; 'p' + 7 digits + NUL
    size_staff_dept       equ 1   ; User enters, 1, 2, or 3 depending on Department Options
    size_staff_salary     equ 4   ; 4 Byte can store a large enough value to store the expected Salary
    size_staff_year       equ 2   ; MAX year expected = 2026. 2 bytes large enough
    size_staff_email      equ 64  ; 63 bytes + 1 null
    
    
    ;Total size of one staff record
    size_staff_record     equ size_staff_surname + size_staff_firstname + size_staff_id + size_staff_dept + size_staff_salary + size_staff_year + size_staff_email
    
    staff_array: resb size_staff_record * 100 ;Whatever the size of one record is, reseserve enough for 100 of such records
    staff_count: resd 1  ; Tracks the number of staff to no if it is up to 100


section .text
request_date:
    mov rdi, year_prompt
    call print_string_new
    ;Collect Year input
    call read_int_new
    ;mov rdi, rax
    mov [current_year], ax
    movzx rdi, WORD [current_year] ;Move the value of CURRENT YEAR and zero the upper bits
    call print_int_new
    call print_nl_new
    
    ;Collect Month Input
    call print_nl_new
    mov rdi, month_prompt
    call print_string_new
    mov rdi, rax
    call read_int_new
    mov [current_month], al ; Store the lower 8 bits of the value in RAX into current_month in BSS to avoid being overwritten in register
    mov rdi, rax
    call print_int_new
    call print_nl_new
    ret
 
display_menu:
    
    call print_nl_new
    mov rdi, main_menu
    call print_string_new ; Print the Main Menu Prompt
    call read_int_new ; Take User input
    
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

    ;Check if the array is full
    mov eax, [staff_count]
    cmp eax, 100
    jge .staff_full

    ;Calculate the base address for the new record
    mov r11, size_staff_record
    mov eax, [staff_count]
    imul rax, r11
    add rax, staff_array
    
    push r12
    mov r12, rax              ; r12 is now the permanent reference for this record

    ;Collect Surname ---
    mov rdi, enter_surname
    call print_string_new
    call read_string_new      ; Library gets input -> Address in RAX
    mov rsi, rax              ; Source = library buffer
    mov rdi, r12              ; Destination = Start of record
    call copy_string

    ;Collect First Name ---
    mov rdi, enter_firstname
    call print_string_new
    call read_string_new
    mov rsi, rax              ; Source
    lea rdi, [r12 + size_staff_surname] ; Destination
    call copy_string

    ;Collect Staff ID ---
    mov rdi, enter_staff_id
    call print_string_new
    call read_string_new
    mov rsi, rax              ; Source
    lea rdi, [r12 + size_staff_surname + size_staff_firstname] ;Destination
    call copy_string

    ;Collect Department: This one Takes and Integer that is only One Byte Big
    mov rdi, enter_dept
    call print_string_new
    call read_int_new
    ;Move the lower byte (8bits of rax into the memory location
    mov [r12 + size_staff_surname + size_staff_firstname + size_staff_id], al

    ;Collect Salary  ---
    mov rdi, enter_salary
    call print_string_new
    call read_int_new
    mov [r12 + size_staff_surname + size_staff_firstname + size_staff_id + size_staff_dept], eax

    ; Collect Year of Joining
    mov rdi, enter_year
    call print_string_new
    call read_int_new
    mov [r12 + size_staff_surname + size_staff_firstname + size_staff_id + size_staff_dept + size_staff_salary], ax

    ; Collect Email

    mov rdi, enter_email
    call print_string_new
    call read_string_new
    mov rsi, rax              ; Source
    lea rdi, [r12 + size_staff_surname + size_staff_firstname + size_staff_id + size_staff_dept + size_staff_salary + size_staff_year]
    call copy_string

    ; --- 10. Increment Staff Count
    inc dword [staff_count]
    
    pop r12 
    jmp .exit

.staff_full:
    mov rdi, staff_full
    call print_string_new

.exit:
    add rsp, 32
    pop rbp
    ret
    
    
; End of add_staff function    
    
        
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
    ret    

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
    ;REF[1]: This exit_program function was researched as the other method of jumping to the end of main seemed problematic.
    ;Source: https://medium.com/@billyelvondaaronumpel2005/pengenalan-bahasa-assembly-dengan-arsitektur-x86-64-b0dd6ca11b54
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
            
        
        
        
        
        
        
        
        
        
        add rsp, 32
        pop rbp
        ret ; Return from main function