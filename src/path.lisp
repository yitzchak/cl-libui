(in-package :ui)

(defclass path ()
  ((handle
     :accessor handle))
  (:metaclass ui-metaclass))

(defmethod initialize-instance :before ((instance path) &rest initargs &key &allow-other-keys)
  (setf (handle instance)
        (%draw-new-path (getf initargs :fill-mode))))

(defun add-rectangle (p x y width height)
  (%draw-path-add-rectangle p x y width height))
