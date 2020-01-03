(in-package #:ui)

(defclass range-control (control)
  ((value
     :accessor value
     :initarg :value
     :allocation :ui-instance))
  (:metaclass ui-metaclass))

(defclass spinbox (range-control on-changed-slot)
  ()
  (:metaclass ui-metaclass))

(defmethod closer-mop:slot-value-using-class ((class ui-metaclass) (object spinbox) (slot closer-mop:standard-effective-slot-definition))
  (if (eql :ui-instance (closer-mop:slot-definition-allocation slot))
    (switch ((closer-mop:slot-definition-name slot) :test #'equal)
      ('value
        (%spinbox-value object))
      (t
        (call-next-method)))
    (call-next-method)))

(defmethod (setf closer-mop:slot-value-using-class) (new-value (class ui-metaclass) (object spinbox) (slot closer-mop:standard-effective-slot-definition))
  (if (eql :ui-instance (closer-mop:slot-definition-allocation slot))
    (switch ((closer-mop:slot-definition-name slot) :test #'equal)
      ('value
        (%spinbox-set-value object new-value))
      (t
        (call-next-method)))
    (call-next-method)))

(defmethod initialize-instance :before ((instance spinbox) &rest initargs &key &allow-other-keys)
  (setf (handle instance)
        (%new-spinbox (getf initargs :min) (getf initargs :max))))

(defmethod initialize-instance :after ((instance spinbox) &rest initargs &key &allow-other-keys)
  (declare (ignore initargs))
  (%spinbox-on-changed instance (cffi:callback on-changed-callback) instance))

(defclass slider (range-control on-changed-slot)
  ()
  (:metaclass ui-metaclass))

(defmethod closer-mop:slot-value-using-class ((class ui-metaclass) (object slider) (slot closer-mop:standard-effective-slot-definition))
  (if (eql :ui-instance (closer-mop:slot-definition-allocation slot))
    (switch ((closer-mop:slot-definition-name slot) :test #'equal)
      ('value
        (%slider-value object))
      (t
        (call-next-method)))
    (call-next-method)))

(defmethod (setf closer-mop:slot-value-using-class) (new-value (class ui-metaclass) (object slider) (slot closer-mop:standard-effective-slot-definition))
  (if (eql :ui-instance (closer-mop:slot-definition-allocation slot))
    (switch ((closer-mop:slot-definition-name slot) :test #'equal)
      ('value
        (%slider-set-value object new-value))
      (t
        (call-next-method)))
    (call-next-method)))

(defmethod initialize-instance :before ((instance slider) &rest initargs &key &allow-other-keys)
  (setf (handle instance)
        (%new-slider (getf initargs :min) (getf initargs :max))))

(defmethod initialize-instance :after ((instance slider) &rest initargs &key &allow-other-keys)
  (declare (ignore initargs))
  (%slider-on-changed instance (cffi:callback on-changed-callback) instance))

(defclass progress-bar (range-control)
  ()
  (:metaclass ui-metaclass))

(defmethod closer-mop:slot-value-using-class ((class ui-metaclass) (object progress-bar) (slot closer-mop:standard-effective-slot-definition))
  (if (eql :ui-instance (closer-mop:slot-definition-allocation slot))
    (switch ((closer-mop:slot-definition-name slot) :test #'equal)
      ('value
        (%progress-bar-value object))
      (t
        (call-next-method)))
    (call-next-method)))

(defmethod (setf closer-mop:slot-value-using-class) (new-value (class ui-metaclass) (object progress-bar) (slot closer-mop:standard-effective-slot-definition))
  (if (eql :ui-instance (closer-mop:slot-definition-allocation slot))
    (switch ((closer-mop:slot-definition-name slot) :test #'equal)
      ('value
        (%progress-bar-set-value object new-value))
      (t
        (call-next-method)))
    (call-next-method)))

(defmethod initialize-instance :before ((instance progress-bar) &rest initargs &key &allow-other-keys)
  (declare (ignore initargs))
  (setf (handle instance)
        (%new-progress-bar)))
