/*
 * Copyright (C) 2010 The Android Open Source Project
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

/** \file CMediaPlayer.c MediaPlayer class */

#ifdef ANDROID
// FIXME JNI should not be part of the API we can avoid it
#include <jni.h>

#include <binder/ProcessState.h>

#include <media/IStreamSource.h>
#include <media/mediaplayer.h>
#include <media/stagefright/foundation/ADebug.h>

#include <binder/IServiceManager.h>
#include <media/IMediaPlayerService.h>
#include <surfaceflinger/ISurfaceComposer.h>
#include <surfaceflinger/SurfaceComposerClient.h>

#include <fcntl.h>
#endif

#include "sles_allinclusive.h"

#ifdef ANDROID
using namespace android;

#endif


XAresult CMediaPlayer_Realize(void *self, XAboolean async)
{
    CMediaPlayer *thiz = (CMediaPlayer *) self;

    XAresult result = XA_RESULT_SUCCESS;

#ifdef ANDROID
    // realize player
    result = android_Player_realize(thiz, async);
    if (XA_RESULT_SUCCESS == result) {

        // if there is a video sink
        if (XA_DATALOCATOR_NATIVEDISPLAY == thiz->mImageVideoSink.mLocator.mLocatorType) {
            XANativeHandle nativeSurface = thiz->mImageVideoSink.mLocator.mNativeDisplay.hWindow;

            if ((thiz->mAVPlayer != 0) && (NULL != nativeSurface)) {
                // initialize display surface
                result = android_Player_setVideoSurface(thiz->mAVPlayer.get(), nativeSurface);
            }
        }
    }
#endif

    return result;
}


XAresult CMediaPlayer_Resume(void *self, XAboolean async)
{
    return XA_RESULT_SUCCESS;
}


/** \brief Hook called by Object::Destroy when a media player is destroyed */

void CMediaPlayer_Destroy(void *self)
{
    CMediaPlayer *this = (CMediaPlayer *) self;
    freeDataLocatorFormat(&this->mDataSource);
    freeDataLocatorFormat(&this->mBankSource);
    freeDataLocatorFormat(&this->mAudioSink);
    freeDataLocatorFormat(&this->mImageVideoSink);
    freeDataLocatorFormat(&this->mVibraSink);
    freeDataLocatorFormat(&this->mLEDArraySink);
#ifdef ANDROID
    android_Player_destroy(this);
#endif
}


predestroy_t CMediaPlayer_PreDestroy(void *self)
{
    return predestroy_ok;
}
