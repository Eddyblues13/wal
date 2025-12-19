# API Specification: Send Transaction Endpoint

## Endpoint Details

**URL:** `send_transaction.php`  
**Method:** `POST`  
**Content-Type:** `application/json`

---

## Request Format

**Important:** The wallet address is REQUIRED in the request body. The backend uses the wallet address to identify and authenticate the user (no separate authentication token is used).

### Request Body Parameters

```json
{
  "wallet": "string (required)",
  "receiver_address": "string (required)",
  "coin_symbol": "string (required)",
  "amount": "string (required)",
  "network": "string (required)"
}
```

### Request Example

```json
{
  "wallet": "EQD7Z9B7GcjTRdcP4F1sLjQhA7tFq3RC8dO2HcK2hZMx",
  "receiver_address": "0x9876543210fedcba9876543210fedcba98765432",
  "coin_symbol": "TON",
  "amount": "10.50",
  "network": "TON"
}
```

### Request Validation Requirements

- `wallet`: Required, non-empty string (sender wallet address - used for authentication and user identification)
- `receiver_address`: Required, non-empty string (receiver wallet address)
- `coin_symbol`: Required, non-empty string (e.g., "TON", "USDT", "STARCOIN")
- `amount`: Required, non-empty string representing a positive decimal number
- `network`: Required, non-empty string (currently always "TON" for TON network)

### Authentication

**Note:** This API uses wallet-based authentication. The wallet address in the request body serves as both:
1. User identification (to identify which user is making the request)
2. Authentication mechanism (to verify the user is authorized)

The backend should:
1. Extract the `wallet` address from the request body
2. Validate that the wallet address exists in the system
3. Verify the wallet address is associated with an active user account
4. Use that wallet address as the sender for the transaction

---

## Response Format

### Success Response

**Status Code:** 200 (or success status)  
**Response Body:**

```json
{
  "success": true,
  "message": "Transaction sent successfully",
  "transaction_hash": "0xabcdef1234567890abcdef1234567890abcdef1234567890abcdef1234567890"
}
```

### Error Responses

#### Insufficient Balance

```json
{
  "success": false,
  "error": "Insufficient balance",
  "message": "You don't have enough balance to complete this transaction"
}
```

#### Invalid Receiver Address

```json
{
  "success": false,
  "error": "Invalid receiver address",
  "message": "The receiver wallet address is invalid"
}
```

#### Invalid Amount

```json
{
  "success": false,
  "error": "Invalid amount",
  "message": "The transaction amount must be greater than 0"
}
```

#### Wallet Not Found

```json
{
  "success": false,
  "error": "Wallet not found",
  "message": "No account found for the provided wallet address"
}
```

#### Network Error

```json
{
  "success": false,
  "error": "Network error",
  "message": "Failed to process transaction on TON network. Please try again."
}
```

#### Server Error

```json
{
  "success": false,
  "error": "Server error",
  "message": "An error occurred while processing the transaction. Please try again."
}
```

---

## Response Field Descriptions

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `success` | boolean | Yes | `true` if transaction was sent successfully, `false` otherwise |
| `message` | string | Yes | Human-readable message describing the result |
| `error` | string | No | Error code or description (only present when `success` is `false`) |
| `transaction_hash` | string | No | Transaction hash/ID on the blockchain (only present when `success` is `true`) |

---

## Expected Behavior

1. **Authentication:**
   - Extract the `wallet` address from the request body
   - Validate that the wallet address exists in the system
   - Verify the wallet address is associated with an active user account
   - Use the wallet address to identify the sender

2. **Validation:**
   - Verify sender wallet address exists in the system
   - Verify receiver wallet address is valid for the TON network
   - Validate amount is positive and does not exceed sender's balance
   - Verify coin symbol is supported on TON network
   - Verify network is "TON"

2. **Transaction Processing:**
   - Check sender has sufficient balance for the transaction
   - Process the transaction on the TON network
   - Update sender's balance in the database
   - Record transaction in transaction history
   - Generate transaction hash/ID

3. **Response:**
   - Return success response with transaction hash if transaction is processed successfully
   - Return appropriate error response if any validation fails
   - Always include a `success` boolean field
   - Always include a `message` field with user-friendly text

---

## Error Handling

The API should handle the following error scenarios:

1. **Missing Parameters:** Return error if any required field is missing (especially `wallet`)
2. **Invalid Wallet:** Return error if wallet address is missing, invalid format, or not found in system
3. **User Not Found:** Return error if wallet address is not associated with an active user account
4. **Invalid Receiver:** Return error if receiver address is invalid or not on TON network
5. **Insufficient Balance:** Return error if sender doesn't have enough balance
6. **Invalid Amount:** Return error if amount is zero, negative, or invalid format
7. **Unsupported Coin:** Return error if coin symbol is not supported on TON network
8. **Network Errors:** Return error if TON network transaction fails
9. **Database Errors:** Return error if database operation fails
10. **Server Errors:** Return error for any unexpected server-side issues

---

## Security Requirements

1. **Balance Verification:** Always verify balance before processing transaction
2. **Address Validation:** Validate both sender and receiver addresses are valid TON addresses
3. **Amount Validation:** Ensure amount is positive and within acceptable limits
4. **Rate Limiting:** Implement rate limiting to prevent spam transactions
5. **Transaction Logging:** Log all transaction attempts (without logging sensitive data)
6. **Double Spending Prevention:** Ensure transactions cannot be processed twice

---

## Testing Scenarios

### Test Case 1: Successful Transaction
- **Request:** Valid sender wallet, valid receiver address, valid amount within balance, TON coin, TON network
- **Expected:** `{"success": true, "message": "Transaction sent successfully", "transaction_hash": "..."}`

### Test Case 2: Insufficient Balance
- **Request:** Valid sender wallet, valid receiver address, amount exceeding balance
- **Expected:** `{"success": false, "error": "Insufficient balance", "message": "..."}`

### Test Case 3: Invalid Receiver Address
- **Request:** Valid sender wallet, invalid receiver address
- **Expected:** `{"success": false, "error": "Invalid receiver address", "message": "..."}`

### Test Case 4: Invalid Amount
- **Request:** Valid sender wallet, valid receiver address, amount = 0 or negative
- **Expected:** `{"success": false, "error": "Invalid amount", "message": "..."}`

### Test Case 5: Invalid Wallet
- **Request:** Missing or invalid wallet address
- **Expected:** `{"success": false, "error": "Invalid wallet", "message": "..."}`

### Test Case 6: User Not Found
- **Request:** Valid wallet format but wallet not found in system
- **Expected:** `{"success": false, "error": "User not found", "message": "..."}`

### Test Case 7: Missing Parameters
- **Request:** Missing one or more required fields
- **Expected:** `{"success": false, "error": "Missing parameters", "message": "..."}`

### Test Case 8: Unsupported Coin
- **Request:** Valid sender wallet, valid receiver address, unsupported coin symbol
- **Expected:** `{"success": false, "error": "Unsupported coin", "message": "..."}`

---

## Notes for Backend Developer

1. **Response Consistency:** Always return JSON with `success` boolean and `message` string fields
2. **Error Format:** Include `error` field for error responses to help with debugging
3. **Status Codes:** Use appropriate HTTP status codes (200 for success, 400 for client errors, 500 for server errors)
4. **Transaction Hash:** Include transaction hash in success response for blockchain verification
5. **Network:** Currently all transactions are on TON network, but the field is included for future extensibility
6. **Default Fallback:** The frontend will use default success response if API fails, so ensure proper error handling
7. **Balance Check:** Always verify balance before processing to prevent overdrafts
8. **Address Format:** Validate TON wallet addresses are in correct format

---

## Supported Coins on TON Network

The following coins are supported for sending on TON network:
- **TON** (Toncoin)
- **USDT** (Tether USD)
- **STARCOIN** (STAR)

All coins must be on the TON network. The `network` field should always be "TON" for these transactions.

---

## Example PHP Implementation Structure

```php
<?php
header('Content-Type: application/json');

// Get request data
$data = json_decode(file_get_contents('php://input'), true);

// Validate required fields
$required = ['wallet', 'receiver_address', 'coin_symbol', 'amount', 'network'];
foreach ($required as $field) {
    if (!isset($data[$field]) || empty($data[$field])) {
        echo json_encode([
            'success' => false,
            'error' => 'Missing parameters',
            'message' => 'All fields are required'
        ]);
        exit;
    }
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

// Validate receiver address format
// Validate amount is positive and within balance
// Validate coin symbol is supported on TON network
// Validate network is TON
// Process transaction on TON network
// Update balances in database
// Record transaction in history

// Return success response
echo json_encode([
    'success' => true,
    'message' => 'Transaction sent successfully',
    'transaction_hash' => $transactionHash
]);
?>
```

---

## Frontend Integration

The frontend expects:
- Response can be either JSON object or JSON string (will be parsed automatically)
- Response must include `success` boolean field
- Response must include `message` string field
- Success responses should include `transaction_hash` field (optional but recommended)
- Error responses should include `error` field (optional but recommended)

If the API fails or returns an error, the frontend will automatically use a default success response to ensure the user experience is not disrupted. However, it's recommended to handle all error cases properly on the backend.

---

## Balance Validation

**Important:** The backend must verify that the sender has sufficient balance before processing the transaction. The frontend performs client-side validation, but the backend must enforce this server-side to prevent overdrafts.

Balance check should:
1. Retrieve current balance for the sender wallet and coin symbol
2. Verify amount does not exceed available balance
3. Consider any pending transactions
4. Return error if balance is insufficient

---

## Transaction Hash Format

The `transaction_hash` should be a unique identifier for the transaction on the TON blockchain. It should be:
- A string value
- Unique for each transaction
- Verifiable on the TON blockchain explorer
- Included in success responses for user reference

Example format: `"0xabcdef1234567890abcdef1234567890abcdef1234567890abcdef1234567890"` or TON-specific format.

