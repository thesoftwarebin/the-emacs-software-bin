;;; string-list-composer.el --- sum and product of string lists

;;; Commentary:
;; the functions `slc/s+' and `slc/s*' allow to build string lists,
;; similarly to the Bash brace expansion facilities.

;;; Code:

(defgroup slc nil "String-list-composer options" :group 'wp)

(defun slc/assign-aliases (symbol value)
  (set-default symbol value)
  (defalias (plist-get slc-aliases 'slc/s+)    'slc/s+)
  (defalias (plist-get slc-aliases 'slc/s*)    'slc/s*)
  (defalias (plist-get slc-aliases 'slc/s^)    'slc/s^)
  (defalias (plist-get slc-aliases 'slc/s...)  'slc/s...)
  (defalias (plist-get slc-aliases 'slc/scase) 'slc/scase))

(defcustom slc-aliases '(slc/s+ s+ slc/s* s* slc/s^ s^ slc/s... s... slc/scase scase)
  "Plist of function aliases for the string-list-composer functions.  
User can change if the default aliases s+, s* ... aren't comfortable
enough. Each alias has the form (INITIAL-FUNCTION-NAME PREFERRED-ALIAS-NAME)."
  :type '(plist 
	  :key-type   (symbol :tag "Function to be aliased")
	  :value-type (symbol :tag "Alias name"))
  :group 'slc
  :set 'slc/assign-aliases)

(defun slc/s+ (&rest e)
  "String sum: merge arguments E into a single list.  See also `slc/s*'."
  (apply 
   'append 
   (mapcar 
    (lambda (i) (if (stringp i) (list i) (apply 'slc/s+ i))) 
    e)))

(defun slc/s*_sl (sc ls)
  "String product between a string SC and a list of strings LS."
  (mapcar (lambda (i) (concat sc i)) ls))

(defun slc/s*_ll (ls1 ls2)
  "String product between two lists of strings LS1 and LS2."
  (let (
	(listls1 (if (listp ls1) ls1 (list ls1)))
	(listls2 (if (listp ls2) ls2 (list ls2))))
    (slc/s+
     (mapcar (lambda (i) (slc/s*_sl i listls2)) listls1))))

(defun slc/s* (a b &rest r)
  "String product between A, B and the rest of arguments R.
A and B can be a string or a list of strings.  See also `slc/s+'."
  (let ((ab (slc/s*_ll a b)))
    (if (null r) ab (apply 'slc/s* (cons ab r)))))

(defun slc/s^ (b e)
  "Repeat string product B * B * B for E times."
  (cond
   ((<= e 0) "")
   (t (slc/s* b (slc/s^ b (- e 1))))))

(defun slc/scase (str)
  "Decompose STR in (`slc/s+' strchar1 strchar2 ... strcharN)."
  (apply 'slc/s+ (mapcar 'char-to-string (string-to-list str))))

(defun slc/s... (c1 c2)
  "Build a char pattern (`slc/s+' C1 ... C2).
Works both for ascendent and descendent patterns."
  (let ((i1 (string-to-char c1))
	(i2 (string-to-char c2)))
    (cond
     ((= i1 i2) (list (char-to-string i1)))
     (t (slc/s+ (char-to-string i1) (slc/s... (char-to-string (if (< i1 i2) (+ i1 1) (- i1 1))) c2))))))

(defun slc/insert (alist)
  "Insert in current buffer the list of strings ALIST.
Generated strings are inserted row by row. See `slc/s+'
and `slcs/*'."
  (interactive "XBuild expression (s+, s*, s^, s..., scase): ")
  (insert
   (mapconcat
    'identity
    alist
    "\n")))

(provide 'string-list-composer)

;;; string-list-composer.el ends here

