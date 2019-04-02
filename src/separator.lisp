(in-package #:ui)

(defclass horizontal-separator (control)
  ()
  (:metaclass control-metaclass))

(defmethod initialize-instance :before ((instance horizontal-separator) &rest initargs &key &allow-other-keys)
  (declare (ignore initargs))
  (setf (handle instance) (%new-horizontal-separator)))

(defclass vertical-separator (control)
  ()
  (:metaclass control-metaclass))

(defmethod initialize-instance :before ((instance vertical-separator) &rest initargs &key &allow-other-keys)
  (declare (ignore initargs))
  (setf (handle instance) (%new-vertical-separator)))
