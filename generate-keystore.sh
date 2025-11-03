#!/bin/bash

# Script to generate Android release keystore
# Run this script to create a release keystore for signing your APK

echo "🔐 Generating Android Release Keystore..."
echo "Please provide the following information for your release keystore:"

read -p "Keystore password: " -s KEYSTORE_PASSWORD
echo
read -p "Key alias (e.g., growthapp-release): " KEY_ALIAS
read -p "Key password: " -s KEY_PASSWORD
echo
read -p "Your first and last name: " DNAME_CN
read -p "Your organizational unit: " DNAME_OU
read -p "Your organization: " DNAME_O
read -p "Your city or locality: " DNAME_L
read -p "Your state or province: " DNAME_ST
read -p "Your country code (e.g., US): " DNAME_C

# Generate the keystore
keytool -genkey -v -keystore android/app/growthapp-release.keystore \
    -alias "$KEY_ALIAS" \
    -keyalg RSA \
    -keysize 2048 \
    -validity 10000 \
    -storepass "$KEYSTORE_PASSWORD" \
    -keypass "$KEY_PASSWORD" \
    -dname "CN=$DNAME_CN, OU=$DNAME_OU, O=$DNAME_O, L=$DNAME_L, ST=$DNAME_ST, C=$DNAME_C"

# Create key.properties file
cat > android/key.properties << EOF
storePassword=$KEYSTORE_PASSWORD
keyPassword=$KEY_PASSWORD
keyAlias=$KEY_ALIAS
storeFile=growthapp-release.keystore
EOF

echo "✅ Keystore generated successfully!"
echo "📁 Location: android/app/growthapp-release.keystore"
echo "🔑 Properties file: android/key.properties"
echo ""
echo "⚠️  IMPORTANT: Keep these files secure and never commit them to version control!"
echo "Add the following to your .gitignore:"
echo "android/app/growthapp-release.keystore"
echo "android/key.properties"