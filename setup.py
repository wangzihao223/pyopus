from setuptools import setup, Extension
from Cython.Build import cythonize

ext_modules = [
    Extension(
        "pyopus.opus_wrapper",
        sources=["pyopus/opus_wrapper.pyx",],
        libraries=["opus"],
        include_dirs=["./include/"],
        library_dirs=["./libs"],    
        language="c",
    )
]


setup(
    name="pyopus",
    version="0.1",
    packages=["pyopus"],
    ext_modules=cythonize(ext_modules),
    package_data={"pyopus":["libs/*dll"]},
    include_package_data=True,
    zip_safe=False,
)