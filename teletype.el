;;    Demo of a teletype-like printing function for Emacs.
;;    To see the demo, load-file this file and execute
;;    command `teletype-run-demo'.
;;
;;    Copyright (C) 2013  Andrea Rossetti aka "The Software Bin"
;;                          http://github.com/thesoftwarebin
;; 
;;    This program is free software: you can redistribute it and/or modify
;;    it under the terms of the GNU General Public License as published by
;;    the Free Software Foundation, either version 3 of the License, or
;;    (at your option) any later version.
;; 
;;    This program is distributed in the hope that it will be useful,
;;    but WITHOUT ANY WARRANTY; without even the implied warranty of
;;    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;;    GNU General Public License for more details.
;; 
;;    You should have received a copy of the GNU General Public License
;;    along with this program.  If not, see <http://www.gnu.org/licenses/>.

(defun teletype-char (c short-pause long-pause)
  (let ((med-pause (/ (+ long-pause (* 2 short-pause)) 3.0)))
    (cond
     ((equal c ?.)
      (insert (char-to-string c))
      (sit-for long-pause))
     ((equal c ?,)
      (insert (char-to-string c))
      (sit-for med-pause))
     ((equal c ?\n)
      (sit-for med-pause) (insert (char-to-string c))
      (sit-for med-pause))
     (t
      (insert (char-to-string c))
      (sit-for short-pause)))))
 
(defun teletype-text (str short-pause long-pause)
  (mapcar
   (lambda (strchar)
     (teletype-char strchar short-pause long-pause))
   (string-to-list str)))
 
(defun teletype-in-new-buffer (pause-between-keys pause-between-rows buffer-title text)
  "Create a new buffer, print text in it one character at a time,
with a pause between each character."
  (switch-to-buffer (get-buffer-create buffer-title))
  (erase-buffer)
  (teletype-text text pause-between-keys pause-between-rows))
 
(defun teletype-run-demo ()
  "Demonstrate teletyping by using the `teletype-in-new-buffer' function."
  (interactive)
  (teletype-in-new-buffer
   0.1
   0.5
   "Emacs teletype demo"
   (concat
    "Hello Emacs user,\n\n"
    " teletype-like printing can be useful to\n"
    "keep the user focused on a brief tutorial.\n\n"
    " You are currently reading at 10 cps, with\n"
    "pauses of 0.5 sec at punctuation and newlines.\n"
    " If this demo annoys you, stop it with C-g.\n\n"
    " To run your own demo, you may load teletype.el and\n"
    "execute the following LISP function:\n\n"
    " (teletype-in-new-buffer 0.1 0.5 demo-title all-your-text)\n\n"
    "Future improvements could be:\n\n"
    " - read text from file\n"
    " - a resumable \"pause\" key\n"
    " - support for text coloring\n"
    " - support for typewriter sound (tick-tick-tick)\n"
    " - configurable regexps for pauses (so for example you\n"
    " don't have to ... wait so long at the ellipsys\n"
    " triple dots)\n\n"
    " Hope you enjoyed, regards.\n\n"
    " The Software Bin\n"
    " http://github.com/thesoftwarebin\n")))
