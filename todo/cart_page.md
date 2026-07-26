# Cart Page TODOs

## Status Model

### DealStatus (canonical deal lifecycle)
| Status | Label | Description |
|--------|-------|-------------|
| `recruiting` | Recruiting | Open for joins |
| `ready` | Ready | Min qty met, host can order |
| `ordered` | Ordered | Host placed order |
| `arrived` | Arrived | Goods at host |
| `completed` | Completed | All distributed |
| `expired` | Expired | Time up, host decides |
| `cancelled` | Cancelled | Host cancelled |

### ParticipantStatus (per-user state within deal)
| Status | Label | Description |
|--------|-------|-------------|
| `hold` | Hold | Payment proof submitted, awaiting host |
| `confirmed` | Confirmed | Host approved payment |
| `denied` | Denied | Host rejected proof |
| `disputed` | Disputed | Admin dispute in progress |
| `ordered` | Ordered | Deal ordered |
| `arrived` | Arrived | Goods at host |
| `completed` | Completed | Received |
| `expired` | Expired | Deal expired |

---

## Workflow

1. User joins deal → submits payment proof → `hold`
2. Host reviews → `confirmed` or `denied`
3. If denied → user can dispute, resubmit, or accept
4. If confirmed → wait for deal to fill
5. Deal full → `ready` → host orders → `ordered`
6. If expired → host cancels or orders with less (must clear disputes first)
7. Goods arrive → `arrived` → members pick up
8. All received → `completed`

### Host actions
- Confirm/reject payments
- Mark deal status (ready, ordered, arrived, completed, cancelled)
- Add tracking number/url after ordering
- Mark individual participants as received

### Passive (joined) view
- See participant status (hold, confirmed, denied, ordered, arrived, completed, expired)
- See deal status for context
- Can dispute if denied

### Active (hosting) view
- See deal status (recruiting, ready, expired, ordered, arrived, completed, cancelled)
- Manage participants, payments, orders

---

## Cart Filters (simplified)

Both tabs use same 5 pills: `All | Recruiting | Ordered | Arrived | Completed`

Filter logic uses `dealStatus`:
- **Recruiting**: dealStatus ∈ {recruiting, ready, expired}
- **Ordered/Arrived/Completed**: dealStatus matches exactly
- **All**: everything

---

## Mock Data (17 items)

### Passive (9 items)
| # | Name | Participant | Deal | Scenario |
|---|------|-------------|------|----------|
| 1 | Organic Avocados | hold | recruiting | Payment submitted, awaiting host |
| 2 | Premium Paper Towels | confirmed | recruiting | Host approved, still recruiting |
| 3 | Artisan Coffee Beans | denied | recruiting | Host rejected, can dispute |
| 4 | Storage Bins Set | confirmed | expired | Time up, host deciding |
| 5 | IKEA Dorm Run | confirmed | ordered | Host ordered, tracking available |
| 6 | Bulk Laundry Detergent | arrived | arrived | Pending pickup |
| 7 | Campus Snack Pack | completed | arrived | User picked up |
| 8 | Group Textbook Order | completed | completed | All done |
| 9 | Wireless Earbuds Bulk | denied | recruiting | Can dispute |

### Active (8 items)
| # | Name | Deal | Scenario |
|---|------|------|----------|
| 10 | IKEA Dorm Run | recruiting | Waiting for members |
| 11 | Bulk Protein Powder | ready | Can place order now |
| 12 | Campus Coffee Run | expired | Cancel or order with less |
| 13 | Dorm Essentials Kit | ordered | Add tracking link |
| 14 | Shared Fridge Stock | arrived | Distribute, mark received |
| 15 | Semester Book Bundle | completed | All distributed |
| 16 | Cancelled Group Order | cancelled | Deal cancelled |
| 17 | Disputed Electronics Order | recruiting | Admin dispute |

---

## Tracking
- Optional `trackingNumber` and `trackingUrl` fields on CartItem
- Only available when dealStatus = `ordered`

---

## Partial Pickup
- `received` boolean on CartItem
- Deal stays `arrived` until all confirmed participants mark received
- Host sees received/total progress

---

## Backend Contract
- Backend: `http://192.168.0.113:8000`
- See `todo/api_contract.md` for existing deal endpoints
- Cart/order endpoints: TBD (frontend first with mock data)

---

## Files

| File | Purpose |
|------|---------|
| `lib/src/features/cart/domain/entities/deal_status.dart` | DealStatus + ParticipantStatus enums |
| `lib/src/features/cart/domain/entities/cart_item.dart` | CartItem entity |
| `lib/src/features/cart/domain/repositories/cart_repository.dart` | Repository contract |
| `lib/src/features/cart/domain/usecases/get_cart_items.dart` | GetCartItems use case |
| `lib/src/features/cart/data/models/cart_item_model.dart` | CartItemModel with JSON |
| `lib/src/features/cart/data/datasources/cart_local_datasource.dart` | Mock data (17 items) |
| `lib/src/features/cart/data/repositories/cart_repository_impl.dart` | Repository implementation |
| `lib/src/features/cart/presentation/providers/cart_provider.dart` | Riverpod providers |
| `lib/src/features/cart/presentation/widgets/cart_tab_bar.dart` | Passive/Active toggle |
| `lib/src/features/cart/presentation/widgets/cart_status_filter.dart` | Status filter pills |
| `lib/src/features/cart/presentation/widgets/cart_item_tile.dart` | Deal list tile |
| `lib/src/features/cart/presentation/screens/cart_page.dart` | Cart page |
| `lib/src/features/cart/presentation/screens/order_status_page.dart` | Order status (placeholder) |
| `lib/src/shared/widgets/deal_status_chip.dart` | Reusable status chip |
| `lib/src/routing/app_routes.dart` | Route constants |
| `lib/src/routing/app_router.dart` | Router config |

---

## Pending
- [ ] OrderStatusPage — full implementation with role-based tabs
- [ ] Dispute flow (admin UI)
- [ ] Tracking info UI (add/edit)
- [ ] Received/pickup confirmation UI
- [ ] Host: confirm/reject payment UI
- [ ] Host: mark deal status actions
- [ ] Backend cart/order API contract
