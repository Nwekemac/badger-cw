%include "/home/malware/asm/joey_lib_io_v9_release.asm"
global main

section .data


section .text
    main:
    mov rbp, rsp; for correct debugging
        ; Create a stack frame
        push rbp
        mov rbp, rsp
        sub rsp,32
    
        add rsp, 32
        pop rbp
        
        ret ; Return from main function