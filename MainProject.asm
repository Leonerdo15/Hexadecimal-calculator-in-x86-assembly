section  .data

cabeca		db	"------------ Calculadora Leo & Jose ------------", 10, 10
tam_cab		equ	$-cabeca

tabela		db	"1- Soma ", 10, "2- Subtraçao", 10, "3- Multiplicaçao", 10, "4- Divisao", 10, 10
tam_tab		equ	$-tabela

pedido		db	"Insira um número: "
tam_ped		equ	$-pedido

p_sinal		db	"Insira opçao: "
tam_sinal	equ	$-p_sinal

p_cont		db	"Deseja fazer mais operacoes? ", 10, 10, "1- Sim", 10, "2- Nao", 10, 10, "Escolha: "
tam_cont	equ	$-p_cont

msg_erro		db	"Valor invalo!!!", 10, 10
tam_err		equ	$-msg_erro

msg_result	db	"Resultado: "
tam_res		equ	$-msg_result

f_cabeca	db	"-------------------- Fim ---------------------", 10
tam_fcab	equ	$-f_cabeca

LINHA		db	10	; ENTER ou newline

section  .bss

TAMANHO		equ	9
strnum		resb	TAMANHO
nlidos		resd	1



TAMSL		equ	1
sinal		resb	TAMSL

TAMCONT		equ	1
cont		resb	TAMCONT

nlidos1		resd	1

num1		resd	1
num2		resd	1
res		resd	1

section  .text

global  _start
_start:
;**************************************************** Cabeçalho **************************************************************;
	; Print do cabeçalho
	mov	eax, 4		;
	mov	ebx, 1
	mov	ecx, cabeca
	mov	edx, tam_cab
	int	0x80

;******************************************************** Num 1 **************************************************************;
	; Pedir o número 1
	mov	eax, 4		;
	mov	ebx, 1
	mov	ecx, pedido
	mov	edx, tam_ped
	int	0x80
	
	; Ler o número 1
	mov	eax, 3
	mov	ebx, 0
	mov	ecx, strnum
	mov	edx, TAMANHO
	int	0x80
	dec	eax
	mov	[nlidos], eax
	
	; Converter string para número
	; Em C seria: num1 = atoi(strnum, nlidos);
	push	qword[nlidos]
	push	strnum
	call	atoi
	add	rsp, 16
	mov	[num1], eax
	
;******************************************************** Num 2 **************************************************************;
	; Pedir outro número 2
	mov	eax, 4
	mov	ebx, 1
	mov	ecx, pedido
	mov	edx, tam_ped
	int	0x80
	
	; Ler o número 2
	mov	eax, 3
	mov	ebx, 0
	mov	ecx, strnum
	mov	edx, TAMANHO
	int	0x80
	dec	eax
	mov	[nlidos], eax
	
	; Converter string para número
	; Em C seria: num2 = atoi(strnum, nlidos);
	push	qword[nlidos]
	push	strnum
	call	atoi
	add	rsp, 16
	mov	[num2], eax
;*********************************************** Escolher a operaçao *********************************************************;
	; Pedir das opçoes
	mov	eax, 4		
	mov	ebx, 1
	mov	ecx, tabela
	mov	edx, tam_tab
	int	0x80
;***************************************************** Sinal *****************************************************************;
	
	; Pedir o sinal
	mov	eax, 4
	mov	ebx, 1
	mov	ecx, p_sinal
	mov	edx, tam_sinal
	int	0x80
	
	; Ler o sinal
	mov	eax, 3
	mov	ebx, 0
	mov	ecx, sinal
	mov	edx, TAMSL
	int	0x80
	jmp	erro1
	
erro1:
	cmp byte[sinal], '1'
    	jl	erro
    	cmp byte[sinal], '4'
    	jg	erro
    	
    	jmp	continua
	
erro:
	; Pedir o msg erro
	mov	eax, 4
	mov	ebx, 1
	mov	ecx, msg_erro
	mov	edx, tam_err
	int	0x80
	
	; Pedir o sinal
	mov	eax, 4
	mov	ebx, 1
	mov	ecx, p_sinal
	mov	edx, tam_sinal
	int	0x80
	
	; Ler o sinal
	mov	eax, 3
	mov	ebx, 0
	mov	ecx, sinal
	mov	edx, TAMSL
	int	0x80
	
	; Ler o sinal
	mov	eax, 3
	mov	ebx, 0
	mov	ecx, sinal
	mov	edx, TAMSL
	int	0x80
	jmp	erro1

continua:
	; Comapra o sinal inserido e dependendo do sinal vai fazer a opreaçao correspondida 
    	cmp byte[sinal], '1'
    	je	add
    	cmp byte[sinal], '2'
    	je	subtract
    	cmp byte[sinal], '3'
    	je	multiply
    	cmp byte[sinal], '4'
    	je	divide

add:
	; Somar os números
	push	qword[num1]
	push	qword[num2]
	call	soma
	add	rsp, 16
	mov	[res], eax
	jmp acabou
	
subtract:
	; Subtrai os números
	push	qword[num1]
	push	qword[num2]
	call	subt
	add	rsp, 16
	mov	[res], eax
	jmp acabou
multiply:
	; Multiplica os numeros
	push	qword[num1]
	push	qword[num2]
	call	multi
	add	rsp, 16
	mov	[res], eax
	jmp acabou
divide:
	; Dividir os numeros
	push	qword[num1]
	push	qword[num2]
	call	divid
	add	rsp, 16
	mov	[res], eax
	jmp acabou
	
;***************************************************** Fim *******************************************************************;

acabou:

;Este acabou e preciso para o programa nao realizar as outras operaaçoes 

	; Converter número para string
	; Em C seria: itoa(res, strnum);
	push	strnum
	push	qword[res]
	call	itoa
	add	rsp, 16
	mov	[nlidos], eax
	
	; Print "Resultado: "
	mov	eax, 4		
	mov	ebx, 1
	mov	ecx, msg_result
	mov	edx, tam_res
	int	0x80
	
	; Imprimir número
	mov	eax, 4
	mov	ebx, 1
	mov	ecx, strnum
	mov	edx, [nlidos]
	int	0x80
	
	; Imprimir ENTER
	mov	eax, 4
	mov	ebx, 1
	mov	ecx, LINHA
	mov	edx, 1
	int	0x80
	
continuar1:
	; Print para saber se continua
	mov	eax, 4		
	mov	ebx, 1
	mov	ecx, p_cont
	mov	edx, tam_cont
	int	0x80
	
	; Ler cont
	mov	eax, 3
	mov	ebx, 0
	mov	ecx, cont
	mov	edx, TAMCONT
	int	0x80
	
	; Ler cont
	mov	eax, 3
	mov	ebx, 0
	mov	ecx, cont
	mov	edx, TAMCONT
	int	0x80
	
	cmp	byte[cont], '1'
	jne	final
	cmp	byte[cont], '1'
	je	outravez

	
outravez:
	; Pedir outro número 2
	mov	eax, 4
	mov	ebx, 1
	mov	ecx, pedido
	mov	edx, tam_ped
	int	0x80
	
	; Ler o número 2
	mov	eax, 3
	mov	ebx, 0
	mov	ecx, strnum
	mov	edx, TAMANHO
	int	0x80
	dec	eax
	mov	[nlidos], eax
	
	; Ler o número 2
	mov	eax, 3
	mov	ebx, 0
	mov	ecx, strnum
	mov	edx, TAMANHO
	int	0x80
	dec	eax
	mov	[nlidos], eax
	
	; Converter string para número
	; Em C seria: num2 = atoi(strnum, nlidos);
	push	qword[nlidos]
	push	strnum
	call	atoi
	add	rsp, 16
	mov	[num2], eax
;*********************************************** Escolher a operaçao *********************************************************;
	; Pedir das opçoes
	mov	eax, 4		
	mov	ebx, 1
	mov	ecx, tabela
	mov	edx, tam_tab
	int	0x80
;***************************************************** Sinal *****************************************************************;
	
	; Pedir o sinal
	mov	eax, 4
	mov	ebx, 1
	mov	ecx, p_sinal
	mov	edx, tam_sinal
	int	0x80
	
	; Ler o sinal
	mov	eax, 3
	mov	ebx, 0
	mov	ecx, sinal
	mov	edx, TAMSL
	int	0x80
	jmp	erro2
	
erro2:
	cmp byte[sinal], '1'
    	jl	erro3
    	cmp byte[sinal], '4'
    	jg	erro3
    	
    	jmp	continua4
	
erro3:
	; Pedir o msg erro
	mov	eax, 4
	mov	ebx, 1
	mov	ecx, msg_erro
	mov	edx, tam_err
	int	0x80
	
	; Pedir o sinal
	mov	eax, 4
	mov	ebx, 1
	mov	ecx, p_sinal
	mov	edx, tam_sinal
	int	0x80
	
	; Ler o sinal
	mov	eax, 3
	mov	ebx, 0
	mov	ecx, sinal
	mov	edx, TAMSL
	int	0x80
	
	; Ler o sinal
	mov	eax, 3
	mov	ebx, 0
	mov	ecx, sinal
	mov	edx, TAMSL
	int	0x80
	jmp	erro2

continua4:
	; Comapra o sinal inserido e dependendo do sinal vai fazer a opreaçao correspondida 
    	cmp byte[sinal], '1'
    	je	add1
    	cmp byte[sinal], '2'
    	je	subtract1
    	cmp byte[sinal], '3'
    	je	multiply1
    	cmp byte[sinal], '4'
    	je	divide1

add1:
	xor	eax, eax
	; Somar os números
	push	qword[num2]
	push	qword[res]
	call	soma
	add	rsp, 16
	mov	[res], eax
	jmp acabou1
	
subtract1:
	; Subtrai os números
	push	qword[res]
	push	qword[num2]
	call	subt
	add	rsp, 16
	mov	[res], eax
	jmp acabou1
multiply1:
	; Multiplica os numeros
	push	qword[res]
	push	qword[num2]
	call	multi
	add	rsp, 16
	mov	[res], eax
	jmp acabou1
divide1:
	; Dividir os numeros
	push	qword[res]
	push	qword[num2]
	call	divid
	add	rsp, 16
	mov	[res], eax
	jmp acabou1
	
;***************************************************** Fim *******************************************************************;

acabou1:

;Este acabou e preciso para o programa nao realizar as outras operaaçoes 

	; Converter número para string
	; Em C seria: itoa(res, strnum);
	push	strnum
	push	qword[res]
	call	itoa
	add	rsp, 16
	mov	[nlidos], eax
	
	; Print "Resultado: "
	mov	eax, 4		
	mov	ebx, 1
	mov	ecx, msg_result
	mov	edx, tam_res
	int	0x80
	
	; Imprimir número
	mov	eax, 4
	mov	ebx, 1
	mov	ecx, strnum
	mov	edx, [nlidos]
	int	0x80
	
	; Imprimir ENTER
	mov	eax, 4
	mov	ebx, 1
	mov	ecx, LINHA
	mov	edx, 1
	int	0x80
	jmp	continuar1
	
		
final:	
	
	; Print do cabeçalho
	mov	eax, 4		
	mov	ebx, 1
	mov	ecx, f_cabeca
	mov	edx, tam_fcab
	int	0x80
	
	; Ler cont
	mov	eax, 3
	mov	ebx, 0
	mov	ecx, cont
	mov	edx, TAMCONT
	int	0x80
	
	; Sair
	mov	eax, 1
	mov	ebx, 0
	int	0x80
	
;*********************************************************** Funcoes *********************************************************;
soma:
	push	rbp
	mov	rbp, rsp
	mov	eax, [rbp+24]
	add	eax, [rbp+16]
	pop	rbp
	ret
subt:
	push	rbp
	mov	rbp, rsp
	mov	eax, [rbp+24]	; primeiro numero passado. int(num1, num2) -> [rbp+24] = num1
	sub	eax, [rbp+16]	; segundo numero passado. int(num1, num2) -> [rbp+16] = num2
	pop	rbp
	ret
multi:
	push	rbp
	mov	rbp, rsp
	mov	eax, [rbp+24]
	mov	ebx, [rbp+16]
	mul	ebx		; eax = eax * ebx
	pop	rbp
	ret
divid:
	push	rbp
	mov	rbp, rsp
	xor	edx, edx
	mov	eax, [rbp+24]	;dividendo
	mov	ebx, [rbp+16]	;divisor
	div	ebx		; eax = eax / ebx
	pop	rbp
	ret
; Converter string para número.
; Em C seria:  int atoi(char* strnum, int nlidos);
atoi:
	push	rbp
	mov	rbp, rsp
	xor	eax, eax	; mov eax, 0
	xor	edx, edx	; mov edx, 0
	mov	esi, strnum
	mov	ecx, [nlidos]
	cld
ciclo:
	lodsb
	cmp	al, '9'
	jle	algarismo	; se AL < '9' é algarismo
	add	al, 9		; se for letra, soma 9, para obter hexa correto
algarismo:
	and	al, 0x0F	; passam apenas os 4 bits da direita
	shl	edx, 4		; desloca EDX 4 bits à esquerda
	or	edx, eax	; copia os 4 bits do EAX para o EDX
	loop	ciclo
	
	mov	eax, edx	; Por convenção o retorno é no EAX
	pop	rbp
	ret
	
; Converter número para string
; Em C seria: int itoa(int res, char* strnum);
; devolve o nº de dígitos convertidos
itoa:
	push	rbp
	mov	rbp, rsp
	mov	edi, [rbp+24]
	mov	ecx, 8
	cld
	mov	edx, [rbp+16]
	xor	ebx, ebx	; mov ebx, 0 - indica se já vi dígitos diferentes de zero
	xor	esi, esi	; mov esi, 0 - guarda nº de dígitos convertidos
ciclo2:
	rol	edx, 4		; Roda o EDX 4 bits à esquerda
	mov	eax, edx	; Deixa apenas os 4 bits da direita
	and	eax, 0xF	; Acumula dígitos no EBX	
	add	ebx, eax
	; Verificar se estou no último dígito
	cmp	esi, 0
	jne	converte
	cmp	ecx, 1
	je	converte
	; Se ainda não vi dígitos diferentes de zero, descarta
	cmp	ebx, 0
	jne	converte
	loop	ciclo2
converte:
	inc	esi		; já converti mais um dígito
	cmp	al, 9
	jg	letra		; Se AL > 9, é letra
	add	al, 48		; Soma 48 para obter código ASCII do número
	jmp	fim
letra:
	add	al, 55		; Soma 55, para obter o código ASCII da letra
fim:
	stosb			; Guarda o caráter na string
	loop	ciclo2
	
	mov	eax, esi	; Por convenção, o retorno é no EAX
	pop	rbp
	ret
	
