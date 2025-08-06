#!/bin/bash

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${BLUE}=== To-Do List API Setup Script ===${NC}"

# Check if Ruby is installed
echo -e "\n${GREEN}Checking Ruby installation...${NC}"
if command -v ruby &> /dev/null; then
    RUBY_VERSION=$(ruby -v)
    echo -e "${GREEN}✓ Ruby is installed: $RUBY_VERSION${NC}"
else
    echo -e "${RED}✗ Ruby is not installed${NC}"
    exit 1
fi

# Check if Bundler is installed
echo -e "\n${GREEN}Checking Bundler installation...${NC}"
if command -v bundle &> /dev/null; then
    BUNDLER_VERSION=$(bundle -v)
    echo -e "${GREEN}✓ Bundler is installed: $BUNDLER_VERSION${NC}"
else
    echo -e "${YELLOW}Installing Bundler...${NC}"
    gem install bundler
fi

# Check if PostgreSQL is running
echo -e "\n${GREEN}Checking PostgreSQL...${NC}"
if command -v pg_isready &> /dev/null; then
    if pg_isready -q; then
        echo -e "${GREEN}✓ PostgreSQL is running${NC}"
    else
        echo -e "${YELLOW}⚠ PostgreSQL is installed but not running${NC}"
        echo -e "${YELLOW}Please start PostgreSQL service and run this script again${NC}"
    fi
else
    echo -e "${RED}✗ PostgreSQL is not installed${NC}"
    echo -e "${YELLOW}Please install PostgreSQL and run this script again${NC}"
    exit 1
fi

# Install dependencies
echo -e "\n${GREEN}Installing gems...${NC}"
bundle install

# Database setup
echo -e "\n${GREEN}Setting up database...${NC}"
if rails db:version &> /dev/null; then
    echo -e "${YELLOW}Database already exists, running migrations...${NC}"
    rails db:migrate
else
    echo -e "${GREEN}Creating and setting up database...${NC}"
    rails db:create
    rails db:migrate
    rails db:seed
fi

# Check if server can start
echo -e "\n${GREEN}Testing server startup...${NC}"
timeout 5s rails server --daemon --port=3001 &> /dev/null
if [ $? -eq 0 ]; then
    echo -e "${GREEN}✓ Server can start successfully${NC}"
    # Kill the test server
    pkill -f "rails server.*port=3001" &> /dev/null
else
    echo -e "${RED}✗ Server failed to start${NC}"
    exit 1
fi

echo -e "\n${BLUE}=== Setup Complete! ===${NC}"
echo -e "${GREEN}You can now start the server with:${NC}"
echo -e "${YELLOW}  rails server${NC}"
echo -e "\n${GREEN}API will be available at:${NC}"
echo -e "${YELLOW}  http://localhost:3000${NC}"
echo -e "\n${GREEN}API documentation available at:${NC}"
echo -e "${YELLOW}  http://localhost:3000/docs${NC}"
echo -e "\n${GREEN}Test the API with:${NC}"
echo -e "${YELLOW}  ./test_api.sh${NC}"
echo -e "\n${GREEN}Happy coding! 🚀${NC}"
