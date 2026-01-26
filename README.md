# Reducto Claude Code Plugins

Official plugin marketplace for [Reducto](https://reducto.ai) tools in Claude Code.

## Installation

Add this marketplace to Claude Code:

```
/plugin marketplace add reductoai/claude-plugins
```

Then install the plugins you want:

```
/plugin install reducto-cli@reducto-plugins
```

## Available Plugins

### reducto-cli

Parse, extract, and edit documents using Reducto's AI-powered platform.

**Features:**
- **Parse** documents into clean Markdown with metadata
- **Extract** structured data using JSON schemas
- **Edit** documents using natural language instructions

**Supported file types:**
- PDF (`.pdf`)
- Images (`.png`, `.jpg`, `.jpeg`)
- Office documents (`.doc`, `.docx`, `.ppt`, `.pptx`)
- Spreadsheets (`.xls`, `.xlsx`)

**Quick start:**
```bash
# Authenticate
uvx --from reducto-cli reducto login

# Parse a document
uvx --from reducto-cli reducto parse document.pdf

# Extract structured data
uvx --from reducto-cli reducto extract invoice.pdf --schema schema.json

# Edit a document
uvx --from reducto-cli reducto edit form.pdf --instructions "Fill in name as 'John Doe'"
```

## Requirements

- Claude Code 1.0.33 or later
- UV (automatically installed by the plugin if not present)

## License

MIT
