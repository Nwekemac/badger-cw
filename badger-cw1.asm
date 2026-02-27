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
    lbl_staff_id:   db "Staff ID: ", 0
    lbl_current_salary: db "Current Salary: £", 0
    lbl_department:  db "Department: ", 0
    lbl_staff_years: db "Years of employment: ", 0
        
        ;Department Strings
        dept_1: db "Zoo Keeper", 0
        dept_2: db "Shop", 0
        dept_3: db "Cafe", 0
    
               
    msg_add_staff: db "You can now add a staff!", 0
    msg_invalid: db "Invalid input!", 0

section .bss
    current_year: resw 4 ; Reserve four bytes to store the current year
    current_month: resb 1  ; Buffer to Store the month
    
;   ------- Initialising Staff Records ----------
    ; Defining the size of each input in the record.
    size_staff_surname    equ 65 ;64 characters max + 1 null terminator
    size_staff_firstname  equ 65
    size_staff_id         equ 9   ; 'p' + 7 digits + NUL
    size_staff_dept       equ 1   ; User enters, 1, 2, or 3 depending on Department Options
    size_staff_salary     equ 4   ; 4 Byte can store a large enough value to store the expected Salary
    size_staff_year       equ 2   ; MAX year expected = 2026. 2 bytes large enough
    size_staff_email      equ 64  ; 63 bytes + 1 null
    size_staff_deleted    equ 1 ; One number, 0 or 1
    
    
    ; Position of each info from the base address of the record
    staff_surname_pfb       equ 0
    staff_firstname_pfb     equ staff_surname_pfb   + size_staff_surname
    staff_id_pfb            equ staff_firstname_pfb + size_staff_firstname
    staff_dept_pfb          equ staff_id_pfb        + size_staff_id
    staff_salary_pfb        equ staff_dept_pfb      + size_staff_dept
    staff_year_pfb          equ staff_salary_pfb    + size_staff_salary
    staff_email_pfb         equ staff_year_pfb      + size_staff_year
    staff_deleted_pfb       equ staff_email_pfb     + size_staff_email
    
    
    ;Total size of one staff record
    size_staff_record       equ staff_deleted_pfb   + size_staff_deleted
    max_no_staff equ 100 ; The maximum number of staff is 100
    size_staff_array equ max_no_staff * size_staff_record ; Enough for 100 Staff records 
    
    staff_array: resb size_staff_array
    staff_count: resq 1  ; Tracks the number of staff already saved to the array


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
    push rbx
    push rcx
    push rdx
    push rdi
    push rsi    

    ;Check if the array is full
    mov rax, [staff_count]
    cmp rax, 100
    jge .staff_full
    
    mov rdi,[staff_count]
    call print_uint_new

    ;Calculate the base address for the new record
    ; base address of any record = staff_array ( which is the address of the begining of the entire array) + (Staff_count * size_staff_record)
    mov rcx, size_staff_record ; size of staff record as computed by the EQU statements
    mov rax, [staff_count] ;the value stored in memory in staff_count
    imul rax, rcx ; RAX now = staff_count * size_staff_record
    mov rbx, staff_array ;stored the pointer of the begining of the entire array in rbx
    add rbx, rax ; rbx now begining of new entry = base address of entire array + (staff_count * size_staff_record)
    
    ;RBX  is now the reference base address for this new record being created

    ;Collect Surname 
    mov rdi, enter_surname
    call print_string_new
    call read_string_new      ; Surname String now in RAX
    mov rsi, rax              ; For the copy_string function, the destination is stored in RSI
                              ; and the destination is stored in RDI
    lea rdi, [rbx + staff_surname_pfb]   ; Load the effective address for [RBX + the position of staffname from the base address of that record into RSI
    
    call copy_string ; [this moves the value of rsi(contains the pointer to the surname string

    ;Collect First Name
    mov rdi, enter_firstname
    call print_string_new
    call read_string_new
    mov rsi, rax              ; Source
    lea rdi, [rbx + staff_firstname_pfb] ; Destination: Effective address RBX + distance of staff surname from the base address of that staff record
    call copy_string

    ;Collect Staff ID ---
    mov rdi, enter_staff_id
    call print_string_new
    call read_string_new
    mov rsi, rax              ; Source
    lea rdi, [rbx + staff_id_pfb] ;Destination
    call copy_string

    ;Collect Department: This one Takes and Integer that is only One Byte Big
    mov rdi, enter_dept
    call print_string_new
    call read_uint_new
    ;Move the lower byte (8bits of rax into the memory location
    mov BYTE[rbx + staff_dept_pfb], al

    ;Collect Salary
    mov rdi, enter_salary
    call print_string_new
    call read_uint_new
    mov DWORD[rbx + staff_salary_pfb], eax

    ; Collect Year of Joining
    mov rdi, enter_year
    call print_string_new
    call read_int_new
    mov WORD[rbx + staff_year_pfb], ax

    ; Collect Email

    mov rdi, enter_email
    call print_string_new
    call read_string_new
    mov rsi, rax              ; Source
    lea rdi, [rbx + staff_email_pfb]
    call copy_string

    ; --- 10. Increment Staff Count
    inc dword [staff_count]
    
    
    jmp .exit

    .staff_full:
    mov rdi, staff_full
    call print_string_new

.exit:
    ;TEST DISPLAY STAFF FUNCT
    mov rdi, staff_array    ; Point RDI to the start of the first record
    call display_staff      ; Call your new single-staff display function
    
    pop rsi
    pop rdi
    pop rdx
    pop rcx
    pop rbx
    pop rbp
    
    add rsp, 32
    pop rbp
    ret
    
    
; End of add_staff function    
    

        
;DISPLAY_STAFF FUNCTION TO DISPLAY A SINGLE STAFF RECORD
;Take an argument in RDI that is equal to the base address of that particular staff record
display_staff:
    push rbp
    mov rbp, rsp
    sub rsp, 32
    
    push rbx
    push rdi
    push r9
    push r10
    push r11
    push r12
    
    mov rbx, rdi ; RBX now contains the the base address of the individual record
    
    ;Print Surname
    mov rdi, lbl_surname
    call print_string_new
    lea rdi, [rbx + staff_surname_pfb]
    call print_string_new
    call print_nl_new
    
    ;Print Firstname
    mov rdi, lbl_firstname
    call print_string_new
    lea rdi, [rbx + staff_firstname_pfb]
    call print_string_new
    call print_nl_new
    
    ;Print Staff ID
    mov rdi, lbl_staff_id
    call print_string_new
    lea rdi, [rbx + staff_id_pfb]
    call print_string_new
    call print_nl_new
    
    ;Print Staff DEPARTMENT
    mov rdi, lbl_department
    call print_string_new
    movzx r9, BYTE[rbx + staff_dept_pfb] ;SAVE the value of department (1, 2 or 3) to 69
    ;Print the deparment based on the integer stored in r9
    cmp r9, 1
    je print_dept_1
    cmp r9, 2
    je print_dept_2
    cmp r9, 3
    je print_dept_3
    
    
    
    print_dept_1:
        mov rdi, dept_1
        call print_string_new
        call print_nl_new
        jmp print_years
    print_dept_2:
        mov rdi, dept_2
        call print_string_new
        call print_nl_new
        jmp print_years
    print_dept_3:
        mov rdi, dept_3
        call print_string_new
        call print_nl_new
        jmp print_years
        
    print_years:
    ;Print YEars of Experience
    mov rdi, lbl_staff_years
    call print_string_new
    ; years of Experience = current_year - staff_year
    movzx r10, WORD[rbx + staff_year_pfb]
    movzx r11, WORD[current_year]
    sub r11, r10 ;NOW R11 hold the value of years of experience
    mov rdi, r11
    call print_int_new
    call print_nl_new
    
    ;Print ANNUAL SALARY
    mov rdi, lbl_current_salary
    call print_string_new
    ;CALCULATE CURRENT SALAry
    ; current salary = starting salary + (200 * years of experience)
    ;mov rcx, r11
    imul r11, 200
    movzx r12, WORD[rbx + staff_salary_pfb]
    add r11, r12
    mov rdi, r11
    call print_int_new
    call print_nl_new
    
    
    ;Print EMAIL
    mov rdi, lbl_email
    call print_string_new
    lea rdi, [rbx + staff_email_pfb]
    call print_string_new
    call print_nl_new

    pop r12
    pop r11
    pop r12
    pop r9
    pop rdi
    pop rbx
    
    add rsp, 32
    pop rbp
    ret
; END OF DISPLAY_STAFF FUNCT 
                                  
        
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
    
        
        ; TEST to SEE if PROGRAM can DETECT if max number of entries has been reached
        ;mov QWORD[staff_count], 101
        call request_date
        menu_loop:
            call display_menu
            jmp menu_loop
            
        
        
        
        
        
        
        
        
        
        add rsp, 32
        pop rbp
        ret ; Return from main function