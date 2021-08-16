// @dart=2.9
import 'package:flutter/material.dart';

//needed for using the Timer

// ignore: must_be_immutable
class SmallBtn extends StatelessWidget {
  final String passedText;
  IconData passedIcon;
  Color passedBGColor;
  Color passedFontColor;
  Color passedBorderColor;
  bool isShadowEnabled;
  SmallBtn({
    @required this.passedText,
    this.passedIcon,
    this.passedBGColor,
    this.passedFontColor,
    this.passedBorderColor,
    this.isShadowEnabled,
  });
  @override
  Widget build(BuildContext context) {
    isShadowEnabled == null
        ? isShadowEnabled = false
        : isShadowEnabled = isShadowEnabled;
    final deviceSize = MediaQuery.of(context).size;
    return Container(
      // alignment: Alignment.bottomLeft,
      // width: deviceSize.width * 0.5 + passedText.length * 3,
      padding: EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
      height: deviceSize.height * 0.04,
      decoration: BoxDecoration(
        color: passedBGColor == null ? Colors.brown : passedBGColor,
        borderRadius: BorderRadius.all(
          Radius.circular(
            deviceSize.height * 0.02,
          ),
        ),
        border: Border.all(
          color: passedBorderColor == null
              ? Colors.transparent
              : passedBorderColor,
        ),
        boxShadow: [
          isShadowEnabled
              ? BoxShadow(
                  color: Colors.brown,
                  blurRadius: 10.0, // has the effect of softening the shadow
                  spreadRadius: 1.0, // has the effect of extending the shadow
                  offset: Offset(
                    0.0, // horizontal
                    1.0, // vertical
                  ),
                )
              : BoxShadow()
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          passedIcon != null
              ? Icon(
                  passedIcon,
                  color: Colors.white,
                  size: deviceSize.height * 0.02,
                )
              : Container(),
          passedIcon != null
              ? SizedBox(width: deviceSize.width * 0.01)
              : SizedBox(),
          Text(
            passedText,
            style: TextStyle(
              fontSize: deviceSize.height * 0.018,
              fontFamily: "Dancing",
              color: passedFontColor != null ? passedFontColor : Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}

class CombinedHomeView extends StatefulWidget {
  // --- Services Headings
  @override
  _CombinedHomeViewState createState() => _CombinedHomeViewState();
}

class _CombinedHomeViewState extends State<CombinedHomeView> {
  String fontMontserrat = "Dancing";
  _showGrocOrderReviewDialog(Size _deviceSize) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        margin: EdgeInsets.all(10),
        padding: EdgeInsets.all(10),
        width: double.infinity,
        height: _deviceSize.height * 0.28,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "How was your last order?",
              style: TextStyle(
                fontFamily: fontMontserrat,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 10),
            Expanded(
              child: Container(
                padding: EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.2),
                  borderRadius: BorderRadius.all(
                    Radius.circular(_deviceSize.height * 0.02),
                  ),
                ),
                child: SingleChildScrollView(
                  child: TextField(
                    maxLines: 5,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Add additional remarks',
                      hintStyle: TextStyle(
                        fontSize: _deviceSize.height * 0.015,
                        fontFamily: fontMontserrat,
                        color: Colors.black38,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 10),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: SmallBtn(
                    passedText: "Cancel",
                    passedBorderColor: Colors.green,
                    passedBGColor: Colors.white,
                    passedFontColor: Colors.brown,
                  ),
                ),
                SizedBox(width: 10),
                Expanded(child: SmallBtn(passedText: "Submit")),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Size _deviceSize = MediaQuery.of(context).size;
    return Stack(
      alignment: Alignment.center,
      children: [
        // ------------ List of content
        ListView(/* few simple widgets here*/),
        // ------------ Dialog
        _showGrocOrderReviewDialog(_deviceSize)
      ],
    );
  }
}
