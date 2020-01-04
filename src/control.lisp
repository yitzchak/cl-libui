(in-package :ui)

(defclass control ()
  ((handle
     :accessor handle
     :initarg :handle)
   (id
     :accessor id)
   (enabled
     :accessor enabled
     :initarg :enabled
     :allocation :ui-instance)
   (visible
     :accessor visible
     :initarg :visible
     :allocation :ui-instance))
  (:metaclass ui-metaclass))

(defparameter *controls* (make-hash-table))

(defmethod initialize-instance :before ((instance control) &rest initargs &key &allow-other-keys)
  (declare (ignore initargs))
  (with-slots (id) instance
    (setf id (hash-table-count *controls*))
    (setf (gethash id *controls*) instance)))

(defmethod cffi:translate-to-foreign (value (type control-pointer))
  (declare (ignore type))
  (handle value))

(defmethod cffi:translate-to-foreign (value (type control-id))
  (declare (ignore type))
  (cffi:make-pointer (id value)))

(defmethod cffi:translate-from-foreign (value (type control-id))
  (declare (ignore type))
  (gethash (cffi:pointer-address value) *controls*))

(defmethod closer-mop:slot-value-using-class ((class ui-metaclass) (object control) (slot closer-mop:standard-effective-slot-definition))
  (if (eql :ui-instance (closer-mop:slot-definition-allocation slot))
    (switch ((closer-mop:slot-definition-name slot) :test #'equal)
      ('enabled
        (%control-enabled object))
      ('visible
        (%control-visible object))
      (t
        (call-next-method)))
    (call-next-method)))

(defmethod (setf closer-mop:slot-value-using-class) (new-value (class ui-metaclass) (object control) (slot closer-mop:standard-effective-slot-definition))
  (if (eql :ui-instance (closer-mop:slot-definition-allocation slot))
    (switch ((closer-mop:slot-definition-name slot) :test #'equal)
      ('enabled
        (if new-value
          (%control-enable object)
          (%control-disable object)))
      ('visible
        (if new-value
          (%control-show object)
          (%control-hide object)))
      (t
        (call-next-method)))
    (call-next-method)))

(defgeneric append-child (object child &rest options &key &allow-other-keys))

(defgeneric insert-child (object child &rest options &key &allow-other-keys))

(defgeneric append-text (object item &rest options &key &allow-other-keys))

(defgeneric append-item (object item &rest options &key &allow-other-keys))

(defclass on-changed-slot ()
  ((on-changed
     :accessor on-changed
     :initarg :on-changed
     :initform nil)))

(defun call-on-changed (instance &rest args)
  (when instance
    (with-slots (on-changed) instance
      (when on-changed
        (apply on-changed instance args)))))

(cffi:defcallback on-changed-callback :void ((pointer :pointer) (instance control-id))
  (declare (ignore pointer))
  (call-on-changed instance))

(defclass on-clicked-slot ()
  ((on-clicked
     :accessor on-clicked
     :initarg :on-clicked
     :initform nil)))

(defun call-on-clicked (instance &rest args)
  (when instance
    (with-slots (on-clicked) instance
      (when on-clicked
        (apply on-clicked instance args)))))

(cffi:defcallback on-clicked-callback (:boolean :int) ((pointer :pointer) (instance control-id))
  (declare (ignore pointer))
  (call-on-clicked instance))

(defclass on-closing-slot ()
  ((on-closing
     :accessor on-closing
     :initarg :on-closing
     :initform nil)))

(defun call-on-closing (instance &rest args)
  (if instance
    (with-slots (on-closing) instance
      (if on-closing
        (apply on-closing instance args)
        t))
    t))

(cffi:defcallback on-closing-callback (:boolean :int) ((pointer :pointer) (instance control-id))
  (declare (ignore pointer))
  (call-on-closing instance))

(defclass on-content-size-changed-slot ()
  ((on-content-size-changed
     :accessor on-content-size-changed
     :initarg :on-content-size-changed
     :initform nil)))

(defun call-on-content-size-changed (instance &rest args)
  (when instance
    (with-slots (on-content-size-changed) instance
      (when on-content-size-changed
        (apply on-content-size-changed instance args)))))

(cffi:defcallback on-content-size-changed-callback :void ((pointer :pointer) (instance control-id))
  (declare (ignore pointer))
  (call-on-content-size-changed instance))

(defclass on-selected-slot ()
  ((on-selected
     :accessor on-selected
     :initarg :on-selected
     :initform nil)))

(defun call-on-selected (instance &rest args)
  (when instance
    (with-slots (on-selected) instance
      (when on-selected
        (apply on-selected instance args)))))

(cffi:defcallback on-selected-callback :void ((pointer :pointer) (instance control-id))
  (declare (ignore pointer))
  (call-on-selected instance))

(defclass on-toggled-slot ()
  ((on-toggled
     :accessor on-toggled
     :initarg :on-toggled
     :initform nil)))

(defun call-on-toggled (instance &rest args)
  (when instance
    (with-slots (on-toggled) instance
      (when on-toggled
        (apply on-toggled instance args)))))

(cffi:defcallback on-toggled-callback :void ((pointer :pointer) (instance control-id))
  (declare (ignore pointer))
  (call-on-toggled instance))




