import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // 화면 방향 및 UI 설정을 위해 추가
import 'package:jest/settingposition.dart'; // 새로 만든 파일을 import

void main() {
  // runApp()을 호출하기 전에 Flutter 엔진과의 바인딩을 보장합니다.
  WidgetsFlutterBinding.ensureInitialized();

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

// 선을 그리는 로직을 담당하는 클래스
class LinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // 1. 선의 모양과 속성을 정의하는 Paint 객체를 생성합니다.
    final paint = Paint()
      ..color = Colors.white30 // 선의 색상
      ..strokeWidth = 2; // 선의 두께

    // 2. 상단 선과 점을 정의하고 그립니다.
    const p1 = Offset(50, 0);
    const p2 = Offset(50, 200);
    const p3 = Offset(100, 200);
    const p4 = Offset(105, 200);

    canvas.drawLine(p1, p2, paint);
    canvas.drawLine(p2, p3, paint);
    canvas.drawCircle(p4, 5, paint);

    // 3. 하단 선과 점을 동적으로 계산하여 그립니다.
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

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

// 스플래시 화면 위젯
class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // build 메서드 내에서 화면 크기를 가져옵니다.
    final screenSize = MediaQuery
        .of(context)
        .size;

    return Scaffold(
      // 화면의 배경색을 설정합니다.
      backgroundColor: Colors.black,
      // body를 Stack으로 변경하여 위젯들을 겹치게 합니다.
      body: Stack(
        children: [
          // 1. 배경 그림 (화면 전체에 그려짐)
          CustomPaint(
            painter: LinePainter(),
            size: Size.infinite,
          ),

          // 2. 중앙 로고 이미지
          Center(
            child: Image.asset(
              'assets/images/LOGO_JEST.png',
              width: screenSize.width * 0.4,
            ),
          ),

          // 3. 버튼1: "1개팀 만들기"
          Positioned(
            left: 110, // X 좌표
            top: 177, // Y 좌표
            child: ElevatedButton(
              // ▼▼▼▼▼ 버튼1 onPressed 수정 ▼▼▼▼▼
              onPressed: () {
                // SettingPositionPage로 이동하면서 teamno에 1을 전달
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SettingPositionPage(teamno: 1),
                  ),
                );
              },
              // ▲▲▲▲▲ 수정 끝 ▲▲▲▲▲
              // 버튼 스타일 지정
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black, // 버튼 배경색
                foregroundColor: Colors.white60, // 버튼 글자색
                shape: RoundedRectangleBorder( // 버튼 모양
                  borderRadius: BorderRadius.circular(5),
                ),
                padding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 8),
              ),
              child: const Text(
                '1개팀 만들기',
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          // 4. 버튼2: "2개팀 만들기" (pp4 좌표에 위치)
          Positioned(
            // pp4의 x 좌표: 화면 너비 - 105
            left: screenSize.width - 250,
            // pp4의 y 좌표: 화면 높이 - 200
            top: screenSize.height - 225,
            child: ElevatedButton(
              // ▼▼▼▼▼ 버튼2 onPressed 수정 ▼▼▼▼▼
              onPressed: () {
                // SettingPositionPage로 이동하면서 teamno에 2를 전달
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SettingPositionPage(teamno: 2),
                  ),
                );
              },
              // ▲▲▲▲▲ 수정 끝 ▲▲▲▲▲
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                foregroundColor: Colors.white60,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
                padding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 8),
              ),
              child: const Text(
                '2개팀 만들기',
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}