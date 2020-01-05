(asdf:defsystem #:cl-libui
  :description "A Common Lisp interface to libui."
  :version "0.1"
  :author "Tarn W. Burton"
  :license "MIT"
  :defsystem-depends-on (:cffi-grovel)
  :depends-on (
    #:alexandria
    #:cffi
    #:closer-mop
    #:iterate
    #:trivial-garbage)
  :components
    ((:module src
      :serial t
      :components
        ((:file "packages")
         (:cffi-grovel-file "grovel")
         (:file "libui")
         (:file "core")
         (:file "text-layout")
         (:file "path")
         (:file "matrix")
         (:file "draw-context")
         (:file "attribute")
         (:file "control")
         (:file "area")
         (:file "box")
         (:file "button")
         (:file "checkbox")
         (:file "color-button")
         (:file "date-time-picker")
         (:file "entry")
         (:file "font-button")
         (:file "form")
         (:file "grid")
         (:file "group")
         (:file "label")
         (:file "list")
         (:file "range")
         (:file "separator")
         (:file "tab")
         (:file "window")))))
