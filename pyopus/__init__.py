import os
import sys

if sys.platform == "win32":
    dll_dir = os.path.abspath(os.path.join(os.path.dirname(__file__), "libs"))
    if os.path.isdir(dll_dir):
        os.add_dll_directory(dll_dir)

from .opus_wrapper import create_encoder, encode, create_decoder, decode, free_encoder, free_decoder
