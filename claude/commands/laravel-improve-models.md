# Laravel Model Improvement

Apply "fat models, skinny controllers" principle, extract query logic to scopes and query builders, implement proper relationships, and optimize model structure following Laravel best practices.

## Instructions

Improve Laravel model structure and functionality: **$ARGUMENTS**

**Flags:**
- `--relationships`: Optimize model relationships and eager loading
- `--scopes`: Extract query logic to scopes and query builders
- `--accessors`: Implement accessors, mutators, and attribute casting
- `--mass-assignment`: Review and secure mass assignment properties
- `--events`: Implement model events and observers

1. **Model Architecture Assessment**
   ```markdown
   ## Model Structure Analysis
   
   ### Current State Evaluation
   - **Model Responsibilities**: Identify models with mixed concerns
   - **Query Logic**: Locate complex queries in controllers/services
   - **Relationship Optimization**: Review relationship definitions and usage
   - **Data Access Patterns**: Analyze how model data is accessed and modified
   - **Security Concerns**: Check mass assignment and data protection
   
   ### Fat Models vs Skinny Models Balance
   - **Appropriate Fat**: Business logic, data validation, relationships
   - **Inappropriate Fat**: External API calls, file operations, complex workflows
   - **Keep Skinny**: Presentation logic, HTTP concerns, framework-specific code
   ```

2. **Relationship Optimization and Implementation**
   ```markdown
   ## Model Relationship Enhancement
   
   ### Proper Relationship Definitions
   #### One-to-Many Relationships
   ```php
   <?php
   
   namespace App\Models;
   
   use Illuminate\Database\Eloquent\Model;
   use Illuminate\Database\Eloquent\Relations\HasMany;
   use Illuminate\Database\Eloquent\Relations\BelongsTo;
   
   class User extends Model
   {
       // Optimized relationship with constraints
       public function posts(): HasMany
       {
           return $this->hasMany(Post::class)
                      ->orderBy('created_at', 'desc');
       }
   
       // Relationship with specific columns
       public function activeOrders(): HasMany
       {
           return $this->hasMany(Order::class)
                      ->where('status', 'active')
                      ->select(['id', 'user_id', 'total', 'status', 'created_at']);
       }
   
       // Conditional relationships
       public function recentPosts(): HasMany
       {
           return $this->posts()
                      ->where('created_at', '>=', now()->subDays(30));
       }
   }
   
   class Post extends Model
   {
       public function author(): BelongsTo
       {
           return $this->belongsTo(User::class, 'user_id')
                      ->select(['id', 'name', 'email']);
       }
   
       public function comments(): HasMany
       {
           return $this->hasMany(Comment::class)
                      ->where('approved', true)
                      ->orderBy('created_at', 'asc');
       }
   }
   ```
   
   #### Many-to-Many Relationships
   ```php
   class User extends Model
   {
       // Many-to-many with pivot data
       public function roles(): BelongsToMany
       {
           return $this->belongsToMany(Role::class)
                      ->withPivot(['assigned_at', 'assigned_by'])
                      ->withTimestamps();
       }
   
       // Many-to-many with constraints
       public function activeRoles(): BelongsToMany
       {
           return $this->roles()
                      ->wherePivot('active', true);
       }
   
       // Relationship through pivot model
       public function permissions(): HasManyThrough
       {
           return $this->hasManyThrough(
               Permission::class,
               Role::class,
               'user_id', // Foreign key on roles table
               'role_id', // Foreign key on permissions table
               'id',      // Local key on users table
               'id'       // Local key on roles table
           );
       }
   }
   ```
   
   #### Polymorphic Relationships
   ```php
   class Comment extends Model
   {
       // Polymorphic relationship
       public function commentable(): MorphTo
       {
           return $this->morphTo();
       }
   
       public function author(): BelongsTo
       {
           return $this->belongsTo(User::class, 'user_id');
       }
   }
   
   class Post extends Model
   {
       // Inverse polymorphic
       public function comments(): MorphMany
       {
           return $this->morphMany(Comment::class, 'commentable')
                      ->where('approved', true)
                      ->orderBy('created_at', 'desc');
       }
   }
   ```
   ```

3. **Query Scopes and Query Builder Implementation**
   ```markdown
   ## Advanced Query Scopes
   
   ### Local Scopes for Reusable Queries
   #### Basic and Advanced Scopes
   ```php
   <?php
   
   namespace App\Models;
   
   use Illuminate\Database\Eloquent\Builder;
   use Illuminate\Database\Eloquent\Model;
   use Carbon\Carbon;
   
   class Order extends Model
   {
       // Simple scope
       public function scopeActive(Builder $query): Builder
       {
           return $query->where('status', 'active');
       }
   
       // Parameterized scope
       public function scopeByStatus(Builder $query, string $status): Builder
       {
           return $query->where('status', $status);
       }
   
       // Complex scope with multiple conditions
       public function scopeRecent(Builder $query, int $days = 30): Builder
       {
           return $query->where('created_at', '>=', now()->subDays($days))
                       ->orderBy('created_at', 'desc');
       }
   
       // Scope with relationships
       public function scopeWithCustomer(Builder $query): Builder
       {
           return $query->with(['user:id,name,email']);
       }
   
       // Scope with aggregations
       public function scopeHighValue(Builder $query, float $amount = 1000): Builder
       {
           return $query->where('total', '>=', $amount);
       }
   
       // Date range scope
       public function scopeBetweenDates(
           Builder $query,
           Carbon $startDate,
           Carbon $endDate
       ): Builder {
           return $query->whereBetween('created_at', [$startDate, $endDate]);
       }
   
       // Search scope
       public function scopeSearch(Builder $query, string $term): Builder
       {
           return $query->where(function ($q) use ($term) {
               $q->where('id', 'like', "%{$term}%")
                 ->orWhereHas('user', function ($userQuery) use ($term) {
                     $userQuery->where('name', 'like', "%{$term}%")
                              ->orWhere('email', 'like', "%{$term}%");
                 });
           });
       }
   }
   
   // Usage examples
   $activeOrders = Order::active()->withCustomer()->get();
   $recentHighValue = Order::recent(7)->highValue(500)->get();
   $searchResults = Order::search('john')->byStatus('completed')->get();
   ```
   
   ### Global Scopes for Automatic Constraints
   ```php
   <?php
   
   namespace App\Models\Scopes;
   
   use Illuminate\Database\Eloquent\Builder;
   use Illuminate\Database\Eloquent\Model;
   use Illuminate\Database\Eloquent\Scope;
   
   class ActiveScope implements Scope
   {
       public function apply(Builder $builder, Model $model): void
       {
           $builder->where('active', true);
       }
   }
   
   // In the model
   class Product extends Model
   {
       protected static function booted(): void
       {
           static::addGlobalScope(new ActiveScope);
           
           // Or anonymous global scope
           static::addGlobalScope('published', function (Builder $builder) {
               $builder->where('published_at', '<=', now());
           });
       }
   
       // Remove global scope when needed
       public function scopeWithInactive(Builder $query): Builder
       {
           return $query->withoutGlobalScope(ActiveScope::class);
       }
   }
   ```
   ```

4. **Custom Query Builders**
   ```markdown
   ## Advanced Query Builder Implementation
   
   ### Custom Eloquent Builder
   #### Domain-Specific Query Builder
   ```php
   <?php
   
   namespace App\Models\Builders;
   
   use Illuminate\Database\Eloquent\Builder;
   use Carbon\Carbon;
   
   class OrderBuilder extends Builder
   {
       public function forUser(int $userId): self
       {
           return $this->where('user_id', $userId);
       }
   
       public function completed(): self
       {
           return $this->where('status', 'completed');
       }
   
       public function pending(): self
       {
           return $this->where('status', 'pending');
       }
   
       public function thisMonth(): self
       {
           return $this->whereMonth('created_at', now()->month)
                      ->whereYear('created_at', now()->year);
       }
   
       public function highValue(float $threshold = 1000): self
       {
           return $this->where('total', '>=', $threshold);
       }
   
       public function withFullDetails(): self
       {
           return $this->with([
               'user:id,name,email',
               'items.product:id,name,price',
               'payments:id,order_id,amount,status'
           ]);
       }
   
       public function summarize(): array
       {
           return [
               'total_count' => $this->count(),
               'total_value' => $this->sum('total'),
               'average_value' => $this->avg('total'),
               'max_value' => $this->max('total'),
               'min_value' => $this->min('total'),
           ];
       }
   }
   
   // In the Order model
   class Order extends Model
   {
       public function newEloquentBuilder($query): OrderBuilder
       {
           return new OrderBuilder($query);
       }
   }
   
   // Usage
   $userOrders = Order::forUser(1)->completed()->thisMonth()->get();
   $summary = Order::highValue()->summarize();
   ```
   ```

5. **Accessors, Mutators, and Attribute Casting**
   ```markdown
   ## Data Transformation and Casting
   
   ### Modern Attribute Accessors and Mutators
   #### Attribute Implementation
   ```php
   <?php
   
   namespace App\Models;
   
   use Illuminate\Database\Eloquent\Casts\Attribute;
   use Illuminate\Database\Eloquent\Model;
   use Illuminate\Support\Str;
   
   class User extends Model
   {
       protected $casts = [
           'email_verified_at' => 'datetime',
           'preferences' => 'array',
           'settings' => 'json',
           'is_admin' => 'boolean',
           'balance' => 'decimal:2',
       ];
   
       // Modern accessor/mutator
       protected function name(): Attribute
       {
           return Attribute::make(
               get: fn (string $value) => ucwords($value),
               set: fn (string $value) => strtolower($value),
           );
       }
   
       // Computed attribute
       protected function fullName(): Attribute
       {
           return Attribute::make(
               get: fn () => "{$this->first_name} {$this->last_name}",
           );
       }
   
       // Password hashing
       protected function password(): Attribute
       {
           return Attribute::make(
               set: fn (string $value) => bcrypt($value),
           );
       }
   
       // JSON attribute handling
       protected function preferences(): Attribute
       {
           return Attribute::make(
               get: fn (?string $value) => $value ? json_decode($value, true) : [],
               set: fn (array $value) => json_encode($value),
           );
       }
   
       // Date formatting
       protected function createdAtFormatted(): Attribute
       {
           return Attribute::make(
               get: fn () => $this->created_at?->format('M j, Y'),
           );
       }
   
       // URL generation
       protected function avatarUrl(): Attribute
       {
           return Attribute::make(
               get: fn () => $this->avatar 
                   ? asset("storage/avatars/{$this->avatar}")
                   : asset('images/default-avatar.png'),
           );
       }
   }
   ```
   
   ### Custom Cast Classes
   ```php
   <?php
   
   namespace App\Casts;
   
   use Illuminate\Contracts\Database\Eloquent\CastsAttributes;
   use App\ValueObjects\Money;
   
   class MoneyCast implements CastsAttributes
   {
       public function get($model, string $key, $value, array $attributes): ?Money
       {
           return $value ? new Money($value, $attributes['currency'] ?? 'USD') : null;
       }
   
       public function set($model, string $key, $value, array $attributes): array
       {
           if ($value instanceof Money) {
               return [
                   $key => $value->getAmount(),
                   'currency' => $value->getCurrency(),
               ];
           }
   
           return [$key => $value];
       }
   }
   
   // Usage in model
   class Order extends Model
   {
       protected $casts = [
           'total' => MoneyCast::class,
       ];
   }
   ```
   ```

6. **Mass Assignment Security and Data Protection**
   ```markdown
   ## Mass Assignment Best Practices
   
   ### Secure Mass Assignment Configuration
   #### Fillable and Guarded Properties
   ```php
   <?php
   
   namespace App\Models;
   
   use Illuminate\Database\Eloquent\Model;
   
   class User extends Model
   {
       // Explicitly allow mass assignment for these fields
       protected $fillable = [
           'name',
           'email',
           'password',
           'phone',
           'date_of_birth',
       ];
   
       // Or protect sensitive fields (use one approach, not both)
       protected $guarded = [
           'id',
           'email_verified_at',
           'remember_token',
           'is_admin',
           'created_at',
           'updated_at',
       ];
   
       // Hide sensitive attributes from serialization
       protected $hidden = [
           'password',
           'remember_token',
           'two_factor_recovery_codes',
           'two_factor_secret',
       ];
   
       // Always include these in serialization
       protected $visible = [
           'id',
           'name',
           'email',
           'created_at',
       ];
   
       // Fields that should be cast to dates
       protected $dates = [
           'email_verified_at',
           'last_login_at',
           'password_changed_at',
       ];
   }
   
   class Order extends Model
   {
       protected $fillable = [
           'user_id',
           'status',
           'notes',
           'shipping_address',
           'billing_address',
       ];
   
       // Calculated fields that shouldn't be mass assigned
       protected $guarded = [
           'total',           // Calculated from items
           'tax_amount',      // Calculated
           'discount_amount', // Calculated
           'order_number',    // Auto-generated
       ];
   
       // Method to safely update calculated fields
       public function recalculateTotals(): void
       {
           $this->total = $this->items->sum('total');
           $this->tax_amount = $this->calculateTax();
           $this->discount_amount = $this->calculateDiscount();
           $this->save();
       }
   }
   ```
   ```

7. **Model Events and Observers**
   ```markdown
   ## Model Event Management
   
   ### Model Events Implementation
   #### Event Hooks in Models
   ```php
   <?php
   
   namespace App\Models;
   
   use Illuminate\Database\Eloquent\Model;
   use Illuminate\Support\Str;
   
   class Order extends Model
   {
       protected static function booted(): void
       {
           // Generate order number before creating
           static::creating(function (Order $order) {
               if (!$order->order_number) {
                   $order->order_number = 'ORD-' . strtoupper(Str::random(8));
               }
           });
   
           // Update timestamps and notify
           static::updated(function (Order $order) {
               if ($order->wasChanged('status')) {
                   // Log status change
                   activity()
                       ->performedOn($order)
                       ->log("Order status changed to {$order->status}");
               }
           });
   
           // Clean up related data when deleting
           static::deleting(function (Order $order) {
               // Cancel any pending payments
               $order->payments()->where('status', 'pending')->update([
                   'status' => 'cancelled'
               ]);
           });
       }
   }
   ```
   
   ### Observer Classes for Complex Logic
   ```php
   <?php
   
   namespace App\Observers;
   
   use App\Models\User;
   use App\Services\Notification\NotificationService;
   use App\Services\Analytics\AnalyticsService;
   
   class UserObserver
   {
       public function __construct(
           private NotificationService $notificationService,
           private AnalyticsService $analyticsService
       ) {}
   
       public function created(User $user): void
       {
           // Send welcome email
           $this->notificationService->sendWelcomeEmail($user);
           
           // Track user registration
           $this->analyticsService->track('user_registered', [
               'user_id' => $user->id,
               'source' => request()->get('source', 'direct'),
           ]);
           
           // Create default user profile
           $user->profile()->create([
               'display_name' => $user->name,
               'bio' => '',
               'avatar' => null,
           ]);
       }
   
       public function updated(User $user): void
       {
           // Send email verification if email changed
           if ($user->wasChanged('email')) {
               $user->email_verified_at = null;
               $user->saveQuietly(); // Avoid infinite loop
               
               $user->sendEmailVerificationNotification();
           }
       }
   
       public function deleting(User $user): void
       {
           // Anonymize user data instead of hard delete
           $user->update([
               'name' => 'Deleted User',
               'email' => 'deleted_' . $user->id . '@example.com',
               'password' => null,
           ]);
           
           // Archive user's orders
           $user->orders()->update(['user_id' => null]);
       }
   }
   
   // Register observer in AppServiceProvider
   public function boot(): void
   {
       User::observe(UserObserver::class);
   }
   ```
   ```

8. **Model Performance Optimization**
   ```markdown
   ## Model Performance Enhancement
   
   ### Lazy Loading and Performance
   #### Optimized Model Loading
   ```php
   <?php
   
   namespace App\Models;
   
   use Illuminate\Database\Eloquent\Model;
   
   class User extends Model
   {
       // Define default relationships to always load
       protected $with = ['profile'];
   
       // Relationships that should never be loaded by default
       protected $without = ['orders', 'posts'];
   
       // Optimize relationship queries
       public function orders(): HasMany
       {
           return $this->hasMany(Order::class)
                      ->select(['id', 'user_id', 'total', 'status', 'created_at']);
       }
   
       // Cached relationship
       public function getCachedOrdersAttribute()
       {
           return Cache::remember(
               "user_orders_{$this->id}",
               3600,
               fn() => $this->orders()->get()
           );
       }
   
       // Count relationship without loading
       public function getOrdersCountAttribute(): int
       {
           return $this->orders()->count();
       }
   
       // Efficient existence check
       public function hasOrders(): bool
       {
           return $this->orders()->exists();
       }
   }
   
   class Post extends Model
   {
       // Touch parent timestamps efficiently
       protected $touches = ['user'];
   
       // Define searchable attributes
       public static function search(string $query): Builder
       {
           return static::where('title', 'like', "%{$query}%")
                       ->orWhere('content', 'like', "%{$query}%")
                       ->orWhereHas('tags', function ($q) use ($query) {
                           $q->where('name', 'like', "%{$query}%");
                       });
       }
   }
   ```
   ```

## Usage Examples

```bash
# Optimize relationships in specific model
/laravel-improve-models --relationships app/Models/User.php

# Extract query logic to scopes
/laravel-improve-models --scopes app/Models/Order.php

# Implement accessors and mutators
/laravel-improve-models --accessors app/Models/Product.php

# Review mass assignment security
/laravel-improve-models --mass-assignment app/Models/

# Implement model events and observers
/laravel-improve-models --events app/Models/User.php
```

**Model Improvement Quality Standards:**
- Models should contain business logic appropriate to their domain
- All database queries should use scopes or query builders
- Relationships should be properly defined with appropriate constraints
- Mass assignment should be explicitly controlled with fillable/guarded
- Sensitive data should be hidden from serialization
- Model events should handle cross-cutting concerns
- Performance should be optimized with proper eager loading