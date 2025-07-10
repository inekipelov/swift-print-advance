# PrintAdvance Documentation

This directory contains the DocC documentation for PrintAdvance.

## Structure

- `PrintAdvance.md` - Main documentation page
- `QuickStart.md` - Getting started guide
- `Installation.md` - Installation instructions
- `CoreExtensions.md` - Core printing extensions
- `CustomOutputs.md` - Creating custom output destinations
- `ModifyingOutputs.md` - Using and creating output modifiers
- `SwiftUIIntegration.md` - SwiftUI integration guide
- `CombineIntegration.md` - Combine integration guide
- `ResultUtilities.md` - Result type debugging
- `PerformanceConsiderations.md` - Performance optimization guide

## Building Documentation

### Local Development

Generate and open documentation:

```bash
./scripts/generate-docs.sh
```

Or manually:

```bash
# Generate documentation
swift package generate-documentation --target PrintAdvance

# Preview documentation with local server
swift package --disable-sandbox preview-documentation --target PrintAdvance
```

### GitHub Actions

Documentation is automatically built and deployed to GitHub Pages on every push to the main branch.

## Documentation Guidelines

### Writing Style

- Use clear, concise language
- Include practical examples
- Provide context for when to use features
- Cover both basic and advanced use cases

### Code Examples

- All examples should be compilable
- Use meaningful variable names
- Show both success and error cases
- Include imports when necessary

### Cross-References

- Link to related topics using `<doc:ArticleName>`
- Reference symbols using double backticks: `` `SymbolName` ``
- Use descriptive link text

### Best Practices

- Start with overview and basic usage
- Progress from simple to complex examples
- Include performance considerations
- Provide troubleshooting tips
- Keep examples focused and relevant

## Contributing

When adding new documentation:

1. Follow the existing structure and style
2. Test all code examples
3. Generate documentation locally to check for warnings
4. Update cross-references as needed
5. Add new articles to the main Topics section in `PrintAdvance.md`
