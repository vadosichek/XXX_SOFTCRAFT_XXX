;Вариант 11
;Разработать программу, которая вводит одномерный массив A[N], формирует из элементов массива A новый массив B по правилам, указанным в таблице, и выводит его. Память под массивы может выделяться как статически, так и динамически по выбору разработчика.
;Разбить решение задачи на функции следующим образом:
;Ввод и вывод массивов оформить как подпрограммы.
;Выполнение задания по варианту оформить как процедуру
;Организовать вывод как исходного, так и сформированного массивов
;Указанные процедуры могут использовать данные напрямую (имитация процедур без параметров). Имитация работы с параметрами также допустима.
;Массив B из элементов A, за исключением первого положительного


format PE console
entry start

include 'win32a.inc'

;--------------------------------------------------------------------------
section '.data' data readable writable

        strVecSize   db 'size of vector? ', 0
        strIncorSize db 'Incorrect size of vector = %d', 10, 0
        strVecElemI  db '[%d]? ', 0
        strScanInt   db '%d', 0
        strVecElemOut  db '[%d] = %d', 10, 0

        vec_size     dd 0
        vec_size2    dd 0
        sum          dd 0
        i            dd ?
        tmp          dd ?
        tmpStack     dd ?
        vec          rd 100
        vec2         rd 100
        flag         dd 0
        zero         dd 0

;--------------------------------------------------------------------------
section '.code' code readable executable
start:
        call VectorInput
        call VectorGeneration
        call VectorOut
finish:
        call [getch]

        push 0
        call [ExitProcess]

;--------------------------------------------------------------------------
VectorInput:
        push strVecSize
        call [printf]
        add esp, 4

        push vec_size
        push strScanInt
        call [scanf]
        add esp, 8

        mov eax, [vec_size]
        cmp eax, 0
        jg  getVector
; fail size
        push vec_size
        push strIncorSize
        call [printf]
        push 0
        call [ExitProcess]
; else continue...
getVector:
        xor ecx, ecx            ; ecx = 0
        mov ebx, vec            ; ebx = &vec
getVecLoop:
        mov [tmp], ebx
        cmp ecx, [vec_size]
        jge endInputVector       ; to end of loop

        ; input element
        mov [i], ecx
        push ecx
        push strVecElemI
        call [printf]
        add esp, 8

        push ebx
        push strScanInt
        call [scanf]
        add esp, 8

        mov ecx, [i]
        inc ecx
        mov ebx, [tmp]
        add ebx, 4
        jmp getVecLoop
endInputVector:
        ret
;--------------------------------------------------------------------------
VectorGeneration:
        mov [vec_size2], 0
        mov [flag], 0
        xor ecx, ecx            ; ecx = 0
        mov ebx, vec            ; ebx = &vec
        mov edx, vec2           ; edx = &vec2
        jmp passLoop
passEnd:
        inc ecx
        add ebx, 4
        jmp passLoop
miss:
        mov [flag], 1
        jmp passEnd
save:
        inc [vec_size2]
        mov eax, [ebx]
        mov [edx], eax
        add edx, 4
        jmp passEnd
check:
        cmp dword [ebx], 0
        jg miss
        jmp save
passLoop:
        cmp ecx, [vec_size]
        je endPassLoop      ; to end of loop

        cmp [flag], 0
        je check
        jmp save
endPassLoop:
        ret
;--------------------------------------------------------------------------
VectorOut:
        mov [tmpStack], esp
        xor ecx, ecx            ; ecx = 0
        mov ebx, vec2            ; ebx = &vec
putVecLoop:
        mov [tmp], ebx
        cmp ecx, [vec_size2]
        je endOutputVector      ; to end of loop
        mov [i], ecx

        ; output element
        push dword [ebx]
        push ecx
        push strVecElemOut
        call [printf]

        mov ecx, [i]
        inc ecx
        mov ebx, [tmp]
        add ebx, 4
        jmp putVecLoop
endOutputVector:
        mov esp, [tmpStack]
        ret
;-------------------------------third act - including HeapApi--------------------------
                                                 
section '.idata' import data readable
    library kernel, 'kernel32.dll',\
            msvcrt, 'msvcrt.dll',\
            user32,'USER32.DLL'

include 'api\user32.inc'
include 'api\kernel32.inc'
    import kernel,\
           ExitProcess, 'ExitProcess',\
           HeapCreate,'HeapCreate',\
           HeapAlloc,'HeapAlloc'
  include 'api\kernel32.inc'
    import msvcrt,\
           printf, 'printf',\
           scanf, 'scanf',\
           getch, '_getch'