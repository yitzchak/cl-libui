(in-package #:ui)

(include "ui.h")

(ctype size-t "size_t")

(constant (default-miter-limit "uiDrawDefaultMiterLimit") :type double-float)

(cenum (%for-each :base-type :unsigned-int)
	((:continue "uiForEachContinue"))
	((:stop "uiForEachStop")))

(cenum (%attribute-type :base-type :unsigned-int)
  ((:family "uiAttributeTypeFamily"))
  ((:size "uiAttributeTypeSize"))
  ((:weight "uiAttributeTypeWeight"))
  ((:italic "uiAttributeTypeItalic"))
  ((:stretch "uiAttributeTypeStretch"))
  ((:color "uiAttributeTypeColor"))
  ((:background "uiAttributeTypeBackground"))
  ((:underline "uiAttributeTypeUnderline"))
  ((:underline-color "uiAttributeTypeUnderlineColor"))
  ((:features "uiAttributeTypeFeatures")))
