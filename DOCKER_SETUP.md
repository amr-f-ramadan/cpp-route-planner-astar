# Docker Setup for C++ Route Planning Project

This Docker configuration provides a complete development environment for the C++ Route Planning project with full IO2D graphics library support and all necessary dependencies.

## 🚀 Quick Start

### 1. Build the Container
```bash
./docker-build.sh build
```
*Note: First build takes 10-15 minutes due to IO2D compilation*

### 2. Development Workflow
```bash
# Get shell access to the container
./docker-build.sh shell

# Inside the container, build the project
cd build
cmake ..
make

# Run the application
./OSM_A_star_search
```

## 📋 What's Included

### Base System
- **Ubuntu 20.04 LTS** - Stable base with good package compatibility
- **GCC 9** - Compiler version compatible with IO2D
- **CMake** - Modern build system
- **Git** - Version control

### Graphics Libraries (IO2D Compatible)
- **IO2D Library** - 2D graphics library (built from source)
- **Cairo** - 2D graphics library
- **GraphicsMagick** - Image processing
- **PNG, JPEG, GIF, TIFF** - Image format support
- **FreeType & FontConfig** - Font rendering
- **X11 Libraries** - Display support

### Development Libraries
- **Boost 1.71** - Compatible version for IO2D
- **Eigen3** - Linear algebra library
- **XML libraries** - For OSM file parsing
- **PugiXML** - Lightweight XML parser (from project)
- **GoogleTest** - Testing framework (from project)

### Build Configuration
- **C++14 Standard** - Required for IO2D compatibility
- **Optimized build flags** - For stable compilation
- **Debug support** - GDB included

## 🛠️ Available Commands

```bash
# Container Management
./docker-build.sh build       # Build the Docker image
./docker-build.sh shell       # Get shell access
./docker-build.sh cleanup     # Remove containers and images

# Project Building
./docker-build.sh project     # Build C++ project in container
./docker-build.sh app         # Run the built application
./docker-build.sh test        # Run tests

# Information
./docker-build.sh info        # Show container details
./docker-build.sh help        # Show all commands
```

## 🔧 Manual Development

### Using Docker Compose (Alternative)
```bash
# Build and run
docker-compose up --build

# Shell access
docker-compose run route-planner /bin/bash
```

### Direct Docker Commands
```bash
# Build image
docker build -t cpp-route-planner .

# Run with shell
docker run -it --rm -v "$(pwd)":/usr/src/app cpp-route-planner /bin/bash

# Build project inside container
docker run -it --rm -v "$(pwd)":/usr/src/app cpp-route-planner \
  bash -c "cd /usr/src/app && mkdir -p build && cd build && cmake .. && make"
```

## 🐛 Troubleshooting

### VS Code Dev Container
If using VS Code Dev Containers:
1. Make sure Docker is running
2. Open the project folder in VS Code
3. Command Palette (Cmd+Shift+P) → "Dev Containers: Reopen in Container"
4. Wait for container to build (first time takes 10-15 minutes)

### Build Issues
- **IO2D compilation errors**: The Dockerfile uses compatible versions (Ubuntu 20.04, GCC 9, Boost 1.71)
- **CMake errors**: Ensure all dependencies are built by rebuilding the container
- **Memory issues**: Increase Docker memory allocation to 4GB+

### Runtime Issues
```bash
# Check if image exists
docker images | grep cpp-route-planner

# Check container logs
docker logs [container-name]

# Get shell access for debugging
./docker-build.sh shell
```

## 📁 Project Structure in Container

```
/usr/src/app/               # Project root (mounted from host)
├── build/                  # Build directory
├── src/                    # Source files
├── thirdparty/            # Third-party libraries
├── CMakeLists.txt         # Build configuration
└── map.osm                # Sample map data
```

## 🔄 Development Cycle

1. **Initial Setup**:
   ```bash
   ./docker-build.sh build    # Build container (once)
   ```

2. **Daily Development**:
   ```bash
   ./docker-build.sh shell    # Get container shell
   # Make code changes on host
   # Build inside container: cd build && make
   ```

3. **Testing**:
   ```bash
   ./docker-build.sh test     # Run tests
   ./docker-build.sh app      # Run application
   ```

## ⚙️ Configuration Details

### Compiler Settings
- **Standard**: C++14 (required for IO2D)
- **Compiler**: GCC 9.4
- **Optimization**: Release build with debug info
- **Warnings**: Standard warning levels

### Graphics Configuration
- **Backend**: Cairo-based rendering
- **Format Support**: PNG, JPEG, SVG
- **Display**: X11 forwarding supported
- **Memory**: Optimized for large map rendering

### Volume Mounting
- **Source code**: Live mounted from host
- **Build artifacts**: Persistent in container
- **Configuration**: Shared between host and container

## 🚀 Performance Tips

- **First build**: Takes 10-15 minutes (IO2D compilation)
- **Subsequent builds**: Use Docker layer caching (~2-3 minutes)
- **Development**: Use mounted volumes for instant file changes
- **Memory**: Allocate 4GB+ to Docker for optimal performance

## 📝 Notes

- The container runs as root for simplicity (can be changed)
- All dependencies are pre-installed and compatible
- The setup prioritizes stability over latest versions
- IO2D is built with samples and tests disabled for faster compilation
