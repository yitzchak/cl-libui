(in-package #:ui)

(defgeneric on-closing (control)
  (:documentation "Called to confirm close signal."))

(defmethod on-closing (control)
  (declare (ignore control))
  t)

(cffi:defcallback on-closing-callback (:boolean :int) ((control control-pointer) (data :pointer))
  (declare (ignore data))
  (on-closing control))

(defclass window (control)
  ((child
     :accessor child
     :initarg :child
     :initform nil)
   (fullscreen
     :accessor fullscreen
     :initarg :fullscreen
     :initform nil
     :allocation :ui-instance)
   (margined
     :accessor margined
     :initarg :margined
     :initform nil
     :allocation :ui-instance)
   (title
     :accessor title
     :initarg :title
     :allocation :ui-instance))
  (:metaclass ui-metaclass))

(defmethod initialize-instance :before ((instance window) &rest initargs &key &allow-other-keys)
  (setf (handle instance)
        (%new-window (getf initargs :title)
                     (getf initargs :width)
                     (getf initargs :height)
                     (getf initargs :has-menubar)))
  (%window-on-closing instance (cffi:callback on-closing-callback) (cffi:null-pointer)))

(defmethod (setf child) :after (new-value (object window))
  (when new-value
    (%window-set-child object new-value)))

(defmethod closer-mop:slot-value-using-class ((class ui-metaclass) (object window) (slot closer-mop:standard-effective-slot-definition))
  (if (eql :ui-instance (closer-mop:slot-definition-allocation slot))
    (switch ((closer-mop:slot-definition-name slot) :test #'equal)
      ('fullscreen
        (%window-fullscreen object))
      ('margined
        (%window-margined object))
      ('title
        (%window-title object))
      (t
        (call-next-method)))
    (call-next-method)))

(defmethod (setf closer-mop:slot-value-using-class) (new-value (class ui-metaclass) (object window) (slot closer-mop:standard-effective-slot-definition))
  (if (eql :ui-instance (closer-mop:slot-definition-allocation slot))
    (switch ((closer-mop:slot-definition-name slot) :test #'equal)
      ('fullscreen
        (%window-set-fullscreen object new-value))
      ('margined
        (%window-set-margined object new-value))
      ('title
        (%window-set-title object new-value))
      (t
        (call-next-method)))
    (call-next-method)))
