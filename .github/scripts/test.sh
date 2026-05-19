#!/bin/bash
# Local test script for Signal Hugo theme

set -e

echo "🧪 Running Signal theme tests..."

# Cleanup on exit
trap "rm -rf testbuild" EXIT

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color

# Test 1: Build the example site
echo -e "\n📦 Test 1: Building example site..."
mkdir -p testbuild/themes
cd testbuild
hugo new site . --force 2>/dev/null
ln -sf ../.. themes/signal
echo 'theme = "signal"
baseURL = "https://example.com/"
' > hugo.toml
if hugo --themesDir ./themes --minify --quiet 2>/dev/null; then
    echo -e "${GREEN}✓${NC} Build successful"
else
    echo -e "${RED}✗${NC} Build failed"
    cd ..
    exit 1
fi
cd ..

# Test 2: Check CSS file exists and is not empty
echo -e "\n📐 Test 2: Checking CSS..."
if [ -s assets/css/main.css ] && grep -q ".post-summary-content" assets/css/main.css; then
    echo -e "${GREEN}✓${NC} CSS file valid"
else
    echo -e "${RED}✗${NC} CSS file issues"
    exit 1
fi

# Test 3: Check required templates exist
echo -e "\n📄 Test 3: Checking templates..."
REQUIRED_TEMPLATES=(
    "layouts/_default/baseof.html"
    "layouts/_default/single.html"
    "layouts/_default/list.html"
    "layouts/partials/header.html"
    "layouts/partials/footer.html"
    "layouts/partials/scripts.html"
    "layouts/partials/head.html"
    "layouts/partials/social-share.html"
    "layouts/partials/author-bio.html"
    "layouts/partials/newsletter.html"
    "layouts/partials/comments.html"
    "layouts/partials/breadcrumbs.html"
    "layouts/partials/analytics.html"
)

for template in "${REQUIRED_TEMPLATES[@]}"; do
    if [ -f "$template" ]; then
        echo -e "${GREEN}✓${NC} $template exists"
    else
        echo -e "${RED}✗${NC} $template missing"
        exit 1
    fi
done

# Test 4: Check for duplicate CSS rules (exact match)
echo -e "\n🔄 Test 4: Checking for duplicate CSS rules..."
DUPLICATES=$(grep -c '^\.read-more {$' assets/css/main.css || true)
if [ "$DUPLICATES" -eq 1 ]; then
    echo -e "${GREEN}✓${NC} No duplicate .read-more rules"
else
    echo -e "${RED}✗${NC} Found $DUPLICATES .read-more rule definitions (expected 1)"
    exit 1
fi

# Test 5: Verify robots.txt exists
echo -e "\n🤖 Test 5: Checking robots.txt..."
if [ -f "layouts/robots.txt" ]; then
    echo -e "${GREEN}✓${NC} robots.txt template exists"
else
    echo -e "${RED}✗${NC} robots.txt template missing"
    exit 1
fi

# Test 5b: Verify RSS template exists
echo -e "\n📡 Test 5b: Checking RSS template..."
if [ -f "layouts/_default/rss.xml" ] || [ -f "layouts/rss.xml" ]; then
    echo -e "${GREEN}✓${NC} RSS template exists"
else
    echo -e "${RED}✗${NC} RSS template missing"
    exit 1
fi

# Test 5c: Verify sitemap exists
echo -e "\n🗺️ Test 5c: Checking sitemap..."
if [ -f "layouts/_default/sitemap.xml" ]; then
    echo -e "${GREEN}✓${NC} Sitemap template exists"
else
    echo -e "${RED}✗${NC} Sitemap template missing"
    exit 1
fi

# Test 6: Check theme.toml is valid TOML
echo -e "\n⚙️ Test 6: Checking theme.toml..."
if python3 -c "import tomllib; tomllib.load(open('theme.toml', 'rb'))" 2>/dev/null; then
    echo -e "${GREEN}✓${NC} theme.toml valid"
else
    echo -e "${RED}✗${NC} theme.toml has syntax errors"
    exit 1
fi

# Test 7: Check for rel="noopener noreferrer" on external links (anchor tags only)
echo -e "\n🔒 Test 7: Checking security attributes..."
# Forms with target="_blank" don't need noopener (only anchor tags do)
if grep -r '<a.*target="_blank"' layouts/partials/*.html | grep -v 'noopener' | grep -v 'rel="' > /dev/null; then
    echo -e "${RED}✗${NC} Found external links without rel=\"noopener noreferrer\""
    exit 1
else
    echo -e "${GREEN}✓${NC} All external links have security attributes"
fi

# Test 8: Check JS attribute usage has CSS selector support
echo -e "\n🔍 Test 8: Checking JS/CSS consistency..."
if grep -q 'setAttribute.*\bdata-theme\b' layouts/partials/scripts.html 2>/dev/null; then
    if ! grep -q '\[data-theme=' assets/css/main.css; then
        echo -e "${RED}✗${NC} JS uses data-theme but CSS missing [data-theme] selectors"
        exit 1
    fi
    echo -e "${GREEN}✓${NC} JS/CSS attribute consistency check passed"
fi

# Test 9: Check for required CSS selectors used by JavaScript
echo -e "\n🎯 Test 9: Checking required CSS selectors..."
REQUIRED_SELECTORS=(
    "\.back-to-top"
    "\.theme-toggle"
    "\.nav-toggle"
    "\.nav-menu"
    "\.search-toggle"
    "\.search-overlay"
    "\.reading-progress"
    "\.skip-link"
    "\.post-content"
    "\.post-summary"
    "\.post-preview"
    "\.toc"
    "\.breadcrumbs"
    "\.author-bio"
    "\.newsletter"
    "\.share-buttons"
    "\.comments"
    "\.related-posts"
)
for selector in "${REQUIRED_SELECTORS[@]}"; do
    if ! grep -q "$selector" assets/css/main.css 2>/dev/null && ! grep -q "$selector" layouts/*.html 2>/dev/null; then
        echo -e "${RED}✗${NC} Missing template element for JS selector: $selector"
        exit 1
    fi
done
echo -e "${GREEN}✓${NC} All required CSS selectors present"

# Test 10: Check template parameter usage consistency
echo -e "\n📋 Test 10: Checking template parameter references..."
PARAMS_USED=$(grep -roh '\.Site\.Params\.[^ )"]*' layouts/ | sort -u | sed 's/\.Site\.Params\.//' | cut -d'.' -f1)
KNOWN_PARAMS="author description logoIcon comments giscus authorBio social newsletter share analytics disableBreadcrumb footerDescription footerTitle"
for param in $PARAMS_USED; do
    if ! echo "$KNOWN_PARAMS" | grep -qw "$param"; then
        echo -e "${YELLOW}⚠${NC} Template uses param '$param' - consider documenting in README"
    fi
done
echo -e "${GREEN}✓${NC} Template parameter check complete"

echo -e "\n${GREEN}✅ All tests passed!${NC}"
