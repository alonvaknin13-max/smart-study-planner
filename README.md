# Smart Study Planner

Smart Study Planner is a Flutter mobile application for Android and iOS that turns exams and syllabus materials into actionable daily learning plans.

## Tech stack

- Flutter frontend (Material 3)
- Riverpod state management
- Supabase Auth + Postgres + Storage backend
- OpenAI GPT integration for syllabus topic extraction

## Implemented capabilities

- Google authentication via Supabase OAuth
- Exam creation with target dates
- Syllabus PDF selection + upload to Supabase Storage (`syllabi` bucket)
- AI-driven topic extraction from syllabus text prompt
- Daily study task generation based on exam date
- Task completion tracking with progress analytics
- Interactive multiple-choice quiz flow generated from study tasks

## Folder structure

```text
lib/
  app/
  core/
    config/
    theme/
  features/
    auth/
    exams/
    syllabus/
    planner/
    progress/
    quiz/
test/
```

## Supabase schema

```sql
create table if not exists public.exams (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null default auth.uid(),
  title text not null,
  target_date timestamptz not null,
  syllabus_path text,
  created_at timestamptz not null default now()
);

create table if not exists public.study_tasks (
  id uuid primary key default gen_random_uuid(),
  exam_id uuid not null references public.exams(id) on delete cascade,
  title text not null,
  notes text,
  due_date timestamptz not null,
  is_complete boolean not null default false,
  created_at timestamptz not null default now()
);

alter table public.exams enable row level security;
alter table public.study_tasks enable row level security;

create policy "Users manage own exams"
  on public.exams
  using (auth.uid() = user_id)
  with check (auth.uid() = user_id);

create policy "Users manage own tasks"
  on public.study_tasks
  using (
    exists (
      select 1 from public.exams e where e.id = study_tasks.exam_id and e.user_id = auth.uid()
    )
  )
  with check (
    exists (
      select 1 from public.exams e where e.id = study_tasks.exam_id and e.user_id = auth.uid()
    )
  );
```

## Run locally

1. Install Flutter SDK.
2. Install dependencies:
   ```bash
   flutter pub get
   ```
3. Run on Android/iOS with required secrets:
   ```bash
   flutter run \
     --dart-define=SUPABASE_URL=... \
     --dart-define=SUPABASE_ANON_KEY=... \
     --dart-define=OPENAI_API_KEY=...
   ```

## Notes

- Configure Google provider in Supabase Auth.
- Create a public/private `syllabi` storage bucket according to your policy needs.
- The OpenAI integration is wired for JSON topic extraction and can be extended for richer planning.
