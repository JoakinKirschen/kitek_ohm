(defun c:KTO_wblockm ( / path cmdecho lst itm nam pass ctr )
(setq cmdecho (getvar "CMDECHO"))
(setvar "CMDECHO" 0)
;
(if (not KTO_InsertAll)(load "KTO_InsertAllBlocksInFolder.lsp"))
(setq path (LM:DirectoryDialog (strcat "Select Directory of" " files to Insert") (vl-filename-directory (findfile "KTO_Lib.lsp")) 512))
;(setq path (dos_getdir "Target Folder" (getvar "DWGPREFIX")))
;)
(if (/= path nil)
(progn
(if (= (substr path (strlen path) 1) "\\")
(setq path (substr path 1 (1- (strlen path))))
)
(princ "\nDS> Building List of Blocks ... ")
(setq lst nil)
(setq itm (tblnext "BLOCK" T))
(while (/= itm nil)
(setq nam (cdr (assoc 2 itm)))
(setq pass T)
(if (/= (cdr (assoc 1 itm)) nil)
(setq pass nil)
(progn
(setq ctr 1)
(repeat (strlen nam)
(setq chk (substr nam ctr 1))
(if (or (= chk "*")(= chk "|"))
(setq pass nil)
)
(setq ctr (1+ ctr))
)
)
)
(if (= pass T)
(setq lst (cons nam lst))
)
(setq itm (tblnext "BLOCK"))
)
(setq lst (acad_strlsort lst))
(princ "Done.")
;
(foreach blk lst
(setq fn (strcat path (chr 92) blk))
(if (findfile (strcat fn ".dwg"))
(command "_.-WBLOCK" fn "_Y" blk)
(command "_.-WBLOCK" fn blk)
)
)
)
)
;
(setvar "CMDECHO" cmdecho)
(princ)
)

(defun c:delattblockm nil
  (vl-load-com)
;;; Tharwat 04. May . 2012 ;;;
  (vlax-for x (vla-get-blocks
                (vla-get-activedocument (vlax-get-acad-object))
              )
    (if (and (eq :vlax-false (vla-get-isXref x))
             (eq :vlax-false (vla-get-islayout x))
        )
      (vlax-for ent x
        (if (eq (vla-get-objectname ent) "AcDbAttributeDefinition")
          (vla-delete ent)
        )
      )
    )
  )
  (princ)
)