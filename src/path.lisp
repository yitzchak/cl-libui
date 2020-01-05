(in-package :ui)

(defclass path ()
  ((handle
     :accessor handle))
  (:metaclass ui-metaclass))

(defmethod initialize-instance :before ((instance path) &rest initargs &key &allow-other-keys)
  (with-slots (handle) instance
    (setf handle (%draw-new-path (getf initargs :fill-mode)))
    (trivial-garbage:finalize instance
      (lambda ()
        (%draw-free-path handle)))))

(defun new-figure (instance x y)
  (%draw-path-new-figure instance x y))

(defun new-figure-with-arc (instance x-center y-center radius start-angle sweep &optional negative)
  (%draw-path-new-figure-with-arc instance x-center y-center radius start-angle sweep negative))

(defun line-to (instance x y)
  (%draw-path-line-to instance x y))

(defun arc-to (instance x-center y-center radius start-angle sweep &optional negative)
  (%draw-path-arc-to instance x-center y-center radius start-angle sweep negative))

(defun bezier-to (instance c1x c1y c2x c2y end-x end-y)
  (%draw-path-bezier-to instance c1x c1y c2x c2y end-x end-y))

(defun close-figure (instance)
  (%draw-path-close-figure instance))

(defun add-rectangle (p x y width height)
  (%draw-path-add-rectangle p x y width height))

(defun end (instance)
  (%draw-path-end instance))
