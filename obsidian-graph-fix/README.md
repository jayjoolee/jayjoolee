# 옵시디언 그래프 개선 가이드 — 날짜 중심 → 주제 중심

> LLMWiki vault의 그래프 뷰가 날짜 노드 중심의 "헤어볼"이 되는 문제를 고치고,
> 그래프를 실제로 쓸모있게 만드는 2단계 + 활용법.

## 진단: 왜 날짜가 중심이 되나

- `02 Daily Notes`(데일리)와 `07 Sessions`(세션) 노트가 `[[2026-06-19]]` 형태 wikilink로
  거의 모든 노트와 연결된다 → **옵시디언은 모든 wikilink를 그래프 엣지로 그리므로** 날짜 노드가
  거대한 허브가 된다.
- 반면 **주제**(투자/종목, LLM, Claude Code)끼리는 직접 연결이 적어 흩어져 보인다.
- 그래서 그래프가 "시간순 더미"일 뿐, 관련 개념을 탐색하는 도구로 안 쓰인다.

해결은 두 층위다.
1. **보기 설정** — 지금 당장 읽히게 (노트 수정 없음).
2. **노트 구조** — 날짜 대신 주제가 허브가 되게 (앞으로 지속).

---

## 1단계 — 보기 설정 (즉시, 노트 수정 없음)

### A. graph.json 적용
이 폴더의 `graph.json`을 vault의 `.obsidian/graph.json`에 덮어쓴다.
- 옵시디언 **완전 종료** → `.obsidian/graph.json` 교체 → 재시작.
- 또는 그래프 뷰 우상단 톱니 설정에서 아래 값을 손으로 입력해도 동일하다.

핵심 설정 의미:

| 항목 | 값 | 효과 |
|---|---|---|
| Filters(search) | `-path:"02 Daily Notes"` | 날짜 허브를 화면에서 제거 (세션도 빼려면 `-path:"07 Sessions"` 추가) |
| Show attachments | off | `00 _assets` 첨부 노이즈 제거 |
| Show tags | on | 태그를 연결고리로 활용 |
| Color groups | 폴더/태그별 색 | 영역을 한눈에 구분 (아래) |
| Center force | 0.3 (낮춤) | 중앙 쏠림 완화 |
| Repel force | 14 (높임) | 노드를 서로 밀어내 펼침 |
| Link distance | 230 | 간격 확보 |
| Node size | 0.6 | 노드 작게 → 라벨 가독성 ↑ |

### B. 색 그룹 (이미 graph.json에 포함)
- `path:"04 Knowledge"` → 초록
- `path:"sources"` → 파랑
- `path:"07 Sessions"` → 주황
- `tag:#bull OR tag:#bear OR tag:#neutral OR tag:#conservative OR tag:#aggressive` → 빨강 (sentiment)
- `path:"02 Daily Notes"` → 회색 (필터를 끌 때 대비)

색 값은 그래프 설정의 색상 피커로 언제든 미세 조정 가능.

### C. 가장 중요한 활용 팁
**전역 그래프는 "월 1회 건강검진"용이다.** 일상 탐색의 진짜 도구는 **Local Graph**다.
- 노트에서 우클릭 → *Open local graph* (또는 커맨드 팔레트 → Open local graph).
- 우측 설정에서 **Depth 1~2**로 두면 "지금 이 노트와 직접 연결된 것"만 보인다.
- 관련 노트 탐색, 빠진 연결 발견, 고아 노트 찾기에 실제로 쓰인다.

---

## 2단계 — 구조 개선 (앞으로 지속, 그래프를 의미있게)

핵심 원칙: **날짜가 아니라 주제가 허브가 되게 한다.**

### 1) 날짜 wikilink → 프로퍼티로 (근본 원인 제거)
- 데일리/세션 노트 본문의 `[[2026-06-19]]`를 frontmatter `created: 2026-06-19`
  (또는 Dataview inline `created:: 2026-06-19`)로 대체.
- **프로퍼티 날짜는 그래프 엣지를 만들지 않으므로** 날짜 허브가 근본적으로 사라진다.
- 신규 노트는 `templates/데일리노트-템플릿.md`로 처음부터 이렇게 작성.
- 기존 노트 일괄 변환(정규식 find-replace)은 선택사항 — 당장은 1단계 필터로 충분하다.

### 2) MOC(Map of Content) 인덱스 노트 도입 (주제 허브 만들기)
- 주제별 인덱스 노트를 만들어 관련 노트를 링크한다.
  예: `04 Knowledge/투자-주식/투자-주식 MOC.md`가 TXN·APH·Seagate 등을 링크.
- 각 노트는 본문에 `[[투자-주식 MOC]]` 한 줄만 넣어도 주제 클러스터로 묶인다.
- `templates/MOC-템플릿.md` 골격과 `examples/`의 완성 예시(투자-주식 / Claude-Code / LLM) 참고.

### 3) 중첩 태그 체계 정리 (폴더와 무관하게 주제로 묶기)
- 이미 쓰는 sentiment 태그를 확장: `#투자/종목/TXN`, `#llm/claude-code`, `#sentiment/bull`.
- 중첩 태그는 그래프에서 상위/하위로 묶여 주제 클러스터를 만든다.
- 필요하면 색 그룹을 태그 기준으로 추가.

### 4) (선택) Dataview 플러그인
- MOC의 링크 목록을 쿼리로 자동 생성해 수동 유지보수를 줄인다.
  예) ` ```dataview\nLIST FROM #투자/종목 SORT file.name``` `
- 커뮤니티 플러그인 `Dataview` 설치 후 사용.

---

## 활용 루틴 정리

- **일상**: Local Graph(depth 1~2)로 현재 노트 주변 탐색.
- **주간/월간**: 전역 그래프에서 날짜 필터를 끄고 어디가 헤어볼인지 점검 → 해당 주제에 MOC 추가.
  `Show orphans`로 섬처럼 떠 있는 고아 노트를 찾아 MOC/태그로 연결하거나 정리.
- **새 노트 작성 시**: 날짜는 프로퍼티로, 본문엔 관련 MOC 링크 한 줄 + 주제 태그.

## 적용 체크리스트
- [ ] `graph.json`을 `.obsidian/graph.json`에 덮어쓰고 재시작 → 날짜 허브가 사라지고 색 클러스터가 보인다.
- [ ] 한 노트에서 Local Graph(depth 2)를 열어 관련 노트가 뜨는지 확인.
- [ ] 주제 1개(예: 투자-주식)부터 MOC 만들고 관련 노트에 링크 추가.
- [ ] 데일리 노트 템플릿을 프로퍼티 방식으로 교체.
