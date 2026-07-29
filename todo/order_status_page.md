# Order Status / Detail Page TODOs

## Overview
The order status page is what the user sees after tapping a cart item. It shows the full deal lifecycle, participant status, and available actions. Two views: Passive (joined) and Active (hosting).

---

## Business Logic — Full Workflow

### 1. User Joins Deal → Payment Proof → Hold
- User submits payment proof screenshot/details
- Status: `hold` on participant
- Deal: `recruiting`
- Host sees pending payment to review

### 2. Host Reviews Payment
- **Confirm** → participant status becomes `confirmed`
- **Reject (fake proof)** → participant status becomes `denied`
- Host CANNOT proceed to order until ALL hold/rejected/disputed participants are resolved
- Every participant must be `confirmed` before deal moves forward

### 3. If Rejected (denied)
User has 3 options:
- **Submit again** → status goes back to `hold`
- **Accept defeat** → stays `denied`, gets penalty if no dispute filed
- **Dispute to admin** → status becomes `disputed`, deal BLOCKED until admin resolves

### 4. Dispute Flow
- Disputed status BLOCKS the deal from progressing
- Host cannot order until dispute is resolved
- Admin resolves (not built yet — later feature)
- Both parties must be satisfied before proceeding

### 5. Deal Filling Phase
- Deal stays `recruiting` until qty/goal met
- If qty met → deal becomes `ready`
- If time expires before full → deal becomes `expired`

### 6. Expired Deal — Host Decision
- **Cancel deal** → deal becomes `cancelled`, refunds needed for all participants
  - Ongoing disputes prevent cancellation
  - Must resolve disputes first
- **Order with less** → host can only proceed with `confirmed` participants
  - ALL hold/disputed participants must be resolved first
  - Hold money either returned to user or confirmed for order
  - Dispute must be admin-resolved
  - Rejected with no dispute = assumed fake, gets penalty

### 7. Host Places Order
- Deal status → `ordered`
- Host can optionally add tracking info:
  - `trackingNumber` (string, optional)
  - `trackingUrl` (string, optional)
- All confirmed participants see tracking info

### 8. Product Arrives at Host
- Deal status → `arrived`
- Host must distribute to all confirmed members
- Each participant has `received: true/false`
- Deal STAYS `arrived` until ALL confirmed participants marked received
- Host marks individual pickup/delivery as it happens

### 9. All Received → Complete
- Once all confirmed participants marked received
- Deal status → `completed`

---

## Order Status Page — Passive (Joined) View

### Shows
- Deal info (name, image, price, quantity)
- Host info (name, avatar, reputation)
- Timeline / progress indicator:
  - Hold → Confirmed → Ordered → Arrived → Completed
- Current participant status badge
- Current deal status badge
- Tracking info (if ordered)
- Pickup location details
- Price breakdown

### Actions (contextual)
| Participant Status | Available Actions |
|--------------------|-------------------|
| hold | Cancel join, View proof submitted |
| confirmed | Wait (no action) |
| denied | Resubmit proof, Dispute to admin, Accept defeat |
| disputed | Wait for admin, View dispute status |
| ordered | View tracking |
| arrived | Confirm pickup/received |
| completed | View receipt |

### Dispute Flow (Passive)
- If denied → show dispute option
- File dispute → admin notified
- Wait for resolution
- Status shows "Under Review"

### Pickup Confirmation (Passive)
- When deal status = `arrived`
- Show "Confirm Pickup" button
- User taps → sets `received = true`
- If last person → deal auto-completes

---

## Order Status Page — Active (Hosting) View

### Shows
- Deal info (name, image, goal qty, current qty)
- Participant list with individual statuses
- Payment summary (confirmed, hold, denied counts)
- Deal lifecycle timeline
- Tracking info management
- Pickup/distribution progress

### Actions (contextual)
| Deal Status | Available Actions |
|-------------|-------------------|
| recruiting | Confirm/reject pending payments, Cancel deal |
| ready | Place order |
| expired | Cancel deal, Order with less (if all disputes resolved) |
| ordered | Add/edit tracking number + URL |
| arrived | Mark individual participants as received |
| completed | View summary |
| cancelled | View refund status |

### Payment Management (Recruiting)
- See list of participants with `hold` status
- For each: Confirm or Reject
- Must resolve ALL before deal can proceed
- Block message if any unresolved: "Resolve all pending payments first"

### Cancel Deal
- Only if no active disputes
- Refund flow triggered (not implemented yet)
- Deal → `cancelled`

### Order with Less
- Only if all hold/rejected/disputed resolved
- Only confirmed participants counted
- Proceeds with confirmed members only

### Tracking Management (Ordered)
- Input field: Tracking Number
- Input field: Tracking URL
- Save → all participants see it

### Distribution (Arrived)
- List of confirmed participants
- Toggle `received` for each
- Progress bar: X/Y received
- Auto-complete when all received

---

## Route
- Path: `/cart/order/:dealId`
- Nested under cart branch (preserves bottom nav)
- Uses `push` navigation (back returns to cart with state)

---

## Backend Contract
- See `todo/api_contract.md` for existing deal endpoints
- Cart/order endpoints: TBD
- Participant management endpoints: TBD
- Tracking endpoints: TBD
- Dispute endpoints: TBD (later)
- Refund endpoints: TBD (later)

---

## Files
| File | Purpose |
|------|---------|
| `lib/src/features/cart/presentation/screens/order_status_page.dart` | Main page (passive view) |
| `lib/src/features/cart/presentation/widgets/order_summary_card.dart` | Order summary |
| `lib/src/features/cart/presentation/widgets/order_timeline.dart` | Timeline widget |
| `lib/src/features/cart/presentation/widgets/host_info_card.dart` | Host info + call |
| `lib/src/features/cart/presentation/widgets/pickup_location_card.dart` | Pickup + deadline grid |
| `lib/src/features/cart/presentation/widgets/deal_progress_card.dart` | Deal progress bar |
| `lib/src/features/cart/presentation/widgets/action_banner.dart` | Contextual action banner |
| `lib/src/features/cart/presentation/widgets/host_updates_feed.dart` | Host broadcasts |
| `lib/src/features/cart/presentation/providers/order_status_provider.dart` | State providers |

---

## Action Pages (Future)

### Resubmit Payment Proof
- Triggered from: `ActionBanner` when `participantStatus == denied`
- Route: `/cart/order/:dealId/resubmit`
- UI: Upload screenshot form (reuse join deal payment upload)
- Action: Updates `paymentProofUrl`, sets status back to `hold`
- Fields: image picker, optional note

### Dispute to Admin
- Triggered from: `ActionBanner` when `participantStatus == denied`
- Route: `/cart/order/:dealId/dispute`
- UI: Form with reason text field, optional evidence upload
- Action: Sets `participantStatus` to `disputed`, adds dispute record
- Fields: reason (required), evidence URLs (optional)

### Cancel Join
- Triggered from: `ActionBanner` when `participantStatus == hold`
- Route: `/cart/order/:dealId/cancel`
- UI: Confirmation dialog (not a full page)
- Action: Removes participant from deal, navigates back to cart

### Confirm Receipt
- Triggered from: `ActionBanner` when `participantStatus == arrived` and `received == false`
- Route: `/cart/order/:dealId/confirm-receipt`
- UI: Confirmation dialog with item summary
- Action: Sets `received = true`, `participantStatus` to `completed`

### View Tracking
- Triggered from: OrderSummaryCard when tracking exists
- Route: External URL or in-app webview
- Action: Opens `trackingUrl` if available, else shows tracking number with copy

---

## Pending
- [ ] Build resubmit payment proof page
- [ ] Build dispute form page
- [ ] Build cancel join confirmation dialog
- [ ] Build confirm receipt dialog
- [ ] Build tracking viewer
- [ ] Design participant list (host view)
- [ ] Design payment action buttons (confirm/reject) - host
- [ ] Design tracking input form (host)
- [ ] Design cancel deal flow (host)
- [ ] Design refund status display
- [ ] Backend endpoints for all actions
