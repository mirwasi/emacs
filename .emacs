;; ** remove annoyances **

(setq inhibit-startup-message t)  ;; no spalsh scree
(setq ring-bell-function 'ignore) ;; silence is golden

;; welcome to the 21st century
(setq locale-coding-system 'utf-8)
(set-terminal-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)
(set-selection-coding-system 'utf-8)
(prefer-coding-system 'utf-8)

;; should be defaults but aren't
(column-number-mode)
(setq blink-matching-paren t)

(ido-mode)                       ;; much nicer way to open files/switch buffers
                                 ;; more: http://www.emacswiki.org/emacs/InteractivelyDoThings

(setq mac-option-modifier 'meta) ;; use mac alt key as meta

;; titlebar format
(setq-default
 frame-title-format
 (list '((buffer-file-name " %f" (dired-directory
								  dired-directory
								  (revert-buffer-function " %b"
														  ("%b - Dir:  " default-directory)))))))

;; make emacs treat .<spc> !<spc> and ?<spc> as sentence endings
(setq sentence-end "[.!?][]'\")}]*\\(\\$\\| \\$\\|    \\| \\)[ ]*")

;; recent files
(setq recentf-save-file "~/.emacs.d/recentf") ;; keep my ~/ clean
(require 'recentf)
(recentf-mode 1)
(setq recentf-max-menu-items 100)
(global-set-key [?\C-c ?r ?f] 'recentf-open-files)

;; save minibuffer history
(setq savehist-additional-variables        ;; also save...
	  '(search-ring regexp-search-ring)    ;; ... my search entries
	  savehist-file "~/.emacs.d/savehist") ;; keep my home clean
(savehist-mode t)                          ;; do customization before activate

;; remember cursor position in files
(setq save-place-file "~/.emacs.d/saveplace") ;; keep my ~/ clean
(setq-default save-place t)                   ;; activate it for all buffers
(require 'saveplace)                          ;; get the package

;; sensible default for naming duplicate buffers
(require 'uniquify) 
(setq 
  uniquify-buffer-name-style 'post-forward ;; file's folder suffixed
  uniquify-separator ":")                  ;; after a colon

;; ispell on mac
(if (file-exists-p "/opt/local/bin/ispell")
          (setq ispell-program-name "/opt/local/bin/ispell"))


;; ** load paths **

;; where is all the external stuff going to be loaded from
(add-to-list 'load-path
			 "~/Dropbox/Emacs")
(add-to-list 'load-path
			 "~/Dropbox/Emacs/color-theme/")
(add-to-list 'load-path
             "~/Dropbox/Emacs/color-theme/themes/color-theme-solarized/")
(add-to-list 'load-path
	     "~/Dropbox/Emacs/magit-1.0.0")


;; ** programming tweaks **

;; show function names on modeline
(which-func-mode 1)

;; use 4 space wide tabs
(setq-default indent-tabs-mode nil)
(setq standard-indent 4)
(setq tab-width 4)

;; turn autoindenting on
(global-set-key "\r" 'newline-and-indent)

;; show matching parens on steroids
(defadvice show-paren-function
  (after show-matching-paren-offscreen activate)
  "If the matching paren is offscreen, show the matching line in the
        echo area. Has no effect if the character before point is not of
        the syntax class ')'."
  (interactive)
  (if (not (minibuffer-prompt))
      (let ((matching-text nil))
        ;; Only call `blink-matching-open' if the character before point
        ;; is a close parentheses type character. Otherwise, there's not
        ;; really any point, and `blink-matching-open' would just echo
        ;; "Mismatched parentheses", which gets really annoying.
        (if (char-equal (char-syntax (char-before (point))) ?\))
            (setq matching-text (blink-matching-open)))
        (if (not (null matching-text))
            (message matching-text)))))

;; jump to matching paren
(global-set-key "§" 'match-paren)
(defun match-paren (arg)
  "Go to the matching  if on (){}[], similar to vi style of % "
  (interactive "p")
  ;; first, check for "outside of bracket" positions expected by forward-sexp, etc.
  (cond ((looking-at "[\[\(\{]") (forward-sexp))
        ((looking-back "[\]\)\}]" 1) (backward-sexp))
        ;; now, try to succeed from inside of a bracket
        ((looking-at "[\]\)\}]") (forward-char) (backward-sexp))
        ((looking-back "[\[\(\{]" 1) (backward-char) (forward-sexp))
        (t (self-insert-command (or arg 1)))))



;; ** specialized modes **

;; template toolkit
(autoload 'tt-mode "tt-mode")
(setq auto-mode-alist
	  (append '(("\\.tt$" . tt-mode))  auto-mode-alist ))
(setq auto-mode-alist
	  (append '(("\\.tt2$" . tt-mode))  auto-mode-alist ))

;; cperl mode tweaks
(defun djcb-cperl-mode-hook ()
  (interactive)
  (outline-minor-mode)
  (eval-when-compile (require 'cperl-mode))
  (setq 
   cperl-hairy nil                
   cperl-indent-level 4
   cperl-close-paren-offset -4
   cperl-continued-statement-offset 4   
   cperl-invalid-face (quote off)
   cperl-electric-keywords nil
   cperl-indent-parens-as-block t
   cperl-electric-parens nil))

;; give us a dedicated imenu index on menubar
(add-hook 'cperl-mode-hook 'imenu-add-menubar-index)

;; cperl-mode is preferred to perl-mode
(defalias 'perl-mode 'cperl-mode)
(add-hook 'cperl-mode-hook 'djcb-cperl-mode-hook)
(add-hook 'cperl-mode-hook
  (lambda()
    (setq mode-name "PL"))) ;; save space on modeline

;; magit
(require 'magit)

;; org-mode
(setq auto-mode-alist
      (append '(("\\.org$" . org-mode)) auto-mode-alist))
(setq org-directory "~/Dropbox/org")
(setq org-tag-alist '(("annoyance" . ?a)))
;(add-hook 'org-mode-hook '(lambda () (setq outline-regexp "★")))

;; zen coding
(require 'zencoding-mode)
(add-hook 'sgml-mode-hook 'zencoding-mode) ;; auto-start on any markup modes


;; ** misc tweaks **

(require 'anything)
(load-file "~/Dropbox/Emacs/anything-config.el")
(global-set-key [?\C-=] 'anything-imenu)           ;; access imenu quickly
(global-set-key [?\C-c ?r ?a] 'anything-for-files) ;; access recentf quickly

;; make mode names on modeline smaller
(when (require 'diminish nil 'noerror)
  (eval-after-load "Icy"
      '(diminish 'icicle-mode "I"))
  (eval-after-load "Flymake"
    '(diminish 'flymake-mode "F")))

;; mark rectangular regions
(require 'rect-mark)
;; keybindings for rect-mark
(global-set-key (kbd "C-x r C-S-SPC") 'rm-set-mark)
(global-set-key (kbd "C-w")  
  '(lambda(b e) (interactive "r") 
     (if rm-mark-active 
       (rm-kill-region b e) (kill-region b e))))
(global-set-key (kbd "M-w")  
  '(lambda(b e) (interactive "r") 
     (if rm-mark-active 
       (rm-kill-ring-save b e) (kill-ring-save b e))))
(global-set-key (kbd "C-x C-x")  
  '(lambda(&optional p) (interactive "p") 
     (if rm-mark-active 
       (rm-exchange-point-and-mark p) (exchange-point-and-mark p))))

;; required by edit with emacs chrome extension
(require 'edit-server)
(setq edit-server-new-frame 't)
(edit-server-start)


;; ** more keybindings **

;; outline-minor-mode key map
(define-prefix-command 'cm-map nil "Outline-")
;; hide
(define-key cm-map "q" 'hide-sublevels)    ;; hide everything but the top-level headings
(define-key cm-map "t" 'hide-body)         ;; hide everything but headings (all body lines)
(define-key cm-map "o" 'hide-other)        ;; hide other branches
(define-key cm-map "c" 'hide-entry)        ;; hide this entry's body
(define-key cm-map "l" 'hide-leaves)       ;; hide body lines in this entry and sub-entries
(define-key cm-map "d" 'hide-subtree)      ;; hide everything in this entry and sub-entries
;; show
(define-key cm-map "a" 'show-all)          ;; show (expand) everything
(define-key cm-map "e" 'show-entry)        ;; show this heading's body
(define-key cm-map "i" 'show-children)     ;; show this heading's immediate child sub-headings
(define-key cm-map "k" 'show-branches)     ;; show all sub-headings under this heading
(define-key cm-map "s" 'show-subtree)      ;; show (expand) everything in this heading & below
;; move
(define-key cm-map "u" 'outline-up-heading)                ;; up
(define-key cm-map "n" 'outline-next-visible-heading)      ;; next
(define-key cm-map "p" 'outline-previous-visible-heading)  ;; previous
(define-key cm-map "f" 'outline-forward-same-level)        ;; forward - same level
(define-key cm-map "b" 'outline-backward-same-level)       ;; backward - same level
(global-set-key "\M-o" cm-map)

;; make it easy to insert bullets and stars
(defun insert-bullet ()
  "Insert bullet at point"
  (interactive)
  (ucs-insert "2022"))

(defun insert-star ()
  "Insert star at point"
  (interactive)
  (ucs-insert "2605"))

(global-set-key (kbd "M-8") 'insert-bullet) ;; M-8 => •
(global-set-key (kbd "M-9") 'insert-star)   ;; M-9 => ★

;; Command-SPC on mac invokes spotlight so define alternatives
(global-set-key (kbd "M-SPC") 'set-mark-command)
(global-set-key (kbd "C-S-SPC") 'set-mark-command)

;;customizations saved by emacs
(custom-set-variables
  ;; custom-set-variables was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 '(auto-save-default nil)
 '(c-default-style "bsd")
 '(default-major-mode (quote fundamental-mode) t)
 '(default-tab-width 4 t)
 '(make-backup-files nil)
 '(ns-command-modifier (quote control))
 '(ns-right-alternate-modifier (quote none))
 '(nxhtml-skip-welcome t)
 '(paren-match-face (quote paren-face-match-light))
 '(paren-sexp-mode t)
 '(safe-local-variable-values (quote ((todo-categories "Todo"))))
 '(show-paren-mode t)
 '(tab-stop-list (quote (4 8 12 16 20 24 28 32 36 40)))
 '(tool-bar-mode nil))

(custom-set-faces
  ;; custom-set-faces was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 '(font-lock-comment-face ((((class color) (min-colors 88) (background light)) (:foreground "DarkGreen"))))
 '(font-lock-string-face ((((class color) (min-colors 88) (background light)) (:foreground "RoyalBlue"))))
 '(which-func ((((class color) (min-colors 88) (background dark)) (:foreground "OliveDrab3")))))



;; ** colours **

;; colour themes
(require 'color-theme)
(color-theme-initialize)
(require 'color-theme-solarized)
(require 'color-theme-zenburn)


;; *** PerlySense Config ***

;; ** PerlySense **
;; The PerlySense prefix key (unset only if needed, like for \C-o)
(global-unset-key "\C-o")
(setq ps/key-prefix "\C-o")


;; ** Flymake **
;; Load flymake if t
;; Flymake must be installed.
;; It is included in Emacs 22
;;     (or http://flymake.sourceforge.net/, put flymake.el in your load-path)
(setq ps/load-flymake t)
;; Note: more flymake config below, after loading PerlySense


;; *** PerlySense load (don't touch) ***
(setq ps/external-dir (shell-command-to-string "perly_sense external_dir"))
(if (string-match "Devel.PerlySense.external" ps/external-dir)
    (progn
      (message
       "PerlySense elisp files  at (%s) according to perly_sense, loading..."
       ps/external-dir)
      (setq load-path (cons
                       (expand-file-name
                        (format "%s/%s" ps/external-dir "emacs")
                        ) load-path))
      (load "perly-sense")
      )
  (message "Could not identify PerlySense install dir.
    Is Devel::PerlySense installed properly?
    Does 'perly_sense external_dir' give you a proper directory? (%s)" ps/external-dir)
  )


;; ** Flymake Config **
;; If you only want syntax check whenever you save, not continously
(setq flymake-no-changes-timeout 9999)
(setq flymake-start-syntax-check-on-newline nil)

;; ** Code Coverage Visualization **
;; If you have a Devel::CoverX::Covered database handy and want to
;; display the sub coverage in the source, set this to t
(setq ps/enable-test-coverage-visualization nil)

;; ** Color Config **
;; Emacs named colors: http://www.geocities.com/kensanata/colors.html
;; The following colors work fine with a white X11
;; background. They may not look that great on a console with the
;; default color scheme.
;;(set-face-background 'flymake-errline "antique white")
;;(set-face-background 'flymake-warnline "lavender")
;;(set-face-background 'dropdown-list-face "lightgrey")
;;(set-face-background 'dropdown-list-selection-face "grey")


;; ** Misc Config **

;; Run calls to perly_sense as a prepared shell command. Experimental
;; optimization, please try it out.
(setq ps/use-prepare-shell-command t)

;; *** PerlySense End ***
