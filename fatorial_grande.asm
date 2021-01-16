;Author: Ruan Felipe de Almeida Silva

%include "io.inc"

section .bss
    res RESD 25
section .text
    size EQU 25
global CMAIN
CMAIN:
    mov ebp, esp; for correct debugging
    GET_DEC 4, EBX ;recebendo o numero do usuario
    mov EAX, 0 ;zerando eax
    mov ESI, (size-1)*4 ;altera o valor do indice ESI
    mov [res+ESI], EBX; coloca-se o numero recebido na posicao do vetor menos significativa
    mov ECX, EBX ;inicia o contador 
    dec ECX ;decresce um do contador pois o 1ºnumero ja esta la no vetor
    jle F1F0
    mov EDX, 0 ;zerando o contador de carry EDX
  
FATORIAL:
    push ECX
    call SOMADEGRANDES ;chama a funcao SOMADEGRANDES para realizar a soma 
    pop ECX
    loop FATORIAL ;continua o loop do fatorial de acordo com o contador 
   
    PRINT:
    mov ECX, size ;move para o contador o tamanho do array
    mov ESI, 0 ;move para o indice ESI, o valor inicial 0
    ESCREVE:
        PRINT_HEX 4, [res+ESI] ;printa o resultado do fatorial
        add ESI, 4 ;incrementa em 4 o valor de ESI, para pular pra proxima posição
        loop ESCREVE
    xor eax, eax
    ret
 
 F1F0: ;etiqueta para o calculo de fatorial do 0 ou 1
    mov EAX, 1 ;move o resultado desse fatorial para EAX
    call SAVE ;chama a função para salvar nao memória
    jmp PRINT ;salta para a etiqueta para printar

;-----------------------------------------------------------------------  
SAVE: ;Salva na memoria o valor contido da soma que estava no acumulador EAX
 ;Receives: EAX, ESI, [res]
 ;Returns: [res+ESI]
    mov [res+ESI], EAX ;salva-se os dados em resultado no devido campo do vetor
    ret        
;-----------------------------------------------------------------------   

;-----------------------------------------------------------------------    
SOMADEGRANDES: ;funcao para realizar a soma dos numeros
 ;Receives: EAX, EBX, ECX, EDX, ESI, EDI, [res]
 ;Returns: [res+ESI]
 ;Requires: armazenar o valor de ECX antes de chamar essa função
        mov ESI, size*4 ;leva o ESI para o fim
        mov EDX, 0 ;zera o registrador de carry
        LACO_EXTERNO:
            mov EAX, 0  ;zera o contador
            push ECX ;salva o valor de ECX, pois ele eh o contador dessa vez
            sub ESI, 4 ;subtrai-se 4 do ESI para comecar as somas entre as respectivas posicoes do vetor
            add EAX, EDX ;adiciona-se o carry caso haja
            mov EDX, 0 ;zera o carry atual
            mov EBX, [res+ESI] ;move o valor para EBX  
            SUM:
                add EAX, EBX ;inicia-se as somas
                jnc FINAL ;caso nao haja carry pula para FINAL
                inc EDX ;caso haja carry incrementa 1 no contador de carry EDX
                FINAL:
                loop SUM
             call SAVE     
             pop ECX             ;busca da pilha o valor de ECX
             sub ESI, 0          ;espera ate que ESI tenha zerado
             jnz LACO_EXTERNO  ;enquanto ESI for diferente de zero ele executa o laco externo novamente    
      ret
;-----------------------------------------------------------------------    