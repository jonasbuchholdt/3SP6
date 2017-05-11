
	.data


      .text
      
buffer_gain:
	amov    #20000h,XAR4	; Main data page for the circular buffer and circular buffer address initialisation
	amov    #20000h,XAR5
	mov     #3F87h,BSA45		; Starting address Buffer base address is COEFF[0] = 1000 + 10000 = 11000h -->in the SARAM      
	mov     #16,BK47			; Set buffer vsize of 1 words
	mov     #0,AR4			; AR2 points to the second slot in the buffer
	mov     #0,AR5	
	bset    AR4LC			; AR2 is configured as circular pointer 
	bset    AR5LC
	mov     #0x1000, *AR4+	;Input gain	;0
	mov     #0x2000, *AR4+	;0.5		;1
	mov     #0x2CCD, *AR4+	;0.7		;2
	mov     #0x199A, *AR4+	;LD scale	;3
	mov     #0x0CCD, *AR4+	;LD			;4
	mov     #0x1700, *AR4+	;f scale	;5 11EC
	mov     #0x35C3, *AR4+	;f			;6
	mov		#0x3203, *AR4+	;g			;7 2B03
	mov     #0x2D50, *AR4+	;a			;8 0x2D50
	mov     #0x4000, *AR4+	;b1			;9
	mov     #0x399A, *AR4+	;b2			;10
	mov     #0x3334, *AR4+	;b3			;11
	mov     #0x2CCD, *AR4+	;b4			;12
	mov     #0x2667, *AR4+	;b5			;13
	mov     #0x2000, *AR4+	;b6			;14
	mov     #0x2000, *AR4+	;b6			;15
	RET   

	
buffer_coff:
	amov    #20000h,XCDP ; Main data page for the circular buffer and circular buffer address initialisation
	mov     #3F87h,BSAC ; Starting address Buffer base address is COEFF[0] = 1000 + 10000 = 11000h -->in the SARAM      
	mov     #0x14,BKC ; Set buffer vsize of 4 words
	mov     #0,CDP ; AR2 points to the second slot in the buffer
	bset    CDPLC ; AR2 is configured as circular pointer 
	RET
	
	
	
buffer_lpcf_delay:
	amov    #20000h,XAR0 ; Main data page for the circular buffer and circular buffer address initialisation
	amov    #20000h,XAR1    
	mov     #0x70F,BK03 ; Set buffer vsize of 4 words
	mov     #0,AR0 ; AR2 points to the second slot in the buffer
	mov     #0,AR1 ; AR2 points to the second slot in the buffer
	bset    AR0LC ; AR2 is configured as circular pointer 
	bset    AR1LC
	RET	

input_gain:
	mov     #3F87h,BSA45		;Select coffecient
	;Right gain
	MPYM *AR4(0), T2, AC0
	SFTS AC0, #-14, AC0
	MOV AC0, T2
	;left gain
	MPYM *AR4(0), T3, AC0
	SFTS AC0, #-14, AC0
	MOV AC0, T3
	ret

reverb_pre:
	mov     #3F97h,BSA45		;Select X1
	mov     #3878h,BSA01		;Select PreReverb 
	mov		T2, *AR0			;Safe input data into buffer
	mov 	*AR0(-0x100), AC0	;First tab
	mov 	*AR0(-0x101), AC1	;secund tab	
	Add		AC1, AC0			;Y = X(N-ed1)+X(N-ed2)
	mov 	*AR0(-0x102), AC1	;third tab	
	Add		AC1, AC0			;Y = X(N-ed3)+Y
	mov 	*AR0(-0x103), AC1	;forth tab
	Add		AC1, AC0			;X1(N) = X(N-ed3)+Y
	mov 	AC0, *AR5			;Flyt X1(N) i buffer
	ret

reverb_lpcf:

	;get delayed data X1(N-1) initializing 
	mov		AC0,T2				;get X1(N)
	mov		*AR5(-1), AC2		;get X1(N-1)
	;mov		*AR5+, T0			;count up
	mov     #3F87h,BSA01		;Select coffecient
	mov     #3F87h,BSA45		;Select coffecient
	;calculate LD
	mov		#1,CDP
	MPYM 	*AR4(3), *CDP, AC0	;0.5 * user input (init of 0.4)
	SFTS 	AC0, #-14, AC0		;LD	(init LD = 0.2)
	mov		AC0,*AR4(4)			;store LD in AR4 slot number 4
	;calculating X1(N-1)*-LD
	neg		AC0,AC0				;invert the sign for LD
	SFTS 	AC0, #16, AC0		;bit shift
	SFTS 	AC2, #16, AC2		;bit shift
	MPY 	AC0, AC2			;X1(N-1)*-LD
	;SFTS 	AC2, #-14, AC2		;result of X1(N-1)*-LD
	;calculate the g
	;f = 0.5*scaleroom+0.7
	MPYM 	*AR4(5), *CDP, AC1	;0.5 * user input (init of 0.4)
	SFTS 	AC1, #-14, AC1		;bit shift
	add		*AR4(2),AC1			;AR4 slot number 2 + AC1
	mov		AC1, *AR4(6)		;result of f
	; g=f*(1-LD) = f-(f*LD)
	mov		#4,CDP				;LD
	MPYM	*AR4(6), *CDP, AC1		;(f*LD)
	SFTS 	AC1, #-14, AC1		;bit shift
	sub		AC1,*AR4(6),AC1		;f-(f*LD)
	mov		AC1,*AR4(7)			;store g in AR4 slot number 7
	;mov		AC2,T2
	
	;LPCF
LPCF	.macro mem, del, bval 	
	mov     #mem,BSA01			;vælg lpcf1 	
	mov 	*AR0(-1), T0		;X2(N-1) lægges ind i T0
	MPYM 	*AR4(4), T0, AC0	;X2(N-1)*LD
	mov 	*AR0(del), T0		;X2(N-D) lægges ind i AC1
	MPYM 	*AR4(7), T0, AC1	;X2(N-D)*g
	Add		AC2, AC0			;X1(N-1)*-LD + X2(N-1)*LD
	Add		AC1, AC0			;X1(N-1)*-LD + X2(N-1)*LD + X2(N-D)*g
	SFTS 	AC0, #-14, AC0		;bit shift
	add		T2, AC0				;X1(N-1)*-LD + X2(N-1)*LD + X2(N-D)*g + X1(N)
	mov		AC0, *AR0			;gem input data i buffer
	mov		#bval,CDP	
	MPYM 	*AR0, *CDP, AC0		;(X1(N-1)*-LD + X2(N-1)*LD + X2(N-D)*g + X1(N))*b1
	;SFTS 	AC0, #-14, AC0		;bit shift	
	;mov		AC0, T1			;Output store in AC3 (AR0)
	.endm
  	LPCF	0000h, -0x345, 9
  	mov		AC0,AC3
	LPCF	070Fh, -0x3F5, 10
	add		AC0,AC3
	LPCF	0E1Eh, -0x4FE, 11
	add		AC0,AC3
	LPCF	152Dh, -0x556, 12
	add		AC0,AC3
	LPCF	1C3Ch, -0x65E, 13
	add		AC0,AC3
	LPCF	234Bh, -0x70E, 14
	add		AC0,AC3	
	;SFTS 	AC3, #-14, AC3		;bit shift    
    ;mov		AC3,T2
	;mov     #3F97h,BSA45	;Select X1
	;add		*AR5, T2
	;mov		*AR5+, T0			;count up
	;mov		*AR0+, T0
	ret


reverb_allpass:
Allpass	.macro mem, del, aval 	
	mov     #mem,BSA01			;vælg lpcf1	 	
	mov 	*AR0(del), T0		;X2(N-D) lægges ind i T0
	MPYM 	*AR4(aval), T0, AC1	;X2(N-D)*a
	Add		AC3, AC1			;X2(N)+X2(N-D)*a
	SFTS 	AC1, #-14, AC1		;bit shift
	mov		AC1,*AR0			;gemmer X2(N)+X2(N-D)*a
	mov		*AR4(aval),T0		;a
	neg		T0,T0				;-a
	MPYM 	*AR0, T0, AC3		;(X2(N)+X2(N-D)*a)*-a	
 	mov		*AR0(del),AC0		;(X2(N)+X2(N-D)*a)
 	SFTS 	AC0, #14, AC0		;(X2(N)+X2(N-D)*a)>>14
	Add	 	AC0,AC3
	;SFTS 	AC1, #-14, AC3		;bit shift	
	.endm
	
  	Allpass	2A5Ah, -0x2ED, 8 	;-0x2ED
    Allpass	3169h, -0x23D, 8	;-0x23D
	SFTS 	AC3, #-14, AC3		;bit shift    
    mov		AC3,T2
	mov     #3F97h,BSA45	;Select X1
	add		*AR5, T2
	mov		*AR5+, T0			;count up
	mov		*AR0+, T0
	ret
	