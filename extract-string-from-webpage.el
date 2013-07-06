(defun extract-string-from-webpage (pageurl regexp regexp-group-nr)
  "Retrieve HTTP page at address `pageurl', search for first occurrence
of `regexp', return the regex group `regexp-group-nr' as a string.
For a more detailed description of regex and regex group, see
`re-search-forward' and `match-string'.

Usage example:

(concat
 \"Exchange rate for EUR to JPY: \"
 (extract-string-from-webpage
  \"http://it.finance.yahoo.com/echarts?s=EURJPY%3DX\" ; pageurl
  \"<span id=\\\"yfs_l10_eurjpy=x\\\">\\\\([0-9]+,[0-9]+\\\\)\" ; regexp
  1 ; regex-group-nr
  ))
"
  (let
      (
       (tempbuf (url-retrieve-synchronously (url-generic-parse-url pageurl)))
       the-matched-string)
    (with-current-buffer
	tempbuf
      (beginning-of-buffer)
      (re-search-forward regexp)
      (setq the-matched-string (match-string regexp-group-nr)))
    (kill-buffer tempbuf)
    the-matched-string))

