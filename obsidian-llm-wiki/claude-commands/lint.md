---
description: 주간 위키 건강검진 (고아·모순·빈 개념·트리형 점검)
---

CLAUDE.md의 Lint 절차로 `wiki/` 전체를 점검하고 리포트하라. 자동 수정하지 말고 제안 먼저.

1. 페이지 간 **모순** 스캔 → 목록.
2. **고아 페이지**(inbound 링크 0) 탐색 → 목록.
3. 본문에서 3회 이상 언급되는데 **dedicated 페이지가 없는 개념** 목록.
4. 최신 소스에 의해 뒤집힌 **stale 주장** 점검.
5. **클러스터 건강**: 모든 페이지에 `cluster` 필드가 있는지, hub 페이지에 `## In this cluster`
   섹션이 있는지, 허브 member가 15개를 넘는지(넘으면 분할 제안).
6. `synthesis`/`comparison`의 상위 개념 **back-link** 누락 확인.
7. 다음에 파볼 **조사 주제 3~5개** 제안.
8. `wiki/log.md`에 lint 요약 1줄 append.

각 항목은 [[wikilink]]로 바로 갈 수 있게 제시한다.
