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
