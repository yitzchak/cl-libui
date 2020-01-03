(in-package #:ui)

(defclass button (control on-clicked-slot)
  ((text
     :accessor text
     :initarg :text
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
        (%new-button (getf initargs :text))))

(defmethod initialize-instance :after ((instance button) &rest initargs &key &allow-other-keys)
  (declare (ignore initargs))
  (%button-on-clicked instance (cffi:callback on-clicked-callback) instance))

