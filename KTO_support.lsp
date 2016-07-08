;;-----[ Deze functie altijd laten staan ]------------------------------------
(defun KTO_support ()
(princ "KTO_support is loaded")
(princ)
)

;;-----[ Drawing specific values ]------------------------------------
;First part: KTO_TYPE
;First part: KTO_SPEC
;;----- Set used specification: ELEC:NBN ELEC:NEN ELEC:Loop ELEC:Logic ELEC:Install  
;;----- Set used specification: PAID:ISA PAID:DIN 
;;----- Set used specification: SAFE:SAFETY 
;;----- Set used specification: MECH:HYDRPNEU 
;;----- Set used specification: SUPPORT:LIB
;KTO_PHASE: 1 2 3 or more phases

(defun KTO_setprop (type$ val$ / )
    (if (not(KTO_dwgprops-get-custom-prop "KTO_mark" nil))
        (KTO_dwgprops-set-custom-prop "KTO_mark" (rtos KTO_stamp) nil)
    )
    (KTO_dwgprops-set-custom-prop type$ val$ nil)
    (KTO_Statusb)
	(princ)
)

(defun KTO_togglex ( / temp$)
    (if (not(KTO_dwgprops-get-custom-prop "KTO_mark" nil))
        (KTO_dwgprops-set-custom-prop "KTO_mark" (rtos KTO_stamp) nil)
    )
    (if (KTO_dwgprops-get-custom-prop "KTO_togglex" nil)
        (progn
          (setq temp$ (KTO_dwgprops-get-custom-prop "KTO_togglex" nil))
          (if (= temp$ "0")
            (progn(KTO_dwgprops-set-custom-prop "KTO_togglex" "1" nil)(ReplaceThis "   " "XXX"))
            (progn(KTO_dwgprops-set-custom-prop "KTO_togglex" "0" nil)(ReplaceThis "XXX" "   "))
          )
        )
        (progn(KTO_dwgprops-set-custom-prop "KTO_togglex" "0" nil)(ReplaceThis "XXX" "   "))
    )
    (KTO_Statusb)
	(princ)
)

;;-----[ Functie die huidige versie van autocad terugstuurt]----------------

(defun KTO_getAcadVers ( / version)
(setq version (atof (getvar 'AcadVer)))
version
)


;;-----[ Functie die de map waarin autosave file zitten opent]----------------

;(defun C:KTO_AUTOSAVE ( / )
;(startapp "explorer" (strcat "/n,/e," (getvar "SAVEFILEPATH"))) 
;(princ)
;)



;;-----[ Functie die info over Lab2012 geeft ]----------------

;(defun C:KTO_info ( / )
;  (princ "\n")
;  (princ 			"\n[================================================================]")
;  (princ 			"\n[=========================== KiTek Ohm ==========================]")
;  (princ 			"\n[================================================================]")
;  (princ (strcat 	"\n[==================== KiTek Ohm, versie " (rtos KTO_version) " ====================]"))
;  (princ 			"\n[================================================================]")
;  (princ 			"\n[================================================================]")
;  (princ 			"\n[============================== JOKI ============================]")
;  (princ 			"\n[================================================================]")
;  (princ 			"\n")
;  (princ)
;)


;;-----[ Functie die kijkt of de DWG al eerder gebruikt werd door KiTek Ohm]----------------

(defun KTO_checkinstel ( / )
	(if (not(KTO_mark))
		(INSTEL)
	)
)
;(KTO_moveparmeters)
;(princ )




(defun KTO_loaddwg (FileName ReadOnly / )
(vla-activate (vla-Open
 (vla-get-Documents
  (vlax-get-Acad-Object)
 )
 (findfile (strcat FileName ".dwg"))
 (if ReadOnly
  :vlax-true
  :vlax-false
 )
))
)


;;-----[ Functie die kijkt of de DWG al eerder gebruikt werd door KiTek Ohm]----------------

(defun KTO_mark ()
(and (eq (KTO_dwgprops-get-custom-prop "KTO_mark" nil) "8140"))
)

;;-----[ Functies die DWG eigenschappen terugsturen]----------------

(defun KTO_gettype ( / KTO_TYPE )
(if (KTO_dwgprops-get-custom-prop "KTO_TYPE" nil)
(setq KTO_TYPE  (KTO_dwgprops-get-custom-prop "KTO_TYPE" nil))
(setq KTO_TYPE nil)
)
KTO_TYPE
)

(defun KTO_getspec ( / KTO_SPEC )
(if (KTO_dwgprops-get-custom-prop "KTO_SPEC" nil)
(setq KTO_SPEC  (KTO_dwgprops-get-custom-prop "KTO_SPEC" nil))
(setq KTO_SPEC nil)
)
KTO_SPEC
)

(defun KTO_getphase ( / KTO_PHASE )
(if (KTO_dwgprops-get-custom-prop "KTO_PHASE" nil)
(setq KTO_PHASE  (KTO_dwgprops-get-custom-prop "KTO_PHASE" nil))
(setq KTO_PHASE nil)
)
KTO_PHASE
)

(defun KTO_getline ( / KTO_LINE )
(if (KTO_dwgprops-get-custom-prop "KTO_LINE" nil)
(setq KTO_LINE  (KTO_dwgprops-get-custom-prop "KTO_LINE" nil))
(setq KTO_LINE nil)
)
KTO_LINE
)

(defun KTO_gettogglex ( / KTO_toggleX )
(if (KTO_dwgprops-get-custom-prop "KTO_togglex" nil)
(setq KTO_toggleX  (KTO_dwgprops-get-custom-prop "KTO_togglex" nil))
(setq KTO_toggleX nil)
)
KTO_toggleX
)

;;-----[ Functie om schaal door te sturen]-----------------------------------
;
;(defun KTO_setschaal (schaalold / )
;(if (= (KTO_getmode) 2);
;
;	(progn ;normal
;		(if (not (inPspace))
;		(if(member "1:1" (_SortedScaleList (GetScaleListEntities)))
;			(progn (setvar "CANNOSCALE" "1:1"))
;			(progn (command "-scalelistedit" "a" "1:1" "1:1" "e")(setvar "CANNOSCALE" "1:1"))
;		)
;		)	
;	(setvar "useri1" schaalold)
;	(KTO_dwgprops-set-custom-prop "KTO_scale" (rtos schaalold) nil)
;	)
;	
;	(progn ;anotative mode
;		(setq schaalold (strcat "1:"(rtos schaalold 2 0)))
;		(if (not (inPspace))
;		(if(member schaalold (_SortedScaleList (GetScaleListEntities)))
;			(progn (setvar "CANNOSCALE" schaalold))
;			(progn (command "-scalelistedit" "a" schaalold schaalold "e")(setvar "CANNOSCALE" schaalold))
;		)
;		)
;	(setvar "useri1" 0)
;	(KTO_dwgprops-set-custom-prop "KTO_scale" "Annotative" nil)
;	)
;)
;)

;;-----[ Functie om schaal door te sturen]-----------------------------------
;
;(defun KTO_getschaal ( / schaal)
;(KTO_checkinstel)
;(if (or (= (KTO_getmode) 2)(= (KTO_getmodeold) 2))
;    (progn
;	(if (and (KTO_mark) (/=  (getvar "useri1") 0))
;	(progn
;	(setq schaal (getvar "useri1"))
;	)
;	(setq schaal (atof (KTO_dwgprops-get-custom-prop "KTO_scale" nil)))
;	)
;	)
;	(progn
;	(setq schaal (/ 1 (getvar "cannoscalevalue")))
;	)
;)
;schaal ;
;)


;;-----[ Functie die KTO_Statusbar instelt]----------------------

(defun KTO_Statusb ( / stat_type stat_spec stat_phase stat_line stat_togglex)
  (setvar "cmdecho" 0)
  (if (KTO_gettype)	(setq stat_type (KTO_gettype))(setq stat_type "-"))
  (if (KTO_getspec)	(setq stat_spec (KTO_getspec))(setq stat_spec "-"))
  (if (KTO_getphase)	(setq stat_phase (KTO_getphase))(setq stat_phase "-"))
  (if (KTO_getline)	(setq stat_line (KTO_getline))(setq stat_line "-"))
  (if (KTO_gettogglex)	(setq stat_togglex (KTO_gettogglex))(setq stat_togglex "-"))

  (setq staver (strcat "Ohm v"(rtos KTO_version 2 2)))
  (setvar "modemacro" (strcat staver " [" stat_type ":" stat_spec ":" stat_phase ":" stat_line ":" stat_togglex "] " ))
  (setvar "cmdecho" 1)
  (princ)
)

;;-----[ Functie om layer naar oorspronkelijk terug te plaatsen]-----------------------------------

(defun terug ( / )
    (princ)
    (command "layer" "s" c2 "")
) ;

;;-----[ Functie check basepoint]-----------------------------------

(defun  KTO_basecheck ( / curbase )
  (setq curbase (getvar "insbase" ))
;  (if (not(and(= (rtos(nth 0 curbase) 2 0) "0")(= (rtos(nth 1 curbase) 2 0) "0")(= (rtos(nth 2 curbase)2 0) "0")))
  (if (not(and(= (nth 0 curbase) 0)(= (nth 1 curbase) 0)(= (nth 2 curbase) 0)))
  (alert "Basepoint of the drawing isn't 0,0,0\nType 'base' in the command line to modify.")
  )
  (princ)
)

;;-----[ Functie check if in paperspace]-----------------------------------

(defun inPSPACE ( / )
  (and
    (zerop (getvar "TILEMODE"))
    (zerop (getvar "VPMAXIMIZEDSTATE"))
    (eq (getvar "CVPORT") 1)
  )
)

;;-----[ Functies die lijsten manipuleren voor DCL files]----------------

(defun set_tile_list (KeyName$ ListName@ Selected / Item)
  (start_list KeyName$ 3)
  (mapcar 'add_list ListName@)
  (end_list)
  (foreach Item (if (listp Selected) Selected (list Selected))
   (if (member Item ListName@)
     (set_tile KeyName$ (itoa (- (length ListName@) (length (member Item ListName@)))))
   );if
  );foreach
);defun set_tile_list

(defun check_editint (SentVar$ / Cnt# Mid$ Passed SubVar$)
  (setq SubVar$ (eval (read SentVar$)))
  (setq Cnt# 1 Passed t)
  (repeat (strlen $value)
    (setq Mid$ (substr $value Cnt# 1))
    (if (not (member Mid$ (list "0" "1" "2" "3" "4" "5" "6" "7" "8" "9")))
      (setq Passed nil)
    );if
    (setq Cnt# (1+ Cnt#))
  );repeat
  (if (not Passed)
    (progn
      (alert "Value must be an integer!")
      (set_tile $key SubVar$)
    );progn
    (if (= $value "")
      (set (read SentVar$) $value)
      (progn
        (setq $value (itoa (atoi $value)))
        (set (read SentVar$) $value)
        (set_tile $key $value)
      );progn
    );if
  );if
  (princ)
);defun check_editint

(defun set_list_value (SentList$ SentVar$ / SaveVar$ SubList@)
  (setq SubList@ (eval (read SentList$)))
  (setq SaveVar$ (eval (read SentVar$)))
  (set (read SentVar$) (nth (atoi $value) SubList@))
  (if (= (eval (read SentVar$)) "")
    (progn
      (set (read SentVar$) SaveVar$)
      (set_tile_list $key SubList@ SaveVar$)
    );progn
  );if
  (princ)
);defun set_list_value

(defun KTO_MyYesNo (Title$ Question$ / Answer$ Dcl_Id% Return#)
  (princ "\nMyYesNo")(princ)
  ; Load Dialog
  (setq Dcl_Id% (load_dialog "KTO_main.dcl"))
  (new_dialog "LabYesNo" Dcl_Id%)
  ; Set Dialog Initial Settings
  (set_tile "Title" Title$)
  (set_tile "Title2" Question$)
  ; Dialog Actions
  (action_tile "Yes" "(done_dialog 1)")
  (action_tile "No" "(done_dialog 0)")
  (setq Return# (start_dialog))
  ; Unload Dialog
  (unload_dialog Dcl_Id%)
  (if (= Return# 1)
    (setq Answer$ "Yes")
    (setq Answer$ "No")
  );if
  (princ "\n")(princ Answer$)(princ);Optional
  Answer$
);defun LabYesNo

;(vlr-remove-all)
;(setq mySavereactor nil)
;(if (null mySaveReactor)(progn
;(setq reactorCallbacks '((:vlr-commandended . myCallback)))
;(setq mySaveReactor (vlr-command-reactor 1 reactorCallbacks))
;))

;(defun myCallback (R CL)
;(cond
;  ((member(car cl) '("ZOOM" "REDRAW" "REGEN" "REGENALL" "PAN" "U" "MREDO"))
  ;do nothing
;  )
;  ((member(car cl) '("save" "qsave" "saveas"))
;   (vlr-data-set r 1)) ;setcounter to 0
;   ((= 50 (vlr-data R));put your number here
;   (if (= (KTO_MyYesNo "Do you wish to save" "You should be saving your drawing") "Yes")(command "qsave"))
;   (vlr-data-set r 1))
;   (t (vlr-data-set r (1+ (vlr-data r))))
;   ))
   

(vlr-docmanager-reactor
 nil
  '((:vlr-documentToBeActivated . KTO_Statusb_reactor))
)

(defun KTO_Statusb_reactor (mac_reactor mac_info /)
(KTO_Statusb)
(setvar "UCSICON" 1)
(setvar "dblclkedit" 1)
(princ "reactor triggered")
)

(defun DeleteFolder (path / fso path)
  (if (and (setq fso (vlax-get-or-create-object "Scripting.FileSystemObject"))
           (= -1 (vlax-invoke fso 'folderexists path)))
    (progn
      (vlax-invoke (vlax-invoke fso 'getfolder path) 'delete)
      (vlax-release-object fso)))
  (princ)
)

(defun CopyFolder (source target / fso)
  (setq FSO (vlax-create-object "Scripting.FilesystemObject"))
  (if (= -1 (vlax-invoke fso 'folderexists source))
    (vlax-invoke fso 'copyfolder source target)
  )
  (vlax-release-object fso)
)

(defun KTO_GetFileFromURL  (url path / utilObj tempPath newPath)
  ;; © RenderMan 2011, CADTutor.net
  ;; Example: (download "http://www.indiesmiles.com/wp-conten...0/12/SMILE.jpg" (getvar 'dwgprefix))
  (vl-load-com)
  (setq utilObj (vla-get-utility
                  (vla-get-activedocument (vlax-get-acad-object))))
  (if (= :vlax-true (vla-isurl utilObj url))
    (if (vl-catch-all-error-p
          (vl-catch-all-apply
            'vla-GetRemoteFile
            (list utilObj url 'tempPath :vlax-true)))
      (prompt "\n  <!>  Error Downloading File From URL  <!> ")
      (progn
        (if (findfile
              (setq newPath
                     (strcat path
                             (vl-filename-base url)
                             (vl-filename-extension url))))
          (vl-file-rename
            newPath
            (setq voidPath
                   (strcat
                     (vl-filename-directory newPath)
                     "\\void_"
                     (vl-filename-base newPath)
                     "_"
                     (menucmd
                       "M=$(edtime,$(getvar,date),YYYY-MO-DD-HH-MM-SS)")
                     (vl-filename-extension newPath)))))
        (vl-file-copy tempPath newPath)
        (vl-file-delete tempPath)))
    (prompt "\n  <!>  Invalid URL  <!> "))
  (vl-catch-all-apply 'vlax-release-object (list utilObj))
  (princ)
 )
 
 (defun KTO_getdate (/ AP CL DN CD MX MN MO YR)
    (setq 
          CD (rtos (getvar "CDATE") 2 4)
          MX (atoi (substr CD 5 2))
          MN (substr CD 12 2)
          MO (nth MX '(nil "Jan" "Feb" "Mrt" "Apr" "Mei" "Jun"
                           "Jul" "Aug" "Sep" "Okt" "Nov" "Dec"))
    )
    (setq YR (strcat (substr CD 7 2)"-" MO "-'" (substr CD 3 2)))
	YR
 )
 
 (defun DegreesToRadians (numberOfDegrees) 
   (* pi (/ numberOfDegrees 180.0))
 )
 
 (defun KTO_readblock ( / ent blk_data )
 	(setq ent  (entsel "\nSelect GMI Titleblock:"))
	(setq blk_data nil)
	(if ent
	(progn
	(setq ent (entget (car ent)))
	(while ent
	(setq ent (entget (entnext (cdr (assoc -1 ent)))))
	(if (assoc 1 ent)
	(setq blk_data (append blk_data (list (cdr (assoc 1 ent)))))
	)
	(if (not (= (cdr (assoc 0 ent)) "ATTRIB"))(setq ent nil))
	)
	)
	)
	blk_data
	(princ)
)
;;; *********************************************** *************************
;;; * Library DWGruLispLib Copyright © 2007 DWGru Programmers Group 
;;; * 
;;; * KTO_Dwgprops-get-all-prop 
;;; * 
;;; * 27/12/2007 Version 0001. Vladimir Azarko (VVA) 
;;; *********************************************** *************************

(defun KTO_dwgprops-get-all-prop (Doc / si ret nc key value) 
;;; Returns the file's properties, set the command _dwgprops 
;;; Returns an associative list, where the key is: 
;; - For properties created by the user (tab OTHER) 
;;; Property name 
;; - For standard properties (tab PAPER) 
;;; Key field 
;;; NAME - *TITLE* 
;;; AUTHOR - *AUTHOR* 
;;; TOPIC - *SUBJECT* 
;;; KEY WORDS - *KEYWORDS* 
;;; NOTES - *COMMENTS* 
;;; Hyperlink Base - *HYPERLINK* 
;;;!! Key fields are converted to uppercase 
;;; Doc - a pointer to the  document, nil - the current 
   
;;; Example 
;;; (KTO_dwgprops-get-all-prop nil) ;;;(("* AUTHOR * "" VVA ") (" * COMMENTS * "" Memo ") (" * HYPERLINK * "" Base ") 
                                ;;;("* KEYWORDS * "" Key ") (" * TITLE * "" named ") (" * SUBJECT * "" R ") (" UNIQKEY "" Key ")) 

(and
(or Doc
    (setq Doc (vla-get-activeDocument (vlax-get-acad-object)))
    )
(setq si (vla-get-SummaryInfo Doc))
(setq ret (list
	    (list "*AUTHOR*" (vla-get-author si))
	    (list "*COMMENTS*" (vla-get-comments si))
            (list "*HYPERLINK*" (vla-get-HyperlinkBase si))
	    (list "*KEYWORDS*" (vla-get-keywords si))
            (list "*TITLE*" (vla-get-Title si))
	    (list "*SUBJECT*" (vla-get-Subject si))
	    )
)
(setq nc (vla-numcustominfo si))
(while (> nc 0) 
(vla-GetCustomByIndex si (- nc 1) 'key 'value)
(setq ret (append ret (list(list (strcase key) value))))  
(setq nc (1- nc))
)
(vlax-release-object si)
)
 ret
)   
;;; *********************************************** *************************
;;; * Library DWGruLispLib Copyright © 2007 DWGru Programmers Group 
;;; * 
;;; * KTO_Dwgprops-get-custom-prop 
;;; * 
;;; * 27/12/2007 Version 0001. Vladimir Azarko (VVA) 
;;; *********************************************** *************************


(defun KTO_dwgprops-get-custom-prop (key Doc / app counter counter2 counter3 doc dwgprops kv) 
;;; Returns the value of the property created by the user (command _dwgprops) 
;;; Returns an associative list, where the key is: 
;; - For properties created by the user (tab OTHER) 
;;; Key - a string property name (tab OTHER) 
;; - For standard properties (tab PAPER) 
;;; Key field 
;;; NAME - *TITLE* 
;;; AUTHOR - *AUTHOR* 
;;; TOPIC - *SUBJECT* 
;;; KEY WORDS - *KEYWORDS* 
;;; NOTES - *COMMENTS* 
;;; Hyperlink Base - *HYPERLINK* 
;;; 
;;; Uses the library 
;;; KTO_Dwgprops-get-all-prop 
;;; KTO_Assoc (KTO_assoc-multi) 
   
;;; Doc - a pointer to the  document, nil - the current 
   
  (cadr (KTO_assoc key (KTO_dwgprops-get-all-prop Doc))) 
) 


(defun KTO_dwgprops-set-custom-prop (key value Doc / si) 
;;, Create in the properties of the figure (team _dwgprops bookmark OTHER) 
;;; Property with key and value value 
;;; If the property was not, it is created, otherwise the changes 
;;; Key - a string property name (tab OTHER) 
;;; Value - a string  - value of property 
;;; Uses the library 
;;; KTO_Dwgprops-get-custom-prop 
;;; Doc - a pointer to the document, nil - the current 
;;; Returns - nil 
;;; Example 
;;; (KTO_dwgprops-set-custom-prop "dwgru" "dwgru-dwgprops-set-custom-prop" nil) 

   (or Doc 
   (setq Doc (vla-Get-ActiveDocument (vlax-Get-Acad-Object))) 
     ) 
   (setq si (vla-Get-SummaryInfo Doc)) 
   (if (KTO_dwgprops-get-custom-prop key Doc) 
     (vla-SetCustomByKey si key value) 
     (vla-AddCustomInfo si key value) 
   ) 
) 



(defun KTO_assoc-multi (key lst) 
   (if (= (type key) 'str) 
     (setq key (strcase key)) 
     ); _ End of if 
   (vl-remove-if-not 
     (function 
       (lambda (a / b) 
         (and (setq b (car a)) 
              (or (and (= (type b) 'str) (= (strcase b) key)) (equal b key)) 
              ); _ End of and 
         ); _ End of lambda 
       ); _ End of function 
     lst 
     ); _ End of vl-remove-if-not 
   ); _ End of defun 
(defun KTO_assoc (key lst) 
   (car (KTO_assoc-multi key lst)) 
   ); _ End of defun



