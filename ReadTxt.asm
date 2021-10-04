section	.data

pedido		db	"Insira o nome do ficheiro: "
tam_ped		equ	$-pedido

section .bss

TAMFICH		equ	30
ficheiro	resb	TAMFICH

TAMANHO		equ	80
texto		resb	TAMANHO

num1		resd	1
nfich		resd	1
nlidos		resd	1

section	.text

global	_start
_start:

	;Pedir nome do ficheiro
	mov	eax, 4
	mov	ebx, 1
	mov	ecx, pedido
	mov	edx, tam_ped
	int	0x80
	
	;Ler o nome do ficheiro
	mov	eax, 3
	mov	ebx, 0
	mov	ecx, ficheiro
	mov	edx, TAMFICH
	int	0x80
	dec	eax
	
	;Colocar o '\0' no fim do nome do ficheiro
	add	eax, ficheiro
	mov	byte[eax], 0
	
	;Abrir ficheiro para leitura
	mov	eax, 5
	mov	ebx, ficheiro
	mov	ecx, 0		; Modo de abretura 0 = READ
	int	0x80
	mov	[nfich], eax	; O eax tem 4 bytes por isso nao e preciso por byte antes
	
ciclo:
	;Ler Conteudo do ficheiro
	mov	eax, 3
	mov	ebx, [nfich]
	mov	ecx, texto
	mov	edx, TAMANHO
	int	0x80
	mov	[nlidos], eax
	
	
	mov	esi, texto	; ESI = string de origem
	mov	edi, texto	; EDI = string de destino
	mov	ecx, [nlidos]	; PÃµe no ECX o nÂº de bytes a processar
	cld			; apaga a flag de direÃ§Ã£o
	xor	edx, edx	;
ciclo2:
	lodsb			; Copia letra da string para o AL
	cmp	al, 10
	je	vereficar	; verifica se e \n
	cmp	al, 10
	jne	armazenar1	; verifica se e \n
	
vereficar:
	inc	edx
	jmp	ciclo2
armazenar1:
	cmp	byte[edx], 0	;Quando nao ve nunhum \n o edx esta a zero ent armazena o nm1
	jne	ciclo2
	jmp armazenar
armazenar:
	stosb			; Copia letra do AL para a string
	loop ciclo2

final:
	; Escrever texto no ecra
	mov	eax, 4
	mov	ebx, 1
	mov	ecx, texto
	mov	edx, [nlidos]
	int	0x80
	
	;testar se chegamos no final do ciclo
	cmp	dword[nlidos], TAMANHO
	je	ciclo
	
	;Fechar Ficheiro
	mov	eax, 6
	mov	ebx, [nfich]
	int	0x80
	
	;Sair
	mov	eax, 1
	mov	ebx, 0
	int	0x80
	

