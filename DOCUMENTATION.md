# Documentation Deployment Configuration

This repository is configured to automatically build and deploy DocC documentation to GitHub Pages using separate workflows.

## Workflows

### 1. swift.yml - Build & Test
- **Purpose**: Build validation and testing
- **Trigger**: Push to any branch, Pull requests  
- **Actions**: Compile package and run tests only

### 2. docs.yml - Documentation  
- **Purpose**: Generate and deploy documentation
- **Trigger**: Push to main branch, Manual dispatch
- **Actions**: Build, test, generate docs, deploy to GitHub Pages

## Setup

1. **Enable GitHub Pages**: Go to repository Settings → Pages → Source: GitHub Actions

2. **Permissions**: Ensure the repository has the following permissions in Settings → Actions → General:
   - Workflow permissions: Read and write permissions
   - Allow GitHub Actions to create and approve pull requests: ✓

## Deployment Process

The documentation workflow (`docs.yml`) performs these steps:

1. **Build & Test**: Ensures package builds and tests pass
2. **Generate DocC Archive**: Creates documentation bundle
3. **Transform for Static Hosting**: Converts to GitHub Pages compatible format
4. **Deploy**: Publishes to GitHub Pages at `https://inekipelov.github.io/swift-print-advance/documentation/printadvance/`

## Local Development

Generate documentation locally:

```bash
# Quick generation and preview
./scripts/generate-docs.sh

# Manual generation
swift package generate-documentation --target PrintAdvance

# Local preview server
swift package --disable-sandbox preview-documentation --target PrintAdvance
```

## Documentation Structure

```
Documentation.docc/                  # Documentation bundle in project root
├── PrintAdvance.md              # Main documentation page
├── QuickStart.md               # Getting started guide
├── Installation.md             # Installation instructions
├── Tutorial.md                 # Step-by-step tutorial
├── CoreExtensions.md           # Core API documentation
├── CustomOutputs.md            # Custom output creation
├── ModifyingOutputs.md         # Output modifiers guide
├── SwiftUIIntegration.md       # SwiftUI integration
├── CombineIntegration.md       # Combine integration
├── ResultUtilities.md          # Result type utilities
├── PerformanceConsiderations.md # Performance optimization
├── Troubleshooting.md          # Common issues and solutions
└── README.md                   # Documentation guidelines
Sources/
Tests/
Package.swift
```

## URLs

Once deployed, documentation will be available at:
- Main documentation: `https://[username].github.io/swift-print-advance/documentation/printadvance/`
- Quick start: `https://[username].github.io/swift-print-advance/documentation/printadvance/quickstart`
- Tutorial: `https://[username].github.io/swift-print-advance/documentation/printadvance/tutorial`
