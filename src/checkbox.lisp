(in-package #:ui)

(defclass checkbox (control on-toggled-slot)
  ((checked
     :accessor checked
     :initarg :checked
     :initform nil
     :allocation :ui-instance)
   (text
     :accessor text
     :initarg :text
     :initform ""
     :allocation :ui-instance))
  (:metaclass ui-metaclass))

(defmethod closer-mop:slot-value-using-class ((class ui-metaclass) (object checkbox) (slot closer-mop:standard-effective-slot-definition))
  (if (eql :ui-instance (closer-mop:slot-definition-allocation slot))
    (switch ((closer-mop:slot-definition-name slot) :test #'equal)
      ('checked
        (%checkbox-checked object))
      ('text
        (%checkbox-text object))
      (t
        (call-next-method)))
    (call-next-method)))

(defmethod (setf closer-mop:slot-value-using-class) (new-value (class ui-metaclass) (object checkbox) (slot closer-mop:standard-effective-slot-definition))
  (if (eql :ui-instance (closer-mop:slot-definition-allocation slot))
    (switch ((closer-mop:slot-definition-name slot) :test #'equal)
      ('checked
        (%checkbox-set-checked object new-value))
      ('text
        (%checkbox-set-text object new-value))
      (t
        (call-next-method)))
    (call-next-method)))

(defmethod initialize-instance :before ((instance checkbox) &rest initargs &key &allow-other-keys)
  (setf (handle instance)
        (%new-checkbox (getf initargs :text))))

(defmethod initialize-instance :after ((instance checkbox) &rest initargs &key &allow-other-keys)
  (declare (ignore initargs))
  (%checkbox-on-toggled instance (cffi:callback on-toggled-callback) instance))
