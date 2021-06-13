FROM conanio/clang39 as basebuild
WORKDIR /app
COPY . .
WORKDIR /app/build
ENV CC=clang-3.9
ENV CXX=clang++-3.9

FROM basebuild as postbuild
RUN sudo ln -s /usr/bin/clang++-3.9 /usr/local/bin/clang++
RUN conan install .. -s compiler=clang -s compiler.version=3.9 -s compiler.libcxx=libstdc++ --build
RUN cmake .. -DCMAKE_BUILD_TYPE=Release

FROM postbuild
WORKDIR /app
COPY . .
RUN cmake --build .
CMD bin/main

FROM alpine
COPY --from=postbuild /app/bin /app/bin
CMD "./app/bin/main"