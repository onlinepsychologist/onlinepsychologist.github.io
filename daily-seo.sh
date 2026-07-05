#!/bin/bash
# =============================================
# DAILY SEO - FULLY AUTOMATIC
# Run: bash daily-seo.sh
# You only need to: copy-paste social posts
# =============================================

cd /home/zubair/onlinepsychologist

DATE=$(date +"%Y-%m-%d")
KEYWORDS_FILE="social-posts/keywords.txt"
CONTENT_DB="social-posts/content-db.txt"
TRACKER="social-posts/tracker.md"
COUNTER_FILE="social-posts/.counter"

# Get current keyword index
if [ ! -f "$COUNTER_FILE" ]; then
    echo 0 > "$COUNTER_FILE"
fi
INDEX=$(cat "$COUNTER_FILE")
TOTAL=$(wc -l < "$KEYWORDS_FILE")

# Get today's keyword
INDEX=$(( (INDEX + 1) % TOTAL ))
echo $INDEX > "$COUNTER_FILE"

KEYWORD=$(sed -n "$((INDEX + 1))p" "$KEYWORDS_FILE")
SLUG=$(echo "$KEYWORD" | tr ' ' '-' | tr '[:upper:]' '[:lower:]')
FILENAME="$SLUG.html"

echo "========================================"
echo "  AUTOMATIC DAILY SEO - $DATE"
echo "  Keyword: $KEYWORD"
echo "========================================"

# Extract content for this keyword from content DB
extract_field() {
    local field="$1"
    local result=$(awk -v keyword="$KEYWORD" -v fld="$field" '
        BEGIN { in_section = 0 }
        {
            if (index($0, "---KEYWORD---") == 1) { in_section = 0 }
            if (in_section && index($0, fld "=") == 1) {
                val = substr($0, length(fld) + 2)
                print val
                exit
            }
            if ($0 == keyword) { in_section = 1 }
        }
    ' "$CONTENT_DB")
    
    if [ -z "$result" ]; then
        echo ""
    else
        echo "$result"
    fi
}

HEADLINE=$(extract_field "headline")
SUBTITLE=$(extract_field "subtitle")
INTRO=$(extract_field "intro")
H2_1=$(extract_field "h2_1")
P2=$(extract_field "p2")
H2_2=$(extract_field "h2_2")
H3_1=$(extract_field "h3_1")
P4=$(extract_field "p4")
H3_2=$(extract_field "h3_2")
P5=$(extract_field "p5")
H2_3=$(extract_field "h2_3")
LI_1=$(extract_field "li_1")
LI_2=$(extract_field "li_2")
LI_3=$(extract_field "li_3")
LI_4=$(extract_field "li_4")
LI_5=$(extract_field "li_5")
H2_4=$(extract_field "h2_4")
P6=$(extract_field "p6")

# Use defaults if empty
[ -z "$HEADLINE" ] && HEADLINE="Mental Health Support: $KEYWORD"
[ -z "$SUBTITLE" ] && SUBTITLE="Professional help from a qualified clinical psychologist"
[ -z "$INTRO" ] && INTRO="Taking care of your mental health is one of the most important things you can do. If you're searching for '$KEYWORD', you're in the right place."
[ -z "$H2_1" ] && H2_1="Why This Matters"
[ -z "$P2" ] && P2="Mental health affects every aspect of your life. Getting the right support can make a significant difference in how you feel and function."
[ -z "$H2_2" ] && H2_2="How I Can Help"
[ -z "$H3_1" ] && H3_1="Professional Support"
[ -z "$P4" ] && P4="As a qualified clinical psychologist with 3+ years of experience, I provide evidence-based therapy tailored to your needs."
[ -z "$H3_2" ] && H3_2="Convenient Online Sessions"
[ -z "$P5" ] && P5="Sessions are conducted via secure video call. No travel needed, flexible scheduling available."
[ -z "$H2_3" ] && H2_3="Key Benefits"
[ -z "$LI_1" ] && LI_1="Qualified clinical psychologist with MS degree"
[ -z "$LI_2" ] && LI_2="Evidence-based therapeutic approaches"
[ -z "$LI_3" ] && LI_3="Flexible scheduling including evenings"
[ -z "$LI_4" ] && LI_4="Multi-language support (English, Urdu, Punjabi)"
[ -z "$LI_5" ] && LI_5="Affordable rates with package options"
[ -z "$H2_4" ] && H2_4="Get Started Today"
[ -z "$P6" ] && P6="Ready to take the first step? Book a free 15-minute consultation to discuss your needs."

TOPIC=$(echo "$KEYWORD" | sed 's/.*/\u&/')
META_DESC="$(echo "$HEADLINE" | sed 's/://g'). Professional online therapy and counseling from a qualified clinical psychologist. Book your session today."
OG_TITLE="$HEADLINE | Muhammad Zubair"
TITLE="$HEADLINE | Muhammad Zubair"

# Generate blog post
echo "[1/4] Creating blog post..."
sed -e "s/__FILENAME__/$FILENAME/g" \
    -e "s/__DATE__/$DATE/g" \
    -e "s/__TOPIC__/$TOPIC/g" \
    -e "s/__HEADLINE__/$HEADLINE/g" \
    -e "s/__SUBTITLE__/$SUBTITLE/g" \
    -e "s/__META_DESC__/$META_DESC/g" \
    -e "s/__OG_TITLE__/$OG_TITLE/g" \
    -e "s/__TITLE__/$TITLE/g" \
    -e "s/__INTRO_P1__/$INTRO/g" \
    -e "s/__H2_1__/$H2_1/g" \
    -e "s/__P2__/$P2/g" \
    -e "s/__H2_2__/$H2_2/g" \
    -e "s/__P3__/$P2/g" \
    -e "s/__H3_1__/$H3_1/g" \
    -e "s/__P4__/$P4/g" \
    -e "s/__H3_2__/$H3_2/g" \
    -e "s/__P5__/$P5/g" \
    -e "s/__H2_3__/$H2_3/g" \
    -e "s/__LI_1__/$LI_1/g" \
    -e "s/__LI_2__/$LI_2/g" \
    -e "s/__LI_3__/$LI_3/g" \
    -e "s/__LI_4__/$LI_4/g" \
    -e "s/__LI_5__/$LI_5/g" \
    -e "s/__H2_4__/$H2_4/g" \
    -e "s/__P6__/$P6/g" \
    social-posts/blog-template.html > "blog/$FILENAME"

echo "  Created: blog/$FILENAME"

# Step 2: Update sitemap
echo "[2/4] Updating sitemap..."
SITEMAP="sitemap.xml"
BLOG_URL="https://onlinepsychologist.github.io/blog/$FILENAME"
NEW_ENTRY="  <url>\n    <loc>$BLOG_URL</loc>\n    <lastmod>$DATE</lastmod>\n    <changefreq>monthly</changefreq>\n    <priority>0.6</priority>\n  </url>"

# Insert before closing </urlset>
sed -i "/<\/urlset>/i\\  <url>\n    <loc>$BLOG_URL</loc>\n    <lastmod>$DATE</lastmod>\n    <changefreq>monthly</changefreq>\n    <priority>0.6</priority>\n  </url>" "$SITEMAP"

echo "  Sitemap updated"

# Step 3: Generate social posts
echo "[3/4] Generating social media posts..."
POSTS_FILE="social-posts/today.txt"

cat > "$POSTS_FILE" << EOP
========================================
SOCIAL MEDIA POSTS - $DATE
Target Keyword: $KEYWORD
========================================

[FACEBOOK POST]:
$HEADLINE

$INTRO

I offer professional online therapy sessions — convenient, affordable, and confidential.
Free 15-minute consultation: https://wa.me/923187036719

#MentalHealthPakistan #Therapy #Lahore #Psychology

[LINKEDIN POST]:
$HEADLINE

$SUBTITLE

Book a free consultation: https://calendly.com/mzpakistani9

[WHATSAPP STATUS]:
Need support with "$KEYWORD"? I'm available for online therapy.
Free consultation: https://wa.me/923187036719

[BLOG POST LINK]:
https://onlinepsychologist.github.io/blog/$FILENAME

========================================
YOUR JOB: Copy-paste these to Facebook & LinkedIn
========================================
EOP

echo "  Posts saved to: $POSTS_FILE"

# Step 4: Push to GitHub
echo "[4/4] Pushing to GitHub..."
git add -A
git commit -m "Daily SEO: $KEYWORD - $DATE"
git push

# Update tracker
echo ""
echo "---" >> "$TRACKER"
echo "| $DATE | $KEYWORD | Posted: ___ |" >> "$TRACKER"

echo ""
echo "========================================"
echo "  DONE! ✅"
echo "========================================"
echo ""
echo "YOUR ONLY JOB:"
echo "  1. Run: xdg-open social-posts/today.txt"
echo "  2. Copy FACEBOOK post → Facebook"
echo "  3. Copy LINKEDIN post → LinkedIn"
echo "  4. Copy WHATSAPP status → WhatsApp"
echo "  5. Check WhatsApp for client messages"
echo ""
echo "That's it. Everything else is automated."
