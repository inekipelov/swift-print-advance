# Documentation Deployment Configuration

This repository is configured to automatically build and deploy DocC documentation to GitHub Pages.

## Setup

1. **Enable GitHub Pages**: Go to repository Settings → Pages → Source: GitHub Actions

2. **Permissions**: Ensure the repository has the following permissions in Settings → Actions → General:
   - Workflow permissions: Read and write permissions
   - Allow GitHub Actions to create and approve pull requests: ✓

## Workflow

The documentation is built and deployed via `.github/workflows/swift.yml`:

- **Trigger**: Push to main branch or pull requests
- **Build**: Compiles the Swift package and generates DocC documentation
- **Deploy**: Publishes to GitHub Pages at `https://[username].github.io/swift-print-advance`

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
Sources/PrintAdvance/Documentation.docc/
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
```

## URLs

Once deployed, documentation will be available at:
- Main documentation: `https://[username].github.io/swift-print-advance/documentation/printadvance/`
- Quick start: `https://[username].github.io/swift-print-advance/documentation/printadvance/quickstart`
- Tutorial: `https://[username].github.io/swift-print-advance/documentation/printadvance/tutorial`
