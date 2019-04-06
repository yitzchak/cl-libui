(in-package :ui)

(defclass text-layout ()
  ((handle
     :accessor handle))
  (:metaclass ui-metaclass))

(defmethod initialize-instance :before ((instance text-layout) &rest initargs &key &allow-other-keys)
  (cffi:with-foreign-object (params '(:struct %draw-text-layout-params))
    (multiple-value-bind (font alloc)
                         (cffi:convert-to-foreign (getf initargs :default-font) '(:struct %font-descriptor))
      (cffi:with-foreign-slots ((string default-font width align) params (:struct %draw-text-layout-params))
        (setf string (getf initargs :string))
        (setf default-font font)
        (setf width (getf initargs :width))
        (setf align (getf initargs :align)))
    (setf (handle instance)
          (%draw-new-text-layout params))
    (cffi:free-converted-object font '(:struct %font-descriptor) alloc))))
