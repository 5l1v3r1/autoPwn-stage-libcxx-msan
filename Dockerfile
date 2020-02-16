FROM ubuntu:bionic

RUN apt update && apt dist-upgrade -y && apt install -y subversion wget clang-9 build-essential coreutils cmake && \
    ln -s /usr/bin/clang++-9 /usr/bin/clang++ && ln -s /usr/bin/clang-9 /usr/bin/clang && \
    mkdir -p /opt && cd /opt && \
    svn co http://llvm.org/svn/llvm-project/llvm/trunk llvm && \
    (cd llvm/projects && svn co http://llvm.org/svn/llvm-project/libcxx/trunk libcxx) && \
    (cd llvm/projects && svn co http://llvm.org/svn/llvm-project/libcxxabi/trunk libcxxabi) && \
    mkdir libcxx_msan && cd libcxx_msan && \
    cmake ../llvm -DCMAKE_BUILD_TYPE=Release -DLLVM_USE_SANITIZER=Memory -DCMAKE_C_COMPILER=clang -DCMAKE_CXX_COMPILER=clang++ && \
    make cxx -j`nproc`
