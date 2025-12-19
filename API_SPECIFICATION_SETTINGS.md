# API Specification: Settings Endpoints

This document describes all settings-related API endpoints. All endpoints use wallet-based authentication. The wallet address is sent in the request body and serves as both user identification and authentication mechanism (no separate authentication token is used).

---

## 1. Get Settings Data Endpoint

### Endpoint Details

**URL:** `settings_data.php`  
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
  "message": "Settings data fetched successfully",
  "userProfile": {
    "name": "John Doe",
    "email": "john.doe@example.com",
    "wallet": "EQD7Z9B7GcjTRdcP4F1sLjQhA7tFq3RC8dO2HcK2hZMx"
  },
  "referralCode": "REF123456",
  "xLink": "https://twitter.com/starwallet",
  "telegramLink": "https://t.me/starwallet"
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

#### Response Fields

- `success` (boolean, required): Indicates if the operation was successful.
- `message` (string, required): A user-friendly message describing the outcome.
- `error` (string, optional): An error code or description, present if `success` is `false`.
- `userProfile` (object, required on success): User profile information containing:
  - `name` (string, required): User's full name.
  - `email` (string, required): User's email address.
  - `wallet` (string, optional): User's wallet address.
- `referralCode` (string, required on success): User's referral code (e.g., "REF123456").
- `xLink` (string, required on success): X (formerly Twitter) social media link.
- `telegramLink` (string, required on success): Telegram social media link.

---

## 2. Get About Page Links Endpoint

### Endpoint Details

**URL:** `about_links.php`  
**Method:** `POST`  
**Content-Type:** `application/json`

---

### Authentication

This endpoint requires user authentication. The user's identity (and thus their wallet address) should be derived from the authentication token provided in the `Authorization` header.

**Header:** `Authorization: Bearer <user_auth_token>`

---

### Request Format

#### Request Body Parameters

This endpoint does not require any parameters in the request body. The user's wallet address is identified via the authentication token.

```json
{}
```

---

### Response Format

#### Success Response

**Status Code:** 200 (or success status)  
**Response Body:**
```json
{
  "success": true,
  "message": "About links fetched successfully",
  "privacy_policy_url": "https://starwallet.com/privacy-policy",
  "terms_of_service_url": "https://starwallet.com/terms-of-service",
  "open_source_licenses_url": "https://starwallet.com/open-source-licenses"
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

#### Response Fields

- `success` (boolean, required): Indicates if the operation was successful.
- `message` (string, required): A user-friendly message describing the outcome.
- `error` (string, optional): An error code or description, present if `success` is `false`.
- `privacy_policy_url` (string, required on success): URL to the Privacy Policy page.
- `terms_of_service_url` (string, required on success): URL to the Terms of Service page.
- `open_source_licenses_url` (string, required on success): URL to the Open Source Licenses page.

---

## Backend Implementation Notes

### Authentication
- All endpoints must validate the `wallet` parameter in the request body.
- Validate that the wallet address exists in the system.
- Verify the wallet address is associated with an active user account.
- If wallet is missing, invalid, or not found, return an error response.

### Data Retrieval
- For `settings_data.php`: Fetch the user's profile information, referral code, and social media links (X and Telegram) for the authenticated user.
- For `about_links.php`: Return the URLs for Privacy Policy, Terms of Service, and Open Source Licenses.

### Default Data
- If there are no specific data for a user or an error occurs, provide default data:
  - **Settings Data**: Default user profile (name: "User", email: "user@example.com"), referral code "REF123456", X link "https://twitter.com/starwallet", Telegram link "https://t.me/starwallet".
  - **About Links**: Default URLs pointing to starwallet.com for Privacy Policy, Terms of Service, and Open Source Licenses.

### Error Handling
- Return clear error messages for authentication failures, internal server errors, or any issues during data retrieval.

### Important Notes
- **No "Member" Level**: The user profile should NOT include a "level" or "member" field. This has been removed from the application.
- **App Name**: All references should be to "Star Wallet" (not "Trust Wallet").

---

## Testing Scenarios

### Settings Data Endpoint
1. **Successful Retrieval:**
   - Request: Valid wallet address.
   - Expected: `success: true`, user profile, referral code, and social links.
2. **Authentication Failure:**
   - Request: Missing or invalid wallet address.
   - Expected: `success: false`, appropriate error message (e.g., "Invalid wallet").
3. **Internal Server Error:**
   - Request: Valid wallet, but backend encounters an error.
   - Expected: `success: false`, generic error message (e.g., "Internal server error").

### About Links Endpoint
1. **Successful Retrieval:**
   - Request: Valid wallet address.
   - Expected: `success: true`, URLs for Privacy Policy, Terms of Service, and Open Source Licenses.
2. **Authentication Failure:**
   - Request: Missing or invalid wallet address.
   - Expected: `success: false`, appropriate error message (e.g., "Invalid wallet").

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
    case 'settings_data.php':
        handleSettingsData($userWalletAddress);
        break;
    case 'about_links.php':
        handleAboutLinks();
        break;
    default:
        http_response_code(404);
        echo json_encode([
            "success" => false,
            "error" => "NOT_FOUND",
            "message" => "Endpoint not found"
        ]);
}

function handleSettingsData($wallet) {
    // In a real application, query your database for user settings
    $userProfile = [
        'name' => 'John Doe',
        'email' => 'john.doe@example.com',
        'wallet' => $wallet
    ];
    
    // Generate or fetch referral code from database
    $referralCode = 'REF' . substr(strtoupper($wallet), 0, 6);
    
    echo json_encode([
        "success" => true,
        "message" => "Settings data fetched successfully",
        "userProfile" => $userProfile,
        "referralCode" => $referralCode,
        "xLink" => "https://twitter.com/starwallet",
        "telegramLink" => "https://t.me/starwallet"
    ]);
}

function handleAboutLinks() {
    echo json_encode([
        "success" => true,
        "message" => "About links fetched successfully",
        "privacy_policy_url" => "https://starwallet.com/privacy-policy",
        "terms_of_service_url" => "https://starwallet.com/terms-of-service",
        "open_source_licenses_url" => "https://starwallet.com/open-source-licenses"
    ]);
}
?>
```

---

## Summary

All settings endpoints:
- Use wallet-based authentication (`wallet` parameter required in request body)
- Provide default data if API fails
- Return consistent JSON response format
- Include proper error handling
- Do NOT include "Member" level in user profile
- Use "Star Wallet" branding (not "Trust Wallet")

The frontend will handle all settings data, referral codes, social links, and about page links through these endpoints.

