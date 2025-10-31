// lib/lotto.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // 1. 진동 기능을 위해 services.dart를 import 합니다.

// StatefulWidget으로 변경
class LottoPage extends StatefulWidget {
  // 이전 페이지에서 전달받을 7개의 변수
  final int teamno;
  final int totalpeople;
  final int teammembers;
  final int lotto3;
  final int lotto2;
  final int cf;
  final int mf;

  // 생성자를 통해 모든 변수를 필수로 받도록 설정
  const LottoPage({
    super.key,
    required this.teamno,
    required this.totalpeople,
    required this.teammembers,
    required this.lotto3,
    required this.lotto2,
    required this.cf,
    required this.mf,
  });

  @override
  State<LottoPage> createState() => _LottoPageState();
}

// State 클래스 생성
class _LottoPageState extends State<LottoPage> {
  // 상태 변수들 선언
  late List<List<String>> t; // 다차원 배열
  late List<bool> isChecked; // 각 이미지의 체크 상태를 저장할 리스트

  // initState에서 초기화 로직 실행
  @override
  void initState() {
    super.initState();
    // 위젯이 처음 생성될 때 한 번만 실행되는 초기화 로직
    _initializeState();
  }

  void _initializeState() {
    // 이미지 체크 상태 리스트를 totalpeople 크기만큼 만들고 모두 false로 초기화
    isChecked = List.generate(widget.totalpeople, (index) => false, growable: false);

    const int rowCount = 3;
    int colCount = widget.totalpeople;

    // 문자열을 담을 다차원 리스트 생성
    t = List.generate(
      rowCount,
          (i) => List.generate(colCount, (j) => '', growable: false), // 모두 빈 문자열로 초기화
      growable: false,
    );

    // teamno 값에 따라 배열 내용 채우기
    if (widget.teamno == 1) {
      // --- 0행 (첫 번째 행) 채우기 ---
      for (int j = 0; j < colCount; j++) {
        t[0][j] = 'A';
      }

      // --- 1행 (두 번째 행) 채우기 ---
      int currentIndex = 0; // 현재 채우고 있는 열의 인덱스

      // 1. 'CF' 채우기
      for (int i = 0; i < widget.cf && currentIndex < colCount; i++) {
        t[1][currentIndex++] = 'CF';
      }

      // 2. 'MF' 채우기
      for (int i = 0; i < widget.mf && currentIndex < colCount; i++) {
        t[1][currentIndex++] = 'MF';
      }

      // 3. 'GK' 채우기
      if (currentIndex < colCount) {
        t[1][currentIndex++] = 'GK';
      }

      // 4. 'DF' 채우기
      int dfCount = widget.teammembers - (widget.cf + widget.mf + 1);
      for (int i = 0; i < dfCount && currentIndex < colCount; i++) {
        t[1][currentIndex++] = 'DF';
      }

      // 5. 남은 공간 '꽝'으로 채우기
      while (currentIndex < colCount) {
        t[1][currentIndex++] = '꽝';
      }

      // --- 2행 (세 번째 행) 채우기 ---
      for (int j = 0; j < colCount; j++) {
        t[2][j] = "0";
      }

    } else if (widget.teamno == 2) {
      // --- 0행 (첫 번째 행) 채우기 ---
      int aCount = (colCount / 2).ceil();
      for (int j = 0; j < aCount; j++) {
        t[0][j] = 'A';
      }
      for (int j = aCount; j < colCount; j++) {
        t[0][j] = 'B';
      }

      // --- 1행 (두 번째 행) 채우기 ---
      int currentIndex = 0;
      int dfCount = widget.teammembers - widget.cf - widget.mf - 1;

      // A팀 포지션 채우기
      void fillTeamPositions(int start, int end) {
        int current = start;
        // CF
        for(int i = 0; i < widget.cf && current < end; i++) t[1][current++] = 'CF';
        // MF
        for(int i = 0; i < widget.mf && current < end; i++) t[1][current++] = 'MF';
        // GK
        if(current < end) t[1][current++] = 'GK';
        // DF
        for(int i = 0; i < dfCount && current < end; i++) t[1][current++] = 'DF';
        // 꽝
        while(current < end) t[1][current++] = '꽝';
      }

      fillTeamPositions(0, aCount); // A팀
      fillTeamPositions(aCount, colCount); // B팀

      // --- 2행 ---
      for (int j = 0; j < colCount; j++) {
        t[2][j] = "0";
      }
    }

    // 생성된 배열 내용 전체 출력 (디버그용)
    print('--- 생성된 다차원 배열 t ---');
    print('t의 행 개수: ${t.length}');
    print('t의 열 개수: ${t.isNotEmpty ? t[0].length : 0}');
    for (var row in t) {
      print(row);
    }
    print('--------------------------');
  }


  @override
  Widget build(BuildContext context) {
    // 화면 너비를 기반으로 이미지 크기 계산
    final screenWidth = MediaQuery.of(context).size.width;
    final horizontalPadding = 16.0 * 2;
    final crossAxisSpacing = 16.0;
    final imageSize = (screenWidth - horizontalPadding - (crossAxisSpacing * 4)) / 5 * 0.85;

    // GridView에 표시할 총 아이템 개수 계산
    final totalGridItems = widget.totalpeople > 3 ? widget.totalpeople + 2 : widget.totalpeople;

    return Scaffold(
      appBar: AppBar(
        title: const Text('추첨 페이지'),
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.black54, Colors.black],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          Positioned(
            top: -20,
            right: -30,
            child: Opacity(
              opacity: 0.8,
              child: Image.asset(
                'assets/images/LOGO_JEST.png',
                width: MediaQuery.of(context).size.width * 0.5,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
            child: Column(
              children: [
                const SizedBox(height: 120.0),
                Expanded(
                  child: GridView.builder(
                    padding: EdgeInsets.zero,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 5,
                      mainAxisSpacing: 16.0,
                      crossAxisSpacing: 16.0,
                    ),
                    itemCount: totalGridItems,
                    itemBuilder: (BuildContext context, int index) {
                      if (widget.totalpeople > 3 && (index == 3 || index == 4)) {
                        return Container(color: Colors.transparent);
                      }

                      int imageIndex = index;
                      if (widget.totalpeople > 3 && index > 4) {
                        imageIndex = index - 2;
                      }

                      if (imageIndex >= widget.totalpeople) {
                        return Container(color: Colors.transparent);
                      }

                      // GestureDetector로 이미지 감싸기
                      return GestureDetector(
                        onTap: () {
                          // 이미 체크되지 않은 경우에만 상태 변경
                          if (!isChecked[imageIndex]) {
                            // 2. 진동 발생 코드 추가
                            HapticFeedback.mediumImpact();

                            setState(() {
                              isChecked[imageIndex] = true;
                            });
                          }
                        },
                        child: SizedBox(
                          width: imageSize,
                          height: imageSize,
                          // isChecked 상태에 따라 다른 이미지 표시
                          child: Image.asset(
                            isChecked[imageIndex]
                                ? 'assets/images/env_checked.png'
                                : 'assets/images/env_locked.png',
                            fit: BoxFit.contain,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
