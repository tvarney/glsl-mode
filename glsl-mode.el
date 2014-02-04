
(provide 'glsl-mode)

(eval-when-compile
  (require 'cc-mode))

(defconst glsl-version "1.0"
  "GLSL major mode version number.")

(defvar glsl-mode-hook nil)

(defvar glsl-mode-map
  (let ((glsl-mode-map (make-sparse-keymap)))
    glsl-mode-map)
  "Keymap for GLSL major mode")

(add-to-list 'auto-mode-alist '("\\.vert$" . glsl-mode))
(add-to-list 'auto-mode-alist '("\\.frag$" . glsl-mode))
(add-to-list 'auto-mode-alist '("\\.geom$" . glsl-mode))

(defconst glsl-font-lock-keywords-1
  (list
   ;; Preprocessor
   '("#[[:alpha:]][[:alnum:]]*" . font-lock-preprocessor-face)
   ;; Keywords
   '("\\<\\(attribute\\|b\\(?:reak\\|uffer\\)\\|c\\(?:entroid\\|o\\(?:herent\\|n\\(?:st\\|tinue\\)\\)\\)\\|d\\(?:iscard\\|o\\)\\|else\\|f\\(?:lat\\|or\\)\\|i\\(?:n\\(?:\\(?:ou\\|varian\\)t\\)\\|[fn]\\)\\|layout\\|noperspective\\|out\\|precision\\|re\\(?:adonly\\|strict\\|turn\\)\\|s\\(?:ample\\|hared\\|mooth\\|truct\\)\\|uniform\\|v\\(?:arying\\|olatile\\)\\|w\\(?:hile\\|riteonly\\)\\)\\>" . font-lock-keyword-face)
   ;; Types
   '("\\<\\(atomic_uint\\|b\\(?:ool\\|vec[234]\\)\\|d\\(?:mat\\(?:2x[234]\\|3x[234]\\|4x[234]\\|[234]\\)\\|ouble\\|vec[234]\\)\\|float\\|i\\(?:image\\(?:1D\\(?:Array\\)?\\|2D\\(?:Array\\|MS\\(?:Array\\)?\\|Rect\\)?\\|3D\\|Buffer\\|Cube\\(?:Array\\)?\\)\\|mage\\(?:1D\\(?:Array\\)?\\|2D\\(?:Array\\|MS\\(?:Array\\)?\\|Rect\\)?\\|3D\\|Buffer\\|Cube\\(?:Array\\)?\\)\\|nt\\|sampler\\(?:1D\\(?:Array\\)?\\|2D\\(?:Array\\|MS\\(?:Array\\)?\\|Rect\\)?\\|3D\\|Buffer\\|Cube\\(?:Array\\)?\\)\\|vec[234]\\)\\|mat\\(?:2x[234]\\|3x[234]\\|4x[234]\\|[234]\\)\\|sampler\\(?:1D\\(?:Array\\(?:Shadow\\)?\\|Shadow\\)?\\|2D\\(?:Array\\(?:Shadow\\)?\\|MS\\(?:Array\\)?\\|Rect\\(?:Shadow\\)?\\|Shadow\\)?\\|3D\\|Buffer\\|Cube\\(?:Array\\(?:Shadow\\)?\\|Shadow\\)?\\)\\|u\\(?:i\\(?:mage\\(?:1D\\(?:Array\\)?\\|2D\\(?:Array\\|MS\\(?:Array\\)?\\|Rect\\)?\\|3D\\|Buffer\\|Cube\\(?:Array\\)?\\)\\|nt\\)\\|sampler\\(?:1D\\(?:Array\\)?\\|2D\\(?:Array\\|MS\\(?:Array\\)?\\|Rect\\)?\\|3D\\|Buffer\\|Cube\\(?:Array\\)?\\)\\|vec[234]\\)\\|v\\(?:ec[234]\\|oid\\)\\)\\>" . font-lock-type-face)
   ;; Attributes
   '("\\<\\(binding\\|co\\(?:lumn_major\\|mponent\\)\\|highp\\|lo\\(?:cation\\|wp\\)\\|mediump\\|offset\\|packed\\|row_major\\|std\\(?:\\(?:14\\|43\\)0\\)\\)\\>" . font-lock-variable-name-face))
  "Minimal highlighting expressions for GLSL mode")

(defconst glsl-font-lock-keywords-2
  (append glsl-font-lock-keywords-1
          (list
           ;; True/false constants
           '("\\<\\(true\\|false\\)\\>" . font-lock-constant-face)
           ;; Integer/Float constants
           '("\\<[+-]?[0-9]+\\(\.[0-9]+\\)?\\([eE][0-9]+\\)?\\>" . font-lock-constant-face)))
  "Maximum highlighting expressions for GLSL mode")

(defvar glsl-font-lock-keywords glsl-font-lock-keywords-2
  "Default highlighting expressions for GLSL mode")

(defvar glsl-mode-syntax-table
  (let ((glsl-mode-syntax-table (make-syntax-table)))
    glsl-mode-syntax-table)
  "Syntax table for GLSL mode")

(define-derived-mode glsl-mode c-mode "GLSL"
  "Major mode for editing OpenGL shader files"
  (set (make-local-variable 'font-lock-defaults) '(glsl-font-lock-keywords)))
