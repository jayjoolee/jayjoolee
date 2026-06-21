#!/usr/bin/env bash
#
# LLMWiki 키트 설치 스크립트
# 사용법:  bash install.sh [VAULT_경로]      (생략하면 현재 폴더를 vault로 간주)
#
# 하는 일: graph.json 적용, CLAUDE.md/VAULT-INDEX.md 배치, 슬래시 커맨드/템플릿 복사,
#          wiki/ 골격 생성. 덮어쓰기 전에 항상 .bak 백업을 남기고, sources/ 는 절대 안 건드림.

set -euo pipefail

VAULT="${1:-$PWD}"
KIT_LLM="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"   # obsidian-llm-wiki/
REPO="$(cd "$KIT_LLM/.." && pwd)"                          # repo 루트
KIT_GRAPH="$REPO/obsidian-graph-fix"

if [ ! -d "$VAULT/.obsidian" ]; then
  echo "⚠️  '$VAULT' 에 .obsidian 폴더가 없습니다 (옵시디언 vault가 아님)."
  echo "    vault 루트 경로를 직접 주세요:  bash install.sh /path/to/LLMWiki"
  exit 1
fi

ts="$(date +%Y%m%d-%H%M%S)"
backup() { if [ -e "$1" ]; then cp -a "$1" "$1.bak-$ts"; echo "  ↳ 백업: $(basename "$1").bak-$ts"; fi; }

echo "▶ Vault: $VAULT"

# 1) 그래프 보기 설정
backup "$VAULT/.obsidian/graph.json"
cp "$KIT_GRAPH/graph.json" "$VAULT/.obsidian/graph.json"
echo "✓ .obsidian/graph.json 적용 (날짜 허브 필터 + 색 그룹)"

# 2) CLAUDE.md (vault 루트 운영 스키마)
backup "$VAULT/CLAUDE.md"
cp "$KIT_LLM/CLAUDE.md" "$VAULT/CLAUDE.md"
echo "✓ CLAUDE.md (vault 루트)"

# 3) VAULT-INDEX.md (없을 때만)
[ -e "$VAULT/VAULT-INDEX.md" ] || cp "$KIT_LLM/VAULT-INDEX.md" "$VAULT/VAULT-INDEX.md"
echo "✓ VAULT-INDEX.md"

# 4) 슬래시 커맨드
mkdir -p "$VAULT/.claude/commands"
cp "$KIT_LLM/claude-commands/"*.md "$VAULT/.claude/commands/"
echo "✓ .claude/commands/  (/today /close /ingest /lint /my-world)"

# 5) 템플릿 (frontmatter + 데일리/MOC)
mkdir -p "$VAULT/_templates"
cp "$KIT_LLM/templates/"*.md "$VAULT/_templates/"
cp "$KIT_GRAPH/templates/"*.md "$VAULT/_templates/" 2>/dev/null || true
echo "✓ _templates/  (source/concept/entity/synthesis + 데일리/MOC)"

# 6) wiki/ 골격 (Layer 2)
mkdir -p "$VAULT/wiki/sources" "$VAULT/wiki/concepts" "$VAULT/wiki/entities" \
         "$VAULT/wiki/comparisons" "$VAULT/wiki/syntheses"
[ -e "$VAULT/wiki/index.md" ] || printf '# Wiki Index (MOC)\n\n> 클러스터별 카탈로그. ingest 시 자동 갱신.\n' > "$VAULT/wiki/index.md"
[ -e "$VAULT/wiki/log.md" ]   || printf '# Activity Log\n' > "$VAULT/wiki/log.md"
[ -e "$VAULT/wiki/hot.md" ]   || printf '# Hot (세션 캐시 ~500단어)\n' > "$VAULT/wiki/hot.md"
echo "✓ wiki/ 골격 생성 (sources/concepts/entities/comparisons/syntheses + index/log/hot)"

echo
echo "✅ 설치 완료. sources/ 는 그대로 둠."
echo "   다음 → vault 루트에서  claude  실행 후  /today  또는  /ingest sources/<파일>"
echo "   원복 → 이번에 생긴  *.bak-$ts  파일들을 되돌리면 됩니다."
