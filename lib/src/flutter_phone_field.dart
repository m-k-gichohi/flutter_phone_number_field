import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class FlutterPhoneField extends FormBuilderFieldDecoration<String> {
  final TextInputType keyboardType;
  final bool obscureText;
  final TextStyle? style;
  final TextEditingController? controller;
  final TextCapitalization textCapitalization;
  final TextInputAction? textInputAction;
  final StrutStyle? strutStyle;
  final TextDirection? textDirection;
  final TextAlign textAlign;
  final bool autofocus;
  final bool autocorrect;
  final MaxLengthEnforcement maxLengthEnforcement;
  final int? maxLength;
  final VoidCallback? onEditingComplete;
  final ValueChanged<String>? onFieldSubmitted;
  final List<TextInputFormatter>? inputFormatters;
  final double cursorWidth;
  final Radius? cursorRadius;
  final Color? cursorColor;
  final Brightness? keyboardAppearance;
  final EdgeInsets scrollPadding;
  final bool enableInteractiveSelection;
  final InputCounterWidgetBuilder? buildCounter;
  final bool expands;
  final int? minLines;
  final bool? showCursor;
  final VoidCallback? onTap;

  // For country dialog
  final String? searchText;
  final EdgeInsets? titlePadding;
  final bool? isSearchable;
  final Text? dialogTitle;

  /// Default country iso code selected in dropdown
  ///
  /// By default `US`
  final String defaultSelectedCountryIsoCode;
  final List<String>? priorityListByIsoCode;
  final List<String>? countryFilterByIsoCode;
  final TextStyle? dialogTextStyle;
  final bool isCupertinoPicker;
  final double? cupertinoPickerSheetHeight;
  final TextAlignVertical? textAlignVertical;

  ///The [itemExtent] of [CupertinoPicker]
  /// The uniform height of all children.
  ///
  /// All children will be given the [BoxConstraints] to match this exact
  /// height. Must not be null and must be positive.
  // final double pickerItemHeight;

  // ///The height of the picker
  // final double pickerSheetHeight;

  ///The TextStyle that is applied to Text widgets inside item
  final TextStyle? textStyle;

  /// Relative ratio between this picker's height and the simulated cylinder's diameter.
  ///
  /// Smaller values creates more pronounced curvatures in the scrollable wheel.
  ///
  /// For more details, see [ListWheelScrollView.diameterRatio].
  ///
  /// Must not be null and defaults to `1.1` to visually mimic iOS.
  final double diameterRatio;

  /// Background color behind the children.
  ///
  /// Defaults to a gray color in the iOS color palette.
  ///
  /// This can be set to null to disable the background painting entirely; this
  /// is mildly more efficient than using [Colors.transparent].
  final Color backgroundColor;

  /// {@macro flutter.rendering.wheelList.offAxisFraction}
  final double offAxisFraction;

  /// {@macro flutter.rendering.wheelList.useMagnifier}
  final bool useMagnifier;

  /// {@macro flutter.rendering.wheelList.magnification}
  final double magnification;

  // final Country? initialCountry;

  /// A [FixedExtentScrollController] to read and control the current item.
  ///
  /// If null, an implicit one will be created internally.
  final FixedExtentScrollController? scrollController;

  /// [Comparator] to be used in sort of country list
  // final Comparator<Country>? sortComparator;

  /// List of countries that are placed on top
  // final List<Country>? priorityList;

  ///Callback that is called with selected item of type Country which returns a
  ///Widget to build list view item inside dialog

  /// Set a custom widget in left side of flag, (country selector)
  ///
  /// By default this widget is `const Icon(Icons.arrow_drop_down)`
  final Widget? iconSelector;

  /// View to display when search found no result
  final Widget? searchEmptyView;

  /// Country picker button
  final Widget Function(
    Widget flag,
    String countryCode,
  )? countryPicker;

  /// Creates field for international phone number input.
  FlutterPhoneField({
    super.key,
    required super.name,
    super.validator,
    super.initialValue,
    super.decoration,
    super.onChanged,
    super.valueTransformer,
    super.enabled,
    super.onSaved,
    super.autovalidateMode,
    super.onReset,
    super.focusNode,
    this.obscureText = false,
    this.textCapitalization = TextCapitalization.none,
    this.scrollPadding = const EdgeInsets.all(20.0),
    this.enableInteractiveSelection = true,
    this.maxLengthEnforcement = MaxLengthEnforcement.enforced,
    this.textAlign = TextAlign.start,
    this.autofocus = false,
    this.autocorrect = true,
    this.cursorWidth = 2.0,
    this.keyboardType = TextInputType.phone,
    this.style,
    this.controller,
    this.textInputAction,
    this.strutStyle,
    this.textDirection,
    this.maxLength,
    this.onEditingComplete,
    this.onFieldSubmitted,
    this.inputFormatters,
    this.cursorRadius,
    this.cursorColor,
    this.keyboardAppearance,
    this.buildCounter,
    this.expands = false,
    this.minLines,
    this.showCursor,
    this.onTap,
    this.searchText,
    this.titlePadding,
    this.dialogTitle,
    this.isSearchable,
    this.defaultSelectedCountryIsoCode = 'US',
    this.priorityListByIsoCode,
    this.countryFilterByIsoCode,
    this.dialogTextStyle,
    this.isCupertinoPicker = false,
    this.cupertinoPickerSheetHeight,
    this.textAlignVertical,
    this.textStyle,
    this.diameterRatio = 1.35,
    this.backgroundColor = const Color(0xFFD2D4DB),
    this.offAxisFraction = 0.0,
    this.useMagnifier = false,
    this.magnification = 1.0,
    this.scrollController,
    this.iconSelector,
    this.countryPicker,
    this.searchEmptyView,
  })  : assert(initialValue == null || controller == null),
        super(
          builder: (FormFieldState<String?> field) {
            final state = field as _FlutterPhoneFieldState;

            return InputDecorator(
              decoration: state.decoration,
              child: Row(
                children: <Widget>[
                  const Icon(Icons.arrow_drop_down),
                  state._openCountryPickerDialog(),
                  Expanded(
                    child: TextField(
                      enabled: state.enabled,
                      style: style,
                      focusNode: state.effectiveFocusNode,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        errorBorder: InputBorder.none,
                        hintText: decoration.hintText,
                        hintStyle: decoration.hintStyle,
                      ),
                      onChanged: (value) {
                        final phoneText =
                            '${state._selectedDialogCountry}$value';

                        state.setValue(phoneText);
                      },
                      maxLines: 1,
                      keyboardType: keyboardType,
                      obscureText: obscureText,
                      onEditingComplete: onEditingComplete,
                      controller: state._effectiveController,
                      autocorrect: autocorrect,
                      autofocus: autofocus,
                      buildCounter: buildCounter,
                      cursorColor: cursorColor,
                      cursorRadius: cursorRadius,
                      cursorWidth: cursorWidth,
                      enableInteractiveSelection: enableInteractiveSelection,
                      maxLength: maxLength,
                      inputFormatters: inputFormatters,
                      keyboardAppearance: keyboardAppearance,
                      maxLengthEnforcement: maxLengthEnforcement,
                      scrollPadding: scrollPadding,
                      textAlign: textAlign,
                      textCapitalization: textCapitalization,
                      textDirection: textDirection,
                      textInputAction: textInputAction,
                      strutStyle: strutStyle,
                      //readOnly: state.readOnly, -- Does this need to be exposed?
                      expands: expands,
                      minLines: minLines,
                      showCursor: showCursor,
                      onTap: onTap,
                      textAlignVertical: textAlignVertical,
                    ),
                  ),
                ],
              ),
            );
          },
        );

  @override
  FormBuilderFieldDecorationState<FlutterPhoneField, String>
      createState() => _FlutterPhoneFieldState();
}

class _FlutterPhoneFieldState
    extends FormBuilderFieldDecorationState<FlutterPhoneField, String> {
  late TextEditingController _effectiveController;
  late String _selectedDialogCountry;
  late String _defaultSelectedCountryIsoCode;
  late List<String> _priorityListByIsoCode;

  String get fullNumber {
    // When there is no phone number text, the field is empty -- the country
    // prefix is only prepended when a phone number is specified.
    final phoneText = _effectiveController.text;
    final phoneNumber =
        phoneText.isNotEmpty ? '$_selectedDialogCountry$phoneText' : phoneText;

    return phoneNumber;
  }

  @override
  void initState() {
    super.initState();
    _effectiveController = widget.controller ?? TextEditingController();

    _defaultSelectedCountryIsoCode = widget.defaultSelectedCountryIsoCode;
    _priorityListByIsoCode = widget.priorityListByIsoCode!;
  }

  @override
  void dispose() {
    if (null == widget.controller) {
      _effectiveController.dispose();
    }
    super.dispose();
  }

  @override
  void reset() {
    super.reset();
    _effectiveController = widget.controller ?? TextEditingController();
  }

  _openCountryPickerDialog() {
    return CountryCodePicker(
        onChanged: (value) {
          setState(() => _selectedDialogCountry = value.dialCode!);
          didChange(fullNumber);
        },
        // Initial selection and favorite can be one of code ('IT') OR dial_code('+39')
        initialSelection: _defaultSelectedCountryIsoCode,
        favorite: _priorityListByIsoCode,
        showFlagDialog: true,
        onInit: (code) => {
              setValue(code!.dialCode),
              _selectedDialogCountry = code.dialCode!,
              debugPrint("on init ${code.name} ${code.dialCode} ${code.name}"),
            });
  }
}
