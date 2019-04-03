(in-package #:ui)

(cffi:define-foreign-library libui
  (:darwin "libui.dylib")
  (:unix "libui.so")
  (t (:default "libui.dll")))

(cffi:use-foreign-library libui)

(cffi:define-foreign-type control-type ()
  ()
  (:actual-type :pointer))

(cffi:define-parse-method control-type ()
  (make-instance 'control-type))

(cl:defmacro defanonenum (cl:&body enums)
   "Converts anonymous enums to defconstants."
  `(cl:progn ,@(cl:loop for value in enums
                        for index = 0 then (cl:1+ index)
                        when (cl:listp value) do (cl:setf index (cl:second value)
                                                          value (cl:first value))
                        collect `(cl:defconstant ,value ,index))))

(cl:eval-when (:compile-toplevel :load-toplevel)
  (cl:unless (cl:fboundp 'swig-lispify)
    (cl:defun swig-lispify (name flag cl:&optional (package cl:*package*))
      (cl:labels ((helper (lst last rest cl:&aux (c (cl:car lst)))
                    (cl:cond
                      ((cl:null lst)
                       rest)
                      ((cl:upper-case-p c)
                       (helper (cl:cdr lst) 'upper
                               (cl:case last
                                 ((lower digit) (cl:list* c #\- rest))
                                 (cl:t (cl:cons c rest)))))
                      ((cl:lower-case-p c)
                       (helper (cl:cdr lst) 'lower (cl:cons (cl:char-upcase c) rest)))
                      ((cl:digit-char-p c)
                       (helper (cl:cdr lst) 'digit
                               (cl:case last
                                 ((upper lower) (cl:list* c #\- rest))
                                 (cl:t (cl:cons c rest)))))
                      ((cl:char-equal c #\_)
                       (helper (cl:cdr lst) '_ (cl:cons #\- rest)))
                      (cl:t
                       (cl:error "Invalid character: ~A" c)))))
        (cl:let ((fix (cl:case flag
                        ((constant enumvalue) "+")
                        (variable "*")
                        (cl:t ""))))
          (cl:intern
           (cl:concatenate
            'cl:string
            fix
            (cl:nreverse (helper (cl:concatenate 'cl:list name) cl:nil cl:nil))
            fix)
           package))))))

;;;SWIG wrapper code ends here


(defanonenum
	uiForEachContinue
	uiForEachStop)

(cffi:defcstruct %init-options
	(size :ulong))

(cffi:defcfun ("uiInit" %init) :pointer
  (options (:pointer (:struct %init-options))))

(cffi:defcfun ("uiUninit" %uninit) :void)

(cffi:defcfun ("uiFreeInitError" %free-init-error) :void
  (err :pointer))

(cffi:defcfun ("uiMain" %main) :void)

(cffi:defcfun ("uiMainSteps" %main-steps) :void)

(cffi:defcfun ("uiMainStep" %main-step) :int
  (wait :int))

(cffi:defcfun ("uiQuit" %quit) :void)

(cffi:defcfun ("uiQueueMain" %queue-main) :void
  (f :pointer)
  (data :pointer))

(cffi:defcfun ("uiTimer" %timer) :void
  (milliseconds :int)
  (f :pointer)
  (data :pointer))

(cffi:defcfun ("uiOnShouldQuit" %on-should-quit) :void
  (f :pointer)
  (data :pointer))

(cffi:defcfun ("uiFreeText" %free-text) :void
  (text :pointer))

; (cffi:defcstruct %control
; 	(Signature :pointer)
; 	(OSSignature :pointer)
; 	(TypeSignature :pointer)
; 	(Destroy :pointer)
; 	(Handle :pointer)
; 	(Parent :pointer)
; 	(SetParent :pointer)
; 	(Toplevel :pointer)
; 	(Visible :pointer)
; 	(Show :pointer)
; 	(Hide :pointer)
; 	(Enabled :pointer)
; 	(Enable :pointer)
; 	(Disable :pointer))

(cffi:defcfun ("uiControlDestroy" %control-destroy) :void
  (arg0 control-type))

; (cffi:defcfun ("uiControlHandle" %control-handle) :pointer
;   (arg0 :pointer))

(cffi:defcfun ("uiControlParent" %control-parent) :pointer
  (arg0 control-type))

(cffi:defcfun ("uiControlSetParent" %control-set-parent) :void
  (arg0 control-type)
  (arg1 control-type))

(cffi:defcfun ("uiControlToplevel" %control-toplevel) (:boolean :int)
  (arg0 control-type))

(cffi:defcfun ("uiControlVisible" %control-visible) (:boolean :int)
  (arg0 control-type))

(cffi:defcfun ("uiControlShow" %control-show) :void
  (arg0 control-type))

(cffi:defcfun ("uiControlHide" %control-hide) :void
  (arg0 control-type))

(cffi:defcfun ("uiControlEnabled" %control-enabled) (:boolean :int)
  (arg0 control-type))

(cffi:defcfun ("uiControlEnable" %control-enable) :void
  (arg0 control-type))

(cffi:defcfun ("uiControlDisable" %control-disable) :void
  (arg0 control-type))

; (cffi:defcfun ("uiAllocControl" %alloc-control) :pointer
;   (n :pointer)
;   (OSsig :pointer)
;   (typesig :pointer)
;   (typenamestr :string))
;
; (cffi:defcfun ("uiFreeControl" %free-control) :void
;   (arg0 control-type))

; (cffi:defcfun ("uiControlVerifySetParent" %control-verify-set-parent) :void
;   (arg0 :pointer)
;   (arg1 :pointer))

(cffi:defcfun ("uiControlEnabledToUser" %control-enabled-to-user) (:boolean :int)
  (arg0 :pointer))

; (cffi:defcfun ("uiUserBugCannotSetParentOnToplevel" %user-bug-cannot-set-parent-on-toplevel) :void
;   (type :string))

(cffi:defcfun ("uiWindowTitle" %window-title) :string
  (w control-type))

(cffi:defcfun ("uiWindowSetTitle" %window-set-title) :void
  (w control-type)
  (title :string))

(cffi:defcfun ("uiWindowContentSize" %window-content-size) :void
  (w control-type)
  (width (:pointer :int))
  (height (:pointer :int)))

(cffi:defcfun ("uiWindowSetContentSize" %window-set-content-size) :void
  (w control-type)
  (width :int)
  (height :int))

(cffi:defcfun ("uiWindowFullscreen" %window-fullscreen) (:boolean :int)
  (w control-type))

(cffi:defcfun ("uiWindowSetFullscreen" %window-set-fullscreen) :void
  (w control-type)
  (fullscreen (:boolean :int)))

(cffi:defcfun ("uiWindowOnContentSizeChanged" %window-on-content-size-changed) :void
  (w control-type)
  (f :pointer)
  (data :pointer))

(cffi:defcfun ("uiWindowOnClosing" %window-on-closing) :void
  (w control-type)
  (f :pointer)
  (data :pointer))

(cffi:defcfun ("uiWindowBorderless" %window-borderless) (:boolean :int)
  (w control-type))

(cffi:defcfun ("uiWindowSetBorderless" %window-set-borderless) :void
  (w control-type)
  (borderless (:boolean :int)))

(cffi:defcfun ("uiWindowSetChild" %window-set-child) :void
  (w control-type)
  (child control-type))

(cffi:defcfun ("uiWindowMargined" %window-margined) (:boolean :int)
  (w control-type))

(cffi:defcfun ("uiWindowSetMargined" %window-set-margined) :void
  (w control-type)
  (margined (:boolean :int)))

(cffi:defcfun ("uiNewWindow" %new-window) :pointer
  (title :string)
  (width :int)
  (height :int)
  (hasMenubar (:boolean :int)))

(cffi:defcfun ("uiButtonText" %button-text) :string
  (b control-type))

(cffi:defcfun ("uiButtonSetText" %button-set-text) :void
  (b control-type)
  (text :string))

(cffi:defcfun ("uiButtonOnClicked" %button-on-clicked) :void
  (b control-type)
  (f :pointer)
  (data :pointer))

(cffi:defcfun ("uiNewButton" %new-button) :pointer
  (text :string))

(cffi:defcfun ("uiBoxAppend" %box-append) :void
  (b control-type)
  (child :pointer)
  (stretchy (:boolean :int)))

(cffi:defcfun ("uiBoxDelete" %box-delete) :void
  (b control-type)
  (index :int))

(cffi:defcfun ("uiBoxPadded" %box-padded) (:boolean :int)
  (b control-type))

(cffi:defcfun ("uiBoxSetPadded" %box-set-padded) :void
  (b control-type)
  (padded (:boolean :int)))

(cffi:defcfun ("uiNewHorizontalBox" %new-horizontal-box) :pointer)

(cffi:defcfun ("uiNewVerticalBox" %new-vertical-box) :pointer)

(cffi:defcfun ("uiCheckboxText" %checkbox-text) :string
  (c control-type))

(cffi:defcfun ("uiCheckboxSetText" %checkbox-set-text) :void
  (c control-type)
  (text :string))

(cffi:defcfun ("uiCheckboxOnToggled" %checkbox-on-toggled) :void
  (c control-type)
  (f :pointer)
  (data :pointer))

(cffi:defcfun ("uiCheckboxChecked" %checkbox-checked) (:boolean :int)
  (c control-type))

(cffi:defcfun ("uiCheckboxSetChecked" %checkbox-set-checked) :void
  (c control-type)
  (checked (:boolean :int)))

(cffi:defcfun ("uiNewCheckbox" %new-checkbox) :pointer
  (text :string))

(cffi:defcfun ("uiEntryText" %entry-text) :string
  (e control-type))

(cffi:defcfun ("uiEntrySetText" %entry-set-text) :void
  (e control-type)
  (text :string))

(cffi:defcfun ("uiEntryOnChanged" %entry-on-changed) :void
  (e control-type)
  (f :pointer)
  (data :pointer))

(cffi:defcfun ("uiEntryReadOnly" %entry-read-only) (:boolean :int)
  (e control-type))

(cffi:defcfun ("uiEntrySetReadOnly" %entry-set-read-only) :void
  (e control-type)
  (readonly (:boolean :int)))

(cffi:defcfun ("uiNewEntry" %new-entry) :pointer)

(cffi:defcfun ("uiNewPasswordEntry" %new-password-entry) :pointer)

(cffi:defcfun ("uiNewSearchEntry" %new-search-entry) :pointer)

(cffi:defcfun ("uiLabelText" %label-text) :string
  (l control-type))

(cffi:defcfun ("uiLabelSetText" %label-set-text) :void
  (l control-type)
  (text :string))

(cffi:defcfun ("uiNewLabel" %new-label) :pointer
  (text :string))

(cffi:defcfun ("uiTabAppend" %tab-append) :void
  (t_arg0 control-type)
  (name :string)
  (c control-type))

(cffi:defcfun ("uiTabInsertAt" %tab-insert-at) :void
  (t_arg0 control-type)
  (name :string)
  (before :int)
  (c control-type))

(cffi:defcfun ("uiTabDelete" %tab-delete) :void
  (t_arg0 control-type)
  (index :int))

(cffi:defcfun ("uiTabNumPages" %tab-num-pages) :int
  (t_arg0 control-type))

(cffi:defcfun ("uiTabMargined" %tab-margined) (:boolean :int)
  (t_arg0 control-type)
  (page :int))

(cffi:defcfun ("uiTabSetMargined" %tab-set-margined) :void
  (t_arg0 control-type)
  (page :int)
  (margined (:boolean :int)))

(cffi:defcfun ("uiNewTab" %new-tab) :pointer)

(cffi:defcfun ("uiGroupTitle" %group-title) :string
  (g control-type))

(cffi:defcfun ("uiGroupSetTitle" %group-set-title) :void
  (g control-type)
  (title :string))

(cffi:defcfun ("uiGroupSetChild" %group-set-child) :void
  (g control-type)
  (c control-type))

(cffi:defcfun ("uiGroupMargined" %group-margined) (:boolean :int)
  (g control-type))

(cffi:defcfun ("uiGroupSetMargined" %group-set-margined) :void
  (g control-type)
  (margined (:boolean :int)))

(cffi:defcfun ("uiNewGroup" %new-group) :pointer
  (title :string))

(cffi:defcfun ("uiSpinboxValue" %spinbox-value) :int
  (s control-type))

(cffi:defcfun ("uiSpinboxSetValue" %spinbox-set-value) :void
  (s control-type)
  (value :int))

(cffi:defcfun ("uiSpinboxOnChanged" %spinbox-on-changed) :void
  (s control-type)
  (f :pointer)
  (data :pointer))

(cffi:defcfun ("uiNewSpinbox" %new-spinbox) :pointer
  (min :int)
  (max :int))

(cffi:defcfun ("uiSliderValue" %slider-value) :int
  (s control-type))

(cffi:defcfun ("uiSliderSetValue" %slider-set-value) :void
  (s control-type)
  (value :int))

(cffi:defcfun ("uiSliderOnChanged" %slider-on-changed) :void
  (s control-type)
  (f :pointer)
  (data :pointer))

(cffi:defcfun ("uiNewSlider" %new-slider) :pointer
  (min :int)
  (max :int))

(cffi:defcfun ("uiProgressBarValue" %progress-bar-value) :int
  (p control-type))

(cffi:defcfun ("uiProgressBarSetValue" %progress-bar-set-value) :void
  (p control-type)
  (n :int))

(cffi:defcfun ("uiNewProgressBar" %new-progress-bar) :pointer)

(cffi:defcfun ("uiNewHorizontalSeparator" %new-horizontal-separator) :pointer)

(cffi:defcfun ("uiNewVerticalSeparator" %new-vertical-separator) :pointer)

(cffi:defcfun ("uiComboboxAppend" %combobox-append) :void
  (c control-type)
  (text :string))

(cffi:defcfun ("uiComboboxSelected" %combobox-selected) :int
  (c control-type))

(cffi:defcfun ("uiComboboxSetSelected" %combobox-set-selected) :void
  (c control-type)
  (n :int))

(cffi:defcfun ("uiComboboxOnSelected" %combobox-on-selected) :void
  (c control-type)
  (f :pointer)
  (data :pointer))

(cffi:defcfun ("uiNewCombobox" %new-combobox) :pointer)

(cffi:defcfun ("uiEditableComboboxAppend" %editable-combobox-append) :void
  (c control-type)
  (text :string))

(cffi:defcfun ("uiEditableComboboxText" %editable-combobox-text) :string
  (c control-type))

(cffi:defcfun ("uiEditableComboboxSetText" %editable-combobox-set-text) :void
  (c control-type)
  (text :string))

(cffi:defcfun ("uiEditableComboboxOnChanged" %editable-combobox-on-changed) :void
  (c control-type)
  (f :pointer)
  (data :pointer))

(cffi:defcfun ("uiNewEditableCombobox" %new-editable-combobox) :pointer)

(cffi:defcfun ("uiRadioButtonsAppend" %radio-buttons-append) :void
  (r control-type)
  (text :string))

(cffi:defcfun ("uiRadioButtonsSelected" %radio-buttons-selected) :int
  (r control-type))

(cffi:defcfun ("uiRadioButtonsSetSelected" %radio-buttons-set-selected) :void
  (r control-type)
  (n :int))

(cffi:defcfun ("uiRadioButtonsOnSelected" %radio-buttons-on-selected) :void
  (r control-type)
  (f :pointer)
  (data :pointer))

(cffi:defcfun ("uiNewRadioButtons" %new-radio-buttons) :pointer)

(cffi:defcfun ("uiDateTimePickerTime" %date-time-pickerTime) :void
  (d control-type)
  (time :pointer))

(cffi:defcfun ("uiDateTimePickerSetTime" %date-time-picker-setTime) :void
  (d control-type)
  (time :pointer))

(cffi:defcfun ("uiDateTimePickerOnChanged" %date-time-picker-on-changed) :void
  (d control-type)
  (f :pointer)
  (data :pointer))

(cffi:defcfun ("uiNewDateTimePicker" %new-date-time-picker) :pointer)

(cffi:defcfun ("uiNewDatePicker" %new-date-picker) :pointer)

(cffi:defcfun ("uiNewTimePicker" %new-time-picker) :pointer)

(cffi:defcfun ("uiMultilineEntryText" %multiline-entry-text) :string
  (e control-type))

(cffi:defcfun ("uiMultilineEntrySetText" %multiline-entry-set-text) :void
  (e control-type)
  (text :string))

(cffi:defcfun ("uiMultilineEntryAppend" %multiline-entry-append) :void
  (e control-type)
  (text :string))

(cffi:defcfun ("uiMultilineEntryOnChanged" %multiline-entry-on-changed) :void
  (e control-type)
  (f :pointer)
  (data :pointer))

(cffi:defcfun ("uiMultilineEntryReadOnly" %multiline-entry-read-only) (:boolean :int)
  (e control-type))

(cffi:defcfun ("uiMultilineEntrySetReadOnly" %multiline-entry-set-read-only) :void
  (e control-type)
  (readonly (:boolean :int)))

(cffi:defcfun ("uiNewMultilineEntry" %new-multiline-entry) :pointer)

(cffi:defcfun ("uiNewNonWrappingMultilineEntry" %new-non-wrapping-multiline-entry) :pointer)

(cffi:defcfun ("uiMenuItemEnable" %menu-item-enable) :void
  (m control-type))

(cffi:defcfun ("uiMenuItemDisable" %menu-item-disable) :void
  (m control-type))

(cffi:defcfun ("uiMenuItemOnClicked" %menu-item-on-clicked) :void
  (m control-type)
  (f :pointer)
  (data :pointer))

(cffi:defcfun ("uiMenuItemChecked" %menu-item-checked) (:boolean :int)
  (m control-type))

(cffi:defcfun ("uiMenuItemSetChecked" %menu-item-set-checked) :void
  (m control-type)
  (checked (:boolean :int)))

(cffi:defcfun ("uiMenuAppendItem" %menu-append-item) :pointer
  (m control-type)
  (name :string))

(cffi:defcfun ("uiMenuAppendCheckItem" %menu-append-check-item) :pointer
  (m control-type)
  (name :string))

(cffi:defcfun ("uiMenuAppendQuitItem" %menu-append-quit-item) :pointer
  (m control-type))

(cffi:defcfun ("uiMenuAppendPreferencesItem" %menu-append-preferences-item) :pointer
  (m control-type))

(cffi:defcfun ("uiMenuAppendAboutItem" %menu-append-about-item) :pointer
  (m control-type))

(cffi:defcfun ("uiMenuAppendSeparator" %menu-append-separator) :void
  (m control-type))

(cffi:defcfun ("uiNewMenu" %new-menu) :pointer
  (name :string))

(cffi:defcfun ("uiOpenFile" %open-file) :string
  (parent control-type))

(cffi:defcfun ("uiSaveFile" %save-file) :string
  (parent control-type))

(cffi:defcfun ("uiMsgBox" %msg-box) :void
  (parent control-type)
  (title :string)
  (description :string))

(cffi:defcfun ("uiMsgBoxError" %msg-box-error) :void
  (parent control-type)
  (title :string)
  (description :string))

(cffi:defcstruct %area-handler
	(Draw :pointer)
	(MouseEvent :pointer)
	(MouseCrossed :pointer)
	(DragBroken :pointer)
	(KeyEvent :pointer))

(defanonenum
	uiWindowResizeEdgeLeft
	uiWindowResizeEdgeTop
	uiWindowResizeEdgeRight
	uiWindowResizeEdgeBottom
	uiWindowResizeEdgeTopLeft
	uiWindowResizeEdgeTopRight
	uiWindowResizeEdgeBottomLeft
	uiWindowResizeEdgeBottomRight)

(cffi:defcfun ("uiAreaSetSize" %area-set-size) :void
  (a control-type)
  (width :int)
  (height :int))

(cffi:defcfun ("uiAreaQueueRedrawAll" %area-queue-redraw-all) :void
  (a control-type))

(cffi:defcfun ("uiAreaScrollTo" %area-scroll-to) :void
  (a control-type)
  (x :double)
  (y :double)
  (width :double)
  (height :double))

(cffi:defcfun ("uiAreaBeginUserWindowMove" %area-begin-user-window-move) :void
  (a control-type))

(cffi:defcfun ("uiAreaBeginUserWindowResize" %area-begin-user-window-resize) :void
  (a control-type)
  (edge :unsigned-int))

(cffi:defcfun ("uiNewArea" %new-area) :pointer
  (ah :pointer))

(cffi:defcfun ("uiNewScrollingArea" %new-scrolling-area) :pointer
  (ah :pointer)
  (width :int)
  (height :int))

(cffi:defcstruct %area-draw-params
	(Context :pointer)
	(AreaWidth :double)
	(AreaHeight :double)
	(ClipX :double)
	(ClipY :double)
	(ClipWidth :double)
	(ClipHeight :double))

(defanonenum
	uiDrawBrushTypeSolid
	uiDrawBrushTypeLinearGradient
	uiDrawBrushTypeRadialGradient
	uiDrawBrushTypeImage)

(defanonenum
	uiDrawLineCapFlat
	uiDrawLineCapRound
	uiDrawLineCapSquare)

(defanonenum
	uiDrawLineJoinMiter
	uiDrawLineJoinRound
	uiDrawLineJoinBevel)

(cl:defconstant %draw-default-miter-limit 10.0d0)

(defanonenum
	uiDrawFillModeWinding
	uiDrawFillModeAlternate)

(cffi:defcstruct %draw-matrix
	(M11 :double)
	(M12 :double)
	(M21 :double)
	(M22 :double)
	(M31 :double)
	(M32 :double))

(cffi:defcstruct %draw-brush
	(Type :unsigned-int)
	(R :double)
	(G :double)
	(B :double)
	(A :double)
	(X0 :double)
	(Y0 :double)
	(X1 :double)
	(Y1 :double)
	(OuterRadius :double)
	(Stops :pointer)
	(NumStops :pointer))

(cffi:defcstruct %draw-brush-gradient-stop
	(Pos :double)
	(R :double)
	(G :double)
	(B :double)
	(A :double))

(cffi:defcstruct %draw-stroke-params
	(Cap :unsigned-int)
	(Join :unsigned-int)
	(Thickness :double)
	(MiterLimit :double)
	(Dashes :pointer)
	(NumDashes :pointer)
	(DashPhase :double))

(cffi:defcfun ("uiDrawNewPath" %draw-new-path) :pointer
  (fillMode :unsigned-int))

(cffi:defcfun ("uiDrawFreePath" %draw-free-path) :void
  (p :pointer))

(cffi:defcfun ("uiDrawPathNewFigure" %draw-path-new-figure) :void
  (p :pointer)
  (x :double)
  (y :double))

(cffi:defcfun ("uiDrawPathNewFigureWithArc" %draw-path-new-figure-with-arc) :void
  (p :pointer)
  (xCenter :double)
  (yCenter :double)
  (radius :double)
  (startAngle :double)
  (sweep :double)
  (negative :int))

(cffi:defcfun ("uiDrawPathLineTo" %draw-path-line-to) :void
  (p :pointer)
  (x :double)
  (y :double))

(cffi:defcfun ("uiDrawPathArcTo" %draw-path-arc-to) :void
  (p :pointer)
  (xCenter :double)
  (yCenter :double)
  (radius :double)
  (startAngle :double)
  (sweep :double)
  (negative :int))

(cffi:defcfun ("uiDrawPathBezierTo" %draw-path-bezier-to) :void
  (p :pointer)
  (c1x :double)
  (c1y :double)
  (c2x :double)
  (c2y :double)
  (endX :double)
  (endY :double))

(cffi:defcfun ("uiDrawPathCloseFigure" %draw-path-close-figure) :void
  (p :pointer))

(cffi:defcfun ("uiDrawPathAddRectangle" %draw-path-add-rectangle) :void
  (p :pointer)
  (x :double)
  (y :double)
  (width :double)
  (height :double))

(cffi:defcfun ("uiDrawPathEnd" %draw-path-end) :void
  (p :pointer))

(cffi:defcfun ("uiDrawStroke" %draw-stroke) :void
  (c :pointer)
  (path :pointer)
  (b :pointer)
  (p :pointer))

(cffi:defcfun ("uiDrawFill" %draw-fill) :void
  (c :pointer)
  (path :pointer)
  (b :pointer))

(cffi:defcfun ("uiDrawMatrixSetIdentity" %draw-matrix-set-identity) :void
  (m :pointer))

(cffi:defcfun ("uiDrawMatrixTranslate" %draw-matrix-translate) :void
  (m :pointer)
  (x :double)
  (y :double))

(cffi:defcfun ("uiDrawMatrixScale" %draw-matrix-scale) :void
  (m :pointer)
  (xCenter :double)
  (yCenter :double)
  (x :double)
  (y :double))

(cffi:defcfun ("uiDrawMatrixRotate" %draw-matrix-rotate) :void
  (m :pointer)
  (x :double)
  (y :double)
  (amount :double))

(cffi:defcfun ("uiDrawMatrixSkew" %draw-matrix-skew) :void
  (m :pointer)
  (x :double)
  (y :double)
  (xamount :double)
  (yamount :double))

(cffi:defcfun ("uiDrawMatrixMultiply" %draw-matrixMultiply) :void
  (dest :pointer)
  (src :pointer))

(cffi:defcfun ("uiDrawMatrixInvertible" %draw-matrix-invertible) :int
  (m :pointer))

(cffi:defcfun ("uiDrawMatrixInvert" %draw-matrix-invert) :int
  (m :pointer))

(cffi:defcfun ("uiDrawMatrixTransformPoint" %draw-matrix-transform-point) :void
  (m :pointer)
  (x :pointer)
  (y :pointer))

(cffi:defcfun ("uiDrawMatrixTransformSize" %draw-matrix-transform-size) :void
  (m :pointer)
  (x :pointer)
  (y :pointer))

(cffi:defcfun ("uiDrawTransform" %draw-transform) :void
  (c :pointer)
  (m :pointer))

(cffi:defcfun ("uiDrawClip" %draw-clip) :void
  (c :pointer)
  (path :pointer))

(cffi:defcfun ("uiDrawSave" %draw-save) :void
  (c :pointer))

(cffi:defcfun ("uiDrawRestore" %draw-restore) :void
  (c :pointer))

(cffi:defcfun ("uiFreeAttribute" %free-attribute) :void
  (a :pointer))

(defanonenum
	uiAttributeTypeFamily
	uiAttributeTypeSize
	uiAttributeTypeWeight
	uiAttributeTypeItalic
	uiAttributeTypeStretch
	uiAttributeTypeColor
	uiAttributeTypeBackground
	uiAttributeTypeUnderline
	uiAttributeTypeUnderlineColor
	uiAttributeTypeFeatures)

(cffi:defcfun ("uiAttributeGetType" %attribute-get-type) :unsigned-int
  (a :pointer))

(cffi:defcfun ("uiNewFamilyAttribute" %new-family-attribute) :pointer
  (family :string))

(cffi:defcfun ("uiAttributeFamily" %attribute-family) :string
  (a :pointer))

(cffi:defcfun ("uiNewSizeAttribute" %new-size-attribute) :pointer
  (size :double))

(cffi:defcfun ("uiAttributeSize" %attribute-size) :double
  (a :pointer))

(defanonenum
	(uiTextWeightMinimum #.0)
	(uiTextWeightThin #.100)
	(uiTextWeightUltraLight #.200)
	(uiTextWeightLight #.300)
	(uiTextWeightBook #.350)
	(uiTextWeightNormal #.400)
	(uiTextWeightMedium #.500)
	(uiTextWeightSemiBold #.600)
	(uiTextWeightBold #.700)
	(uiTextWeightUltraBold #.800)
	(uiTextWeightHeavy #.900)
	(uiTextWeightUltraHeavy #.950)
	(uiTextWeightMaximum #.1000))

(cffi:defcfun ("uiNewWeightAttribute" %new-weight-attribute) :pointer
  (weight :unsigned-int))

(cffi:defcfun ("uiAttributeWeight" %attribute-weight) :unsigned-int
  (a :pointer))

(defanonenum
	uiTextItalicNormal
	uiTextItalicOblique
	uiTextItalicItalic)

(cffi:defcfun ("uiNewItalicAttribute" %new-italic-attribute) :pointer
  (italic :unsigned-int))

(cffi:defcfun ("uiAttributeItalic" %attribute-italic) :unsigned-int
  (a :pointer))

(defanonenum
	uiTextStretchUltraCondensed
	uiTextStretchExtraCondensed
	uiTextStretchCondensed
	uiTextStretchSemiCondensed
	uiTextStretchNormal
	uiTextStretchSemiExpanded
	uiTextStretchExpanded
	uiTextStretchExtraExpanded
	uiTextStretchUltraExpanded)

(cffi:defcfun ("uiNewStretchAttribute" %new-stretch-attribute) :pointer
  (stretch :unsigned-int))

(cffi:defcfun ("uiAttributeStretch" %attribute-stretch) :unsigned-int
  (a :pointer))

(cffi:defcfun ("uiNewColorAttribute" %new-color-attribute) :pointer
  (r :double)
  (g :double)
  (b :double)
  (a :double))

(cffi:defcfun ("uiAttributeColor" %attribute-color) :void
  (a :pointer)
  (r :pointer)
  (g :pointer)
  (b :pointer)
  (alpha :pointer))

(cffi:defcfun ("uiNewBackgroundAttribute" %new-background-attribute) :pointer
  (r :double)
  (g :double)
  (b :double)
  (a :double))

(defanonenum
	uiUnderlineNone
	uiUnderlineSingle
	uiUnderlineDouble
	uiUnderlineSuggestion)

(cffi:defcfun ("uiNewUnderlineAttribute" %new-underline-attribute) :pointer
  (u :unsigned-int))

(cffi:defcfun ("uiAttributeUnderline" %attribute-underline) :unsigned-int
  (a :pointer))

(defanonenum
	uiUnderlineColorCustom
	uiUnderlineColorSpelling
	uiUnderlineColorGrammar
	uiUnderlineColorAuxiliary)

(cffi:defcfun ("uiNewUnderlineColorAttribute" %new-underline-color-attribute) :pointer
  (u :unsigned-int)
  (r :double)
  (g :double)
  (b :double)
  (a :double))

(cffi:defcfun ("uiAttributeUnderlineColor" %attribute-underline-color) :void
  (a :pointer)
  (u :pointer)
  (r :pointer)
  (g :pointer)
  (b :pointer)
  (alpha :pointer))

(cffi:defcfun ("uiNewOpenTypeFeatures" %new-open-type-features) :pointer)

(cffi:defcfun ("uiFreeOpenTypeFeatures" %free-open-type-features) :void
  (otf :pointer))

(cffi:defcfun ("uiOpenTypeFeaturesClone" %open-type-features-clone) :pointer
  (otf :pointer))

(cffi:defcfun ("uiOpenTypeFeaturesAdd" %open-type-features-add) :void
  (otf :pointer)
  (a :char)
  (b :char)
  (c :char)
  (d :char)
  (value :pointer))

(cffi:defcfun ("uiOpenTypeFeaturesRemove" %open-type-features-remove) :void
  (otf :pointer)
  (a :char)
  (b :char)
  (c :char)
  (d :char))

(cffi:defcfun ("uiOpenTypeFeaturesGet" %open-type-features-get) :int
  (otf :pointer)
  (a :char)
  (b :char)
  (c :char)
  (d :char)
  (value :pointer))

(cffi:defcfun ("uiOpenTypeFeaturesForEach" %open-type-features-for-each) :void
  (otf :pointer)
  (f :pointer)
  (data :pointer))

(cffi:defcfun ("uiNewFeaturesAttribute" %new-features-attribute) :pointer
  (otf :pointer))

(cffi:defcfun ("uiAttributeFeatures" %attribute-features) :pointer
  (a :pointer))

(cffi:defcfun ("uiNewAttributedString" %new-attributed-string) :pointer
  (initialString :string))

(cffi:defcfun ("uiFreeAttributedString" %free-attributed-string) :void
  (s :pointer))

(cffi:defcfun ("uiAttributedStringString" %attributed-string-string) :string
  (s :pointer))

(cffi:defcfun ("uiAttributedStringLen" %attributed-string-len) :pointer
  (s :pointer))

(cffi:defcfun ("uiAttributedStringAppendUnattributed" %attributed-string-append-unattributed) :void
  (s :pointer)
  (str :string))

(cffi:defcfun ("uiAttributedStringInsertAtUnattributed" %attributed-string-insert-at-unattributed) :void
  (s :pointer)
  (str :string)
  (at :pointer))

(cffi:defcfun ("uiAttributedStringDelete" %attributed-string-delete) :void
  (s :pointer)
  (start :pointer)
  (end :pointer))

(cffi:defcfun ("uiAttributedStringSetAttribute" %attributed-string-set-attribute) :void
  (s :pointer)
  (a :pointer)
  (start :pointer)
  (end :pointer))

(cffi:defcfun ("uiAttributedStringForEachAttribute" %attributed-string-for-each-attribute) :void
  (s :pointer)
  (f :pointer)
  (data :pointer))

(cffi:defcfun ("uiAttributedStringNumGraphemes" %attributed-string-num-graphemes) :pointer
  (s :pointer))

(cffi:defcfun ("uiAttributedStringByteIndexToGrapheme" %attributed-string-byte-index-to-grapheme) :pointer
  (s :pointer)
  (pos :pointer))

(cffi:defcfun ("uiAttributedStringGraphemeToByteIndex" %attributed-string-grapheme-to-byte-index) :pointer
  (s :pointer)
  (pos :pointer))

(cffi:defcstruct %font-descriptor
	(Family :string)
	(Size :double)
	(Weight :unsigned-int)
	(Italic :unsigned-int)
	(Stretch :unsigned-int))

(defanonenum
	uiDrawTextAlignLeft
	uiDrawTextAlignCenter
	uiDrawTextAlignRight)

(cffi:defcstruct %draw-text-layout-params
	(String :pointer)
	(DefaultFont :pointer)
	(Width :double)
	(Align :unsigned-int))

(cffi:defcfun ("uiDrawNewTextLayout" %draw-new-text-layout) :pointer
  (params :pointer))

(cffi:defcfun ("uiDrawFreeTextLayout" %draw-free-text-layout) :void
  (tl :pointer))

(cffi:defcfun ("uiDrawText" %draw-text) :void
  (c :pointer)
  (tl :pointer)
  (x :double)
  (y :double))

(cffi:defcfun ("uiDrawTextLayoutExtents" %draw-text-layout-extents) :void
  (tl :pointer)
  (width :pointer)
  (height :pointer))

(cffi:defcfun ("uiFontButtonFont" %font-button-font) :void
  (b :pointer)
  (desc :pointer))

(cffi:defcfun ("uiFontButtonOnChanged" %font-button-on-changed) :void
  (b :pointer)
  (f :pointer)
  (data :pointer))

(cffi:defcfun ("uiNewFontButton" %new-font-button) :pointer)

(cffi:defcfun ("uiFreeFontButtonFont" %free-font-button-font) :void
  (desc :pointer))

(defanonenum
	(uiModifierCtrl #.(cl:ash 1 0))
	(uiModifierAlt #.(cl:ash 1 1))
	(uiModifierShift #.(cl:ash 1 2))
	(uiModifierSuper #.(cl:ash 1 3)))

(cffi:defcstruct %area-mouse-event
	(X :double)
	(Y :double)
	(AreaWidth :double)
	(AreaHeight :double)
	(Down :int)
	(Up :int)
	(Count :int)
	(Modifiers :unsigned-int)
	(Held1To64 :pointer))

(defanonenum
	(uiExtKeyEscape #.1)
	uiExtKeyInsert
	uiExtKeyDelete
	uiExtKeyHome
	uiExtKeyEnd
	uiExtKeyPageUp
	uiExtKeyPageDown
	uiExtKeyUp
	uiExtKeyDown
	uiExtKeyLeft
	uiExtKeyRight
	uiExtKeyF1
	uiExtKeyF2
	uiExtKeyF3
	uiExtKeyF4
	uiExtKeyF5
	uiExtKeyF6
	uiExtKeyF7
	uiExtKeyF8
	uiExtKeyF9
	uiExtKeyF10
	uiExtKeyF11
	uiExtKeyF12
	uiExtKeyN0
	uiExtKeyN1
	uiExtKeyN2
	uiExtKeyN3
	uiExtKeyN4
	uiExtKeyN5
	uiExtKeyN6
	uiExtKeyN7
	uiExtKeyN8
	uiExtKeyN9
	uiExtKeyNDot
	uiExtKeyNEnter
	uiExtKeyNAdd
	uiExtKeyNSubtract
	uiExtKeyNMultiply
	uiExtKeyNDivide)

(cffi:defcstruct %area-key-event
	(Key :char)
	(ExtKey :unsigned-int)
	(Modifier :unsigned-int)
	(Modifiers :unsigned-int)
	(Up :int))

(cffi:defcfun ("uiColorButtonColor" %color-button-color) :void
  (b :pointer)
  (r :pointer)
  (g :pointer)
  (bl :pointer)
  (a :pointer))

(cffi:defcfun ("uiColorButtonSetColor" %color-button-set-color) :void
  (b :pointer)
  (r :double)
  (g :double)
  (bl :double)
  (a :double))

(cffi:defcfun ("uiColorButtonOnChanged" %color-button-on-changed) :void
  (b :pointer)
  (f :pointer)
  (data :pointer))

(cffi:defcfun ("uiNewColorButton" %new-color-button) :pointer)

(cffi:defcfun ("uiFormAppend" %form-append) :void
  (f control-type)
  (label :string)
  (c control-type)
  (stretchy (:boolean :int)))

(cffi:defcfun ("uiFormDelete" %form-delete) :void
  (f control-type)
  (index :int))

(cffi:defcfun ("uiFormPadded" %form-padded) (:boolean :int)
  (f control-type))

(cffi:defcfun ("uiFormSetPadded" %form-set-padded) :void
  (f control-type)
  (padded (:boolean :int)))

(cffi:defcfun ("uiNewForm" %new-form) :pointer)

(defanonenum
	uiAlignFill
	uiAlignStart
	uiAlignCenter
	uiAlignEnd)

(defanonenum
	uiAtLeading
	uiAtTop
	uiAtTrailing
	uiAtBottom)

(cffi:defcfun ("uiGridAppend" %grid-append) :void
  (g :pointer)
  (c :pointer)
  (left :int)
  (top :int)
  (xspan :int)
  (yspan :int)
  (hexpand :int)
  (halign :unsigned-int)
  (vexpand :int)
  (valign :unsigned-int))

(cffi:defcfun ("uiGridInsertAt" %grid-insert-at) :void
  (g :pointer)
  (c :pointer)
  (existing :pointer)
  (at :unsigned-int)
  (xspan :int)
  (yspan :int)
  (hexpand :int)
  (halign :unsigned-int)
  (vexpand :int)
  (valign :unsigned-int))

(cffi:defcfun ("uiGridPadded" %grid-padded) :int
  (g :pointer))

(cffi:defcfun ("uiGridSetPadded" %grid-set-padded) :void
  (g :pointer)
  (padded :int))

(cffi:defcfun ("uiNewGrid" %new-grid) :pointer)

(cffi:defcfun ("uiNewImage" %new-image) :pointer
  (width :double)
  (height :double))

(cffi:defcfun ("uiFreeImage" %free-image) :void
  (i :pointer))

(cffi:defcfun ("uiImageAppend" %image-append) :void
  (i :pointer)
  (pixels :pointer)
  (pixelWidth :int)
  (pixelHeight :int)
  (byteStride :int))

(cffi:defcfun ("uiFreeTableValue" %free-table-value) :void
  (v :pointer))

(defanonenum
	uiTableValueTypeString
	uiTableValueTypeImage
	uiTableValueTypeInt
	uiTableValueTypeColor)

(cffi:defcfun ("uiTableValueGetType" %table-value-get-type) :unsigned-int
  (v :pointer))

(cffi:defcfun ("uiNewTableValueString" %new-table-value-string) :pointer
  (str :string))

(cffi:defcfun ("uiTableValueString" %table-value-string) :string
  (v :pointer))

(cffi:defcfun ("uiNewTableValueImage" %new-table-value-image) :pointer
  (img :pointer))

(cffi:defcfun ("uiTableValueImage" %table-value-image) :pointer
  (v :pointer))

(cffi:defcfun ("uiNewTableValueInt" %new-table-value-int) :pointer
  (i :int))

(cffi:defcfun ("uiTableValueInt" %table-value-int) :int
  (v :pointer))

(cffi:defcfun ("uiNewTableValueColor" %new-table-value-color) :pointer
  (r :double)
  (g :double)
  (b :double)
  (a :double))

(cffi:defcfun ("uiTableValueColor" %table-value-color) :void
  (v :pointer)
  (r :pointer)
  (g :pointer)
  (b :pointer)
  (a :pointer))

(cffi:defcstruct %table-model-handler
	(NumColumns :pointer)
	(ColumnType :pointer)
	(NumRows :pointer)
	(CellValue :pointer)
	(SetCellValue :pointer))

(cffi:defcfun ("uiNewTableModel" %new-table-model) :pointer
  (mh :pointer))

(cffi:defcfun ("uiFreeTableModel" %free-table-model) :void
  (m :pointer))

(cffi:defcfun ("uiTableModelRowInserted" %table-model-row-inserted) :void
  (m :pointer)
  (newIndex :int))

(cffi:defcfun ("uiTableModelRowChanged" %table-model-row-changed) :void
  (m :pointer)
  (index :int))

(cffi:defcfun ("uiTableModelRowDeleted" %table-model-row-deleted) :void
  (m :pointer)
  (oldIndex :int))

(cl:defconstant %table-model-column-never-editable -1)

(cl:defconstant %table-model-column-always-editable -2)

(cffi:defcstruct %table-text-column-optional-params
	(ColorModelColumn :int))

(cffi:defcstruct %table-params
	(Model :pointer)
	(RowBackgroundColorModelColumn :int))

(cffi:defcfun ("uiTableAppendTextColumn" %table-append-text-column) :void
  (t_arg0 :pointer)
  (name :string)
  (textModelColumn :int)
  (textEditableModelColumn :int)
  (textParams :pointer))

(cffi:defcfun ("uiTableAppendImageColumn" %table-append-image-column) :void
  (t_arg0 :pointer)
  (name :string)
  (imageModelColumn :int))

(cffi:defcfun ("uiTableAppendImageTextColumn" %table-append-image-text-column) :void
  (t_arg0 :pointer)
  (name :string)
  (imageModelColumn :int)
  (textModelColumn :int)
  (textEditableModelColumn :int)
  (textParams :pointer))

(cffi:defcfun ("uiTableAppendCheckboxColumn" %table-append-checkboxColumn) :void
  (t_arg0 :pointer)
  (name :string)
  (checkboxModelColumn :int)
  (checkboxEditableModelColumn :int))

(cffi:defcfun ("uiTableAppendCheckboxTextColumn" %table-append-checkbox-textColumn) :void
  (t_arg0 :pointer)
  (name :string)
  (checkboxModelColumn :int)
  (checkboxEditableModelColumn :int)
  (textModelColumn :int)
  (textEditableModelColumn :int)
  (textParams :pointer))

(cffi:defcfun ("uiTableAppendProgressBarColumn" %table-append-progress-bar-column) :void
  (t_arg0 :pointer)
  (name :string)
  (progressModelColumn :int))

(cffi:defcfun ("uiTableAppendButtonColumn" %table-append-button-column) :void
  (t_arg0 :pointer)
  (name :string)
  (buttonModelColumn :int)
  (buttonClickableModelColumn :int))

(cffi:defcfun ("uiNewTable" %new-table) :pointer
  (params :pointer))
