(in-package #:ui)

(defclass window (control on-closing-slot on-content-size-changed-slot)
  ((child
     :accessor child
     :initarg :child)
   (fullscreen
     :accessor fullscreen
     :initarg :fullscreen
     :allocation :ui-instance)
   (margined
     :accessor margined
     :initarg :margined
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
                     (getf initargs :has-menubar))))

(defmethod initialize-instance :after ((instance window) &rest initargs &key &allow-other-keys)
  (declare (ignore initargs))
  (%window-on-content-size-changed instance (cffi:callback on-content-size-changed-callback) (cffi:null-pointer))
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
