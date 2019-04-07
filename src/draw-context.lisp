(in-package :ui)

(defclass draw-context ()
  ((handle
     :initarg :handle
     :accessor handle)))

(defmethod cffi:translate-to-foreign (object (type draw-context-type))
  (declare (ignore type))
  (handle object))

(defmethod cffi:translate-from-foreign (handle (type draw-context-type))
  (declare (ignore type))
  (make-instance 'draw-context :handle handle))

(defmethod cffi:translate-to-foreign :around (value (type draw-brush-type))
  (multiple-value-bind (pointer alloc) (call-next-method)
    (let ((stops (getf value :stops)))
      (setf (cffi:foreign-slot-value pointer '(:struct %draw-brush) :num-stops) (length stops))
      (setf (cffi:foreign-slot-value pointer '(:struct %draw-brush) :stops)
        (if stops
          (cffi:foreign-alloc '(:struct %draw-brush-gradient-stop) :initial-contents stops)
          (cffi:null-pointer))))
    (values pointer alloc)))

(defmethod cffi:free-translated-object :before (value (type draw-brush-type) param)
  (cffi:foreign-free (cffi:foreign-slot-value value '(:struct %draw-brush) :stops)))

(defun draw-fill (context path brush)
  (multiple-value-bind (b alloc)
                       (cffi:convert-to-foreign brush '(:struct %draw-brush))
    (%draw-fill context path b)
    (cffi:free-converted-object b '(:struct %draw-brush) alloc)))
