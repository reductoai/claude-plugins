# Reducto CLI Plugin

A Claude Code plugin for document processing using [Reducto's](https://reducto.ai) AI-powered platform.

## Features

- **Parse** documents into clean Markdown with metadata
- **Extract** structured data using JSON schemas
- **Edit** documents using natural language instructions

## Supported File Types

- PDF (`.pdf`)
- Images (`.png`, `.jpg`, `.jpeg`)
- Office documents (`.doc`, `.docx`, `.ppt`, `.pptx`)
- Spreadsheets (`.xls`, `.xlsx`)

## Installation

Install via Claude Code plugin system:

```
/plugin install reducto-cli@claude-plugin-directory
```

Or browse for it in `/plugin > Discover`.

The plugin will automatically install `reducto-cli` using UV during installation.

## Usage

### Authentication

Before using reducto commands, authenticate:

```bash
uvx --from reducto-cli reducto login
```

### Parse Documents

Convert documents to Markdown:

```bash
uvx --from reducto-cli reducto parse document.pdf
uvx --from reducto-cli reducto parse ./documents/  # entire directory
```

Options:
- `--agentic` - Maximum accuracy (slower)
- `--change-tracking` - Track document revisions
- `--highlights` - Include highlighted text
- `--hyperlinks` - Include embedded links
- `--comments` - Include document comments

### Extract Structured Data

Extract fields using JSON schemas:

```bash
uvx --from reducto-cli reducto extract invoice.pdf --schema schema.json
```

### Edit Documents

Modify documents with natural language:

```bash
uvx --from reducto-cli reducto edit form.pdf --instructions "Fill in name as 'John Doe'"
```

## Structure

```
reducto-cli/
├── .claude-plugin/
│   └── plugin.json       # Plugin metadata
├── hooks/
│   └── post-install.sh   # UV bootstrapping script
├── skills/
│   └── reducto-document-parsing/
│       └── SKILL.md      # Usage instructions for Claude
└── README.md
```

## Requirements

- UV (automatically installed if not present)
- Reducto API access (via `reducto login`)

## License

MIT
