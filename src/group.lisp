(in-package #:ui)

(defclass group (control)
  ((child
     :accessor child
     :initarg :child)
   (margined
     :accessor margined
     :initarg :margined
     :allocation :ui-instance)
   (title
     :accessor title
     :initarg :title
     :allocation :ui-instance))
  (:metaclass ui-metaclass))

(defmethod initialize-instance :before ((instance group) &rest initargs &key &allow-other-keys)
  (setf (handle instance)
        (%new-group (getf initargs :title))))

(defmethod (setf child) :after (new-value (object group))
  (when new-value
    (%group-set-child object new-value)))

(defmethod closer-mop:slot-value-using-class ((class ui-metaclass) (object group) (slot closer-mop:standard-effective-slot-definition))
  (if (eql :ui-instance (closer-mop:slot-definition-allocation slot))
    (switch ((closer-mop:slot-definition-name slot) :test #'equal)
      ('margined
        (%group-margined object))
      ('title
        (%group-title object))
      (t
        (call-next-method)))
    (call-next-method)))

(defmethod (setf closer-mop:slot-value-using-class) (new-value (class ui-metaclass) (object group) (slot closer-mop:standard-effective-slot-definition))
  (if (eql :ui-instance (closer-mop:slot-definition-allocation slot))
    (switch ((closer-mop:slot-definition-name slot) :test #'equal)
      ('margined
        (%group-set-margined object new-value))
      ('title
        (%group-set-title object new-value))
      (t
        (call-next-method)))
    (call-next-method)))
