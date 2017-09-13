(global-set-key "\C-cffTf" 'formalog-prolog-formalog-prolog-or-prolog-mode)
(global-set-key "\C-cfpr" 'formalog-prolog-find-or-start-formalog-repl)

(defvar formalog-prolog-buffer-name "*Formalog-Prolog*")
(defvar formalog-use-formalog-movement nil)
;; (ffap "/usr/share/emacs24/site-lisp/prolog-el/prolog.el")

(defun formalog-prolog-font-lock-keywords ()
 ""
 formalog-prolog-font-lock-keywords-var)

(defun formalog-prolog ()
 ""
 (interactive)
 (if (not (derived-mode-p 'formalog-prolog-mode))
  (progn 
   (prolog-mode)
   (let* ((keywords (prolog-font-lock-keywords)))
    (setq formalog-prolog-font-lock-keywords-var keywords)
    (formalog-prolog-mode)))))

(define-derived-mode formalog-prolog-mode
 prolog-mode "Formalog-Prolog"
 "Major mode for Formalog Prolog Files.
\\{prolog-mode-map}"
 (setq case-fold-search nil)

 (define-key formalog-prolog-mode-map (kbd "TAB") 'formalog-complete-or-tab)
 (define-key formalog-prolog-mode-map [C-tab] 'flp-complete-or-tab)

 (define-key formalog-prolog-mode-map "\C-cdtc" 'formalog-prolog-term-completed)
 (define-key formalog-prolog-mode-map "\C-cdtd" 'formalog-prolog-term-depends-on-new-task)
 (define-key formalog-prolog-mode-map "\C-cdtD" 'formalog-prolog-term-is-depended-on-by-new-task)
 (define-key formalog-prolog-mode-map "\C-cdte" 'formalog-prolog-term-deleted)
 (define-key formalog-prolog-mode-map "\C-cdth" 'formalog-prolog-term-habitual)
 (define-key formalog-prolog-mode-map "\C-cdts" 'formalog-prolog-term-solution)
 (define-key formalog-prolog-mode-map "\C-cdtS" 'formalog-prolog-term-sequester-to)
 (define-key formalog-prolog-mode-map "\C-cdtp" 'formalog-prolog-term-in-progress)
 (define-key formalog-prolog-mode-map "\C-cdtP" 'formalog-prolog-term-postponed)
 (define-key formalog-prolog-mode-map "\C-cdtk" 'formalog-prolog-term-skipped)
 (define-key formalog-prolog-mode-map "\C-cdto" 'formalog-prolog-term-obsoleted)
 (define-key formalog-prolog-mode-map "\C-cdtn" 'formalog-prolog-term-noted-elsewhere)
 (define-key formalog-prolog-mode-map "\C-cdtN" 'formalog-prolog-term-note-elsewhere)
 (define-key formalog-prolog-mode-map "\C-cdtw" 'formalog-prolog-term-when)
 (define-key formalog-prolog-mode-map "\C-cdta" 'formalog-prolog-term-assign-to-project)
 
 (define-key formalog-prolog-mode-map (kbd "C-M-f") 'forward-formalog-term)
 (define-key formalog-prolog-mode-map (kbd "C-M-b") 'beginning-formalog-term)

 ;; (define-key formalog-prolog-mode-map (kbd "C-M-f") 'forward-formalog-term-special)
 ;; (define-key formalog-prolog-mode-map (kbd "C-M-b") 'beginning-formalog-term-special)

 (setq font-lock-defaults
  '(formalog-prolog-font-lock-keywords nil nil ((?_ . "w"))))

 (re-font-lock)
 )

(defun formalog-prolog-term-completed ()
 ""
 (interactive)
 (formalog-prolog-assert-about-term "completed"))

(defun formalog-prolog-term-depends-on-new-task ()
 ""
 (interactive)
 (formalog-prolog-assert-about-term "completed"))

(defun formalog-prolog-term-is-depended-on-by-new-task ()
 ""
 (interactive)
 (save-excursion
  (let*
   ((dependency (read-from-minibuffer "Is depended on: ")))
   (formalog-prolog-assert-about-term "depends" dependency)
   )))

(defun formalog-prolog-term-deleted ()
 ""
 (interactive)
 (formalog-prolog-assert-about-term "deleted"))

(defun formalog-prolog-term-habitual ()
 ""
 (interactive)
 (formalog-prolog-assert-about-term "habitual"))

(defun formalog-prolog-term-solution ()
 ""
 (interactive)
 (save-excursion
  (let*
   ((solution (read-from-minibuffer "Solution: ")))
   (formalog-prolog-assert-about-term "solution" nil solution))))

(defun formalog-prolog-term-sequester-to ()
 ""
 (interactive)
 (save-excursion
  (let*
   ((location (read-from-minibuffer "Where should this be sequestered to: ")))
   (formalog-prolog-assert-about-term "sequester to" nil location))
   ;; (do-todo-list-add-to-solved)
   ))

(defun formalog-prolog-term-in-progress ()
 ""
 (interactive)
 (formalog-prolog-assert-about-term "in progress"))

(defun formalog-prolog-term-postponed ()
 ""
 (interactive)
 (formalog-prolog-assert-about-term "postponed"))

(defun formalog-prolog-term-skipped ()
 ""
 (interactive)
 (formalog-prolog-assert-about-term "skipped"))

(defun formalog-prolog-term-obsoleted ()
 ""
 (interactive)
 (formalog-prolog-assert-about-term "obsoleted"))

(defun formalog-prolog-term-noted-elsewhere ()
 ""
 (interactive)
 (formalog-prolog-assert-about-term "noted elsewhere"))

(defun formalog-prolog-term-note-elsewhere ()
 ""
 (interactive)
 (save-excursion
  (let*
   ((solution (read-from-minibuffer "Where should this be noted: ")))
   (formalog-prolog-assert-about-term "note elsewhere" nil solution))
   ;; (do-todo-list-add-to-solved)
   ))

(defun formalog-prolog-term-when ()
 ""
 (interactive)
 (save-excursion
  (let*
   ((clause (read-from-minibuffer "When: ")))
   (formalog-prolog-assert-about-term "when" clause))
   ))

(defun formalog-prolog-term-assign-to-project ()
 ""
 (save-excursion
  (let*
   ((project-dir (radar-select-directory (append radar-radar-dirs radar-radar-work-dirs))))
   (formalog-prolog-assert-about-term "assigned project" nil project-dir))
   ;; (do-todo-list-add-to-solved)
   ))

(defun formalog-prolog-assert-about-term (predicate &optional previous additional)
 "While editing a todo file, use this to mark the solution for a particular task."
 ;; have the option of moving it to the end
 ;; also use the elisp pretty printer (when the git repos are synced)
 (interactive)
 (if (formalog-prolog-term-at-point-p)
  (save-excursion
   (formalog-prolog-re-search-forward "[^[:blank:]\n]" nil t) 
   (backward-char)
   (let*
    ((term (formalog-prolog-kill-term-at-point))
     (modified-term
      (concat
       predicate "("
       (if previous (concat previous ","))
       term
       (if additional (concat "," additional))
       ")")))
    (insert modified-term))))
 (formalog-prolog-pretty-print-term-at-point)
 )

(defun formalog-prolog-term-at-point-p ()
 ""
 (interactive)
 (save-excursion
  (formalog-prolog-re-search-forward "[^[:blank:]\n]" nil t)
  (backward-char)
  (not (not (thing-at-point 'formalog-term)))))

;; thing-at-point

(defun term-at-point ()
 "Return the sexp at point, or nil if none is found."
 (form-at-point 'term))

(defun formalog-prolog-re-search-forward (regex &optional bound noerror count)
 (let ((case case-fold-search))
  (setq case-fold-search nil)
  (re-search-forward regex (or bound nil) (or noerror nil) (or count nil))
  (setq case-fold-search case)))

(defun formalog-prolog-kill-term-at-point ()
 ""
 (interactive)
 (save-excursion
  (set-mark (point))
  (forward-char (length (thing-at-point 'formalog-term)))
  (kill-region (point) (mark))
  (kmax-top-of-kill-ring)))

(defun formalog-prolog-pretty-print-term-at-point ()
 ""
 (interactive)
 ;; (kmax-not-yet-implemented)
 )

(defun forward-formalog-term () 
 ""
 (interactive)
 (if formalog-use-formalog-movement 
  (prolog-forward-list)
  (forward-sexp)))

(defun beginning-formalog-term ()
 ""
 (interactive)
 (if formalog-use-formalog-movement 
  (progn
   (prolog-backward-list)
   (backward-sexp))
  (backward-sexp)))

(defun end-formalog-term ()
 ""
 (interactive)
 (if formalog-use-formalog-movement 
  (prolog-forward-list)
  (forward-sexp)))

(put 'formalog-term 'forward-op 'forward-formalog-term)
(put 'formalog-term 'beginning-op 'beginning-formalog-term)
(put 'formalog-term 'end-op 'end-formalog-term)

(defun forward-formalog-term-special () 
 ""
 (interactive)
 (forward-formalog-term)
 (condition-case nil
  (progn
   (forward-formalog-term)
   (beginning-formalog-term))
  (error nil)))

(defun beginning-formalog-term-special ()
 ""
 (interactive)
 (beginning-formalog-term)
 (condition-case nil
  (progn
   (beginning-formalog-term)
   (forward-formalog-term-special))
  (error nil)))

(defun formalog-prolog-formalog-prolog-or-prolog-mode ()
 "Determine if the current file is a perl or prolog file, and load the appropriate mode"
 (interactive)
 (if (eq major-mode 'formalog-prolog-mode)
  (prolog-mode)
  (if (eq major-mode 'prolog-mode)
   (formalog-prolog-mode)
   (error nil))))

(defun formalog-prolog-act-on-referent-and-push-onto-ring ()
 ""
 (interactive)
 ;; see cmh-act-on-referent-and-push-onto-ring
 (formalog-prolog-act-on-referent (list 'push-onto-ring)))

;; (defun formalog-prolog-act-on-referent (&optional modes-arg function-arg referent-arg mt-arg)
;;  ""
;;  ;; see cmh-act-on-referent
;;  (interactive)
;;  (let* ((referent (if referent-arg referent-arg (formalog-prolog-referent)))
;; 	(modes (cmh-merge-modes-lists cmh-currently-enabled-modes modes-arg))

;; 	(function (if function-arg function-arg 
;; 		   (if (kmax-mode-match 'all-instances modes)
;; 		    "all-instances"
;; 		    (if (kmax-mode-match 'all-term-assertions modes)
;; 		     "all-term-assertions"
;; 		     (completing-read "Function?: " 
;; 		      (sort cyc-subl-function-names 'string<))))))
;; 	(results (sort 
;; 		  (mapcar (lambda (item) (prin1-to-string item t)) 
;; 		   (car
;; 		    (cmh-send-subl-command
;; 		     (see (concat
;; 			   "(" function " " referent
;; 			   (if (not (kmax-mode-match 'no-mt modes))
;; 			    (concat " " (if mt-arg mt-arg cmhc-microtheory)))
;; 			   ")") 0.2))))
;; 		  'string<)))
;;   (if (kmax-mode-match 'speak modes)
;;    (if (stringp results)
;;     (all-speak-text results)))
;;   (if (kmax-mode-match 'push-onto-ring modes)
;;    (freekbs2-load-onto-stack results)
;;    (if (kmax-mode-match 'ret modes)
;;     results
;;     (freekbs2-load-onto-stack
;;      (freekbs2-get-assertion-importexport t "CycL String"
;;       (completing-read
;;        (concat "Choose from "function " of " (prin1-to-string referent t) "?: ") 
;;        results
;;        )))))))

(defun formalog-prolog-find-or-start-formalog-repl ()
 ""
 (interactive)
 (formalog-repl-start t))

(defun formalog-prolog-find-source-of-predicate (&optional predicate-arg arity-arg)
 (interactive)
 (let* ((predicate (or predicate-arg (read-from-minibuffer "Predicate: ")))
	(definition-information
	 (cdadar
	  (formalog-query
	   (list 'var-DefinitionInformation)
	   (list "findDefinitionInformation"
	    (list "/" predicate arity-arg)
	    'var-DefinitionInformation)))))
  definition-information))

(defun formalog-prolog-find-predicate ()
 ""
 (interactive "P")
 (let* ((tap (thing-at-point 'formalog-term))
	(term (if (non-nil tap)
	       (substring-no-properties tap)
	       (prin1-to-string (symbol-at-point))))
	(predicate (if (string-match "^\\(.+?\\)(" term)
		    (match-string 1 term)
		    (if (kmax-non-empty-string term)
		     term
		     nil)))
	(possible-arities (formalog-prolog-predicate-has-arities predicate))
  	(definition-information
	 (if (non-nil predicate)
	  (formalog-prolog-find-source-of-predicate
	   predicate
	   (if (= (length possible-arities) 1)
	    (car possible-arities)
	    (completing-read "Arity: " possible-arities)))
	  nil)))
  (if (non-nil definition-information)
   (progn
    (ffap (nth 0 definition-information))
    (goto-line (string-to-number (nth 1 definition-information)))))))

(defun formalog-prolog-predicate-has-arities (predicate)
 ""
 (interactive)
 (cdadar 
  (formalog-query (list 'var-Arities) (list "arities" predicate 'var-Arities))))

(provide 'formalog-prolog-mode)
