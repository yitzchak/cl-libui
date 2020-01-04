(in-package :ui)

(defclass ui-metaclass (standard-class)
  ())

(defmethod closer-mop:validate-superclass
           ((class ui-metaclass) (super standard-class))
  t)

(defmethod closer-mop:compute-slots ((class ui-metaclass))
  (call-next-method))

(defmethod closer-mop:slot-boundp-using-class ((class ui-metaclass) object (slot closer-mop:standard-effective-slot-definition))
  (or (eql :ui-instance (closer-mop:slot-definition-allocation slot))
      (call-next-method)))

(defparameter *on-should-quit* nil)
(defparameter *on-init* nil)

(cffi:defcallback on-should-quit-callback (:boolean :int) ((data :pointer))
  (declare (ignore data))
  (if *on-should-quit*
    (funcall *on-should-quit*)
    t))

(cffi:defcallback main-callback :void ((data :pointer))
  (declare (ignore data))
  (when *on-init*
    (funcall *on-init*)))

(defun main ()
  (cffi:with-foreign-object (o '(:struct %init-options))
    (setf (cffi:foreign-slot-value o '(:struct %init-options) 'size) (cffi:foreign-type-size :ulong))
    (let ((err (%init o)))
      (unless (cffi:null-pointer-p err)
        (let ((err-string (cffi:foreign-string-to-lisp err)))
          (%free-init-error err)
          (error "cl-libui init error: ~A" err-string)))))
  (%on-should-quit (cffi:callback on-should-quit-callback) (cffi:null-pointer))
  (%queue-main (cffi:callback main-callback) (cffi:null-pointer))
  (%main))
