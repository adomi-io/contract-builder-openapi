#!/bin/bash
set -e

# Base directory for OpenAPI specifications
SRC_DIR="/local/src"

# Base directory for generated output
OUT_DIR="/local/out"

# This function generates a client from an OpenAPI specification
generate_client() {
    local spec_path=$1
    local language=$2
    local client_name=$3
    
    echo "Generating $language client for $spec_path..."
    
    # Construct the environment variable name for additional properties
    # Convert language to uppercase and replace hyphens with underscores
    local lang_env=$(echo "$language" | tr '[:lower:]' '[:upper:]' | tr '-' '_')
    local env_var_name="GENERATOR_${lang_env}_ADDITIONAL_PROPERTIES"
    
    # Get the value of the environment variable using indirect reference
    local additional_props="${!env_var_name}"
    
    local extra_args=()
    if [ -n "$additional_props" ]; then
        extra_args+=(--additional-properties="$additional_props")
    fi

    # Run the openapi-generator-cli tool
    # The entrypoint script is provided by the base image
    /usr/local/bin/docker-entrypoint.sh generate \
        -i "$spec_path" \
        -g "$language" \
        -o "$OUT_DIR/$client_name/$language" \
        --skip-validate-spec \
        "${extra_args[@]}"
}

# Scan for all api.yml files in the source directory
# The script iterates through found yaml files to trigger generation

# Process generators provided in the environment variable
# This converts comma-separated values into a space-separated list for the loop
GENERATORS=$(echo $GENERATORS | tr ',' ' ')

if [ -z "$GENERATORS" ]; then
    echo "No generators specified. Please set the GENERATORS environment variable."
    exit 0
fi

find "$SRC_DIR" -name "*.yml" -o -name "*.yaml" | while read spec; do
    # Extract the parent directory name to define the service name
    service_name=$(basename "$(dirname "$spec")")
    
    # Loop through the list of generators and build each client
    for lang in $GENERATORS; do
        generate_client "$spec" "$lang" "$service_name"
    done
done

echo "Generation complete. Outputs are in $OUT_DIR"
