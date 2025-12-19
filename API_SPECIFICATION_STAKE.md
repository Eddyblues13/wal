# API Specification: Stake Endpoints

This document describes all stake-related API endpoints. All endpoints use wallet-based authentication. The wallet address is sent in the request body and serves as both user identification and authentication mechanism (no separate authentication token is used).

---

## 1. Get Stake Data Endpoint

### Endpoint Details

**URL:** `stake_data.php`  
**Method:** `POST`  
**Content-Type:** `application/json`

---

### Authentication

**Note:** This API uses wallet-based authentication. The wallet address in the request body serves as both user identification and authentication mechanism.

---

### Request Format

#### Request Body Parameters

```json
{
  "wallet": "string (required)"
}
```

#### Request Example

```json
{
  "wallet": "EQD7Z9B7GcjTRdcP4F1sLjQhA7tFq3RC8dO2HcK2hZMx"
}
```

---

### Response Format

#### Success Response

**Status Code:** 200 (or success status)  
**Response Body:**
```json
{
  "success": true,
  "message": "Stake data fetched successfully",
  "packages": [
    {
      "token": "STARCOIN",
      "chain": "TON Chain",
      "dailyReward": "0.5% - 0.7%",
      "minStake": "$10",
      "duration": "365 Days",
      "logo": "assets/images/starcoin.png"
    }
  ],
  "positions": [
    {
      "token": "STARCOIN",
      "amount": "$150.00",
      "dailyReward": "$0.90",
      "totalEarned": "$45.50",
      "daysRemaining": "320",
      "positionId": "1"
    }
  ],
  "totalStaked": "150.00",
  "totalDailyRewards": "0.90",
  "totalEarned": "45.50",
  "referralRewards": "12.30"
}
```

#### Error Response

**Status Code:** 400/500 (or error status)  
**Response Body:**
```json
{
  "success": false,
  "error": "error_code_or_description",
  "message": "User-friendly error message"
}
```

---

## 2. Get Daily Return Endpoint

### Endpoint Details

**URL:** `daily_return.php`  
**Method:** `POST`  
**Content-Type:** `application/json`

---

### Authentication

**Note:** This API uses wallet-based authentication. The wallet address in the request body serves as both user identification and authentication mechanism.

---

### Request Format

#### Request Body Parameters

```json
{
  "wallet": "string (required)"
}
```

---

### Response Format

#### Success Response

**Status Code:** 200 (or success status)  
**Response Body:**
```json
{
  "success": true,
  "daily_return": "0.50"
}
```

#### Error Response

**Status Code:** 400/500 (or error status)  
**Response Body:**
```json
{
  "success": false,
  "error": "error_code_or_description",
  "message": "User-friendly error message"
}
```

---

## 3. Get Reward Tiers Endpoint

### Endpoint Details

**URL:** `reward_tiers.php`  
**Method:** `POST`  
**Content-Type:** `application/json`

---

### Authentication

**Note:** This API uses wallet-based authentication. The wallet address in the request body serves as both user identification and authentication mechanism.

---

### Request Format

#### Request Body Parameters

```json
{
  "wallet": "string (required)"
}
```

---

### Response Format

#### Success Response

**Status Code:** 200 (or success status)  
**Response Body:**
```json
{
  "success": true,
  "tiers": [
    {
      "min_amount": "10",
      "max_amount": "99",
      "daily_reward": "0.5",
      "apr": "182.5"
    },
    {
      "min_amount": "100",
      "max_amount": "999",
      "daily_reward": "0.6",
      "apr": "219.0"
    },
    {
      "min_amount": "1000",
      "max_amount": "999999",
      "daily_reward": "0.7",
      "apr": "255.5"
    }
  ]
}
```

#### Error Response

**Status Code:** 400/500 (or error status)  
**Response Body:**
```json
{
  "success": false,
  "error": "error_code_or_description",
  "message": "User-friendly error message"
}
```

---

## 4. Stake Tokens Endpoint

### Endpoint Details

**URL:** `stake_tokens.php`  
**Method:** `POST`  
**Content-Type:** `application/json`

---

### Authentication

This endpoint requires user authentication. The user's identity (and thus their wallet address) should be derived from the authentication token provided in the `Authorization` header.

**Header:** `Authorization: Bearer <user_auth_token>`

---

### Request Format

#### Request Body Parameters

```json
{
  "wallet": "string (required)",
  "amount": "100.00",
  "coin_symbol": "STARCOIN"
}
```

#### Request Validation Requirements

- `wallet` (string, required): The wallet address used for authentication and user identification
- `amount` (string, required): The amount of STARCOIN to stake. Must be a valid number string (e.g., "100.00"). Minimum value is 10.
- `coin_symbol` (string, required): The symbol of the coin to stake. Currently only "STARCOIN" is supported.

#### Request Example

```json
{
  "wallet": "EQD7Z9B7GcjTRdcP4F1sLjQhA7tFq3RC8dO2HcK2hZMx",
  "amount": "100.00",
  "coin_symbol": "STARCOIN"
}
```

---

### Response Format

#### Success Response

**Status Code:** 200 (or success status)  
**Response Body:**
```json
{
  "success": true,
  "message": "Staking successful",
  "transaction_hash": "0x1234567890abcdef..."
}
```

#### Error Response

**Status Code:** 400/500 (or error status)  
**Response Body:**
```json
{
  "success": false,
  "error": "INSUFFICIENT_BALANCE",
  "message": "Insufficient STARCOIN balance to stake"
}
```

---

## 5. Claim Rewards Endpoint

### Endpoint Details

**URL:** `claim_rewards.php`  
**Method:** `POST`  
**Content-Type:** `application/json`

---

### Authentication

This endpoint requires user authentication. The user's identity (and thus their wallet address) should be derived from the authentication token provided in the `Authorization` header.

**Header:** `Authorization: Bearer <user_auth_token>`

---

### Request Format

#### Request Body Parameters

```json
{
  "wallet": "string (required)",
  "position_id": "string (optional)"
}
```

#### Request Validation Requirements

- `wallet` (string, required): The wallet address used for authentication and user identification
- `position_id` (string, optional): The ID of a specific staking position to claim rewards from. If not provided or null, all available rewards will be claimed.

#### Request Example

**Claim specific position:**
```json
{
  "wallet": "EQD7Z9B7GcjTRdcP4F1sLjQhA7tFq3RC8dO2HcK2hZMx",
  "position_id": "1"
}
```

**Claim all rewards:**
```json
{
  "wallet": "EQD7Z9B7GcjTRdcP4F1sLjQhA7tFq3RC8dO2HcK2hZMx"
}
```

---

### Response Format

#### Success Response

**Status Code:** 200 (or success status)  
**Response Body:**
```json
{
  "success": true,
  "message": "Rewards claimed successfully",
  "claimed_amount": "45.50",
  "transaction_hash": "0x1234567890abcdef..."
}
```

#### Error Response

**Status Code:** 400/500 (or error status)  
**Response Body:**
```json
{
  "success": false,
  "error": "NO_REWARDS_AVAILABLE",
  "message": "No rewards available to claim"
}
```

---

## Backend Implementation Notes

### Authentication
- All endpoints must validate the `wallet` parameter in the request body.
- Validate that the wallet address exists in the system.
- Verify the wallet address is associated with an active user account.
- If wallet is missing, invalid, or not found, return an error response.

### Data Retrieval
- For `stake_data.php`: Fetch the list of available staking packages (currently only STARCOIN), active staking positions, and summary statistics for the authenticated user.
- For `daily_return.php`: Calculate and return the daily return percentage for the user's staking positions.
- For `reward_tiers.php`: Return the list of reward tiers with their min/max amounts, daily reward percentages, and APR values.

### Staking
- For `stake_tokens.php`: Validate that the user has sufficient STARCOIN balance, create a new staking position, and return a success response with optional transaction hash.
- Minimum stake amount is 10 STARCOIN.

### Claiming
- For `claim_rewards.php`: Calculate total earned rewards for the specified position (or all positions if `position_id` is not provided), transfer the rewards to the user's wallet, and return a success response with the claimed amount and optional transaction hash.

### Default Data
- If there are no specific data for a user or an error occurs, provide default data:
  - **Stake Data**: One STARCOIN package, empty positions list, zero totals.
  - **Daily Return**: "0.50" (default percentage).
  - **Reward Tiers**: Three tiers (10-99: 0.5%, 100-999: 0.6%, 1000+: 0.7%).

### Error Handling
- Return clear error messages for authentication failures, insufficient balance, invalid amounts, internal server errors, or any issues during data retrieval or processing.

---

## Testing Scenarios

### Stake Data Endpoint
1. **Successful Retrieval:**
   - Request: Valid wallet address.
   - Expected: `success: true`, list of packages (STARCOIN only), positions, and totals.
2. **Authentication Failure:**
   - Request: Missing or invalid wallet address.
   - Expected: `success: false`, appropriate error message (e.g., "Invalid wallet").

### Daily Return Endpoint
1. **Successful Retrieval:**
   - Request: Valid wallet address.
   - Expected: `success: true`, daily return percentage.
2. **No Positions:**
   - Request: Valid wallet, but user has no staking positions.
   - Expected: `success: true`, default daily return.

### Reward Tiers Endpoint
1. **Successful Retrieval:**
   - Request: Valid wallet address.
   - Expected: `success: true`, list of reward tiers.

### Stake Tokens Endpoint
1. **Successful Stake:**
   - Request: Valid wallet, amount >= 10, sufficient balance.
   - Expected: `success: true`, success message, optional transaction hash.
2. **Insufficient Balance:**
   - Request: Valid wallet, amount > available balance.
   - Expected: `success: false`, "INSUFFICIENT_BALANCE" error.
3. **Invalid Amount:**
   - Request: Valid wallet, amount < 10.
   - Expected: `success: false`, "INVALID_AMOUNT" error.

### Claim Rewards Endpoint
1. **Successful Claim (Specific Position):**
   - Request: Valid wallet, valid position_id with available rewards.
   - Expected: `success: true`, claimed amount, optional transaction hash.
2. **Successful Claim (All Rewards):**
   - Request: Valid wallet, no position_id, user has available rewards.
   - Expected: `success: true`, total claimed amount, optional transaction hash.
3. **No Rewards Available:**
   - Request: Valid wallet, but no rewards to claim.
   - Expected: `success: false`, "NO_REWARDS_AVAILABLE" error.

---

## Example PHP Implementation (Conceptual)

```php
<?php
header('Content-Type: application/json');

// Get request data
$input = json_decode(file_get_contents('php://input'), true);

// Validate wallet parameter (used for authentication)
if (!isset($input['wallet']) || empty($input['wallet'])) {
    http_response_code(400);
    echo json_encode([
        "success" => false,
        "error" => "MISSING_WALLET",
        "message" => "Wallet address is required"
    ]);
    exit();
}

$userWalletAddress = $input['wallet'];

// Validate wallet exists in system
if (!walletExists($userWalletAddress)) {
    http_response_code(401);
    echo json_encode([
        "success" => false,
        "error" => "INVALID_WALLET",
        "message" => "Wallet address not found in system"
    ]);
    exit();
}

// Get the endpoint from the request
$requestUri = $_SERVER['REQUEST_URI'];
$endpoint = basename(parse_url($requestUri, PHP_URL_PATH));

// Get request body
$input = json_decode(file_get_contents('php://input'), true);

// Route to appropriate handler
switch ($endpoint) {
    case 'stake_data.php':
        handleStakeData($userWalletAddress);
        break;
    case 'daily_return.php':
        handleDailyReturn($userWalletAddress);
        break;
    case 'reward_tiers.php':
        handleRewardTiers($userWalletAddress);
        break;
    case 'stake_tokens.php':
        handleStakeTokens($userWalletAddress, $input);
        break;
    case 'claim_rewards.php':
        handleClaimRewards($userWalletAddress, $input);
        break;
    default:
        http_response_code(404);
        echo json_encode([
            "success" => false,
            "error" => "NOT_FOUND",
            "message" => "Endpoint not found"
        ]);
}

function handleStakeData($wallet) {
    // In a real application, query your database for stake data
    $packages = [
        [
            'token' => 'STARCOIN',
            'chain' => 'TON Chain',
            'dailyReward' => '0.5% - 0.7%',
            'minStake' => '$10',
            'duration' => '365 Days',
            'logo' => 'assets/images/starcoin.png'
        ]
    ];
    
    $positions = [
        [
            'token' => 'STARCOIN',
            'amount' => '$150.00',
            'dailyReward' => '$0.90',
            'totalEarned' => '$45.50',
            'daysRemaining' => '320',
            'positionId' => '1'
        ]
    ];
    
    echo json_encode([
        "success" => true,
        "message" => "Stake data fetched successfully",
        "packages" => $packages,
        "positions" => $positions,
        "totalStaked" => "150.00",
        "totalDailyRewards" => "0.90",
        "totalEarned" => "45.50",
        "referralRewards" => "12.30"
    ]);
}

function handleDailyReturn($wallet) {
    // Calculate daily return based on user's positions
    echo json_encode([
        "success" => true,
        "daily_return" => "0.50"
    ]);
}

function handleRewardTiers($wallet) {
    // Wallet is validated above, can be used for user-specific tiers if needed
    $tiers = [
        [
            "min_amount" => "10",
            "max_amount" => "99",
            "daily_reward" => "0.5",
            "apr" => "182.5"
        ],
        [
            "min_amount" => "100",
            "max_amount" => "999",
            "daily_reward" => "0.6",
            "apr" => "219.0"
        ],
        [
            "min_amount" => "1000",
            "max_amount" => "999999",
            "daily_reward" => "0.7",
            "apr" => "255.5"
        ]
    ];
    
    echo json_encode([
        "success" => true,
        "tiers" => $tiers
    ]);
}

function handleStakeTokens($wallet, $input) {
    // Wallet is already validated above
    $amount = $input['amount'] ?? null;
    $coinSymbol = $input['coin_symbol'] ?? null;
    
    if (!$amount || !$coinSymbol) {
        http_response_code(400);
        echo json_encode([
            "success" => false,
            "error" => "INVALID_REQUEST",
            "message" => "Amount and coin_symbol are required"
        ]);
        return;
    }
    
    $amountValue = floatval($amount);
    if ($amountValue < 10) {
        http_response_code(400);
        echo json_encode([
            "success" => false,
            "error" => "INVALID_AMOUNT",
            "message" => "Minimum stake is 10 STARCOIN"
        ]);
        return;
    }
    
    // In a real app, check balance and create staking position
    // For now, simulate success
    echo json_encode([
        "success" => true,
        "message" => "Staking successful",
        "transaction_hash" => "0x" . bin2hex(random_bytes(16))
    ]);
}

function handleClaimRewards($wallet, $input) {
    $positionId = $input['position_id'] ?? null;
    
    // In a real app, calculate and transfer rewards
    // For now, simulate success
    echo json_encode([
        "success" => true,
        "message" => "Rewards claimed successfully",
        "claimed_amount" => "45.50",
        "transaction_hash" => "0x" . bin2hex(random_bytes(16))
    ]);
}
?>
```

---

## Summary

All stake endpoints:
- Use wallet-based authentication (`wallet` parameter required in request body)
- Support only STARCOIN for staking
- Provide default data if API fails
- Return consistent JSON response format
- Include proper error handling

The frontend will handle all currency in STARCOIN, display reward tiers from the API, calculate daily returns, and allow users to stake and claim rewards through these endpoints.

