# 플러그인 가이드 (설치·용도)

설정 → Community plugins → Browse 에서 설치.

## 필수 (Phase 1)
- **Dataview** — frontmatter를 DB처럼 질의. MOC 목록 자동 생성.
  예) cluster별 종목 목록:
  ```dataview
  TABLE confidence, updated FROM "wiki/concepts" WHERE cluster = "investing" SORT updated DESC
  ```
- **Templater** — `templates/`의 frontmatter 스키마를 새 노트에 강제. 날짜 자동 삽입.
  설정 → Templater → Template folder = vault의 템플릿 폴더 지정.

## 권장 (Phase 3)
- **Smart Connections** — vault 전체를 로컬 임베딩으로 색인 → 사이드바에서 vault와 대화(RAG),
  현재 노트와 의미적으로 유사한 노트 자동 추천("Smart Links"). 데이터는 로컬에 남음.
- **Graph View**(기본 내장) — `../obsidian-graph-fix/graph.json` 설정과 함께 트리형 토폴로지 점검용.

## 선택
- **Web Clipper**(공식) — 기사 → `sources/articles/`로 저장(=raw 흡수 입력).
- **QuickAdd** — `/ingest` 같은 워크플로우를 버튼/단축키로.

> 원칙: 플러그인은 **캡처·질의·시각화**만 돕는다. 지식의 생성·유지는 Claude Code(`CLAUDE.md`)가 한다.
