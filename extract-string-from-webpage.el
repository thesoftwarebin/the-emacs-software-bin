(defun extract-string-from-webpage (pageurl regexp regexp-group-nr)
  "Retrieve a web page at PAGEURL and return all occurrences of REGEXP.
The regex group REGEXP-GROUP-NR may be a list of numbers if more than
one subgroup is needed. Usage example:

Usage example 1: retrieve a list of news headlines from
www.povray.org.

(extract-string-from-webpage
\"http://www.povray.org\"
\"<div class=\\\"spiffy_content\\\">\\\\([^<]*\\\\)</div>\"
1)

Usage example 2: retrieve a list of currencies in the form
'((country1 name1 currcode1) (country2 name2 currcode2) ...),
convert it to a tab-delimited text, insert it in the current
buffer.

(insert
 (mapconcat
  (lambda (row)
    (mapconcat
     'identity
     row
     \"\\t\"))
  (extract-string-from-webpage
   \"http://www.currency-iso.org/dam/downloads/table_a1.xml\"
   \"<CtryNm>\\\\(.*?\\\\)</CtryNm>\\\\(.\\\\|\\n\\\\)*?<CcyNm>\\\\(.*?\\\\)</CcyNm>\\\\(.\\\\|\\n\\\\)*?<Ccy>\\\\(.*?\\\\)</Ccy>\"
   '(1 3 5))
  \"\\n\"))
"
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
	 (mapcar (lambda (i) (match-string i)) grouplist)
         t)))
    (kill-buffer tempbuf) 
    resultlist))


