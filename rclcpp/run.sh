#!/bin/bash
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
WORKSPACE_DIR="$(dirname "$SCRIPT_DIR")"

# Discover all packages under rclcpp/
mapfile -t PACKAGES < <(find "$SCRIPT_DIR" -name "package.xml" -exec grep -h "<name>" {} \; \
    | sed 's/.*<name>\(.*\)<\/name>/\1/' | sort)

if [[ ${#PACKAGES[@]} -eq 0 ]]; then
    echo "No packages found."
    exit 1
fi

# Step 1: Select package
echo "Available packages:"
for i in "${!PACKAGES[@]}"; do
    echo "  $((i + 1)). ${PACKAGES[$i]}"
done
echo ""
read -rp "Select package number [1-${#PACKAGES[@]}]: " PKG_NUM

if ! [[ "$PKG_NUM" =~ ^[0-9]+$ ]] || (( PKG_NUM < 1 || PKG_NUM > ${#PACKAGES[@]} )); then
    echo "Invalid selection."
    exit 1
fi
PKG_NAME="${PACKAGES[$((PKG_NUM - 1))]}"
echo ""
echo "Selected: $PKG_NAME"

# Step 2: Clean and build
echo ""
echo "==> Cleaning and building $PKG_NAME ..."
cd "$WORKSPACE_DIR"
colcon build --packages-select "$PKG_NAME" --cmake-clean-first
source install/setup.bash
echo "==> Build complete."

# Step 3: Discover executables for the package
EXEC_DIR="$WORKSPACE_DIR/install/$PKG_NAME/lib/$PKG_NAME"
if [[ ! -d "$EXEC_DIR" ]]; then
    echo "No executables found for $PKG_NAME."
    exit 1
fi

mapfile -t EXECUTABLES < <(find "$EXEC_DIR" -maxdepth 1 -type f -executable -printf "%f\n" | sort)

if [[ ${#EXECUTABLES[@]} -eq 0 ]]; then
    echo "No executables found for $PKG_NAME."
    exit 1
elif [[ ${#EXECUTABLES[@]} -eq 1 ]]; then
    EXEC_NAME="${EXECUTABLES[0]}"
else
    echo ""
    echo "Available executables:"
    for i in "${!EXECUTABLES[@]}"; do
        echo "  $((i + 1)). ${EXECUTABLES[$i]}"
    done
    echo ""
    read -rp "Select executable number [1-${#EXECUTABLES[@]}]: " EXEC_NUM

    if ! [[ "$EXEC_NUM" =~ ^[0-9]+$ ]] || (( EXEC_NUM < 1 || EXEC_NUM > ${#EXECUTABLES[@]} )); then
        echo "Invalid selection."
        exit 1
    fi
    EXEC_NAME="${EXECUTABLES[$((EXEC_NUM - 1))]}"
fi

# Step 4: Run
echo ""
echo "==> Running: ros2 run $PKG_NAME $EXEC_NAME"
echo "-------------------------------------------"
ros2 run "$PKG_NAME" "$EXEC_NAME"
