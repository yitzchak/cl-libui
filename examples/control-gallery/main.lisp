(ql:quickload :cl-libui)

(defun make-basic-controls-page ()
  (let ((vbox (make-instance 'ui:vertical-box :padded t))
        (hbox (make-instance 'ui:horizontal-box :padded t)))
    (ui:append-child vbox hbox)
    (ui:append-child hbox (make-instance 'ui:button :text "Button"))
    vbox))

(defun make-numbers-page ()
  (let ((vbox (make-instance 'ui:vertical-box :padded t)))
    vbox))

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
