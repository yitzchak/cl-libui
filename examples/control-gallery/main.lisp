(ql:quickload :cl-libui)

(defparameter *slider* nil)
(defparameter *spinbox* nil)
(defparameter *progress-bar* nil)

(defmethod ui:on-changed (control)
  (cond
    ((eql control *slider*)
      (let ((value (ui:value control)))
        (setf (ui:value *spinbox*) value)
        (setf (ui:value *progress-bar*) value)))
    ((eql control *spinbox*)
      (let ((value (ui:value control)))
        (setf (ui:value *slider*) value)
        (setf (ui:value *progress-bar*) value)))))

(defun make-basic-controls-page ()
  (let ((vbox (make-instance 'ui:vertical-box :padded t))
        (hbox (make-instance 'ui:horizontal-box :padded t))
        (group (make-instance 'ui:group :title "Entries" :margined t))
        (entry-form (make-instance 'ui:form :padded t)))
    (ui:append-child vbox hbox)
    (ui:append-child hbox (make-instance 'ui:button :text "Button"))
    (ui:append-child hbox (make-instance 'ui:checkbox :text "Checkbox"))
    (ui:append-child vbox (make-instance 'ui:label :text "This is a label. Right now, labels can only span one line."))
    (ui:append-child vbox (make-instance 'ui:horizontal-separator))
    (ui:append-child vbox group :stretch t)
    (setf (ui:child group) entry-form)
    (ui:append-child entry-form (make-instance 'ui:entry) :label "Entry")
    (ui:append-child entry-form (make-instance 'ui:password-entry) :label "Password Entry")
    (ui:append-child entry-form (make-instance 'ui:search-entry) :label "Search Entry")
    (ui:append-child entry-form (make-instance 'ui:multiline-entry) :label "Multiline Entry" :stretch t)
    (ui:append-child entry-form (make-instance 'ui:non-wrapping-multiline-entry) :label "Multiline Entry No Wrap" :stretch t)
    vbox))

(defun make-numbers-page ()
  (let ((vbox (make-instance 'ui:vertical-box :padded t))
        (hbox (make-instance 'ui:horizontal-box :padded t))
        (group (make-instance 'ui:group :title "Numbers" :margined t)))
    (ui:append-child hbox group :stretch t)
    (setf (ui:child group) vbox)
    (setq *spinbox* (make-instance 'ui:spinbox :min 0 :max 100))
    (ui:append-child vbox *spinbox*)
    (setq *slider* (make-instance 'ui:slider :min 0 :max 100))
    (ui:append-child vbox *slider*)
    (setq *progress-bar* (make-instance 'ui:progress-bar))
    (ui:append-child vbox *progress-bar*)
    (ui:append-child vbox (make-instance 'ui:progress-bar :value -1))
    hbox))

(defun make-data-choosers-page ()
  (let ((vbox (make-instance 'ui:vertical-box :padded t)))
    vbox))

(defmethod ui:on-init ()
  (let ((tab (make-instance 'ui:tab)))
    (defvar w (make-instance 'ui:window :title "libui Control Gallery" :width 640 :height 480
                                        :has-menubar t :visible t))
    (setf (ui:child w) tab)
    (ui:append-child tab (make-basic-controls-page) :title "Basic Controls")
    (ui:append-child tab (make-numbers-page) :title "Numbers and Lists")
    (ui:append-child tab (make-data-choosers-page) :title "Data Choosers")))

(defmethod ui:on-closing (control)
  (declare (ignore control))
  (ui::%quit)
  t)

(ui:main)
