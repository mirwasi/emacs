My .emacs and related files. This has a few mac specific tweaks that
you might want to turn off.

;; uses command key as control
'(ns-command-modifier (quote control)) 

;; leaves the right alt key as it is so that you can type accented
;; characters the Mac way i.e. Alt+e e to type é
'(ns-right-alternate-modifier (quote none))

Also it pressing Cmd+Space invokes spotlight and since Cmd is mapped
to Ctrl, we are unable to set a mark. I have therefore mapped
C-S-Space and M-Space to the set-mark-command:

(global-set-key (kbd "M-SPC") 'set-mark-command)
(global-set-key (kbd "C-S-SPC") 'set-mark-command)

