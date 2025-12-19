# API Specification: Update Password Endpoint

## Endpoint Details

**URL:** `update_password.php`  
**Method:** `POST`  
**Content-Type:** `application/json`

---

## Request Format

**Important:** The wallet address is REQUIRED in the request body. The backend uses the wallet address to identify and authenticate the user (no separate authentication token is used).

### Request Body Parameters

```json
{
  "wallet": "string (required)",
  "old_password": "string (required)",
  "new_password": "string (required)"
}
```

### Request Example

```json
{
  "wallet": "EQD7Z9B7GcjTRdcP4F1sLjQhA7tFq3RC8dO2HcK2hZMx",
  "old_password": "OldPassword123",
  "new_password": "NewPassword456"
}
```

### Request Validation Requirements

- `wallet`: Required, non-empty string (wallet address - used for authentication and user identification)
- `old_password`: Required, non-empty string (current password)
- `new_password`: Required, minimum 6 characters, non-empty string

### Authentication

**Note:** This API uses wallet-based authentication. The wallet address in the request body serves as both:
1. User identification (to identify which user is updating their password)
2. Authentication mechanism (to verify the user is authorized)

The backend should:
1. Extract the `wallet` address from the request body
2. Validate that the wallet address exists in the system
3. Verify the wallet address is associated with an active user account
4. Use that wallet address for the password update operation

---

## Response Format

### Success Response

**Status Code:** 200 (or success status)  
**Response Body:**

```json
{
  "success": true,
  "message": "Password updated successfully"
}
```

### Error Responses

#### Invalid Old Password

```json
{
  "success": false,
  "error": "Invalid current password",
  "message": "The current password you entered is incorrect"
}
```

#### Password Validation Error

```json
{
  "success": false,
  "error": "Password validation failed",
  "message": "New password must be at least 6 characters long"
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

#### Server Error

```json
{
  "success": false,
  "error": "Server error",
  "message": "An error occurred while updating password. Please try again."
}
```

---

## Response Field Descriptions

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `success` | boolean | Yes | `true` if password was updated successfully, `false` otherwise |
| `message` | string | Yes | Human-readable message describing the result |
| `error` | string | No | Error code or description (only present when `success` is `false`) |

---

## Expected Behavior

1. **Authentication:**
   - Extract the `wallet` address from the request body
   - Validate that the wallet address exists in the system
   - Verify the wallet address is associated with an active user account
   - Use the wallet address to identify the user

2. **Validation:**
   - Verify old password matches the current password for the wallet address
   - Validate new password meets requirements (minimum length, etc.)

2. **Password Update:**
   - Hash the new password securely before storing
   - Update the password in the database
   - Invalidate any existing sessions if required by security policy

3. **Response:**
   - Return success response if password is updated successfully
   - Return appropriate error response if any validation fails
   - Always include a `success` boolean field
   - Always include a `message` field with user-friendly text

---

## Error Handling

The API should handle the following error scenarios:

1. **Missing Parameters:** Return error if any required field is missing (especially `wallet`)
2. **Invalid Wallet:** Return error if wallet address is missing, invalid format, or not found in system
3. **User Not Found:** Return error if wallet address is not associated with an active user account
4. **Wrong Old Password:** Return error if old password doesn't match
5. **Weak New Password:** Return error if new password doesn't meet requirements
6. **Database Errors:** Return error if database operation fails
7. **Server Errors:** Return error for any unexpected server-side issues

---

## Security Requirements

1. **Password Hashing:** New password must be hashed (e.g., bcrypt, argon2) before storage
2. **Rate Limiting:** Implement rate limiting to prevent brute force attacks
3. **Password Strength:** Enforce minimum password requirements (e.g., 6+ characters)
4. **Session Management:** Optionally invalidate existing sessions after password change
5. **Logging:** Log password update attempts (without logging actual passwords)

---

## Testing Scenarios

### Test Case 1: Successful Password Update
- **Request:** Valid wallet, correct old password, valid new password
- **Expected:** `{"success": true, "message": "Password updated successfully"}`

### Test Case 2: Invalid Old Password
- **Request:** Valid wallet, incorrect old password, valid new password
- **Expected:** `{"success": false, "error": "Invalid current password", "message": "..."}`

### Test Case 3: Weak New Password
- **Request:** Valid wallet, correct old password, password less than 6 characters
- **Expected:** `{"success": false, "error": "Password validation failed", "message": "..."}`

### Test Case 4: Invalid Wallet
- **Request:** Missing or invalid wallet address
- **Expected:** `{"success": false, "error": "Invalid wallet", "message": "..."}`

### Test Case 5: User Not Found
- **Request:** Valid wallet format but wallet not found in system
- **Expected:** `{"success": false, "error": "User not found", "message": "..."}`

### Test Case 6: Missing Parameters
- **Request:** Missing one or more required fields
- **Expected:** `{"success": false, "error": "Missing parameters", "message": "..."}`

---

## Notes for Backend Developer

1. **Response Consistency:** Always return JSON with `success` boolean and `message` string fields
2. **Error Format:** Include `error` field for error responses to help with debugging
3. **Status Codes:** Use appropriate HTTP status codes (200 for success, 400 for client errors, 500 for server errors)
4. **Password Security:** Never return passwords in responses, even in error messages
5. **Default Fallback:** The frontend will use default success response if API fails, so ensure proper error handling

---

## Example PHP Implementation Structure

```php
<?php
header('Content-Type: application/json');

// Get request data
$data = json_decode(file_get_contents('php://input'), true);

// Validate required fields
if (!isset($data['wallet']) || !isset($data['old_password']) || !isset($data['new_password'])) {
    echo json_encode([
        'success' => false,
        'error' => 'Missing parameters',
        'message' => 'All fields are required'
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

// Verify old password
// Validate new password strength
// Update password in database

// Return success response
echo json_encode([
    'success' => true,
    'message' => 'Password updated successfully'
]);
?>
```

---

## Frontend Integration

The frontend expects:
- Response can be either JSON object or JSON string (will be parsed automatically)
- Response must include `success` boolean field
- Response must include `message` string field
- Error responses should include `error` field (optional but recommended)

If the API fails or returns an error, the frontend will automatically use a default success response to ensure the user experience is not disrupted.

