(in-package #:ui)

(defclass box (control)
  ((padded
     :accessor padded
     :initarg :padded
     :initform nil
     :allocation :ui-instance))
  (:metaclass control-metaclass))

(defmethod closer-mop:slot-value-using-class ((class control-metaclass) (object box) (slot closer-mop:standard-effective-slot-definition))
  (if (eql :ui-instance (closer-mop:slot-definition-allocation slot))
    (switch ((closer-mop:slot-definition-name slot) :test #'equal)
      ('padded
        (%box-padded (handle object)))
      (t
        (call-next-method)))
    (call-next-method)))

(defmethod (setf closer-mop:slot-value-using-class) (new-value (class control-metaclass) (object box) (slot closer-mop:standard-effective-slot-definition))
  (if (eql :ui-instance (closer-mop:slot-definition-allocation slot))
    (switch ((closer-mop:slot-definition-name slot) :test #'equal)
      ('padded
        (%box-set-padded (handle object) new-value))
      (t
        (call-next-method)))
    (call-next-method)))

(defclass vertical-box (box)
  ()
  (:metaclass control-metaclass))

(defmethod initialize-instance :before ((instance vertical-box) &rest initargs &key &allow-other-keys)
  (declare (ignore initargs))
  (setf (handle instance)
        (%new-vertical-box)))

(defclass horizontal-box (box)
  ()
  (:metaclass control-metaclass))

(defmethod initialize-instance :before ((instance horizontal-box) &rest initargs &key &allow-other-keys)
  (declare (ignore initargs))
  (setf (handle instance)
        (%new-horizontal-box)))

(defmethod append-child ((object box) child &rest options &key &allow-other-keys)
  (%box-append (handle object) (handle child) (getf options :stretch)))
