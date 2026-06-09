(add-to-list 'default-frame-alist '(fullscreen . maximized))
;; -*- lexical-binding: t; -*-

;; --- 1. PACKAGE SYSTEM SETUP ---
(require 'package)

;; Standard, reliable URLs with trailing slashes
(setq package-archives 
      '(("gnu"   . "https://elpa.gnu.org/packages/")
        ("melpa" . "https://melpa.org/packages/")))

;; Security & Connection Fixes
(setq package-check-signature nil)
(setq gnutls-algorithm-priority "NORMAL:-VERS-TLS1.3")

;; Note: package-initialize is automatic in 30.2, but keeping it here doesn't hurt.
(package-initialize)

;; Refresh only if necessary
(unless package-archive-contents
  (package-refresh-contents))

;; Setup use-package
(unless (package-installed-p 'use-package)
  (package-install 'use-package))
(require 'use-package)
(setq use-package-always-ensure t)

;;; winum stuff
(use-package winum
  :ensure t
  :init
  ;; This forces winum to use Alt-1, Alt-2, etc. globally
  (setq winum-keymap
        (let ((map (make-sparse-keymap)))
          (define-key map (kbd "M-1") 'winum-select-window-1)
          (define-key map (kbd "M-2") 'winum-select-window-2)
          (define-key map (kbd "M-3") 'winum-select-window-3)
          (define-key map (kbd "M-4") 'winum-select-window-4)
          map))
  :config
  (winum-mode 1))

;; --- 2. FONT & UI ---
(set-face-attribute 'default nil :font "IntoneMono Nerd Font" :height 140)
(tool-bar-mode -1)
(menu-bar-mode -1)
(scroll-bar-mode -1)
(setq inhibit-startup-screen t)

;; --- 3. EVIL MODE (NEOVIM BEHAVIOR) ---
(use-package evil
  :init
  (setq evil-want-C-u-scroll t)
  :config
;;;  (evil-mode 1)
     (evil-mode 0)
  (setq evil-normal-state-cursor  '(block "white")
        evil-insert-state-cursor  '(bar "white")
        evil-visual-state-cursor  '(hollow "white")
        evil-move-cursor-back t)
  (blink-cursor-mode -1))

;; --- 4. MANUAL CLIPBOARD SYNC (KITTY) ---
;; (setq select-enable-clipboard t)
;; (defun kitty-copy-osc52 (text)
;;  (let ((base64-text (base64-encode-string (encode-coding-string text 'utf-8) t)))
;;    (send-string-to-terminal (format "\e]52;c;%s\a" base64-text))))
;; (setq interprogram-cut-function 'kitty-copy-osc52)

;; 2. Setup Superstar BEFORE Org loads
(use-package org-superstar
  :ensure t
  :config
  ;; Fix the conflict: stop org-indent from taking over star-hiding
  (setq org-indent-mode-turns-on-hiding-stars nil) 
  (setq org-superstar-headline-bullets-list '("—" "•" "◦" "▪" "▫" "+"))
  (add-hook 'org-mode-hook (lambda () (org-superstar-mode 1))))

;; --- 5. THEME ---
  (use-package doom-themes
    :config
    (load-theme 'doom-molokai t)
    (doom-themes-org-config)) ;; This makes Org headers look better

;; --- 6. ORG MODE & ORG-APPEAR ---
(setq org-hide-emphasis-markers t)

(use-package org
  :ensure nil
  :hook (org-mode . org-indent-mode) ;; Makes text align under headers
  :config
  (setq org-startup-indented t
        org-fontify-done-headline t
        org-fontify-whole-heading-line t))

(setq org-hide-leading-stars t)

(defun my/sort-lexicon-ignore-frontmatter ()
  "Sort entries and force a visual refresh."
  (interactive)
  (save-excursion
    (goto-char (point-min))
    (if (re-search-forward "^\\* -" nil t)
        (let ((beg (line-beginning-position))
              (end (point-max)))
          (goto-char beg)
          (set-mark (point))
          (goto-char end)
          (activate-mark)
          (org-sort-entries nil ?a)
          (deactivate-mark)
          ;; This forces Emacs to redraw the "pretty" parts
          (font-lock-flush)
          (font-lock-ensure)
          (message "Lexicon sorted!"))
      (message "No entries found."))))

(with-eval-after-load 'org
  ;; 1. Link & Bracket Behavior
  (setq org-return-follows-link t)
  (setq org-link-descriptive t) ;; Hides [[square]] brackets

  ;; 2. Navigation: RET to follow links, '' or Ctrl-o to jump back
;;   (evil-define-key 'normal org-mode-map (kbd "RET") 'org-open-at-point)
;;   (evil-add-command-properties #'org-open-at-point :jump t)
;;   (evil-define-key 'normal org-mode-map (kbd "''") 'org-mark-ring-goto)
  
  ;; 3. Insert Mode: RET behaves normally
;;   (evil-define-key 'insert org-mode-map (kbd "RET") 'org-return)

  ;; 4. Sorting: Map C-c s to your lexicon sorting function
  (define-key org-mode-map (kbd "C-c s") #'my/sort-lexicon-ignore-frontmatter)
 
   ;; 5. Fold Icon: Clean ASCII Tilde
  (setq org-ellipsis " ▼") 
  (set-face-attribute 'org-ellipsis nil 
                      :foreground "light blue" 
                      :background nil 
                      :underline nil 
                      :weight 'bold)

  ;; 6. Prettify Angle Brackets (Hide << >>)
  (add-hook 'org-mode-hook (lambda ()
    (setq prettify-symbols-alist '(("<<" . "") (">>" . "")))
    (prettify-symbols-mode 1)))

  ;; 7. Ligature Helper (Ensures arrows work in Kitty)
  (let ((alist '((61 . ".\\(?:\\(?:=>\\|==\\)\\|[=>]\\)") ; =
                 (45 . ".\\(?:\\(?:->\\|--\\)\\|[->]\\)")))) ; -
    (dolist (char-alist alist)
      (set-char-table-range composition-function-table (car char-alist)
                            `([,(cdr char-alist) 0 font-shape-gstring])))))


(with-eval-after-load 'org-faces
  (set-face-attribute 'org-tag nil
                      :background "#4c566a" ;; A lighter grey/blue that stands out
                      :foreground "#eceff4" ;; Bright text
                      :weight 'bold
                      :inverse-video nil))

(use-package org-appear
  :hook (org-mode . org-appear-mode)
  :config (setq org-appear-autolinks t))

;; --- 7. LINE NUMBERS ---
(global-display-line-numbers-mode 1)
(setq display-line-numbers-type 'relative)
;; Disable line numbers in Org mode if it looks too messy:
;; (add-hook 'org-mode-hook (lambda () (display-line-numbers-mode -1)))

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(blink-cursor-mode nil)
;; '(custom-enabled-themes '(ef-autum))
;;  '(custom-safe-themes
;;    '("546f3e8c4cb46043df1f646322c4b57049fc4c31fdf96e41db077c3408660057"
;;      "833ddce3314a4e28411edf3c6efde468f6f2616fc31e17a62587d6a9255f4633"
;;      "f1e8339b04aef8f145dd4782d03499d9d716fdc0361319411ac2efc603249326"
;;      "22a0d47fe2e6159e2f15449fcb90bbf2fe1940b185ff143995cc604ead1ea171"
;;      "70c88c01b0b5fde9ecf3bb23d542acba45bb4c5ae0c1330b965def2b6ce6fac3"
;;      "dd4582661a1c6b865a33b89312c97a13a3885dc95992e2e5fc57456b4c545176"
;;      default))
 '(display-line-numbers-type 'relative)
 '(global-display-line-numbers-mode t)
 '(menu-bar-mode nil)
 '(package-selected-packages nil)
 '(tool-bar-mode nil))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:family "SauceCodePro Nerd Font" :foundry "ADBO" :slant normal :weight medium :height 143 :width normal)))))



(defvar instant-abbrev-alist
  '(("AAA" . "â")
    ("EEE" . "ê")
    ("III" . "î")
    ("OOO" . "ô")
    ("UUU" . "û")))

(defun instant-replace-triple-letter ()
  "Replace triple letters with circumflex characters instantly."
  (let* ((len 3)
         (start (- (point) len)))
    ;; Ensure we are far enough into the buffer to look back 3 chars
    (when (>= start (point-min))
      (let* ((typed-text (buffer-substring-no-properties start (point)))
             (replacement (assoc typed-text instant-abbrev-alist)))
        (when replacement
          (delete-region start (point))
          (insert (cdr replacement)))))))

(add-hook 'post-self-insert-hook #'instant-replace-triple-letter)


;; --- 10. FINAL KITTY CURSOR FIX (NO PACKAGES) ---
;; (unless (display-graphic-p)
;;   (defun my/set-cursor-shape-bar ()
;;     (send-string-to-terminal "\e[5 q")) ; 5 = bar

;;   (defun my/set-cursor-shape-block ()
;;     (send-string-to-terminal "\e[2 q")) ; 2 = block

  ;; Change to bar when entering insert mode
;;   (add-hook 'evil-insert-state-entry-hook #'my/set-cursor-shape-bar)
  
  ;; Change back to block when leaving insert mode
;;   (add-hook 'evil-insert-state-exit-hook #'my/set-cursor-shape-block)
  
  ;; Also ensure it's a block in visual/normal on startup
;;   (add-hook 'evil-visual-state-entry-hook #'my/set-cursor-shape-block)
;;   (add-hook 'evil-normal-state-entry-hook #'my/set-cursor-shape-block)

  ;; Reset cursor to block when you close Emacs
;;   (add-hook 'kill-emacs-hook #'my/set-cursor-shape-block))

;; --- 11. SPACEBAR LEADER (NO DOWNLOADS REQUIRED) ---

;; Create a "map" for our leader commands
;; (define-prefix-command 'my-leader-map)

;; Bind Space in Normal, Visual, and Motion modes to our leader map
;; (define-key evil-normal-state-map (kbd "SPC") 'my-leader-map)
;; (define-key evil-visual-state-map (kbd "SPC") 'my-leader-map)
;; (define-key evil-motion-state-map (kbd "SPC") 'my-leader-map)

;; --- THE COOL COMMANDS ---

;; File Commands
;; (define-key my-leader-map (kbd "f s") 'save-buffer)       ;; Space f s = Save
;; (define-key my-leader-map (kbd "f f") 'find-file)         ;; Space f f = Open
;; (define-key my-leader-map (kbd "f r") 'recentf-open-files) ;; Space f r = Recent
;; Buffer/Window Commands
;; (define-key my-leader-map (kbd "b b") 'switch-to-buffer)  ;; Space b b = Switch Buffer
;; (define-key my-leader-map (kbd "b k") 'kill-current-buffer) ;; Space b k = Kill Buffer
;; (define-key my-leader-map (kbd "w v") 'split-window-right) ;; Space w v = Split Vertically
;; (define-key my-leader-map (kbd "w d") 'delete-window)      ;; Space w d = Close Window
;; Org Mode Helpers
;; (define-key my-leader-map (kbd "o a") 'org-agenda)        ;; Space o a = Agenda
;; (define-key my-leader-map (kbd "o t") 'org-todo)          ;; Space o t = Todo Toggle
;; Open Dired in the current folder
;; (define-key my-leader-map (kbd "d") 'dired-jump)  ;; Space d = Dired Jump

;; --- 12. ORG MODE SOFT WRAP ---
(add-hook 'org-mode-hook 'visual-line-mode)

;; (with-eval-after-load 'evil
;;   (define-key evil-normal-state-map (kbd "j") 'evil-next-visual-line)
;;   (define-key evil-normal-state-map (kbd "k") 'evil-previous-visual-line))

;; --- 13. WIDE MARGINS & CLEAN INDENT ---
(add-hook 'org-mode-hook (lambda ()
  ;; 1. Indent text under headers
  (org-indent-mode 1)
  
  ;; 2. Set wider margins (10 columns on each side)
  (set-window-margins (selected-window) 10 10)))

;; 3. Make margins seamless with the Doom One theme
(set-face-background 'fringe (face-background 'default))

;; 4. Update the Spacebar toggle to match the new width
;; (define-key my-leader-map (kbd "m") 
;;   (lambda () (interactive) 
;;     (if (> (car (window-margins)) 0)
;;         (set-window-margins nil 0 0)
;;       (set-window-margins nil 15 15))))

;; 14. Lexicon Headers
(defun insert-lexicon-headers ()
  "Inserts the standard Martian Lexicon sub-headers."
  (interactive)
  (insert "** Definition\n")
  (insert "** Related\n")
  (insert "** Examples and Usage\n")
  (insert "** Notes\n")
  (forward-line -4)
  (end-of-line))

;; Bind it to a key (C-c w)
(global-set-key (kbd "C-c w") 'insert-lexicon-headers)

;; 15 Make Emacs see my compose key right everytime
(setq-default indent-tabs-mode nil) ;; Unrelated but good for Org
(set-selection-coding-system 'utf-8)

;; 16 wrap word in [[]] with C-c b
(defun org-wrap-word-in-brackets ()
  "Wrap the word at point in double brackets [[word]]."
  (interactive)
  (let ((bounds (bounds-of-thing-at-point 'word)))
    (when bounds
      (save-excursion
        (goto-char (cdr bounds))
        (insert "]]")
        (goto-char (car bounds))
        (insert "[[")))))

(global-set-key (kbd "C-c b") 'org-wrap-word-in-brackets)

(with-eval-after-load 'org
  ;; 1. Link & Bracket Behavior
  (setq org-return-follows-link t)
  (setq org-link-descriptive t) ;; Hides [[square]] brackets

  ;; 2. Navigation: RET to follow links, '' or Ctrl-o to jump back
;;   (evil-define-key 'normal org-mode-map (kbd "RET") 'org-open-at-point)
;;   (evil-add-command-properties #'org-open-at-point :jump t)
;;   (evil-define-key 'normal org-mode-map (kbd "''") 'org-mark-ring-goto)
  
  ;; 3. Insert Mode: RET behaves normally
;;   (evil-define-key 'insert org-mode-map (kbd "RET") 'org-return)

  ;; 4. Sorting: Map C-c s to your lexicon sorting function
  (define-key org-mode-map (kbd "C-c s") #'my/sort-lexicon-ignore-frontmatter)

  ;; 5. Prettify Angle Brackets (Hide << >>)
  (add-hook 'org-mode-hook (lambda ()
    (setq prettify-symbols-alist '(("<<" . "") (">>" . "")))
    (prettify-symbols-mode 1)))

  ;; 6. Ligature Helper (Ensures arrows work in Kitty)
  (let ((alist '((61 . ".\\(?:\\(?:=>\\|==\\)\\|[=>]\\)") ; =
                 (45 . ".\\(?:\\(?:->\\|--\\)\\|[->]\\)")))) ; -
    (dolist (char-alist alist)
      (set-char-table-range composition-function-table (car char-alist)
                            `([,(cdr char-alist) 0 font-shape-gstring])))))

;;; this little bit keeps vterm in emacs mode
(with-eval-after-load 'vterm
  (evil-set-initial-state 'vterm-mode 'emacs))

;; disable bell and flash both
(setq visible-bell t)
(vertico-mode 1)

;; Optional: Add some "quality of life" settings for Vertico
(setq vertico-cycle t)           ; Go back to the top when you reach the bottom
(setq vertico-resize nil)        ; Keep the window size consistent

(require 'marginalia)
(marginalia-mode 1)
;; Use ESC to quit Vertico/minibuffer
(define-key vertico-map (kbd "<escape>") #'abort-recursive-edit)
;; Alternatively, for a broader fix that works across all minibuffers
(define-key minibuffer-local-map (kbd "<escape>") #'abort-recursive-edit)
(define-key minibuffer-local-ns-map (kbd "<escape>") #'abort-recursive-edit)
(define-key minibuffer-local-completion-map (kbd "<escape>") #'abort-recursive-edit)
(define-key minibuffer-local-must-match-map (kbd "<escape>") #'abort-recursive-edit)
(define-key minibuffer-local-isearch-map (kbd "<escape>") #'abort-recursive-edit)

;;; doom modeline stuff
;;; probably wont need it
(use-package nerd-icons
  :ensure t)

;;; easy window movement with S-arrows
;; (windmove-default-keybindings)
;; This uses Alt + Arrows to move windows, freeing Shift for selection
;; (windmove-default-keybindings 'meta)

;; makes it so you select text, type, and the selected
;; text is replaced (deleted) by the replacement,
;; like every other editor
(delete-selection-mode 1)

;; C-= once selects word; twice sentence; etc.
;; (global-set-key (kbd "C-=") 'er/expand-region)
;; Change "C-=" to "M-=" because your terminal can't see the Control version

(require 'expand-region)
(global-set-key (kbd "M-=") 'er/expand-region)

;; crux does cool shit
(unless (package-installed-p 'crux)
  (package-refresh-contents)
  (package-install 'crux))
(require 'crux)



;; Like 'o' and 'O' in Vim: Open line above/below regardless of cursor position
(global-set-key (kbd "C-o") 'crux-smart-open-line)
(global-set-key (kbd "M-o") 'crux-smart-open-line-above)
;; Like 'dd' in Vim: Kills the whole line including the newline character
(global-set-key (kbd "M-K") 'crux-kill-whole-line)

;; Like 'yyp' in Vim: Quickly duplicate the current line or selection
(global-set-key (kbd "C-c d") 'crux-duplicate-current-line-or-region)
;; Smart Home: First press goes to first non-whitespace; second goes to column 0
(global-set-key (kbd "C-a") 'crux-move-beginning-of-line)
;; Quickly rename the file and buffer you are currently editing
(global-set-key (kbd "C-c r") 'crux-rename-buffer-and-file)
;; Delete the current file and buffer instantly
;; (global-set-key (kbd "C-c D") 'crux-delete-file-and-buffer)

;; install consult and use C-s to do it
;;  (unless (package-installed-p 'consult)
;;    (package-refresh-contents)
;;   (package-install 'consult))

;; Bind it to the standard search key or a new one
;; (global-set-key (kbd "C-s") 'consult-line)

;; make Isearch prettier
(setq search-highlight t)           ;; Highlight all matches
(setq isearch-lazy-highlight t)    ;; Highlight matches as you type

;;; begin avy
(unless (package-installed-p 'avy)
  (package-refresh-contents)
  (package-install 'avy))

(require 'avy)

;; Use M-j (Alt + j) to teleport
(global-set-key (kbd "M-j") 'avy-goto-char-timer)

;; Optional: This makes Avy look at ALL visible windows, not just the current one
(setq avy-all-windows t)
;;; end avy

;; allows something like a fuzzier search
;; 1. Install the orderless package
(unless (package-installed-p 'orderless)
  (package-refresh-contents)
  (package-install 'orderless))

;; 2. Configure Emacs to use it
(setq completion-styles '(orderless basic)
      completion-category-overrides '((file (styles basic partial-completion))))

(which-key-mode)
(setq which-key-idle-delay 0.3) ; 3/10 of a second

;; org by default disable shift select like normal graphical apps
;; turn this off if it's a problem
(setq org-support-shift-select t)
;; (setq org-support-shift-select 'always)
(setq org-support-shift-select 'everywhere)

;; You'll need to install the 'ace-window' package first
(global-set-key (kbd "M-i") 'ace-window)


(setq initial-scratch-message 
      (concat ";; Fare forward, voyager.\n"
              ";; [C-x r b] to open bookmarks.\n"
              ";; [F5] to open the Jagarôth Lexicon\n"
              ";; [F6] to open ~/.emacs\n"
              ";; [F7] to open the Jagarôth Workspace\n"
              ";; [F8] to open ~/notes/raggo.org\n\n"))


;; ;; ;; ;; s/^/;; /
(defun my-add-comment-prefix ()
  "Add ';; ' to the beginning of the current line."
  (interactive)
  (save-excursion
    (beginning-of-line)
    (insert ";; ")))

;; Example: Bind it to a key like F9
(global-set-key (kbd "<f9>") 'my-add-comment-prefix)

;; Function to open your jlex notes
(defun open-jlex-notes ()
  "Open the jlex.org file."
  (interactive)
  (find-file "~/notes/jlex.org"))

;; Function to open your Emacs config
(defun open-emacs-config ()
  "Open the .emacs file."
  (interactive)
  (find-file "~/.emacs"))

;; Function to open jworkspace.org
(defun open-jworkspace-notes ()
  "Open the jworkspace.org file."
  (interactive)
  (find-file "~/notes/jworkspace.org"))

;; Function to open raggo.org
(defun open-raggo-notes ()
  "Open the raggo.org file."
  (interactive)
  (find-file "~/notes/raggo.org"))

;; Bindings
;; I used F5 and F6 as examples, but you can change these!
(global-set-key (kbd "<f5>") 'open-jlex-notes)
(global-set-key (kbd "<f6>") 'open-emacs-config)
(global-set-key (kbd "<f7>") 'open-jworkspace-notes)
(global-set-key (kbd "<f8>") 'open-raggo-notes)


;; --- 5. THEME ---
;;   (use-package doom-themes
;;     :config
;;     (load-theme 'doom-molokai t)
;;     (doom-themes-org-config)) ;; This makes Org headers look better

;;; begin consult block
(use-package consult
  :ensure t
  :bind (;; Core navigation replacements
         ("C-s" . consult-line)                  ;; Better than swiper/isearch
         ("C-x b" . consult-buffer)              ;; Enhanced buffer/recentf/bookmark switcher
         ("C-x 4qq b" . consult-buffer-other-window) ;; orig. switch-to-buffer-other-window
         ("<f3>" . consult-buffer-other-window)
         ("M-y" . consult-yank-from-kill-ring)   ;; Visual kill-ring browser
         
         ;; Search & Jump
         ("M-g g" . consult-goto-line)           ;; Jump with preview
         ("M-g i" . consult-imenu)               ;; Jump to symbols in current buffer
         ("M-s r" . consult-ripgrep)             ;; Search project with live results
         
         ;; Registers (replaces standard register UI)
         ("C-x r b" . consult-bookmark)
         ("C-x r l" . consult-register-load)
         ("C-x r s" . consult-register-store)
         ("M-'" . consult-register-store)        ;; Quick register store
         ("M-#" . consult-register-load))        ;; Quick register load

  :init
  ;; Tweak settings before loading
  (setq register-preview-delay 0.5
        register-preview-function #'consult-register-format)

  :config
   ;; Replace the default register preview with Consult's enhanced version
   (advice-add #'register-preview :override #'consult-register-window))
;;; end consult block


;; Enable standard Shift-selection globally
(setq shift-selection-mode t)

;; Force Org-mode to respect Shift-selection instead of its own commands
(setq org-support-shift-select t)

;; Optional: If you find some Org elements still resist, 
;; this makes Shift+Arrows ALWAYS select regardless of context.
(with-eval-after-load 'org
  (define-key org-mode-map (kbd "S-<left>") #'left-char)
  (define-key org-mode-map (kbd "S-<right>") #'right-char)
  (define-key org-mode-map (kbd "S-<up>") #'previous-line)
  (define-key org-mode-map (kbd "S-<down>") #'next-line))   `

(set-face-attribute 'default nil 
                    :font "IntoneMono Nerd Font Propo" 
                    :weight 'semibold
                    :height 200)

;;(use-package ef-themes
;;  :ensure t ; Not needed in Doom Emacs
;;  :init
;;   Optional: Makes Modus commands (like modus-themes-select) 
;;   only show Ef themes
;;  (ef-themes-take-over-modus-themes-mode 1)
;;  :config
;;   Load the specific autumn theme
;; (load-theme 'ef-autumn :no-confirm))


