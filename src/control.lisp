(in-package :ui)

(defclass control ()
  ((handle
     :accessor handle
     :initarg :handle)
   (enabled
     :accessor enabled
     :initarg :enabled
     :allocation :ui-instance)
   (visible
     :accessor visible
     :initarg :visible
     :allocation :ui-instance))
  (:metaclass ui-metaclass))

(defmethod cffi:translate-to-foreign (object (type control-pointer))
  (declare (ignore type))
  (handle object))

(defmethod cffi:translate-from-foreign (handle (type control-pointer))
  (declare (ignore type))
  (make-instance 'control :handle handle))

(defmethod closer-mop:slot-value-using-class ((class ui-metaclass) (object control) (slot closer-mop:standard-effective-slot-definition))
  (if (eql :ui-instance (closer-mop:slot-definition-allocation slot))
    (switch ((closer-mop:slot-definition-name slot) :test #'equal)
      ('enabled
        (%control-enabled object))
      ('visible
        (%control-visible object))
      (t
        (call-next-method)))
    (call-next-method)))

(defmethod (setf closer-mop:slot-value-using-class) (new-value (class ui-metaclass) (object control) (slot closer-mop:standard-effective-slot-definition))
  (if (eql :ui-instance (closer-mop:slot-definition-allocation slot))
    (switch ((closer-mop:slot-definition-name slot) :test #'equal)
      ('enabled
        (if new-value
          (%control-enable object)
          (%control-disable object)))
      ('visible
        (if new-value
          (%control-show object)
          (%control-hide object)))
      (t
        (call-next-method)))
    (call-next-method)))

(defgeneric on-changed (control)
  (:documentation "Called on change signal."))

(defmethod on-changed (control)
  (declare (ignore control)))

(cffi:defcallback on-changed-callback :void ((control control-pointer) (data :pointer))
  (declare (ignore data))
  (on-changed control))

(defgeneric append-child (object child &rest options &key &allow-other-keys))

(defgeneric insert-child (object child &rest options &key &allow-other-keys))

(defgeneric append-text (object item &rest options &key &allow-other-keys))

(defgeneric append-item (object item &rest options &key &allow-other-keys))
