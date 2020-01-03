(in-package #:ui)

(cffi:define-foreign-library libui
  (:darwin "libui.dylib")
  (:unix "libui.so")
  (t (:default "libui.dll")))

(cffi:use-foreign-library libui)

(cffi:define-foreign-type control-pointer ()
  ()
  (:actual-type :pointer)
  (:simple-parser control-pointer))

(cffi:define-foreign-type button-pointer ()
  ()
  (:actual-type :pointer)
  (:simple-parser button-pointer))

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

(cffi::define-foreign-type double-type ()
  ()
  (:actual-type :double)
  (:simple-parser double-type))

(defmethod cffi:translate-to-foreign (value (type double-type))
  (coerce value 'double-float))

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
  (arg0 control-pointer))

; (cffi:defcfun ("uiControlHandle" %control-handle) :pointer
;   (arg0 :pointer))

(cffi:defcfun ("uiControlParent" %control-parent) :pointer
  (arg0 control-pointer))

(cffi:defcfun ("uiControlSetParent" %control-set-parent) :void
  (arg0 control-pointer)
  (arg1 control-pointer))

(cffi:defcfun ("uiControlToplevel" %control-toplevel) (:boolean :int)
  (arg0 control-pointer))

(cffi:defcfun ("uiControlVisible" %control-visible) (:boolean :int)
  (arg0 control-pointer))

(cffi:defcfun ("uiControlShow" %control-show) :void
  (arg0 control-pointer))

(cffi:defcfun ("uiControlHide" %control-hide) :void
  (arg0 control-pointer))

(cffi:defcfun ("uiControlEnabled" %control-enabled) (:boolean :int)
  (arg0 control-pointer))

(cffi:defcfun ("uiControlEnable" %control-enable) :void
  (arg0 control-pointer))

(cffi:defcfun ("uiControlDisable" %control-disable) :void
  (arg0 control-pointer))

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
  (w control-pointer))

(cffi:defcfun ("uiWindowSetTitle" %window-set-title) :void
  (w control-pointer)
  (title :string))

(cffi:defcfun ("uiWindowContentSize" %window-content-size) :void
  (w control-pointer)
  (width (:pointer :int))
  (height (:pointer :int)))

(cffi:defcfun ("uiWindowSetContentSize" %window-set-content-size) :void
  (w control-pointer)
  (width :int)
  (height :int))

(cffi:defcfun ("uiWindowFullscreen" %window-fullscreen) (:boolean :int)
  (w control-pointer))

(cffi:defcfun ("uiWindowSetFullscreen" %window-set-fullscreen) :void
  (w control-pointer)
  (fullscreen (:boolean :int)))

(cffi:defcfun ("uiWindowOnContentSizeChanged" %window-on-content-size-changed) :void
  (w control-pointer)
  (f :pointer)
  (data :pointer))

(cffi:defcfun ("uiWindowOnClosing" %window-on-closing) :void
  (w control-pointer)
  (f :pointer)
  (data :pointer))

(cffi:defcfun ("uiWindowBorderless" %window-borderless) (:boolean :int)
  (w control-pointer))

(cffi:defcfun ("uiWindowSetBorderless" %window-set-borderless) :void
  (w control-pointer)
  (borderless (:boolean :int)))

(cffi:defcfun ("uiWindowSetChild" %window-set-child) :void
  (w control-pointer)
  (child control-pointer))

(cffi:defcfun ("uiWindowMargined" %window-margined) (:boolean :int)
  (w control-pointer))

(cffi:defcfun ("uiWindowSetMargined" %window-set-margined) :void
  (w control-pointer)
  (margined (:boolean :int)))

(cffi:defcfun ("uiNewWindow" %new-window) :pointer
  (title :string)
  (width :int)
  (height :int)
  (hasMenubar (:boolean :int)))

(cffi:defcfun ("uiButtonText" %button-text) :string
  (b control-pointer))

(cffi:defcfun ("uiButtonSetText" %button-set-text) :void
  (b control-pointer)
  (text :string))

(cffi:defcfun ("uiButtonOnClicked" %button-on-clicked) :void
  (b control-pointer)
  (f :pointer)
  (data :pointer))

(cffi:defcfun ("uiNewButton" %new-button) :pointer
  (text :string))

(cffi:defcfun ("uiBoxAppend" %box-append) :void
  (b control-pointer)
  (child control-pointer)
  (stretchy (:boolean :int)))

(cffi:defcfun ("uiBoxDelete" %box-delete) :void
  (b control-pointer)
  (index :int))

(cffi:defcfun ("uiBoxPadded" %box-padded) (:boolean :int)
  (b control-pointer))

(cffi:defcfun ("uiBoxSetPadded" %box-set-padded) :void
  (b control-pointer)
  (padded (:boolean :int)))

(cffi:defcfun ("uiNewHorizontalBox" %new-horizontal-box) :pointer)

(cffi:defcfun ("uiNewVerticalBox" %new-vertical-box) :pointer)

(cffi:defcfun ("uiCheckboxText" %checkbox-text) :string
  (c control-pointer))

(cffi:defcfun ("uiCheckboxSetText" %checkbox-set-text) :void
  (c control-pointer)
  (text :string))

(cffi:defcfun ("uiCheckboxOnToggled" %checkbox-on-toggled) :void
  (c control-pointer)
  (f :pointer)
  (data :pointer))

(cffi:defcfun ("uiCheckboxChecked" %checkbox-checked) (:boolean :int)
  (c control-pointer))

(cffi:defcfun ("uiCheckboxSetChecked" %checkbox-set-checked) :void
  (c control-pointer)
  (checked (:boolean :int)))

(cffi:defcfun ("uiNewCheckbox" %new-checkbox) :pointer
  (text :string))

(cffi:defcfun ("uiEntryText" %entry-text) :string
  (e control-pointer))

(cffi:defcfun ("uiEntrySetText" %entry-set-text) :void
  (e control-pointer)
  (text :string))

(cffi:defcfun ("uiEntryOnChanged" %entry-on-changed) :void
  (e control-pointer)
  (f :pointer)
  (data :pointer))

(cffi:defcfun ("uiEntryReadOnly" %entry-read-only) (:boolean :int)
  (e control-pointer))

(cffi:defcfun ("uiEntrySetReadOnly" %entry-set-read-only) :void
  (e control-pointer)
  (readonly (:boolean :int)))

(cffi:defcfun ("uiNewEntry" %new-entry) :pointer)

(cffi:defcfun ("uiNewPasswordEntry" %new-password-entry) :pointer)

(cffi:defcfun ("uiNewSearchEntry" %new-search-entry) :pointer)

(cffi:defcfun ("uiLabelText" %label-text) :string
  (l control-pointer))

(cffi:defcfun ("uiLabelSetText" %label-set-text) :void
  (l control-pointer)
  (text :string))

(cffi:defcfun ("uiNewLabel" %new-label) :pointer
  (text :string))

(cffi:defcfun ("uiTabAppend" %tab-append) :void
  (t_arg0 control-pointer)
  (name :string)
  (c control-pointer))

(cffi:defcfun ("uiTabInsertAt" %tab-insert-at) :void
  (t_arg0 control-pointer)
  (name :string)
  (before :int)
  (c control-pointer))

(cffi:defcfun ("uiTabDelete" %tab-delete) :void
  (t_arg0 control-pointer)
  (index :int))

(cffi:defcfun ("uiTabNumPages" %tab-num-pages) :int
  (t_arg0 control-pointer))

(cffi:defcfun ("uiTabMargined" %tab-margined) (:boolean :int)
  (t_arg0 control-pointer)
  (page :int))

(cffi:defcfun ("uiTabSetMargined" %tab-set-margined) :void
  (t_arg0 control-pointer)
  (page :int)
  (margined (:boolean :int)))

(cffi:defcfun ("uiNewTab" %new-tab) :pointer)

(cffi:defcfun ("uiGroupTitle" %group-title) :string
  (g control-pointer))

(cffi:defcfun ("uiGroupSetTitle" %group-set-title) :void
  (g control-pointer)
  (title :string))

(cffi:defcfun ("uiGroupSetChild" %group-set-child) :void
  (g control-pointer)
  (c control-pointer))

(cffi:defcfun ("uiGroupMargined" %group-margined) (:boolean :int)
  (g control-pointer))

(cffi:defcfun ("uiGroupSetMargined" %group-set-margined) :void
  (g control-pointer)
  (margined (:boolean :int)))

(cffi:defcfun ("uiNewGroup" %new-group) :pointer
  (title :string))

(cffi:defcfun ("uiSpinboxValue" %spinbox-value) :int
  (s control-pointer))

(cffi:defcfun ("uiSpinboxSetValue" %spinbox-set-value) :void
  (s control-pointer)
  (value :int))

(cffi:defcfun ("uiSpinboxOnChanged" %spinbox-on-changed) :void
  (s control-pointer)
  (f :pointer)
  (data :pointer))

(cffi:defcfun ("uiNewSpinbox" %new-spinbox) :pointer
  (min :int)
  (max :int))

(cffi:defcfun ("uiSliderValue" %slider-value) :int
  (s control-pointer))

(cffi:defcfun ("uiSliderSetValue" %slider-set-value) :void
  (s control-pointer)
  (value :int))

(cffi:defcfun ("uiSliderOnChanged" %slider-on-changed) :void
  (s control-pointer)
  (f :pointer)
  (data :pointer))

(cffi:defcfun ("uiNewSlider" %new-slider) :pointer
  (min :int)
  (max :int))

(cffi:defcfun ("uiProgressBarValue" %progress-bar-value) :int
  (p control-pointer))

(cffi:defcfun ("uiProgressBarSetValue" %progress-bar-set-value) :void
  (p control-pointer)
  (n :int))

(cffi:defcfun ("uiNewProgressBar" %new-progress-bar) :pointer)

(cffi:defcfun ("uiNewHorizontalSeparator" %new-horizontal-separator) :pointer)

(cffi:defcfun ("uiNewVerticalSeparator" %new-vertical-separator) :pointer)

(cffi:defcfun ("uiComboboxAppend" %combobox-append) :void
  (c control-pointer)
  (text :string))

(cffi:defcfun ("uiComboboxSelected" %combobox-selected) :int
  (c control-pointer))

(cffi:defcfun ("uiComboboxSetSelected" %combobox-set-selected) :void
  (c control-pointer)
  (n :int))

(cffi:defcfun ("uiComboboxOnSelected" %combobox-on-selected) :void
  (c control-pointer)
  (f :pointer)
  (data :pointer))

(cffi:defcfun ("uiNewCombobox" %new-combobox) :pointer)

(cffi:defcfun ("uiEditableComboboxAppend" %editable-combobox-append) :void
  (c control-pointer)
  (text :string))

(cffi:defcfun ("uiEditableComboboxText" %editable-combobox-text) :string
  (c control-pointer))

(cffi:defcfun ("uiEditableComboboxSetText" %editable-combobox-set-text) :void
  (c control-pointer)
  (text :string))

(cffi:defcfun ("uiEditableComboboxOnChanged" %editable-combobox-on-changed) :void
  (c control-pointer)
  (f :pointer)
  (data :pointer))

(cffi:defcfun ("uiNewEditableCombobox" %new-editable-combobox) :pointer)

(cffi:defcfun ("uiRadioButtonsAppend" %radio-buttons-append) :void
  (r control-pointer)
  (text :string))

(cffi:defcfun ("uiRadioButtonsSelected" %radio-buttons-selected) :int
  (r control-pointer))

(cffi:defcfun ("uiRadioButtonsSetSelected" %radio-buttons-set-selected) :void
  (r control-pointer)
  (n :int))

(cffi:defcfun ("uiRadioButtonsOnSelected" %radio-buttons-on-selected) :void
  (r control-pointer)
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
  (d control-pointer)
  (time (:pointer (:struct %tm))))

(cffi:defcfun ("uiDateTimePickerSetTime" %date-time-picker-set-time) :void
  (d control-pointer)
  (time (:pointer (:struct %tm))))

(cffi:defcfun ("uiDateTimePickerOnChanged" %date-time-picker-on-changed) :void
  (d control-pointer)
  (f :pointer)
  (data :pointer))

(cffi:defcfun ("uiNewDateTimePicker" %new-date-time-picker) :pointer)

(cffi:defcfun ("uiNewDatePicker" %new-date-picker) :pointer)

(cffi:defcfun ("uiNewTimePicker" %new-time-picker) :pointer)

(cffi:defcfun ("uiMultilineEntryText" %multiline-entry-text) :string
  (e control-pointer))

(cffi:defcfun ("uiMultilineEntrySetText" %multiline-entry-set-text) :void
  (e control-pointer)
  (text :string))

(cffi:defcfun ("uiMultilineEntryAppend" %multiline-entry-append) :void
  (e control-pointer)
  (text :string))

(cffi:defcfun ("uiMultilineEntryOnChanged" %multiline-entry-on-changed) :void
  (e control-pointer)
  (f :pointer)
  (data :pointer))

(cffi:defcfun ("uiMultilineEntryReadOnly" %multiline-entry-read-only) (:boolean :int)
  (e control-pointer))

(cffi:defcfun ("uiMultilineEntrySetReadOnly" %multiline-entry-set-read-only) :void
  (e control-pointer)
  (readonly (:boolean :int)))

(cffi:defcfun ("uiNewMultilineEntry" %new-multiline-entry) :pointer)

(cffi:defcfun ("uiNewNonWrappingMultilineEntry" %new-non-wrapping-multiline-entry) :pointer)

(cffi:defcfun ("uiMenuItemEnable" %menu-item-enable) :void
  (m control-pointer))

(cffi:defcfun ("uiMenuItemDisable" %menu-item-disable) :void
  (m control-pointer))

(cffi:defcfun ("uiMenuItemOnClicked" %menu-item-on-clicked) :void
  (m control-pointer)
  (f :pointer)
  (data :pointer))

(cffi:defcfun ("uiMenuItemChecked" %menu-item-checked) (:boolean :int)
  (m control-pointer))

(cffi:defcfun ("uiMenuItemSetChecked" %menu-item-set-checked) :void
  (m control-pointer)
  (checked (:boolean :int)))

(cffi:defcfun ("uiMenuAppendItem" %menu-append-item) :pointer
  (m control-pointer)
  (name :string))

(cffi:defcfun ("uiMenuAppendCheckItem" %menu-append-check-item) :pointer
  (m control-pointer)
  (name :string))

(cffi:defcfun ("uiMenuAppendQuitItem" %menu-append-quit-item) :pointer
  (m control-pointer))

(cffi:defcfun ("uiMenuAppendPreferencesItem" %menu-append-preferences-item) :pointer
  (m control-pointer))

(cffi:defcfun ("uiMenuAppendAboutItem" %menu-append-about-item) :pointer
  (m control-pointer))

(cffi:defcfun ("uiMenuAppendSeparator" %menu-append-separator) :void
  (m control-pointer))

(cffi:defcfun ("uiNewMenu" %new-menu) :pointer
  (name :string))

(cffi:defcfun ("uiOpenFile" open-file) :string
  (parent control-pointer))

(cffi:defcfun ("uiSaveFile" save-file) :string
  (parent control-pointer))

(cffi:defcfun ("uiMsgBox" message-box) :void
  (parent control-pointer)
  (title :string)
  (description :string))

(cffi:defcfun ("uiMsgBoxError" error-box) :void
  (parent control-pointer)
  (title :string)
  (description :string))

(cffi:defcstruct %area-handler
	(:draw :pointer)
	(:mouse-event :pointer)
	(:mouse-crossed :pointer)
	(:drag-broken :pointer)
	(:key-event :pointer))

(cffi:defcfun ("uiAreaSetSize" %area-set-size) :void
  (a control-pointer)
  (width :int)
  (height :int))

(cffi:defcfun ("uiAreaQueueRedrawAll" %area-queue-redraw-all) :void
  (a control-pointer))

(cffi:defcfun ("uiAreaScrollTo" %area-scroll-to) :void
  (a control-pointer)
  (x double-type)
  (y double-type)
  (width double-type)
  (height double-type))

(cffi:defcfun ("uiAreaBeginUserWindowMove" %area-begin-user-window-move) :void
  (a control-pointer))

(cffi:defcfun ("uiAreaBeginUserWindowResize" %area-begin-user-window-resize) :void
  (a control-pointer)
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
	(:red double-type)
	(:green double-type)
	(:blue double-type)
	(:alpha double-type)
	(:x0 double-type)
	(:y0 double-type)
	(:x1 double-type)
	(:y1 double-type)
	(:outer-radius double-type)
	(:stops (:pointer (:struct %draw-brush-gradient-stop)))
	(:num-stops size-t))

(cffi:defcstruct (%draw-stroke-params :class draw-stroke-params-type)
	(:cap %draw-line-cap)
	(:join %draw-line-join)
	(:thickness double-type)
	(:miter-limit double-type)
	(:dashes (:pointer double-type))
	(:num-dashes size-t)
	(:dash-phase double-type))

(cffi:defcfun ("uiDrawNewPath" %draw-new-path) :pointer
  (fill-mode %draw-fill-mode))

(cffi:defcfun ("uiDrawFreePath" %draw-free-path) :void
  (p :pointer))

(cffi:defcfun ("uiDrawPathNewFigure" %draw-path-new-figure) :void
  (p control-pointer)
  (x double-type)
  (y double-type))

(cffi:defcfun ("uiDrawPathNewFigureWithArc" %draw-path-new-figure-with-arc) :void
  (p control-pointer)
  (x-center double-type)
  (y-center double-type)
  (radius double-type)
  (start-angle double-type)
  (sweep double-type)
  (negative (:boolean :int)))

(cffi:defcfun ("uiDrawPathLineTo" %draw-path-line-to) :void
  (p control-pointer)
  (x double-type)
  (y double-type))

(cffi:defcfun ("uiDrawPathArcTo" %draw-path-arc-to) :void
  (p control-pointer)
  (x-center double-type)
  (y-center double-type)
  (radius double-type)
  (start-angle double-type)
  (sweep double-type)
  (negative (:boolean :int)))

(cffi:defcfun ("uiDrawPathBezierTo" %draw-path-bezier-to) :void
  (p control-pointer)
  (c1x double-type)
  (c1y double-type)
  (c2x double-type)
  (c2y double-type)
  (end-x double-type)
  (end-y double-type))

(cffi:defcfun ("uiDrawPathCloseFigure" %draw-path-close-figure) :void
  (p control-pointer))

(cffi:defcfun ("uiDrawPathAddRectangle" %draw-path-add-rectangle) :void
  (p control-pointer)
  (x double-type)
  (y double-type)
  (width double-type)
  (height double-type))

(cffi:defcfun ("uiDrawPathEnd" %draw-path-end) :void
  (p control-pointer))

(cffi:defcfun ("uiDrawStroke" %draw-stroke) :void
  (c draw-context-type)
  (path control-pointer)
  (b brush-type)
  (p stroke-params-type))

(cffi:defcfun ("uiDrawFill" %draw-fill) :void
  (c draw-context-type)
  (path control-pointer)
  (b brush-type))

(cffi:defcfun ("uiDrawMatrixSetIdentity" %draw-matrix-set-identity) :void
  (m control-pointer))

(cffi:defcfun ("uiDrawMatrixTranslate" %draw-matrix-translate) :void
  (m control-pointer)
  (x double-type)
  (y double-type))

(cffi:defcfun ("uiDrawMatrixScale" %draw-matrix-scale) :void
  (m control-pointer)
  (x-center double-type)
  (y-center double-type)
  (x double-type)
  (y double-type))

(cffi:defcfun ("uiDrawMatrixRotate" %draw-matrix-rotate) :void
  (m control-pointer)
  (x double-type)
  (y double-type)
  (amount double-type))

(cffi:defcfun ("uiDrawMatrixSkew" %draw-matrix-skew) :void
  (m control-pointer)
  (x double-type)
  (y double-type)
  (xamount double-type)
  (yamount double-type))

(cffi:defcfun ("uiDrawMatrixMultiply" %draw-matrix-multiply) :void
  (dest control-pointer)
  (src control-pointer))

(cffi:defcfun ("uiDrawMatrixInvertible" %draw-matrix-invertible) (:boolean :int)
  (m control-pointer))

(cffi:defcfun ("uiDrawMatrixInvert" %draw-matrix-invert) (:boolean :int)
  (m control-pointer))

(cffi:defcfun ("uiDrawMatrixTransformPoint" %draw-matrix-transform-point) :void
  (m control-pointer)
  (x (:pointer :double))
  (y (:pointer :double)))

(cffi:defcfun ("uiDrawMatrixTransformSize" %draw-matrix-transform-size) :void
  (m control-pointer)
  (x (:pointer :double))
  (y (:pointer :double)))

(cffi:defcfun ("uiDrawTransform" %draw-transform) :void
  (c draw-context-type)
  (m control-pointer))

(cffi:defcfun ("uiDrawClip" %draw-clip) :void
  (c draw-context-type)
  (path control-pointer))

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
  (size double-type))

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
  (r double-type)
  (g double-type)
  (b double-type)
  (a double-type))

(cffi:defcfun ("uiAttributeColor" %attribute-color) :void
  (a :pointer)
  (r (:pointer :double))
  (g (:pointer :double))
  (b (:pointer :double))
  (alpha (:pointer :double)))

(cffi:defcfun ("uiNewBackgroundAttribute" %new-background-attribute) :pointer
  (r double-type)
  (g double-type)
  (b double-type)
  (a double-type))

(cffi:defcfun ("uiNewUnderlineAttribute" %new-underline-attribute) :pointer
  (u %underline))

(cffi:defcfun ("uiAttributeUnderline" %attribute-underline) :unsigned-int
  (a :pointer))

(cffi:defcfun ("uiNewUnderlineColorAttribute" %new-underline-color-attribute) :pointer
  (u %underline-color)
  (r double-type)
  (g double-type)
  (b double-type)
  (a double-type))

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
  (s control-pointer))

(cffi:defcfun ("uiAttributedStringLen" %attributed-string-len) size-t
  (s control-pointer))

(cffi:defcfun ("uiAttributedStringAppendUnattributed" %attributed-string-append-unattributed) :void
  (s control-pointer)
  (str :string))

(cffi:defcfun ("uiAttributedStringInsertAtUnattributed" %attributed-string-insert-unattributed) :void
  (s control-pointer)
  (str :string)
  (at size-t))

(cffi:defcfun ("uiAttributedStringDelete" %attributed-string-delete) :void
  (s control-pointer)
  (start size-t)
  (end size-t))

(cffi:defcfun ("uiAttributedStringSetAttribute" %attributed-string-set-attribute) :void
  (s control-pointer)
  (a :pointer)
  (start size-t)
  (end size-t))

(cffi:defcfun ("uiAttributedStringForEachAttribute" %attributed-string-for-each-attribute) :void
  (s control-pointer)
  (f :pointer)
  (data :pointer))

(cffi:defcfun ("uiAttributedStringNumGraphemes" %attributed-string-num-graphemes) size-t
  (s control-pointer))

(cffi:defcfun ("uiAttributedStringByteIndexToGrapheme" %attributed-string-byte-index-to-grapheme) size-t
  (s control-pointer)
  (pos :pointer))

(cffi:defcfun ("uiAttributedStringGraphemeToByteIndex" %attributed-string-grapheme-to-byte-index) size-t
  (s control-pointer)
  (pos :pointer))

(cffi:defcstruct %font-descriptor
	(:family :string)
	(:size :double)
	(:weight %text-weight)
	(:italic %text-italic)
	(:stretch %text-stretch))

(cffi:defcstruct %draw-text-layout-params
	(string control-pointer)
	(default-font (:pointer (:struct %font-descriptor)))
	(width :double)
	(align %draw-text-align))

(cffi:defcfun ("uiDrawNewTextLayout" %draw-new-text-layout) :pointer
  (params (:pointer (:struct %draw-text-layout-params))))

(cffi:defcfun ("uiDrawFreeTextLayout" %draw-free-text-layout) :void
  (tl :pointer))

(cffi:defcfun ("uiDrawText" %draw-text) :void
  (c draw-context-type)
  (tl control-pointer)
  (x double-type)
  (y double-type))

(cffi:defcfun ("uiDrawTextLayoutExtents" %draw-text-layout-extents) :void
  (tl control-pointer)
  (width (:pointer :double))
  (height (:pointer :double)))

(cffi:defcfun ("uiFontButtonFont" %font-button-font) :void
  (b control-pointer)
  (desc (:pointer (:struct %font-descriptor))))

(cffi:defcfun ("uiFontButtonOnChanged" %font-button-on-changed) :void
  (b control-pointer)
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
  (button control-pointer)
  (r (:pointer :double))
  (g (:pointer :double))
  (b (:pointer :double))
  (a (:pointer :double)))

(cffi:defcfun ("uiColorButtonSetColor" %color-button-set-color) :void
  (button control-pointer)
  (r double-type)
  (g double-type)
  (b double-type)
  (a double-type))

(cffi:defcfun ("uiColorButtonOnChanged" %color-button-on-changed) :void
  (button control-pointer)
  (f :pointer)
  (data :pointer))

(cffi:defcfun ("uiNewColorButton" %new-color-button) :pointer)

(cffi:defcfun ("uiFormAppend" %form-append) :void
  (f control-pointer)
  (label :string)
  (c control-pointer)
  (stretchy (:boolean :int)))

(cffi:defcfun ("uiFormDelete" %form-delete) :void
  (f control-pointer)
  (index :int))

(cffi:defcfun ("uiFormPadded" %form-padded) (:boolean :int)
  (f control-pointer))

(cffi:defcfun ("uiFormSetPadded" %form-set-padded) :void
  (f control-pointer)
  (padded (:boolean :int)))

(cffi:defcfun ("uiNewForm" %new-form) :pointer)

(cffi:defcfun ("uiGridAppend" %grid-append) :void
  (g control-pointer)
  (c control-pointer)
  (left :int)
  (top :int)
  (xspan :int)
  (yspan :int)
  (hexpand (:boolean :int))
  (halign %align)
  (vexpand (:boolean :int))
  (valign %align))

(cffi:defcfun ("uiGridInsertAt" %grid-insert-at) :void
  (g control-pointer)
  (c control-pointer)
  (existing control-pointer)
  (at %at)
  (xspan :int)
  (yspan :int)
  (hexpand (:boolean :int))
  (halign %align)
  (vexpand (:boolean :int))
  (valign %align))

(cffi:defcfun ("uiGridPadded" %grid-padded) (:boolean :int)
  (g control-pointer))

(cffi:defcfun ("uiGridSetPadded" %grid-set-padded) :void
  (g control-pointer)
  (padded (:boolean :int)))

(cffi:defcfun ("uiNewGrid" %new-grid) :pointer)

(cffi:defcfun ("uiNewImage" %new-image) :pointer
  (width double-type)
  (height double-type))

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
  (r double-type)
  (g double-type)
  (b double-type)
  (a double-type))

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
