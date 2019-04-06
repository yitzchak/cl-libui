(in-package :ui)

(defclass tab (control)
  ()
  (:metaclass ui-metaclass))

(defmethod initialize-instance :before ((instance tab) &rest initargs &key &allow-other-keys)
  (declare (ignore initargs))
  (setf (handle instance)
        (%new-tab)))

(defmethod append-child ((object tab) child &rest options &key &allow-other-keys)
  (%tab-append object (getf options :title) child)
  (when (getf options :margined)
    (%tab-set-margined object (1- (%tab-num-pages object)) t)))
