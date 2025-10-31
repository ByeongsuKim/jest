// lib/settingposition.dart

import 'package:flutter/material.dart';
import 'lotto.dart'; // lotto.dart 파일을 import 합니다.

// teamno 값을 전달받기 위한 StatefulWidget
class SettingPositionPage extends StatefulWidget {
  final int teamno; // 전달받을 변수

  // 생성자를 통해 teamno를 필수로 받도록 설정
  const SettingPositionPage({super.key, required this.teamno});

  @override
  State<SettingPositionPage> createState() => _SettingPositionPageState();
}

class _SettingPositionPageState extends State<SettingPositionPage> {
  // ▼▼▼▼▼ 각 입력 필드에 대한 컨트롤러 선언 ▼▼▼▼▼
  final TextEditingController _totalCountController = TextEditingController();
  final TextEditingController _teamMemberController = TextEditingController();
  final TextEditingController _threeCardController = TextEditingController();
  final TextEditingController _twoCardController = TextEditingController();
  final TextEditingController _cfCountController = TextEditingController();
  final TextEditingController _mfCountController = TextEditingController();

  // ▼▼▼▼▼ initState 추가 ▼▼▼▼▼
  @override
  void initState() {
    super.initState();
    // 위젯이 처음 생성될 때 teamno 값에 따라 기본값을 설정합니다.
    if (widget.teamno == 1) {
      _totalCountController.text = '13';
      _teamMemberController.text = '11';
      _threeCardController.text = '3';
      _twoCardController.text = '6';
      _cfCountController.text = '2';
      _mfCountController.text = '4';
    } else if (widget.teamno == 2) {
      _totalCountController.text = '22';
      _teamMemberController.text = '11';
      _threeCardController.text = '5';
      _twoCardController.text = '11';
      _cfCountController.text = '2';
      _mfCountController.text = '4';
    }
  }
  // ▲▲▲▲▲ initState 끝 ▲▲▲▲▲


  // 위젯이 화면에서 제거될 때 모든 컨트롤러를 정리합니다.
  @override
  void dispose() {
    _totalCountController.dispose();
    _teamMemberController.dispose();
    _threeCardController.dispose();
    _twoCardController.dispose();
    _cfCountController.dispose();
    _mfCountController.dispose();
    super.dispose();
  }
  // ▲▲▲▲▲ 컨트롤러 정리 끝 ▲▲▲▲▲

  // ▼▼▼▼▼ 경고 메시지를 표시하는 함수 추가 ▼▼▼▼▼
  void _showWarningDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.grey[800],
          title: const Text(
            '설정 오류',
            style: TextStyle(color: Colors.orangeAccent),
          ),
          content: Text(
            message,
            style: const TextStyle(color: Colors.white),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('확인', style: TextStyle(color: Colors.white)),
              onPressed: () {
                Navigator.of(context).pop(); // 대화 상자 닫기
              },
            ),
          ],
        );
      },
    );
  }
  // ▲▲▲▲▲ 경고 메시지 함수 끝 ▲▲▲▲▲

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // 1. AppBar
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        title: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/LOGO_JEST.png',
              height: 32,
            ),
            const SizedBox(width: 8),
            const Padding(
              padding: EdgeInsets.only(top: 8.0),
              child: Text(
                'JEST',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        centerTitle: true,
        elevation: 0,
      ),
      // 2. body
      body: SingleChildScrollView(
        // ▼▼▼▼▼ 스크롤 동작을 막기 위한 physics 속성 추가 ▼▼▼▼▼
        physics: const NeverScrollableScrollPhysics(),
        // ▲▲▲▲▲ 수정된 부분 끝 ▲▲▲▲▲
        child: Stack(
          children: [
            // 층 1: 그라데이션 배경
            Container(
              height: MediaQuery.of(context).size.height * 1.2,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.black54, Colors.black],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),

            // 층 2: 배경 이미지
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

            // 층 3: 컨텐츠
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${widget.teamno}개팀 선발인원 추첨',
                    style: const TextStyle(
                      color: Colors.orangeAccent,
                      fontSize: 22.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 80.0),
                  _buildInputSet(label: '총인원수: ', controller: _totalCountController),
                  const SizedBox(height: 16.0), // 간격은 이전 상태(16.0)로 유지
                  _buildInputSet(label: '한팀 선발 인원: ', controller: _teamMemberController),
                  const SizedBox(height: 16.0),
                  _buildInputSet(label: '3장 뽑기: ', controller: _threeCardController),
                  const SizedBox(height: 16.0),
                  _buildInputSet(label: '2장 뽑기: ', controller: _twoCardController),
                  const SizedBox(height: 16.0),
                  _buildInputSet(label: 'CF인원: ', controller: _cfCountController),
                  const SizedBox(height: 16.0),
                  _buildInputSet(label: 'MF인원: ', controller: _mfCountController),
                  const SizedBox(height: 40.0),
                  Center(
                    child: GestureDetector(
                      // ▼▼▼▼▼ onTap 로직 수정 (유효성 검사 추가) ▼▼▼▼▼
                      onTap: () {
                        // 텍스트 필드 값을 정수로 변환
                        final totalPeople = int.tryParse(_totalCountController.text) ?? 0;
                        final teamMembers = int.tryParse(_teamMemberController.text) ?? 0;
                        final cfCount = int.tryParse(_cfCountController.text) ?? 0;
                        final mfCount = int.tryParse(_mfCountController.text) ?? 0;

                        // 1단계 확인
                        if ((cfCount + mfCount + 1) > teamMembers) {
                          _showWarningDialog("CF 및 MF 인원수를 확인");
                          return; // 함수 종료
                        }

                        // 2단계 확인
                        if (totalPeople < teamMembers) {
                          _showWarningDialog("선발 인원 등 확인");
                          return; // 함수 종료
                        }

                        // 모든 확인 통과 시 LottoPage로 이동
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => LottoPage(
                              teamno: widget.teamno,
                              totalpeople: totalPeople,
                              teammembers: teamMembers,
                              lotto3: int.tryParse(_threeCardController.text) ?? 0,
                              lotto2: int.tryParse(_twoCardController.text) ?? 0,
                              cf: cfCount,
                              mf: mfCount,
                            ),
                          ),
                        );
                      },
                      // ▲▲▲▲▲ onTap 로직 수정 끝 ▲▲▲▲▲
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Image.asset(
                            'assets/images/soccer_ball.png',
                            width: 120,
                            height: 120,
                          ),
                          const Text(
                            'START',
                            style: TextStyle(
                              color: Colors.orangeAccent,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              shadows: [
                                Shadow(
                                  blurRadius: 10.0,
                                  color: Colors.black,
                                  offset: Offset(2.0, 2.0),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ▼▼▼▼▼ 입력 세트를 생성하는 재사용 가능한 함수 ▼▼▼▼▼
  Widget _buildInputSet({required String label, required TextEditingController controller}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          width: 140,
          child: Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18.0,
            ),
          ),
        ),
        SizedBox(
          width: 80,
          child: TextField(
            controller: controller,
            style: const TextStyle(
                color: Colors.orangeAccent,
                fontSize: 22.0,
                fontWeight: FontWeight.bold
            ),
            textAlign: TextAlign.center,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.lightBlueAccent),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.yellow),
              ),
            ),
          ),
        ),
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 24,
              width: 24,
              child: IconButton(
                padding: EdgeInsets.zero,
                icon: const Icon(Icons.arrow_drop_up, color: Colors.white),
                onPressed: () {
                  int currentValue = int.tryParse(controller.text) ?? 0;
                  currentValue++;
                  controller.text = currentValue.toString();
                },
              ),
            ),
            SizedBox(
              height: 24,
              width: 24,
              child: IconButton(
                padding: EdgeInsets.zero,
                icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
                onPressed: () {
                  int currentValue = int.tryParse(controller.text) ?? 0;
                  if (currentValue > 0) {
                    currentValue--;
                    controller.text = currentValue.toString();
                  }
                },
              ),
            ),
          ],
        ),
      ],
    );
  }
// ▲▲▲▲▲ 재사용 함수 끝 ▲▲▲▲▲
}
