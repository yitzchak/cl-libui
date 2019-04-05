(in-package #:ui)

(defclass grid (control)
  ((padded
     :accessor padded
     :initarg :padded
     :initform nil
     :allocation :ui-instance))
  (:metaclass control-metaclass))

(defmethod closer-mop:slot-value-using-class ((class control-metaclass) (object grid) (slot closer-mop:standard-effective-slot-definition))
  (if (eql :ui-instance (closer-mop:slot-definition-allocation slot))
    (switch ((closer-mop:slot-definition-name slot) :test #'equal)
      ('padded
        (%grid-padded (handle object)))
      (t
        (call-next-method)))
    (call-next-method)))

(defmethod (setf closer-mop:slot-value-using-class) (new-value (class control-metaclass) (object grid) (slot closer-mop:standard-effective-slot-definition))
  (if (eql :ui-instance (closer-mop:slot-definition-allocation slot))
    (switch ((closer-mop:slot-definition-name slot) :test #'equal)
      ('padded
        (%grid-set-padded (handle object) new-value))
      (t
        (call-next-method)))
    (call-next-method)))

(defmethod initialize-instance :before ((instance grid) &rest initargs &key &allow-other-keys)
  (declare (ignore initargs))
  (setf (handle instance)
        (%new-grid)))

(defmethod append-child ((object grid) child &rest options &key &allow-other-keys)
  (%grid-append object child (getf options :left)
                             (getf options :top)
                             (getf options :xspan)
                             (getf options :yspan)
                             (getf options :hexpand)
                             (getf options :halign)
                             (getf options :vexpand)
                             (getf options :valign)))
