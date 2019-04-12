(in-package #:ui)

(cffi:define-foreign-library libui
  (:darwin "libui.dylib")
  (:unix "libui.so")
  (t (:default "libui.dll")))

(cffi:use-foreign-library libui)

(cffi:define-foreign-type ui-type ()
  ()
  (:actual-type :pointer)
  (:simple-parser ui-type))

(cffi:define-foreign-type draw-context-type ()
  ()
  (:actual-type :pointer)
  (:simple-parser draw-context-type))

(cffi:define-foreign-type brush-type ()
  ()
  (:actual-type :pointer)
  (:simple-parser brush-type))

(cffi:define-foreign-type stroke-params-type ()
  ()
  (:actual-type :pointer)
  (:simple-parser stroke-params-type))

(cffi:defcstruct %init-options
	(size size-t))

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
  (arg0 ui-type))

; (cffi:defcfun ("uiControlHandle" %control-handle) :pointer
;   (arg0 :pointer))

(cffi:defcfun ("uiControlParent" %control-parent) :pointer
  (arg0 ui-type))

(cffi:defcfun ("uiControlSetParent" %control-set-parent) :void
  (arg0 ui-type)
  (arg1 ui-type))

(cffi:defcfun ("uiControlToplevel" %control-toplevel) (:boolean :int)
  (arg0 ui-type))

(cffi:defcfun ("uiControlVisible" %control-visible) (:boolean :int)
  (arg0 ui-type))

(cffi:defcfun ("uiControlShow" %control-show) :void
  (arg0 ui-type))

(cffi:defcfun ("uiControlHide" %control-hide) :void
  (arg0 ui-type))

(cffi:defcfun ("uiControlEnabled" %control-enabled) (:boolean :int)
  (arg0 ui-type))

(cffi:defcfun ("uiControlEnable" %control-enable) :void
  (arg0 ui-type))

(cffi:defcfun ("uiControlDisable" %control-disable) :void
  (arg0 ui-type))

; (cffi:defcfun ("uiAllocControl" %alloc-control) :pointer
;   (n size-t)
;   (OSsig :pointer)
;   (typesig :pointer)
;   (typenamestr :string))
;
(cffi:defcfun ("uiFreeControl" %free-control) :void
  (arg0 :pointer))

; (cffi:defcfun ("uiControlVerifySetParent" %control-verify-set-parent) :void
;   (arg0 :pointer)
;   (arg1 :pointer))

(cffi:defcfun ("uiControlEnabledToUser" %control-enabled-to-user) (:boolean :int)
  (arg0 :pointer))

; (cffi:defcfun ("uiUserBugCannotSetParentOnToplevel" %user-bug-cannot-set-parent-on-toplevel) :void
;   (type :string))

(cffi:defcfun ("uiWindowTitle" %window-title) :string
  (w ui-type))

(cffi:defcfun ("uiWindowSetTitle" %window-set-title) :void
  (w ui-type)
  (title :string))

(cffi:defcfun ("uiWindowContentSize" %window-content-size) :void
  (w ui-type)
  (width (:pointer :int))
  (height (:pointer :int)))

(cffi:defcfun ("uiWindowSetContentSize" %window-set-content-size) :void
  (w ui-type)
  (width :int)
  (height :int))

(cffi:defcfun ("uiWindowFullscreen" %window-fullscreen) (:boolean :int)
  (w ui-type))

(cffi:defcfun ("uiWindowSetFullscreen" %window-set-fullscreen) :void
  (w ui-type)
  (fullscreen (:boolean :int)))

(cffi:defcfun ("uiWindowOnContentSizeChanged" %window-on-content-size-changed) :void
  (w ui-type)
  (f :pointer)
  (data :pointer))

(cffi:defcfun ("uiWindowOnClosing" %window-on-closing) :void
  (w ui-type)
  (f :pointer)
  (data :pointer))

(cffi:defcfun ("uiWindowBorderless" %window-borderless) (:boolean :int)
  (w ui-type))

(cffi:defcfun ("uiWindowSetBorderless" %window-set-borderless) :void
  (w ui-type)
  (borderless (:boolean :int)))

(cffi:defcfun ("uiWindowSetChild" %window-set-child) :void
  (w ui-type)
  (child ui-type))

(cffi:defcfun ("uiWindowMargined" %window-margined) (:boolean :int)
  (w ui-type))

(cffi:defcfun ("uiWindowSetMargined" %window-set-margined) :void
  (w ui-type)
  (margined (:boolean :int)))

(cffi:defcfun ("uiNewWindow" %new-window) :pointer
  (title :string)
  (width :int)
  (height :int)
  (hasMenubar (:boolean :int)))

(cffi:defcfun ("uiButtonText" %button-text) :string
  (b ui-type))

(cffi:defcfun ("uiButtonSetText" %button-set-text) :void
  (b ui-type)
  (text :string))

(cffi:defcfun ("uiButtonOnClicked" %button-on-clicked) :void
  (b ui-type)
  (f :pointer)
  (data :pointer))

(cffi:defcfun ("uiNewButton" %new-button) :pointer
  (text :string))

(cffi:defcfun ("uiBoxAppend" %box-append) :void
  (b ui-type)
  (child ui-type)
  (stretchy (:boolean :int)))

(cffi:defcfun ("uiBoxDelete" %box-delete) :void
  (b ui-type)
  (index :int))

(cffi:defcfun ("uiBoxPadded" %box-padded) (:boolean :int)
  (b ui-type))

(cffi:defcfun ("uiBoxSetPadded" %box-set-padded) :void
  (b ui-type)
  (padded (:boolean :int)))

(cffi:defcfun ("uiNewHorizontalBox" %new-horizontal-box) :pointer)

(cffi:defcfun ("uiNewVerticalBox" %new-vertical-box) :pointer)

(cffi:defcfun ("uiCheckboxText" %checkbox-text) :string
  (c ui-type))

(cffi:defcfun ("uiCheckboxSetText" %checkbox-set-text) :void
  (c ui-type)
  (text :string))

(cffi:defcfun ("uiCheckboxOnToggled" %checkbox-on-toggled) :void
  (c ui-type)
  (f :pointer)
  (data :pointer))

(cffi:defcfun ("uiCheckboxChecked" %checkbox-checked) (:boolean :int)
  (c ui-type))

(cffi:defcfun ("uiCheckboxSetChecked" %checkbox-set-checked) :void
  (c ui-type)
  (checked (:boolean :int)))

(cffi:defcfun ("uiNewCheckbox" %new-checkbox) :pointer
  (text :string))

(cffi:defcfun ("uiEntryText" %entry-text) :string
  (e ui-type))

(cffi:defcfun ("uiEntrySetText" %entry-set-text) :void
  (e ui-type)
  (text :string))

(cffi:defcfun ("uiEntryOnChanged" %entry-on-changed) :void
  (e ui-type)
  (f :pointer)
  (data :pointer))

(cffi:defcfun ("uiEntryReadOnly" %entry-read-only) (:boolean :int)
  (e ui-type))

(cffi:defcfun ("uiEntrySetReadOnly" %entry-set-read-only) :void
  (e ui-type)
  (readonly (:boolean :int)))

(cffi:defcfun ("uiNewEntry" %new-entry) :pointer)

(cffi:defcfun ("uiNewPasswordEntry" %new-password-entry) :pointer)

(cffi:defcfun ("uiNewSearchEntry" %new-search-entry) :pointer)

(cffi:defcfun ("uiLabelText" %label-text) :string
  (l ui-type))

(cffi:defcfun ("uiLabelSetText" %label-set-text) :void
  (l ui-type)
  (text :string))

(cffi:defcfun ("uiNewLabel" %new-label) :pointer
  (text :string))

(cffi:defcfun ("uiTabAppend" %tab-append) :void
  (t_arg0 ui-type)
  (name :string)
  (c ui-type))

(cffi:defcfun ("uiTabInsertAt" %tab-insert-at) :void
  (t_arg0 ui-type)
  (name :string)
  (before :int)
  (c ui-type))

(cffi:defcfun ("uiTabDelete" %tab-delete) :void
  (t_arg0 ui-type)
  (index :int))

(cffi:defcfun ("uiTabNumPages" %tab-num-pages) :int
  (t_arg0 ui-type))

(cffi:defcfun ("uiTabMargined" %tab-margined) (:boolean :int)
  (t_arg0 ui-type)
  (page :int))

(cffi:defcfun ("uiTabSetMargined" %tab-set-margined) :void
  (t_arg0 ui-type)
  (page :int)
  (margined (:boolean :int)))

(cffi:defcfun ("uiNewTab" %new-tab) :pointer)

(cffi:defcfun ("uiGroupTitle" %group-title) :string
  (g ui-type))

(cffi:defcfun ("uiGroupSetTitle" %group-set-title) :void
  (g ui-type)
  (title :string))

(cffi:defcfun ("uiGroupSetChild" %group-set-child) :void
  (g ui-type)
  (c ui-type))

(cffi:defcfun ("uiGroupMargined" %group-margined) (:boolean :int)
  (g ui-type))

(cffi:defcfun ("uiGroupSetMargined" %group-set-margined) :void
  (g ui-type)
  (margined (:boolean :int)))

(cffi:defcfun ("uiNewGroup" %new-group) :pointer
  (title :string))

(cffi:defcfun ("uiSpinboxValue" %spinbox-value) :int
  (s ui-type))

(cffi:defcfun ("uiSpinboxSetValue" %spinbox-set-value) :void
  (s ui-type)
  (value :int))

(cffi:defcfun ("uiSpinboxOnChanged" %spinbox-on-changed) :void
  (s ui-type)
  (f :pointer)
  (data :pointer))

(cffi:defcfun ("uiNewSpinbox" %new-spinbox) :pointer
  (min :int)
  (max :int))

(cffi:defcfun ("uiSliderValue" %slider-value) :int
  (s ui-type))

(cffi:defcfun ("uiSliderSetValue" %slider-set-value) :void
  (s ui-type)
  (value :int))

(cffi:defcfun ("uiSliderOnChanged" %slider-on-changed) :void
  (s ui-type)
  (f :pointer)
  (data :pointer))

(cffi:defcfun ("uiNewSlider" %new-slider) :pointer
  (min :int)
  (max :int))

(cffi:defcfun ("uiProgressBarValue" %progress-bar-value) :int
  (p ui-type))

(cffi:defcfun ("uiProgressBarSetValue" %progress-bar-set-value) :void
  (p ui-type)
  (n :int))

(cffi:defcfun ("uiNewProgressBar" %new-progress-bar) :pointer)

(cffi:defcfun ("uiNewHorizontalSeparator" %new-horizontal-separator) :pointer)

(cffi:defcfun ("uiNewVerticalSeparator" %new-vertical-separator) :pointer)

(cffi:defcfun ("uiComboboxAppend" %combobox-append) :void
  (c ui-type)
  (text :string))

(cffi:defcfun ("uiComboboxSelected" %combobox-selected) :int
  (c ui-type))

(cffi:defcfun ("uiComboboxSetSelected" %combobox-set-selected) :void
  (c ui-type)
  (n :int))

(cffi:defcfun ("uiComboboxOnSelected" %combobox-on-selected) :void
  (c ui-type)
  (f :pointer)
  (data :pointer))

(cffi:defcfun ("uiNewCombobox" %new-combobox) :pointer)

(cffi:defcfun ("uiEditableComboboxAppend" %editable-combobox-append) :void
  (c ui-type)
  (text :string))

(cffi:defcfun ("uiEditableComboboxText" %editable-combobox-text) :string
  (c ui-type))

(cffi:defcfun ("uiEditableComboboxSetText" %editable-combobox-set-text) :void
  (c ui-type)
  (text :string))

(cffi:defcfun ("uiEditableComboboxOnChanged" %editable-combobox-on-changed) :void
  (c ui-type)
  (f :pointer)
  (data :pointer))

(cffi:defcfun ("uiNewEditableCombobox" %new-editable-combobox) :pointer)

(cffi:defcfun ("uiRadioButtonsAppend" %radio-buttons-append) :void
  (r ui-type)
  (text :string))

(cffi:defcfun ("uiRadioButtonsSelected" %radio-buttons-selected) :int
  (r ui-type))

(cffi:defcfun ("uiRadioButtonsSetSelected" %radio-buttons-set-selected) :void
  (r ui-type)
  (n :int))

(cffi:defcfun ("uiRadioButtonsOnSelected" %radio-buttons-on-selected) :void
  (r ui-type)
  (f :pointer)
  (data :pointer))

(cffi:defcfun ("uiNewRadioButtons" %new-radio-buttons) :pointer)

(cffi:defcstruct %tm
  (sec :int)
  (min :int)
  (hour :int)
  (mday :int)
  (mon :int)
  (year :int)
  (wday :int)
  (yday :int)
  (isdst :int))

(cffi:defcfun ("uiDateTimePickerTime" %date-time-picker-time) :void
  (d ui-type)
  (time (:pointer (:struct %tm))))

(cffi:defcfun ("uiDateTimePickerSetTime" %date-time-picker-set-time) :void
  (d ui-type)
  (time (:pointer (:struct %tm))))

(cffi:defcfun ("uiDateTimePickerOnChanged" %date-time-picker-on-changed) :void
  (d ui-type)
  (f :pointer)
  (data :pointer))

(cffi:defcfun ("uiNewDateTimePicker" %new-date-time-picker) :pointer)

(cffi:defcfun ("uiNewDatePicker" %new-date-picker) :pointer)

(cffi:defcfun ("uiNewTimePicker" %new-time-picker) :pointer)

(cffi:defcfun ("uiMultilineEntryText" %multiline-entry-text) :string
  (e ui-type))

(cffi:defcfun ("uiMultilineEntrySetText" %multiline-entry-set-text) :void
  (e ui-type)
  (text :string))

(cffi:defcfun ("uiMultilineEntryAppend" %multiline-entry-append) :void
  (e ui-type)
  (text :string))

(cffi:defcfun ("uiMultilineEntryOnChanged" %multiline-entry-on-changed) :void
  (e ui-type)
  (f :pointer)
  (data :pointer))

(cffi:defcfun ("uiMultilineEntryReadOnly" %multiline-entry-read-only) (:boolean :int)
  (e ui-type))

(cffi:defcfun ("uiMultilineEntrySetReadOnly" %multiline-entry-set-read-only) :void
  (e ui-type)
  (readonly (:boolean :int)))

(cffi:defcfun ("uiNewMultilineEntry" %new-multiline-entry) :pointer)

(cffi:defcfun ("uiNewNonWrappingMultilineEntry" %new-non-wrapping-multiline-entry) :pointer)

(cffi:defcfun ("uiMenuItemEnable" %menu-item-enable) :void
  (m ui-type))

(cffi:defcfun ("uiMenuItemDisable" %menu-item-disable) :void
  (m ui-type))

(cffi:defcfun ("uiMenuItemOnClicked" %menu-item-on-clicked) :void
  (m ui-type)
  (f :pointer)
  (data :pointer))

(cffi:defcfun ("uiMenuItemChecked" %menu-item-checked) (:boolean :int)
  (m ui-type))

(cffi:defcfun ("uiMenuItemSetChecked" %menu-item-set-checked) :void
  (m ui-type)
  (checked (:boolean :int)))

(cffi:defcfun ("uiMenuAppendItem" %menu-append-item) :pointer
  (m ui-type)
  (name :string))

(cffi:defcfun ("uiMenuAppendCheckItem" %menu-append-check-item) :pointer
  (m ui-type)
  (name :string))

(cffi:defcfun ("uiMenuAppendQuitItem" %menu-append-quit-item) :pointer
  (m ui-type))

(cffi:defcfun ("uiMenuAppendPreferencesItem" %menu-append-preferences-item) :pointer
  (m ui-type))

(cffi:defcfun ("uiMenuAppendAboutItem" %menu-append-about-item) :pointer
  (m ui-type))

(cffi:defcfun ("uiMenuAppendSeparator" %menu-append-separator) :void
  (m ui-type))

(cffi:defcfun ("uiNewMenu" %new-menu) :pointer
  (name :string))

(cffi:defcfun ("uiOpenFile" open-file) :string
  (parent ui-type))

(cffi:defcfun ("uiSaveFile" save-file) :string
  (parent ui-type))

(cffi:defcfun ("uiMsgBox" message-box) :void
  (parent ui-type)
  (title :string)
  (description :string))

(cffi:defcfun ("uiMsgBoxError" error-box) :void
  (parent ui-type)
  (title :string)
  (description :string))

(cffi:defcstruct %area-handler
	(:draw :pointer)
	(:mouse-event :pointer)
	(:mouse-crossed :pointer)
	(:drag-broken :pointer)
	(:key-event :pointer))

(cffi:defcfun ("uiAreaSetSize" %area-set-size) :void
  (a ui-type)
  (width :int)
  (height :int))

(cffi:defcfun ("uiAreaQueueRedrawAll" %area-queue-redraw-all) :void
  (a ui-type))

(cffi:defcfun ("uiAreaScrollTo" %area-scroll-to) :void
  (a ui-type)
  (x :double)
  (y :double)
  (width :double)
  (height :double))

(cffi:defcfun ("uiAreaBeginUserWindowMove" %area-begin-user-window-move) :void
  (a ui-type))

(cffi:defcfun ("uiAreaBeginUserWindowResize" %area-begin-user-window-resize) :void
  (a ui-type)
  (edge :unsigned-int))

(cffi:defcfun ("uiNewArea" %new-area) :pointer
  (ah :pointer))

(cffi:defcfun ("uiNewScrollingArea" %new-scrolling-area) :pointer
  (ah :pointer)
  (width :int)
  (height :int))

(cffi:defcstruct %area-draw-params
	(:context draw-context-type)
	(:area-width :double)
	(:area-height :double)
	(:clip-x :double)
	(:clip-y :double)
	(:clip-width :double)
	(:clip-height :double))

(cffi:defcstruct %draw-matrix
	(:m11 :double)
	(:m12 :double)
	(:m21 :double)
	(:m22 :double)
	(:m31 :double)
	(:m32 :double))

(cffi:defcstruct %draw-brush-gradient-stop
	(:position :double)
	(:red :double)
	(:green :double)
	(:blue :double)
	(:alpha :double))

(cffi:defcstruct (%draw-brush :class type-draw-brush)
	(:type %draw-brush-type)
	(:red :double)
	(:green :double)
	(:blue :double)
	(:alpha :double)
	(:x0 :double)
	(:y0 :double)
	(:x1 :double)
	(:y1 :double)
	(:outer-radius :double)
	(:stops (:pointer (:struct %draw-brush-gradient-stop)))
	(:num-stops size-t))

(cffi:defcstruct (%draw-stroke-params :class draw-stroke-params-type)
	(:cap %draw-line-cap)
	(:join %draw-line-join)
	(:thickness :double)
	(:miter-limit :double)
	(:dashes (:pointer :double))
	(:num-dashes size-t)
	(:dash-phase :double))

(cffi:defcfun ("uiDrawNewPath" %draw-new-path) :pointer
  (fill-mode %draw-fill-mode))

(cffi:defcfun ("uiDrawFreePath" %draw-free-path) :void
  (p :pointer))

(cffi:defcfun ("uiDrawPathNewFigure" %draw-path-new-figure) :void
  (p ui-type)
  (x :double)
  (y :double))

(cffi:defcfun ("uiDrawPathNewFigureWithArc" %draw-path-new-figure-with-arc) :void
  (p ui-type)
  (x-center :double)
  (y-center :double)
  (radius :double)
  (start-angle :double)
  (sweep :double)
  (negative (:boolean :int)))

(cffi:defcfun ("uiDrawPathLineTo" %draw-path-line-to) :void
  (p ui-type)
  (x :double)
  (y :double))

(cffi:defcfun ("uiDrawPathArcTo" %draw-path-arc-to) :void
  (p ui-type)
  (x-center :double)
  (y-center :double)
  (radius :double)
  (start-angle :double)
  (sweep :double)
  (negative :int))

(cffi:defcfun ("uiDrawPathBezierTo" %draw-path-bezier-to) :void
  (p ui-type)
  (c1x :double)
  (c1y :double)
  (c2x :double)
  (c2y :double)
  (end-x :double)
  (end-y :double))

(cffi:defcfun ("uiDrawPathCloseFigure" %draw-path-close-figure) :void
  (p ui-type))

(cffi:defcfun ("uiDrawPathAddRectangle" %draw-path-add-rectangle) :void
  (p ui-type)
  (x :double)
  (y :double)
  (width :double)
  (height :double))

(cffi:defcfun ("uiDrawPathEnd" %draw-path-end) :void
  (p ui-type))

(cffi:defcfun ("uiDrawStroke" %draw-stroke) :void
  (c draw-context-type)
  (path ui-type)
  (b (:pointer (:struct %draw-brush)))
  (p (:pointer (:struct %draw-stroke-params))))

(cffi:defcfun ("uiDrawFill" %draw-fill) :void
  (c draw-context-type)
  (path ui-type)
  (b brush-type))

(cffi:defcfun ("uiDrawMatrixSetIdentity" %draw-matrix-set-identity) :void
  (m ui-type))

(cffi:defcfun ("uiDrawMatrixTranslate" %draw-matrix-translate) :void
  (m ui-type)
  (x :double)
  (y :double))

(cffi:defcfun ("uiDrawMatrixScale" %draw-matrix-scale) :void
  (m ui-type)
  (x-center :double)
  (y-center :double)
  (x :double)
  (y :double))

(cffi:defcfun ("uiDrawMatrixRotate" %draw-matrix-rotate) :void
  (m ui-type)
  (x :double)
  (y :double)
  (amount :double))

(cffi:defcfun ("uiDrawMatrixSkew" %draw-matrix-skew) :void
  (m ui-type)
  (x :double)
  (y :double)
  (xamount :double)
  (yamount :double))

(cffi:defcfun ("uiDrawMatrixMultiply" %draw-matrixMultiply) :void
  (dest ui-type)
  (src ui-type))

(cffi:defcfun ("uiDrawMatrixInvertible" %draw-matrix-invertible) (:boolean :int)
  (m ui-type))

(cffi:defcfun ("uiDrawMatrixInvert" %draw-matrix-invert) (:boolean :int)
  (m ui-type))

(cffi:defcfun ("uiDrawMatrixTransformPoint" %draw-matrix-transform-point) :void
  (m ui-type)
  (x (:pointer :double))
  (y (:pointer :double)))

(cffi:defcfun ("uiDrawMatrixTransformSize" %draw-matrix-transform-size) :void
  (m ui-type)
  (x (:pointer :double))
  (y (:pointer :double)))

(cffi:defcfun ("uiDrawTransform" %draw-transform) :void
  (c draw-context-type)
  (m ui-type))

(cffi:defcfun ("uiDrawClip" %draw-clip) :void
  (c draw-context-type)
  (path ui-type))

(cffi:defcfun ("uiDrawSave" %draw-save) :void
  (c :pointer))

(cffi:defcfun ("uiDrawRestore" %draw-restore) :void
  (c :pointer))

(cffi:defcfun ("uiFreeAttribute" %free-attribute) :void
  (a :pointer))

(cffi:defcfun ("uiAttributeGetType" %attribute-get-type) %attribute-type
  (a :pointer))

(cffi:defcfun ("uiNewFamilyAttribute" %new-family-attribute) :pointer
  (family :string))

(cffi:defcfun ("uiAttributeFamily" %attribute-family) :string
  (a :pointer))

(cffi:defcfun ("uiNewSizeAttribute" %new-size-attribute) :pointer
  (size :double))

(cffi:defcfun ("uiAttributeSize" %attribute-size) :double
  (a :pointer))

(cffi:defcfun ("uiNewWeightAttribute" %new-weight-attribute) :pointer
  (weight %text-weight))

(cffi:defcfun ("uiAttributeWeight" %attribute-weight) %text-weight
  (a :pointer))

(cffi:defcfun ("uiNewItalicAttribute" %new-italic-attribute) :pointer
  (italic %text-italic))

(cffi:defcfun ("uiAttributeItalic" %attribute-italic) %text-italic
  (a :pointer))

(cffi:defcfun ("uiNewStretchAttribute" %new-stretch-attribute) :pointer
  (stretch %text-stretch))

(cffi:defcfun ("uiAttributeStretch" %attribute-stretch) %text-stretch
  (a :pointer))

(cffi:defcfun ("uiNewColorAttribute" %new-color-attribute) :pointer
  (r :double)
  (g :double)
  (b :double)
  (a :double))

(cffi:defcfun ("uiAttributeColor" %attribute-color) :void
  (a :pointer)
  (r (:pointer :double))
  (g (:pointer :double))
  (b (:pointer :double))
  (alpha (:pointer :double)))

(cffi:defcfun ("uiNewBackgroundAttribute" %new-background-attribute) :pointer
  (r :double)
  (g :double)
  (b :double)
  (a :double))

(cffi:defcfun ("uiNewUnderlineAttribute" %new-underline-attribute) :pointer
  (u %underline))

(cffi:defcfun ("uiAttributeUnderline" %attribute-underline) :unsigned-int
  (a :pointer))

(cffi:defcfun ("uiNewUnderlineColorAttribute" %new-underline-color-attribute) :pointer
  (u %underline-color)
  (r :double)
  (g :double)
  (b :double)
  (a :double))

(cffi:defcfun ("uiAttributeUnderlineColor" %attribute-underline-color) :void
  (a :pointer)
  (u (:pointer %underline-color))
  (r (:pointer :double))
  (g (:pointer :double))
  (b (:pointer :double))
  (alpha (:pointer :double)))

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
  (value :uint32))

(cffi:defcfun ("uiOpenTypeFeaturesRemove" %open-type-features-remove) :void
  (otf :pointer)
  (a :char)
  (b :char)
  (c :char)
  (d :char))

(cffi:defcfun ("uiOpenTypeFeaturesGet" %open-type-features-get) (:boolean :int)
  (otf :pointer)
  (a :char)
  (b :char)
  (c :char)
  (d :char)
  (value (:pointer :uint32)))

(cffi:defcfun ("uiOpenTypeFeaturesForEach" %open-type-features-for-each) :void
  (otf :pointer)
  (f :pointer)
  (data :pointer))

(cffi:defcfun ("uiNewFeaturesAttribute" %new-features-attribute) :pointer
  (otf :pointer))

(cffi:defcfun ("uiAttributeFeatures" %attribute-features) :pointer
  (a :pointer))

(cffi:defcfun ("uiNewAttributedString" %new-attributed-string) :pointer
  (initial-string :string))

(cffi:defcfun ("uiFreeAttributedString" %free-attributed-string) :void
  (s :pointer))

(cffi:defcfun ("uiAttributedStringString" %attributed-string-string) :string
  (s ui-type))

(cffi:defcfun ("uiAttributedStringLen" %attributed-string-len) size-t
  (s ui-type))

(cffi:defcfun ("uiAttributedStringAppendUnattributed" %attributed-string-append-unattributed) :void
  (s ui-type)
  (str :string))

(cffi:defcfun ("uiAttributedStringInsertAtUnattributed" %attributed-string-insert-unattributed) :void
  (s ui-type)
  (str :string)
  (at size-t))

(cffi:defcfun ("uiAttributedStringDelete" %attributed-string-delete) :void
  (s ui-type)
  (start size-t)
  (end size-t))

(cffi:defcfun ("uiAttributedStringSetAttribute" %attributed-string-set-attribute) :void
  (s ui-type)
  (a :pointer)
  (start size-t)
  (end size-t))

(cffi:defcfun ("uiAttributedStringForEachAttribute" %attributed-string-for-each-attribute) :void
  (s ui-type)
  (f :pointer)
  (data :pointer))

(cffi:defcfun ("uiAttributedStringNumGraphemes" %attributed-string-num-graphemes) size-t
  (s ui-type))

(cffi:defcfun ("uiAttributedStringByteIndexToGrapheme" %attributed-string-byte-index-to-grapheme) size-t
  (s ui-type)
  (pos :pointer))

(cffi:defcfun ("uiAttributedStringGraphemeToByteIndex" %attributed-string-grapheme-to-byte-index) size-t
  (s ui-type)
  (pos :pointer))

(cffi:defcstruct %font-descriptor
	(:family :string)
	(:size :double)
	(:weight %text-weight)
	(:italic %text-italic)
	(:stretch %text-stretch))

(cffi:defcstruct %draw-text-layout-params
	(string ui-type)
	(default-font (:pointer (:struct %font-descriptor)))
	(width :double)
	(align %draw-text-align))

(cffi:defcfun ("uiDrawNewTextLayout" %draw-new-text-layout) :pointer
  (params (:pointer (:struct %draw-text-layout-params))))

(cffi:defcfun ("uiDrawFreeTextLayout" %draw-free-text-layout) :void
  (tl :pointer))

(cffi:defcfun ("uiDrawText" %draw-text) :void
  (c draw-context-type)
  (tl ui-type)
  (x :double)
  (y :double))

(cffi:defcfun ("uiDrawTextLayoutExtents" %draw-text-layout-extents) :void
  (tl ui-type)
  (width (:pointer :double))
  (height (:pointer :double)))

(cffi:defcfun ("uiFontButtonFont" %font-button-font) :void
  (b ui-type)
  (desc (:pointer (:struct %font-descriptor))))

(cffi:defcfun ("uiFontButtonOnChanged" %font-button-on-changed) :void
  (b ui-type)
  (f :pointer)
  (data :pointer))

(cffi:defcfun ("uiNewFontButton" %new-font-button) :pointer)

(cffi:defcfun ("uiFreeFontButtonFont" %free-font-button-font) :void
  (desc (:pointer (:struct %font-descriptor))))

(cffi:defbitfield (%modifiers :unsigned-int)
	:ctrl
	:alt
	:shift
	:super)

(cffi:defcstruct %area-mouse-event
	(:x :double)
	(:y :double)
	(:area-width :double)
	(:area-height :double)
	(:down (:boolean :int))
	(:up (:boolean :int))
	(:count :int)
	(:modifiers %modifiers)
	(:held1to64 :uint64))

(cffi:defcstruct %area-key-event
	(:key :char)
	(:ext-key %ext-key)
	(:modifier %modifiers)
	(:modifiers %modifiers)
	(:up (:boolean :int)))

(cffi:defcfun ("uiColorButtonColor" %color-button-color) :void
  (button ui-type)
  (r (:pointer :double))
  (g (:pointer :double))
  (b (:pointer :double))
  (a (:pointer :double)))

(cffi:defcfun ("uiColorButtonSetColor" %color-button-set-color) :void
  (button ui-type)
  (r :double)
  (g :double)
  (b :double)
  (a :double))

(cffi:defcfun ("uiColorButtonOnChanged" %color-button-on-changed) :void
  (button ui-type)
  (f :pointer)
  (data :pointer))

(cffi:defcfun ("uiNewColorButton" %new-color-button) :pointer)

(cffi:defcfun ("uiFormAppend" %form-append) :void
  (f ui-type)
  (label :string)
  (c ui-type)
  (stretchy (:boolean :int)))

(cffi:defcfun ("uiFormDelete" %form-delete) :void
  (f ui-type)
  (index :int))

(cffi:defcfun ("uiFormPadded" %form-padded) (:boolean :int)
  (f ui-type))

(cffi:defcfun ("uiFormSetPadded" %form-set-padded) :void
  (f ui-type)
  (padded (:boolean :int)))

(cffi:defcfun ("uiNewForm" %new-form) :pointer)

(cffi:defcfun ("uiGridAppend" %grid-append) :void
  (g ui-type)
  (c ui-type)
  (left :int)
  (top :int)
  (xspan :int)
  (yspan :int)
  (hexpand (:boolean :int))
  (halign %align)
  (vexpand (:boolean :int))
  (valign %align))

(cffi:defcfun ("uiGridInsertAt" %grid-insert-at) :void
  (g ui-type)
  (c ui-type)
  (existing ui-type)
  (at %at)
  (xspan :int)
  (yspan :int)
  (hexpand (:boolean :int))
  (halign %align)
  (vexpand (:boolean :int))
  (valign %align))

(cffi:defcfun ("uiGridPadded" %grid-padded) (:boolean :int)
  (g ui-type))

(cffi:defcfun ("uiGridSetPadded" %grid-set-padded) :void
  (g ui-type)
  (padded (:boolean :int)))

(cffi:defcfun ("uiNewGrid" %new-grid) :pointer)

(cffi:defcfun ("uiNewImage" %new-image) :pointer
  (width :double)
  (height :double))

(cffi:defcfun ("uiFreeImage" %free-image) :void
  (i :pointer))

(cffi:defcfun ("uiImageAppend" %image-append) :void
  (i :pointer)
  (pixels :pointer)
  (pixel-width :int)
  (pixel-height :int)
  (byte-stride :int))

(cffi:defcfun ("uiFreeTableValue" %free-table-value) :void
  (v :pointer))

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
	(num-columns :pointer)
	(column-type :pointer)
	(num-rows :pointer)
	(cell-value :pointer)
	(set-cell-value :pointer))

(cffi:defcfun ("uiNewTableModel" %new-table-model) :pointer
  (mh :pointer))

(cffi:defcfun ("uiFreeTableModel" %free-table-model) :void
  (m :pointer))

(cffi:defcfun ("uiTableModelRowInserted" %table-model-row-inserted) :void
  (m :pointer)
  (new-index :int))

(cffi:defcfun ("uiTableModelRowChanged" %table-model-row-changed) :void
  (m :pointer)
  (index :int))

(cffi:defcfun ("uiTableModelRowDeleted" %table-model-row-deleted) :void
  (m :pointer)
  (old-index :int))

(cl:defconstant %table-model-column-never-editable -1)

(cl:defconstant %table-model-column-always-editable -2)

(cffi:defcstruct %table-text-column-optional-params
	(color-model-column :int))

(cffi:defcstruct %table-params
	(model :pointer)
	(row-background-color-model-column :int))

(cffi:defcfun ("uiTableAppendTextColumn" %table-append-text-column) :void
  (t_arg0 :pointer)
  (name :string)
  (text-model-column :int)
  (text-editable-model-column :int)
  (text-params :pointer))

(cffi:defcfun ("uiTableAppendImageColumn" %table-append-image-column) :void
  (t_arg0 :pointer)
  (name :string)
  (image-model-column :int))

(cffi:defcfun ("uiTableAppendImageTextColumn" %table-append-image-text-column) :void
  (t_arg0 :pointer)
  (name :string)
  (image-model-column :int)
  (text-model-column :int)
  (text-editable-model-column :int)
  (text-params :pointer))

(cffi:defcfun ("uiTableAppendCheckboxColumn" %table-append-checkboxColumn) :void
  (t_arg0 :pointer)
  (name :string)
  (checkbox-model-column :int)
  (checkbox-editable-model-column :int))

(cffi:defcfun ("uiTableAppendCheckboxTextColumn" %table-append-checkbox-textColumn) :void
  (t_arg0 :pointer)
  (name :string)
  (checkbox-model-column :int)
  (checkbox-editable-model-column :int)
  (text-model-column :int)
  (text-editable-model-column :int)
  (text-params :pointer))

(cffi:defcfun ("uiTableAppendProgressBarColumn" %table-append-progress-bar-column) :void
  (t_arg0 :pointer)
  (name :string)
  (progress-model-column :int))

(cffi:defcfun ("uiTableAppendButtonColumn" %table-append-button-column) :void
  (t_arg0 :pointer)
  (name :string)
  (button-model-column :int)
  (button-clickable-model-column :int))

(cffi:defcfun ("uiNewTable" %new-table) :pointer
  (params :pointer))
