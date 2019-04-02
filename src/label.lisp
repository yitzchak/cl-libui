(in-package #:ui)

(defclass label (control)
  ((text
     :accessor text
     :initarg :text
     :initform ""
     :allocation :ui-instance))
  (:metaclass control-metaclass))

(defmethod closer-mop:slot-value-using-class ((class control-metaclass) (object label) (slot closer-mop:standard-effective-slot-definition))
  (if (eql :ui-instance (closer-mop:slot-definition-allocation slot))
    (switch ((closer-mop:slot-definition-name slot) :test #'equal)
      ('text
        (%label-text object))
      (t
        (call-next-method)))
    (call-next-method)))

(defmethod (setf closer-mop:slot-value-using-class) (new-value (class control-metaclass) (object label) (slot closer-mop:standard-effective-slot-definition))
  (if (eql :ui-instance (closer-mop:slot-definition-allocation slot))
    (switch ((closer-mop:slot-definition-name slot) :test #'equal)
      ('text
        (%label-set-text object new-value))
      (t
        (call-next-method)))
    (call-next-method)))

(defmethod initialize-instance :before ((instance label) &rest initargs &key &allow-other-keys)
  (setf (handle instance)
        (%new-label (getf initargs :text))))
