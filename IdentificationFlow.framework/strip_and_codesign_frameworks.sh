#!/bin/sh

# ABBYY® Mobile Imaging SDK II © 2018 ABBYY Production LLC.
# ABBYY is either a registered trademark or a trademark of ABBYY Software Ltd.

# Sign a file
code_sign_file() {
	/usr/bin/codesign --force --sign ${EXPANDED_CODE_SIGN_IDENTITY} --preserve-metadata=identifier,entitlements --timestamp=none "$1"
}

# Strip and code sign framework
strip_and_code_sign_framework() {
	FRAMEWORK_PATH=$1

	EXECUTABLE_NAME=$(defaults read "$FRAMEWORK_PATH/Info.plist" CFBundleExecutable)
	EXECUTABLE_PATH="$FRAMEWORK_PATH/$EXECUTABLE_NAME"

	EXTRACTED_ARCHS=()

	for ARCH in $ARCHS; do
		lipo -extract "$ARCH" "$EXECUTABLE_PATH" -o "$EXECUTABLE_PATH-$ARCH"
		rc=$?
		if [[ $rc == 0 ]]; then
			EXTRACTED_ARCHS+=("$EXECUTABLE_PATH-$ARCH")
		fi
	done

	if [[ "$EXTRACTED_ARCHS" ]]; then
		lipo -o "$EXECUTABLE_PATH-merged" -create "${EXTRACTED_ARCHS[@]}"
		rm "${EXTRACTED_ARCHS[@]}"

		rm "$EXECUTABLE_PATH"
		mv "$EXECUTABLE_PATH-merged" "$EXECUTABLE_PATH"
	fi

	if [[ "${CODE_SIGNING_REQUIRED}" == "YES" ]]; then
		code_sign_file "$FRAMEWORK_PATH"
	fi
}

APP_PATH="${TARGET_BUILD_DIR}/${WRAPPER_NAME}"

find "$APP_PATH" -name '*.framework' -type d | while read -r FRAMEWORK_PATH; do
	strip_and_code_sign_framework "$FRAMEWORK_PATH"
done
