(in-package #:ui)

(defclass area (control)
  ((%event-handlers
     :accessor %event-handlers))
  (:metaclass ui-metaclass))

; (defmethod closer-mop:slot-value-using-class ((class ui-metaclass) (object area) (slot closer-mop:standard-effective-slot-definition))
;   (if (eql :ui-instance (closer-mop:slot-definition-allocation slot))
;     (switch ((closer-mop:slot-definition-name slot) :test #'equal)
;       ('padded
;         (%area-padded (handle object)))
;       (t
;         (call-next-method)))
;     (call-next-method)))
;
; (defmethod (setf closer-mop:slot-value-using-class) (new-value (class ui-metaclass) (object area) (slot closer-mop:standard-effective-slot-definition))
;   (if (eql :ui-instance (closer-mop:slot-definition-allocation slot))
;     (switch ((closer-mop:slot-definition-name slot) :test #'equal)
;       ('padded
;         (%area-set-padded (handle object) new-value))
;       (t
;         (call-next-method)))
;     (call-next-method)))

(defgeneric on-draw (object params))

(defmethod on-draw (object params)
  (declare (ignore object params)))

(cffi:defcallback area-draw-callback :void ((handler :pointer) (area control-pointer) (params (:pointer (:struct %area-draw-params))))
  (declare (ignore handler))
  (on-draw area (cffi:convert-from-foreign params '(:struct %area-draw-params))))

(defgeneric on-mouse (object event))

(defmethod on-mouse (object event)
  (declare (ignore object event)))

(cffi:defcallback area-mouse-callback :void ((handler :pointer) (area control-pointer) (event (:pointer (:struct %area-mouse-event))))
  (declare (ignore handler))
  (on-mouse area (cffi:convert-from-foreign event '(:struct %area-mouse-event))))

(defgeneric on-mouse-crossed (object left))

(defmethod on-mouse-crossed (object left)
  (declare (ignore object left)))

(cffi:defcallback area-mouse-crossed-callback :void ((handler :pointer) (area control-pointer) (left (:boolean :int)))
  (declare (ignore handler))
  (on-mouse-crossed area left))

(defgeneric on-drag-broken (object))

(defmethod on-drag-broken (object)
  (declare (ignore object)))

(cffi:defcallback area-drag-broken-callback :void ((handler :pointer) (area control-pointer))
  (declare (ignore handler))
  (on-drag-broken area))

(defgeneric on-key (object event))

(defmethod on-key (object event)
  (declare (ignore object event)))

(cffi:defcallback area-key-callback (:boolean :int) ((handler :pointer) (area control-pointer) (event (:pointer (:struct %area-key-event))))
  (declare (ignore handler))
  (on-key area (cffi:convert-from-foreign event '(:struct %area-key-event))))

(defmethod initialize-instance :before ((instance area) &rest initargs &key &allow-other-keys)
  (with-accessors ((%event-handlers %event-handlers) (handle handle)) instance
    (setf %event-handlers
          (cffi:convert-to-foreign (list :draw (cffi:callback area-draw-callback)
                                         :mouse-event (cffi:callback area-mouse-callback)
                                         :mouse-crossed (cffi:callback area-mouse-crossed-callback)
                                         :drag-broken (cffi:callback area-drag-broken-callback)
                                         :key-event (cffi:callback area-key-callback))
                                   '(:struct %area-handler)))
    (setf handle
          (if-let ((width (getf initargs :width))
                   (height (getf initargs :height)))
            (%new-scrolling-area %event-handlers width height)
            (%new-area %event-handlers)))))
