#!/bin/bash
set +e
export CFA_RELEASE=$(wget -qO- -t1 -T2 "https://api.github.com/repos/Kr328/ClashForAndroid/releases/latest" | grep "tag_name" | head -n 1 | awk -F ":" '{print $2}' | sed 's/\"//g;s/,//g;s/ //g')
export LAST_BUILD=$(cat last_build)
echo "LAST_BUILD_VERSION: ${LAST_BUILD}"
echo "LATEST_VERSION: ${CFA_RELEASE}"
if [ $CFA_RELEASE == $LAST_BUILD ];
then
    echo "no new release"
    exit 125
fi
git clone https://github.com/Kr328/ClashForAndroid.git --recurse-submodules -b $CFA_RELEASE cfa
. modify.sh
cd cfa
echo $ANDROID_KEYSTORE_DATA | base64 -d | tee key.jks
echo "keystore.path=key.jks" >> signing.properties
echo "keystore.password=${ANDROID_KEYSTORE_PASSWORD}" >> signing.properties
echo "key.alias=${ANDROID_KEY_ALIAS}" >> signing.properties
echo "key.password=${ANDROID_KEY_PASSWORD}" >> signing.properties
./gradlew app:assembleKaminoRelease
cd ..
echo $CFA_RELEASE | tee last_build
cp -f README.template.md README.md
sed -i "s/BUILD_VERSION/${CFA_RELEASE/v/}/g" README.md
git config --global user.email "kamino@imea.me"
git config --global user.name "kamino"
git add .
git commit -m "build ${CFA_RELEASE}" || true
git push origin main