(in-package :ui)

(defun plist-to-open-type-features (plist)
  (iter
    (with features = (%new-open-type-features))
    (for (k v) on plist by #'cddr)
    (for name next (string-downcase (symbol-name k)))
    (%open-type-features-add features (char-code (char name 0))
                                      (char-code (char name 1))
                                      (char-code (char name 2))
                                      (char-code (char name 3))
                                      v)
    (finally
      (return features))))

(defun plist-to-attributes (plist)
  (iter
    (for (k v) on plist by #'cddr)
    (collect
      (case k
        (:family
          (%new-family-attribute v))
      	(:size
          (%new-size-attribute v))
      	(:weight
          (%new-weight-attribute v))
      	(:italic
          (%new-italic-attribute v))
      	(:stretch
          (%new-stretch-attribute v))
      	(:color
          (%new-color-attribute (getf v :red) (getf v :green) (getf v :blue) (getf v :alpha)))
      	(:background
          (%new-background-attribute (getf v :red) (getf v :green) (getf v :blue) (getf v :alpha)))
      	(:underline
          (%new-underline-attribute v))
      	(:underline-color
          (%new-underline-color-attribute (getf v :underline) (getf v :red) (getf v :green) (getf v :blue) (getf v :alpha)))
      	(:features
          (plist-to-open-type-features v))))))

(defclass attributed-string ()
  ((handle
    :accessor handle)
   (text
     ; :initarg :text
     :allocation :ui-instance))
  (:metaclass ui-metaclass))

; (defun len (object)
;   (%attributed-string-len object))

(defmethod closer-mop:slot-value-using-class ((class ui-metaclass) (object attributed-string) (slot closer-mop:standard-effective-slot-definition))
  (if (eql :ui-instance (closer-mop:slot-definition-allocation slot))
    (switch ((closer-mop:slot-definition-name slot) :test #'equal)
      ('text
        (%attributed-string-string object))
      (t
        (call-next-method)))
    (call-next-method)))

; (defmethod (setf closer-mop:slot-value-using-class) (new-value (class ui-metaclass) (object attributed-string) (slot closer-mop:standard-effective-slot-definition))
;   (if (eql :ui-instance (closer-mop:slot-definition-allocation slot))
;     (switch ((closer-mop:slot-definition-name slot) :test #'equal)
;       ('text
;         (%attributed-string-set-text object new-value))
;       (t
;         (call-next-method)))
;     (call-next-method)))

(defmethod append-text ((object attributed-string) text &rest options &key &allow-other-keys)
  (iter
    (with start = (%attributed-string-len object))
    (with end = (+ start (length text)))
    (initially (%attributed-string-append-unattributed object text))
    (for attr in (plist-to-attributes options))
    (%attributed-string-set-attribute object attr start end)))

(defmethod initialize-instance :before ((instance attributed-string) &rest initargs &key &allow-other-keys)
  (let* ((text (getf initargs :text))
         (h (%new-attributed-string (if (stringp text) text ""))))
    (setf (handle instance) h)
    (trivial-garbage:finalize instance
      (lambda ()
        (%free-attributed-string h)))
    (when (listp text)
      (iter
        (for span in text)
        (apply #'append-text instance span)))))
