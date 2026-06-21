# Claude ↔ Obsidian 연결

## 권장: MCP 없이 Claude Code 직접 실행 (가장 단순)
LLM Wiki 패턴의 기본값. 터미널에서 vault 루트로 이동해 Claude Code 실행만 하면 된다.
파일시스템으로 마크다운을 직접 읽고 쓰며, `CLAUDE.md`가 자동 로드된다. **MCP·플러그인·API키 불필요.**

```bash
cd /path/to/LLMWiki   # vault 루트
claude                # 여기서 /today, /ingest, /lint 사용
```

## MCP가 필요한 경우 (Claude Desktop·원격·정밀 frontmatter 조작)
`obsidian-mcp-server`(cyanheads)는 노트·태그·frontmatter를 MCP로 read/write/search/편집한다.
Obsidian의 **Local REST API** 커뮤니티 플러그인을 켜고 API 키를 발급한 뒤, MCP 클라이언트
설정(`.mcp.json` 또는 Claude Desktop config)에 추가한다.

```json
{
  "mcpServers": {
    "obsidian": {
      "command": "npx",
      "args": ["-y", "obsidian-mcp-server"],
      "env": {
        "OBSIDIAN_API_KEY": "여기에-Local-REST-API-키",
        "OBSIDIAN_BASE_URL": "http://127.0.0.1:27123"
      }
    }
  }
}
```

> 패키지명·환경변수는 버전에 따라 다를 수 있으니 https://github.com/cyanheads/obsidian-mcp-server
> README를 최종 확인할 것.

## 선택: qmd 로컬 검색 (대규모 vault 토큰 절감)
BM25 + 벡터 + LLM 재랭킹을 로컬에서 수행. ingest/query 전 관련 페이지만 선로딩 → 토큰 60%+ 절감.
소스가 수십 개를 넘어가면 도입 고려.

```bash
qmd collection add ./wiki --name llmwiki
qmd index rebuild llmwiki
qmd query "TXN 배당 정책" --json
```

## 안전 수칙
- 단일 작성자 원칙: 동시에 여러 Claude 세션이 같은 파일을 쓰지 않게. 병렬이면 파일 집합을 분리.
- `sources/`(raw)는 어떤 경로로도 **쓰기 금지**.
