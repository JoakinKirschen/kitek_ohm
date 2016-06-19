;;-----[ Lab2012 UPDATE SYSTEM]----------------
(defun updatefunction (LabPathDest List1 / Temp PMPPath UserPath PlotPath PlotStyles DirNew DirLengthNew Printers)
  (vl-load-com)

  ;Modus
  (setq Printers (nth 1 List1))
  
  ;Default paden
  (setq *olderr* *error* *error* my-error)
  (setq Temp (getenv "Temp"))
  (setq UserPath (getenv "Appdata"))
  (setq PlotPath (strcat(getenv "PrinterConfigDir")"\\"))
  (setq PMPPath (strcat(getenv "PrinterDescDir")"\\"))
  (setq PlotStyles (strcat(getenv "PrinterStyleSheetDir")"\\"))
  
  (princ "\nExitting autocad")
  (setq scriptfile (findfile "L12_update.vbs")) 
  (startapp (strcat "CSCRIPT.EXE //nologo " (vl-prin1-to-string scriptfile)
;   " " (vl-prin1-to-string LabPathSource)
   " " (vl-prin1-to-string LabPathDest)
   " " (vl-prin1-to-string Temp)
   " " (vl-prin1-to-string UserPath)
   " " (vl-prin1-to-string PlotPath)
   " " (vl-prin1-to-string PMPPath)
   " " (vl-prin1-to-string PlotStyles)
   " " (vl-prin1-to-string Printers)
   " " (vl-prin1-to-string "https://github.com/JoakinKirschen/lab2012/archive/master.zip")
   ))
)
   