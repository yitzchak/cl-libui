(in-package #:ui)

(defgeneric on-clicked (control)
  (:documentation "Called on click signal."))

(defmethod on-clicked (control)
  (declare (ignore control)))

(cffi:defcallback on-clicked-callback (:boolean :int) ((control ui-type) (data :pointer))
  (declare (ignore data))
  (on-clicked control))

(defclass button (control)
  ((text
     :accessor text
     :initarg :text
     :initform ""
     :allocation :ui-instance))
  (:metaclass ui-metaclass))

(defmethod closer-mop:slot-value-using-class ((class ui-metaclass) (object button) (slot closer-mop:standard-effective-slot-definition))
  (if (eql :ui-instance (closer-mop:slot-definition-allocation slot))
    (switch ((closer-mop:slot-definition-name slot) :test #'equal)
      ('text
        (%button-text object))
      (t
        (call-next-method)))
    (call-next-method)))

(defmethod (setf closer-mop:slot-value-using-class) (new-value (class ui-metaclass) (object button) (slot closer-mop:standard-effective-slot-definition))
  (if (eql :ui-instance (closer-mop:slot-definition-allocation slot))
    (switch ((closer-mop:slot-definition-name slot) :test #'equal)
      ('text
        (%button-set-text object new-value))
      (t
        (call-next-method)))
    (call-next-method)))

(defmethod initialize-instance :before ((instance button) &rest initargs &key &allow-other-keys)
  (setf (handle instance)
        (%new-button (getf initargs :text)))
  (%button-on-clicked instance (cffi:callback on-clicked-callback) (cffi:null-pointer)))
