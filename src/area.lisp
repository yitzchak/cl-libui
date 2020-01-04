(in-package #:ui)

(defclass area (control on-draw-slot on-mouse-slot on-mouse-crossed-slot on-drag-broken-slot on-key-slot)
  ((%event-handlers
     :accessor %event-handlers))
  (:metaclass ui-metaclass))

(cffi:defcallback area-draw-callback :void ((handler :pointer) (area control-pointer) (params (:pointer (:struct %area-draw-params))))
  (declare (ignore handler))
  (call-on-draw area (cffi:convert-from-foreign params '(:struct %area-draw-params))))

(cffi:defcallback area-mouse-callback :void ((handler :pointer) (area control-pointer) (event (:pointer (:struct %area-mouse-event))))
  (declare (ignore handler))
  (call-on-mouse area (cffi:convert-from-foreign event '(:struct %area-mouse-event))))

(cffi:defcallback area-mouse-crossed-callback :void ((handler :pointer) (area control-pointer) (left (:boolean :int)))
  (declare (ignore handler))
  (call-on-mouse-crossed area left))

(cffi:defcallback area-drag-broken-callback :void ((handler :pointer) (area control-pointer))
  (declare (ignore handler))
  (call-on-drag-broken area))

(cffi:defcallback area-key-callback (:boolean :int) ((handler :pointer) (area control-pointer) (event (:pointer (:struct %area-key-event))))
  (declare (ignore handler))
  (call-on-key area (cffi:convert-from-foreign event '(:struct %area-key-event))))

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
