# Spatie Laravel & PHP Guidelines - LLM Ready Reference

## Core Philosophy
- **Follow Laravel's intended patterns** - If Laravel has a documented way, use it. Only deviate with clear justification.
- **Code style** - Follow PSR-1, PSR-2, and PSR-12
- **String conventions** - Non-public strings use camelCase

## PHP Type System

### Type Declarations
```php
// ✅ GOOD: Use short nullable notation
public ?string $variable;

// ❌ BAD: Union with null
public string | null $variable;
```

### Void Returns
```php
// ✅ GOOD: Explicitly declare void returns
public function scopeArchived(Builder $query): void
{
    $query->...
}
```

### Typed Properties
```php
// ✅ GOOD: Always type properties when possible
class Foo
{
    public string $bar;
}

// ❌ BAD: Using docblocks for types
class Foo
{
    /** @var string */
    public $bar;
}
```

### Enums
```php
// ✅ GOOD: PascalCase for enum values
enum Suit
{
    case Clubs;
    case Diamonds;
    case Hearts;
    case Spades;
}
```

## Documentation Standards

### Docblocks Rules
1. **Skip docblocks for fully type-hinted methods** unless description adds value
2. **Use full sentences** for descriptions, including periods
3. **Import all classnames** in docblocks
4. **Single-line format** when possible
5. **Most common type first** in union types

```php
// ✅ GOOD: Clean, no redundant docblock
class Url
{
    public static function fromString(string $url): Url
    {
        // ...
    }
}

// ❌ BAD: Redundant docblock
/**
 * Create a url from a string.
 *
 * @param string $url
 * @return \Spatie\Url\Url
 */
public static function fromString(string $url): Url
```

### Iterables Documentation
```php
// ✅ GOOD: Specify key and value types
/**
 * @param array<int, MyObject> $myArray
 * @return \Illuminate\Support\Collection<int, SomeObject>
 */
function someFunction(array $myArray): Collection
```

```php
// ✅ GOOD: Fixed keys notation
/**
 * @return array{first: SomeClass, second: SomeClass}
 */
function someFunction(): array
```

## Constructor Property Promotion
```php
// ✅ GOOD: Each property on its own line, trailing comma
class MyClass
{
    public function __construct(
        protected string $firstArgument,
        protected string $secondArgument,
    ) {}
}
```

## Traits
```php
// ✅ GOOD: Each trait on its own line
class MyClass
{
    use TraitA;
    use TraitB;
}

// ❌ BAD: Multiple traits on one line
class MyClass
{
    use TraitA, TraitB;
}
```

## String Handling
```php
// ✅ GOOD: String interpolation
$greeting = "Hi, I am {$name}.";

// ❌ BAD: Concatenation
$greeting = 'Hi, I am ' . $name . '.';
```

## Control Structures

### If Statements
```php
// ✅ GOOD: Always use curly brackets
if ($condition) {
    // ...
}

// ❌ BAD: No brackets
if ($condition) ...
```

### Happy Path Pattern
```php
// ✅ GOOD: Unhappy path first, early returns
if (! $goodCondition) {
    throw new Exception;
}

// Happy path unindented
// do work
```

### Avoid Else
```php
// ✅ GOOD: Early returns instead of else
if (! $conditionA) {
    return;
}

if (! $conditionB) {
    return;
}

// Both conditions passed

// ❌ BAD: Nested if/else
if ($conditionA) {
    if ($conditionB) {
        // Both passed
    } else {
        // A passed, B failed
    }
} else {
    // A failed
}
```

### Compound Conditions
```php
// ✅ GOOD: Separate if statements for debugging
if (! $conditionA) {
    return;
}

if (! $conditionB) {
    return;
}

// ❌ BAD: Compound condition
if ($conditionA && $conditionB && $conditionC) {
    // do stuff
}
```

## Comments
- **Avoid comments** by writing expressive code
- **Space before single-line comments**
- **Consider refactoring** comments into method names

```php
// ✅ GOOD: Expressive method name
$this->calculateLoans();

// ❌ BAD: Comment explaining code
// Start calculating loans
```

## Whitespace
- **Add blank lines between statements** for readability
- **No extra empty lines between brackets**

```php
// ✅ GOOD: Statements can breathe
public function getPage($url)
{
    $page = $this->pages()->where('slug', $url)->first();
    
    if (! $page) {
        return null;
    }
    
    if ($page['private'] && ! Auth::check()) {
        return null;
    }
    
    return $page;
}
```

## Laravel-Specific Conventions

### Configuration
- **File names**: kebab-case (`pdf-generator.php`)
- **Config keys**: snake_case (`chrome_path`)
- **Avoid env() outside config files**
- **Use services.php** for service-specific configs

```php
// ✅ GOOD: In config/pdf-generator.php
return [
    'chrome_path' => env('CHROME_PATH'),
];

// ✅ GOOD: Service config in services.php
return [
    'github' => [
        'token' => env('GITHUB_TOKEN'),
    ],
];
```

### Artisan Commands
- **Command names**: kebab-case (`delete-old-records`)
- **Always provide feedback**
- **Show progress for loops**
- **Summary at the end**

```php
public function handle()
{
    $this->comment("Start processing items...");
    
    $items->each(function(Item $item) {
        $this->info("Processing item id `{$item->id}`...");
        $this->processItem($item);
    });
    
    $this->comment("Processed {$items->count()} items.");
}
```

### Routing
- **URLs**: kebab-case (`/open-source`)
- **Route names**: camelCase (`openSource`)
- **Use tuple notation** for controllers
- **HTTP verb first** in route definitions
- **Parameters**: camelCase

```php
// ✅ GOOD
Route::get('open-source', [OpenSourceController::class, 'index'])
    ->name('openSource');

Route::get('news/{newsItem}', [NewsItemsController::class, 'index']);

// ❌ BAD
Route::get('/open-source', 'OpenSourceController@index')
    ->name('open-source');
```

### API Routing
- **Plural resource names** (`/errors`)
- **kebab-case** for multi-word resources (`/error-occurrences`)
- **Limit deep nesting** (prefer `/error-occurrences/1` over `/projects/1/errors/1/error-occurrences/1`)

### Controllers
- **Plural resource names** (`PostsController`)
- **Stick to CRUD methods** (index, create, store, show, edit, update, destroy)
- **Extract new controllers** for non-CRUD actions

```php
// ✅ GOOD: Separate controller for favorites
class FavoritePostsController
{
    public function store(Post $post) { }
    public function destroy(Post $post) { }
}

// ❌ BAD: Non-CRUD methods in resource controller
class PostsController
{
    public function favorite(Post $post) { }
    public function unfavorite(Post $post) { }
}
```

### Views
- **File names**: camelCase (`openSource.blade.php`)

```php
// ✅ GOOD
return view('openSource');
```

### Validation
- **Use array notation** for multiple rules
- **Custom rules**: snake_case

```php
// ✅ GOOD: Array notation
public function rules()
{
    return [
        'email' => ['required', 'email'],
    ];
}

// ✅ GOOD: Snake case custom rule
Validator::extend('organisation_type', function ($attribute, $value) {
    return OrganisationType::isValid($value);
});
```

### Blade Templates
- **Four spaces** for indentation
- **No spaces after control structures**

```blade
{{-- ✅ GOOD --}}
@if($condition)
    Something
@endif

{{-- ❌ BAD --}}
@if ($condition)
  Something
@endif
```

### Authorization
- **Policies**: camelCase (`editPost`)
- **Use CRUD words** (view instead of show for user-facing)

```php
Gate::define('editPost', function ($user, $post) {
    return $user->id == $post->user_id;
});
```

### Translations
- **Use `__()` function** over `@lang`

```blade
<h2>{{ __('newsletter.form.title') }}</h2>
{!! __('newsletter.form.description') !!}
```

## Naming Conventions

### Class Naming Patterns

| Type | Pattern | Example |
|------|---------|---------|
| **Controllers** | Plural resource + Controller | `UsersController` |
| **Single action controllers** | Action + Controller | `PerformCleanupController` |
| **Resources/Transformers** | Plural + Resource/Transformer | `UsersResource` |
| **Jobs** | Action verb | `CreateUser`, `PerformDatabaseCleanup` |
| **Events** | Present/past tense | `ApprovingLoan`, `LoanApproved` |
| **Listeners** | Action + Listener | `SendInvitationMailListener` |
| **Commands** | Action + Command | `PublishScheduledPostsCommand` |
| **Mailables** | Description + Mail | `AccountActivatedMail` |
| **Enums** | No suffix needed | `OrderStatus`, `BookingType` |

## Final Notes
- **No `final` keyword** by default
- **Expressive code over comments**
- **Consistency over personal preference**
- **Laravel conventions over generic PHP patterns**