(ql:quickload :cl-libui)

(defparameter *window* nil)
(defparameter *histogram* nil)
(defparameter *datapoints* nil)
(defparameter *color-button* nil)
(defparameter *current-point* nil)

; some metrics
(defparameter +margin+ 20)
(defparameter +point-radius+ 6)

(defparameter +dodger-blue+ '(:red 0.117647059 :green 0.564705882 :blue 1.0 :alpha 1.0))
(defparameter +solid-white+ '(:type :solid :red 1.0 :green 1.0 :blue 1.0 :alpha 1.0))
(defparameter +solid-black+ '(:type :solid :red 0.0 :green 0.0 :blue 0.0 :alpha 1.0))
(defparameter +stroke+ (list :cap :flat :join :miter :thickness 2 :miter-limit ui:default-miter-limit))

(defun on-changed (instance)
  (declare (ignore instance))
  (ui::%area-queue-redraw-all *histogram*))

(defun on-closing (instance)
  (declare (ignore instance))
  (ui::%quit)
  t)

(defun point-locations (width height)
  (reverse (reduce
    (lambda (previous current)
      (cons
        (list (* width (/ (length previous) (- (length *datapoints*) 1d0))) (* height (- 1d0 (* 0.01d0 (ui:value current)))))
        previous))
    *datapoints*
    :initial-value nil)))

(defun construct-graph (width height extend)
  (let ((points (point-locations width height))
        (path (make-instance 'ui:path :fill-mode :winding)))
    (ui:new-figure path (caar points) (cadar points))
    (dolist (point (cdr points))
      (ui:line-to path (car point) (cadr point)))
    (when extend
      (ui:line-to path width height)
      (ui:line-to path 0 height)
      (ui:close-figure path))
    (ui:end path)
    path))

(defun draw-background (context width height)
  (let ((path (make-instance 'ui:path :fill-mode :winding)))
    (ui:add-rectangle path 0.0 0.0 width height)
    (ui:end path)
    (ui::%draw-fill context path +solid-white+)))

(defun draw-axes (context width height)
  (let ((path (make-instance 'ui:path :fill-mode :winding)))
    (ui:new-figure path 0 0)
    (ui:line-to path 0 height)
    (ui:line-to path width height)
    (ui:end path)
    (ui::%draw-stroke context path +solid-black+ +stroke+)))

(defun construct-current-point (width height)
  (let ((point (nth *current-point* (point-locations width height)))
        (path (make-instance 'ui:path :fill-mode :winding)))
    (ui:new-figure-with-arc path (car point) (cadr point) +point-radius+ 0 (* 2 pi))
    (ui:close-figure path)
    (ui:end path)
    path))

(defun on-draw (object params)
  (declare (ignore object))
  (let* ((context (getf params :context))
         (width (getf params :area-width))
         (height (getf params :area-height))
         (graph-width (- width (* 2 +margin+)))
         (graph-height (- height (* 2 +margin+)))
         (m (make-instance 'ui:matrix))
         (color (ui:color *color-button*)))
    (draw-background context width height)
    (ui::%draw-matrix-translate m +margin+ +margin+)
    (ui::%draw-transform context m)
    (draw-axes context graph-width graph-height)
    (ui::%draw-fill context (construct-graph graph-width graph-height t)
      (list :type :solid :red (getf color :red) :green (getf color :green)
            :green (getf color :green) :blue (getf color :blue)
            :alpha (* 0.5d0 (getf color :alpha))))
    (ui::%draw-stroke context (construct-graph graph-width graph-height nil)
      (append '(:type :solid) color)
      +stroke+)
    (when *current-point*
      (ui::%draw-fill context (construct-current-point graph-width graph-height)
        (append '(:type :solid) color)))))

(defun on-mouse (object params)
  (declare (ignore object))
  (let* ((width (getf params :area-width))
         (height (getf params :area-height))
         (x (- (getf params :x) +margin+))
         (y (- (getf params :y) +margin+))
         (graph-width (- width (* 2 +margin+)))
         (graph-height (- height (* 2 +margin+)))
         (ind
          (position-if
            (lambda (point)
              (>= +point-radius+ (sqrt (+ (expt (- (car point) x) 2) (expt (- (cadr point) y) 2)))))
            (point-locations graph-width graph-height))))
    (when (not (equalp ind *current-point*))
      (setq *current-point* ind)
      (ui::%area-queue-redraw-all *histogram*))))

(defun on-init ()
  (let ((hbox (make-instance 'ui:horizontal-box :padded t))
        (vbox (make-instance 'ui:vertical-box :padded t)))
    (setq *window*
      (make-instance 'ui:window :title "libui Histogram Example"
                                :width 640 :height 480
                                :has-menubar t :visible t :margined t
                                :on-closing #'on-closing :child hbox))
    (ui:append-child hbox vbox)

    (dotimes (i 10)
      (let ((sb (make-instance 'ui:spinbox :min 0 :max 100 :on-changed #'on-changed :value (random 100))))
        (ui:append-child vbox sb)
        (push sb *datapoints*)))
    (setf *datapoints* (reverse *datapoints*))

    (setq *color-button* (make-instance 'ui:color-button :color +dodger-blue+ :on-changed #'on-changed))
    (ui:append-child vbox *color-button*)
    (setq *histogram* (make-instance 'ui:area :on-draw #'on-draw :on-mouse #'on-mouse))
    (ui:append-child hbox *histogram* :stretch t)))

(setq ui:*on-init* #'on-init)

(ui:main)
