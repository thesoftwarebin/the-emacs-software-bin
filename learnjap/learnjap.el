;;; learnjap.el --- show reading and meaning of Japanese symbols at cursor point

;; Copyright: Andrea Rossetti, 2013
;;            http://thesoftwarebin.github.com
;;
;; This program is free software: you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.
;;  
;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.
;;  
;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <http://www.gnu.org/licenses/>.

;;; Commentary:

;;; Code:

(defvar learnjap/kanjitable (make-hash-table :test 'equal))

(load-file "learnjap-kanji-table.el")

(defun learnjap/get-properties (code)
  (gethash code learnjap/kanjitable))

(defun learnjap/get-properties-as-string (code)
  (let ((i (learnjap/get-properties code)))
    (if
        (null i)
        (format "%c\nNo information available for this character." code)
      (format
       "%s\nOn reading: %s\nKun reading: %s\nDefinition: %s\nStrokes: %s"
       (plist-get i :utf8)
       (mapconcat 'identity (plist-get i :onreadings) ", ")
       (mapconcat 'identity (plist-get i :kunreadings) ", ")
       (plist-get i :definition)
       (plist-get i :strokecount)))))

(defvar learnjap/info-buffer-name "*learnjap-info*")

(defun learnjap/show-learnjap-info (bufpoint)
  "Shows kanji information for the kanji at the
current cursor point. Information is shown in a
buffer named \"*learnjap-info*\" (if it does not
exist, it's created and shown at the bottom).

To call the function simply use:

M-x learnjap/show-learnjap-info RET

After some test usage you will probably prefer
to set a shortcut key with `local-set-key',
for example on mouse click:

(local-set-key
  (kbd \"<mouse-1>\")
  'learnjap/show-learnjap-info)

- TODO: add pronounce of hiragana and katakana
- TODO: make it a minor mode
"
  (interactive "d")
  (let
      (
       (charnum        (string-to-char (buffer-substring-no-properties bufpoint (1+ bufpoint))))
       (big-jap-char-height (* (face-attribute 'default :height) 6)))

    (when
        (null (get-buffer learnjap/info-buffer-name))
      (split-window-below 10)
      (other-window 1)
      (generate-new-buffer learnjap/info-buffer-name)
      (set-window-buffer nil learnjap/info-buffer-name)
      (other-window -1))

    (with-current-buffer (get-buffer learnjap/info-buffer-name)
      (erase-buffer)
      (insert (learnjap/get-properties-as-string charnum))
      (add-text-properties 1 2  (list 'face (list :height big-jap-char-height))))))

(provide 'learnjap)

;;; learnjap.el ends here
