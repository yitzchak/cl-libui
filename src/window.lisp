(in-package #:ui)

(defgeneric on-closing (control)
  (:documentation "Called to confirm close signal."))

(defmethod on-closing (control)
  (declare (ignore control))
  t)

(cffi:defcallback on-closing-callback (:boolean :int) ((control :pointer) (data :pointer))
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
  (:metaclass control-metaclass))

(defmethod initialize-instance :before ((instance window) &rest initargs &key &allow-other-keys)
  (with-slots (handle) instance
    (setf handle
          (%new-window (getf initargs :title)
                       (getf initargs :width)
                       (getf initargs :height)
                       (getf initargs :has-menubar)))
    (%window-on-closing handle (cffi:callback on-closing-callback) (cffi:null-pointer))))

(defmethod (setf child) :after (new-value (object window))
  (when new-value
    (format t "~A ~A~%" new-value object)
    (%window-set-child (handle object) (handle new-value))))

(defmethod closer-mop:slot-value-using-class ((class control-metaclass) (object window) (slot closer-mop:standard-effective-slot-definition))
  (if (eql :ui-instance (closer-mop:slot-definition-allocation slot))
    (let ((handle (handle object)))
      (switch ((closer-mop:slot-definition-name slot) :test #'equal)
        ('fullscreen
          (%window-fullscreen handle))
        ('margined
          (%window-margined handle))
        ('title
          (%window-title handle))
        (t
          (call-next-method))))
    (call-next-method)))

(defmethod (setf closer-mop:slot-value-using-class) (new-value (class control-metaclass) (object window) (slot closer-mop:standard-effective-slot-definition))
  (if (eql :ui-instance (closer-mop:slot-definition-allocation slot))
    (let ((handle (handle object)))
      (switch ((closer-mop:slot-definition-name slot) :test #'equal)
        ('fullscreen
          (%window-set-fullscreen handle new-value))
        ('margined
          (%window-set-margined handle new-value))
        ('title
          (%window-set-title handle new-value))
        (t
          (call-next-method))))
    (call-next-method)))
