#!/bin/sh

# Clean previous build
rm -rf .docs

# Generate documentation
swift package \
    --allow-writing-to-directory ./.docs \
    generate-documentation \
    --target PrintAdvance \
    --output-path ./.docs \
    --transform-for-static-hosting \
    --hosting-base-path /swift-print-advance

# Create index.html that redirects to documentation
cat > .docs/index.html << 'EOF'
<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <title>PrintAdvance Documentation</title>
    <meta http-equiv="refresh" content="0; url=./documentation/printadvance/">
    <script>
        window.location.href = "./documentation/printadvance/";
    </script>
</head>
<body>
    <p>Redirecting to <a href="./documentation/printadvance/">PrintAdvance Documentation</a>...</p>
</body>
</html>
EOF

# Create .nojekyll file to prevent Jekyll processing
touch .docs/.nojekyll

# Verify documentation was generated
if [ -d ".docs/documentation" ]; then
    echo "✅ Documentation generated successfully"
    ls -la .docs/
else
    echo "❌ Documentation generation failed"
    exit 1
fi