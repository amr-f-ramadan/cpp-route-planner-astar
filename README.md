# Route Planning Project

A C++ implementation of the A* search algorithm for route planning on OpenStreetMap data, developed as part of the Udacity C++ Nanodegree program.

**This Project was first submitted on August 5, 2021. Later on, it went through some enhancements that are listed below.**

<img src="map.png" width="600" height="450" />

## Project Overview

This project demonstrates my implementation of the A* pathfinding algorithm to find optimal routes on real-world map data. As part of the Udacity C++ Nanodegree, I built upon the provided starter framework to create a fully functional route planning application that can visualize paths between any two points on an OpenStreetMap.

### My Contributions
- Implemented the core A* search algorithm with proper heuristic functions
- Developed efficient data structures for managing open and closed node sets
- Created path reconstruction logic to trace back the optimal route
- Added comprehensive error handling and input validation
- **Enhanced the project with Docker containerization for cross-platform compatibility**

## Running with Docker (Recommended)

I've added Docker support to make this project easily runnable on any machine without dependency management hassles.

### Prerequisites
- Docker installed on your system

### Quick Start
```bash
# Build the Docker image
docker build -t route-planning .

# Run the application
docker run -it --rm -e DISPLAY=$DISPLAY -v /tmp/.X11-unix:/tmp/.X11-unix route-planning
```

## Running Locally

### Dependencies
* cmake >= 3.11.3
* make >= 4.1 (Linux, Mac), 3.81 (Windows)
* gcc/g++ >= 7.4.0
* IO2D graphics library

### Installation
1. Clone this repository (my complete solution):
```bash
git clone <your-repo-url> --recurse-submodules
```
*Note: The original unsolved Udacity starter project can be found at: https://github.com/udacity/CppND-Route-Planning-Project.git*

2. Install IO2D following the [official instructions](https://github.com/cpp-io2d/P0267_RefImpl/blob/master/BUILDING.md)

### Compiling and Running

```bash
# Create build directory
mkdir build && cd build

# Configure and build
cmake ..
make

# Run the application
./OSM_A_star_search

# Or with a custom map file
./OSM_A_star_search -f ../<your_osm_file.osm>
```

## Testing

Run the unit tests to verify the implementation:
```bash
cd build
./test
```

## Algorithm Details

The A* implementation uses:
- **Heuristic Function**: Euclidean distance for optimal pathfinding
- **Data Structures**: Priority queue for efficient node selection
- **Memory Management**: Smart pointers for safe resource handling
- **Performance Optimization**: Early termination and efficient neighbor exploration

This project showcases modern C++ practices including RAII, smart pointers, STL containers, and object-oriented design principles learned throughout the Udacity C++ Nanodegree

