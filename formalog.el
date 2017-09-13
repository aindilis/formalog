(global-set-key "\C-cfla" 'formalog-all-term-assertions-of-referent)

(defvar formalog-currently-enabled-modes nil)

(defun formalog-all-term-assertions-of-referent ()
 ""
 (interactive)
 (formalog-act-on-referent (list 'all-term-assertions 'no-mt 'push-onto-ring)))

(defun formalog-act-on-referent (&optional modes-arg function-arg referent-arg mt-arg)
 ""
 (interactive "P")
 (let* ((referent (if referent-arg referent-arg (formalog-prolog-term-at-point)))
	(modes (cmh-merge-modes-lists formalog-currently-enabled-modes modes-arg))
	(function (if (kmax-mode-match 'all-instances modes)
		   "allInstances"
		   (if (kmax-mode-match 'all-term-assertions modes)
		    "allTermAssertions"
		    (completing-read "Function?: " 
		     (sort formalog-function-names 'string<)))))
	(results (cdar (mapcar #'cadr (formalog-query (list 'var-Assertions) (list function referent 'var-Assertions))))))
  (if (kmax-mode-match 'speak modes)
   (if (stringp results)
    (all-speak-text results)))
  (if (kmax-mode-match 'push-onto-ring modes)
   (freekbs2-load-onto-stack results)
   (if (kmax-mode-match 'ret modes)
    results
    (freekbs2-load-onto-stack
     (freekbs2-get-assertion-importexport t "CycL String"
      (completing-read
       (concat "Choose from "function " of " (prin1-to-string referent t) "?: ") 
       results
       )))))))

(defun formalog-prolog-term-at-point ()
 ""
 (interactive)
 (cyc-mode-get-cyc-constant-or-symbol-at-point))

;; /var/lib/myfrdcsa/codebases/minor/formalog/frdcsa/emacs/formalog-prolog-mode.el
;; /var/lib/myfrdcsa/codebases/minor/formalog/frdcsa/emacs/formalog-repl-mode.el

(add-to-list 'load-path  "/var/lib/myfrdcsa/codebases/minor/formalog/frdcsa/emacs")

(require 'formalog-prolog-mode)
(require 'formalog-repl-mode)

