# Reducto Claude Code Plugins

**Document work starts here.** Parse, extract, classify, and edit PDFs, images, spreadsheets, and Office documents directly inside [Claude Code](https://claude.ai) — powered by [Reducto](https://reducto.ai), the agentic document platform.

Reducto is the complete agentic document platform for AI teams that need enterprise performance at scale. It provides a comprehensive toolkit for working with documents the way a human would, orchestrating custom in-house and frontier models to power accurate, efficient document workflows. This plugin brings those capabilities into your Claude Code workflow — so you and your agents can process invoices, contracts, medical records, financial filings, and more without leaving your terminal.

Trusted by leading AI teams at Harvey, Scale AI, Vanta, and others.

## Why Reducto

- **Performance for your workload** — zero-shot accuracy on complex documents, balanced against latency and throughput for your use case. A dozen+ models orchestrated under the hood, continuously updated so you don't have to chase the frontier. Handles long-tail complexity (tables, charts, figures, handwriting, scans) without breaking.
- **Enterprise-ready** — deployable hosted, in your VPC, on-premises, or fully air-gapped. SOC 2 Type II and HIPAA compliant with zero data retention by default. Autoscaling, custom SLAs, and white-glove FDE support for production workloads.
- **Complete toolkit** — one platform for every document task: parse, classify, split, extract, and edit. Covers 30+ file types — not just PDFs — with agent-ready tooling (CLI, MCP, plugins) and workflows for triggers, human-in-the-loop, and scale.

## Installation

### Via Vercel Skills CLI (recommended)

```bash
npx skills add reductoai/claude-plugins
```

### Via Claude Code Plugin System

Add this marketplace to Claude Code:

```
/plugin marketplace add reductoai/claude-plugins
```

Then install the plugin:

```
/plugin install reducto-cli@reducto-plugins
```

## Quick Start

```bash
# 1. Authenticate with your Reducto account
uvx --from reducto-cli reducto login

# 2. Parse a PDF into clean Markdown
uvx --from reducto-cli reducto parse document.pdf

# 3. Extract structured JSON from an invoice
uvx --from reducto-cli reducto extract invoice.pdf --schema schema.json

# 4. Fill out a form with natural language
uvx --from reducto-cli reducto edit form.pdf --instructions "Fill in name as 'John Doe'"
```

## Plugin: reducto-cli

### Parse — Convert Documents to Markdown

Transform any supported document into clean, structured Markdown with optional YAML metadata. Parsed output preserves document layout, tables, figures, and semantic structure.

```bash
uvx --from reducto-cli reducto parse document.pdf
uvx --from reducto-cli reducto parse ./documents/   # batch process a directory
```

**Options:**

| Flag | Description |
|------|-------------|
| `--agentic` | Maximum accuracy mode — uses agentic OCR for tables, text, and figures (slower) |
| `--change-tracking` | Outputs `<s>`, `<u>`, and `<change>` tags for tracked revisions |
| `--highlights` | Includes highlighted text in output |
| `--hyperlinks` | Preserves embedded hyperlinks |
| `--comments` | Includes document comments and annotations |

```bash
# High-accuracy parse with full metadata
uvx --from reducto-cli reducto parse contract.pdf --agentic --change-tracking --comments
```

Output files are written as `<filename>.parse.md`.

### Extract — Pull Structured Data with JSON Schema

Define the data you need using a [JSON Schema](https://json-schema.org/) and Reducto extracts it into typed JSON. The top-level schema type must be `object`.

```bash
uvx --from reducto-cli reducto extract invoice.pdf --schema schema.json
```

**Example schema for invoice extraction:**

```json
{
  "type": "object",
  "properties": {
    "invoice_number": { "type": "string" },
    "date": { "type": "string" },
    "vendor": {
      "type": "object",
      "properties": {
        "name": { "type": "string" },
        "address": { "type": "string" }
      }
    },
    "line_items": {
      "type": "array",
      "items": {
        "type": "object",
        "properties": {
          "description": { "type": "string" },
          "quantity": { "type": "number" },
          "unit_price": { "type": "number" },
          "total": { "type": "number" }
        },
        "required": ["description", "quantity", "unit_price", "total"]
      }
    },
    "total": { "type": "number" }
  },
  "required": ["invoice_number", "line_items", "total"]
}
```

You can also pass schemas inline:

```bash
uvx --from reducto-cli reducto extract receipt.pdf --schema '{"type":"object","properties":{"total":{"type":"number"},"date":{"type":"string"}}}'
```

Output files are written as `<filename>.extract.json`.

### Edit — Modify Documents with Natural Language

Programmatically fill forms, update fields, and modify documents using plain English instructions. Edited files are returned in their original format.

```bash
uvx --from reducto-cli reducto edit application.pdf -i "Fill out: Name: Jane Smith, Email: jane@example.com"
uvx --from reducto-cli reducto edit contract.pdf -i "Set the effective date to March 1, 2025 and the client name to Acme Corp"
uvx --from reducto-cli reducto edit ./forms/ -i "Check the 'Approved' box and sign with today's date"
```

Output files are written as `<filename>.edited.<ext>`.

## Supported File Types

| Category | Formats |
|----------|---------|
| PDF | `.pdf` |
| Images | `.png`, `.jpg`, `.jpeg` |
| Word Documents | `.doc`, `.docx` |
| Presentations | `.ppt`, `.pptx` |
| Spreadsheets | `.xls`, `.xlsx` |

Reducto handles scanned documents, faxes, and handwritten content through its agentic OCR pipeline, and supports a wide range of languages including mixed-language and non-Latin-script documents.

## Use Cases

### Invoice and Receipt Processing
Parse a folder of invoices, extract line items, totals, and vendor info into JSON, then feed the structured data into your accounting pipeline.

```bash
uvx --from reducto-cli reducto extract ./invoices/ --schema invoice_schema.json
```

### Contract Review and Clause Extraction
Convert legal contracts to Markdown with change tracking enabled, then extract specific clauses, dates, and party names.

```bash
uvx --from reducto-cli reducto parse contract.pdf --agentic --change-tracking
uvx --from reducto-cli reducto extract contract.pdf --schema '{"type":"object","properties":{"effective_date":{"type":"string"},"termination_clause":{"type":"string"},"parties":{"type":"array","items":{"type":"string"}}}}'
```

### Financial Document Analysis
Extract tables and figures from SEC filings, earnings reports, and investor decks with high-accuracy agentic parsing.

```bash
uvx --from reducto-cli reducto parse 10-K_filing.pdf --agentic
```

### Automated Form Filling
Batch-fill PDF application forms, onboarding packets, or compliance documents using natural language instructions.

```bash
uvx --from reducto-cli reducto edit ./onboarding_forms/ -i "Fill in employee name: Alex Chen, start date: 2025-04-01, department: Engineering"
```

### RAG Pipeline Document Preparation
Parse documents into structured Markdown optimized for chunking and embedding in retrieval-augmented generation systems.

```bash
uvx --from reducto-cli reducto parse ./knowledge_base/ --agentic
```

### Medical Record Summarization
Extract patient info, diagnoses, and treatment plans from medical documents using a custom schema.

### Insurance Claims Processing
Parse claim forms and supporting documents, then extract policy numbers, incident details, and damage assessments into structured data.

### Multi-Language Document Processing
Process documents across a wide range of languages — Reducto handles mixed-language content and non-Latin scripts through its vision-language models.

## Requirements

- Claude Code 1.0.33 or later
- [UV](https://docs.astral.sh/uv/) (automatically installed by the plugin if not present)
- A [Reducto](https://reducto.ai) account — sign up at [studio.reducto.ai](https://studio.reducto.ai)

## Resources

- [Reducto Website](https://reducto.ai) — agentic document platform overview
- [Documentation](https://docs.reducto.ai) — full API reference, guides, and cookbooks
- [Studio](https://studio.reducto.ai) — web dashboard and interactive playground
- [GitHub](https://github.com/reductoai) — SDKs, examples, and open-source tools
- [Python SDK](https://github.com/reductoai/reducto-python-sdk) — official Python client
- [Node.js SDK](https://github.com/reductoai/reducto-node-sdk) — official Node.js client
- [Status Page](https://status.reducto.ai) — uptime and incident monitoring
- [Trust Center](https://trust.reducto.ai) — SOC 2 Type II, HIPAA compliance, and security documentation
- Support: [support@reducto.ai](mailto:support@reducto.ai)

## License

MIT
