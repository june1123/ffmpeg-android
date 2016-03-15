export ANDROID_NDK=/Users/June/Desktop/dev/android-sdk-macosx/ndk-bundle
./android_build.sh || exit 1

SNAPJOB_ANDROID_PROJECT_ROOT=/Users/June/Desktop/dev/dalcome/RecruitAware/RecruitAware/react-native/recruit/android
FFMPEG_ANDROID_JAVA_PROJECT_PATH=/Users/June/Desktop/dev/AndroidStudioProjects/ffmpeg-android-java

echo '===========Copy ffmpeg to library diretory'
cp ./build/armeabi-v7a/bin/ffmpeg \
  $FFMPEG_ANDROID_JAVA_PROJECT_PATH/FFmpegAndroid/assets/armeabi-v7a/

cp ./build/armeabi-v7a-neon/bin/ffmpeg \
  $FFMPEG_ANDROID_JAVA_PROJECT_PATH/FFmpegAndroid/assets/armeabi-v7a-neon/

cp ./build/x86/bin/ffmpeg \
  $FFMPEG_ANDROID_JAVA_PROJECT_PATH/FFmpegAndroid/assets/x86/

echo '===========Build android library'
cd /Users/June/Desktop/dev/AndroidStudioProjects/ffmpeg-android-java
./gradlew assembleRelease || exit 1

# Move to copy result to snap job
echo '===========Copy aar to snap-job==========='

cd $FFMPEG_ANDROID_JAVA_PROJECT_PATH
cp ./FFmpegAndroid/build/outputs/aar/FFmpegAndroid-release.aar \
  $SNAPJOB_ANDROID_PROJECT_ROOT/app/libs/FFmpegAndroid-min.aar
  
echo "===========Let's start clean build"
# Lets start build
cd $SNAPJOB_ANDROID_PROJECT_ROOT
./gradlew clean
./gradlew assembleDebug




