(asdf:defsystem #:cl-libui
  :description "A Common Lisp interface to libui."
  :version "0.1"
  :author "Tarn W. Burton"
  :license "MIT"
  :depends-on (
    #:alexandria
    #:cffi
    #:closer-mop)
  :components
    ((:module src
      :serial t
      :components
        ((:file "packages")
         (:file "libui")
         (:file "core")
         (:file "control")
         (:file "box")
         (:file "button")
         (:file "checkbox")
         (:file "label")
         (:file "tab")
         (:file "window")))))
