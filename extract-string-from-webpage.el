(defun tsb/extract-string-from-webpage (pageurl regexp regexp-group-nr)
  "Retrieve HTTP page at address `pageurl', 
   search for first occurrence of `regexp',
   return its group `regexp-group-nr' as
   a string."
  (let 
      (
       (b (url-retrieve-synchronously (url-generic-parse-url pageurl)))
       (previous-buffer (current-buffer))
       (s))
    (progn
      (set-buffer b)
      (beginning-of-buffer)
      (re-search-forward regexp)
      (setq s (match-string regexp-group-nr))
      (set-buffer previous-buffer)
      (kill-buffer b)
      s)))

#||
Usage example:

(tsb/extract-string-from-webpage
 "http://www.ts.ismar.cnr.it/node/14" 
 "Raffica massima</td>.*\n.*<b>\\([0-9\\.]*\\)"
 1)
||#
