(ql:quickload :cl-libui)

(defparameter *window* nil)
(defparameter *slider* nil)
(defparameter *spinbox* nil)
(defparameter *progress-bar* nil)
(defparameter *file-entry* nil)
(defparameter *file-button* nil)

(defmethod ui:on-changed (control)
  (cond
    ((eql control *slider*)
      (let ((value (ui:value control)))
        (setf (ui:value *spinbox*) value)
        (setf (ui:value *progress-bar*) value)))
    ((eql control *spinbox*)
      (let ((value (ui:value control)))
        (setf (ui:value *slider*) value)
        (setf (ui:value *progress-bar*) value)))
    ((typep control 'ui:font-button)
      (format t "~S~%" (ui:font control)))
    ((typep control 'ui:color-button)
      (format t "~S~%" (ui:color control)))))

(defmethod ui:on-clicked (control)
  (when (eql control *file-button*)
    (setf (ui:text *file-entry*) (or (ui:open-file control) "(cancelled)"))))

(defun make-basic-controls-page ()
  (let ((vbox (make-instance 'ui:vertical-box :padded t))
        (hbox (make-instance 'ui:horizontal-box :padded t))
        (entries-group (make-instance 'ui:group :title "Entries" :margined t))
        (entry-form (make-instance 'ui:form :padded t)))
    (ui:append-child vbox hbox)
    (ui:append-child hbox (make-instance 'ui:button :text "Button"))
    (ui:append-child hbox (make-instance 'ui:checkbox :text "Checkbox"))
    (ui:append-child vbox (make-instance 'ui:label :text "This is a label. Right now, labels can only span one line."))
    (ui:append-child vbox (make-instance 'ui:horizontal-separator))
    (ui:append-child vbox entries-group :stretch t)
    (setf (ui:child entries-group) entry-form)
    (ui:append-child entry-form (make-instance 'ui:entry) :label "Entry")
    (ui:append-child entry-form (make-instance 'ui:password-entry) :label "Password Entry")
    (ui:append-child entry-form (make-instance 'ui:search-entry) :label "Search Entry")
    (ui:append-child entry-form (make-instance 'ui:multiline-entry) :label "Multiline Entry" :stretch t)
    (ui:append-child entry-form (make-instance 'ui:non-wrapping-multiline-entry) :label "Multiline Entry No Wrap" :stretch t)
    vbox))

(defun make-numbers-page ()
  (let ((vbox (make-instance 'ui:vertical-box :padded t))
        (hbox (make-instance 'ui:horizontal-box :padded t))
        (number-group (make-instance 'ui:group :title "Numbers" :margined t))
        (list-group (make-instance 'ui:group :title "Lists" :margined t))
        (list-box (make-instance 'ui:vertical-box :padded t))
        (c (make-instance 'ui:combobox))
        (e (make-instance 'ui:editable-combobox))
        (r (make-instance 'ui:radio-buttons)))
    (ui:append-child hbox number-group :stretch t)
    (setf (ui:child number-group) vbox)
    (setq *spinbox* (make-instance 'ui:spinbox :min 0 :max 100))
    (ui:append-child vbox *spinbox*)
    (setq *slider* (make-instance 'ui:slider :min 0 :max 100))
    (ui:append-child vbox *slider*)
    (setq *progress-bar* (make-instance 'ui:progress-bar))
    (ui:append-child vbox *progress-bar*)
    (ui:append-child vbox (make-instance 'ui:progress-bar :value -1))
    (ui:append-child hbox list-group :stretch t)
    (setf (ui:child list-group) list-box)
    (ui:append-item c "Combobox Item 1")
    (ui:append-item c "Combobox Item 2")
    (ui:append-item c "Combobox Item 3")
    (ui:append-child list-box c)
    (ui:append-item e "Editable Item 1")
    (ui:append-item e "Editable Item 2")
    (ui:append-item e "Editable Item 3")
    (ui:append-child list-box e)
    (ui:append-item r "Radio Button 1")
    (ui:append-item r "Radio Button 2")
    (ui:append-item r "Radio Button 3")
    (ui:append-child list-box r)
    hbox))

(defun make-data-choosers-page ()
  (let ((hbox (make-instance 'ui:horizontal-box :padded t)))
    (let ((vbox (make-instance 'ui:vertical-box :padded t)))
      (ui:append-child hbox vbox)
      (ui:append-child vbox (make-instance 'ui:date-time-picker))
      (ui:append-child vbox (make-instance 'ui:date-picker))
      (ui:append-child vbox (make-instance 'ui:time-picker))
      (ui:append-child vbox (make-instance 'ui:font-button))
      (ui:append-child vbox (make-instance 'ui:color-button)))
    (ui:append-child hbox (make-instance 'ui:vertical-separator))
    (let ((vbox (make-instance 'ui:vertical-box :padded t))
          (g (make-instance 'ui:grid :padded t)))
      (ui:append-child hbox vbox)
      (ui:append-child vbox g)
      (setq *file-button* (make-instance 'ui:button :text "Open File"))
      (ui:append-child g *file-button* :left 0 :top 0 :xspan 1 :yspan 1 :halign :align-fill :valign :align-fill)
      (setq *file-entry* (make-instance 'ui:entry :read-only t))
      (ui:append-child g *file-entry* :left 1 :top 0 :xspan 1 :yspan 1 :hexpand t :halign :align-fill :valign :align-fill))
    hbox))

(defmethod ui:on-init ()
  (let ((tab (make-instance 'ui:tab)))
    (setq *window* (make-instance 'ui:window :title "libui Control Gallery" :width 640 :height 480
                                        :has-menubar t :visible t))
    (setf (ui:child *window*) tab)
    (ui:append-child tab (make-basic-controls-page) :title "Basic Controls")
    (ui:append-child tab (make-numbers-page) :title "Numbers and Lists")
    (ui:append-child tab (make-data-choosers-page) :title "Data Choosers")))

(defmethod ui:on-closing (control)
  (declare (ignore control))
  (ui::%quit)
  t)

(ui:main)
