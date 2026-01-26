---
name: reducto-document-parsing
description: This skill should be used when the user asks to "parse a document", "extract data from PDF", "process invoices", "convert PDF to markdown", "extract structured data", "edit a document", mentions "reducto", or discusses document processing, OCR, PDF parsing, invoice extraction, form filling, or data extraction from files.
version: 1.0.0
---

# Reducto CLI - Document Processing

This skill provides guidance for using the Reducto CLI to parse, extract, and edit documents.

## Overview

Reducto CLI is a powerful document processing tool that uses AI to:
- Parse documents into clean Markdown with metadata
- Extract structured data according to JSON schemas
- Edit documents using natural language instructions

## Prerequisites

Before using reducto commands, ensure the user is authenticated:
```bash
uvx --from reducto-cli reducto login
```

This opens a browser for device code authentication.

## Supported File Types

- **PDF**: `.pdf`
- **Images**: `.png`, `.jpg`, `.jpeg`
- **Office documents**: `.doc`, `.docx`, `.ppt`, `.pptx`
- **Spreadsheets**: `.xls`, `.xlsx`

## Commands

### 1. Parse Documents

Convert documents to Markdown with YAML front matter containing metadata.

**Basic usage:**
```bash
uvx --from reducto-cli reducto parse path/to/document.pdf
```

**Parse entire directory:**
```bash
uvx --from reducto-cli reducto parse ./documents/
```

**Output:** Creates `<filename>.parse.md` files with parsed content.

#### Parse Options

| Flag | Description |
|------|-------------|
| `--agentic` | Enables all agentic options for tables, text, and figures. Increases accuracy but also increases latency. Use for complex layouts or when maximum accuracy is needed. |
| `--change-tracking` | Returns `<s>` tags around strikethrough text, `<u>` tags around underlined text, and `<change>` tags around colored adjacent strikethrough and underlined text. Useful for documents with revision history. |
| `--highlights` | Include highlighted text in output |
| `--hyperlinks` | Include embedded hyperlinks |
| `--comments` | Include document comments |

**Examples:**
```bash
# Maximum accuracy (slower)
uvx --from reducto-cli reducto parse document.pdf --agentic

# Contract with change tracking
uvx --from reducto-cli reducto parse contract.pdf --change-tracking

# All metadata
uvx --from reducto-cli reducto parse document.pdf --hyperlinks --comments --highlights

# Combined flags
uvx --from reducto-cli reducto parse legal_doc.pdf --agentic --change-tracking --comments
```

### 2. Extract Structured Data

Extract specific fields from documents into JSON using a schema.

**Basic usage:**
```bash
uvx --from reducto-cli reducto extract document.pdf --schema schema.json
```

**With inline schema:**
```bash
uvx --from reducto-cli reducto extract invoice.pdf --schema '{"type": "object", "properties": {"total": {"type": "number"}}}'
```

**Output:** Creates `<filename>.extract.json` files.

#### Schema Requirements

- Must be valid JSON Schema
- Top-level must be an object (`{"type": "object", ...}`)
- Provide explicit property definitions for deterministic mapping

#### Example Invoice Schema

```json
{
  "type": "object",
  "properties": {
    "invoice_number": {"type": "string"},
    "date": {"type": "string"},
    "vendor": {
      "type": "object",
      "properties": {
        "name": {"type": "string"},
        "address": {"type": "string"}
      }
    },
    "items": {
      "type": "array",
      "items": {
        "type": "object",
        "properties": {
          "description": {"type": "string"},
          "quantity": {"type": "number"},
          "unit_price": {"type": "number"},
          "total": {"type": "number"}
        },
        "required": ["description", "quantity", "unit_price", "total"]
      }
    },
    "subtotal": {"type": "number"},
    "tax": {"type": "number"},
    "total": {"type": "number"}
  },
  "required": ["invoice_number", "items", "total"]
}
```

#### Common Use Cases

- **Invoices/Receipts**: Extract line items, totals, vendor info
- **Contracts**: Pull key clauses, dates, parties involved
- **Forms**: Capture field values from scanned documents
- **Financial statements**: Extract tables and figures
- **Medical records**: Summarize structured results

### 3. Edit Documents

Modify documents using natural language instructions.

**Basic usage:**
```bash
uvx --from reducto-cli reducto edit document.pdf --instructions "Fill in the client name as 'Acme Corp'"
```

**Output:** Creates `<filename>.edited.<extension>` files.

**Examples:**
```bash
# Fill out a form
uvx --from reducto-cli reducto edit application.pdf -i "Fill out: Name: John Doe, Email: john@example.com"

# Modify contract details
uvx --from reducto-cli reducto edit contract.pdf -i "Set the contract date to January 15, 2024 and fill in the client name as 'Acme Corporation'"

# Process directory of forms
uvx --from reducto-cli reducto edit ./forms/ -i "Check 'Approved' box and add today's date"
```

#### Tips for Effective Instructions

- Be specific about what to modify and how
- Reference specific elements (headers, tables, specific text)
- Describe the desired outcome clearly
- For directories, ensure instructions apply uniformly

## Workflow Example

**Processing invoices from a folder:**

1. Parse all documents first:
```bash
uvx --from reducto-cli reducto parse ./invoices/
```

2. Extract data using a schema (reuses existing parses):
```bash
uvx --from reducto-cli reducto extract ./invoices/ --schema invoice_schema.json
```

3. Results are in `*.extract.json` files

## Performance Notes

- The CLI automatically reuses existing `.parse.md` files for extraction
- Use `--agentic` only when needed (complex layouts, tables, figures)
- Batch processing is supported via directory paths
- Extraction jobs reference previous parse job IDs for efficiency
