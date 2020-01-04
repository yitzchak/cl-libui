(in-package #:ui)

(defclass form (control)
  ((padded
     :accessor padded
     :initarg :padded
     :allocation :ui-instance))
  (:metaclass ui-metaclass))

(defmethod closer-mop:slot-value-using-class ((class ui-metaclass) (object form) (slot closer-mop:standard-effective-slot-definition))
  (if (eql :ui-instance (closer-mop:slot-definition-allocation slot))
    (switch ((closer-mop:slot-definition-name slot) :test #'equal)
      ('padded
        (%form-padded object))
      (t
        (call-next-method)))
    (call-next-method)))

(defmethod (setf closer-mop:slot-value-using-class) (new-value (class ui-metaclass) (object form) (slot closer-mop:standard-effective-slot-definition))
  (if (eql :ui-instance (closer-mop:slot-definition-allocation slot))
    (switch ((closer-mop:slot-definition-name slot) :test #'equal)
      ('padded
        (%form-set-padded object new-value))
      (t
        (call-next-method)))
    (call-next-method)))

(defmethod initialize-instance :before ((instance form) &rest initargs &key &allow-other-keys)
  (declare (ignore initargs))
  (setf (handle instance)
        (%new-form)))

(defmethod append-child ((object form) child &rest options &key &allow-other-keys)
  (%form-append object (getf options :label) child (getf options :stretch)))
