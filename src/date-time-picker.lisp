(in-package #:ui)

(defclass base-date-time-picker (control on-changed-slot)
  ((value
     :accessor value
     :initarg :value
     :initform ""
     :allocation :ui-instance))
  (:metaclass ui-metaclass))

(defmethod closer-mop:slot-value-using-class ((class ui-metaclass) (object base-date-time-picker) (slot closer-mop:standard-effective-slot-definition))
  (if (eql :ui-instance (closer-mop:slot-definition-allocation slot))
    (switch ((closer-mop:slot-definition-name slot) :test #'equal)
      ('value
        (cffi:with-foreign-object (v '(:struct %tm))
          (%date-time-picker-time object v)
          (cffi:with-foreign-slots ((sec min hour mday mon year) v (:struct %tm))
            (list :second sec
                  :minute min
                  :hour hour
                  :day mday
                  :month mon
                  :year (+ 1900 year)))))
      (t
        (call-next-method)))
    (call-next-method)))

(defmethod (setf closer-mop:slot-value-using-class) (new-value (class ui-metaclass) (object base-date-time-picker) (slot closer-mop:standard-effective-slot-definition))
  (if (eql :ui-instance (closer-mop:slot-definition-allocation slot))
    (switch ((closer-mop:slot-definition-name slot) :test #'equal)
      ('value
        (cffi:with-foreign-object (v '(:struct %tm))
          (cffi:with-foreign-slots ((sec min hour mday mon year) v (:struct %tm))
            (setf sec (getf new-value :second)
                  min (getf new-value :minute)
                  hour (getf new-value :hour)
                  mday (getf new-value :day)
                  mon (getf new-value :month)
                  year (- (getf new-value :year) 1900)))
          (%date-time-picker-set-time object new-value)))
      (t
        (call-next-method)))
    (call-next-method)))

(defclass date-time-picker (base-date-time-picker)
  ()
  (:metaclass ui-metaclass))

(defmethod initialize-instance :before ((instance date-time-picker) &rest initargs &key &allow-other-keys)
  (declare (ignore initargs))
  (setf (handle instance)
        (%new-date-time-picker)))

(defmethod initialize-instance :after ((instance date-time-picker) &rest initargs &key &allow-other-keys)
  (declare (ignore initargs))
  (%date-time-picker-on-changed instance (cffi:callback on-changed-callback) (cffi:null-pointer)))

(defclass date-picker (base-date-time-picker)
  ()
  (:metaclass ui-metaclass))

(defmethod initialize-instance :before ((instance date-picker) &rest initargs &key &allow-other-keys)
  (declare (ignore initargs))
  (setf (handle instance)
        (%new-date-picker)))

(defmethod initialize-instance :after ((instance date-picker) &rest initargs &key &allow-other-keys)
  (declare (ignore initargs))
  (%date-time-picker-on-changed instance (cffi:callback on-changed-callback) (cffi:null-pointer)))

(defclass time-picker (base-date-time-picker)
  ()
  (:metaclass ui-metaclass))

(defmethod initialize-instance :before ((instance time-picker) &rest initargs &key &allow-other-keys)
  (declare (ignore initargs))
  (setf (handle instance)
        (%new-time-picker)))

(defmethod initialize-instance :after ((instance time-picker) &rest initargs &key &allow-other-keys)
  (declare (ignore initargs))
  (%date-time-picker-on-changed instance (cffi:callback on-changed-callback) (cffi:null-pointer)))
