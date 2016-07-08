(SETQ XS    5)    ; start x positie
(SETQ YS    5)    ; start y positie
(SETQ HOR   100)   ; hor afstand positie
(SETQ VRT   100)   ; ver afstand positie
(SETQ HMAX  20)   ; maximum aantal in horizontale richting



(DEFUN C:SYMBOLS( / )
'   (COMMAND "LAYER" "M" "IPUNT" "C" "6" "IPUNT" "")
'   (COMMAND "LAYER" "M" "BLNAAM" "C" "1" "BLNAAM" "")
   (SETVAR "ATTREQ" 0)
   (SETQ IPOINT (LIST XS YS))
   (SETQ FIJL (OPEN (FINDFILE "SYMBOLS.TXT") "r"))  ; file met alle symbolen
   (SETQ H 0)                     ; teller in horizontale richting
   (SETQ V 0)                     ; teller in verticale richting
   (SETQ SYMB 1)
   (WHILE (/= SYMB nil)
      (SETQ X (+ XS (* H HOR)))
      (SETQ Y (+ YS (* V VRT)))
      (SETQ IPOINT (LIST X Y))
      (SETQ SYMB (READ-LINE FIJL))
      (IF (/= SYMB nil)
         (PROGN
            (COMMAND "LAYER" "S" "0" "")
            (COMMAND "INSERT" SYMB IPOINT "1" "1" "0")
'            (COMMAND "LAYER" "S" "IPUNT" "")
'            (COMMAND "POINT" IPOINT)
'            (COMMAND "LAYER" "S" "BLNAAM" "")
'            (SETQ Y (- Y 6))
'            (SETQ IPT (LIST X Y))
'            (COMMAND "TEXT" IPT "2" "0" SYMB)
         )
      )
      (IF (= H HMAX)
         (PROGN
            (SETQ H 0)
            (SETQ V (1+ V))
         )
         (PROGN
            (SETQ H (1+ H))
         )
      )
   )
)
