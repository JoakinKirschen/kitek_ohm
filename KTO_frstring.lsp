;;-----[ Deze functie altijd laten staan]------------------------------------
(defun KTO_frstring ()
(princ "KTO_frstring is loaded")
(princ)
)

(defun ReplaceThis  (ToReplace ReplacedBy / SearchStr aDoc SelSet FoundString)
;;l		Replace Text pBe May 2011     	;;;
      (defun SearchStr  (lst str / a b done)
            (while (and (setq a (car lst))
                        (not done))
                  (setq b (cdr lst))
                  (if (vl-string-search a str)
                        (progn
                              (setq Done T)
                              (vl-string-subst
                                    ReplacedBy
                                    a
                                    str))
                        (setq lst b))
                  )
       )
      (setq aDoc (vla-get-activedocument (vlax-get-acad-object)))
      (ssget "_X" '((0 . "TEXT,MTEXT,INSERT")))
      (vlax-for
             obj  (setq SelSet (vla-get-activeselectionset aDoc))
            (if (wcmatch (vla-get-Objectname obj) "*Text")
                  (if (setq FoundString
                                 (SearchStr
                                       (list ToReplace)
                                       (vla-get-textstring obj)))
                        (vla-put-textstring obj FoundString))
                  (if (eq (vla-get-HasAttributes obj) :vlax-true)
                        (foreach
                               attStr
                               (vlax-invoke obj 'Getattributes)
                              (if (setq FoundString
                                             (SearchStr
                                                   (list ToReplace)
                                                   (vla-get-textstring
                                                         attStr)))
                                    (vla-put-textstring
                                          attStr
                                          FoundString))
                              )
                        )
                  )
            )
      (vla-delete SelSet)
      (princ)
      )