#!/bin/bash

# Generate and preview DocC documentation locally

echo "🏗️  Building documentation..."
swift package generate-documentation --target PrintAdvance

if [ $? -eq 0 ]; then
    echo "✅ Documentation built successfully!"
    echo ""
    echo "📖 Opening documentation in browser..."
    
    # Open the documentation archive
    open .build/plugins/Swift-DocC/outputs/PrintAdvance.doccarchive
    
    echo ""
    echo "📚 Documentation archive location:"
    echo "   .build/plugins/Swift-DocC/outputs/PrintAdvance.doccarchive"
    echo ""
    echo "🌐 To host locally, run:"
    echo "   swift package --disable-sandbox preview-documentation --target PrintAdvance"
else
    echo "❌ Documentation build failed!"
    exit 1
fi
