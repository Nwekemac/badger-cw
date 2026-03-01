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
    msg_record_not_found: db "Sorry, record no dey!", 0
    msg_record_deleted: db "Delete Successful!", 0

    ; --- add_badger prompts ---
    enter_badger_id:    db "Enter Badger ID (bXXXXXX): ", 0
    enter_badger_name:  db "Enter Badger Name: ", 0
    enter_sett:         db "Enter Home Sett (1: Settfield, 2: Badgerton, 3: Stripeville): ", 0
    enter_mass:         db "Enter Mass in kg: ", 0
    enter_stripes:      db "Enter Number of Stripes (0-255): ", 0
    enter_sex:          db "Enter Sex (M/F): ", 0
    enter_birth_month:  db "Enter Month of Birth (1-12): ", 0
    enter_birth_year:   db "Enter Year of Birth: ", 0
    enter_keeper_id:    db "Enter Keeper Staff ID (pXXXXXXX): ", 0
    badger_full:        db "Error: Badger list is full.", 10, 0

    ; --- display_badger labels ---
    lbl_badger_id:      db "Badger ID: ", 0
    lbl_badger_name:    db "Name: ", 0
    lbl_badger_sett:    db "Home Sett: ", 0
    lbl_badger_mass:    db "Mass (kg): ", 0
    lbl_badger_stripes: db "Stripes: ", 0
    lbl_badger_sex:     db "Sex: ", 0
    lbl_birth_month:    db "Birth Month: ", 0
    lbl_birth_year:     db "Birth Year: ", 0
    lbl_age:            db "Age: ", 0
    lbl_stripiness:     db "Stripiness: ", 0
    lbl_keeper_id:      db "Keeper ID: ", 0

    ; --- sett name strings ---
    sett_1:     db "Settfield", 0
    sett_2:     db "Badgerton", 0
    sett_3:     db "Stripeville", 0








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






    ; --- Badger record field sizes ---
    size_badger_id          equ 8   ; 'b' + 6 digits + NUL
    size_badger_name        equ 65  ; 64 chars max + NUL
    size_badger_sett        equ 1   ; 1=Settfield 2=Badgerton 3=Stripeville
    size_badger_mass        equ 1   ; whole kg, fits in a byte (0-255)
    size_badger_stripes     equ 1   ; 0-255
    size_badger_sex         equ 1   ; ASCII 'M' or 'F'
    size_badger_birth_month equ 1   ; 1-12
    size_badger_birth_year  equ 2   ; e.g. 2017 
    size_badger_keeper_id   equ 9   ; 'p' + 7 digits + NUL
    size_badger_deleted     equ 1   ; 0=active  1=deleted

    ; --- position of field from base address of one badger record ---
    badger_id_pfb           equ 0
    badger_name_pfb         equ badger_id_pfb           + size_badger_id
    badger_sett_pfb         equ badger_name_pfb         + size_badger_name
    badger_mass_pfb         equ badger_sett_pfb         + size_badger_sett
    badger_stripes_pfb      equ badger_mass_pfb         + size_badger_mass
    badger_sex_pfb          equ badger_stripes_pfb      + size_badger_stripes
    badger_birth_month_pfb  equ badger_sex_pfb          + size_badger_sex
    badger_birth_year_pfb   equ badger_birth_month_pfb  + size_badger_birth_month
    badger_keeper_id_pfb    equ badger_birth_year_pfb   + size_badger_birth_year
    badger_deleted_pfb      equ badger_keeper_id_pfb    + size_badger_keeper_id

    ; --- Total size of one record and the whole array ---
    size_badger_record      equ badger_deleted_pfb      + size_badger_deleted
    max_no_badgers          equ 500
    size_badger_array       equ max_no_badgers * size_badger_record

    badger_array:   resb size_badger_array
    badger_count:   resq 1  ; Tracks how many badger slots have been used

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
    ;REF[3]: The copy_string function was introduced in class and likely part of the 
    ;joey_lib_io_v9_release.asm library. It is used in the same manner are demonstrated in the class
    ;assignments
    
    
    
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

    ; Increment Staff Count
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
    pop r10
    pop r9
    pop rdi
    pop rbx
    
    add rsp, 32
    pop rbp
    ret
; END OF DISPLAY_STAFF FUNCT 
                                  
;--------- ADD BADGER FUNCTN -- - - - - - -        
add_badger:
    
    push rbp
    mov rbp, rsp
    sub rsp, 32

    push rbx
    push rcx
    push rdx
    push rdi
    push rsi

    ; Check if the array is full
    mov rax, [badger_count]
    cmp rax, max_no_badgers
    jge .badger_full

    ; Calculating the base address for the new record
    ; base = badger_array + (badger_count * size_badger_record)
    mov rcx, size_badger_record
    mov rax, [badger_count]
    imul rax, rcx
    mov rbx, badger_array
    add rbx, rax        ; RBX = base address of the new record slot

    ; Collect Badger ID
    mov rdi, enter_badger_id
    call print_string_new
    call read_string_new
    mov rsi, rax
    lea rdi, [rbx + badger_id_pfb]
    call copy_string

    ; Collect Name
    mov rdi, enter_badger_name
    call print_string_new
    call read_string_new
    mov rsi, rax
    lea rdi, [rbx + badger_name_pfb]
    call copy_string

    ; Collect Home Sett (1/2/3 stored as one byte)
    mov rdi, enter_sett
    call print_string_new
    call read_uint_new
    mov BYTE[rbx + badger_sett_pfb], al

    ; Collect Mass in kg
    mov rdi, enter_mass
    call print_string_new
    call read_uint_new
    mov BYTE[rbx + badger_mass_pfb], al

    ; Collect Number of Stripes
    mov rdi, enter_stripes
    call print_string_new
    call read_uint_new
    mov BYTE[rbx + badger_stripes_pfb], al

    ; Collect Sex — read as string, store just the first character
    mov rdi, enter_sex
    call print_string_new
    call read_string_new    ; pointer to input buffer in RAX
    mov dl, BYTE[rax]       ; grab the first character ('M' or 'F')
    mov BYTE[rbx + badger_sex_pfb], dl

    ; Collect Month of Birth
    mov rdi, enter_birth_month
    call print_string_new
    call read_uint_new
    mov BYTE[rbx + badger_birth_month_pfb], al

    ; Collect Year of Birth
    mov rdi, enter_birth_year
    call print_string_new
    call read_int_new
    mov WORD[rbx + badger_birth_year_pfb], ax

    ; Collect Keeper Staff ID
    mov rdi, enter_keeper_id
    call print_string_new
    call read_string_new
    mov rsi, rax
    lea rdi, [rbx + badger_keeper_id_pfb]
    call copy_string

    ; Mark record as active (not deleted)
    mov BYTE[rbx + badger_deleted_pfb], 0

    ; Increment badger count
    inc QWORD[badger_count]

    jmp .exit

.badger_full:
    mov rdi, badger_full
    call print_string_new

.exit:
    pop rsi
    pop rdi
    pop rdx
    pop rcx
    pop rbx

    add rsp, 32
    pop rbp
    ret
;------- End add_badger

delete_staff:
    push rbp
    mov rbp, rsp
    sub rsp, 32
    
    push rdi
    push rsi
    push rax
    
    mov rdi, lbl_staff_id
    call print_string_new
    call read_string_new
    mov rdi, rax ;This moves the input into RDI so that it can be passed as
                 ; a parameter for the find_staff_by_ID function
    call find_staff_by_ID ; NOW the base address of the record is here, if the
                          ; record was not found, 0 will be returned
    cmp rax, 0 ; IF RAX = 0, meaning no record was found,
    je .not_found
    
    ;IF NoT, change the staff_deleted field of that record to 1
    mov BYTE[rax + staff_deleted_pfb], 1
    mov rdi, msg_record_deleted
    call print_string_new
    jmp .end
    
    .not_found:
    mov rdi, msg_record_not_found
    call print_string_new
    
    .end:
    pop rax
    pop rsi
    pop rdi
    
    add rsp, 32
    pop rbp
    ret ;
    
delete_badger:
    push rbp
    mov rbp, rsp
    sub rsp, 32

    push rdi
    push rsi
    push rax

    ; REquest Badger ID to delete
    mov rdi, enter_badger_id
    call print_string_new
    call read_string_new

    ; Pass the ID string to find_badger_by_ID
    mov rdi, rax
    call find_badger_by_ID  ; RAX = record address, or 0 if not found

    cmp rax, 0
    je .not_found

    ; Record found — mark it as deleted
    mov BYTE[rax + badger_deleted_pfb], 1 ; Changing it to 1 will cause it to be ignored during display loops and find_badger_by_ID
    mov rdi, msg_record_deleted
    call print_string_new
    jmp .end

.not_found:
    mov rdi, msg_record_not_found
    call print_string_new

.end:
    pop rax
    pop rsi
    pop rdi

    add rsp, 32
    pop rbp
    ret
; End delete_badger    

display_all_staff:
    push rbp
    mov rbp, rsp
    sub rsp, 32
    
    push rbx
    push rcx
    push rdi
    
    mov rdx, 0 ;RDX USED to count number of records found
    
    
    mov rcx, [staff_count]
    mov rbx, staff_array ;RBX now contains the pointer to the base of the staff array
    
    cmp rcx, 0
    je .no_records
    
    .loop:
    cmp BYTE[rbx + staff_deleted_pfb], 0
    jne .next_record ; SKIP if the record has been marked as deleted
    
    mov rdi, rbx
    call display_staff
    inc rdx
    
    .next_record:
    add rbx, size_staff_record ;Jump to the next RECORD
    dec rcx
    cmp rcx, 0
    jne .loop
    
    
    
    .no_records:
    cmp rdx, 0
    jg .end
    mov rdi, msg_record_not_found
    call print_string_new
    
    
    .end:
    pop rdi
    pop rcx
    pop rbx
    
    add rsp, 32
    pop rbp
    ret   
    


;DIsPLAY Badger Function - - - - - - - - - - - - - - - -

; Displays a single badger record in full, including the
; computed age and stripiness values.
; RDI = pointer to the base address of the badger record.

display_badger:
    push rbp
    mov rbp, rsp
    sub rsp, 32

    push rbx
    push rdi
    push r9
    push r10
    push r11
    push r12

    mov rbx, rdi    ; RBX = base address of this badger record

    ; Print Badger ID
    mov rdi, lbl_badger_id
    call print_string_new
    lea rdi, [rbx + badger_id_pfb]
    call print_string_new
    call print_nl_new

    ; Print Name
    mov rdi, lbl_badger_name
    call print_string_new
    lea rdi, [rbx + badger_name_pfb]
    call print_string_new
    call print_nl_new

    ; Print Home Sett — base on the number inputed
    mov rdi, lbl_badger_sett
    call print_string_new
    movzx r9, BYTE[rbx + badger_sett_pfb]
    cmp r9, 1
    je print_sett_1
    cmp r9, 2
    je print_sett_2
    cmp r9, 3
    je print_sett_3

print_sett_1:
    mov rdi, sett_1
    call print_string_new
    call print_nl_new
    jmp print_mass
print_sett_2:
    mov rdi, sett_2
    call print_string_new
    call print_nl_new
    jmp print_mass
print_sett_3:
    mov rdi, sett_3
    call print_string_new
    call print_nl_new

print_mass:
    ; Print Mass in kg
    mov rdi, lbl_badger_mass
    call print_string_new
    movzx rdi, BYTE[rbx + badger_mass_pfb]
    call print_uint_new
    call print_nl_new

    ; Print Number of Stripes
    mov rdi, lbl_badger_stripes
    call print_string_new
    movzx rdi, BYTE[rbx + badger_stripes_pfb]
    call print_uint_new
    call print_nl_new

    ; Print Sex — stored as ASCII character, use print_char_new
    mov rdi, lbl_badger_sex
    call print_string_new
    movzx rdi, BYTE[rbx + badger_sex_pfb]
    call print_char_new
    call print_nl_new

    ; Print Month of Birth
    mov rdi, lbl_birth_month
    call print_string_new
    movzx rdi, BYTE[rbx + badger_birth_month_pfb]
    call print_uint_new
    call print_nl_new

    ; Print Year of Birth
    mov rdi, lbl_birth_year
    call print_string_new
    movzx rdi, WORD[rbx + badger_birth_year_pfb]
    call print_uint_new
    call print_nl_new

    ; ---- Calculating  Age ----
    ; 
    ;   if (currentMonth - birthMonth) >= 0  →  age = currentYear - birthYear
    ;   else                                 →  age = currentYear - birthYear - 1
    ;
    ; r10 = currentYear - birthYear  (base age)
    ; r11 = currentMonth - birthMonth (indicates if birthday passed)
    movzx r10, WORD[current_year]
    movzx r9,  WORD[rbx + badger_birth_year_pfb]
    sub r10, r9                     ; r10 = currentYear - birthYear

    movzx r11, BYTE[current_month]
    movzx r9,  BYTE[rbx + badger_birth_month_pfb]
    sub r11, r9                     ; r11 = currentMonth - birthMonth

    cmp r11, 0
    jge .age_ok                     ; birthday already passed this year
    dec r10                         ; birthday not yet reached — subtract 1
.age_ok:
    mov rdi, lbl_age
    call print_string_new
    mov rdi, r10
    call print_uint_new
    call print_nl_new

    ; ---- Calculating Stripiness ----
    ; stripiness = mass * numberOfStripes
    movzx r11, BYTE[rbx + badger_mass_pfb]
    movzx r12, BYTE[rbx + badger_stripes_pfb]
    imul r11, r12                   ; r11 = mass * stripes

    mov rdi, lbl_stripiness
    call print_string_new
    mov rdi, r11
    call print_uint_new
    call print_nl_new

    ; Print Keeper Staff ID
    mov rdi, lbl_keeper_id
    call print_string_new
    lea rdi, [rbx + badger_keeper_id_pfb]
    call print_string_new
    call print_nl_new

    pop r12
    pop r11
    pop r10
    pop r9
    pop rdi
    pop rbx

    add rsp, 32
    pop rbp
    ret
; End display_badger ---------------------------------


;; DISPLAY ALL BADGER FUNCTION
; LOOPS THrough the records and ignores deleted records
display_all_badger:
    push rbp
    mov rbp, rsp
    sub rsp, 32

    push rbx
    push rcx
    push rdi

    mov rdx, 0              ; RDX counts how many active records are displayed

    mov rcx, [badger_count]
    mov rbx, badger_array   ; RBX = pointer to the first slot

    cmp rcx, 0
    je .no_records

.loop:
    ; Skip deleted records
    cmp BYTE[rbx + badger_deleted_pfb], 0
    jne .next_record

    ; Display this record
    mov rdi, rbx
    call display_badger
    inc rdx

.next_record:
    add rbx, size_badger_record ; Advance RBX to the next slot
    dec rcx
    cmp rcx, 0
    jne .loop

.no_records:
    cmp rdx, 0
    jg .end
    mov rdi, msg_record_not_found
    call print_string_new

.end:
    pop rdi
    pop rcx
    pop rbx

    add rsp, 32
    pop rbp
    ret
; --------End display_all_badger------




find_staff_by_ID:
    ;This function takes the string being pointed to in RDI, and compares it to
    ; the staff_id for that record. If they the same, it returns the value of the 
    ; base pointer to that record into RAX
    
    
    push rbp
    mov rbp, rsp
    sub rsp, 32
    
    
    
    mov rdx, rdi; RDX now contains the ID to search for
    mov rcx, [staff_count]
    mov rbx, staff_array; RBX now contains the pointer to the start of the first slot
    
    .loop:
    ;Check the Value of the last byte of the record to know if has
    ; been marked delete. If it has, ignore it
    cmp BYTE[rbx +staff_deleted_pfb], 0
    jne .next_record
    
    
    lea rsi, [rbx + staff_id_pfb]
    mov rdi, rdx
    ;REF[2] This strings_are_equal function was not developed by me, it was first demonstrated in
    ;The module in the test_strings_are_equal example in module. The function is most likely included
    ;in the joey_lib_io_v9_release.asm file
    call strings_are_equal
    cmp rax, 1; IF RAX is Zero, Strings are not equal
    je .found
    
    cmp rcx, 0
    je .not_found ; If the staff count is Zero, meaning no staff record has been added
    
    .next_record:
    add rbx, size_staff_record ;HERE, RBX now holds the pointer to the next record
    dec rcx ;This will take note that one record out of the total records has been checked
    cmp rcx, 0
    jne .loop ;If the value of RCX is still not equal to 0, jump to the loop and check again
    
   
    
    .not_found:
    mov rax, 0
    jmp .end
    
     .found:
    mov rax, rbx ; Move the value of RBX which is the pointer to the start of the record to RAX
    
    .end:
    add rsp, 32
    pop rbp
    ret ;
    
search_staff:
    push rbp
    mov rbp, rsp
    sub rsp, 32               

    ;REQuest USER ID
    mov rdi, enter_staff_id
    call print_string_new
    call read_string_new      ; ID string pointer now in RAX
    
    ;MOV Value to RDI so that it is used as the parameter for the find_staff_by_ID function
    mov rdi, rax              ;
    call find_staff_by_ID     ; Returns record address in RAX or 0 if there is no record
    
    ;if find_staff_by_ID retunrs 0 into rax, jump to display the error msg.
    cmp rax, 0
    je .not_found
    
    
    ;IF found, move the base address of that record into RDI and display
    mov rdi, rax             
    call display_staff
    jmp .end

.not_found:
    mov rdi, msg_record_not_found      ; Print ERROR if not Found
    call print_string_new
    call print_nl_new

.end:
    add rsp, 32
    pop rbp
    ret
; ------- FIND BADGER BY ID -----------
; Searches badger_array for a record whose badger_id matches he string pointed to by RDI.
; Returns RAX with the base address of the matching record, or 0
find_badger_by_ID:
    push rbp
    mov rbp, rsp
    sub rsp, 32

    mov rdx, rdi            ; RDX = the ID string to search for
    mov rcx, [badger_count]
    mov rbx, badger_array   ; RBX = pointer to first slot

    .loop:
    ; ignore deleted record
    cmp BYTE[rbx + badger_deleted_pfb], 0
    jne .next_record

    ; Compare the stored ID with the search ID
    lea rsi, [rbx + badger_id_pfb]
    mov rdi, rdx
    call strings_are_equal  ; Returns 1 if equal, 0 if not
    cmp rax, 1
    je .found

    cmp rcx, 0
    je .not_found

    .next_record:
    add rbx, size_badger_record
    dec rcx
    cmp rcx, 0
    jne .loop

.not_found:
    mov rax, 0
    jmp .end

.found:
    mov rax, rbx    ; Return the base address of the matching record

.end:
    add rsp, 32
    pop rbp
    ret
; ----- --- - End find_badger_by_ID - - - - - - -  
   
       
               
; - - - - - - Search Badger function - - - - -
search_badger:
    push rbp
    mov rbp, rsp
    sub rsp, 32

    ; Request Badger ID from user
    mov rdi, enter_badger_id
    call print_string_new
    call read_string_new    ; ID string pointer now in RAX

    ; Pass the ID to find_badger_by_ID
    mov rdi, rax
    call find_badger_by_ID  ; Returns record address in RAX or 0

    cmp rax, 0
    je .not_found

    ; Found — display the record
    mov rdi, rax
    call display_badger
    jmp .end

.not_found:
    mov rdi, msg_record_not_found
    call print_string_new
    call print_nl_new

.end:
    add rsp, 32
    pop rbp
    ret
; End search_badger -----------------


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