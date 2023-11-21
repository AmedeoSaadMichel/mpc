import 'package:flutter/material.dart';

class ReusableCard extends StatefulWidget {
  final String title;
  final double height;
  final double width;
  final List<Widget> children;
  final TextStyle? titleStyle; // Add an optional parameter for title style
  final List<Widget>?
      titleRowWidget; // Add an optional parameter for additional widget in title row

  const ReusableCard({
    super.key,
    required this.title,
    required this.height,
    required this.width,
    required this.children,
    this.titleStyle, // Provide a default value or make it nullable if needed
    this.titleRowWidget, // Provide a default value or make it nullable if needed
  });

  @override
  State<ReusableCard> createState() => _ReusableCardState();
}

class _ReusableCardState extends State<ReusableCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey[100]!),
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey[500]!,
            offset: const Offset(1.0, 2.0),
            spreadRadius: 2.0,
            blurRadius: 6.0,
          ),
        ],
      ),
      height: widget.height,
      width: widget.width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // Title Row
          Padding(
            padding: EdgeInsets.only(
              left: widget.width * 0.05,
            ),
            child: Row(
              children: [
                Text(
                  widget.title,
                  style: widget.titleStyle ??
                      TextStyle(
                        color: Colors.grey[700],
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const Spacer(),
                //HERE I PASS OTHER WIDGET CLOSE TO THE TITLE
                if (widget.titleRowWidget != null) ...widget.titleRowWidget!,
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: widget.width * 0.05),
            child: const Divider(),
          ), //THAT'S THE LINE UNDER TITLE
          // Pass the children parameter to the Column widget
          ...widget.children
        ],
      ),
    );
  }
}
//CUSTOM BUTTON--------------------------------------------------------------------------------------------------------

class CButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color buttonColor;
  final double height;
  final double width;

  const CButton({
    Key? key,
    required this.text,
    required this.onPressed,
    required this.buttonColor,
    this.height = 40.0,
    this.width = 120.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: width * 0.05),
      child: Container(
        decoration: BoxDecoration(
          color: buttonColor,
          borderRadius: BorderRadius.circular(6),
          boxShadow: const [
            BoxShadow(
              color: Colors.grey,
              offset: Offset(2.0, 2.0),
              spreadRadius: 2.0,
              blurRadius: 6.0,
            ),
          ],
        ),
        height: height * 0.06,
        width: width * 0.8,
        child: GestureDetector(
          onTap: onPressed,
          child: Align(
            alignment: Alignment.center,
            child: Text(
              text,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
