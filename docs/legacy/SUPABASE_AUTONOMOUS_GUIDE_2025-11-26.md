# Supabase Autonomous Editing Protocol

**For Claude Code: How to execute database operations WITHOUT user intervention**

---

## FIRST TIME IN A NEW PROJECT? (Claude: Do This Automatically)

If MCP isn't configured yet, run this:
```bash
claude mcp add supabase -s project -t http -- https://mcp.supabase.com/mcp
```

Then tell the user: "I've added Supabase MCP. Please restart Claude Code and run `/mcp` to authenticate."

---

## TL;DR for Claude

When the user asks you to modify a database:

1. **Check if MCP is available** - try using `mcp__supabase__*` tools first
2. **If MCP unavailable** - use server actions or scripts
3. **NEVER** ask user to run SQL manually
4. **CONFIRM** results with specific details

---

## MCP Setup (100% Autonomous - PREFERRED)

MCP gives Claude direct database access. No scripts needed.

### New Project Setup (Claude Should Run This)
```bash
# Add to project (creates .mcp.json - can be committed to repo)
claude mcp add supabase -s project -t http -- https://mcp.supabase.com/mcp
```

### Alternative: User-Level (All Projects)
```bash
# Add globally (stored in ~/.claude.json)
claude mcp add supabase -s user -t http -- https://mcp.supabase.com/mcp
```

### Authenticate (One-Time Per Machine)
1. Restart Claude Code after adding MCP server
2. Run `/mcp` in Claude Code
3. Click "supabase" and authenticate with Supabase account

### Verify Setup
```bash
claude mcp list
# Should show: supabase: https://mcp.supabase.com/mcp (HTTP) - ✓ Connected
```

### Available MCP Tools
Once authenticated, Claude has access to:
- `mcp__supabase__list_tables` - List all tables
- `mcp__supabase__query` - Run SELECT queries
- `mcp__supabase__execute` - Run INSERT/UPDATE/DELETE
- `mcp__supabase__create_table` - Create tables
- `mcp__supabase__describe_table` - Get table schema

### How Claude Uses MCP
```
USER: "Add a blood sugar reading of 105 fasting"

CLAUDE: *Uses mcp__supabase__execute tool*
INSERT INTO blood_sugar_logs (user_id, glucose_level, reading_type)
VALUES ('user-123', 105, 'fasting')

CLAUDE: "✅ Done! Reading logged."
```

---

## Fallback: Setup Requirements (When MCP unavailable)

### Required Environment Variable

Add to `.env.local`:
```
SUPABASE_SERVICE_ROLE_KEY=your_service_role_key_here
```

Get from: **Supabase Dashboard → Settings → API → service_role (secret)**

### Required Files

1. **Server-side Supabase client**: `src/lib/supabase/server.ts`
2. **Server actions**: `src/lib/actions/*.ts`
3. **Admin script**: `scripts/db-admin.ts`

---

## Method 1: Server Actions (Recommended)

For CRUD operations on existing tables.

### File Structure
```
src/lib/actions/
├── index.ts          # Exports all actions
├── health.ts         # Health records, blood sugar
├── stretching.ts     # Stretching routines
├── workouts.ts       # Workout management
├── meals.ts          # Meal tracking
└── db-admin.ts       # Table checks, seeding
```

### Usage Pattern

```typescript
'use server'

import { createClient } from '@/lib/supabase/server'
import { revalidatePath } from 'next/cache'

export async function updateRecord(table: string, id: string, data: any) {
  const supabase = await createClient()

  const { data: result, error } = await supabase
    .from(table)
    .update({ ...data, updated_at: new Date().toISOString() })
    .eq('id', id)
    .select()
    .single()

  if (error) throw new Error(error.message)

  revalidatePath('/')
  return result
}
```

### How Claude Should Use This

```
USER: "Add a blood sugar reading of 105 fasting for my account"

CLAUDE: "I'll add that reading now."

*Creates/runs:*
import { addBloodSugarReading } from '@/lib/actions/health'

await addBloodSugarReading('user-id', {
  glucose_level: 105,
  reading_type: 'fasting'
})

CLAUDE: "✅ Done! Blood sugar reading logged:
         Level: 105 mg/dL
         Type: Fasting
         Status: Normal range"
```

---

## Method 2: Admin Scripts (For Migrations & Seeding)

For schema changes, migrations, and bulk operations.

### Script Location
```
scripts/db-admin.ts
```

### Available Commands

```bash
# Check database health
npx tsx scripts/db-admin.ts health

# Run specific migration
npx tsx scripts/db-admin.ts migrate 0014_stretching_routines.sql

# Run all pending migrations
npx tsx scripts/db-admin.ts migrate-all

# Seed data
npx tsx scripts/db-admin.ts seed foods
npx tsx scripts/db-admin.ts seed exercises

# List tables
npx tsx scripts/db-admin.ts tables
```

### How Claude Should Use This

```
USER: "Set up the stretching routines feature"

CLAUDE: "I'll create the migration and run it."

*Creates migration file: 0014_stretching_routines.sql*
*Runs:*
npx tsx scripts/db-admin.ts migrate 0014_stretching_routines.sql

CLAUDE: "✅ Done!
         Created tables: stretching_exercises, stretching_routines, stretching_logs
         Seeded: 10 default exercises
         Ready to use at /stretching"
```

---

## Method 3: Direct Script Execution

For one-off operations.

### Create and Run Script

```typescript
// scripts/update-thing.ts
import { createClient } from '@supabase/supabase-js'

const supabase = createClient(
  process.env.NEXT_PUBLIC_SUPABASE_URL!,
  process.env.SUPABASE_SERVICE_ROLE_KEY!
)

async function main() {
  const { data, error } = await supabase
    .from('courses')
    .update({ price_cents: 99700 })
    .eq('slug', 'my-course')
    .select()
    .single()

  if (error) throw error
  console.log('✅ Updated:', data.title)
}

main()
```

```bash
npx tsx scripts/update-thing.ts
```

---

## Decision Tree for Claude

```
User wants database change?
│
├─ Is it a CRUD operation on existing data?
│  └─ YES → Use Server Actions
│     └─ Import action, call it, confirm result
│
├─ Is it a schema change (new table, column)?
│  └─ YES → Use Migration Script
│     └─ Create .sql file, run via db-admin.ts
│
├─ Is it seeding/bulk data?
│  └─ YES → Use Seed Script
│     └─ npx tsx scripts/db-admin.ts seed <type>
│
└─ Is it a one-off complex operation?
   └─ YES → Create and run custom script
```

---

## Common Operations Reference

### Add Record
```typescript
await supabase.from('table').insert({ ...data }).select().single()
```

### Update Record
```typescript
await supabase.from('table').update({ ...data }).eq('id', id).select().single()
```

### Delete Record
```typescript
await supabase.from('table').delete().eq('id', id)
```

### Upsert (Insert or Update)
```typescript
await supabase.from('table').upsert(data, { onConflict: 'unique_column' })
```

### Get with Count
```typescript
const { count } = await supabase.from('table').select('*', { count: 'exact', head: true })
```

---

## Project-Specific Configurations

### FitLabs (fitlabs.app)
```
actions/         → src/lib/actions/
migrations/      → packages/database/migrations/
admin script/    → scripts/db-admin.ts
```

**Tables:**
- health_records, blood_sugar_logs
- stretching_exercises, stretching_routines, stretching_logs
- custom_foods, hydration_logs
- recipes, meal_plans
- workouts, meals, user_metrics

### TravisEric.com (courses)
```
actions/         → src/lib/actions/
migrations/      → supabase/migrations/
```

**Tables:**
- courses, lessons, enrollments
- users, profiles

---

## Security Notes

1. **Service Role Key** bypasses RLS - use only in server-side code
2. **Never expose** service role key to client
3. **Server Actions** run on server (secure)
4. **Scripts** run locally (secure)

---

## Troubleshooting

### "Permission denied"
→ Check RLS policies or use service role key

### "Table doesn't exist"
→ Run migration: `npx tsx scripts/db-admin.ts migrate <file>`

### "Column doesn't exist"
→ Check migration was run, or add column via migration

### "Service role key not found"
→ Add SUPABASE_SERVICE_ROLE_KEY to .env.local

---

## Claude's Checklist Before Database Operations

- [ ] Do server actions exist for this operation?
- [ ] If not, should I create them?
- [ ] Is this a schema change requiring migration?
- [ ] Do I have access to service role key?
- [ ] What's the right method for this operation?
- [ ] How will I confirm success to the user?

---

## Example Full Workflow

```
USER: "Add a new stretching exercise called Piriformis Stretch"

CLAUDE: "I'll add that exercise now."

*Checks: Server actions exist ✓*
*Runs:*

import { createStretchingExercise } from '@/lib/actions/stretching'

const result = await createStretchingExercise({
  name: 'Piriformis Stretch',
  description: 'Deep glute stretch targeting the piriformis muscle',
  target_muscles: ['piriformis', 'glutes'],
  duration_seconds: 30,
  difficulty: 'beginner',
  category: 'static',
  instructions: [
    'Lie on your back with knees bent',
    'Cross right ankle over left knee',
    'Pull left thigh toward chest',
    'Hold 30 seconds, switch sides'
  ],
  benefits: ['Relieves sciatic pain', 'Improves hip mobility'],
  is_public: true
})

CLAUDE: "✅ Added!
         Exercise: Piriformis Stretch
         Duration: 30 seconds
         Difficulty: Beginner
         Targets: Piriformis, Glutes
         Available in stretching library now."
```

---

## Summary

| Situation | Method | Command |
|-----------|--------|---------|
| CRUD on data | Server Action | `await action(...)` |
| New table | Migration | `npx tsx scripts/db-admin.ts migrate` |
| Seed data | Seed Script | `npx tsx scripts/db-admin.ts seed` |
| Health check | Admin Script | `npx tsx scripts/db-admin.ts health` |
| One-off update | Custom Script | `npx tsx scripts/update-thing.ts` |

**Never ask users to run SQL manually. Execute it yourself.**

---

## Templates (Copy These to Projects)

Located in `D:\Travis Eric\TE Code\.claude\templates\`:

| Template | Copy To | Use For |
|----------|---------|---------|
| `server-action.ts` | `src/lib/actions/{feature}.ts` | New server actions |
| `migration.sql` | `migrations/NNNN_feature.sql` | New database tables |

Copy and customize these when creating new features.
