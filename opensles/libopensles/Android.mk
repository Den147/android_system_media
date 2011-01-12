LOCAL_PATH:= $(call my-dir)

include $(CLEAR_VARS)

LOCAL_SRC_FILES :=     \
        OpenSLESUT.c   \
        slesutResult.c

LOCAL_C_INCLUDES:= \
        system/media/opensles/include

LOCAL_CFLAGS += -fvisibility=hidden

LOCAL_MODULE := libOpenSLESUT

include $(BUILD_STATIC_LIBRARY)

include $(CLEAR_VARS)

LOCAL_CFLAGS += -Wno-override-init
# -Wno-missing-field-initializers
# optional, see comments in MPH_to.c: -DUSE_DESIGNATED_INITIALIZERS -S
LOCAL_CFLAGS += -DUSE_DESIGNATED_INITIALIZERS

LOCAL_SRC_FILES:=                     \
        MPH_to.c

LOCAL_MODULE:= libopensles_helper

include $(BUILD_STATIC_LIBRARY)

include $(CLEAR_VARS)

#LOCAL_CFLAGS += -DSL_API= -DXA_API=SLAPIENTRY -DXAAPIENTRY=
#LOCAL_CFLAGS += -DUSE_PROFILES=0 -UUSE_TRACE -UUSE_DEBUG -DNDEBUG -DUSE_LOG=SLAndroidLogLevel_Info
LOCAL_CFLAGS += -DUSE_PROFILES=0 -DUSE_TRACE -DUSE_DEBUG -UNDEBUG \
# select the level of log messages
#   -DUSE_LOG=SLAndroidLogLevel_Verbose
   -DUSE_LOG=SLAndroidLogLevel_Info
# trace all the OpenSL ES method enter/exit in the logs
#LOCAL_CFLAGS += -DSL_TRACE_DEFAULT=SL_TRACE_ALL

# Reduce size of .so and hide internal global symbols
LOCAL_CFLAGS += -fvisibility=hidden -DSL_API='__attribute__((visibility("default")))' \
        -DXA_API='__attribute__((visibility("default")))'

LOCAL_SRC_FILES:=                     \
        OpenSLES_IID.c                \
        classes.c                     \
        data.c                        \
        devices.c                     \
        entry.c                       \
        trace.c                       \
        locks.c                       \
        sles.c                        \
        sllog.c                       \
        android_Player.cpp            \
        android_AVPlayer.cpp          \
        android_AudioPlayer.cpp       \
        android_AudioRecorder.cpp     \
        android_LocAVPlayer.cpp       \
        android_OutputMix.cpp         \
        android_StreamPlayer.cpp      \
        android_SfPlayer.cpp          \
        android_Effect.cpp            \
        IID_to_MPH.c                  \
        ThreadPool.c                  \
        C3DGroup.c                    \
        CAudioPlayer.c                \
        CAudioRecorder.c              \
        CEngine.c                     \
        COutputMix.c                  \
        CMediaPlayer.c                \
        IAndroidBufferQueue.c         \
        IAndroidConfiguration.c       \
        IAndroidEffect.cpp            \
        IAndroidEffectCapabilities.c  \
        IAndroidEffectSend.c          \
        IBassBoost.c                  \
        IBufferQueue.c                \
        IDynamicInterfaceManagement.c \
        IEffectSend.c                 \
        IEngine.c                     \
        IEngineCapabilities.c         \
        IEnvironmentalReverb.c        \
        IEqualizer.c                  \
        IMuteSolo.c                   \
        IObject.c                     \
        IOutputMix.c                  \
        IPlay.c                       \
        IPlaybackRate.c               \
        IPrefetchStatus.c             \
        IPresetReverb.c               \
        IRecord.c                     \
        ISeek.c                       \
        IStreamInformation.c          \
        IVirtualizer.c                \
        IVolume.c

EXCLUDE_SRC :=                        \
        sync.c                        \
        I3DCommit.c                   \
        I3DDoppler.c                  \
        I3DGrouping.c                 \
        I3DLocation.c                 \
        I3DMacroscopic.c              \
        I3DSource.c                   \
        IAudioDecoderCapabilities.c   \
        IAudioEncoder.c               \
        IAudioEncoderCapabilities.c   \
        IAudioIODeviceCapabilities.c  \
        IDeviceVolume.c               \
        IDynamicSource.c              \
        ILEDArray.c                   \
        IMIDIMessage.c                \
        IMIDIMuteSolo.c               \
        IMIDITempo.c                  \
        IMIDITime.c                   \
        IMetadataExtraction.c         \
        IMetadataTraversal.c          \
        IPitch.c                      \
        IRatePitch.c                  \
        IThreadSync.c                 \
        IVibra.c                      \
        IVisualization.c

LOCAL_C_INCLUDES:=                                                  \
        $(JNI_H_INCLUDE)                                            \
        system/media/opensles/include                               \
        frameworks/base/media/libstagefright                        \
        frameworks/base/media/libstagefright/include                \
        frameworks/base/include/media/stagefright/openmax

LOCAL_CFLAGS += -x c++ -Wno-multichar -Wno-invalid-offsetof

LOCAL_STATIC_LIBRARIES += \
        libopensles_helper        \
        libOpenSLESUT

LOCAL_SHARED_LIBRARIES :=         \
        libutils                  \
        libmedia                  \
        libbinder                 \
        libstagefright            \
        libstagefright_foundation \
        libcutils

ifeq ($(TARGET_OS)-$(TARGET_SIMULATOR),linux-true)
        LOCAL_LDLIBS += -lpthread -ldl
        LOCAL_SHARED_LIBRARIES += libdvm
        LOCAL_CPPFLAGS += -DANDROID_SIMULATOR
endif

ifneq ($(TARGET_SIMULATOR),true)
        LOCAL_SHARED_LIBRARIES += libdl
else
        LOCAL_CFLAGS += -DTARGET_SIMULATOR
endif

ifeq ($(TARGET_OS)-$(TARGET_SIMULATOR),linux-true)
        LOCAL_LDLIBS += -lpthread
endif

LOCAL_PRELINK_MODULE:= false

LOCAL_MODULE:= libOpenSLES

ifeq ($(TARGET_BUILD_VARIANT),userdebug)
        LOCAL_CFLAGS += -DUSERDEBUG_BUILD=1
endif

include $(BUILD_SHARED_LIBRARY)

include $(call all-makefiles-under,$(LOCAL_PATH))
