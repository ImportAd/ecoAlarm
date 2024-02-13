import 'package:ecoalarm/core/Presentation/widgets/home_button.dart';
import 'package:flutter/material.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final mediaQueryData = MediaQuery.of(context);
    final screenWidth = mediaQueryData.size.width;
    final screenHeight = mediaQueryData.size.height;
    // final isPortrait = mediaQueryData.orientation == Orientation.portrait;
    // final pixelRatio = mediaQueryData.devicePixelRatio;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: const Color.fromARGB(255, 1, 32, 63),
        body: Center(
            child: CustomMultiChildLayout(
          delegate: OwnMultiChildLayoutDelegate(
              height: screenHeight, width: screenWidth),
          children: [
            LayoutId(id: 1, child: Image.asset('assets/images/homeImage.png')),
            LayoutId(
              id: 2,
              child: const HomeButton(text: "Новая игра"),
            ),
            LayoutId(
              id: 3,
              child: const HomeButton(text: "Загрузить"),
            ),
            LayoutId(
              id: 4,
              child: const HomeButton(text: "Справочник"),
            ),
          ],
        )),
      ),
    );
  }
}

class OwnMultiChildLayoutDelegate extends MultiChildLayoutDelegate {
  final double height;
  final double width;
  OwnMultiChildLayoutDelegate({required this.height, required this.width});
  @override
  void performLayout(Size size) {
    layoutChild(1, BoxConstraints.loose(Size(width / 1, height / 1.3)));
    layoutChild(2, BoxConstraints.loose(Size(width / 2, height / 5)));
    layoutChild(3, BoxConstraints.loose(Size(width / 2, height / 5)));
    layoutChild(4, BoxConstraints.loose(Size(width / 2, height / 5)));
    positionChild(1, Offset(width / 14, height / 10));
    positionChild(2, Offset(width / 2, height / 8));
    positionChild(3, Offset(width / 2, height / 2.58));
    positionChild(4, Offset(width / 2, height / 1.55));
  }

  @override
  bool shouldRelayout(covariant MultiChildLayoutDelegate oldDelegate) {
    return true;
  }
}
