;; ファイルサイズを表示
(size-indication-mode t)
;;時計を２４hで表示
(setq display-time-day-and-date t)
(setq display-time-24hr-format t)
(display-time-mode t)

;; Font
;; ;; Basic font
;; (custom-set-faces
;;  '(default ((t (
;;                 :foundry "Source Code Pro" :family "Source Code Pro" :size 16)))))

;; Japanese font
(set-fontset-font t 'japanese-jisx0208 (font-spec :family "IPAExGothic"))

; ずれ確認用
; 0123456789012345678901234567890123456789
; ｱｲｳｴｵｱｲｳｴｵｱｲｳｴｵｱｲｳｴｵｱｲｳｴｵｱｲｳｴｵｱｲｳｴｵｱｲｳｴｵ
; あいうえおあいうえおあいうえおあいうえお
 
;;タイトルバーにフルパス表示
(setq frame-title-format "%&%f")
 
;;タブの表示幅=4
;; (setq-default tab-width 2)

;; タブにスペースを使用する
(setq-default tab-width 4 indent-tabs-mode nil)
 
;;テーマを読み込むための設定
(when (require `color-theme nil t)
  (color-theme-initialize))
;; 開始時のメッセージ表示しない
(setq inhibit-startup-screen t)

;; ツールバーを非表示
(tool-bar-mode -1)
 
;; 開いているバッファを更新
(defun revert-buffer-force()
  (interactive)
  (revert-buffer nil t))
(global-set-key (kbd "<f5>") 'revert-buffer-force)
 
;; ウィンドウ 2分割時に 縦分割<->横分割
(defun window-toggle-division ()
  (interactive)
  (unless (= (count-windows 1) 2)
    (error "window is not split to 2"))
  (let (before-height (other-buf (window-buffer (next-window))))
    (setq before-height (window-height))
    (delete-other-windows)
 
    (if (= (window-height) before-height)
        (split-window-vertically)
      (split-window-horizontally)
      )
 
    (switch-to-buffer-other-window other-buf)
    (other-window -1)))
;; (global-set-key "\C-c\C-w" 'window-toggle-division)
(global-set-key [S-f2] 'window-toggle-division)
 
;; 開始時のフレーム位置とサイズ
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ansi-color-faces-vector
   [default default default italic underline success warning error])
 '(custom-enabled-themes (quote (dichromacy)))
 '(initial-frame-alist
   (quote
    ((top . 200)
     (left . 45)
     (width . 95)
     (height . 45))))
 '(package-selected-packages (quote (haskell-mode flycheck auto-complete))))
 
;; 置換
(define-key global-map "\C-x\C-r" 'replace-string)

;; ;; ハイライトの色
;; (custom-set-faces
;; '(hl-line ((t (:background "color-239"))))
;; )

;; 選択範囲のハイライト
(transient-mark-mode t)

;; 対応する括弧を光らせる。
(show-paren-mode t)
 
;; ウィンドウ内に収まらないときだけ括弧内も光らせる。
(setq show-paren-style 'mixed)
 
;;（行番号、カラム番号）の表示
(require 'linum)
(global-linum-mode)

;; ##########################
;; ########### C++ ##########
;; ##########################
;; コンパイル
(add-hook
 'c++-mode-hook
 (lambda ()
   (define-key c-mode-base-map "\C-c\C-c" 'compile)
   ;; RET キーで自動改行+インデント
   (define-key c-mode-base-map "\C-m" 'newline-and-indent)
   ;; コンパイルウィンドウの大きさ
   (setq compilation-window-height 8)
   (setq c-indent-comments-syntactically-p t)
   ;; コンパイルコマンドの設定
   (unless (file-exists-p "Makefile")
     (let* ((filename (file-name-nondirectory (buffer-file-name)))
            (filename-no-suffix (substring filename 0 (string-match "\\." filename))))
       (make-local-variable 'compile-command)
       (setq compile-command
             (concat "c++ -Wall -o "
                     filename-no-suffix
                     " "
                     filename))))))

;; C++ style "stroustrup"
;; 組み込みstyleなのでインデントはspace 4で固定
(defun add-c++-mode-conf ()
  (c-set-style "stroustrup")  ;;スタイルはストラウストラップ
  (show-paren-mode t))        ;;カッコを強調表示する
(add-hook 'c++-mode-hook 'add-c++-mode-conf)

 
;; 自動補完　auto-complete
(require 'auto-complete)
(require 'auto-complete-config)
(global-auto-complete-mode t)
;;(global-set-key (kbd "\A-t") 'auto-complete)

;; ##########################
;; ########## Java ##########
;; ##########################
;;Java
(add-hook
 'java-mode-hook
 '(lambda ()
    (define-key c-mode-base-map "\C-c\C-c" 'compile)   
    ;; RET キーで自動改行+インデント
    (define-key c-mode-base-map "\C-m" 'newline-and-indent)
    ;; コンパイルウィンドウの大きさ
    (setq compilation-window-height 8)
    (setq c-indent-comments-syntactically-p t)
    ;; コンパイルコマンドの設定
    (let* ((filename (file-name-nondirectory (buffer-file-name)))
           (filename-no-suffix (substring filename 0 (string-match "\\." filename))))
      (make-local-variable 'compile-command)
      (setq compile-command
            (concat "javac " filename)))
    )
 )
;; #########################
;; ######## Haskell ########
;; #########################
(autoload 'haskell-mode "haskell-mode" nil t)
(autoload 'haskell-cabal "haskell-cabal" nil t)

(add-to-list 'auto-mode-alist '("\\.hs$" . haskell-mode))
(add-to-list 'auto-mode-alist '("\\.lhs$" . literate-haskell-mode))
(add-to-list 'auto-mode-alist '("\\.cabal$" . haskell-cabal-mode))

(autoload 'ghc-init "ghc" nil t)
(autoload 'ghc-debug "ghc" nil t)

(add-hook 'after-init-hook #'global-flycheck-mode)

;; 自動コンパイル
(add-hook
 'haskell-mode-hook
 '(lambda ()
    (define-key c-mode-base-map "\C-c\C-c" 'compile)   
    ;; RET キーで自動改行+インデント
    (define-key c-mode-base-map "\C-m" 'newline-and-indent)
    ;; コンパイルウィンドウの大きさ
    (setq compilation-window-height 8)
    ;; コンパイルコマンドの設定
    (let* ((filename (file-name-nondirectory (buffer-file-name)))
           (filename-no-suffix (substring filename 0 (string-match "\\." filename))))
      (make-local-variable 'compile-command)
      (setq compile-command
            (concat "ghc " filename)))
    )
 )

;; ######################
;; ######## Rust ########
;; ######################
;; fly-check, rustmode.
(add-hook 'after-init-hook #'global-flycheck-mode)
(add-hook 'rust-mode-hook 'cargo-minor-mode)


(add-hook
 'rust-mode-hook
 '(lambda ()
    (define-key c-mode-base-map "\C-c\C-c" 'compile)   
    ;; RET キーで自動改行+インデント
    (define-key c-mode-base-map "\C-m" 'newline-and-indent)
    ;; コンパイルウィンドウの大きさ
    (setq compilation-window-height 8)
    (setq c-indent-comments-syntactically-p t)
    ;; コンパイルコマンドの設定
    (let* ((filename (file-name-nondirectory (buffer-file-name)))
           (filename-no-suffix (substring filename 0 (string-match "\\." filename))))
      (make-local-variable 'compile-command)
      (setq compile-command
            (concat "rustc " filename)))
    )
 )
                                        ;
;;Rust
;; ;;; racerやrustfmt、コンパイラにパスを通す
;; (add-to-list 'exec-path (expand-file-name "~/.cargo/bin/"))
;; ;;; rust-modeでrust-format-on-saveをtにすると自動でrustfmtが走る
;; (eval-after-load "rust-mode"
;;   '(setq-default rust-format-on-save t))
;; ;;; rustのファイルを編集するときにracerとflycheckを起動する
;; (add-hook 'rust-mode-hook (lambda ()
;;                             (racer-mode)
;;                             (flycheck-rust-setup)))
;; ;;; racerのeldocサポートを使う
;; (add-hook 'racer-mode-hook #'eldoc-mode)
;; ;;; racerの補完サポートを使う
;; (add-hook 'racer-mode-hook (lambda ()
;;                              (company-mode)
;;                              ;;; この辺の設定はお好みで
;;                              (set (make-variable-buffer-local 'company-idle-delay) 0.1)
;;                              (set (make-variable-buffer-local 'company-minimum-prefix-length) 0)))
 
;;画面分割した際の各画面のサイズ変更
(defun window-resizer ()
  "Control window size and position."
  (interactive)
  (let ((window-obj (selected-window))
        (current-width (window-width))
        (current-height (window-height))
        (dx (if (= (nth 0 (window-edges)) 0) 10
              -10))
        (dy (if (= (nth 1 (window-edges)) 0) 10
              -10))
        c)
    (catch 'end-flag
      (while t
        (message "size[%dx%d]"
                 (window-width) (window-height))
        (setq c (read-event))
        (cond ((string= c "right")					;右
               (enlarge-window-horizontally dx))
              ((string= c "left")					;左
               (shrink-window-horizontally dx))
              ((string= c "down")					;下
               (enlarge-window dy))
              ((string= c "up")                     ;上
               (shrink-window dy))
              ((string= c "return")	 
               (message "Quit")
               (throw 'end-flag t))   
              ;; otherwise
              (t
               (message "Quit")
               (throw 'end-flag t)))))))
(global-set-key (kbd "<f1>") 'window-resizer)
 
;;スクリプトに自動的に実行権限を付ける
(add-hook 'after-save-hook 'executable-make-buffer-file-executable-if-script-p)
 
;;It's all text!
(if (locate-library "server")
    (progn
      (load-library "server")
      (server-start)
      ))
 
(setq inhibit-startup-message t)


;; ##########################
;; ########## Latex #########
;; ##########################
;; AUC-TeX
(load "auctex.el" nil t t)
(setq auto-mode-alist
      (cons '("\\.tex" . japanese-latex-mode)
            auto-mode-alist))
(require 'font-latex)
(setq japanese-LaTeX-command-default "pLaTeX")
 
;; xvdi
;; (setq TeX-view-program-selection
;;   '((output-dvi "xdvi")))
;; (setq TeX-view-program-list
;;   '(("xdvi" "xdvi -unique %o")))
 
 
(add-hook 'LaTeX-mode-hook
  (lambda ()
    (setq TeX-view-program-selection
      '((output-dvi "xdvi")))
    (setq TeX-view-program-list
      '(("xdvi" "xdvi -unique %o")))
    ))
 
(defun view-pdf ()
  (interactive)
  (call-process "dvipdfmx" nil nil nil
                (concat (file-name-sans-extension buffer-file-name) ".dvi")
                )
  (call-process "evince" nil 0 nil
                (concat (file-name-sans-extension buffer-file-name) ".pdf"))
  )
 
(add-hook
 'LaTeX-mode-hook
 (lambda ()
   ;; 'latex-indent-setup
   (local-unset-key (kbd "C-M-i"))
   ;; (local-set-key "\C-c\C-v" 'make-pdf-by-dvipdf)
   (local-set-key "\C-c\C-v" 'view-pdf)
   ;; (local-set-key "\C-cv" 'view-pdf-by-evince)
   ))




;; for window system
(if window-system
    (progn
      (set-frame-parameter nil 'alpha 94)))
 
(when (>= emacs-major-version 25)
  (require 'package)
  (add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/") t)
  (package-initialize)
  )

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )


;; バックアップファイルを作らない
(setq make-backup-files nil)


;; emacs-lispをflycheckの対象から外す.
(setq-default flycheck-disabled-checkers '(emacs-lisp-checkdoc)) 
