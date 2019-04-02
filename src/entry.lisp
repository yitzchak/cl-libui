(in-package #:ui)

(defgeneric on-changed (control)
  (:documentation "Called on change signal."))

(defmethod on-changed (control)
  (declare (ignore control)))

(cffi:defcallback on-changed-callback (:boolean :int) ((control control-type) (data :pointer))
  (declare (ignore data))
  (on-changed control))

(defclass entry (control)
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

(defmethod closer-mop:slot-value-using-class ((class control-metaclass) (object entry) (slot closer-mop:standard-effective-slot-definition))
  (if (eql :ui-instance (closer-mop:slot-definition-allocation slot))
    (switch ((closer-mop:slot-definition-name slot) :test #'equal)
      ('read-only
        (%entry-read-only (handle object)))
      ('text
        (%entry-text (handle object)))
      (t
        (call-next-method)))
    (call-next-method)))

(defmethod (setf closer-mop:slot-value-using-class) (new-value (class control-metaclass) (object entry) (slot closer-mop:standard-effective-slot-definition))
  (if (eql :ui-instance (closer-mop:slot-definition-allocation slot))
    (switch ((closer-mop:slot-definition-name slot) :test #'equal)
      ('read-only
        (%entry-set-read-only (handle object) new-value))
      ('text
        (%entry-set-text (handle object) new-value))
      (t
        (call-next-method)))
    (call-next-method)))

(defmethod initialize-instance :before ((instance entry) &rest initargs &key &allow-other-keys)
(declare (ignore initargs))
  (setf (handle instance)
        (%new-entry))
  (%entry-on-changed instance (cffi:callback on-changed-callback) (cffi:null-pointer)))

(defclass password-entry (entry)
  ()
  (:metaclass control-metaclass))

(defmethod initialize-instance :before ((instance password-entry) &rest initargs &key &allow-other-keys)
(declare (ignore initargs))
  (setf (handle instance)
        (%new-password-entry))
  (%entry-on-changed instance (cffi:callback on-changed-callback) (cffi:null-pointer)))

(defclass search-entry (entry)
  ()
  (:metaclass control-metaclass))

(defmethod initialize-instance :before ((instance search-entry) &rest initargs &key &allow-other-keys)
  (declare (ignore initargs))
  (setf (handle instance)
        (%new-search-entry))
  (%entry-on-changed instance (cffi:callback on-changed-callback) (cffi:null-pointer)))

(defclass multiline-entry (entry)
  ()
  (:metaclass control-metaclass))

(defmethod initialize-instance :before ((instance multiline-entry) &rest initargs &key &allow-other-keys)
  (declare (ignore initargs))
  (setf (handle instance)
        (%new-multiline-entry))
  (%multiline-entry-on-changed instance (cffi:callback on-changed-callback) (cffi:null-pointer)))

(defmethod closer-mop:slot-value-using-class ((class control-metaclass) (object multiline-entry) (slot closer-mop:standard-effective-slot-definition))
  (if (eql :ui-instance (closer-mop:slot-definition-allocation slot))
    (switch ((closer-mop:slot-definition-name slot) :test #'equal)
      ('read-only
        (%multiline-entry-read-only (handle object)))
      ('text
        (%multiline-entry-text (handle object)))
      (t
        (call-next-method)))
    (call-next-method)))

(defmethod (setf closer-mop:slot-value-using-class) (new-value (class control-metaclass) (object multiline-entry) (slot closer-mop:standard-effective-slot-definition))
  (if (eql :ui-instance (closer-mop:slot-definition-allocation slot))
    (switch ((closer-mop:slot-definition-name slot) :test #'equal)
      ('read-only
        (%multiline-entry-set-read-only (handle object) new-value))
      ('text
        (%multiline-entry-set-text (handle object) new-value))
      (t
        (call-next-method)))
    (call-next-method)))

(defclass non-wrapping-multiline-entry (multiline-entry)
  ()
  (:metaclass control-metaclass))

(defmethod initialize-instance :before ((instance non-wrapping-multiline-entry) &rest initargs &key &allow-other-keys)
  (declare (ignore initargs))
  (setf (handle instance)
        (%new-non-wrapping-multiline-entry))
  (%multiline-entry-on-changed instance (cffi:callback on-changed-callback) (cffi:null-pointer)))
