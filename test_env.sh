#!/bin/bash

# Mocking docker-entrypoint.sh to see what's being called
mkdir -p bin
cat << 'EOF' > bin/docker-entrypoint.sh
#!/bin/bash
echo "CALL: openapi-generator-cli $@"
EOF
chmod +x bin/docker-entrypoint.sh

# Export necessary variables
export SRC_DIR="./specs"
export OUT_DIR="./out_test"
export GENERATORS="python,typescript-axios,graphql-schema"
export GENERATOR_PYTHON_ADDITIONAL_PROPERTIES="identifierNamingConvention=snake_case,useSingleRequestParameter=true"
export GENERATOR_GRAPHQL_SCHEMA_ADDITIONAL_PROPERTIES="withInterfaces=true"

# Patch generate.sh to use our mock script
# We can just set PATH to include our bin directory first
export PATH="$(pwd)/bin:$PATH"

# We also need to mock /usr/local/bin/docker-entrypoint.sh in generate.sh
# Let's create a temporary version of generate.sh for testing
cp src/generate.sh generate_test.sh
sed -i 's|/usr/local/bin/docker-entrypoint.sh|docker-entrypoint.sh|g' generate_test.sh
sed -i 's|SRC_DIR="/local/src"|SRC_DIR="./specs"|g' generate_test.sh
sed -i 's|OUT_DIR="/local/out"|OUT_DIR="./out_test"|g' generate_test.sh

# Run it
bash generate_test.sh

# Cleanup
rm generate_test.sh
rm -rf bin
rm -rf out_test
