(global-set-key "\C-c\C-k\C-vfo" 'formalog-repl-start)
(global-set-key "\C-cffTt" 'formalog-complete)

(defvar formalog-repl-buffer-name "*Formalog-REPL*")

(defun formalog-repl-start (&optional switch-to)
 ""
 (interactive)
 (if switch-to
  (if (get-buffer formalog-repl-buffer-name)
   (switch-to-buffer formalog-repl-buffer-name)
   (formalog-repl-start))
  (progn
   (if (get-buffer formalog-repl-buffer-name)
    (kill-buffer formalog-repl-buffer-name))
   (run-in-shell
    "cd /var/lib/myfrdcsa/codebases/minor/formalog/scripts && ./start-repl"
    formalog-repl-buffer-name
    nil
    'formalog-repl-mode)
   (sit-for 1.0)))
 (switch-to-buffer formalog-repl-buffer-name)
 (end-of-buffer))

(define-derived-mode formalog-repl-mode
 shell-mode "Formalog REPL"
 "Major mode for Formalog Interaction.
\\{shell-mode-map}"
 (setq case-fold-search nil)
 (define-key formalog-repl-mode-map (kbd "TAB") 'formalog-complete)

 (define-key freekbs2-ring-editor-mode-map "q" 'quit-window)
 (suppress-keymap freekbs2-ring-editor-mode-map)
 )

(defun formalog-query (vars query &optional verbose)
 ""
 (interactive)
 (if verbose
  (message (prin1-to-string (list vars query))))
 (push "_prolog_list" vars)
 (let* (
	(tmp
	 (freekbs2-get-result
	  (uea-query-agent-raw nil "Agent1"
	   (freekbs2-util-data-dumper
	    (list
	     (cons "_DoNotLog" 1)
	     (cons "Eval" (list (list "_prolog_list" vars query) nil)))))))
	(results (progn (pop tmp) tmp)))
  results))

(defun formalog-complete (arg &optional predicate)
 "Perform completion on Formalog symbol preceding point.
Compare that symbol against the known Formalog symbols.

When called from a program, optional arg PREDICATE is a predicate
determining which symbols are considered, e.g. `commandp'.
If PREDICATE is nil, the context determines which symbols are
considered.  If the symbol starts just after an open-parenthesis, only
symbols with function definitions are considered.  Otherwise, all
this-command-keyssymbols with function definitions, values or properties are
considered."
 (interactive "P")
 (let* ((end (point))
	(pattern
	 (cmh-decyclify
          (cyc-mode-get-cyc-constant-or-symbol-at-point)))
	(beg (- (point) (length pattern)))
	)
  (if (and
       (non-nil pattern)
       (non-nil (string-match "\\([^\\s]\\)" pattern))
       (not (equal (line-beginning-position) (point)))
       )
   (let*
    ((completions (si-list-to-alist (formalog-complete-prolog pattern)))
     (completion (try-completion pattern completions)))
    (cond
     ((eq completion t))
     ((null completion)
      (error "Can't find completion for \"%s\"" pattern)
      (ding))
     ((not (string= pattern (cmh-decyclify completion)))
      (delete-region beg end)
      (string-match "^\\(.+?\\)$" completion)
      (insert (match-string 1 completion)))
     (t
      (let* 
       ((expansion (completing-read "Constant: " 
		    (all-completions pattern completions)
		    nil nil completion))
	(regex (concat pattern "\\(.+\\)")))
       (string-match regex expansion)
       (let ((match (match-string 1 expansion)))
	(string-match "^\\(.+?\\)$" match)
	(insert (match-string 1 match)))))))
   (error "Nothing to complete."))))

(defun formalog-complete-prolog (pattern)
 ""
 (interactive)
 (mapcar #'cadr (formalog-query (list 'var-Y) (list "constant_complete" pattern 'var-Y))))

(defun formalog-complete-or-tab (&optional arg)
 (interactive "P")
 (let* ((flp-line-prefix (save-excursion
			  (set-mark (point))
			  (beginning-of-line nil)
			  (buffer-substring-no-properties (point) (mark)))))
  (if (string-match "^[\s\t]*$" flp-line-prefix)
   (progn
    ;; (see "yes") 
    (indent-for-tab-command arg))
   (progn
    ;; (see "no")
    (unwind-protect
     (condition-case ex
      (formalog-complete nil flp-line-prefix)
      ('error (indent-for-tab-command arg))))))))

(provide 'formalog-repl-mode)
