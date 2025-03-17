.data
    
    v: .space 5150
    aux: .space 5150
    dim_vector: .long 1024
    dim_nou: .long -1
    teste: .long -1
    cod: .long -1
    n: .long -1
    zero: .long 0
    gasit_add: .long 0
    gasit: .long 0
    lim_inf: .long 9
    x: .long 0
    y: .long 0
    st: .long -1
    dr: .long -1
    indi: .long -1
    indj: .long -1
    indl: .long -1
    dim: .long -1
    ok: .long 0
    copie: .long -1
    id: .long -1
    mem: .long -1
    a3: .long 23
    a4: .long 24
    format_citire_numar: .asciz "%ld"
    format_citire_doua: .asciz "%ld %ld"
    format_afisare_numar: .asciz "%ld "
    format_afisare_interval: .asciz "(%ld, %ld)\n"
    format_afisare_interval_cu_id: .asciz "%ld: (%ld, %ld)\n"
    debug1: .asciz "trec aici\n"
    debug0: .asciz "ajung aici\n"
    terminat_delete: .asciz "am terminat delete ul \n"
    terminat_get: .asciz "am terminat get ul \n"
    terminat_defrag: .asciz "am terminat defrag ul \n"
    
.text
FUNCTIE_ADD:
    pushl $n # nr de operatii
    pushl $format_citire_numar
    call scanf
    add $8, %esp


    for_operatii: # for(i=1;i<=n;i++)
        mov n, %eax
        cmp $0, %eax
        je iesire_for_operatii
        decl n
        movl $0, gasit_add

        # citim perechea (id, mem), citire care se face invers
        pushl $mem
        pushl $id
        pushl $format_citire_doua
        call scanf
        add $12, %esp

        # mem=(mem/8)+(mem%8==0?0:1)
        # pentru a evita o eticheta in plus putem sa adaugam 7
        mov mem, %edx
        cmp %edx, lim_inf
        jg lasamcuafisarea
        jmp sari_aici
        lasamcuafisarea:
        xor %eax, %eax
        pushl %eax
        pushl %eax
        mov id, %ebx
        pushl %ebx
        pushl $format_afisare_interval_cu_id
        call printf
        add $16, %esp

        pushl $0
        call fflush
        add $4, %esp
        jmp for_operatii
        sari_aici:
        mov $0, %edx
        addl $7, mem

        mov mem, %eax
        mov $8, %ebx
        idiv %ebx
        mov %eax, mem
        ###### interval de lungime: mem
        #######              si id: id

        movl $0, indi
        parcurgere_vector: # for(j=0;j<256;j++)
            mov indi, %eax
            incl indi
            mov %eax, copie
            cmp dim_vector, %eax
            je inca_o_iesire

            
            mov copie, %eax
            mov %eax, x
            mov $1, %ecx # %ecx = spatiu liber
            mov %ecx, y
            #indicele curent este in %eax=copie
            parcurgere_vector_again: # for(l=j;l<256;l++) numaram 0
                
                mov x, %eax
                incl x
                
                cmp dim_vector, %eax #verificam l<256
                je iesire_parc1_vector
                
                mov v(,%eax,4),%ebx # v[%eax]=%ebx

                cmp zero, %ebx #verificam v[l]==0
                jne iesire_parc1_vector
                mov y, %ecx
                incl y
                # cautam cat spatiu liber avem pana la (final sau !=0)
                jmp parcurgere_vector_again
            iesire_parc1_vector:
               
            cmp %ecx, mem
            jg parcurgere_vector# inseamna ca nu avem spatiu suficientt => 
            
            movl $1, gasit_add
            mov $1, %ecx
            mov id, %edx
            mov copie, %eax
            mov %eax, x
            mov %ecx, y
            umplere_vector:
                mov x, %eax
                mov y, %ecx
                incl x
                incl y

                cmp mem,%ecx
                jg iesire_umplere_vector
                
                

                mov id, %edx
                mov %edx, v(,%eax,4)
                

                jmp umplere_vector
            iesire_umplere_vector:
            decl %eax
            mov %eax, %ebx
            pushl %ebx
            mov copie, %ebx
            pushl %ebx
            mov id, %ebx
            pushl %ebx
            pushl $format_afisare_interval_cu_id
            call printf
            add $16, %esp

            pushl $0
            call fflush
            add $4, %esp
            
            jmp for_operatii
        inca_o_iesire:
        xor %eax, %eax
        pushl %eax
        pushl %eax
        mov id, %ebx
        pushl %ebx
        pushl $format_afisare_interval_cu_id
        call printf
        add $16, %esp

        pushl $0
        call fflush
        add $4, %esp
        jmp for_operatii
    iesire_for_operatii:
    
    jmp for_teste
    movl $0, indi
    movl $0, gasit
    afisare_vector:
    ################ afisare vector
        mov indi, %eax
        
        cmp %eax, dim_vector # (ind<256)
        je iesim
        incl indi

        # v[%eax] = v(,%eax,4)
        
        mov v(,%eax,4), %ebx # in ebx este v[%eax]

        cmp zero, %ebx
        je afisare_vector
        movl $1, gasit
        mov %eax, st
        mov %eax, indj

        afisare_vector_parcurgere:
            mov indj, %eax
            incl indj
            

            cmp %eax, dim_vector
            je iesire_parc2_vector

            mov v(,%eax,4), %ecx
            
            mov st, %edx
            mov v(,%edx,4),%ebx

            cmp %ebx, %ecx
            jne iesire_parc2_vector
            
            



            jmp afisare_vector_parcurgere
        

        iesire_parc2_vector:
        /*

        ################### afisare
        pushl $debug1
        call printf
        add $4, %esp

        pushl $0
        call fflush
        add $4, %esp
        ########################
        */
        decl indj
        mov indj, %eax
        mov %eax, indi
        decl indj
        mov indj, %eax

        mov %eax, dr
        mov st, %eax
        mov v(,%eax,4),%ebx
        mov %ebx, id

        mov dr, %ebx
        pushl %ebx
        mov st, %ebx
        pushl %ebx
        mov id, %ebx
        pushl %ebx
        pushl $format_afisare_interval_cu_id
        call printf
        add $16, %esp

        pushl $0
        call fflush
        add $4, %esp
        jmp afisare_vector
    ################
    iesim:
    
    jmp for_teste
FUNCTIE_GET:
    
    pushl $id # nr de operatii
    pushl $format_citire_numar
    call scanf
    add $8, %esp
    xor %eax, %eax
    mov %eax, indi
    mov %eax, st
    mov %eax, dr
    movl $0, gasit
    parcurgere_vector_get:
        mov indi, %eax
        incl indi
        

        cmp %eax, dim_vector
        je iesire_parcurgere_vector_get
        
        mov v(,%eax,4),%edx

        cmp id, %edx
        jne parcurgere_vector_get
        movl $1, gasit
        mov %eax, st
        mov %eax, indj
        parcurgere_vector_get_again:
            mov indj, %eax
            
            cmp %eax, dim_vector
            je iesire_parcurgere_vector_get
            mov v(,%eax,4),%edx
            
            cmp %edx, id
            jne iesire_parcurgere_vector_get
            incl indj
            jmp parcurgere_vector_get_again


        jmp parcurgere_vector_get

    iesire_parcurgere_vector_get:
    movl $0, dr
    mov gasit, %eax
    cmp zero, %eax
    je caz_special_get

    decl indj    
    mov indj, %eax
    mov %eax,dr
    caz_special_get:
    ######## afisare
    pushl dr
    pushl st
    pushl $format_afisare_interval
    call printf
    add $12, %esp

    pushl $0
    call fflush
    add $4, %esp
    #############

    jmp for_teste
FUNCTIE_DELETE:
    pushl $id # nr de operatii
    pushl $format_citire_numar
    call scanf
    add $8, %esp
    xor %eax, %eax
    mov %eax, indi
    parcurgere_vector_delete:
        mov indi, %eax
        incl indi

        cmp %eax, dim_vector # ind<256
        je iesire_parcurgere_vector_delete

        mov v(,%eax,4), %edx
        cmp %edx, id
        jne parcurgere_vector_delete

        mov $0, %edx
        mov %edx, v(,%eax,4)

        jmp parcurgere_vector_delete

    iesire_parcurgere_vector_delete:

    movl $0, indi
    jmp afisare_vector #### vom face afisarea din add
FUNCTIE_DEFRAGMENTATION:
    
    xor %eax, %eax
    mov %eax, indi
    mov %eax, indj
    mov %eax, dim_nou
    parcurgere_vector_defrag:
        mov indi, %eax
        incl indi

        cmp %eax, dim_vector # ind<256
        je iesire_parcurgere_vector_defrag

        mov v(,%eax,4), %edx
        cmp %edx, zero
        je parcurgere_vector_defrag

        mov v(,%eax,4), %edx
        mov indj, %eax
        incl indj
        mov %edx, aux(,%eax,4)
        jmp parcurgere_vector_defrag

    iesire_parcurgere_vector_defrag:
    
    umple_cu_zero:
        movl indj, %eax
        incl indj

        cmp %eax, dim_vector
        je iesire_umplere

        xor %ebx, %ebx
        mov %ebx, aux(,%eax,4)

        jmp umple_cu_zero
    iesire_umplere:
    xor %eax, %eax
    mov %eax, indi
    copiaza:
        mov indi, %eax
        incl indi
        cmp %eax, dim_vector # ind<256
        je iesire_copiere_defrag



        mov aux(,%eax,4), %ebx
        mov %ebx, v(,%eax,4)

        jmp copiaza
    iesire_copiere_defrag:
    
    movl $0, indi
    jmp afisare_vector

.global main
main:
    pushl $teste
    pushl $format_citire_numar
    call scanf # citim nr de teste 
    add $8, %esp 

for_teste:
    mov teste, %eax
    cmp $0, %eax
    je exit_program
    
    pushl $cod
    pushl $format_citire_numar
    call scanf
    add $8, %esp

    decl teste

    movl cod, %edx #vezi sa nu folosesti edx
    cmp $1, %edx
    je FUNCTIE_ADD
    
    cmp $2, %edx
    je FUNCTIE_GET

    cmp $3, %edx
    je FUNCTIE_DELETE

    cmp $4, %edx
    je FUNCTIE_DEFRAGMENTATION
    
    jmp for_teste
    
exit_program:
    mov $1, %eax
    mov $0, %ebx
    int $0x80

/*
6 1 5
1 124
4 350
121 75
254 1024
70 30
2 121
*/