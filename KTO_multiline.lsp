;;------------------------=={ Multi-Polyline  }==-----------------------;;
;;                                                                      ;;
;;  This program enables the user to create objects with the appearance ;;
;;  of multilines, however, which are composed of standard polylines.   ;;
;;                                                                      ;;
;;  The program will invoke the standard AutoCAD MLINE command,         ;;
;;  allowing the user to construct the object with the real-time        ;;
;;  dynamic preview afforded by the MLINE command, with the resulting   ;;
;;  multiline automatically exploded & joined to form standard 2D       ;;
;;  polylines.                                                          ;;
;;----------------------------------------------------------------------;;
;;  Author:  Lee Mac, Copyright © 2010  -  www.lee-mac.com              ;;
;;----------------------------------------------------------------------;;
;;  Version 1.0    -    2010-06-19                                      ;;
;;                                                                      ;;
;;  First release.                                                      ;;
;;----------------------------------------------------------------------;;
;;  Version 1.1    -    2015-09-12                                      ;;
;;                                                                      ;;
;;  Program rewritten.                                                  ;;
;;----------------------------------------------------------------------;;
(defun KTO_multilineinput (linetype$ / name$ linetype$ amount#)
(if (KTO_getline)
(setq name$ (strcat (KTO_getline) linetype$ ))
(progn (KTO_setprop "KTO_LINE" "V1") (setq name$ (strcat (KTO_getline) linetype$ )))
)

(setq amount# (atoi (substr (KTO_getline) 2 1)))

(KTO_multiline name$ "0" linetype$ 0 amount# "1" "bottom" 10)


)

(defun KTO_multiline (name$ layer$ linetype$ color# amount# scale# just$  gap# / *error* ent sel val var )
    (defun *error* ( msg )
        (mapcar 'setvar var val)
        (LM:endundo (LM:acdoc))
        (if (and msg (not (wcmatch (strcase msg t) "*break,*cancel*,*exit*")))
            (princ (strcat "\nError: " msg))
        )
        (princ)
    )
	(setq templayer (getvar "clayer"))
    (setvar "clayer" layer$)
    (LM:loadlinetypes '("BORDER" "BORDER2" "CENTER" "CENTER2" "DASHED" "DASHDOT" "DASHDOT2" "DIVIDE" "DIVIDE2" "HIDDEN" "HIDDEN2" "PHANTOM" "PHANTOM2") nil)
    (KTO_makemline name$ layer$ linetype$ color# amount# gap#)
    (LM:startundo (LM:acdoc))
    (setq ent (entlast))
    (vl-cmdf "_.mline" "St" name$ "S" scale# "J" just$ )
    (while (= 1 (logand 1 (getvar 'cmdactive)))
        (vl-cmdf "\\")
    )
    (if (not (eq ent (setq ent (entlast))))
        (progn
            (setq var '(cmdecho peditaccept qaflags)
                  val  (mapcar 'getvar var)
                  sel  (ssadd)
            )
            (mapcar 'setvar var '(0 1 0))
            (vl-cmdf "_.explode" ent)
            (while (setq ent (entnext ent)) (ssadd ent sel))
            (vl-cmdf "_.pedit" "_m" sel "" "_j" "" "")
        )
    )
    (*error* nil)
	(setvar "clayer" templayer)
    (princ)
)

;; Start Undo  -  Lee Mac
;; Opens an Undo Group.
 
(defun LM:startundo ( doc )
    (LM:endundo doc)
    (vla-startundomark doc)
)
 
;; End Undo  -  Lee Mac
;; Closes an Undo Group.
 
(defun LM:endundo ( doc )
    (while (= 8 (logand 8 (getvar 'undoctl)))
        (vla-endundomark doc)
    )
)
 
;; Active Document  -  Lee Mac
;; Returns the VLA Active Document Object
 
(defun LM:acdoc nil
    (eval (list 'defun 'LM:acdoc 'nil (vla-get-activedocument (vlax-get-acad-object))))
    (LM:acdoc)
)

;(KTO_loadlinetypes)

(defun KTO_multiline2 (name$ layer$ amount# scale# just$  gap# /)
  ;(KTO_loadlinetypes)
  (KTO_makemline name$ layer$ amount# gap#)
  (command "_mline" "St" name$ "S" scale# "J" just$ )
  (while (> (getvar "cmdactive") 0)(command pause))
  ;(command pause)
  ;)
  (princ "ddededededededd")
  ;(command "")
  (KTO_ml2pl)
  (princ)
)

(defun KTO_makemline (name$ layer$ linetype$ color# amount# gap# / MLINE_STYLE_NAME x#)
;;;(setvar "CLAYER" "ANNO-ARCH-WALL")  

;(while (< x# amount)
;    (cons 49  (* gap# x#))
;    '(62 . 256)
;    '(6 . "BYLAYER")
;    (setq x# (+ x# 1))
;)
(setq MLINE_STYLE_NAME name$
	  x# 0.0)
(setq templ1
	(list '(0 . "MLINESTYLE")
	'(100 . "AcDbMlineStyle")
	(cons 2 MLINE_STYLE_NAME)
	'(70 . 0)
	'(3 . "")
	'(62 . 256)
	'(51 . 1.5708)
	'(52 . 1.5708)
	(cons 71 amount#)
	)
)
;(while (< x# amount#)
;    (setq templ1(append templ1 (list(cons 49  (* gap# x#)))))
;    (setq templ1(append templ1 (list '(62 . 256))))
;    (setq templ1(append templ1 (list '(6 . "BYLAYER"))))
;    (setq x# (+ x# 1))
;)
(while (< x# amount#)
    (setq templ1(append templ1 (list(cons 49  (* gap# x#)))))
    (setq templ1(append templ1 (list(cons 62 color#))))
    (setq templ1(append templ1 (list(cons 6 linetype$))))
    (setq x# (+ x# 1))
)
(if
  (not
    (dictadd
(cdar (dictsearch (namedobjdict) "ACAD_MLINESTYLE"))
MLINE_STYLE_NAME
(entmakex
templ1
)))  
  ;(alert "Impossible to create mline style\n perhaps this was exist earlier"))
  (princ))
  )

