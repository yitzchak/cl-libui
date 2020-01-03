(in-package #:ui)

(defclass button (control)
  ((text
     :accessor text
     :initarg :text
     :allocation :ui-instance)
   (on-clicked-handlers
     :accessor on-clicked-handlers
     :initform (make-hash-table)
     :allocation :class))
  (:metaclass ui-metaclass))

(defun on-clicked (instance)
  (gethash (cffi:pointer-address (handle instance)) (on-clicked-handlers instance)))

(defun (setf on-clicked) (handler instance)
   (setf (gethash (cffi:pointer-address (handle instance)) (on-clicked-handlers instance)) handler))

(cffi:defcallback on-clicked-callback (:boolean :int) ((instance button-pointer) (data :pointer))
  (declare (ignore data))
  (when-let ((handler (on-clicked instance)))
    (funcall handler instance)))

(defmethod cffi:translate-to-foreign (object (type button-pointer))
  (declare (ignore type))
  (handle object))

(defmethod cffi:translate-from-foreign (handle (type button-pointer))
  (declare (ignore type))
  (make-instance 'button :handle handle))

(defmethod closer-mop:slot-value-using-class ((class ui-metaclass) (object button) (slot closer-mop:standard-effective-slot-definition))
  (if (eql :ui-instance (closer-mop:slot-definition-allocation slot))
    (switch ((closer-mop:slot-definition-name slot) :test #'equal)
      ('text
        (%button-text object))
      (t
        (call-next-method)))
    (call-next-method)))

(defmethod (setf closer-mop:slot-value-using-class) (new-value (class ui-metaclass) (object button) (slot closer-mop:standard-effective-slot-definition))
  (if (eql :ui-instance (closer-mop:slot-definition-allocation slot))
    (switch ((closer-mop:slot-definition-name slot) :test #'equal)
      ('text
        (%button-set-text object new-value))
      (t
        (call-next-method)))
    (call-next-method)))

(defmethod initialize-instance :before ((instance button) &rest initargs &key &allow-other-keys)
  (unless (getf initargs :handle)
    (setf (handle instance)
          (%new-button (getf initargs :text)))
    (%button-on-clicked instance (cffi:callback on-clicked-callback) (cffi:null-pointer))))

