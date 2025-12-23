FROM node:18-alpine

# Set working directory
WORKDIR /app

# Copy package files if they exist, otherwise just copy the converter
COPY package*.json ./
RUN if [ -f package.json ]; then npm install; fi

# Copy the converter script
COPY converter.js .

# Make the script executable
RUN chmod +x converter.js

# Create directories for input and output
RUN mkdir -p /input /output

# Set the entrypoint
ENTRYPOINT ["node", "converter.js"]
