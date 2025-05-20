import 'package:flutter/material.dart';
import 'pages/interest_selection_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const MainScreen(),
      debugShowCheckedModeBanner: false, // 디버그 배너 제거
    );
  }
}

class MainScreen extends StatelessWidget {
  const MainScreen({super.key}); // 생성자

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('메인화면')),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            // 앞으로 나온듯한 형태의 버튼 위젯
            onPressed: () {
              Navigator.push(
                // 새 화면으로 전환하는 함수
                context,
                MaterialPageRoute(
                    // 화면 전환 애니메이션을 제공하는 라우트 클래스
                    builder: (context) => const InterestSelectionPage()),
              );
            },
            child: const Text('관심사 선택 페이지 이동'),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              showGeneralDialog(
                // 사용자 정의 다이얼로그 표시 함수
                // 다이얼로그 : 비밀번호를 입력하세요 같이 화면 위 잠깐 뜨는 작은 팝업 창
                context: context, // 현재 위젯의 정보 제공
                barrierLabel: "검색", // 베리어 : 다이얼로그가 뜰 때, 뒤에 깔리는 반투명한 어두운 배경
                // 사용자가 다른 화면을 못 건드리게 막는 장벽
                barrierDismissible: true, // 사용자가 다이얼로그 바깥을 클릭하면 닫히게 하는 옵션
                barrierColor: Colors.black.withOpacity(0.3),
                transitionDuration:
                    const Duration(milliseconds: 300), // 등장하고 소멸하는 시간
                pageBuilder: (context, anim1, anim2) {
                  // pageBuilder : 반드시 위젯 반환 필요, 이 경우는 실제 표시할 내용 없음음
                  // 다이얼로그 콘텐츠 빌드하는 함수
                  return const SizedBox.shrink(); // 아무것도 없는 가장 작은 크기의 위젯 생성하는 것
                  // 왜? 다이얼로그의 콘텐츠는 transitionBuilder에서 정의하기 때문
                  // 다이얼로그의 기본 콘텐츠를 적용하는 곳이기에 애니메이션 적용이 힘듦
                },
                transitionBuilder: (context, anim1, anim2, child) {
                  // 다이얼로그의 애니메이션과 UI 결정하는 함수
                  // anim1 : 주 애니메이션 컨트롤러, 다이얼로그가 나타날때 애니메이션 제어
                  // anim2 : 보조 애니메이션 컨트롤러, 보통 종료 애니메이션에 사용용
                  // child : pageBuilder에서 반환한 위젯
                  return SlideTransition(
                    // 다이얼로그의 콘텐츠
                    // 슬라이드 애니메이션
                    position: Tween(
                      // 애니메이션의 시작과 끝 위치
                      begin: const Offset(0, -1), // 시작 위치
                      // x좌표 : 0 (화면 중앙), y좌표 : -1 (화면 위쪽)
                      end: Offset.zero,
                      // x: 왼쪽에서 오른쪽 0 -> 1, y: 위에서 아래 0 -> 1
                    ).animate(anim1), // Tween을 애니메이션 컨트롤러 anim1에 연결
                    child: const SearchOverlay(), // 애니메이션에 적용될 실제 위젯
                  );
                },
              );
            },
            child: const Text('검색하기'),
          ),
        ],
      ),
    );
  }
}

class SearchOverlay extends StatefulWidget {
  const SearchOverlay({super.key});

  @override
  State<SearchOverlay> createState() => _SearchOverlayState();
}

class _SearchOverlayState extends State<SearchOverlay> {
  final TextEditingController _controller =
      TextEditingController(); // 검색어 입력을 위한 컨트롤러 즉, 입력창의 기능을 제어하는 객체
  final List<String> _recentSearches = []; // 최근 검색어를 저장할 리스트

  void _onSearch() {
    final text = _controller.text.trim(); //텍스트를 가져올 떄 앞 뒤 공백 제거
    // 왜? 사용자가 불필요한 공백을 입력하지 않도록 하기 위해
    if (text.isNotEmpty) {
      setState(() {
        _recentSearches.remove(text); // 중복된 검색어를 제거
        // 만약 사용자가 같은 검색어를 다시 입력하면, 리스트에서 제거
        _recentSearches.insert(0, text);
        _controller.clear();
      });
    }
  }

  void _removeSearch(String item) {
    setState(() {
      _recentSearches.remove(item);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent, // 다이얼로그의 배경색 투명하게 설정
      child: Align(
        // 자식 위젯의 정렬 조정
        alignment: Alignment.topCenter,
        child: Container(
          margin: const EdgeInsets.only(top: 60, left: 18, right: 16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          height: 400,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller, // 입력값 관리할 컨트롤러 연결
                      decoration: InputDecoration(
                        hintText: '검색어를 입력하세요', // 입력창 비어있을 때 표시
                        filled: true, // 입력창 배경색 채울지 여부
                        fillColor: Colors.grey.shade300,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none, // 테두리 선 없애기
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xff606a95),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: _onSearch,
                    child: const Text('검색'),
                  ),
                  const SizedBox(width: 4),
                  TextButton(
                    onPressed: () => Navigator.pop(context), // 클릭 시 현재 화면 닫기기
                    // navigator.push/pop : 화면 전환을 위한 메소드
                    child: const Text('취소'),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: const Text('최근 검색어',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Color(0xff606a95))),
              ),
              Expanded(
                // 남은 공간을 모두 차지
                child: ListView.builder(
                  padding: const EdgeInsets.only(
                      top: 2), // 따로 설정하지 않으면 기본 제공 패딩이 너무 큼
                  // 스크롤 가능한 목록을 동적으로 생성 : 리스트뷰
                  itemCount: _recentSearches.length,
                  itemBuilder: (context, index) {
                    // 리스트 아이템을 생성하는 함수
                    // context : 현재 위젯의 정보 제공
                    final item = _recentSearches[index]; // 현재 인덱스 검색어 가져오기
                    return ListTile(
                      // 각 항목을 리스트타일로 형태로 표시
                      // 리스트타일 : 일종의 "행" 형태의 표준화된 레이아웃웃
                      title: Text(item), // 검색어를 텍스트로 표시
                      trailing: IconButton(
                        // trailing : 리스트 항목의 오른쪽에 위치
                        // leading : 리스트 항목의 왼쪽에 위치
                        icon: const Icon(Icons.close, color: Color(0xff606a95)),
                        onPressed: () => _removeSearch(item),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
