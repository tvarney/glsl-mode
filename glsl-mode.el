
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
           '("^[a-zA-Z_][a-zA-Z_0-9]*[[:space:]\n]+\\([a-zA-Z_][a-zA-Z_0-9]*\\)(" 1 font-lock-preprocessor-face)
           ;; True/false constants
           '("\\<\\(true\\|false\\)\\>" . font-lock-constant-face)
           ;; Integer/Float constants
           '("\\<[+-]?[0-9]+\\(\.[0-9]+\\)?\\([eE][0-9]+\\)?\\>" . font-lock-constant-face)))
  "Medium highlighting expressions for GLSL mode")

(defconst glsl-font-lock-keywords-3
  (append glsl-font-lock-keywords-2
          (list
           ;; Builtin gl_* variables
           '("\\<\\(gl_\\(?:ClipDistance\\|DepthRange\\|Fr\\(?:ag\\(?:Coord\\|Depth\\)\\|ontFacing\\)\\|GlobalInvocationID\\|In\\(?:\\(?:stance\\|vocation\\)ID\\)\\|L\\(?:ayer\\|ocalInvocationI\\(?:D\\|ndex\\)\\)\\|M\\(?:ax\\(?:AtomicCounterB\\(?:indings\\|ufferSize\\)\\|C\\(?:lipDistances\\|om\\(?:bined\\(?:\\(?:AtomicCounter\\(?:Buffer\\)?\\|ImageUni\\(?:form\\|tsAndFragmentOutput\\)\\|TextureImageUnit\\)s\\)\\|pute\\(?:AtomicCounter\\(?:\\(?:Buffer\\)?s\\)\\|ImageUniforms\\|TextureImageUnits\\|UniformComponents\\|WorkGroup\\(?:Count\\|Size\\)\\)\\)\\)\\|DrawBuffers\\|Fragment\\(?:\\(?:AtomicCounter\\(?:Buffer\\)?\\|I\\(?:mageUniform\\|nputComponent\\)\\|Uniform\\(?:Component\\|Vector\\)\\)s\\)\\|Geometry\\(?:\\(?:AtomicCounter\\(?:Buffer\\)?\\|I\\(?:mageUniform\\|nputComponent\\)\\|Output\\(?:Component\\|Vertice\\)\\|\\(?:T\\(?:extureImageUni\\|otalOutputComponen\\)\\|\\(?:Uniform\\|Varying\\)Componen\\)t\\)s\\)\\|Image\\(?:\\(?:Sample\\|Unit\\)s\\)\\|P\\(?:atchVertices\\|rogramTexelOffset\\)\\|T\\(?:e\\(?:ss\\(?:Control\\(?:\\(?:AtomicCounter\\(?:Buffer\\)?\\|I\\(?:mageUniform\\|nputComponent\\)\\|\\(?:OutputComponen\\|T\\(?:extureImageUni\\|otalOutputComponen\\)\\|UniformComponen\\)t\\)s\\)\\|Evaluation\\(?:\\(?:AtomicCounter\\(?:Buffer\\)?\\|I\\(?:mageUniform\\|nputComponent\\)\\|\\(?:OutputComponen\\|TextureImageUni\\|UniformComponen\\)t\\)s\\)\\|GenLevel\\|Patch\\(?:\\(?:Component\\|Vertice\\)s\\)\\)\\|xtureImageUnits\\)\\|ransformFeedback\\(?:\\(?:Buffer\\|InterleavedComponent\\)s\\)\\)\\|V\\(?:\\(?:aryingVector\\|ertex\\(?:At\\(?:omicCounter\\(?:Buffer\\)?\\|trib\\)\\|ImageUniform\\|OutputComponent\\|TextureImageUnit\\|Uniform\\(?:Component\\|Vector\\)\\)\\|iewport\\)s\\)\\)\\|inProgramTexelOffset\\)\\|NumWorkGroups\\|P\\(?:atchVerticesIn\\|erVertex\\|o\\(?:int\\(?:Coord\\|Size\\)\\|sition\\)\\|rimitiveID\\(?:In\\)?\\)\\|Sample\\(?:ID\\|Mask\\(?:In\\)?\\|Position\\)\\|Tess\\(?:Coord\\|Level\\(?:\\(?:Inn\\|Out\\)er\\)\\)\\|V\\(?:ertexID\\|iewportIndex\\)\\|WorkGroup\\(?:Id\\|Size\\)\\)\\)\\>" . font-lock-builtin-face)))
  "Highest GLSL highlighting expressions")

(defvar glsl-font-lock-keywords glsl-font-lock-keywords-3
  "Default highlighting expressions for GLSL mode")

(defvar glsl-mode-syntax-table
  (let ((glsl-mode-syntax-table (make-syntax-table)))
    glsl-mode-syntax-table)
  "Syntax table for GLSL mode")

(define-derived-mode glsl-mode c-mode "GLSL"
  "Major mode for editing OpenGL shader files"
  (set (make-local-variable 'font-lock-defaults) '(glsl-font-lock-keywords)))
