(defun KTO_libtrigger ()
(princ "KTO_libtrigger is loaded")
(princ)
)


;(load "Blk_Lib.lsp");(setq *Blk_Lib* t);^C^C_SBL

(defun c:switches()
(Blk_Lib "ElekBlocks" (strcat BlockLibBase$ "\\Blocks\\ElekSymb\\ElekBlocks.def") nil)
)
(defun c:sockets()
(Blk_Lib "ElekBlocks" (strcat BlockLibBase$ "\\Blocks\\ElekSymb\\ElekBlocks.def") nil)
)
(defun c:sockets()
(Blk_Lib "ElekBlocks" (strcat BlockLibBase$ "\\Blocks\\ElekSymb\\ElekBlocks.def") nil)
)
