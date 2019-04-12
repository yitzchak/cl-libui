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

(defmethod cffi:translate-to-foreign :around (value (type type-draw-brush))
  (multiple-value-bind (pointer alloc) (call-next-method)
    (let ((stops (getf value :stops)))
      (setf (cffi:foreign-slot-value pointer '(:struct %draw-brush) :num-stops) (length stops))
      (setf (cffi:foreign-slot-value pointer '(:struct %draw-brush) :stops)
        (if stops
          (cffi:foreign-alloc '(:struct %draw-brush-gradient-stop) :initial-contents stops)
          (cffi:null-pointer))))
    (values pointer alloc)))

(defmethod cffi:free-translated-object :before (value (type type-draw-brush) param)
  (cffi:foreign-free (cffi:foreign-slot-value value '(:struct %draw-brush) :stops)))

(defmethod cffi:translate-to-foreign :around (value (type draw-stroke-params-type))
  (multiple-value-bind (pointer alloc) (call-next-method)
    (let ((dashes (getf value :dashes)))
      (setf (cffi:foreign-slot-value pointer '(:struct %draw-stroke-params) :num-dashes) (length dashes))
      (setf (cffi:foreign-slot-value pointer '(:struct %draw-stroke-params) :dashes)
        (if dashes
          (cffi:foreign-alloc :double :initial-contents dashes)
          (cffi:null-pointer))))
    (values pointer alloc)))

(defmethod cffi:free-translated-object :before (value (type draw-stroke-params-type) param)
  (cffi:foreign-free (cffi:foreign-slot-value value '(:struct %draw-stroke-params) :dashes)))

(defmethod cffi:translate-to-foreign (value (type brush-type))
  (cffi:convert-to-foreign value '(:struct %draw-brush)))

(defmethod cffi:free-translated-object (value (type brush-type) param)
  (cffi:free-converted-object value '(:struct %draw-brush) param))

(defmethod cffi:translate-to-foreign (value (type stroke-params-type))
  (cffi:convert-to-foreign value '(:struct %draw-stroke-params)))

(defmethod cffi:free-translated-object (value (type stroke-params-type) param)
  (cffi:free-converted-object value '(:struct %draw-stroke-params) param))
