#!/bin/bash

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m' # No Color

BASE_URL="http://localhost:3000"

echo -e "${BLUE}=== To-Do List API Test Script ===${NC}"

# Test 1: User Registration
echo -e "\n${GREEN}1. Testing User Registration...${NC}"
REGISTER_RESPONSE=$(curl -s -X POST $BASE_URL/signup \
  -H "Content-Type: application/json" \
  -d '{"name":"API Test User","email":"apitest@example.com","password":"password123","password_confirmation":"password123"}')

echo "Response: $REGISTER_RESPONSE"

# Extract token from registration response
TOKEN=$(echo $REGISTER_RESPONSE | grep -o '"auth_token":"[^"]*' | cut -d'"' -f4)

if [ -z "$TOKEN" ]; then
  echo -e "${RED}Registration failed - no token received${NC}"
  # Try with existing user for login test
  echo -e "\n${GREEN}Trying login with existing user...${NC}"
  LOGIN_RESPONSE=$(curl -s -X POST $BASE_URL/auth/login \
    -H "Content-Type: application/json" \
    -d '{"email":"john@example.com","password":"password123"}')
  echo "Login Response: $LOGIN_RESPONSE"
  TOKEN=$(echo $LOGIN_RESPONSE | grep -o '"auth_token":"[^"]*' | cut -d'"' -f4)
fi

if [ -z "$TOKEN" ]; then
  echo -e "${RED}No token available for further tests${NC}"
  exit 1
fi

echo -e "${GREEN}Token received: $TOKEN${NC}"

# Test 2: Create Todo
echo -e "\n${GREEN}2. Testing Create Todo...${NC}"
CREATE_RESPONSE=$(curl -s -X POST $BASE_URL/todos \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $TOKEN" \
  -d '{"title":"API Test Todo","description":"Testing todo creation via API","priority":1}')

echo "Response: $CREATE_RESPONSE"

# Test 3: Get All Todos
echo -e "\n${GREEN}3. Testing Get All Todos...${NC}"
GET_TODOS_RESPONSE=$(curl -s -X GET $BASE_URL/todos \
  -H "Authorization: Bearer $TOKEN")

echo "Response: $GET_TODOS_RESPONSE"

# Test 4: Get Todos with filters
echo -e "\n${GREEN}4. Testing Get Pending Todos...${NC}"
PENDING_TODOS_RESPONSE=$(curl -s -X GET "$BASE_URL/todos?status=pending" \
  -H "Authorization: Bearer $TOKEN")

echo "Response: $PENDING_TODOS_RESPONSE"

# Test 5: Authentication without token
echo -e "\n${GREEN}5. Testing Unauthorized Access (should fail)...${NC}"
UNAUTHORIZED_RESPONSE=$(curl -s -X GET $BASE_URL/todos)
echo "Response: $UNAUTHORIZED_RESPONSE"

# Test 6: Invalid token
echo -e "\n${GREEN}6. Testing Invalid Token (should fail)...${NC}"
INVALID_TOKEN_RESPONSE=$(curl -s -X GET $BASE_URL/todos \
  -H "Authorization: Bearer invalid_token")
echo "Response: $INVALID_TOKEN_RESPONSE"

echo -e "\n${BLUE}=== API Testing Complete ===${NC}"
