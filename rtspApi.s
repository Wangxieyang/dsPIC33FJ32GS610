
.ifdef __dsPIC33F
.include "p33fxxxx.inc"
.endif

.ifdef __PIC24H
.include "p24hxxxx.inc"
.endif


.equ    FLASH_PAGE_ERASE_CODE, 	0x4042
.equ    FLASH_ROW_PROG_CODE, 	0x4001

	.global _flashPageRead
	.global _flashPageErase
	.global _flashPageWrite
	.global _flashPageModify

	.section .text


_flashPageRead:
        push    TBLPAG
        mov     w0, TBLPAG
        mov     #512, w3

readNext:     
		tblrdl  [w1],[w2++]
		tblrdh	[w1++],w6		; Discard PM upper byte
        dec     w3, w3
        bra     nz, readNext

		clr 	w0
 		pop     TBLPAG
        return


_flashPageModify:
		sl 		w0,#7,w0 	
		add		w0,w3,w3	
				
modifyNext:     
		mov	   [w2++],[w3++]	; Discard PM upper byte
        dec     w1, w1
        bra     nz, modifyNext

		return


_flashPageErase:
        push    TBLPAG

        mov     w0, TBLPAG		; Init Pointer to row to be erased
		tblwtl  w1,[w1]			; Dummy write to select the row

								; Setup NVCON for page erase
		mov   	#FLASH_PAGE_ERASE_CODE,w7
        mov     w7, NVMCON
		bset 	w7,#WR
		disi 	#5				; Block all interrupt with priority <7 for next 5 instructions	
		mov     #0x55, W0
        mov     W0, NVMKEY
        mov     #0xAA, W0
        mov     W0, NVMKEY		
		mov     w7,NVMCON		; Start Program Operation
        nop
        nop


erase_wait:     
		btsc    NVMCON, #WR
        bra     erase_wait

		clr 	w0
		pop     TBLPAG
        return


_flashPageWrite:
        push    TBLPAG
        mov     w0, TBLPAG		; Init Pointer to row to be programed
		
		mov		#0,w6
		mov		#8,w5			; w5=row counter
row_loop:
	    mov 	#64,w3

pinst_loop: 
		tblwtl  [W2++],[W1]
		tblwth  w6,[W1++]		; load 0x00 into 3rd byte (will be decoded as NOP should PC attempt to execute)

        dec     w3, w3
        bra     nz, pinst_loop
		
		/*Device ID errata workaround */
		sub #8,w1			;move pointer back to the address with MSB 0x18
		sub #8,w2			;move pointer back to the data for address with MSB 0x18
		tblwtl  [W2],[W1] ;reload latch at the address with MSB 0x18 with original data
		add #8,w1   ;restore register
		add #8,w2   ;restore register

								; Setup NVCON for row program
		mov   	#FLASH_ROW_PROG_CODE,w7
        mov     w7, NVMCON
		bset 	w7,#WR
		disi 	#5				; Block all interrupt with priority <7 for next 5 instructions	
		mov     #0x55, W0
        mov     W0, NVMKEY
        mov     #0xAA, W0
        mov     W0, NVMKEY		
		mov     w7,NVMCON		; Start Program Operation
        nop
        nop
	
prog_wait:     
		btsc    NVMCON, #WR
        bra     prog_wait

		dec     w5, w5
		bra     nz, row_loop

		clr 	w0
        pop     TBLPAG
		
        return


.end
