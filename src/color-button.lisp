(in-package #:ui)

(defclass color-button (control)
  ((color
     :accessor color
     :initarg :color
     :allocation :ui-instance))
  (:metaclass control-metaclass))

(defmethod closer-mop:slot-value-using-class ((class control-metaclass) (object color-button) (slot closer-mop:standard-effective-slot-definition))
  (if (eql :ui-instance (closer-mop:slot-definition-allocation slot))
    (switch ((closer-mop:slot-definition-name slot) :test #'equal)
      ('color
        (cffi:with-foreign-objects ((r :double) (g :double) (b :double) (a :double))
          (%color-button-color object r g b a)
          (list :red (cffi:mem-aref r :double)
                :green (cffi:mem-aref g :double)
                :blue (cffi:mem-aref b :double)
                :alpha (cffi:mem-aref a :double))))
      (t
        (call-next-method)))
    (call-next-method)))

(defmethod (setf closer-mop:slot-value-using-class) (new-value (class control-metaclass) (object color-button) (slot closer-mop:standard-effective-slot-definition))
  (if (eql :ui-instance (closer-mop:slot-definition-allocation slot))
    (switch ((closer-mop:slot-definition-name slot) :test #'equal)
      ('color
        (%color-button-set-color object (getf new-value :red)
                                        (getf new-value :green)
                                        (getf new-value :blue)
                                        (getf new-value :alpha)))
      (t
        (call-next-method)))
    (call-next-method)))

(defmethod initialize-instance :before ((instance color-button) &rest initargs &key &allow-other-keys)
(declare (ignore initargs))
  (setf (handle instance)
        (%new-color-button))
  (%color-button-on-changed instance (cffi:callback on-changed-callback) (cffi:null-pointer)))
