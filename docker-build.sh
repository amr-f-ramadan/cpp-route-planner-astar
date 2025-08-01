#!/bin/bash

# Docker build and run script for C++ Route Planning Project
# This script helps build and manage the Docker container with IO2D compatibility

set -e  # Exit on any error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

print_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

# Check if Docker is installed
check_docker() {
    if ! command -v docker &> /dev/null; then
        print_error "Docker is not installed. Please install Docker first."
        exit 1
    fi

    # Check if Docker is running
    if ! docker info &> /dev/null; then
        print_error "Docker is not running. Please start Docker first."
        exit 1
    fi
}

# Function to build the Docker image
build_image() {
    print_status "Building Docker image with IO2D compatibility..."
    print_info "This may take 10-15 minutes for the first build due to IO2D compilation"
    
    docker build -t cpp-route-planner .
    
    if [ $? -eq 0 ]; then
        print_status "Docker image built successfully!"
    else
        print_error "Docker build failed. Check the output above for errors."
        exit 1
    fi
}

# Function to run the container
run_container() {
    print_status "Running the container..."
    docker run -it --rm \
        --name cpp-route-planner-run \
        -v "$(pwd)":/usr/src/app \
        cpp-route-planner
}

# Function to run container with shell access
run_shell() {
    print_status "Starting container with shell access..."
    docker run -it --rm \
        --name cpp-route-planner-shell \
        -v "$(pwd)":/usr/src/app \
        cpp-route-planner \
        /bin/bash
}

# Function to build project inside container
build_project() {
    print_status "Building C++ project inside container..."
    docker run -it --rm \
        --name cpp-route-planner-build \
        -v "$(pwd)":/usr/src/app \
        cpp-route-planner \
        /bin/bash -c "cd /usr/src/app && mkdir -p build && cd build && cmake .. && make"
}

# Function to run tests
run_tests() {
    print_status "Running tests inside container..."
    docker run -it --rm \
        --name cpp-route-planner-test \
        -v "$(pwd)":/usr/src/app \
        cpp-route-planner \
        /bin/bash -c "cd /usr/src/app/build && ./test"
}

# Function to run the built application
run_app() {
    print_status "Running the route planning application..."
    docker run -it --rm \
        --name cpp-route-planner-app \
        -v "$(pwd)":/usr/src/app \
        cpp-route-planner \
        /bin/bash -c "cd /usr/src/app/build && ./OSM_A_star_search"
}

# Function to clean up
cleanup() {
    print_status "Cleaning up Docker images and containers..."
    
    # Stop and remove any running containers
    docker ps -q --filter "name=cpp-route-planner" | xargs -r docker stop
    docker ps -aq --filter "name=cpp-route-planner" | xargs -r docker rm
    
    # Remove the image
    docker rmi cpp-route-planner 2>/dev/null || true
    
    print_status "Cleanup completed!"
}

# Function to show container info
show_info() {
    print_info "Docker Container Information:"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "Base Image:     Ubuntu 20.04 LTS"
    echo "Compiler:       GCC 9 (compatible with IO2D)"
    echo "Boost Version:  1.71 (compatible with IO2D)"
    echo "C++ Standard:   C++14 (required for IO2D)"
    echo "Graphics:       Cairo, GraphicsMagick, IO2D"
    echo "Build System:   CMake"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo ""
    echo "Key Features:"
    echo "• IO2D library for graphics rendering"
    echo "• All required dependencies pre-installed"
    echo "• Compatible package versions for stable builds"
    echo "• Development tools and debugging support"
    echo ""
}

# Function to show usage
show_usage() {
    echo "Usage: $0 [COMMAND]"
    echo ""
    echo "Commands:"
    echo "  build       Build the Docker image"
    echo "  run         Run the container interactively"
    echo "  shell       Get shell access to the container"
    echo "  project     Build the C++ project inside container"
    echo "  app         Run the built application"
    echo "  test        Run tests inside container"
    echo "  cleanup     Remove Docker image and containers"
    echo "  info        Show container configuration info"
    echo "  help        Show this help message"
    echo ""
    echo "Examples:"
    echo "  $0 build       # Build the Docker image"
    echo "  $0 shell       # Get shell access for development"
    echo "  $0 project     # Build the C++ project"
    echo "  $0 app         # Run the application"
    echo ""
    echo "Development Workflow:"
    echo "  1. $0 build    # Build the container (first time)"
    echo "  2. $0 shell    # Get shell access"
    echo "  3. Inside container: cd build && cmake .. && make"
    echo "  4. Inside container: ./OSM_A_star_search"
}

# Main script logic
main() {
    check_docker
    
    case "${1:-help}" in
        build)
            build_image
            ;;
        run)
            run_container
            ;;
        shell)
            run_shell
            ;;
        project)
            build_project
            ;;
        app)
            run_app
            ;;
        test)
            run_tests
            ;;
        cleanup)
            cleanup
            ;;
        info)
            show_info
            ;;
        help|--help|-h)
            show_usage
            ;;
        *)
            print_error "Unknown command: $1"
            echo ""
            show_usage
            exit 1
            ;;
    esac
}

# Run main function
main "$@"
