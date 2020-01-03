(in-package #:ui)

(defclass combobox (control on-selected-slot)
  ((selected
     :accessor selected
     :initarg :selected
     :initform nil
     :allocation :ui-instance))
  (:metaclass ui-metaclass))

(defmethod closer-mop:slot-value-using-class ((class ui-metaclass) (object combobox) (slot closer-mop:standard-effective-slot-definition))
  (if (eql :ui-instance (closer-mop:slot-definition-allocation slot))
    (switch ((closer-mop:slot-definition-name slot) :test #'equal)
      ('selected
        (%combobox-selected object))
      (t
        (call-next-method)))
    (call-next-method)))

(defmethod (setf closer-mop:slot-value-using-class) (new-value (class ui-metaclass) (object combobox) (slot closer-mop:standard-effective-slot-definition))
  (if (eql :ui-instance (closer-mop:slot-definition-allocation slot))
    (switch ((closer-mop:slot-definition-name slot) :test #'equal)
      ('selected
        (%combobox-set-selected object new-value))
      (t
        (call-next-method)))
    (call-next-method)))

(defmethod initialize-instance :before ((instance combobox) &rest initargs &key &allow-other-keys)
  (setf (handle instance)
        (%new-combobox))
  (dolist (item (getf initargs :items))
    (%combobox-append instance item)))

(defmethod initialize-instance :after ((instance combobox) &rest initargs &key &allow-other-keys)
  (declare (ignore initargs))
  (%combobox-on-selected instance (cffi:callback on-selected-callback) instance))

(defmethod append-item ((object combobox) item &rest options &key &allow-other-keys)
  (declare (ignore options))
  (%combobox-append object item))

(defclass radio-buttons (control on-selected-slot)
  ((selected
     :accessor selected
     :initarg :selected
     :initform nil
     :allocation :ui-instance))
  (:metaclass ui-metaclass))

(defmethod closer-mop:slot-value-using-class ((class ui-metaclass) (object radio-buttons) (slot closer-mop:standard-effective-slot-definition))
  (if (eql :ui-instance (closer-mop:slot-definition-allocation slot))
    (switch ((closer-mop:slot-definition-name slot) :test #'equal)
      ('selected
        (%radio-buttons-selected object))
      (t
        (call-next-method)))
    (call-next-method)))

(defmethod (setf closer-mop:slot-value-using-class) (new-value (class ui-metaclass) (object radio-buttons) (slot closer-mop:standard-effective-slot-definition))
  (if (eql :ui-instance (closer-mop:slot-definition-allocation slot))
    (switch ((closer-mop:slot-definition-name slot) :test #'equal)
      ('selected
        (%radio-buttons-set-selected object new-value))
      (t
        (call-next-method)))
    (call-next-method)))

(defmethod initialize-instance :before ((instance radio-buttons) &rest initargs &key &allow-other-keys)
  (setf (handle instance)
        (%new-radio-buttons))
  (dolist (item (getf initargs :items))
    (%radio-buttons-append instance item)))

(defmethod initialize-instance :after ((instance radio-buttons) &rest initargs &key &allow-other-keys)
  (declare (ignore initargs))
  (%radio-buttons-on-selected instance (cffi:callback on-selected-callback) instance))

(defmethod append-item ((object radio-buttons) item &rest options &key &allow-other-keys)
  (declare (ignore options))
  (%radio-buttons-append object item))

(defclass editable-combobox (control on-changed-slot)
  ((text
     :accessor text
     :initarg :text
     :initform nil
     :allocation :ui-instance))
  (:metaclass ui-metaclass))

(defmethod closer-mop:slot-value-using-class ((class ui-metaclass) (object editable-combobox) (slot closer-mop:standard-effective-slot-definition))
  (if (eql :ui-instance (closer-mop:slot-definition-allocation slot))
    (switch ((closer-mop:slot-definition-name slot) :test #'equal)
      ('text
        (%editable-combobox-text object))
      (t
        (call-next-method)))
    (call-next-method)))

(defmethod (setf closer-mop:slot-value-using-class) (new-value (class ui-metaclass) (object editable-combobox) (slot closer-mop:standard-effective-slot-definition))
  (if (eql :ui-instance (closer-mop:slot-definition-allocation slot))
    (switch ((closer-mop:slot-definition-name slot) :test #'equal)
      ('text
        (%editable-combobox-set-text object new-value))
      (t
        (call-next-method)))
    (call-next-method)))

(defmethod initialize-instance :before ((instance editable-combobox) &rest initargs &key &allow-other-keys)
  (setf (handle instance)
        (%new-editable-combobox))
  (dolist (item (getf initargs :items))
    (%editable-combobox-append instance item)))

(defmethod initialize-instance :after ((instance editable-combobox) &rest initargs &key &allow-other-keys)
  (declare (ignore initargs))
  (%editable-combobox-on-changed instance (cffi:callback on-changed-callback) instance))

(defmethod append-item ((object editable-combobox) item &rest options &key &allow-other-keys)
  (declare (ignore options))
  (%editable-combobox-append object item))
