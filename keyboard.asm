

;**************************************************************************************
; TABELA KOD�W KLAWISZY
;**************************************************************************************

klawisze:       .BYTE     0,$7f,"-","0","8","6","4","2",0,0,"@","o","u","t","e","q",0,"=",":","k","h","f","s",0,0,0,".","m","b","c","z",32,0,47,44,"n","v","x",0,9,0,";","l","j","g","d","a",0,13,"*","p","i","y","r","w",1bh,8,0,"+","9","7","5","3","1"
klawisze_shift: .BYTE     0,7fh,"-","0","(","&","$",34,0,0,"@","O","U","T","E","Q",0,"=","(","K","H","F","S",0,0,0,">","M","B","C","Z",32,0,"?","<","N","V","X",0,09h,0,")","L","J","G","D","A",0,13,"*","P","I","Y","R","W",1bh,8,0,"+",")",39,37,35,33
klawisze_ctrl:  .BYTE     0,7fh,"-","0","8","6","4","2",0,0,"@",15,15h,24,05h,17,0,"=",":",11,8,6,13h,0,0,0,".",13,2,3,1ah,32,0,47,44,14,22,18h,0,09h,0,";",12,10,7,4,1,0,13,"*",10h,9,25,12h,23,1bh,8,0,"+","9","7","5","3","1"



;------------MOJE PROCEDURY OBS�UGI KLAWIATURY----
;**************************************************************************************
; Procedura skanuj�ca klawiatur�. U�ywa prtu fffeh w trybie wej�ciowym i wyj�ciowym.
; Na zatrzask wyj�ciowy podawana jest kolejno liczba binarna maj�ca jedno "0" i za ka�dym
; razem "0" jest przesuwane w lewo (instrukcja rlc). Przy ka�dym przesuni�ciu jest 
; odczytywany port fffeh i sprawdzane jest na kt�rym bicie pojawia si� "0". W przypadku 
; wykrycia zera, obliczany jest indeks dla dalszych tablic. Max ilo�� klawiszy to 64
; dla 8bit porty we i 8bit portu wy. 
; Procedura zwraca wynik w akumulatrze. Jest to ff gdy nie naci�ni�to �adnego przycisku
; lub numer indeksu gdy naci�ni�to przycisk. Dodatkowo procedura usupe�nia zmienne w RAM
; dotycz�ce naci�ni�cia shift.
; Na wyj�ciu (w rej. A) mamy numer klawisza (kolejno�� przycisku na matrycy klawiatury)
; Procedura jest nieblokuj�ca.
;**************************************************************************************
start_skan:

	push bc
	push de
	
;sprawdzam czy nacisnieto shift lub ctrl. Skanuj� odpowiedni� kolumn� i wpisuj� j� do pami�ci pod (R_SHIFT_PRESSED)
; (L_SHIFT_PRESSED) oraz (CTRL_PRESSED).
;W poni�szym kodzie warto umie�ci� dodatkowe testy na inne klawisze, b�d� potem interpretowane w procedurze
;keyboard_decode.

;-------------------------
	ld a,11110111b
	ld bc,0fffeh
	out (c),a
	in a,(c)
	ld (R_SHIFT_PRESSED),a

	ld a,11101111b
	ld bc,0fffeh
	out (c),a
	in a,(c)
	ld (L_SHIFT_PRESSED),a	
	
	ld a,11011111b
	ld bc,0fffeh
	out (c),a
	in a,(c)
	ld (CTRL_PRESSED),a
;-------------------------

	ld d,0			; rejestr wynikowy - zawiera indeks naci�ni�tego klawisza. Mapa klawiszy do zamieszczenia w dokumentacji komputera.
	ld e,0feh		; warto�� testuj�ca - na pocz�tku to liczba 11111110b, czyli sprawdzamy od skrajnie prawej kolumny

skanuj_kbd:			; skanujemy wszystkie wiersze z danej kolumny. jak znajdziemy naci�niety przycisk to dodajemy do rej. wynikowego
 ld a,e				; liczb� okre�laj�c� jego po�o�enie w matrycy klawiszy,m przekazujemy j� do a i wychodzimy
 ld bc,0fffeh
 out (c),a
 in a,(c)
 
 bit 0,a
 jr nz,bit1
 ld a,d
	pop de
	pop bc
 ret
 
bit1:
	bit 3,e			;sprawdzamy czy testowana jest kolumna z R-SHIFT, jesli tak, to pomijamy test - sprawdzono shift na pocz. procedury
	jr z,bit2		; nie chcemy aby skan klawiatury zarejestrowa� naci�ni�cie shift.
 bit 1,a
 jr nz,bit2
 ld a,d
 add a,1
	pop de
	pop bc
 ret
 
bit2:
 bit 2,a
 jr nz,bit3
 ld a,d
 add a,2
	pop de
	pop bc
 ret
 
bit3:
 bit 3,a
 jr nz,bit4
 ld a,d
 add a,3
	pop de
	pop bc
 ret

bit4:
 bit 4,a
 jr nz,bit5
 ld a,d
 add a,4
	pop de
	pop bc
 ret
 
bit5:
 bit 5,a
 jr nz,bit6
 ld a,d
 add a,5
	pop de
	pop bc
 ret

bit6:
	bit 4,e			;sprawdzamy czy testowana jest kolumna z L-SHIFT, jesli tak, to pomijamy test - sprawdzono shift na pocz. procedury
	jr z,bit7		; nie chcemy aby skan klawiatury zarejestrowa� naci�ni�cie shift.
 bit 6,a
 jr nz,bit7
 ld a,d
 add a,6
	pop de
	pop bc
 ret
 
bit7:
	bit 5,e			;Omijamy CTRL tak jak SHIFTy
	jr z,dalej
 bit 7,a
 jr nz,dalej
 ld a,d
 add a,7
	pop de
	pop bc
 ret

dalej:
 bit 7,e				;tu po przeskanowaniu wierszy sprawdzamy czy w�a�nie przeskanowali�my ostatni� kolumn� - jak tak (bit 7=0) to a=ff i wychodzimy 
 jr nz,nie_koniec		;z procedury maj�c w a informacj�, �e nie naci�ni�to �adnego klawisza.
 ld a,0ffh
	pop de
	pop bc
 ret
 
nie_koniec:				;po ka�dej przeskanowanej kolumnie przesuwamy wektor testuj�cy w lewo, a do rejestru wynikowego dodajemy 8 i skanujemy
 rlc e					;dalsze kolumny
 ld a,d
 add a,8
 ld d,a
 jp skanuj_kbd

;**************************************************************************************
; Procedura odbieraj�ca numer klawisza z poprzedniej procedury. Numer klawisza z matrycy
; staje si� indeksem do tablic "klawisze" i "klawisze_shift". W tych tablicach znajduj� si�
; nast�puj�ce mo�liwe kody: ASCII - dla normalnych znak�w i znak�w steruj�cych nadaj�cych
; si� do wy�wietlenia, czyli RETURN (10) backspace (8). Najlepiej aby by�y zgodne z ASCII
; Inne typy to kody klawiszy specjalnych , np. Fx,<-,CLR/HOME itp. te b�d� tutaj dekodowane
; i zwracane w akumulatorze jako kod specjalnego klawisza. 
; Klawisze nieoprogramowane - kod 0 s� ignorowane i procedura 
; ko�czy dzia�anie. Rozpoznane Kody ASCII s� przeznaczone do wy�wietlenia procedur� print_char, przedtem
; sprawdzane jest czy naci�ni�ty by� jednocze�nie shift - w�wczas ASCII jest brane z innej 
; tablicy.
; ZWRACAMY: w AKUMULATORZE KOD ASCII ZNAKU Z KLAWIATURY.
;**************************************************************************************

keyboard_decode:
		push bc
		push de
		push hl
		
	   ld d,a
       ld hl,klawisze
       ld bc,0h
       ld c,a
       add hl,bc
       ld a,(hl)

	cp 1
	jr nz,next_key1
;   call zwracamy w akumulatorze kod specjalnego klawisza - do obs�ugi w innej procedurze
;   Prawdopodobnie bedzie potrzeba u�ycia update_command_buffer, aby prawid�owo obs�u�y� wprowadzon� komend�.
; Mo�liwe, �e trzeba b�dzie uzupe�ni� bufor i w��czy� flag�. Nie zdecydowa�em jeszcze.
; Taka fumnkcja "insert into buffer" w pliku util.asm
	jp nic_nie_rob
	
next_key1:
	cp 2
	jr nz,next_key2
;   call zwracamy w akumulatorze kod specjalnego klawisza - do obs�ugi w innej procedurze
;   Prawdopodobnie bedzie potrzeba u�ycia update_command_buffer, aby prawid�owo obs�u�y� wprowadzon� komend�.
; Mo�liwe, �e trzeba b�dzie uzupe�ni� bufor i w��czy� flag�. Nie zdecydowa�em jeszcze.
; Taka fumnkcja "insert into buffer" w pliku util.asm
	jp nic_nie_rob
	
next_key2:		;klawisz nie zostal ani oprogramowany ani nie jest klawiszem specjalnym. Koniec funkcji - nic nie wypisujemy na ekran.
	cp 0
	jr z,nic_nie_rob  	


obsluga_wypisywania_znaku:

;Jak nie kod sterujacy lub nierozpoznany, to wypisz na ekranie: jezeli shift (L lub R) wcisniety to zaladuj ascii z shiftem lub ctrl, jak nie to normalny
	push af
	ld a,(CTRL_PRESSED)
	ld b,a
	pop af
	bit 7,b
	jr z,ctrl_display

	push af
	ld a,(R_SHIFT_PRESSED)
	ld b,a
	pop af
	bit 1,b
	jr z,shift_display

	push af
	ld a,(L_SHIFT_PRESSED)
	ld b,a
	pop af
	bit 6,b
	jr z,shift_display	

	jp normal_display

ctrl_display:

	ld a,d						;ladowanie znaku z CTRL
	ld hl,klawisze_ctrl
    ld bc,0h
    ld c,a
    add hl,bc
    ld a,(hl)

	jp normal_display
	
shift_display:
	
	ld a,d						;ladowanie znaku z shiftem
	ld hl,klawisze_shift
    ld bc,0h
    ld c,a
    add hl,bc
    ld a,(hl)
	
normal_display:					; ostateczne wyswietlenie znaku
			
	
nic_nie_rob:					; gdy klawisz nie oprogramowany, albo po wyswietleniu znaku - normalny powrot
	pop hl
	pop de
	pop bc
	ret
