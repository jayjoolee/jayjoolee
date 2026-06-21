---
description: 소스 1개를 wiki로 흡수 (요약·개념/엔티티 갱신·링크·로그·커밋)
argument-hint: <sources/ 경로>
---

`$ARGUMENTS` 경로의 소스를 흡수한다. CLAUDE.md의 Ingest 절차를 그대로 따른다.

1. `$ARGUMENTS`를 읽는다. **이 파일은 절대 수정/삭제하지 않는다 (Layer 1).**
2. 핵심 주장 3~5개를 사용자에게 먼저 짚어 확인.
3. `wiki/sources/summary-{slug}.md` 생성 (templates/source.md 스키마).
4. 관련 `wiki/concepts/`·`wiki/entities/` 페이지를 갱신. 없으면 생성하되, 신규 페이지는
   기존 2개 이상과 교차링크(`related`, `sources`).
5. 다른 페이지와 충돌 시 `> [!contradiction]` 콜아웃으로 명시.
6. `wiki/index.md`에 새 페이지를 해당 cluster 아래 추가, `wiki/log.md`에 ingest 항목 append.
7. `git add wiki/ && git commit -m "ingest: {title}"`.

날짜는 frontmatter로만 기록하고 본문에 날짜 wikilink는 만들지 않는다.
