// 첫 화면 로고와 선 2개 그리기를 완료한 상태
// 로고는 위젯으로 만듦

import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // 화면 방향 및 UI 설정을 위해 추가

void main() {
  // runApp()을 호출하기 전에 Flutter 엔진과의 바인딩을 보장합니다.
  WidgetsFlutterBinding.ensureInitialized();

  // ▼▼▼▼▼ 전체 화면 설정 코드 추가 ▼▼▼▼▼
  // 앱을 몰입 모드(전체 화면)로 설정하여 상단 상태 바와 하단 네비게이션 바를 숨깁니다.
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

  // 앱이 지원할 화면 방향을 설정합니다.
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp, // 세로 위 방향만 허용
    DeviceOrientation.portraitDown, // (선택) 세로 아래 방향 (폰을 거꾸로 드는 경우)
  ]).then((_) {
    // 방향 설정이 완료된 후에 앱을 실행합니다.
    runApp(const MyApp());
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      // 디버그 모드에서 오른쪽 상단에 표시되는 "DEBUG" 배너를 제거합니다.
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}

// ▼▼▼▼▼ 선을 그리는 로직을 담당하는 클래스 ▼▼▼▼▼
class LinePainter extends CustomPainter {
  // paint 메서드 안에 그림을 그리는 모든 로직을 작성합니다.
  @override
  void paint(Canvas canvas, Size size) {
    // 1. 선의 모양과 속성을 정의하는 Paint 객체를 생성합니다.
    final paint = Paint()
      ..color = Colors.white60 // 선의 색상
      ..strokeWidth = 2; // 선의 두께

    // 2. 선의 시작점과 끝점을 정의합니다.
    const p1 = Offset(50, 0); // 시작점 (x: 0, y: 100)
    const p2 = Offset(50, 200); // 끝점 (x: 100, y: 100) -> 길이가 100px인 수평선
    const p3 = Offset(100, 200);
    const p4 = Offset(105, 200);

    // 3. canvas에 시작점과 끝점을 연결하는 선을 그립니다.
    canvas.drawLine(p1, p2, paint);
    canvas.drawLine(p2, p3, paint);

    // ▼▼▼▼▼ p3 지점에 원(점) 그리기 추가 ▼▼▼▼▼
    // canvas.drawCircle(중심점 좌표, 반지름, Paint 객체);
    canvas.drawCircle(p4, 5, paint); // p3를 중심으로 반지름이 5인 원을 그림

    // 하단 선과 점 그리기
    final screenWidth = size.width;
    final screenHeight = size.height;
    final pp1 = Offset(screenWidth-50, screenHeight);
    final pp2 = Offset(screenWidth-50, screenHeight-200);
    final pp3 = Offset(screenWidth-100, screenHeight-200);
    final pp4 = Offset(screenWidth-105, screenHeight-200);
    canvas.drawLine(pp1, pp2, paint);
    canvas.drawLine(pp2, pp3, paint);
    canvas.drawCircle(pp4, 5, paint);






  }

  // shouldRepaint 메서드는 위젯이 다시 그려져야 할 때 호출됩니다.
  // 지금은 정적인 선이므로 false를 반환하여 불필요한 리소스를 절약합니다.
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

// 로고와 선을 보여줄 화면 위젯
class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // 화면의 배경색을 설정합니다.
      backgroundColor: Colors.black,
      // body에 CustomPaint 위젯을 사용하여 선을 그립니다.
      body: CustomPaint(
        // 우리가 만든 LinePainter를 painter로 지정합니다.
        painter: LinePainter(),
        // CustomPaint가 차지할 영역을 화면 전체로 확장합니다.
        // 이 코드가 없으면 CustomPaint의 크기가 0이 되어 아무것도 보이지 않습니다.
        size: Size.infinite,
        // (선택) CustomPaint 위에 다른 위젯(예: 로고)을 배치할 수 있습니다.
        child: Center(
          child: Image.asset(
            'assets/images/LOGO_JEST.png',
            // 이미지의 너비를 화면 너비의 40%로 설정합니다.
            width: MediaQuery.of(context).size.width * 0.4,
          ),
        ),
      ),
    );
  }
}
