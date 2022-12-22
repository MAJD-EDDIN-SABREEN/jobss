import 'package:flutter/material.dart';
import 'package:jobss/UI/SignUp.dart';
import 'package:onboarding/onboarding.dart';
class OnBordingPages extends StatefulWidget {
  const OnBordingPages({Key? key}) : super(key: key);

  @override
  State<OnBordingPages> createState() => _OnBordingPagesState();
}

class _OnBordingPagesState extends State<OnBordingPages> {
  late Material materialButton;
  late int index;
  final onboardingPagesList = [
    PageModel(

      widget: DecoratedBox(
        decoration: BoxDecoration(
          color: background,
          border: Border.all(
            width: 0.0,

            color: background,
          ),
        ),
        child: SingleChildScrollView(
          controller: ScrollController(),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 45.0,
                  vertical: 90.0,
                ),
                child: Image.asset('images/job1.jpg',
                   //color: pageImageColor,
                  fit: BoxFit.fitHeight,
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 45.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'JOB APP',
                    style: pageTitleStyle,
                    textAlign: TextAlign.left,
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(top: 10,bottom: 300,left:45),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Welcome in Job app',
                    style: pageInfoStyle,
                    textAlign: TextAlign.left,
                  ),
                ),
              ),


            ],
          ),
        ),
      ),
    ),
    PageModel(

      widget: DecoratedBox(
        decoration: BoxDecoration(
          color: background,
          border: Border.all(
            width: 0.0,

            color: background,
          ),
        ),
        child: SingleChildScrollView(
          controller: ScrollController(),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 45.0,
                  vertical: 90.0,
                ),
                child: Image.asset('images/job1.jpg',
                  //color: pageImageColor,
                  fit: BoxFit.fitHeight,
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 45.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Let find your job',
                    style: pageTitleStyle,
                    textAlign: TextAlign.left,
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(top: 10,bottom: 300,left:45),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Easily find your job from home',
                    style: pageInfoStyle,
                    textAlign: TextAlign.left,
                  ),
                ),
              ),


            ],
          ),
        ),
      ),
    ),

  ];

  @override
  void initState() {
    super.initState();
    materialButton = _skipButton();
    index = 0;
  }

  Material _skipButton({void Function(int)? setIndex}) {
    return Material(
      borderRadius: defaultSkipButtonBorderRadius,
      color: defaultSkipButtonColor,
      child: InkWell(
        borderRadius: defaultSkipButtonBorderRadius,
        onTap: () {
          if (setIndex != null) {
            index = 1;
            setIndex(1);
          }
        },
        child: const Padding(
          padding: defaultSkipButtonPadding,
          child: Text(
            'Skip',
            style: defaultSkipButtonTextStyle,
          ),
        ),
      ),
    );
  }

  Material get _signupButton {
    return Material(
      borderRadius: defaultProceedButtonBorderRadius,
      color: defaultProceedButtonColor,
      child: InkWell(
        borderRadius: defaultProceedButtonBorderRadius,
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => SignUp("30.044420", "31.235712")));
        },
        child: const Padding(
          padding: defaultProceedButtonPadding,
          child: Text(
            'Sign up',
            style: defaultProceedButtonTextStyle,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
        body: Onboarding(
          pages: onboardingPagesList,
          onPageChange: (int pageIndex) {
            index = pageIndex;
          },
          startPageIndex: 0,
          footerBuilder: (context, dragDistance, pagesLength, setIndex) {
            return DecoratedBox(
              decoration: BoxDecoration(
                color: background,
                border: Border.all(
                  width: 0.0,
                  color: background,
                ),
              ),
              child: ColoredBox(
                color: background,
                child: Padding(
                  padding: const EdgeInsets.all(45.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomIndicator(
                        netDragPercent: dragDistance,
                        pagesLength: pagesLength,
                        indicator: Indicator(
                          indicatorDesign: IndicatorDesign.line(
                            lineDesign: LineDesign(
                              lineType: DesignType.line_uniform,
                            ),
                          ),
                        ),
                      ),
                      index == pagesLength - 1
                          ? _signupButton
                          : _skipButton(setIndex: setIndex)
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      );

  }
}