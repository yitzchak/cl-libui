(in-package :ui)

(defclass tab (control)
  ()
  (:metaclass control-metaclass))

(defmethod initialize-instance :before ((instance tab) &rest initargs &key &allow-other-keys)
  (declare (ignore initargs))
  (setf (handle instance)
        (%new-tab)))

(defmethod append-child ((object tab) child &rest options &key &allow-other-keys)
  (%tab-append (handle object) (getf options :title) (handle child)))
