(ql:quickload :cl-libui)

(defvar *window* nil)
(defvar *font-button* nil)
(defvar *align-combobox* nil)
(defvar *area* nil)
(defvar *attributed-string* nil)

(defmethod ui:on-draw (object params)
  (declare (ignore object))
  (let ((tl (make-instance 'ui:text-layout :string *attributed-string*
                                           :default-font (ui:font *font-button*)
                                           :width (getf params :area-width)
                                           :align (ui:selected *align-combobox*))))
    (ui::%draw-text (getf params :context) tl 0d0 0d0)))

(defmethod ui:on-changed (object)
  (declare (ignore object))
  (ui::%area-queue-redraw-all *area*))

(defun make-attributed-string ()
  (let ((attrst (make-instance 'ui:attributed-string :text
    "Drawing strings with libui is done with the ui:attributed-string and ui:text-layout objects.
ui:attributed-string lets you have a variety of attributes: ")))
    (ui:append-text attrst "font family"
                    :family "Courier New")
    (ui:append-text attrst ", ")
    (ui:append-text attrst "font size"
                    :size 18.0d0)
    (ui:append-text attrst ", ")
    (ui:append-text attrst "font weight"
                    :weight :bold)
    (ui:append-text attrst ", ")
    (ui:append-text attrst "font italicness"
                    :italic :italic)
    (ui:append-text attrst ", ")
    (ui:append-text attrst "font stretch"
                    :stretch :condensed)
    (ui:append-text attrst ", ")
    (ui:append-text attrst "text color"
                    :color '(:red 0.75d0 :green 0.25d0 :blue 0.5d0 :alpha 0.75d0))
    (ui:append-text attrst ", ")
    (ui:append-text attrst "text background color"
                    :color '(:red 0.5d0 :green 0.5d0 :blue 0.25d0 :alpha 0.5d0))
    (ui:append-text attrst ", ")
    (ui:append-text attrst "underline style"
                    :underline :single)
    (ui:append-text attrst ", and ")
    (ui:append-text attrst "underline color"
                    :underline :double
                    :underline-color '(:underline :custom :red 1.0d0 :green 0.0d0 :blue 0.5d0 :alpha 1.0d0))
    (ui:append-text attrst ". Furthermore, there are attributes allowing for ")
    (ui:append-text attrst "special underlines for indicating spelling errors"
                    :underline :suggestion
                    :underline-color '(:underline :spelling :red 0d0 :green 0d0 :blue 0d0 :alpha 0d0))
    (ui:append-text attrst " (and other types of errors) and control over OpenType features such as ligatures (for instance, ")
    (ui:append-text attrst "afford"
                    :features '(:liga 0))
    (ui:append-text attrst " vs. ")
    (ui:append-text attrst "afford"
                    :features '(:liga 1))
    (ui:append-text attrst ").
Use the controls opposite to the text to control properties of the text.")
    attrst))

(defmethod ui:on-init ()
  (let ((hbox (make-instance 'ui:horizontal-box :padded t))
        (vbox (make-instance 'ui:vertical-box :padded t))
        (form (make-instance 'ui:form :padded t)))
    (setq *attributed-string* (make-attributed-string))
    (setq *window* (make-instance 'ui:window :title "libui Text-Drawing Example"
                                             :width 640 :height 480
                                             :has-menubar t :visible t :margined t))
    (setf (ui:child *window*) hbox)
    (ui:append-child hbox vbox)
    (setq *font-button* (make-instance 'ui:font-button))
    (ui:append-child vbox *font-button*)
    (ui:append-child vbox form)
    (setq *align-combobox* (make-instance 'ui:combobox :items '("Left" "Center" "Right")
                                                       :selected 0))
    (ui:append-child form *align-combobox* :label "Alignment")
    (setq *area* (make-instance 'ui:area))
    (ui:append-child hbox *area* :stretch t)))

(defmethod ui:on-closing (control)
  (declare (ignore control))
  (ui::%quit)
  t)

(ui:main)
