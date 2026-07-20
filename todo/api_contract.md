# Deals API Contract

Backend base: `http://192.168.0.113:8000`
All endpoints return JSON. Auth requires `Authorization: Bearer <token>` header.

---

## GET /deals/closing-soon

Returns mixed product + vendor deals sorted by shortest time remaining.

**Query params:** none

**Response:**
```json
{
  "deals": [
    {
      "type": "product",
      "id": "1",
      "name": "Bulk Organic Avocados (Box of 20)",
      "image_url": "https://...",
      "current_price": 18.50,
      "original_price": 35.00,
      "qty_current": 12,
      "qty_goal": 15,
      "confirmed_qty": 10,
      "hold_qty": 2,
      "time_remaining": 8100,
      "savings_percentage": 47.1
    },
    {
      "type": "vendor",
      "id": "v1",
      "name": "Costco Campus Delivery",
      "image_urls": ["https://...", "https://...", "https://...", "https://..."],
      "min_price": 350,
      "max_price": 500,
      "rating": 4.8,
      "review_count": 120,
      "time_remaining": 8100,
      "tag": "Free Shipping Split"
    }
  ]
}
```

**Notes:**
- `time_remaining` is seconds until deal closes (int)
- `type` field distinguishes product vs vendor cards
- `image_urls` for vendor deals: exactly 4 URLs (2x2 grid)
- `confirmed_qty` + `hold_qty` ≤ `qty_goal` (progress bar segments)
- Sorted ascending by `time_remaining` (shortest first)

---

## GET /deals/max-savings

Returns product deals only, sorted by highest savings percentage.

**Query params:** none

**Response:**
```json
{
  "deals": [
    {
      "type": "product",
      "id": "3",
      "name": "A4 Sketchbook Bundle (Pack of 10)",
      "image_url": "https://...",
      "current_price": 15.00,
      "original_price": 33.00,
      "qty_current": 22,
      "qty_goal": 50,
      "confirmed_qty": 15,
      "hold_qty": 7,
      "time_remaining": 172800,
      "savings_percentage": 54.5
    }
  ]
}
```

**Notes:**
- Product deals only — no vendor deals in this section
- Sorted descending by `savings_percentage`
- `time_remaining` may be null (deal has no deadline)

---

## GET /deals/categories

Returns top categories for the authenticated user.

**Query params:** none

**Response:**
```json
{
  "categories": [
    { "id": "1", "name": "Groceries", "icon_url": "https://..." },
    { "id": "2", "name": "Supplies", "icon_url": null },
    { "id": "3", "name": "Tech Acc.", "icon_url": null }
  ]
}
```

**Notes:**
- `icon_url` is optional (nullable)
- Max 10 categories
- First chip is always "All" (handled by frontend, not from API)
- Ordered by user relevance (most purchased/viewed first)

---

## GET /deals/suggested?category={id}

Returns suggested deals filtered by category.

**Query params:**
- `category` (optional) — category ID. If null/omitted, returns mixed from all categories.

**Response:**
```json
{
  "deals": [
    {
      "type": "product",
      "id": "5",
      "name": "Laundry Pods Mega Pack (120ct)",
      "image_url": "https://...",
      "current_price": 21.99,
      "original_price": 39.99,
      "qty_current": 45,
      "qty_goal": 100,
      "confirmed_qty": 30,
      "hold_qty": 15,
      "time_remaining": 172800,
      "savings_percentage": 45.0
    },
    {
      "type": "vendor",
      "id": "v3",
      "name": "Local Farmers Market",
      "image_urls": ["https://...", "https://...", "https://...", "https://..."],
      "min_price": 45,
      "max_price": 100,
      "rating": 4.9,
      "review_count": null,
      "time_remaining": 172800,
      "tag": null
    }
  ]
}
```

**Notes:**
- Max 50 items returned
- Mixed product + vendor deals
- When `category` is "All" or omitted, returns personalized suggestions
- No guaranteed sort order (algorithmic ranking)

---

## GET /deals/search?q={query}

Search deals by name.

**Query params:**
- `q` (required) — search string

**Response:**
```json
{
  "deals": [
    {
      "type": "product",
      "id": "1",
      "name": "Bulk Organic Avocados (Box of 20)",
      "image_url": "https://...",
      "current_price": 18.50,
      "original_price": 35.00,
      "qty_current": 12,
      "qty_goal": 15,
      "confirmed_qty": 10,
      "hold_qty": 2,
      "time_remaining": 8100,
      "savings_percentage": 47.1
    }
  ]
}
```

**Notes:**
- Returns mixed product + vendor deals
- Max 50 results
- Min query length: 2 chars (frontend should debounce)
- No results → `{ "deals": [] }`

---

## Common error response

```json
{
  "error": "Unauthorized",
  "message": "Invalid or expired token"
}
```

Status codes: 401 (auth), 404 (not found), 500 (server)
