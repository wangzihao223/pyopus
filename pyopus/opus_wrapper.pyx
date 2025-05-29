from cpython.pycapsule cimport PyCapsule_New, PyCapsule_GetPointer, PyCapsule_SetDestructor
from libc.stdint cimport uint8_t, int16_t

cdef extern from "stdlib.h":
    void* malloc(size_t size)
    void free(void* ptr)
cdef extern from "opus.h":
    ctypedef int opus_int32
    ctypedef int16_t opus_int16
    ctypedef struct OpusEncoder:
        pass
    ctypedef struct OpusDecoder:
        pass
    #encode
    int opus_encoder_get_size(int channels)
    int opus_encoder_init(OpusEncoder *st, opus_int32 Fs, int channels, int application)
    OpusEncoder* opus_encoder_create(opus_int32 Fs, int channels, int application, int *error)
    opus_int32 opus_encode(OpusEncoder *st, const opus_int16 *pcm, int frame_size, unsigned char *data, opus_int32 max_data_bytes)
    void opus_encoder_destroy(OpusEncoder *st)
    int opus_encoder_ctl(OpusEncoder *st, int request, ...) 

    #decode 
    OpusDecoder* opus_decoder_create(opus_int32 Fs, int channels, int*error)
    int opus_decoder_get_size(int channels)
    int opus_decoder_init(OpusDecoder* st, opus_int32 Fs, int channels)
    int opus_decode(OpusDecoder* st, const unsigned char* data, opus_int32 len,
                            opus_int16* pcm, int frame_size, int decode_fec)
    void opus_decoder_destroy(OpusDecoder *st)

    #define __opus_check_int(x) (((void)((x) == (opus_int32)0)), (opus_int32)(x))
    #define OPUS_SET_BITRATE(x) OPUS_SET_BITRATE_REQUEST, __opus_check_int(x)

cdef struct Encoder:
    void* encoder

cpdef create_encoder(fs, channels, application):
    cdef OpusEncoder* encoder
    cdef int error
    encoder = opus_encoder_create(<opus_int32>fs, <int>channels, <int>application, &error)
    if error == 0: 
        return PyCapsule_New(<void*>encoder, "encoder", NULL)
    else:
        return -1

cpdef encode(encoder_ptr, const opus_int16[:]pcm, frame_size, max_data_bytes):
    cdef OpusEncoder* st
    cdef void* ptr = PyCapsule_GetPointer(encoder_ptr, "encoder")
    st = <OpusEncoder*>ptr
    cdef bytearray buf = bytearray(max_data_bytes)
    cdef uint8_t[:] cyarr = buf
    cdef opus_int32 length
    length = opus_encode(st, &pcm[0], frame_size, &cyarr[0], <opus_int32>max_data_bytes)
    if length > 0:
        return cyarr[:length]
    else:
        return -1

cpdef create_decoder(fs, channels):
    cdef OpusDecoder* st
    cdef int error
    st = opus_decoder_create(fs, channels, &error)
    if error == 0:
        return PyCapsule_New(<void*>st, "decoder", NULL)
    else:
        return -1

cpdef decode(decoder, const unsigned char[:]data, length, frame_size, channels, decode_fec):
    cdef OpusDecoder* st
    cdef void* ptr = PyCapsule_GetPointer(decoder, "decoder")
    st = <OpusDecoder*>ptr
    cdef int error
    cdef int n
    cdef bytearray buf = bytearray(frame_size*channels*2)
    cdef int16_t[:]  pcm = buf
    n = opus_decode(st, &data[0], length, &pcm[0], frame_size, decode_fec)
    if n:
        return pcm[:n]
    return -1

cpdef free_encoder(encoder):
    PyCapsule_SetDestructor(encoder, NULL) 
    cdef void* ptr = PyCapsule_GetPointer(encoder, "encoder")
    if ptr:
        opus_encoder_destroy(<OpusEncoder*> ptr)
        del encoder
        return True
    else:
        return False

cpdef free_decoder(decoder):
    PyCapsule_SetDestructor(decoder, NULL)
    cdef void* ptr = PyCapsule_GetPointer(decoder, "decoder")
    if ptr:
        opus_decoder_destroy(<OpusDecoder*> ptr)
        del decoder
        return True
    else:
        return False

