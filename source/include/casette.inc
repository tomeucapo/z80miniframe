;
; Cassette file types
;

LeadLen     equ     128 

LeadByte    equ     $55         ; Lead byte
SyncByte	equ 	$3C 		; Sync byte in cassete files


BlkNameFileType    equ     $00  ; Name file type ID
BlkDataType        equ     $01  ; Data block type ID
BlkEOFType         equ     $FF  ; End of file block type ID

