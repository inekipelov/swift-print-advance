##!/bin/sh

swift package \
          --allow-writing-to-directory ./docs \
          generate-documentation \
          --target PrintAdvance \
          --output-path ./docs \
          --transform-for-static-hosting \
          --hosting-base-path /swift-print-advance

echo '<script>window.location.href += "/documentation/printadvance"</script>' > docs/index.html