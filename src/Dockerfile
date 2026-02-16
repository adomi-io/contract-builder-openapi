# Use the official OpenAPI Generator CLI image as the base
FROM openapitools/openapi-generator-cli:v7.2.0

# Set the working directory for the application
WORKDIR /local

# Copy the source directory into the container image
COPY ./src/generate.sh /local/generate.sh

# Create the directory for the generated output
RUN mkdir -p /local/out

# The default entrypoint in the base image is "docker-entrypoint.sh"
# This script executes multiple generations for the identified specifications
RUN chmod +x /local/generate.sh

# Run the generation script as the container entrypoint
ENTRYPOINT ["/local/generate.sh"]
