.data
    
    v: .space 4194400
    aux: .space 4194400
    dim_vector: .long 1024
    dim_total: .long 1048576
    /*v: .space 360
    aux: .space 360
    dim_vector: .long 8
    dim_total: .long 64*/
    lim_inf: .long 9
    dim_nou: .long -1
    teste: .long -1
    cod: .long -1
    gasit: .long 0
    n: .long -1
    zero: .long 0
    x: .long 0
    y: .long 0
    st: .long -1
    dr: .long -1
    fosti: .long 0
    fostj: .long 0
    fostlin: .long 0
    indi: .long -1
    indj: .long -1
    indl: .long -1
    dim: .long -1
    ok: .long 0
    poz: .long 0
    lin: .long 0
    copie: .long -1
    alin: .long -1
    ai: .long -1
    aj: .long -1
    contor: .long 0
    id: .long -1
    mem: .long -1
    elem: .long -1
    format_citire_numar: .asciz "%ld"
    format_citire_doua: .asciz "%ld %ld"
    format_afisare_enter: .asciz "\n"
    format_afisare_numar: .asciz "%ld "
    format_afisare_interval: .asciz "(%ld, %ld)\n"
    format_afisare_interval_cu_id: .asciz "%ld: (%ld, %ld)\n"
    format_afisare_interval_mat: .asciz "((%ld, %ld), (%ld, %ld))\n"
    format_afisare_interval_mat_id: .asciz "%ld: ((%ld, %ld), (%ld, %ld))\n"
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
        jg caz_special_add
        jmp sari_aci
        caz_special_add:
        xor %ebx, %ebx
        pushl %ebx
        pushl %ebx
        pushl %ebx
        pushl %ebx
        mov id, %ebx
        pushl %ebx
        pushl $format_afisare_interval_mat_id
        call printf
        add $24, %esp

        pushl $0
        call fflush
        add $4, %esp
        jmp for_operatii
        sari_aci:
        mov $0, %edx
        addl $7, mem

        mov mem, %eax
        mov $8, %ebx
        idiv %ebx
        mov %eax, mem

        ########### AFISARE 
        /*mov mem, %ebx
        pushl %ebx
        mov id, %ebx
        pushl %ebx
        pushl $format_afisare_interval
        call printf
        add $12, %esp

        pushl $0
        call fflush
        add $4, %esp */
        ###### interval de lungime: mem
        #######              si id: id

        movl $0, indi
        movl $0, indj
        movl $0, lin
        movl $0, poz

        parcurgere_vector_add_pentru_i: # for(i=0;i<256;i++)
            mov indi, %eax
            incl indi
            
            cmp dim_vector, %eax
            je iesire_pt_i

            movl $0, indj
            parcurgere_vector_add_pentru_j:
                mov indj, %eax
                incl indj
                cmp dim_vector, %eax
                je iesire_parcurgere_add_cu_j
                mov lin, %eax
                add indj, %eax
                decl %eax
                mov %eax, poz

                mov v(,%eax,4),%edx
                cmp %edx, zero
                jne parcurgere_vector_add_pentru_j
                ######## am intrat intr un if(v[poz]==0)

                movl $0, copie #### asta o sa fie un fel de contor
                mov indj, %ebx
                mov %ebx, indl
                decl indl
                parcurgere_verificare_add:
                    mov indl, %eax
                    incl indl

                    cmp dim_vector, %eax
                    je iesire_parcurgere_add_cu_l

                    mov lin, %eax
                    add indl, %eax
                    decl %eax
                    mov v(,%eax,4),%edx
                    cmp %edx, zero
                    jne iesire_parcurgere_add_cu_l
                    mov copie, %ebx
                    incl %ebx
                    mov %ebx, copie
                    jmp parcurgere_verificare_add

                iesire_parcurgere_add_cu_l:
                mov copie, %ebx
                cmp %ebx, mem
                jg parcurgere_vector_add_pentru_j
                # acum inseamna ca am spatiu suficient
                mov indj, %ebx
                mov %ebx, indl
                decl indl
                xor %ecx, %ecx
                umplere_matrice:
                    mov indl, %eax
                    incl indl

                    cmp dim_vector, %eax
                    je iesire_umplere_matrice
                    
                    incl %ecx
                    cmp mem, %ecx
                    jg iesire_umplere_matrice
                    mov id, %ebx

                    mov lin, %eax
                    add indl, %eax
                    decl %eax
                    mov %ebx,v(,%eax,4)

                    jmp umplere_matrice
                iesire_umplere_matrice:
                ##### mai ramane sa facem afisarea
                #### (indi, indj, indi, indl)
                
                decl indi
                decl indj
                decl indl
                decl indl
                mov indl, %ebx
                pushl %ebx
                mov indi, %ebx
                pushl %ebx
                mov indj, %ebx
                pushl %ebx
                mov indi, %ebx
                pushl %ebx
                mov id, %ebx
                pushl %ebx
                pushl $format_afisare_interval_mat_id
                call printf
                add $24, %esp

                pushl $0
                call fflush
                add $4, %esp

                incl indi
                incl indj
                incl indl 
                jmp for_operatii

            iesire_parcurgere_add_cu_j:
            mov lin, %eax
            add dim_vector, %eax
            mov %eax, lin
            jmp parcurgere_vector_add_pentru_i
        iesire_pt_i:
        xor %ebx, %ebx
        pushl %ebx
        pushl %ebx
        pushl %ebx
        pushl %ebx
        mov id, %ebx
        pushl %ebx
        pushl $format_afisare_interval_mat_id
        call printf
        add $24, %esp

        pushl $0
        call fflush
        add $4, %esp
        jmp for_operatii
    iesire_for_operatii:
    jmp for_teste
    movl $0, indi
    movl $0, indj
    movl $0, lin
    parcurgere_afisare:
        mov indi, %eax
        incl indi

        cmp dim_vector, %eax
        je iesire
        movl $0, indj
        parcurgere_aux:
            mov indj, %eax
            incl indj
            cmp dim_vector, %eax
            je iesire_parcurgere

            mov lin, %eax
            add indj, %eax
            decl %eax

            /*mov v(,%eax,4),%ebx
            pushl %ebx
            pushl $format_afisare_numar
            call printf
            add $8, %esp

            pushl $0
            call fflush
            add $4, %esp */

            mov v(,%eax,4),%ebx
            cmp %ebx, zero
            je parcurgere_aux
            mov %ebx, x
            mov indj, %eax
            mov %eax, indl
            decl indl
            alta_parcurgere:
                mov indl, %eax
                incl indl
                cmp dim_vector, %eax
                je iesire_alta_parcurgere
                mov lin, %eax
                add indl, %eax
                decl %eax
                mov v(,%eax,4),%ebx
                cmp x, %ebx
                jne iesire_alta_parcurgere

                jmp alta_parcurgere
            iesire_alta_parcurgere:
            decl indi
            decl indj
            decl indl
            decl indl
            mov indl, %ebx
            pushl %ebx
            mov indi, %ebx
            pushl %ebx
            mov indj, %ebx
            pushl %ebx
            mov indi, %ebx
            pushl %ebx
            mov x, %ebx
            pushl %ebx
            pushl $format_afisare_interval_mat_id
            call printf
            add $24, %esp

            pushl $0
            call fflush
            add $4, %esp

            incl indi
            incl indj
            incl indl
            mov indl, %eax
            mov %eax, indj
            
            jmp parcurgere_aux
        iesire_parcurgere:
        mov lin, %eax
        add dim_vector, %eax
        mov %eax, lin
        /*pushl $format_afisare_enter
        call printf
        add $4, %esp

        pushl $0
        call fflush
        add $4, %esp */

        jmp parcurgere_afisare
    iesire:
    
    jmp for_teste
FUNCTIE_GET:
    pushl $id # nr de operatii
    pushl $format_citire_numar
    call scanf
    add $8, %esp

    xor %eax, %eax
    movl $0, indi
    movl $0, indj
    movl $0, indl
    movl $0, st
    movl $0, dr
    movl $0, gasit
    movl $0, lin
    parcurgere_get:
        mov indi, %eax
        incl indi

        cmp dim_vector, %eax
        je iesire_parcurgere_get
        movl $0, indj
        parcurgere_get_j:
            mov indj, %eax
            incl indj
            cmp %eax, dim_vector
            je iesire_parcurgere_get_j
            mov lin, %eax
            add indj, %eax
            decl %eax
            mov v(,%eax,4),%ebx
            cmp id, %ebx
            jne parcurgere_get_j
            movl $1, gasit
            mov indj, %eax
            mov %eax, indl
            decl indl
            parcurgere_get_l:
                mov indl, %eax
                incl indl
                cmp %eax, dim_vector
                je iesire_parcurgere_get
                mov lin, %eax
                add indl, %eax
                decl %eax
                mov v(,%eax,4),%ebx
                cmp id, %ebx
                jne iesire_parcurgere_get
                jmp parcurgere_get_l
            jmp parcurgere_get_j
        iesire_parcurgere_get_j:
        mov lin, %eax
        add dim_vector, %eax
        mov %eax, lin
        /*pushl $format_afisare_enter
        call printf
        add $4, %esp

        pushl $0
        call fflush
        add $4, %esp */

        jmp parcurgere_get
    iesire_parcurgere_get:
    decl indi
    decl indj
    decl indl
    decl indl
    mov gasit, %eax
    cmp %eax, zero
    jne afisam_get
    movl $0, indi
    movl $0, indj
    movl $0, indl
    afisam_get:
    ######## afisare
    mov indl, %ebx
    pushl %ebx
    mov indi, %ebx
    pushl %ebx
    mov indj, %ebx
    pushl %ebx
    mov indi, %ebx
    pushl %ebx
    pushl $format_afisare_interval_mat
    call printf
    add $20, %esp

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

        cmp %eax, dim_total # ind<256
        je iesire_parcurgere_vector_delete

        mov v(,%eax,4), %edx
        cmp %edx, id
        jne parcurgere_vector_delete

        mov $0, %edx
        mov %edx, v(,%eax,4)

        jmp parcurgere_vector_delete

    iesire_parcurgere_vector_delete:
    movl $0, indi
    movl $0, indj
    movl $0, indl
    movl $0, lin
    jmp parcurgere_afisare #### vom face afisarea din add
FUNCTIE_DEFRAGMENTATION:
    movl $0, fosti
    movl $0, fostj
    movl $0, fostlin
    jmp incepem_aici
    adaugare:
    mov fosti, %eax
    mov %eax, indi
    mov fostj, %eax
    mov %eax, indj
    mov fostlin, %eax
    mov %eax, lin

    parcurgere_vector_defrag_pentru_i: # for(i=0;i<256;i++)
        mov indi, %eax
        mov %eax, fosti
        incl indi
        
        cmp dim_vector, %eax
        je revenire

        movl $0, indj
        parcurgere_vector_defrag_pentru_j:
            mov indj, %eax
            mov %eax, fostj
            incl indj
            cmp dim_vector, %eax
            je iesire_parcurgere_defrag_cu_j
            mov lin, %eax
            add indj, %eax
            decl %eax

            mov aux(,%eax,4),%edx
            cmp %edx, zero
            jne parcurgere_vector_defrag_pentru_j
            ######## am intrat intr un if(v[poz]==0)

            movl $0, copie #### asta o sa fie un fel de contor
            mov indj, %ebx
            mov %ebx, indl
            decl indl
            parcurgere_verificare_defrag:
                mov indl, %eax
                incl indl

                cmp dim_vector, %eax
                je iesire_parcurgere_defrag_cu_l

                mov lin, %eax
                add indl, %eax
                decl %eax
                mov aux(,%eax,4),%edx
                cmp %edx, zero
                jne iesire_parcurgere_defrag_cu_l
                mov copie, %ebx
                incl %ebx
                mov %ebx, copie
                jmp parcurgere_verificare_defrag

            iesire_parcurgere_defrag_cu_l:
            mov copie, %ebx
            cmp %ebx, mem
            jg parcurgere_vector_defrag_pentru_j
            # acum inseamna ca am spatiu suficient
            mov indj, %ebx
            mov %ebx, indl
            decl indl
            xor %ecx, %ecx
            umplere_matrice_def:
                mov indl, %eax
                incl indl

                cmp dim_vector, %eax
                je iesire_umplere_matrice_def
                
                incl %ecx
                cmp mem, %ecx
                jg iesire_umplere_matrice_def
                mov id, %ebx

                mov lin, %eax
                add indl, %eax
                decl %eax
                mov %ebx,aux(,%eax,4)

                jmp umplere_matrice_def
            iesire_umplere_matrice_def:
            jmp revenire

        iesire_parcurgere_defrag_cu_j:
        mov lin, %eax
        add dim_vector, %eax
        mov %eax, lin
        mov %eax, fostlin
        jmp parcurgere_vector_defrag_pentru_i
    incepem_aici:
    movl $0, indi
    movl $0, indj
    movl $0, lin
    afisare_aux:
        mov indi, %eax
        incl indi
        cmp %eax, dim_vector
        je iesire_afisare_aux
        movl $0, indj
        afisare_aux_j:
            mov indj, %eax
            incl indj
            cmp %eax, dim_vector
            je iesire_afisare_aux_j
            mov lin, %eax
            add indj, %eax
            decl %eax

            mov aux(,%eax,4),%ebx
            xor %ebx, %ebx
            mov %ebx, aux(,%eax,4)
            /*pushl %ebx
            pushl $format_afisare_numar
            call printf
            add $8, %esp

            pushl $0
            call fflush
            add $4, %esp */
            jmp afisare_aux_j
            
        iesire_afisare_aux_j:
        mov lin, %eax
        add dim_vector, %eax
        mov %eax, lin
        
        /*pushl $format_afisare_enter
        call printf
        add $4, %esp

        pushl $0
        call fflush
        add $4, %esp*/
        jmp afisare_aux
    iesire_afisare_aux:
    xor %eax, %eax
    movl $0, indi
    movl $0, indj
    movl $0, indl
    movl $0, lin
    parcurgere_defrag:
        mov indi, %eax
        incl indi

        cmp dim_vector, %eax
        je iesire_parcurgere_defrag
        movl $0, indj
        parcurgere_defrag_j:
            mov indj, %eax
            incl indj
            cmp %eax, dim_vector
            je iesire_parcurgere_defrag_j

            mov lin, %eax
            add indj, %eax
            decl %eax

            mov v(,%eax,4),%ebx
            cmp zero, %ebx
            je parcurgere_defrag_j

            mov %ebx, id
            mov indj, %eax
            mov %eax, indl
            decl indl
            movl $0, mem
            parcurgere_defrag_l:
                mov indl, %eax
                incl indl
                cmp %eax, dim_vector
                je iesire_parcurgere_defrag_l

                mov lin, %eax
                add indl, %eax
                decl %eax

                mov v(,%eax,4),%ebx
                cmp id, %ebx
                jne iesire_parcurgere_defrag_l
                incl mem
                jmp parcurgere_defrag_l
            iesire_parcurgere_defrag_l:

            mov indl, %eax
            mov %eax, indj
            decl indj
            mov indi, %eax
            mov %eax, ai
            mov indj, %eax
            mov %eax, aj
            mov lin, %eax
            mov %eax, alin
            mov mem, %edx
            # cmp %edx, lim_inf
            # jg revenire
            jmp adaugare
            revenire: 
            mov aj, %eax
            mov %eax, indj
            mov ai, %eax
            mov %eax, indi
            mov alin, %eax
            mov %eax, lin
            
            /*decl indi
            mov mem, %ebx
            pushl %ebx
            mov id, %ebx
            pushl %ebx
            mov indi, %ebx
            pushl %ebx
            pushl $format_afisare_interval_cu_id
            call printf
            add $12, %esp

            pushl $0
            call fflush
            add $4, %esp
            incl indi*/
            jmp parcurgere_defrag_j
        iesire_parcurgere_defrag_j:
        mov lin, %eax
        add dim_vector, %eax
        mov %eax, lin
        /*pushl $format_afisare_enter
        call printf
        add $4, %esp

        pushl $0
        call fflush
        add $4, %esp */

        jmp parcurgere_defrag
    iesire_parcurgere_defrag:
    movl $0, indi
    movl $0, indj
    movl $0, lin
    copiere:
        mov indi, %eax
        incl indi
        cmp %eax, dim_vector
        je iesire_copiere
        movl $0, indj
        copiere_j:
            mov indj, %eax
            incl indj
            cmp %eax, dim_vector
            je iesire_copiere_j
            mov lin, %eax
            add indj, %eax
            decl %eax

            mov aux(,%eax,4),%ebx
            mov %ebx, v(,%eax,4)
            # xor %ebx, %ebx
            # mov %ebx, aux(,%eax,4)
            /*pushl %ebx
            pushl $format_afisare_numar
            call printf
            add $8, %esp

            pushl $0
            call fflush
            add $4, %esp */
            jmp copiere_j
            
        iesire_copiere_j:
        mov lin, %eax
        add dim_vector, %eax
        mov %eax, lin
        /*pushl $format_afisare_enter
        call printf
        add $4, %esp

        pushl $0
        call fflush
        add $4, %esp*/
        jmp copiere
    iesire_copiere: 
    movl $0, indi
    movl $0, indj
    movl $0, lin
    jmp parcurgere_afisare

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