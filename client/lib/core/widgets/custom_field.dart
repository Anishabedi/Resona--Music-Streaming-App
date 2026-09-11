import 'package:flutter/material.dart';

class CustomField extends StatelessWidget{
  final String hintText;
  final TextEditingController? controller;
  final bool isObsecureText;
  final bool readOnly;
  final VoidCallback? onTap;
  final ValueChanged<String>? onChanged;
  final FocusNode? focusNode;
  final IconData? prefixIcon;
  const CustomField({super.key, required this.hintText, required this.controller, this.isObsecureText=false, this.readOnly=false, this.onTap, this.onChanged,this.focusNode, this.prefixIcon});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onTap: onTap,
      readOnly: readOnly,
      controller: controller,
      focusNode: focusNode,
      onChanged: onChanged,
      decoration: InputDecoration(
        hintText: hintText,
        prefixIcon: prefixIcon != null ? Icon(prefixIcon) : null
      ),
      validator: (val){
        if(val!.trim().isEmpty){
          return "$hintText is missing";
        }
        return null;
      },
      obscureText: isObsecureText,
      keyboardType: TextInputType.text,
    );
  }
}