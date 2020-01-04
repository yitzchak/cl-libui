(in-package #:ui)

(defclass font-button (control on-changed-slot)
  ((font
     :accessor font
     :initarg :font
     :allocation :ui-instance))
  (:metaclass ui-metaclass))

(defmethod closer-mop:slot-value-using-class ((class ui-metaclass) (object font-button) (slot closer-mop:standard-effective-slot-definition))
  (if (eql :ui-instance (closer-mop:slot-definition-allocation slot))
    (switch ((closer-mop:slot-definition-name slot) :test #'equal)
      ('font
        (cffi:with-foreign-object (f '(:struct %font-descriptor))
          (%font-button-font object f)
          (cffi:convert-from-foreign f '(:struct %font-descriptor))))
      (t
        (call-next-method)))
    (call-next-method)))

(defmethod (setf closer-mop:slot-value-using-class) (new-value (class ui-metaclass) (object font-button) (slot closer-mop:standard-effective-slot-definition))
  (if (eql :ui-instance (closer-mop:slot-definition-allocation slot))
    (switch ((closer-mop:slot-definition-name slot) :test #'equal)
      ('font
        (error "Setting font property on font-button not yet supported in libui."))
      (t
        (call-next-method)))
    (call-next-method)))

(defmethod initialize-instance :before ((instance font-button) &rest initargs &key &allow-other-keys)
  (declare (ignore initargs))
  (setf (handle instance)
        (%new-font-button)))

(defmethod initialize-instance :after ((instance font-button) &rest initargs &key &allow-other-keys)
  (declare (ignore initargs))
  (%font-button-on-changed instance (cffi:callback on-changed-callback) (cffi:null-pointer)))
