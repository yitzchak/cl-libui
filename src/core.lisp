(in-package :ui)

(defgeneric on-should-quit ()
  (:documentation "Called to confirm quit signal."))

(defmethod on-should-quit ()
  t)

(cffi:defcallback on-should-quit-callback (:boolean :int) ((data :pointer))
  (declare (ignore data))
  (on-should-quit))

(defgeneric on-init ()
  (:documentation "Called after init is completed"))

(defmethod on-init ())

(cffi:defcallback main-callback :void ((data :pointer))
  (declare (ignore data))
  (on-init))

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
