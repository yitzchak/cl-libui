(in-package :ui)

(defclass matrix ()
  ((handle
     :accessor handle))
  (:metaclass ui-metaclass))

(defmethod initialize-instance :before ((instance matrix) &rest initargs &key &allow-other-keys)
  (with-slots (handle) instance
    (setf handle (cffi:foreign-alloc '(:struct %draw-matrix)))
    (%draw-matrix-set-identity instance)
    (trivial-garbage:finalize instance
      (lambda ()
        (format t "wibble~%")
        (cffi:foreign-free handle)))))


