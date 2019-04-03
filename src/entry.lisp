(in-package #:ui)

(defclass base-entry (control)
  ((text
     :accessor text
     :initarg :text
     :initform ""
     :allocation :ui-instance)
   (read-only
     :accessor read-only
     :initarg :read-only
     :initform nil
     :allocation :ui-instance))
  (:metaclass control-metaclass))

(defclass entry (base-entry)
  ()
  (:metaclass control-metaclass))

(defmethod closer-mop:slot-value-using-class ((class control-metaclass) (object base-entry) (slot closer-mop:standard-effective-slot-definition))
  (if (eql :ui-instance (closer-mop:slot-definition-allocation slot))
    (switch ((closer-mop:slot-definition-name slot) :test #'equal)
      ('read-only
        (%entry-read-only object))
      ('text
        (%entry-text object))
      (t
        (call-next-method)))
    (call-next-method)))

(defmethod (setf closer-mop:slot-value-using-class) (new-value (class control-metaclass) (object base-entry) (slot closer-mop:standard-effective-slot-definition))
  (if (eql :ui-instance (closer-mop:slot-definition-allocation slot))
    (switch ((closer-mop:slot-definition-name slot) :test #'equal)
      ('read-only
        (%entry-set-read-only object new-value))
      ('text
        (%entry-set-text object new-value))
      (t
        (call-next-method)))
    (call-next-method)))

(defmethod initialize-instance :before ((instance entry) &rest initargs &key &allow-other-keys)
(declare (ignore initargs))
  (setf (handle instance)
        (%new-entry))
  (%entry-on-changed instance (cffi:callback on-changed-callback) (cffi:null-pointer)))

(defclass password-entry (base-entry)
  ()
  (:metaclass control-metaclass))

(defmethod initialize-instance :before ((instance password-entry) &rest initargs &key &allow-other-keys)
(declare (ignore initargs))
  (setf (handle instance)
        (%new-password-entry))
  (%entry-on-changed instance (cffi:callback on-changed-callback) (cffi:null-pointer)))

(defclass search-entry (base-entry)
  ()
  (:metaclass control-metaclass))

(defmethod initialize-instance :before ((instance search-entry) &rest initargs &key &allow-other-keys)
  (declare (ignore initargs))
  (setf (handle instance)
        (%new-search-entry))
  (%entry-on-changed instance (cffi:callback on-changed-callback) (cffi:null-pointer)))

(defclass multiline-base-entry (base-entry)
  ()
  (:metaclass control-metaclass))

(defclass multiline-entry (multiline-base-entry)
  ()
  (:metaclass control-metaclass))

(defmethod initialize-instance :before ((instance multiline-entry) &rest initargs &key &allow-other-keys)
  (declare (ignore initargs))
  (setf (handle instance)
        (%new-multiline-entry))
  (%multiline-entry-on-changed instance (cffi:callback on-changed-callback) (cffi:null-pointer)))

(defmethod closer-mop:slot-value-using-class ((class control-metaclass) (object multiline-base-entry) (slot closer-mop:standard-effective-slot-definition))
  (if (eql :ui-instance (closer-mop:slot-definition-allocation slot))
    (switch ((closer-mop:slot-definition-name slot) :test #'equal)
      ('read-only
        (%multiline-entry-read-only object))
      ('text
        (%multiline-entry-text object))
      (t
        (call-next-method)))
    (call-next-method)))

(defmethod (setf closer-mop:slot-value-using-class) (new-value (class control-metaclass) (object multiline-base-entry) (slot closer-mop:standard-effective-slot-definition))
  (if (eql :ui-instance (closer-mop:slot-definition-allocation slot))
    (switch ((closer-mop:slot-definition-name slot) :test #'equal)
      ('read-only
        (%multiline-entry-set-read-only object new-value))
      ('text
        (%multiline-entry-set-text object new-value))
      (t
        (call-next-method)))
    (call-next-method)))

(defclass non-wrapping-multiline-entry (multiline-base-entry)
  ()
  (:metaclass control-metaclass))

(defmethod initialize-instance :before ((instance non-wrapping-multiline-entry) &rest initargs &key &allow-other-keys)
  (declare (ignore initargs))
  (setf (handle instance)
        (%new-non-wrapping-multiline-entry))
  (%multiline-entry-on-changed instance (cffi:callback on-changed-callback) (cffi:null-pointer)))

(defmethod append-text ((object multiline-base-entry) text &rest options &key &allow-other-keys)
  (declare (ignore options))
  (%multiline-entry-append object text))
