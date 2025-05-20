import 'package:flutter/material.dart';

class InterestSelectionPage extends StatefulWidget {
  const InterestSelectionPage({super.key});

  @override
  State<InterestSelectionPage> createState() => _InterestSelectionPageState();
}

class _InterestSelectionPageState extends State<InterestSelectionPage> {
  final List<String> interests = [
    '자동차',
    '식품/음식',
    '패션/의류',
    '미용/뷰티',
    '인테리어',
    '취미/예술'
  ]; // 선택 가능한 관심 분야 -> 문자열 배열로 정의

  final Set<String> selectedInterests = {}; // 세트 사용으로 중복 선택 방지

  Widget _buildInterestCard(String title, String imagePath) {
    final isSelected = selectedInterests.contains(title);
    return GestureDetector(
      // 탭 이벤트 감지 후 항목 선택/해제
      onTap: () {
        setState(() {
          if (isSelected) {
            selectedInterests.remove(title);
          } else {
            selectedInterests.add(title); // contain : 포함 여부 \ add : 추가
          }
        });
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color:
                isSelected ? Color(0xff606a95) : Colors.transparent, // 투명 테두리
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 4, // 그림자 흐림 정도
              offset: Offset(0, 2), // 그림자 위치.. 차례대로 x,y
            ),
          ],
        ),
        child: Stack(
          // 코드 순으로 위젯들을 겹쳐서 배치하는 레이아웃
          // 사진 위에 하얀 배경 글자를 겹쳐서 배치할 거라 사용
          children: [
            Column(
              crossAxisAlignment:
                  CrossAxisAlignment.stretch, // stretch : 화면 딱 맞게
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(12)),
                    child: Image.asset(
                      imagePath,
                      fit: BoxFit.cover, // 가로세로 비율 유지 + 컨테이너 완전히 덮도록
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    title,
                    style: TextStyle(fontSize: 14),
                    textAlign: TextAlign.left,
                  ),
                ),
              ],
            ),
            Positioned(
              // 스택 내 체크 아이콘 위치 지정
              top: 10, // 위에서 10 만큼, 오른쪽에서 10 만큼
              right: 10,
              child: Icon(
                isSelected ? Icons.check_circle : Icons.radio_button_unchecked,
                color: isSelected ? Color(0xff606a95) : Colors.grey,
                size: 28,
              ),
            )
          ],
        ),
      ),
    );
  }

  // 여기서부터 진짜 메인 화면 구성

  @override
  Widget build(BuildContext context) {
    final imagePaths = [
      'assets/car1.jpg',
      'assets/food1.jpg',
      'assets/fashion1.jpg',
      'assets/beauty1.jpg',
      'assets/housedesign1.jpg',
      'assets/habit1.jpg'
    ];

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Image.asset(
              'assets/logo.png',
              height: 30,
              fit: BoxFit.contain,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: const Text(
                'Revoo',
                style: TextStyle(
                  color: Color(0xff606a95),
                ),
              ),
            ),
          ],
        ),
        centerTitle: true, // AppBar 제목을 가운데 정렬 / false : 왼쪽 정렬
      ),
      body: Padding(
        padding: const EdgeInsets.all(13.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              '관심있는 분야를 선택하시면\n취향에 맞는 상품을 추천해드려요',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              textAlign: TextAlign.left,
            ),
            const SizedBox(height: 6),
            const Text(
              '여러개 선택하셔도 괜찮아요!',
              style: TextStyle(
                  fontSize: 16, color: Color.fromARGB(255, 88, 88, 88)),
              textAlign: TextAlign.left,
            ),
            const SizedBox(height: 22),
            Expanded(
              // 부모 위젯이 주는 공간 최대로 차지하겠다는 뜻
              // 주로 column 이나 Row 에서 쓰임 + 가운데 영역 꽉 채우고 싶은 리스트 그리드 -> 감싸주는 용도
              // 그리드 레이아웃 별표 백만개 + 가용 공간 최대한 활용
              child: GridView.builder(
                // GridView는 그리드 만들기 위해 행/열 계산법 필요
                // 동적으로 그리드 생성
                itemCount: interests.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  // 열 개수 고정해서 그리드 만들어줌
                  crossAxisCount: 2, // 2열 그리드
                  mainAxisSpacing: 16, // 항목 간 간격
                  crossAxisSpacing: 16,
                  childAspectRatio: 3 / 4, // 가로 세로 비율 3:4
                ),
                itemBuilder: (context, index) {
                  // 각 인덱스 마다 호출 되서 그에 맞는 위젯 리턴 필요
                  // 각 항목에 대해 앞서 정의한 매서드 호출
                  return _buildInterestCard(
                      interests[index], imagePaths[index]); // 인덱스 받아온 기준..?
                },
              ),
            ),
            ElevatedButton(
              // 입체감 있는 버튼
              // 하단 버튼 구성
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xff606a95),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () {
                // 관심 선택 완료 후 다음 페이지로 이동
                // 선택된 관심사에 따라 다음 페이지로 이동하는 로직 추가 필요
              },
              child: const Padding(
                padding: EdgeInsets.symmetric(vertical: 16.0),
                child: Text('내 취향에 맞는 상품 보러가기',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 18)), // 스마트폰 하단바 고려한 수정 필요
              ),
            ),
          ],
        ),
      ),
    );
  }
}
