FROM fedora:38 

WORKDIR /opt/workdir

# Disable weak dependencies to reduce image size.
RUN echo "install_weak_deps=False" >> /etc/dnf/dnf.conf 
RUN sudo dnf install -y \
    autoconf \
    automake \
    bison \
    cmake \
    dbus-devel \
    gcc \
    gcc-c++ \
    git \
    kernel-headers\
    libstdc++-static \
    libtool \
    libX11-devel \
    libXcursor-devel \
    libXi-devel \
    libXinerama-devel \
    libxkbcommon-devel \
    libXrandr-devel \
    libXxf86vm-devel \
    make \
    mesa-libEGL-devel \
    mesa-libGL-devel \
    ninja-build \
    patchelf \
    subversion \
    tcl \
    wayland-devel \
    wayland-protocols-devel \
    yasm \
    vulkan-devel \
    vulkan-headers \
    glslc \
    libshaderc \
    libshaderc-devel \
    libshaderc-static 

RUN dnf install 'dnf-command(builddep)' -y
RUN sudo dnf builddep blender -y

# To do: Build and install Open Path Guiding Library.
# svn co https://svn.blender.org/svnroot/bf-blender/trunk/lib/linux_x86_64_glibc_228

# RUN useradd workuser

# USER workuser
CMD git config --global --add safe.directory '*' && \
    make update && \
    cmake \
    -B target/release \
    -D CMAKE_BUILD_TYPE=Release \
    -D PYTHON_VERSION=3.11 \
    -G 'Ninja' && \
    cmake --build target/release -j$(nproc) && \
    DESTDIR="/opt/installdir" cmake --build target/release --target=install 