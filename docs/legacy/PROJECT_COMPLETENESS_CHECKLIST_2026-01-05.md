# Project Completeness Checklist

Use this checklist during Gap Analysis to identify what a project is missing.

## Step 1: Identify Project Type

First, determine what kind of project this is:

| Type | Indicators | Typical Needs |
|------|------------|---------------|
| **SaaS App** | Has user accounts, subscription, dashboard | Auth, billing, dashboard, settings |
| **Marketing Site** | Landing pages, no login | Landing, about, contact, pricing |
| **Internal Tool** | Admin-only, data management | Auth, dashboard, CRUD pages |
| **API Service** | No frontend, just endpoints | Docs, health check, admin |
| **Hybrid** | Public pages + authenticated sections | All of the above |

## Step 2: Check Core Pages

### Public Pages (Everyone sees these)

| Page | Required If | Check For |
|------|-------------|-----------|
| **Landing Page** | Any public-facing app | Hero, value prop, CTA, features |
| **Pricing Page** | SaaS/paid product | Tiers, comparison, FAQ |
| **About Page** | Public-facing | Team, mission, story |
| **Contact Page** | Public-facing | Form, email, location |
| **Blog/Resources** | Content marketing | Article list, individual posts |
| **404 Page** | Always | Custom styled, helpful links |
| **Error Page** | Always | 500, maintenance mode |

### Authentication Pages (If users log in)

| Page | Required If | Check For |
|------|-------------|-----------|
| **Login** | Has user accounts | Email/password, OAuth, remember me |
| **Register** | New users can sign up | Form validation, terms checkbox |
| **Forgot Password** | Has login | Email input, success message |
| **Reset Password** | Has forgot password | New password form, token validation |
| **Email Verification** | Requires verified email | Confirmation page, resend link |
| **Logout** | Has login | Clear session, redirect |

### Authenticated Pages (Logged-in users see these)

| Page | Required If | Check For |
|------|-------------|-----------|
| **Dashboard** | Users have data/activity | Overview, key metrics, quick actions |
| **Settings** | Users have preferences | Profile, notifications, security |
| **Profile** | Social/public profiles | Avatar, bio, activity |
| **Billing** | Paid subscriptions | Current plan, invoices, upgrade |
| **Notifications** | Has alerts/updates | List, mark read, preferences |

### Admin Pages (If content management needed)

| Page | Required If | Check For |
|------|-------------|-----------|
| **Admin Dashboard** | Need to manage content/users | Stats, recent activity |
| **User Management** | Admin manages users | List, search, edit, disable |
| **Content Management** | Dynamic content | CRUD for each content type |
| **Analytics** | Need insights | Charts, exports, filters |

## Step 3: Check Technical Requirements

### Authentication System

```
□ Using teneo-auth? → Read TENEO-AUTH-SETUP.md
□ OAuth providers needed? (Google, GitHub, etc.)
□ Role-based access? (admin, user, guest)
□ Session management? (JWT, cookies)
□ Protected routes configured?
```

### Database & Backend

```
□ Using Supabase? → Read SUPABASE_AUTONOMOUS_GUIDE.md
□ Database schema defined?
□ API endpoints documented?
□ Data validation in place?
□ Error handling implemented?
```

### Design & UX

```
□ Following design principles? → Read WEB-DESIGN-PRINCIPLES-TEMPLATE.md
□ Responsive design (mobile, tablet, desktop)?
□ Dark mode support?
□ Loading states for async operations?
□ Form validation with clear errors?
□ Consistent styling/theme?
```

### Security

```
□ Security checklist reviewed? → Read SECURITY_UNIVERSAL.md
□ Input sanitization?
□ CSRF protection?
□ Rate limiting?
□ Secure headers?
```

## Step 4: Generate Missing Tasks

For each missing item, create a task with the appropriate prefix:

```markdown
# Missing Landing Page
- [ ] RESEARCH: Analyze competitor landing pages for inspiration
- [ ] PLAN: Design landing page wireframe and sections
- [ ] IMPLEMENT: Build landing page hero section
- [ ] IMPLEMENT: Build landing page features section
- [ ] IMPLEMENT: Build landing page CTA section
- [ ] TEST: Verify landing page responsiveness

# Missing Authentication
- [ ] RESEARCH: Review teneo-auth integration requirements
- [ ] IMPLEMENT: Add login page with teneo-auth
- [ ] IMPLEMENT: Add register page with validation
- [ ] IMPLEMENT: Add forgot password flow
- [ ] IMPLEMENT: Add protected route middleware
- [ ] TEST: Verify auth flow end-to-end

# Missing Dashboard
- [ ] RESEARCH: Identify key metrics users need to see
- [ ] PLAN: Design dashboard layout and widgets
- [ ] IMPLEMENT: Build dashboard page structure
- [ ] IMPLEMENT: Add dashboard data fetching
- [ ] IMPLEMENT: Add dashboard charts/visualizations
- [ ] TEST: Verify dashboard with real data
```

## Step 5: Priority Order

Build in this order to unblock dependencies:

1. **Authentication** (if needed) - Everything else depends on this
2. **Database/API** - Data layer for all pages
3. **Core Pages** - Dashboard, main functionality
4. **Settings/Profile** - User customization
5. **Public Pages** - Landing, about, contact
6. **Polish** - Error pages, loading states, animations

## Quick Decision Tree

```
START
  │
  ├─ Does the app have users?
  │   ├─ YES → Need: Auth pages, Dashboard, Settings
  │   └─ NO  → Skip auth, focus on public pages
  │
  ├─ Is it a paid product?
  │   ├─ YES → Need: Pricing page, Billing page
  │   └─ NO  → Skip billing
  │
  ├─ Is it public-facing?
  │   ├─ YES → Need: Landing, About, Contact, SEO
  │   └─ NO  → Skip marketing pages
  │
  ├─ Does it have dynamic content?
  │   ├─ YES → Need: Admin panel, Content management
  │   └─ NO  → Skip admin
  │
  └─ Does it need to look professional?
      ├─ YES → Apply WEB-DESIGN-PRINCIPLES-TEMPLATE.md
      └─ NO  → Basic functional styling
```

## Example Gap Analysis Output

```markdown
## Project: FitLabs
## Type: SaaS App (Hybrid)

### What Exists
- [x] Landing page (basic)
- [x] Login/Register (teneo-auth)
- [x] Dashboard (partial)

### What's Missing
- [ ] Pricing page - CRITICAL for conversions
- [ ] Settings page - Users can't change preferences
- [ ] Forgot password - Users get locked out
- [ ] 404 page - Shows ugly default
- [ ] Mobile responsive - Breaks on phone

### Generated Tasks
- [ ] IMPLEMENT: Add pricing page with 3 tiers
- [ ] IMPLEMENT: Add settings page with profile/notifications tabs
- [ ] IMPLEMENT: Add forgot password flow using teneo-auth
- [ ] IMPLEMENT: Create custom 404 page with navigation
- [ ] FIX: Make dashboard responsive for mobile
```
