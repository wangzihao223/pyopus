# pyopus

`pyopus` 是一个基于 Cython 封装的 Opus 编解码库，方便在 Python 中使用 Opus 编码器和解码器。

## 特性

1. 基于官方 [Opus](https://opus-codec.org/) 库封装 。
   目前版本只封装了简单的几个方法:
   
   编码
   
   1. `opus_encoder_create` 创建编码器
   
   2. `opus_encode` 编码
   
   3. `opus_encoder_destroy` 销毁编码器
   
   解码
   
   1. `opus_decoder_create` 创建解码器
   
   2. `opus_decode` 解码
   
   3. `opus_decoder_destroy`  销毁解码器

2. 支持Linux, windows

## 安装

### 依赖

1. cython

2. setuptools

3. opus 
   
    编译opus 
   
   1. linux
      
      ```bash
      # cd 到 opus项目
      ./configure
      ```
      
      ```bash
      make
      ```
   
   2. windows
      
      ```bash
      
      ```
    将编译好的动态库安装到系统，或者放到 pyopus/libs目录下

生成whl

```bash
python -m build
```

安装

```bash
python -m pip install .
```
测试一下是否安装成功
```bash
python -c "import pyopus; res = pyopus.create_encoder(48000, 1, 2048); print(res)"
```
输出类似
```bash
<capsule object "encoder" at 0x7f83f111eac0>
```
