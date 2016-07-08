
;* **************************************************************************

(setq dXver   80.0            ;* delta X tussen 2 symboolversies
      dYrot   80.0            ;* delta Y tussen Hor. en Vert. symboolversies
      Factor   1.0            ;* ScaleFactor voor Alle Commando's
)

;[===========================================================================]
;[----- PutBlipMark : Plaatst een 'Blip' op een gegeven punt ----------------]
;[                                                                           ]
;[ Param : Ipt    = Insertiepunt voor het punt                               ]
;[         Color  = te gebruiken kleur of -1 voor XOR                        ]
;[ Return: None                                                              ]
;[                                                                           ]
;[- Locals ------------------------------------------------------------------]
;[- Globals -----------------------------------------------------------------]
;[                                                                           ]

(defun PutBlipMark ( Ipt Color / );MarkLen X1 X2 Y1 Y2)
   (setq MarkLen (/ (getvar "VIEWSIZE") 20.0))
   (setq X1 (list (- (car Ipt) Marklen) (- (cadr Ipt) Marklen)))
   (setq X2 (list (+ (car Ipt) Marklen) (+ (cadr Ipt) Marklen)))
   (setq Y1 (list (- (car Ipt) Marklen) (+ (cadr Ipt) Marklen)))
   (setq Y2 (list (+ (car Ipt) Marklen) (- (cadr Ipt) Marklen)))
   (grdraw X1 X2 Color)
   (grdraw Y1 Y2 Color)
)
;* **************************************************************************
;*
;*

(defun MakePoint ( Pos Color Layer / Inf Nam )
   (if Pos
      (progn
         (setq Inf   (entmake (list (cons 0  "POINT")
                                    (cons 8  Layer )
                                    (cons 10 Pos   )
                                    (cons 62 Color )
                              )
                     )
         )
      )
      (setq Inf nil)
   )
   (if Inf
      (setq Nam (entlast))
      (setq Nam nil)
   )
   Nam
)

;* **************************************************************************
;*
;*

(defun PutClpPoints ( IPoint InsPnt / Cnt Pnt SSet Inf Option NewIpt NewPnt )
   (setq Cnt 1)
   (setq SSet (ssadd))

;   (if (/= InsPnt nil)
      (progn
         (setq NewIpt  nil)
         (PutBlipMark InsPnt 6)
      )
      (progn
         (princ "\n Geef Symbool InsertiePunt : ")
         (setq Pnt (getpoint))
;         (if Pnt
;            (progn
;               (setq NewIpt (MakePoint Pnt    256 "IPOINT"))
;            )
;            (progn
;               (setq NewIpt (MakePoint IPoint 256 "IPOINT"))
;            )
;         )
      )
;   )

   (while (/= Cnt nil)
      (princ "\n Geef positie voor Clippunt ")(princ Cnt)(princ " : ")
      (setq Pnt (getpoint))
      (if Pnt
         (progn
            (setq NewPnt (MakePoint Pnt Cnt "C"))
            (if NewPnt
               (setq SSet (ssadd NewPnt SSet))
            )
            (setq Cnt (1+ Cnt))
         )
         (progn
            (setq Cnt nil)
            (princ "\n Geef positie voor Addon punt : ")
            (setq Pnt (getpoint))
            (if Pnt
               (progn
                  (setq NewPnt (MakePoint Pnt 1 "A"))
                  (if NewPnt
                     (setq SSet (ssadd NewPnt SSet))
                  )
               )
            )
         )
      )
   )
   (initget "Yes Ja Nee")
   (setq Option (getkword "\nNieuwe punten in orde <Ja>/Nee ? "))
   (if (= Option "Nee")
      (progn
         (if (/= NewIpt nil)
            (Command "._Erase" SSet NewIpt "")
            (Command "._Erase" SSet "")
         )
         (princ "\nBestaande Clippunten verwijderd.")
         (PutClpPoints IPoint nil)
      )
   )
   (princ)
)

;* **************************************************************************

(defun CheckClpPnt ( SSet / Cnt FoundPnt Nam Inf SymbNam Name LayerName )
   (setq FoundPnt nil)
   (if (/= SSet nil)
      (progn
         (setq Cnt (sslength SSet))
         (while (> Cnt 0)
            (setq SymbNam (ssname SSet (1- Cnt)))
            (setq Inf (entget SymbNam))
            (setq LayerName (cdr (assoc 8 Inf)))
            (if (and (= (cdr (assoc 0 Inf)) "POINT")
                     (OR (= LayerName "C")
                         (= LayerName "A")
                         (= LayerName "IPOINT")
                     )
                )
               (progn
                  (if (= LayerName "IPOINT")
                     (setq FoundPnt (cdr (assoc 10 Inf)))
                  )
                  (if (= FoundPnt nil) (setq FoundPnt 1))
                  (setq Cnt (1- Cnt))
               )
               (progn
                  (if (= (cdr (assoc 0 Inf)) "INSERT")
                     (progn
                        (setq Nam (entlast))
                        (setq Name (cdr (assoc 2 Inf)))
                        (if   (AND  (/= (substr Name 1 1) "*")
                                    (/= Name "DBFBLOCK")
                                    (/= Name "SYMBAREA")
                                    (/= Name "COVER_SHEET")
                              )
                           (progn
                              (ssdel SymbNam SSet)
                              (command "EXPLODE" SymbNam)
                              (setq Nam (entnext Nam))
                              (while (/= Nam nil)
                                 (ssadd Nam SSet)
                                 (setq Nam (entnext Nam))
                              )
                              (setq Cnt (sslength SSet))
                           )
                           (progn
                              (ssdel SymbNam SSet)
                              (setq Cnt (1- Cnt))
                           )
                        )
                     )
                     (progn
                        (ssdel SymbNam SSet)
                        (setq Cnt (1- Cnt))
                     )
                  )
               )
            )
         )
      )
   )
   FoundPnt
)

;* **************************************************************************
;* Definieer block...

(defun BlockClpPnt ( XIPoint YIPoint / ULPnt LRPnt symbent Retval)
   ;* Bepaal Window coordinaten...
   (setq ULPnt (list (- XIpoint (/ (* dXver Factor) 2)) (- YIpoint (/ (* dYrot Factor) 2))))
   (setq LRPnt (list (+ XIpoint (/ (* dXver Factor) 2)) (+ YIpoint (/ (* dYrot Factor) 2))))
   ;* Zoom Window ter informatie...
   (command "ZOOM" "W" ULPnt LRPnt)
   ;* Select entities die samen het symbool vormen...
   (setq symbent (ssget "W" ULPnt LRPnt))
   (if (AND (/= symbent nil)
            (> (sslength symbent) 1)
       )
      (progn
         (setq Retval 1)
         ;* Check selectieset...
         (setq ISymb (CheckClpPnt symbent))
         (if (/= ISymb nil)
            (progn
               (initget "Yes Ja Nee")
;               (setq Option (getkword "\nBestaande Clippunten houden <Ja>/Nee ? "))
;               (if (/= Option "Nee")
;                  (progn
;                     (princ "\nClippunten gelaten zoals ze zijn.")
;                  )
;                  (progn
;                     (Command "._Erase" SymbEnt "")
;                     (princ "\nBestaande Clippunten verwijderd.")
                     (PutClpPoints ISymb nil)
;                  )
;               )
            )
            (progn
               (princ "\nWARNING: Symbool gedefinieerd zonder Clippunten!")
               (PutClpPoints ISymb nil)
            )
         )
      )
      (setq Retval nil)
   )
   Retval
)

;* ******************************* Genereer symbool *************************
;*
;* IN: entity die een DBFBLOCK is: een block met de symboolbeschrijving.
;*

(defun GenClpPoints ( Cnt ssent / AttNam AttInf AttTag AttVal )
   (princ "\n --------------------------------------------------")
   (princ (strcat "\nSymb. " (itoa Cnt)))
   ;* Library symbool gegevens: pos, ver, symboolbestandsnaam, ...
   (setq AttNam (entnext ssent))
   (while (/= AttNam nil)
      (setq AttInf (entget AttNam))
      (setq AttTag (cdr (assoc 2 AttInf)))
      (setq AttVal (cdr (assoc 1 AttInf)))

      ;; Valid TagNames for 'Cond' Check are :
      ;;    "NAME"   "TABLETPOS"    "VERSION"      "REFERENCE"
      ;;    "GRAFV"  "GRAFH"        "GRAFL"
      ;;    "TEXTV"  "TEXTH"        "TEXTL"
      ;;    "ADDON"                 "ADDONL"
      ;;    "TYPE"   "NORMNAME"     "NORMCODE"
      ;;    "DESCR"  "CCAPPLICID"
      (cond
         (  (= AttTag "TABLETPOS"   )  (princ (strcat ", Pos:<" AttVal ">")) )
         (  (= AttTag "VERSION"     )  (princ (strcat ", Ver: " AttVal)) )
         (  (= AttTag "NAME"        )  (princ (strcat ", "      AttVal)) )
         (  (= AttTag "GRAFH"       )  (if (> (strlen AttVal) 1)(princ ", HOR")) )
         (  (= AttTag "GRAFV"       )  (if (> (strlen AttVal) 1)(princ ", VER")) )
         (  (= AttTag "CCAPPLICID"  )  (princ (strcat ", ID: "  AttVal)) )
         (  (= AttTag "DESC"        )  (princ (strcat ", \""      AttVal "\"")) )
         (  (not nil)                  (princ) )
      )
      (setq AttNam (entnext AttNam))
      (if (= (cdr (assoc 0 (entget AttNam))) "SEQEND")
         (setq AttNam nil)
      )
   )
   ;* insertiepunt Vert. symbool.
   (setq VerIPoint (cdr (assoc 10 (entget ssent))))

   ;* coordinaten Vert. of Addon en Hor. symbolen...
   (setq VerXIPoint (car  VerIPoint)
         VerYIPoint (cadr VerIPoint)
         HorXIPoint VerXIPoint
         HorYIPoint (- VerYIPoint (* dYrot Factor))
   )
   ;* Genereer Clippunten: Hor. symbool
   (BlockClpPnt HorXIPoint HorYIPoint)

   ;* Genereer Clippunten: Ver. symbool
   (BlockClpPnt VerXIPoint VerYIPoint)
   (princ)
)

(defun GenClipPnt ( / symbEnt Retval ISymb Option )
   ;* Select entities die samen het symbool vormen...
   (setq symbent (ssget "X"))
   (if (AND (/= symbent nil)
            (> (sslength symbent) 1)
       )
      (progn
         (setq Retval 1)
         ;* Check selectieset...
         (setq ISymb (CheckClpPnt symbent))
         (if (/= ISymb nil)
            (progn
;               (initget "Yes Ja Nee")
;               (setq Option (getkword "\nBestaande Clippunten houden <Ja>/Nee ? "))
;               (if (/= Option "Nee")
;                  (progn
;                     (princ "\nClippunten gelaten zoals ze zijn.")
;                  )
;                  (progn
;                     (Command "._Erase" SymbEnt "")
;                     (princ "\nBestaande Clippunten verwijderd.")
                     (PutClpPoints ISymb (getvar "InsBase"))
;                  )
;               )
            )
            (progn
               (princ "\nWARNING: Symbool gedefinieerd zonder Clippunten!")
               (PutClpPoints ISymb (getvar "InsBase"))
            )
         )
      )
      (setq Retval nil)
   )
)

;* ******************************  PutClp  ***********************************
;* Plaatsen van de Clippunten op de symbolen bibliotheek.
;*
;* IN :  Nothing
;* UIT:  Nothing

(defun C:PutClp ( / SvdPickBox ss Cnt ssent)
   ;* Settings...
   (setq SvdPickBox (getvar "PickBox"))
   (setvar "CMDECHO" 0)
   (setvar "PickBox" 0)
   (setvar "REGENMODE" 0)

   ;* Set Start of Undo-Group
   (Command ".UNDO" "GROUP")

   ;* Doe...
   (princ "\nZoekt symboolbeschrijvingen (blocks 'DBFBLOCK')...")
   (setq ss (ssget "X" (list (cons 0 "INSERT") (cons 2 "DBFBLOCK"))))
   (if (/= ss nil)
      (progn
         (setq Cnt (sslength ss))
         (princ (strcat "\n ***  " (itoa Cnt) " gevonden..."))
         (while (> Cnt 0)
            ;* Bepaal entity name...
            (setq ssent (ssname ss (1- Cnt)))
            ;* Genereer symbool...
            (GenClpPoints Cnt ssent)
            ;* Volgende beschrijving...
            (setq Cnt (1- Cnt))
         )
      )
      (progn
         (princ "\n **** Geen symbolen !")
      )
   )

   ;* Zoom naar drawing grens...
   (command "ZOOM" "A")

   ;* Set Start of Undo-Group
   (Command ".UNDO" "END")
   (setvar "PickBox" SvdPickBox)
   (princ)
)

;* ******************************  PutClp  ***********************************
;* Plaatsen van de Clippunten op de symbolen bibliotheek.
;*
;* IN :  Nothing
;* UIT:  Nothing

(defun C:PutClp2 ( / SvdPickBox ss ssent)
   ;* Settings...
   (setq SvdPickBox (getvar "PickBox"))
   (setq ZoomCen (getvar "ViewCtr"))
   (setq ZoomFac (getvar "ViewSize"))
   (setvar "CMDECHO" 0)

   ;* Set Start of Undo-Group
   (Command ".UNDO" "GROUP")

   (princ "\n Selecteer DataBase Block van Huidige symbool versie.")
   (setq Ent (entsel))
   (setvar "PickBox" 0)
   (if (/= Ent nil)
      (progn
         (setq SSent (car Ent))
         ;* Genereer symbool...
         (GenClpPoints 1 ssent)
      )
   )

   (command "._Zoom" "_C" ZoomCen ZoomFac)

   ;* Set Start of Undo-Group
   (Command ".UNDO" "END")
   (setvar "PickBox" SvdPickBox)
   (princ)
)

;* ******************************  PutClp3 ***********************************
;* Plaatsen van de Clippunten op de symbolen bibliotheek.
;*
;* IN :  Nothing
;* UIT:  Nothing

(defun C:PutClp3 ( / SvdPickBox ss ssent)
   ;* Settings...
   (setq SvdPickBox (getvar "PickBox"))
   (setq ZoomCen (getvar "ViewCtr"))
   (setq ZoomFac (getvar "ViewSize"))
   (setvar "CMDECHO" 0)

   ;* Set Start of Undo-Group
   (Command ".UNDO" "GROUP")

   (GenClipPnt)
   (command "._Zoom" "_C" ZoomCen ZoomFac)

   ;* Set Start of Undo-Group
   (Command ".UNDO" "END")
   (setvar "PickBox" SvdPickBox)
   (princ)
)

;* ** Een commando om Marleen tevreden te stellen (Nu kan ze op tablet Kiezen)
;* ** bij de letters (CP=Crossing Poly)

(defun C:Clp() (C:PutClp3) (princ))

;;(princ "\n* PutClp      :  Plaatsen Clippunten op alle aanwezige tabletposities.")
;;(princ "\n* PutClp2     :  Plaatsen Clippunten op Te selecteren tabletpositie.")
(princ "\n* Clp :  Plaatsen Clippunten op een symbool definitie.")
(princ)

