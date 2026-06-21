# LLMWiki 고도화 로드맵 — 2026 "LLM Wiki" 패턴

> 목표: 노트를 쌓아두기만 하는 vault를 **Claude가 직접 유지·질의하는 지식 위키**로 끌어올린다.
> 그래프 날짜-허브 문제도 이 구조로 근본 해결된다.

## 먼저 — 이건 "키트"입니다 (중요)
저는 사용자님 **로컬 옵시디언 vault를 직접 못 바꿉니다.** 이 폴더의 파일들은 vault에 복사해
넣은 뒤, **vault 루트에서 Claude Code를 실행**해 가동하는 재료입니다. 적용 흐름:
`파일 복사 → 플러그인 설치 → Claude Code 실행 → 루프 가동`.

## "LLM Wiki" 패턴이 뭐길래 (1분 요약)
RAG로 매번 재검색하는 대신, **LLM이 마크다운 위키를 코드처럼 유지**해 지식을 누적한다.
3계층: `sources/`(불변 raw) · `wiki/`(LLM이 쓰는 원자적 페이지) · `CLAUDE.md`(스키마).
자세한 규약은 같은 폴더 `CLAUDE.md` 참고 — 이게 핵심 설정 파일이다.

---

## Phase 0 — 즉효 (오늘, 5분)
- `../obsidian-graph-fix/graph.json`을 `.obsidian/graph.json`에 적용, 또는 그래프 필터에
  `-path:"02 Daily Notes"` 입력 → 날짜 허브 즉시 제거.

## Phase 1 — 기반 (구조·메타데이터)
1. `CLAUDE.md`를 **vault 루트**에 복사 (도메인 부분만 본인 맞게 손질).
2. `templates/`의 frontmatter 템플릿을 vault의 템플릿 폴더로 → **Templater** 플러그인으로 강제.
3. 폴더 매핑(이동 최소화):
   - 기존 `sources/` → 그대로 raw(Layer 1) 역할.
   - 기존 `04 Knowledge` → `wiki/`로 점진 재편 (한 번에 옮기지 말 것; ingest하며 자연 이전).
   - `wiki/index.md`, `wiki/log.md`, `wiki/hot.md` 신설.
4. 플러그인 설치: **Dataview**(frontmatter 질의), **Templater**(스키마 강제), Graph View(기본).

## Phase 2 — LLM 운영 (Claude Code로 가동)
1. **vault 루트에서 Claude Code 실행** → `CLAUDE.md` 자동 로드(가장 단순·권장. MCP·API키 불필요).
2. `claude-commands/`의 슬래시 커맨드를 vault의 `.claude/commands/`로 복사:
   `/today`(아침 포커스) · `/close`(저녁 요약+log) · `/my-world`(세션 브리핑) ·
   `/ingest <경로>`(소스 흡수) · `/lint`(주간 점검).
3. **Ingest 루프 가동**: voice-memo transcript / sources의 자료 → `/ingest`로 wiki 페이지·링크 자동 생성.
   매 ingest 후 `git commit`(위키를 코드처럼 버전 관리).

## Phase 3 — 검색·최적화 (RAG·자동화)
- **Smart Connections** 플러그인: vault 전체와 대화(로컬 임베딩 RAG). `integrations/plugins.md` 참고.
- **obsidian-mcp-server**(cyanheads): Claude Desktop/원격에서 frontmatter·태그까지 정밀 read/write.
  설정은 `integrations/mcp-setup.md`.
- (선택) **qmd** 로컬 검색(BM25+벡터+재랭킹): ingest 전 관련 페이지만 선로딩 → 토큰 60%+ 절감.
- 주간 `/lint`로 고아·모순 정리 + 그래프 트리형 유지.

---

## 매일/매주 어떻게 쓰나
- **아침**: `/today` → 오늘 포커스 제안.
- **자료 생기면**: `sources/`에 떨궈 두고 `/ingest sources/<파일>`.
- **질문**: 그냥 Claude Code에 물으면 wiki를 근거로 인용 답변.
- **저녁**: `/close` → 요약 + `log.md` 갱신.
- **주말**: `/lint` → 고아/모순 정리, 다음 조사 주제 확보.
- 그래프는 전역보다 **Local Graph(depth 1~2)** 위주로.

## 어디부터?
오늘은 **Phase 0**(그래프 필터)만. 이번 주에 **Phase 1**(CLAUDE.md 복사 + 플러그인)→
소스 1개 `/ingest`로 감 잡기. Phase 3는 익숙해진 뒤.
