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

(defmethod closer-mop:slot-value-using-class ((class control-metaclass) object (slot closer-mop:standard-effective-slot-definition))
  (if (eql :ui-instance (closer-mop:slot-definition-allocation slot))
    (let ((handle (handle object)))
      (switch ((closer-mop:slot-definition-name slot) :test #'equal)
        ('enabled
          (%control-enabled handle))
        ('visible
          (%control-visible handle))))
    (call-next-method)))

(defmethod (setf closer-mop:slot-value-using-class) (new-value (class control-metaclass) object (slot closer-mop:standard-effective-slot-definition))
  (if (eql :ui-instance (closer-mop:slot-definition-allocation slot))
    (let ((handle (handle object)))
      (switch ((closer-mop:slot-definition-name slot) :test #'equal)
        ('enabled
          (if new-value
            (%control-enable handle)
            (%control-disable handle)))
        ('visible
          (if new-value
            (%control-show handle)
            (%control-hide handle)))))
    (call-next-method)))

(defmethod closer-mop:slot-boundp-using-class ((class control-metaclass) object (slot closer-mop:standard-effective-slot-definition))
  (or (eql :ui-instance (closer-mop:slot-definition-allocation slot))
      (call-next-method)))
