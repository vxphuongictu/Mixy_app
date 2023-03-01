/*
 * Custom input from extended_phone_number_input library
 */

import 'package:extended_phone_number_input/consts/enums.dart';
import 'package:extended_phone_number_input/consts/strings_consts.dart';
import 'package:extended_phone_number_input/widgets/country_code_list.dart';
import 'package:extended_phone_number_input/models/country.dart';
import 'package:extended_phone_number_input/phone_number_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:food_e/core/_config.dart' as cnf;
import 'package:food_e/functions/toColor.dart';
import 'package:food_e/widgets/MyText.dart';

class CustomPhoneInput extends StatefulWidget {
  final PhoneNumberInputController? controller;
  final String? initialValue;
  final String? initialCountry;
  final List<String>? excludedCountries;
  final List<String>? includedCountries;
  final bool allowPickFromContacts;
  final Widget? pickContactIcon;
  final void Function(String)? onChanged;
  final String? hint;
  final bool showSelectedFlag;
  final InputBorder? border;
  final String locale;
  final String? searchHint;
  final bool allowSearch;
  final CountryListMode countryListMode;
  final InputBorder? enabledBorder;
  final InputBorder? focusedBorder;
  final ContactsPickerPosition contactsPickerPosition;
  String title;
  double fontSize;
  String titleColor;
  FontWeight titleFontWeight;
  String titleFontFamily;
  TextAlign titleAlign;
  FontStyle titleFontStyle;


  CustomPhoneInput({
    Key? key,
    this.controller,
    this.onChanged,
    this.initialValue,
    this.initialCountry,
    this.excludedCountries,
    this.allowPickFromContacts = true,
    this.pickContactIcon,
    this.includedCountries,
    this.hint,
    this.showSelectedFlag = true,
    this.border,
    this.locale = 'en',
    this.searchHint,
    this.allowSearch = true,
    this.countryListMode = CountryListMode.bottomSheet,
    this.enabledBorder,
    this.focusedBorder,
    this.contactsPickerPosition = ContactsPickerPosition.suffix,
    this.title="",
    this.fontSize = cnf.input_text_fontSize,
    this.titleColor=cnf.colorMainStreamBlue,
    this.titleFontWeight=FontWeight.w400,
    this.titleFontFamily="Bebas Neue",
    this.titleAlign = TextAlign.left,
    this.titleFontStyle = FontStyle.normal,
  }) : super(key: key);

  @override
  _CountryCodePickerState createState() => _CountryCodePickerState();
}

class _CountryCodePickerState extends State<CustomPhoneInput> {
  late PhoneNumberInputController _phoneNumberInputController;
  late TextEditingController _phoneNumberTextFieldController;
  late Future _initFuture;
  Country? _selectedCountry;

  @override
  void initState() {
    if (widget.controller == null) {
      _phoneNumberInputController = PhoneNumberInputController(
        context,
      );
    } else {
      _phoneNumberInputController = widget.controller!;
    }
    _initFuture = _init();
    _phoneNumberInputController.addListener(_refresh);
    _phoneNumberTextFieldController = TextEditingController();
    super.initState();
  }

  Future _init() async {
    await _phoneNumberInputController.init(
        initialCountryCode: widget.initialCountry,
        excludeCountries: widget.excludedCountries,
        includeCountries: widget.includedCountries,
        initialPhoneNumber: widget.initialValue,
        locale: widget.locale);
  }

  void _refresh() {
    _phoneNumberTextFieldController.value = TextEditingValue(
        text: _phoneNumberInputController.phoneNumber,
        selection: TextSelection(
            baseOffset: _phoneNumberInputController.phoneNumber.length,
            extentOffset: _phoneNumberInputController.phoneNumber.length));

    setState(() {
      _selectedCountry = _phoneNumberInputController.selectedCountry;
    });
    if (widget.onChanged != null) {
      widget.onChanged!(_phoneNumberInputController.fullPhoneNumber);
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (this.widget.title != "") Container(
          margin: const EdgeInsets.only(left: cnf.input_padding_left_text, bottom: 10.0),
          child: MyText(
            text: "${this.widget.title}",
            fontSize: this.widget.fontSize,
            color: this.widget.titleColor,
            fontWeight: this.widget.titleFontWeight,
            fontFamily: this.widget.titleFontFamily,
            align: this.widget.titleAlign,
            fontStyle: this.widget.titleFontStyle,
          ),
        ),
        Container(
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            color: cnf.colorGrayInputBg.toColor(),
            borderRadius: const BorderRadius.all(Radius.circular(cnf.input_radius))
          ),
          child: FutureBuilder(
              future: _initFuture,
              builder: (context, snapshot) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2),
                  child: Column(
                    children: [
                      Directionality(
                        textDirection: TextDirection.ltr,
                        child: TextFormField(
                          controller: _phoneNumberTextFieldController,
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(15),
                            FilteringTextInputFormatter.allow(kNumberRegex),
                          ],
                          onChanged: (v) {
                            _phoneNumberInputController.innerPhoneNumber = v;
                          },
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          // validator: _phoneNumberInputController.validator,
                          keyboardType: TextInputType.phone,
                          textAlignVertical: TextAlignVertical.center,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.zero,
                            hintText: widget.hint,
                            border: widget.border,
                            // hintStyle: const TextStyle(color: Color(0xFFB6B6B6)),
                            enabledBorder: widget.enabledBorder,
                            focusedBorder: widget.focusedBorder,
                            suffixIcon: Visibility(
                              visible: widget.allowPickFromContacts &&
                                  widget.contactsPickerPosition ==
                                      ContactsPickerPosition.suffix,
                              child: widget.pickContactIcon == null
                                  ? IconButton(
                                  onPressed: _phoneNumberInputController
                                      .pickFromContacts,
                                  icon: Icon(
                                    Icons.contact_phone,
                                    color: Theme.of(context).primaryColor,
                                  ))
                                  : InkWell(
                                onTap: _phoneNumberInputController
                                    .pickFromContacts,
                                child: widget.pickContactIcon,
                              ),
                            ),
                            prefixIcon: InkWell(
                              onTap: _openCountryList,
                              child: Padding(
                                padding: EdgeInsets.only(left: cnf.marginScreen, right: cnf.marginScreen),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(Icons.arrow_drop_down),
                                    if (_selectedCountry != null &&
                                        widget.showSelectedFlag)
                                      Image.asset(
                                        _selectedCountry!.flagPath,
                                        height: 12,
                                      ),
                                    const SizedBox(
                                      width: 4,
                                    ),
                                    if (_selectedCountry != null)
                                      Text(
                                        _selectedCountry!.dialCode,
                                        style: TextStyle(
                                            color: Theme.of(context).primaryColor),
                                      ),
                                    const SizedBox(
                                      width: 8,
                                    ),
                                    Container(
                                      height: 24,
                                      width: 1,
                                      color: const Color(0xFFB9BFC5),
                                    ),
                                    const SizedBox(
                                      width: 8,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Visibility(
                          visible: widget.allowPickFromContacts &&
                              widget.contactsPickerPosition ==
                                  ContactsPickerPosition.bottom,
                          child: widget.pickContactIcon == null
                              ? IconButton(
                              onPressed:
                              _phoneNumberInputController.pickFromContacts,
                              icon: Icon(
                                Icons.contact_phone,
                                color: Theme.of(context).primaryColor,
                              ))
                              : InkWell(
                            onTap: _phoneNumberInputController.pickFromContacts,
                            child: widget.pickContactIcon,
                          )),
                    ],
                  ),
                );
              }),
        )
      ],
    );
  }

  void _openCountryList() {
    switch (widget.countryListMode) {
      case CountryListMode.bottomSheet:
        showModalBottomSheet(
            isScrollControlled: true,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            enableDrag: true,
            context: context,
            builder: (_) => SizedBox(
              height: 500,
              child: CountryCodeList(
                  searchHint: widget.searchHint,
                  allowSearch: widget.allowSearch,
                  phoneNumberInputController: _phoneNumberInputController),
            ));
        break;
      case CountryListMode.dialog:
        showDialog(
            context: context,
            builder: (_) => AlertDialog(
              contentPadding: EdgeInsets.zero,
              content: SizedBox(
                width: double.maxFinite,
                child: CountryCodeList(
                    searchHint: widget.searchHint,
                    allowSearch: widget.allowSearch,
                    phoneNumberInputController: _phoneNumberInputController),
              ),
            ));
        break;
    }
  }
}
