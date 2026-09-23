#!/bin/bash

# --- Shehan Bandara Academy Deployment Script ---

# 1. Configuration
PROJECT_NAME="shehan_bandara_academy"
ZIP_NAME="${PROJECT_NAME}_deploy.zip"

# Files the site cannot work without
REQUIRED_FILES=(
    "index.html"
    "portrait.jpg"
    "sketch.jpg"
    "era_anuradhapura.jpg"
    "era_polonnaruwa.jpg"
    "era_kandy.jpg"
    "era_colonial.jpg"
    "historical_artifacts.jpg"
    "historical_statue.jpg"
)

echo "------------------------------------------------"
echo "🚀 Preparing Deployment for: $PROJECT_NAME"
echo "------------------------------------------------"

# 2. Check for required files
echo "🔍 Checking project files..."
MISSING=0
for file in "${REQUIRED_FILES[@]}"; do
    if [ ! -f "$file" ]; then
        echo "❌ Error: Required file '$file' is missing!"
        MISSING=1
    fi
done
if [ "$MISSING" -ne 0 ]; then
    echo "🛑 Fix the missing files above and try again."
    exit 1
fi
echo "✅ All core files found."

# 3. Make sure we have the zip command
if ! command -v zip > /dev/null 2>&1; then
    echo "❌ Error: 'zip' command not found on this system."
    echo "   On Windows (PowerShell) you can run instead:"
    echo "   Compress-Archive -Path index.html,*.jpg -DestinationPath $ZIP_NAME -Force"
    exit 1
fi

# 4. Create a clean deployment bundle (all pages + every image)
echo "📦 Creating production bundle: $ZIP_NAME"
rm -f "$ZIP_NAME"
zip -q "$ZIP_NAME" index.html *.jpg
if [ ! -f "$ZIP_NAME" ]; then
    echo "❌ Error: Bundle creation failed!"
    exit 1
fi
echo "✅ Bundle created successfully ($(du -h "$ZIP_NAME" | cut -f1))."
echo "   Included: index.html + $(ls -1 *.jpg 2>/dev/null | wc -l) images"

# 5. Deployment Instructions
echo ""
echo "------------------------------------------------"
echo "🌐 HOW TO DEPLOY YOUR SITE:"
echo "------------------------------------------------"
echo "Option A: MANUAL (Recommended for Beginners)"
echo "1. Download '$ZIP_NAME'"
echo "2. Upload it to your hosting provider (e.g., Kozow.com, cPanel, or Netlify)"
echo "3. Extract the files in the root folder."
echo ""
echo "Option B: NETLIFY (Instant & Free)"
echo "1. Go to https://app.netlify.com"
echo "2. Drag and drop the '$ZIP_NAME' file onto the Netlify dashboard."
echo ""
echo "Option C: VERCEL (Professional)"
echo "1. Install Vercel CLI: 'npm i -g vercel'"
echo "2. Run: 'vercel deploy --prod'"
echo "------------------------------------------------"
echo "🔗 OFFICIAL LINKS (already embedded in the site menu):"
echo "   WhatsApp Channel : https://whatsapp.com/channel/0029VatXwt51NCrSgGvJ421s"
echo "   Facebook         : https://www.facebook.com/malinda.shehan.520/"
echo "   Live site URL    : (paste your Netlify/Vercel link here after first deploy)"
echo "------------------------------------------------"
echo "🎉 Your Legacy Academy is ready for the world!"
