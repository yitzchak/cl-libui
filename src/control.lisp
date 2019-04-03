(in-package :ui)

(defclass control-metaclass (standard-class)
  ())

(defmethod closer-mop:validate-superclass
           ((class control-metaclass) (super standard-class))
  t)

(defmethod closer-mop:compute-slots ((class control-metaclass))
  (call-next-method))

(defclass control ()
  ((handle
     :accessor handle)
   (enabled
     :accessor enabled
     :initarg :enabled
     :initform t
     :allocation :ui-instance)
   (visible
     :accessor visible
     :initarg :visible
     :initform nil
     :allocation :ui-instance))
  (:metaclass control-metaclass))

(defparameter *controls* (make-hash-table))

(defmethod initialize-instance :after ((instance control) &rest initargs &key &allow-other-keys)
  (declare (ignore initargs))
  (setf (gethash (handle instance) *controls*) instance))

(defmethod cffi:translate-to-foreign ((object control) (type control-type))
  (declare (ignore type))
  (handle object))

(defmethod cffi:translate-from-foreign (handle (type control-type))
  (gethash handle *controls*))

(defmethod closer-mop:slot-value-using-class ((class control-metaclass) object (slot closer-mop:standard-effective-slot-definition))
  (if (eql :ui-instance (closer-mop:slot-definition-allocation slot))
    (switch ((closer-mop:slot-definition-name slot) :test #'equal)
      ('enabled
        (%control-enabled object))
      ('visible
        (%control-visible object)))
    (call-next-method)))

(defmethod (setf closer-mop:slot-value-using-class) (new-value (class control-metaclass) object (slot closer-mop:standard-effective-slot-definition))
  (if (eql :ui-instance (closer-mop:slot-definition-allocation slot))
    (switch ((closer-mop:slot-definition-name slot) :test #'equal)
      ('enabled
        (if new-value
          (%control-enable object)
          (%control-disable object)))
      ('visible
        (if new-value
          (%control-show object)
          (%control-hide object))))
    (call-next-method)))

(defmethod closer-mop:slot-boundp-using-class ((class control-metaclass) object (slot closer-mop:standard-effective-slot-definition))
  (or (eql :ui-instance (closer-mop:slot-definition-allocation slot))
      (call-next-method)))

(defgeneric on-changed (control)
  (:documentation "Called on change signal."))

(defmethod on-changed (control)
  (declare (ignore control)))

(cffi:defcallback on-changed-callback :void ((control control-type) (data :pointer))
  (declare (ignore data))
  (on-changed control))

(defgeneric append-child (object child &rest options &key &allow-other-keys))

(defgeneric append-text (object item &rest options &key &allow-other-keys))

(defgeneric append-item (object item &rest options &key &allow-other-keys))
