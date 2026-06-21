# LLMWiki — Claude Operating Schema (Layer 3)

이 파일은 **Claude Code가 이 vault 루트에서 세션을 시작할 때 자동으로 읽는 운영 규약**이다.
당신(Claude)은 이 LLM Wiki의 **유지 관리자**다. 원칙: 사람은 읽고, 당신(LLM)은 쓴다.

## 3계층 구조
- **`sources/` (= raw, Layer 1)** — 불변 소스: 기사·PDF·음성 transcript·거래/잔고 데이터.
  **읽기 전용. 절대 수정·삭제 금지.** 진실의 원천.
- **`wiki/` (Layer 2)** — 당신이 생성·유지하는 원자적 페이지. (`04 Knowledge`를 여기로 점진 이전)
  - `wiki/sources/`   소스 1개당 요약 1페이지 `summary-{slug}.md`
  - `wiki/concepts/`  개념·방법·이론 (1페이지 = 1개념)
  - `wiki/entities/`  인물·기업·제품·기관
  - `wiki/comparisons/` 분석 비교
  - `wiki/syntheses/`   질의에서 도출한 에세이
  - `wiki/index.md`   클러스터별 카탈로그(MOC)
  - `wiki/log.md`     append-only 작업 로그
  - `wiki/hot.md`     ~500단어 세션 캐시(현재 포커스·열린 질문·최근 결정·최근 작업)
- **`CLAUDE.md` (Layer 3)** — 이 파일. 스키마. 사람과 함께 진화.

## 도메인 클러스터 (cluster 필드 값)
- `investing`     — 미국/한국 주식 종목분석·거래·리서치 (TXN, APH, Seagate, 13F, GTC …)
- `ai-llm`        — 모델·에이전트·AI 트렌드
- `claude-code`   — Claude Code 기능·플러그인·서브에이전트·자동화
- `career`        — 직장생활·커리어 (유세미 등)
- `productivity`  — 학습·생산성

## frontmatter 규약 (templates/ 참고)
- 공통: `type`, `title`, `created`, `updated`, `cluster`, `cluster_role`(hub|member), `confidence`(high|medium|low)
- 링크: `sources: [[..]]`, `related: [[..]]` — **신규 페이지는 기존 2개 이상과 교차링크**
- source 페이지: `source_file`, `author`, `date_published`, `date_ingested`, `key_claims: []`
- entity 페이지: `entity_type`(person|company|product|org)
- synthesis/comparison: `filed_from_query: true`, `related`(상위 개념으로 back-link 필수)
- **날짜는 frontmatter로만.** 본문에 `[[2026-06-19]]` 같은 날짜 wikilink 금지(그래프 날짜-허브 방지).

## 그래프 = 트리형
탐색 경로는 트리: `index → overview → cluster hub → member → source/synthesis`.
허브 1개의 member가 15개를 넘으면 **분할**. 중력우물(날짜·거대 허브) 만들지 말 것.

## 작업 3루프
### Ingest (`/ingest <sources/경로>`)
1. 소스를 읽는다(수정 금지). 2. 핵심 주장 3~5개를 사용자와 짚는다.
3. `wiki/sources/summary-{slug}.md` 생성. 4. 관련 concept/entity 갱신(없으면 생성).
5. 모순은 `> [!contradiction]` 콜아웃으로 명시. 6. `wiki/index.md` 갱신 + `wiki/log.md` append.
7. `git add wiki/ && git commit -m "ingest: {title}"`. (한 번에 보통 5~15개 페이지 변경)

### Query
1. `wiki/index.md`로 관련 페이지 식별 → 직접 읽기. 2. `[[wikilink]]` 인용과 함께 답변.
3. 가치 있으면 `comparisons/` 또는 `syntheses/`로 저장 제안. 4. `log.md` 갱신.

### Lint (`/lint`, 주 1회)
모순 스캔 · 고아 페이지(inbound 0) · 3회+ 언급인데 페이지 없는 개념 · stale 주장 ·
클러스터 건강(모든 페이지 `cluster` 필드, hub에 `## In this cluster`) · synthesis back-link 확인 ·
다음 조사 3~5개 제안 · `log.md`에 lint 항목 append.

## 하드 제약
- `sources/`(raw)에 **절대 쓰지 않는다.** 예외 없음.
- wiki 페이지를 **삭제하지 않는다.** frontmatter `deprecated: true`로 표시.
- 매 작업마다 `index.md`·`log.md` 갱신. 불확실하면 `confidence: low`.

## 로그 포맷 (파싱 가능)
```
## [YYYY-MM-DD] {ingest|query|lint} | {title}
Source: sources/...
Pages created: wiki/...
Pages updated: wiki/..., wiki/...
Contradictions: wiki/... (note)
```
