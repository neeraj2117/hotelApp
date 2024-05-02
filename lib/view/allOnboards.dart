import 'package:flutter/material.dart';
import 'package:hotels/view/first_onboard.dart';
import 'package:hotels/view/second_onboard.dart';
import 'package:hotels/view/third_onboard.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class AllOnboardScreens extends StatefulWidget {
  const AllOnboardScreens({Key? key}) : super(key: key);

  @override
  State<AllOnboardScreens> createState() => _AllOnboardScreensState();
}

class _AllOnboardScreensState extends State<AllOnboardScreens> {
  PageController _controller = PageController();
  double currentPage = 0.0;

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      setState(() {
        currentPage = _controller.page!;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: 1 * MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: PageView(
              scrollDirection: Axis.vertical,
              controller: _controller,
              children: const [
                FirstOnboard(),
                SecondOnboard(),
                ThirdOnboard(),
              ],
            ),
          ),
          Container(
            alignment: AlignmentDirectional.centerEnd,
            padding: const EdgeInsets.all(15.0),
            child: RotatedBox(
              quarterTurns: 1,
              child: SmoothPageIndicator(
                controller: _controller,
                count: 3,
                effect: ExpandingDotsEffect(
                  dotColor: Colors.grey[300]!,
                  dotWidth: 35,
                  dotHeight: 8,
                  // activeDotColor: const Color.fromARGB(255, 97, 171, 232),
                  activeDotColor: Color(0xFF3C3633),
                  spacing: 20,
                ),
                onDotClicked: (index) {
                  _controller.animateToPage(
                    index,
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.easeInOut,
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
