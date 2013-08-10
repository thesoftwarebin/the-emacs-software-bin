(defun extract-string-from-webpage (pageurl regexp regexp-group-nr)
  "Retrieve a web page at PAGEURL and return all occurrences of REGEXP.
The regex group REGEXP-GROUP-NR may be a list of numbers if more than
one subgroup is needed."
  (let
      (
       (tempbuf    (url-retrieve-synchronously (url-generic-parse-url pageurl)))
       (resultlist nil)
       (grouplist  (if (listp regexp-group-nr) regexp-group-nr (list regexp-group-nr))))
    (with-current-buffer tempbuf
      (beginning-of-buffer)
      (while (re-search-forward regexp nil t)
	(add-to-list 
	 'resultlist 
	 (mapcar (lambda (i) (match-string i)) grouplist))))
    (kill-buffer tempbuf) 
    resultlist))

;; Usage example:
;;
;; (insert
;;  (mapconcat
;;   (lambda (row)
;;     (mapconcat
;;      'identity
;;      row
;;      "\t"))
;;   (extract-string-from-webpage
;;    "http://www.currency-iso.org/dam/downloads/table_a1.xml"
;;    "<CtryNm>\\(.*?\\)</CtryNm>\\(.\\|\n\\)*?<CcyNm>\\(.*?\\)</CcyNm>\\(.\\|\n\\)*?<Ccy>\\(.*?\\)</Ccy>"
;;    '(1 3 5))
;;   "\n"))
