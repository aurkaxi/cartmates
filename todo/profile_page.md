# Profile Page TODOs

## What's Built (mock data)

### Self-Profile (`/profile`)
- Avatar with camera icon picker (ImagePicker gallery)
- Local file path support for picked images (`_profileImage` helper)
- Fullscreen avatar view on tap (InteractiveViewer)
- Stats row: Deals Joined / Hosted / Failed / Points
- Reputation badge with star icon
- BDT Saved card
- Contact section: bKash + Phone with edit bottom sheet
- BD phone validation (`01[3-9]\d{8}`)
- Logout button with confirmation dialog
- Optimistic update on profile edit (no flash reload)

### Public Profile (`/profile/:userId`)
- Outside shell route (no bottom nav)
- Back button to return to deal detail
- Avatar (fullscreen on tap)
- Name, email, reputation badge
- Stats grid (Joined / Hosted / Failed / Points)
- "Currently Hosting" horizontal deal list
- "Joined Deals" horizontal deal list
- Contact info (read-only)
- Mock profiles: Rifat (user 2), Nafisa (user 3)

### Domain Layer
- `UserProfile` entity with `copyWith`
- `ProfileRepository` interface (getProfile, updateProfile, getPublicProfile)
- `GetProfileUseCase`, `UpdateProfileUseCase`
- `UserProfileModel` with `fromJson`/`toJson`/`copyWith`

### Data Layer
- `ProfileDataSource` with mock data (preserves `_cached` across calls)
- `ProfileRepositoryImpl` wiring all three methods

### Provider Layer
- `profileProvider` (AsyncNotifier) — self-profile state
- `publicProfileProvider` (FutureProvider.family) — public profile by userId

### Navigation
- Host row in deal detail → `context.push(publicProfilePath(host.userId))`
- `SameProductDealHostInfo` has `userId` field

---

## Pending

### API Contract
- [ ] Define profile API endpoints (GET /profile, PUT /profile, GET /profile/:userId)
- [ ] Document request/response shapes for profile update
- [ ] Document profile picture upload endpoint (PUT /profile/photo)
- [ ] Add to `todo/api_contract.md`

### Real Backend Integration
- [ ] Replace `ProfileDataSource` mock with Dio calls
- [ ] Profile picture upload (return URL, not local path)
- [ ] Real public profile fetching by userId
- [ ] Error handling for network failures
- [ ] Loading states for profile fetch/update

### Profile Picture
- [ ] Backend upload endpoint for image files
- [ ] Return hosted image URL after upload
- [ ] Cache-busting for updated avatars

### Auth Integration
- [ ] Wire session userId to profile fetch
- [ ] Redirect to login if unauthenticated
- [ ] Refresh profile after auth state changes

### UI Polish
- [ ] Pull-to-refresh on profile page
- [ ] Skeleton loading state for profile data
- [ ] Empty state for no hosted/joined deals
- [ ] Handle deleted users in public profile (404 state)

---

## Files

| File | Purpose |
|------|---------|
| `lib/src/features/profile/domain/entities/profile.dart` | UserProfile entity |
| `lib/src/features/profile/domain/repositories/profile_repository.dart` | Repository interface |
| `lib/src/features/profile/domain/usecases/get_profile.dart` | GetProfileUseCase |
| `lib/src/features/profile/domain/usecases/update_profile.dart` | UpdateProfileUseCase |
| `lib/src/features/profile/data/models/profile_model.dart` | UserProfileModel (JSON) |
| `lib/src/features/profile/data/datasources/profile_data_source.dart` | Mock data source |
| `lib/src/features/profile/data/repositories/profile_repository_impl.dart` | Repository impl |
| `lib/src/features/profile/presentation/providers/profile_provider.dart` | Riverpod providers |
| `lib/src/features/profile/presentation/screens/profile_page.dart` | Self-profile page |
| `lib/src/features/profile/presentation/screens/public_profile_page.dart` | Public profile page |
| `lib/src/features/profile/presentation/widgets/profile_edit_sheet.dart` | Edit bottom sheet |
| `lib/src/routing/app_routes.dart` | Route constants |
| `lib/src/routing/app_router.dart` | Router config |
