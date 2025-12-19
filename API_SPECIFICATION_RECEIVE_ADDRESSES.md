# API Specification: Receive Addresses Endpoint

## Endpoint Details

**URL:** `receive_addresses.php`  
**Method:** `POST`  
**Content-Type:** `application/json`

---

## Request Format

**Important:** The wallet address is REQUIRED in the request body. The backend uses the wallet address to identify and authenticate the user (no separate authentication token is used).

### Request Body Parameters

```json
{
  "wallet": "string (required)"
}
```

### Request Example

```json
{
  "wallet": "EQD7Z9B7GcjTRdcP4F1sLjQhA7tFq3RC8dO2HcK2hZMx"
}
```

### Authentication

**Note:** This API uses wallet-based authentication. The wallet address in the request body serves as both:
1. User identification (to identify which user is requesting addresses)
2. Authentication mechanism (to verify the user is authorized)

The backend should:
1. Extract the `wallet` address from the request body
2. Validate that the wallet address exists in the system
3. Verify the wallet address is associated with an active user account
4. Generate or retrieve receive addresses for all supported coins on TON network

---

## Response Format

### Success Response

**Status Code:** 200 (or success status)  
**Response Body:**

```json
{
  "success": true,
  "assets": [
    {
      "symbol": "TON",
      "name": "Toncoin",
      "network": "TON",
      "address": "EQD7Z9B7GcjTRdcP4F1sLjQhA7tFq3RC8dO2HcK2hZMx",
      "logo": "assets/images/ton.png"
    },
    {
      "symbol": "USDT",
      "name": "Tether USD",
      "network": "TON",
      "address": "EQD7Z9B7GcjTRdcP4F1sLjQhA7tFq3RC8dO2HcK2hZMx",
      "logo": "assets/images/usdt.png"
    },
    {
      "symbol": "STARCOIN",
      "name": "STAR",
      "network": "TON",
      "address": "EQD7Z9B7GcjTRdcP4F1sLjQhA7tFq3RC8dO2HcK2hZMx",
      "logo": "assets/images/starcoin.png"
    }
  ]
}
```

### Error Responses

#### Invalid Token

```json
{
  "success": false,
  "error": "Invalid token",
  "message": "Authentication token is missing, invalid, or expired"
}
```

#### User Not Found

```json
{
  "success": false,
  "error": "User not found",
  "message": "No account found for the authenticated user"
}
```

#### Server Error

```json
{
  "success": false,
  "error": "Server error",
  "message": "An error occurred while retrieving receive addresses. Please try again."
}
```

---

## Response Field Descriptions

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `success` | boolean | Yes | `true` if addresses were retrieved successfully, `false` otherwise |
| `assets` | array | Yes | Array of asset objects with receive addresses (only present when `success` is `true`) |
| `error` | string | No | Error code or description (only present when `success` is `false`) |
| `message` | string | No | Human-readable error message (only present when `success` is `false`) |

### Asset Object Fields

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `symbol` | string | Yes | Coin symbol (e.g., "TON", "USDT", "STARCOIN") |
| `name` | string | Yes | Full name of the coin (e.g., "Toncoin", "Tether USD", "STAR") |
| `network` | string | Yes | Network name (currently always "TON" for TON network) |
| `address` | string | Yes | Receive address for the coin on TON network |
| `logo` | string | No | Path to coin logo image (optional) |

---

## Expected Behavior

1. **Authentication:**
   - Extract the `wallet` address from the request body
   - Validate that the wallet address exists in the system
   - Verify the wallet address is associated with an active user account
   - Use the wallet address to identify the user

2. **Address Generation/Retrieval:**
   - Generate or retrieve receive addresses for all supported coins on TON network
   - Supported coins: TON, USDT, STARCOIN
   - All addresses must be valid TON network addresses
   - Addresses should be unique for each coin for the user

3. **Response:**
   - Return success response with array of assets containing receive addresses
   - Return appropriate error response if authentication fails
   - Always include a `success` boolean field
   - Always include an `assets` array field for successful responses

---

## Error Handling

The API should handle the following error scenarios:

1. **Missing Wallet:** Return error if `wallet` parameter is missing from request body
2. **Invalid Wallet:** Return error if wallet address is invalid format or not found in system
3. **User Not Found:** Return error if wallet address is not associated with an active user account
4. **Address Generation Failure:** Return error if addresses cannot be generated
5. **Database Errors:** Return error if database operation fails
6. **Server Errors:** Return error for any unexpected server-side issues

---

## Security Requirements

1. **Token Validation:** Always validate authentication token before processing
2. **Address Security:** Ensure addresses are generated securely and are unique per user
3. **Rate Limiting:** Implement rate limiting to prevent abuse
4. **Logging:** Log address retrieval attempts (without logging actual addresses)

---

## Testing Scenarios

### Test Case 1: Successful Address Retrieval
- **Request:** Valid wallet address
- **Expected:** `{"success": true, "assets": [...]}` with 3 assets (TON, USDT, STARCOIN)

### Test Case 2: Invalid Wallet
- **Request:** Missing or invalid wallet address
- **Expected:** `{"success": false, "error": "Invalid wallet", "message": "..."}`

### Test Case 3: User Not Found
- **Request:** Valid wallet format but wallet not found in system
- **Expected:** `{"success": false, "error": "User not found", "message": "..."}`

### Test Case 4: Server Error
- **Request:** Valid token but server error occurs
- **Expected:** `{"success": false, "error": "Server error", "message": "..."}`

---

## Notes for Backend Developer

1. **Response Consistency:** Always return JSON with `success` boolean field
2. **Assets Array:** Always include `assets` array in successful responses
3. **Network:** All addresses must be on TON network
4. **Supported Coins:** Only return addresses for TON, USDT, and STARCOIN
5. **Address Format:** Ensure addresses are valid TON network addresses
6. **Default Fallback:** The frontend will use default addresses if API fails, so ensure proper error handling

---

## Supported Coins on TON Network

The following coins are supported for receiving on TON network:
- **TON** (Toncoin)
- **USDT** (Tether USD)
- **STARCOIN** (STAR)

All coins must be on the TON network. The `network` field should always be "TON" for these addresses.

---

## Example PHP Implementation Structure

```php
<?php
header('Content-Type: application/json');

// Get request data
$data = json_decode(file_get_contents('php://input'), true);

// Validate wallet parameter
if (!isset($data['wallet']) || empty($data['wallet'])) {
    echo json_encode([
        'success' => false,
        'error' => 'Missing parameters',
        'message' => 'Wallet address is required'
    ]);
    exit;
}

// Extract wallet address from request body (used for authentication)
$walletAddress = $data['wallet'];

// Validate wallet address exists in system
if (!walletExists($walletAddress)) {
    echo json_encode([
        'success' => false,
        'error' => 'Invalid wallet',
        'message' => 'Wallet address not found in system'
    ]);
    exit;
}

// Generate or retrieve receive addresses for TON network coins
$assets = [
    [
        'symbol' => 'TON',
        'name' => 'Toncoin',
        'network' => 'TON',
        'address' => generateOrRetrieveAddress($userId, 'TON', 'TON'),
        'logo' => 'assets/images/ton.png'
    ],
    [
        'symbol' => 'USDT',
        'name' => 'Tether USD',
        'network' => 'TON',
        'address' => generateOrRetrieveAddress($userId, 'USDT', 'TON'),
        'logo' => 'assets/images/usdt.png'
    ],
    [
        'symbol' => 'STARCOIN',
        'name' => 'STAR',
        'network' => 'TON',
        'address' => generateOrRetrieveAddress($userId, 'STARCOIN', 'TON'),
        'logo' => 'assets/images/starcoin.png'
    ]
];

// Return success response
echo json_encode([
    'success' => true,
    'assets' => $assets
]);
?>
```

---

## Frontend Integration

The frontend expects:
- Response can be either JSON object or JSON string (will be parsed automatically)
- Response must include `success` boolean field
- Successful responses must include `assets` array with at least 3 items (TON, USDT, STARCOIN)
- All assets must have `network` field set to "TON"
- Error responses should include `error` field (optional but recommended)

If the API fails or returns an error, the frontend will automatically use default addresses to ensure the user experience is not disrupted.

---

## Address Generation Guidelines

**Important:** The backend should generate or retrieve unique receive addresses for each coin per user. Addresses should:

1. Be valid TON network addresses
2. Be unique for each user and coin combination
3. Be persistent (same address returned for same user/coin combination)
4. Be securely generated/stored
5. Follow TON network address format standards

---

## Network Requirement

**All receive addresses must be on the TON network.** The frontend filters and displays only TON network addresses, so the backend should only return addresses with `network: "TON"`.

